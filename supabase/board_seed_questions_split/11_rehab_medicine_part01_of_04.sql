-- ===============================================================
-- หมอรู้ — Board seed: เวชศาสตร์ฟื้นฟู (rehab_medicine) — part 1/4 (50 MCQs)
-- Safe to paste into Supabase SQL Editor. Re-runnable.
-- ===============================================================

begin;

-- mcq_subjects for this specialty (idempotent)
insert into public.mcq_subjects
  (name, name_th, icon, audience, board_specialty, exam_type, question_count)
values
  ('rehab_clinical_decision', 'เวชศาสตร์ฟื้นฟู · การตัดสินใจทางเวชกรรม', '🩺', 'board', 'rehab_medicine', NULL, 0),
  ('rehab_basic_science', 'เวชศาสตร์ฟื้นฟู · วิทยาศาสตร์การแพทย์พื้นฐาน', '🧬', 'board', 'rehab_medicine', NULL, 0),
  ('rehab_ems_mgmt', 'เวชศาสตร์ฟื้นฟู · การจัดการระบบบริการการแพทย์ฉุกเฉิน', '🚨', 'board', 'rehab_medicine', NULL, 0),
  ('rehab_integrative', 'เวชศาสตร์ฟื้นฟู · ข้อสอบบูรณาการ', '🧩', 'board', 'rehab_medicine', NULL, 0)
on conflict (name) do nothing;

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี post-ischemic stroke right MCA — left hemiparesis + aphasia + dysphagia + 2 weeks post-acute — needs rehab', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Stroke Rehabilitation — Comprehensive Multidisciplinary Care"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Hospice"},{"label":"E","text":"Bedrest"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Stroke Rehabilitation — Comprehensive Multidisciplinary Care: (1) **Stroke unit care**: organized stroke care reduces mortality + disability + dependency (Cochrane); (2) **Multidisciplinary team**: physiatrist (PM&R) + neurology + nursing + PT (gait, balance, motor) + OT (ADLs, fine motor, cognitive) + SLP (speech, language, swallow) + neuropsychology + recreational therapy + social work + dietitian; (3) **Early mobilization**: within 24h if stable (AVERT trial — careful interpretation, but generally early mobilization good); (4) **Specific interventions**: - Motor: task-specific training, repetitive task practice, constraint-induced movement therapy (CIMT) for selected upper limb, mirror therapy, FES (functional electrical stimulation), robotic-assisted, virtual reality; - Aphasia: speech-language therapy (intensity matters), AAC (alternative + augmentative communication), aphasia groups; - Dysphagia: swallowing therapy (effortful swallow, supraglottic swallow), dietary modification (textures + thickeners), eventual return to oral; - Cognitive: attention + memory + executive function training; (5) **Spasticity management**: stretching, splinting, oral antispasticity (baclofen — caution sedation, tizanidine), intrathecal baclofen, botulinum toxin for focal; (6) **Mood + depression**: high prevalence post-stroke, screen, treat (SSRI); psychotherapy; (7) **Secondary prevention**: antiplatelet, anticoagulation if AF, statin, BP control, lifestyle, AF screening; (8) **Driving + return to work** assessment; (9) **Family + caregiver education + support**; (10) **Long-term**: continued OPD therapy + community + home; (11) **Outcomes**: recovery curve over 3-6 mo + beyond; modern: emerging neuroplasticity-based therapies + technology (BCI brain-computer interface)

---

Stroke rehab: multidisciplinary stroke unit care reduces mortality + disability. PT/OT/SLP/neuropsych + family. Motor + aphasia + dysphagia + cognitive interventions. Spasticity + mood management. Secondary prevention. Modern: technology + neuroplasticity-based therapies.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'AHA/ASA Stroke Rehabilitation Guidelines 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี post-ischemic stroke right MCA — left hemiparesis + aphasia + dysphagia + 2 weeks post-acute — needs rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี traumatic SCI T6 ASIA A — paraplegia — 4 weeks post-injury — rehab unit transfer', '[{"label":"A","text":"Bedrest"},{"label":"B","text":"Spinal Cord Injury Rehabilitation"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Spinal Cord Injury Rehabilitation: (1) **Specialized SCI rehab unit**: better outcomes; (2) **Multidisciplinary team**: physiatrist + nursing + PT + OT + recreation + vocational + social work + psychology + urology + sexual health; (3) **Physical training**: strength + endurance + ROM + wheelchair skills + transfers + ADLs + adaptive equipment; (4) **Bowel + bladder management**: - Bladder: intermittent catheterization preferred (lower UTI than indwelling); urodynamics; - Bowel: scheduled program with suppositories/stimulation; (5) **Skin/pressure injury prevention**: pressure relief q15-30 min, special cushions/mattress, daily skin checks, nutrition; (6) **Autonomic dysreflexia** (lesions above T6): elevated BP from noxious stimulus below (full bladder, constipation, etc.); life-threatening; remove stimulus + sit up + treat HTN (NTG, nifedipine); education to patient + family essential; (7) **Spasticity management**: PT + OT, baclofen, tizanidine, intrathecal baclofen pump, botulinum toxin; (8) **Cardiovascular**: orthostatic hypotension common; gradual upright training + abdominal binder + compression + medications; reduced exercise capacity; (9) **Pulmonary** (high SCI especially): respiratory PT, abdominal binder, vaccination; (10) **Sexual + reproductive**: counseling + PDE5i + assisted reproduction options; (11) **Mental health**: depression high, suicide risk, peer support; (12) **Pain management**: neuropathic pain (gabapentin, pregabalin, SNRI, TCA), nociceptive; (13) **Equipment**: wheelchair selection (manual, power), home modifications, vehicle modifications; (14) **Vocational rehab + community reintegration**; (15) **Long-term**: lifelong follow-up — UTI, pressure injuries, depression, sexual + reproductive, secondary medical conditions; (16) **Modern**: emerging — exoskeletons + epidural stimulation + neural prostheses + stem cells (research)

---

SCI rehab: specialized multidisciplinary care. Comprehensive body systems management. Autonomic dysreflexia emergency. Lifelong issues. Modern: emerging technologies (exoskeletons, epidural stim). Patient + family-centered.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'Consortium for Spinal Cord Medicine Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี traumatic SCI T6 ASIA A — paraplegia — 4 weeks post-injury — rehab unit transfer'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 28 ปี post-MVC TBI — moderate (GCS 9, multiple contusions, no surgical lesion) — 6 weeks post-injury, awake but confused + behavioral issues', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Traumatic Brain Injury Rehabilitation"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Hospice"},{"label":"E","text":"Bedrest"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Traumatic Brain Injury Rehabilitation: (1) **Severity classification**: mild (concussion), moderate, severe; this patient moderate; (2) **Multidisciplinary team**: physiatrist + neuropsychology + PT + OT + SLP + neurology + neurosurgery + behavioral health + social work + family; (3) **Rancho Los Amigos cognitive recovery scale** I-VIII: guides intervention by level (e.g., Level IV agitated — environmental + behavioral); (4) **Cognitive rehabilitation**: attention, memory, executive function, processing speed; restorative + compensatory strategies; (5) **Behavioral management**: structured environment, consistent staff, redirection, behavioral plan; psychiatry consult for severe agitation/disinhibition; (6) **Pharmacotherapy**: - Amantadine (DRS — methylphenidate for arousal + attention); - Modafinil for fatigue; - SSRI for depression + emotional lability; - Atypical antipsychotic for severe agitation (cautious); - Anti-epileptics for post-traumatic seizures; - Avoid benzodiazepines + first-gen antipsychotics (cognitive impairment); (7) **Physical rehab**: mobility, balance, motor; (8) **Speech/language**: dysarthria, aphasia, cognitive-communication; (9) **Swallowing**: assessment + therapy if needed; (10) **Vision + vestibular**: post-concussive — VOR + balance therapy; (11) **Sleep disorders**: common — circadian disruption, insomnia, fragmentation; (12) **Mental health**: depression + anxiety + PTSD + substance use; family adjustment; (13) **Return to activity**: gradual + school/work re-integration; (14) **Long-term**: neurodegenerative concerns (CTE in repeated mild — sports + military), cognitive decline, mood, social + vocational; (15) **Family education + support**; (16) **Modern**: emerging biomarkers (NfL, GFAP), pharmacotherapy, neuromodulation

---

TBI rehab: severity-stratified multidisciplinary. Cognitive + behavioral + physical + speech + family. Rancho scale + tailored intervention. Pharmacotherapy + behavioral management. Long-term concerns. Modern: emerging biomarkers + therapeutics + neuromodulation.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'Brain Injury Association; INCOG Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 28 ปี post-MVC TBI — moderate (GCS 9, multiple contusions, no surgical lesion) — 6 weeks post-injury, awake but confused + behavioral issues'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี — post-AKA (above-knee amputation) for PAD complications — 4 weeks post-op + ready for rehab + considering prosthesis', '[{"label":"A","text":"No rehab"},{"label":"B","text":"Prosthetic fitting + training"},{"label":"C","text":"Hospice"},{"label":"D","text":"Discharge"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Amputee Rehabilitation: (1) **Pre-prosthetic phase**: residual limb shaping + maturation (shrinkers + ace wraps), wound care, pain management (phantom limb + residual limb), strengthening (core + remaining limb + UE), cardiovascular conditioning, balance + transfers + mobility with assistive devices; (2) **Pain management**: - Phantom limb pain: mirror therapy, desensitization, mental imagery, TENS, gabapentin/pregabalin, SNRI, opioid sparing; - Residual limb pain: address neuroma (steroid injection, surgery), prosthetic fit; - TMR (targeted muscle reinnervation) emerging — reduces neuroma + improves prosthetic control; - RPNI (regenerative peripheral nerve interface); (3) **Prosthetic prescription**: K-level (functional ambulation potential) — K0 (no ambulation) — K4 (high-level recreation); guides component selection; (4) **Prosthetic fitting + training**: cast/digital scan → socket fabrication → static + dynamic alignment + ambulation training with PT; (5) **Multidisciplinary**: physiatrist + prosthetist + PT + OT + nurse + social work + vascular surgery; (6) **Modern prosthetic technology**: microprocessor knees (C-Leg, Genium, Rheo, Power Knee, etc.), ankle-foot mechanisms, energy-storing feet, myoelectric upper limbs, osseointegration (bone-anchored — selected); (7) **K-level training program**: stand → step → ambulate → advanced activities; (8) **Long-term**: socket adjustments + prosthetic replacement (typically every 3-5 yr); contralateral limb care (high risk in PAD + DM patients); skin care; weight management; (9) **Psychosocial adjustment**: body image, depression common, peer support, vocational; (10) **Return to function**: ADLs, work, recreation, driving; (11) **Modern**: integrated team + advanced technology + emerging neural interfaces

---

Amputee rehab: pre-prosthetic + prosthetic phases. K-level prescription. Multidisciplinary team. Modern prosthetic technology (microprocessor, osseointegration, myoelectric). Phantom limb pain management. Psychosocial adjustment. Long-term limb + prosthesis care.', NULL,
  'medium', 'trauma', 'review',
  'rehab_medicine', 'clinical_decision', 'trauma', 'adult',
  'AAPM&R; VA Amputee Rehab', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี — post-AKA (above-knee amputation) for PAD complications — 4 weeks post-op + ready for rehab + considering prosthesis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 75 ปี post-hip fracture surgery + 5 days post-op — frail + chronic conditions — going to rehab', '[{"label":"A","text":"Bedrest"},{"label":"B","text":"Geriatric Hip Fracture Rehabilitation"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Hospice"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Geriatric Hip Fracture Rehabilitation: (1) **Multidisciplinary team**: physiatrist + geriatrician + ortho + nursing + PT + OT + social work + dietitian + pharmacy + family; (2) **Mobility + weight-bearing per ortho**: typically weight bear as tolerated (WBAT) with appropriate device; early mobilization day 1 (Cochrane evidence — better outcomes); (3) **PT**: gait training, balance, strength, transfers, stair climbing, fall prevention; (4) **OT**: ADLs, home safety assessment, adaptive equipment, energy conservation; (5) **Nutritional optimization**: protein 1.2-1.5 g/kg, oral supplements (Cochrane — reduces complications); (6) **Pain management**: multimodal opioid-sparing (acetaminophen + NSAID cautious + gabapentinoid + regional + nerve block); avoid Beers medications; (7) **Delirium prevention + management**: HELP elements; avoid contributing factors; (8) **Polypharmacy review** + deprescribing (Beers + STOPP/START); (9) **Secondary prevention**: - **Osteoporosis treatment**: bisphosphonate or other (fracture liaison service - reduce subsequent fractures 50%); - **Fall prevention** (CDC STEADI): exercise (Tai Chi, Otago), medication review, vision, home safety; - VTE prophylaxis continued; (10) **Mental health**: depression screening + treatment; (11) **Goals of care discussion**: realistic recovery vs decline; functional goals; (12) **Discharge planning**: home with services vs SNF vs LTC based on function; family + community support; (13) **Long-term follow-up**: orthopedic + primary care + geriatric + bone health; (14) **Outcomes**: 30-50% return to prior function within 1 yr; 20-30% mortality first year; (15) **Modern**: ortho-geriatric co-management + multidisciplinary standardized pathway + secondary fracture prevention

---

Geriatric hip fracture rehab: multidisciplinary + early mobilization + nutritional optimization + delirium prevention + secondary prevention (osteoporosis + falls) + comprehensive medical management. Significant mortality. Modern: ortho-geriatric co-management + standardized pathways.', NULL,
  'medium', 'trauma', 'review',
  'rehab_medicine', 'clinical_decision', 'trauma', 'adult',
  'AAOS Hip Fracture; AGS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 75 ปี post-hip fracture surgery + 5 days post-op — frail + chronic conditions — going to rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี post-MI + CABG — cardiac rehabilitation program — multidisciplinary care', '[{"label":"A","text":"Bedrest"},{"label":"B","text":"Cardiac Rehabilitation (AHA + AACVPR)"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Hospice"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cardiac Rehabilitation (AHA + AACVPR): (1) **Phase I (inpatient)**: early mobilization, education, risk factor introduction; (2) **Phase II (outpatient supervised, 12 wk)**: structured exercise + risk factor modification + education + psychosocial; ECG-monitored; (3) **Phase III (community-based maintenance)**: long-term lifestyle; (4) **Components**: - **Exercise training**: aerobic (treadmill, cycle, walking) + resistance (after RA selected); intensity titrated (60-85% peak HR or RPE); 3-5 times/wk × 30-60 min; - **Risk factor modification**: lipids, BP, DM, weight, smoking cessation, diet (Mediterranean), stress; - **Education**: heart disease, medications, signs/symptoms, when to seek help; - **Psychosocial counseling**: depression + anxiety + stress; - **Vocational + sexual counseling**; (5) **Indications**: post-MI, post-CABG, post-PCI, HF, stable angina, valve surgery, transplant, peripheral vascular; (6) **Benefits** (extensive evidence): - Reduces mortality 20-25%, MI, CV hospitalizations; - Improves exercise capacity, QOL, depression, symptoms; - Cost-effective; (7) **Underutilization** despite Class I recommendation; (8) **Multidisciplinary team**: physiatrist or cardiologist + exercise physiologist + nurse + dietitian + psychologist + pharmacist + social work; (9) **Modern**: home-based, telerehab, technology-enabled (wearables, apps); (10) **Equity** considerations + access

---

Cardiac rehab: Phase I-III. Multimodal exercise + risk factor + education + psychosocial. Reduces mortality 20-25%. Multidisciplinary. Underutilized despite Class I. Modern: home-based + telerehab + technology. Equity considerations.', NULL,
  'easy', 'cardiovascular', 'review',
  'rehab_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'AACVPR; AHA Cardiac Rehab', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี post-MI + CABG — cardiac rehabilitation program — multidisciplinary care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี severe COPD post-exacerbation — pulmonary rehabilitation referral', '[{"label":"A","text":"Bedrest"},{"label":"B","text":"Pulmonary Rehabilitation (ATS/ERS)"},{"label":"C","text":"Hospice"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pulmonary Rehabilitation (ATS/ERS): (1) **Components** (multidisciplinary 6-12 wk supervised): - Exercise training (aerobic + resistance + IMT inspiratory muscle); - Patient education (disease, medications, self-management, inhaler technique, action plan, exacerbation management, nutrition, energy conservation, oxygen, sleep, end-of-life); - Behavioral change (smoking cessation, physical activity); - Psychosocial support (depression + anxiety high in COPD); - Nutritional counseling; (2) **Indications**: COPD (most studied), other chronic respiratory (ILD, asthma, bronchiectasis, post-TB, NMD), post-acute lung injury (ARDS), post-COVID, lung cancer rehab, pre/post lung transplant + LVRS, pre/post lung surgery; (3) **Benefits**: - Reduces dyspnea + improves exercise capacity, QOL, depression, anxiety; - Reduces hospitalization + mortality after exacerbation; - Cost-effective; - Class I recommendation; (4) **Settings**: inpatient (post-acute, deconditioned), outpatient (most), home-based, telerehab; (5) **Multidisciplinary team**: physiatrist or pulmonologist + RT (respiratory) + PT + nurse + dietitian + psychologist + social work; (6) **Outcome measures**: 6MWT (6-minute walk test), CAT (COPD Assessment Test), mMRC dyspnea scale, SGRQ (St George''s Respiratory Questionnaire); (7) **Underutilization despite Class I** — access + awareness + reimbursement challenges; (8) **Modern**: home-based, telerehab, technology-enabled (wearables, apps), post-COVID expansion; (9) **Maintenance** important — benefits decline if not sustained

---

Pulmonary rehab: multimodal multidisciplinary 6-12 wk. Reduces dyspnea + improves QOL + reduces hospitalization + mortality. Class I for COPD + others. Underutilized. Modern: home-based + telerehab + post-COVID expansion. Multidisciplinary team.', NULL,
  'easy', 'respiratory', 'review',
  'rehab_medicine', 'clinical_decision', 'respiratory', 'adult',
  'ATS/ERS Pulmonary Rehab; GOLD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี severe COPD post-exacerbation — pulmonary rehabilitation referral'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี chronic LBP × 8 yr + multiple failed treatments — coming for multidisciplinary pain rehabilitation', '[{"label":"A","text":"Long-term opioid"},{"label":"B","text":"Multidisciplinary Pain Rehabilitation (interdisciplinary intensive program)"},{"label":"C","text":"Surgery only"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multidisciplinary Pain Rehabilitation (interdisciplinary intensive program): (1) **Foundation: biopsychosocial model**; chronic pain = chronic disease requiring comprehensive approach; (2) **Multidisciplinary team**: physiatrist + pain medicine + psychology + PT + OT + nursing + pharmacy + nutrition + social work + vocational + recreation; (3) **Patient selection**: chronic pain (> 3 mo), failed conventional treatment, motivated for change, no untreated severe psychiatric, no high-dose opioid (or willing to taper); (4) **Components** (typically 3-4 wk full-day program): - **Cognitive Behavioral Therapy (CBT) for chronic pain**: cornerstone — challenge maladaptive cognitions + behaviors; - **Activity-based therapy**: graded exposure, paced activity, fear avoidance reduction, functional restoration; - **PT**: aerobic + strengthening + flexibility + posture + body mechanics; - **OT**: ADL adaptation, energy conservation, return to work; - **Education**: pain neuroscience education (modern emphasis), self-management, sleep, nutrition; - **Mindfulness + meditation + relaxation**; - **Medication optimization**: opioid tapering + multimodal; (5) **Outcomes**: improved function + QOL + reduced disability + reduced opioid use + return to work; (6) **Functional goals** rather than pain elimination; (7) **Specific syndromes**: chronic LBP, fibromyalgia, CRPS, headache, neuropathic; (8) **Modern**: opioid epidemic context — multidisciplinary essential alternative; (9) **Insurance + reimbursement** challenges; (10) **Long-term**: maintenance + self-management skills lifelong

---

Multidisciplinary pain rehab: biopsychosocial model + CBT + activity-based + multimodal. Functional goals over pain elimination. Reduces disability + opioid use. Modern: essential opioid epidemic response. Skills + self-management lifelong.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'rehab_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'ACPA; APS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี chronic LBP × 8 yr + multiple failed treatments — coming for multidisciplinary pain rehabilitation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 5 ปี cerebral palsy + spastic diplegia + recent botulinum toxin treatment — comprehensive rehab', '[{"label":"A","text":"Random"},{"label":"B","text":"Pediatric Cerebral Palsy Rehabilitation"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Cerebral Palsy Rehabilitation: (1) **Multidisciplinary team**: pediatric physiatrist + pediatric neurology + ortho + PT + OT + SLP + nutrition + psychology + family; (2) **Gross Motor Function Classification System (GMFCS)** I-V: guides intervention + prognosis; (3) **Treatment approach**: - Goal-directed functional therapy; - Family-centered care; - Lifespan approach; (4) **Spasticity management**: - Stretching + positioning + bracing; - Oral antispasticity (limited efficacy + side effects — diazepam, baclofen, tizanidine, dantrolene); - **Focal**: botulinum toxin (BTX-A, BTX-B) injection — first-line for focal spasticity in CP; quadrennial injections; - **Systemic**: intrathecal baclofen pump for severe; - **Selective dorsal rhizotomy (SDR)**: neurosurgical for selected; reduces spasticity permanently; - **Tendon transfers + lengthening + bony procedures** (single-event multi-level surgery — SEMLS); (5) **PT**: motor function, gait, balance, strength; (6) **OT**: ADLs, fine motor, adaptive equipment; (7) **SLP**: communication (verbal + AAC), feeding/swallowing; (8) **Equipment**: orthoses (AFO), walkers, wheelchairs, adaptive seating; (9) **Pain management**: hip pain (subluxation/dislocation), spasticity, scoliosis; (10) **Comorbidities**: epilepsy, intellectual disability, vision (CVI), hearing, GI, hip dysplasia, scoliosis, growth + nutrition + bone health; (11) **Education**: appropriate school placement + IEP; (12) **Transition planning**: adolescence + adulthood healthcare + vocational; (13) **Family support + caregiver education**: respite care + community resources; (14) **Modern**: emerging — stem cells (research), neurorehabilitation, technology, bracing + selective surgery + targeted spasticity therapy

---

Pediatric CP rehab: lifespan + family-centered + multidisciplinary. GMFCS guides. Goal-directed functional therapy. Spasticity management (BTX, ITB, SDR, surgery). PT/OT/SLP + equipment + education + transition. Comorbidities management. Modern: integrated comprehensive care.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'peds',
  'AACPDM; AAP CP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'เด็กชายอายุ 5 ปี cerebral palsy + spastic diplegia + recent botulinum toxin treatment — comprehensive rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี athlete with ACL reconstruction 6 wk ago — sports rehabilitation + return-to-play', '[{"label":"A","text":"Bedrest"},{"label":"B","text":"Sports Rehabilitation + Return-to-Play (RTP)"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Hospice"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Sports Rehabilitation + Return-to-Play (RTP): (1) **Multidisciplinary**: sports physician + physiatrist + orthopedic surgeon + PT + athletic trainer + strength coach + nutritionist + sports psychologist; (2) **Phased rehabilitation**: - **Phase I (acute)**: control inflammation + protect; ROM + isometrics; - **Phase II (mid)**: progressive ROM + strengthening; weight-bearing progression; - **Phase III (late)**: dynamic strengthening + neuromuscular control + proprioception + endurance; - **Phase IV (return-to-sport)**: sport-specific drills + agility + plyometrics + sport-specific testing; (3) **Specific to ACL**: 6-9 mo for safe RTP (sometimes longer); functional + biomechanical testing (single-leg hop, Y-balance, isokinetic quadriceps, etc.); psychological readiness (ACL-RSI score); (4) **Re-injury prevention**: neuromuscular training programs (FIFA 11+, ACL Injury Prevention) — evidence-based; female athletes higher ACL risk; (5) **Other common sports injuries**: concussion (gradual RTP per SCAT5), shoulder (rotator cuff, instability), ankle sprains, hamstring strains, stress fractures, overuse injuries; (6) **Performance + nutrition**: macronutrients + hydration + supplements (caution); recovery (sleep, modalities, active recovery); (7) **Doping awareness + education**: WADA prohibited list; (8) **Pediatric athlete special considerations**: growth plates, overuse syndromes, female athlete triad/REDS; (9) **Sports psychology**: motivation, anxiety, recovery, identity, pressure; (10) **Modern**: data-driven RTP + biomechanical analysis + technology-enabled rehab

---

Sports rehab: phased + multidisciplinary + criteria-based RTP. ACL: 6-9 mo with functional testing. Re-injury prevention (neuromuscular training). Sport-specific considerations. Modern: data-driven + technology-enabled. Multidisciplinary team approach.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'rehab_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AOSSM; AMSSM; ACSM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี athlete with ACL reconstruction 6 wk ago — sports rehabilitation + return-to-play'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี — extensive burns 30% TBSA + post-acute — comprehensive burn rehab', '[{"label":"A","text":"Bedrest"},{"label":"B","text":"Wound care + skin grafting"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Hospice"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Burn Rehabilitation: (1) **Multidisciplinary team**: physiatrist + burn surgeon + plastic surgery + PT + OT + nursing + nutrition + psychology + social work; (2) **Phases**: acute → intermediate → long-term + reconstructive; (3) **Wound care + skin grafting**: ongoing dressing changes, graft care, scar management; (4) **Range of motion + positioning**: prevent contracture (most common complication) — positioning + splinting + stretching; (5) **Strengthening + endurance**: gradually progressive; (6) **Hypertrophic scarring management**: pressure garments (12-23 mmHg, 23+ hr/d × months), silicone gel sheets, massage, laser, intralesional steroid, surgical revision; (7) **Pruritus management**: antihistamines, gabapentin, moisturizers, topicals; (8) **Pain management**: multimodal — opioid + adjuvants + non-pharm (distraction, virtual reality, music); (9) **Nutrition**: hypermetabolic state — high calorie + protein; vitamins; (10) **Psychological + psychosocial**: body image, PTSD, depression, anxiety; CBT; peer support; (11) **Vocational + community reintegration**; (12) **Reconstructive surgery**: timed for contractures, function, aesthetics; (13) **Pediatric considerations**: growth + development + long-term scar evolution; (14) **Family support**; (15) **Modern**: emerging technologies — biological skin substitutes (Integra, AlloDerm), spray-on skin (ReCell), virtual reality pain control

---

Burn rehab: multidisciplinary phased. Contracture prevention + scar management + nutrition + psychological + reconstructive. Modern: biological substitutes + technology pain control. Comprehensive lifelong.', NULL,
  'medium', 'trauma', 'review',
  'rehab_medicine', 'clinical_decision', 'trauma', 'adult',
  'ABA; ISBI Burn Rehab', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี — extensive burns 30% TBSA + post-acute — comprehensive burn rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี chronic vertigo + dizziness × 3 months — vestibular rehabilitation', '[{"label":"A","text":"Bedrest"},{"label":"B","text":"Vestibular Rehabilitation"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Hospice"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Vestibular Rehabilitation: (1) **Common causes**: BPPV (most common), vestibular neuritis/labyrinthitis, Meniere''s, vestibular migraine, central vestibular disorders, age-related, MS; (2) **Comprehensive vestibular assessment**: history + bedside (Dix-Hallpike, head impulse, vHIT, dynamic visual acuity, postural stability), specialized (VNG, rotary chair, posturography, fukuda); (3) **BPPV treatment**: canalith repositioning maneuvers (Epley for posterior canal, BBQ roll for lateral) — highly effective; brandt-daroff exercises for self-treatment; (4) **Vestibular adaptation exercises**: gaze stabilization (VOR adaptation), habituation, balance training, gait training; (5) **Vestibular substitution**: visual + somatosensory training; (6) **Pharmacotherapy** (acute symptoms only — avoid long-term — inhibits compensation): - Antihistamines (meclizine — short-term, avoid in elderly); - Antiemetics (ondansetron, promethazine); - Benzodiazepines (short-term, sparingly); (7) **Central causes**: migraine treatment, MS management, etc.; (8) **Multidisciplinary**: physiatrist + neurology + ENT + audiology + PT specialized in vestibular; (9) **Fall prevention** in elderly with dizziness; (10) **Modern**: technology-assisted (VR, computerized posturography, mobile apps for home exercises)

---

Vestibular rehab: BPPV (Epley) + vestibular adaptation exercises for compensation. Avoid long-term medications. Multidisciplinary. Modern: technology-assisted. Fall prevention.', NULL,
  'easy', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'APTA Vestibular; ANA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี chronic vertigo + dizziness × 3 months — vestibular rehabilitation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 80 ปี frail + recurrent falls + deconditioning + functional decline — geriatric rehab', '[{"label":"A","text":"Bedrest"},{"label":"B","text":"Comprehensive geriatric assessment"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Hospice"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Geriatric Rehabilitation: (1) **Comprehensive geriatric assessment** + functional + nutritional + cognitive + psychosocial + medications; (2) **5Ms framework**: mind, mobility, medications, multicomplexity, matters most; (3) **Multidisciplinary**: physiatrist + geriatrician + PT + OT + nursing + dietitian + pharmacy + social work + family; (4) **Fall prevention** (CDC STEADI): assess + interventions: - Exercise (Tai Chi, Otago — most evidence); - Medication review (Beers + STOPP); - Vision + hearing + footwear; - Vitamin D; - Home safety; (5) **Functional training**: gait + balance + strength (especially LE) + ADL + IADL; (6) **Sarcopenia + frailty**: nutrition (protein 1.2-1.5 g/kg) + resistance exercise + treat underlying; (7) **Cognitive intervention**: cognitive training, address dementia if present; (8) **Pain management**: multimodal, avoid Beers; (9) **Nutritional optimization**: oral supplements, micronutrients; (10) **Psychosocial**: depression treatment, social engagement; (11) **Discharge planning**: home with services vs assisted living vs SNF; (12) **Caregiver support + education**; (13) **Goals of care** discussion; (14) **Long-term**: ongoing community-based rehab + chronic disease management; (15) **Modern**: integrated geriatric rehab + technology (sensors, smart homes, fall detection)

---

Geriatric rehab: CGA + 5Ms + multidisciplinary. Fall prevention + functional + sarcopenia + cognitive + pain. Family + goals of care. Modern: integrated + technology. Lifelong chronic disease management.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'rehab_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AGS; AAPM&R Geriatric', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 80 ปี frail + recurrent falls + deconditioning + functional decline — geriatric rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี post-severe COVID-19 + long COVID + chronic fatigue + dyspnea + cognitive — comprehensive rehab', '[{"label":"A","text":"Bedrest"},{"label":"B","text":"Long COVID / Post-Acute COVID Rehabilitation"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Hospice"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Long COVID / Post-Acute COVID Rehabilitation: (1) **Multidisciplinary**: physiatrist + pulmonology + neurology + cardiology + ID + PT + OT + SLP + behavioral health + nutrition + occupational; (2) **Comprehensive assessment**: organ-system involvement (pulmonary, cardiac, neurological, GI, MSK, dermatologic, psychiatric); fatigue, dyspnea, cognitive ("brain fog"), POTS-like symptoms; (3) **Pulmonary rehab** modeled — graduated exercise + breathing exercises (consider pacing in post-exertional malaise — avoid graded exercise that worsens — controversial); (4) **Cognitive rehabilitation**: attention, memory, executive function strategies; (5) **Cardiac evaluation**: rule out myocarditis + arrhythmia; consider POTS workup (tilt table, autonomic testing); (6) **Sleep**: address; (7) **Mental health**: depression, anxiety, PTSD common; CBT; medication; (8) **Pacing + energy conservation**: especially with PEM (post-exertional malaise); (9) **Nutrition + hydration**; (10) **Vaccination**: recommended; (11) **Multidisciplinary clinics** emerging: post-COVID centers; (12) **Research evolving**: emerging treatments (anticoagulation trials, antivirals, immunomodulators) — not yet established; (13) **Patient + family education**: validation, expectations, peer support; (14) **Vocational support**: accommodation, gradual return; (15) **Modern**: rapidly evolving field with growing understanding

---

Long COVID rehab: multidisciplinary multi-organ. Pulmonary + cognitive + cardiac evaluation + mental health + pacing + energy conservation. Post-COVID centers emerging. Modern: rapidly evolving field.', NULL,
  'medium', 'respiratory', 'review',
  'rehab_medicine', 'clinical_decision', 'respiratory', 'adult',
  'AAPM&R Long COVID; CDC', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี post-severe COVID-19 + long COVID + chronic fatigue + dyspnea + cognitive — comprehensive rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี + post-radius distal fracture + ORIF — hand therapy + functional restoration', '[{"label":"A","text":"Bedrest"},{"label":"B","text":"Specific tendon protocols"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Hospice"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hand Therapy: (1) **Multidisciplinary**: physiatrist + hand surgeon + Certified Hand Therapist (CHT — OT or PT specialized); (2) **Phased rehab**: - Acute: edema control, splinting, gentle ROM; - Intermediate: progressive ROM, scar management, gradual strengthening; - Late: full strengthening + endurance + dexterity + return to activity; (3) **Modalities**: cold therapy, paraffin, ultrasound, electrical stimulation; (4) **Splinting**: custom, addresses position + protection + ROM; (5) **Scar management**: massage, silicone, pressure; (6) **Pain management**: multimodal; (7) **Common conditions**: fractures, tendon repairs, nerve injuries, joint replacements, arthritis, CTS, trigger finger, Dupuytren''s, CRPS; (8) **Specific tendon protocols**: e.g., flexor tendon — early protected motion; (9) **Sensory re-education**: post-nerve injury; (10) **CRPS prevention + treatment**: early intervention, edema control, gentle ROM, desensitization; (11) **Return to function/work**: gradual + task-specific; (12) **Ergonomics + adaptive equipment**: for chronic conditions; (13) **Outcomes measurement**: DASH score, grip strength, ROM measurements

---

Hand therapy: specialized + phased + multidisciplinary. CHT certification. Modalities + splinting + scar + pain management. Specific protocols. Sensory re-education + CRPS prevention. Outcomes measurement. Modern: evidence-based hand specialty.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'rehab_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'ASHT; CHT certification', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี + post-radius distal fracture + ORIF — hand therapy + functional restoration'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี — Multiple Sclerosis + relapsing-remitting + chronic fatigue + spasticity + bladder issues — comprehensive rehab', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"MS Rehabilitation"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Hospice"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** MS Rehabilitation: (1) **Multidisciplinary**: physiatrist + neurology + PT + OT + SLP + nursing + urology + social work + psychology + nutrition; (2) **Disease-modifying therapy** (DMT) by neurology — multiple options; (3) **Rehabilitation focus on specific impairments**: - **Fatigue** (most common MS symptom): pacing + energy conservation + exercise (graded — important — improves fatigue); modafinil, amantadine selected; - **Spasticity**: stretching + positioning + oral antispasticity (baclofen, tizanidine, dantrolene), focal botulinum, intrathecal baclofen for severe; - **Bladder dysfunction**: anticholinergics, mirabegron, beta-3 agonist, intermittent catheterization, urology consult; - **Bowel**: scheduled program; - **Gait + balance**: PT, dalfampridine (4-AP) for walking, AFOs, walking aids; - **Cognitive impairment**: cognitive rehabilitation strategies; - **Mood**: depression high prevalence — SSRI + therapy; - **Sexual dysfunction**: PDE5i + counseling; - **Pain**: neuropathic — gabapentinoids, SNRI; - **Vision**: optic neuritis — treat + adaptive; - **Dysphagia**: SLP + dietary modification; (4) **Exercise**: aerobic + resistance + balance — improves multiple symptoms; (5) **Heat sensitivity** (Uhthoff phenomenon): cooling, air conditioning; (6) **Lifestyle**: Mediterranean diet + smoking cessation + vitamin D + sleep; (7) **Pregnancy + family planning**: timing with DMTs + monitoring; (8) **Mental health support**: depression + anxiety; (9) **Vocational + community**: ongoing support; (10) **Modern**: comprehensive integrated multidisciplinary care + emerging neurorestorative therapies

---

MS rehab: multidisciplinary integrative. Multiple symptoms (fatigue, spasticity, bladder/bowel, gait, cognitive, mood, sexual, pain). Symptom-specific interventions + exercise + lifestyle. Modern: emerging neurorestorative + comprehensive care.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'National MS Society; AAN', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี — Multiple Sclerosis + relapsing-remitting + chronic fatigue + spasticity + bladder issues — comprehensive rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี Parkinson disease + bradykinesia + falls — multidisciplinary rehab', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Parkinson Disease Rehabilitation"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Hospice"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Parkinson Disease Rehabilitation: (1) **Multidisciplinary**: physiatrist + neurology + PT + OT + SLP + nutrition + social work + caregiver; (2) **Medical management**: levodopa-carbidopa + adjuvants by neurology; deep brain stimulation (DBS) for advanced + motor fluctuations + dyskinesias; (3) **Exercise** essential: - **LSVT-BIG** (Lee Silverman Voice Treatment BIG — adapted for motor) — large amplitude training; - **PWR! (Parkinson Wellness Recovery)**; - Tai Chi (balance + fall prevention); - Tango + dance; - Aerobic + resistance; - Boxing programs; - Vestibular + balance specific; (4) **Speech therapy**: **LSVT-LOUD** — loud phonation; cognitive-communication; swallowing therapy (dysphagia common); (5) **OT**: ADLs, adaptive equipment, home safety, fall prevention; (6) **Fall prevention**: significant issue — postural instability + freezing; (7) **Dystonia + dyskinesia**: medication optimization, botulinum toxin for focal; (8) **Sleep**: REM behavior disorder, insomnia — clonazepam, melatonin, sleep hygiene; (9) **Cognitive + neuropsychiatric**: depression, anxiety, hallucinations, dementia (late) — manage carefully (avoid antipsychotics that worsen — pimavanserin safer); (10) **Autonomic**: orthostatic hypotension, constipation, urinary, sexual; (11) **Nutrition**: weight, protein timing (interferes with levodopa absorption); (12) **Caregiver support**: education + respite + mental health; (13) **Advance care planning**; (14) **Modern**: precision (PET imaging, biomarkers), new symptomatic + disease-modifying agents (research), DBS technology, focused ultrasound

---

PD rehab: multidisciplinary symptom-based. Exercise (LSVT-BIG, Tai Chi). Speech (LSVT-LOUD) + dysphagia. Fall prevention. Cognitive + neuropsychiatric + autonomic. Caregiver support. Modern: precision + DBS + emerging therapies.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'Movement Disorder Society; AAN PD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี Parkinson disease + bradykinesia + falls — multidisciplinary rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี post-cancer treatment — chronic fatigue + neuropathy + lymphedema + deconditioning — cancer rehabilitation', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Cancer Rehabilitation (CRP — Cancer Rehab Program)"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Hospice"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cancer Rehabilitation (CRP — Cancer Rehab Program): (1) **Multidisciplinary**: physiatrist + oncology + PT + OT + SLP + nutrition + psychology + social work + lymphedema specialist; (2) **Common issues**: fatigue, deconditioning, peripheral neuropathy (chemo-induced), lymphedema, weakness, cognitive impairment ("chemo brain"), pain, body image, depression + anxiety, sexual dysfunction, sleep, mobility, ADL difficulty, vocational; (3) **Cancer-related fatigue**: most common — multimodal exercise (aerobic + resistance) is most evidence-based intervention (Cochrane); modafinil + psychostimulants selected; sleep + mood + nutrition; (4) **Lymphedema management**: - Complex Decongestive Therapy (CDT) — gold standard 4 components: manual lymph drainage (MLD), compression bandaging + garments, exercise, skin care; - Pneumatic compression devices for selected; - Surgical (lymphovenous anastomosis, lymph node transfer, liposuction) — emerging; - Prevention + early intervention key; (5) **CIPN (chemotherapy-induced peripheral neuropathy)**: duloxetine first-line (per ASCO); other gabapentinoids, topical; exercise; balance training; fall prevention; (6) **Functional restoration**: PT + OT + endurance + ADL training; (7) **Cognitive rehabilitation**: strategies + computer-based; (8) **Pain management**: multimodal; (9) **Psychosocial**: counseling + peer support + caregiver; (10) **Vocational + return to work**; (11) **Survivorship care plans**: long-term issues + surveillance; (12) **Palliative integration**: concurrent care; (13) **Modern**: prehabilitation (pre-treatment) + integrated cancer rehab clinics + telerehab

---

Cancer rehab: multidisciplinary survivorship. Fatigue + CIPN + lymphedema + cognitive + functional + psychosocial. CDT for lymphedema. Exercise for fatigue. Duloxetine for CIPN. Modern: integrated programs + prehabilitation + telerehab.', NULL,
  'medium', 'hemato_onco', 'review',
  'rehab_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'AAPM&R Cancer Rehab; ASCO Survivorship', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี post-cancer treatment — chronic fatigue + neuropathy + lymphedema + deconditioning — cancer rehabilitation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี — workplace injury + chronic LBP + unable to return to physically demanding job — vocational rehabilitation + return-to-work', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Vocational Rehabilitation + Return-to-Work (RTW)"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Disability only"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Vocational Rehabilitation + Return-to-Work (RTW): (1) **Multidisciplinary**: physiatrist + occupational medicine + PT + OT + vocational counselor + ergonomist + psychologist + employer + insurance + attorney (workers comp); (2) **Comprehensive functional capacity evaluation (FCE)**: objective measure of work-related abilities vs job demands; (3) **Job demands analysis**: physical + cognitive + environmental requirements; (4) **Work conditioning + work hardening programs**: progressive job-specific tasks + endurance + simulation; (5) **Accommodations**: ADA-compliant + employer collaboration — modified duty, ergonomic adjustments, assistive technology, schedule changes; (6) **Vocational counseling**: career change if cannot return; retraining + education; (7) **Functional restoration**: addresses physical + psychological + behavioral aspects of chronic pain + disability; (8) **Disability evaluation**: temporary vs permanent, partial vs total; AMA Guides to Permanent Impairment; (9) **Psychosocial**: depression + anxiety + fear avoidance + catastrophizing — CBT + behavioral activation; (10) **Pain self-management**: multimodal opioid-sparing; (11) **Stakeholder coordination**: employer + insurance + healthcare + patient + family + legal; (12) **Outcome metrics**: RTW rate + duration + sustainability + recurrence; (13) **Prevention**: workplace ergonomics + safety + early intervention; (14) **Modern**: telework + remote accommodations + technology-enabled work + early intervention + integrated programs

---

Vocational rehab + RTW: multidisciplinary stakeholder coordination. FCE + job analysis + work conditioning + accommodations + vocational counseling. Address psychosocial. Disability evaluation. Modern: remote work + ergonomics + early intervention + integrated.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'rehab_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAPM&R Occupational Med; AMA Guides', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี — workplace injury + chronic LBP + unable to return to physically demanding job — vocational rehabilitation + return-to-work'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 40 ปี — post-mastectomy + lymphedema secondary + early management + prevention', '[{"label":"A","text":"Ignore"},{"label":"B","text":"Lymphedema Management Comprehensive"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Lymphedema Management Comprehensive: (1) **Risk reduction + prevention**: early identification, education, skin care, avoid trauma + IV/BP on affected side (controversial — recent evidence questions strict avoidance), gradual exercise, weight management; (2) **Diagnosis**: clinical (pitting + non-pitting), tape measure + circumferential measurements, BIS (bioimpedance spectroscopy — early detection), perometry, lymphoscintigraphy, MRI lymphangiography; (3) **Stage classification (ISL)**: 0 (subclinical), 1 (early, pitting), 2 (non-pitting, fibrosis), 3 (elephantiasis); (4) **Complex Decongestive Therapy (CDT) — gold standard**: 4 components — - **Manual Lymphatic Drainage (MLD)**: specialized massage to redirect lymph flow; - **Compression bandaging (intensive phase)** → custom compression garments (maintenance); - **Exercise** with compression to enhance pumping; - **Skin care**: prevent infection (cellulitis); (5) **Adjuncts**: pneumatic compression devices, kinesiotape, low-level laser, BIS-guided early intervention (PREVENT trial — early identification + Rx prevents progression); (6) **Pharmacologic**: limited role; (7) **Surgical** for selected refractory: - Microsurgical — lymphovenous anastomosis (LVA), vascularized lymph node transfer (VLNT); - Excisional — suction-assisted lipectomy/liposuction; - Emerging: combined approaches; (8) **Infection prevention + management**: cellulitis high risk — early antibiotic, repeat episodes — prophylactic antibiotic; (9) **Education + self-management**: lifelong; (10) **Psychosocial support**; (11) **Multidisciplinary**: certified lymphedema therapist (CLT) + physiatrist + surgeon + dermatology + breast/cancer team; (12) **Modern**: early identification programs + microsurgical advances + integrated rehab

---

Lymphedema: CDT gold standard. Early identification (BIS, PREVENT trial) reduces progression. Microsurgical options for refractory. Infection prevention. Lifelong self-management. Multidisciplinary. Modern: integrated + microsurgical advances.', NULL,
  'medium', 'hemato_onco', 'review',
  'rehab_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'ISL Lymphology; NCCN Survivorship', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 40 ปี — post-mastectomy + lymphedema secondary + early management + prevention'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง principles of rehabilitation + ICF model + outcomes', '[{"label":"A","text":"Random"},{"label":"B","text":"Rehabilitation Principles + ICF Model"},{"label":"C","text":"Random"},{"label":"D","text":"No principles"},{"label":"E","text":"Single discipline"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Rehabilitation Principles + ICF Model: (1) **WHO ICF (International Classification of Functioning, Disability, and Health)**: biopsychosocial model — body functions/structures + activities + participation; contextual factors (environmental + personal); replaces older disability models; (2) **Rehab principles**: - Functional focus (activities + participation) over impairment alone; - Person-centered + values-based; - Goal-oriented + measurable; - Time-limited intensive programs; - Team-based + multidisciplinary; - Continuum of care across settings; (3) **Outcome measures**: - Generic: FIM (Functional Independence Measure), Barthel Index, SF-36, EQ-5D; - Condition-specific: NIHSS (stroke), ASIA (SCI), Glasgow Outcome Scale (TBI), DASH (upper limb), Berg Balance, Tinetti, 6MWT; - PROMs (Patient-Reported Outcome Measures): increasing importance; (4) **Levels of evidence + GRADE**; (5) **Rehab settings**: acute inpatient rehab (IRF), subacute (SNF), long-term acute care (LTACH), outpatient, home-based, day program, telerehab; (6) **Adaptive equipment + assistive technology**: wheelchairs, prosthetics, orthotics, ADL aids, communication devices, environmental control; (7) **Disability rights**: Americans with Disabilities Act (ADA), UN Convention on Rights of Persons with Disabilities (CRPD); inclusive society; (8) **Multidisciplinary team dynamics**: communication + coordination + leadership; (9) **Modern**: technology-enabled + neuroplasticity-based + telerehab + AI assistance

---

Rehab principles: WHO ICF biopsychosocial. Functional focus + person-centered + multidisciplinary + outcome-measured. ICF replaces older models. Multiple settings + continuum of care. Disability rights. Modern: technology + neuroplasticity + telerehab.', NULL,
  'easy', 'procedures', 'review',
  'rehab_medicine', 'basic_science', 'procedures', 'adult',
  'WHO ICF; AAPM&R', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Resident ถามเรื่อง principles of rehabilitation + ICF model + outcomes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง neuroplasticity + motor learning + rehabilitation', '[{"label":"A","text":"No plasticity"},{"label":"B","text":"Neuroplasticity + Motor Learning"},{"label":"C","text":"Random"},{"label":"D","text":"Single technique"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neuroplasticity + Motor Learning: (1) **Neuroplasticity**: ability of CNS to reorganize structure + function in response to experience, injury, or therapy; lifelong but variable by age + condition; (2) **Principles of neuroplasticity** (Kleim + Jones 2008): use it or lose it; use it + improve it; specificity; repetition matters; intensity matters; time matters; salience matters; age matters; transference; interference; (3) **Mechanisms**: synaptic changes, LTP/LTD, new neuron generation (limited adult — hippocampus, OB), neural connectivity changes, functional reorganization; (4) **Motor learning stages**: cognitive → associative → autonomous (Fitts + Posner); (5) **Practice principles**: massed vs distributed, blocked vs random, whole vs part, mental practice + imagery; (6) **Feedback**: knowledge of results + performance; intrinsic vs extrinsic; (7) **Specific therapies leveraging neuroplasticity**: - **Constraint-Induced Movement Therapy (CIMT)** for stroke upper limb; - **Task-specific training**; - **Robotic-assisted training**; - **Mirror therapy**; - **Virtual reality / gaming**; - **Brain-computer interfaces (BCI)**; - **Functional electrical stimulation (FES)**; - **Transcranial magnetic stimulation (TMS)** + transcranial direct current stimulation (tDCS) — neuromodulation; - **Exoskeletons**; (8) **Pharmacologic adjuncts** (research): amantadine, modafinil, SSRIs, BDNF modulators; (9) **Critical period + recovery curve**: early intervention important but plasticity continues; (10) **Modern**: neuroplasticity + technology + neuromodulation expanding rehab capabilities

---

Neuroplasticity + motor learning: principles guide rehabilitation. Use-dependent + specific + intense + repetitive + salient. Therapies leveraging plasticity (CIMT, task-specific, robotic, BCI, TMS, FES, exoskeletons). Modern: technology + neuromodulation expanding capabilities.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'basic_science', 'neurology', 'adult',
  'Kleim + Jones 2008; AAPM&R', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Resident ถามเรื่อง neuroplasticity + motor learning + rehabilitation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง pharmacology + medications in rehab', '[{"label":"A","text":"Random"},{"label":"B","text":"Rehabilitation Pharmacology"},{"label":"C","text":"Random"},{"label":"D","text":"Single drug"},{"label":"E","text":"No pharmacology"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Rehabilitation Pharmacology: (1) **Spasticity**: baclofen (oral + intrathecal), tizanidine, dantrolene, diazepam (caution sedation), gabapentin off-label; botulinum toxin (focal), phenol/alcohol neurolysis; (2) **Neuropathic pain**: gabapentin, pregabalin, SNRIs (duloxetine, venlafaxine), TCAs (amitriptyline, nortriptyline), topical lidocaine + capsaicin; opioids minimal long-term; (3) **CRPS**: gabapentin, ketamine (severe), bisphosphonates (selected), sympathetic blocks; (4) **Cognitive enhancement (TBI, stroke)**: amantadine, methylphenidate, modafinil, donepezil; (5) **Mood**: SSRIs/SNRIs for depression + emotional lability; lithium for selected; (6) **Bladder**: anticholinergics (oxybutynin, tolterodine — caution cognitive), mirabegron (beta-3); intermittent catheterization; intravesical botulinum; (7) **Bowel**: bulk + osmotic laxatives, stimulants, suppositories; (8) **Bone health**: bisphosphonates + vitamin D + calcium (immobilization osteopenia); (9) **Autonomic dysreflexia**: short-acting antihypertensive (nitroglycerin, nifedipine) for episodes; (10) **Heterotopic ossification**: bisphosphonates + NSAIDs + RT post-surgery + surgical excision; (11) **Phantom limb pain**: gabapentinoids + mirror therapy; (12) **Sleep**: CBT-I + melatonin + selected hypnotics; avoid long-term benzo; (13) **Fatigue**: modafinil, amantadine in MS + post-stroke + cancer (selected); (14) **MS-specific**: dalfampridine (4-AP) for walking; (15) **PD-specific**: levodopa-carbidopa + adjuncts (MAO-B inhibitors, COMT inhibitors, dopamine agonists, amantadine, anticholinergics — caution elderly); (16) **Caution + interactions** especially in elderly + polypharmacy

---

Rehab pharmacology: spasticity + neuropathic pain + cognitive + mood + bladder/bowel + autonomic + bone + condition-specific. Multi-targeted approach. Caution polypharmacy + elderly. Modern: targeted + multidisciplinary medication management.', NULL,
  'medium', 'procedures', 'review',
  'rehab_medicine', 'basic_science', 'procedures', 'adult',
  'AAPM&R; Kasper Adams Frontera', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Resident ถามเรื่อง pharmacology + medications in rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง orthotics + prosthetics + assistive technology', '[{"label":"A","text":"Random"},{"label":"B","text":"Orthotics + Prosthetics + Assistive Technology"},{"label":"C","text":"Random"},{"label":"D","text":"Single device"},{"label":"E","text":"No use"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Orthotics + Prosthetics + Assistive Technology: (1) **Orthotics** (support + correct + protect existing limb): - AFO (ankle-foot orthosis): post-stroke foot drop, peripheral neuropathy, spasticity; - KAFO (knee-AFO): more proximal weakness; - HKAFO: hip too; - Spinal: TLSO (post-vertebral fracture), Milwaukee brace + Boston brace for scoliosis; - Upper limb: WHO (wrist-hand orthosis), CTS splint; - Custom vs off-the-shelf; - Functional vs stabilization; (2) **Prosthetics** (replace missing limb): - Upper extremity: body-powered, myoelectric, hybrid; advanced — TMR (targeted muscle reinnervation), osseointegration; - Lower extremity: by amputation level (Syme, transtibial — BK, transfemoral — AK, hip disarticulation); - Components: socket, suspension, knee, ankle, foot; - K-level prescription (K0-K4) for functional ambulation potential; (3) **Assistive technology**: - Wheelchairs (manual + power), seating + positioning; - Mobility aids (canes, walkers, crutches); - Adaptive equipment for ADLs (reachers, dressing aids, kitchen tools); - Augmentative + alternative communication (AAC); - Environmental control + smart home; - Computer access (eye gaze, switches); - Robotics + exoskeletons; (4) **Selection process**: multidisciplinary, functional assessment, patient preferences, environment, cost, reimbursement, training; (5) **Multidisciplinary**: physiatrist + prosthetist + orthotist + PT + OT + engineering + patient + family; (6) **Modern**: 3D printing + smart materials + neural interfaces + AI-controlled + telerehab training

---

O&P + AT: orthotics support, prosthetics replace, AT enables function. Multiple types + technology evolving. Selection multidisciplinary + individualized. Modern: 3D printing + smart materials + neural interfaces + AI + telerehab.', NULL,
  'easy', 'procedures', 'review',
  'rehab_medicine', 'basic_science', 'procedures', 'adult',
  'AAOP; RESNA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Resident ถามเรื่อง orthotics + prosthetics + assistive technology'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital implements rehabilitation services + multidisciplinary integrated programs', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Rehabilitation Services Implementation"},{"label":"C","text":"Random"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Rehabilitation Services Implementation: (1) **Levels of care**: inpatient rehabilitation facility (IRF), subacute (SNF), long-term acute care (LTACH), outpatient, home-based, telerehab; (2) **CMS criteria for IRF**: medical necessity + 3 hours of therapy/day 5 d/wk + multidisciplinary team + measurable functional goals + active medical management; (3) **Specialty programs**: stroke, SCI, TBI, amputee, cardiac, pulmonary, cancer, pediatric, vestibular, lymphedema, hand, sports; (4) **Team-based care**: physiatrist + PT + OT + SLP + nursing + psychology + recreation + social work + dietitian + family; (5) **Quality measures**: functional outcomes (FIM, CARE), readmission, discharge to community, length of stay, patient experience; UDSMR (Uniform Data System) data; (6) **Outcomes measurement**: continuous quality improvement, benchmarking; (7) **Patient-Family-Centered Care**: education, training, involvement in care + decisions, support; (8) **Care coordination**: transitions, community resources, follow-up, primary care + specialist; (9) **Equity considerations**: access, language, cultural, disability; (10) **Workforce**: shortages in many specialties; training programs; (11) **Reimbursement**: changing landscape — value-based, episode-based, telerehab coverage expanding; (12) **Modern**: telerehab + technology integration + AI-assisted + outcome-driven + patient-centered

---

Rehab services: continuum of care + specialty programs + multidisciplinary teams + quality measures + outcomes + family-centered + care coordination + equity. Modern: telerehab + technology + value-based + patient-centered.', NULL,
  'easy', 'procedures', 'review',
  'rehab_medicine', 'ems_mgmt', 'procedures', 'adult',
  'AAPM&R; AMRPA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Hospital implements rehabilitation services + multidisciplinary integrated programs'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital implements community-based rehabilitation + disability services + advocacy', '[{"label":"A","text":"Single setting"},{"label":"B","text":"Community-Based Rehabilitation + Disability Services"},{"label":"C","text":"Single setting"},{"label":"D","text":"Random"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Community-Based Rehabilitation + Disability Services: (1) **WHO CBR (Community-Based Rehabilitation)**: rehabilitation + equalization of opportunities + social inclusion at community level; includes — health, education, livelihood, social, empowerment; (2) **Settings**: community centers, schools, workplaces, home; (3) **Multidisciplinary**: rehab professionals + community health workers + educators + employers + family + peer mentors + advocates; (4) **Disability rights**: - ADA (Americans with Disabilities Act) — access + accommodation + employment + transportation + communication; - UN Convention on Rights of Persons with Disabilities (CRPD); - Inclusive society — accessibility + employment + education + healthcare + recreation; (5) **Independent Living Movement**: peer support, consumer-directed, civil rights focus; (6) **Specific services**: - Vocational rehab; - Independent living centers; - Transportation; - Adaptive housing; - Education (IEP, 504); - Support groups + advocacy organizations; - Caregiver support; - Sport + recreation programs (Paralympics); (7) **Universal design** principles: accessible for all; environmental design + products; (8) **Long-term care + chronic disease management**; (9) **Health promotion + wellness** for people with disabilities; (10) **Modern**: technology-enabled independent living + remote care + community integration + telerehab; (11) **Equity + global health**: extending services to underserved populations

---

Community-based rehab + disability services: WHO CBR + ADA/CRPD + Independent Living Movement + universal design + multidisciplinary + community-centered. Modern: technology + global health + equity focus.', NULL,
  'easy', 'procedures', 'review',
  'rehab_medicine', 'ems_mgmt', 'procedures', 'adult',
  'WHO CBR; ADA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Hospital implements community-based rehabilitation + disability services + advocacy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital implements telerehabilitation + digital health + technology in rehab', '[{"label":"A","text":"In-person only"},{"label":"B","text":"Telerehabilitation + Digital Health"},{"label":"C","text":"Random"},{"label":"D","text":"Avoid technology"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Telerehabilitation + Digital Health: (1) **Modalities**: synchronous video (real-time therapy + assessment), asynchronous (exercise apps, education), hybrid models, remote monitoring (wearables, sensors); (2) **Applications**: outpatient therapy continuation, home-based programs, remote consultation, telehealth coaching, post-discharge follow-up, specialty rehab consultation; (3) **Conditions**: stroke, SCI, TBI, cardiac, pulmonary, MSK, pain, mental health, geriatric, pediatric, cancer; (4) **Evidence**: comparable outcomes to in-person for many conditions; improves access especially rural + underserved; (5) **Technology**: video platforms, mobile apps, wearable sensors, virtual reality, AI-coached exercise, robotic-assisted, gaming-based; (6) **Implementation barriers**: technology access + digital literacy (especially elderly, low SES), licensing + reimbursement, privacy + security, internet bandwidth, language; (7) **Quality + best practices**: appropriate visit selection, technology testing, backup plans, training, documentation; (8) **Hybrid care models**: combine telerehab with in-person; (9) **AI applications**: motion analysis, exercise quality monitoring, personalized programs, predictive analytics, virtual coaches; (10) **Equity**: address digital divide; provide alternatives; (11) **Patient engagement**: gamification + interactive content; (12) **Modern**: rapidly evolving + COVID-accelerated + technology integration + AI growing

---

Telerehab + digital health: multiple modalities + applications. Comparable outcomes for many conditions. Expands access. Implementation challenges (digital divide). AI growing. Modern: hybrid + technology-integrated + COVID-accelerated.', NULL,
  'easy', 'procedures', 'review',
  'rehab_medicine', 'ems_mgmt', 'procedures', 'adult',
  'AAPM&R Telerehab; APTA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Hospital implements telerehabilitation + digital health + technology in rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี multimorbid + post-stroke + DM + HF + frailty + cognitive impairment — comprehensive integrative rehab', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Multimorbid Post-Stroke Integrative Rehab"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multimorbid Post-Stroke Integrative Rehab: (1) **Multidisciplinary team**: physiatrist + stroke neurology + cardiology + endocrinology + geriatrics + PT + OT + SLP + nursing + dietitian + psychology + social work + pharmacy + family + caregiver; (2) **Stroke-specific rehab** (motor + speech + cognitive + ADL); (3) **Comorbidity-specific**: - DM: glycemic control + SGLT2 + GLP-1 + dietary + exercise; - HF: GDMT (4 pillars) + lifestyle; - Frailty: nutrition + exercise + multidisciplinary; - Cognitive: assessment + strategies + safety; (4) **Polypharmacy management**: Beers + STOPP/START + deprescribing; (5) **Cardiac rehab integration**: post-stroke patients high CV risk; (6) **Secondary stroke prevention**: antiplatelet + statin + BP + AF screen + lifestyle; (7) **Goals of care + shared decision-making**: realistic functional goals + values + family; (8) **Discharge planning**: home with services vs SNF vs LTC; family + caregiver assessment; (9) **Long-term**: continued therapy + community + medical management; (10) **Mental health**: depression high prevalence post-stroke + chronic illness; (11) **Caregiver burden**: education + support + respite; (12) **Modern**: integrated chronic disease + rehab + family-centered + value-based

---

Multimorbid post-stroke integrative rehab: multidisciplinary + comorbidity-specific + polypharmacy + secondary prevention + goals of care + family. Modern: integrated chronic disease + value-based care.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'integrative', 'neurology', 'adult',
  'AHA/ASA Stroke Rehab; AAPM&R', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี multimorbid + post-stroke + DM + HF + frailty + cognitive impairment — comprehensive integrative rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี SCI + chronic pain + depression + substance use + relationship issues — comprehensive integrative care', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"SCI + Complex Comorbidities Integrative Care"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** SCI + Complex Comorbidities Integrative Care: (1) **Multidisciplinary**: physiatrist + addiction medicine + psychiatry + pain medicine + PT + OT + psychology + social work + sexual health + peer support; (2) **SCI rehab continuation**: bladder/bowel + skin + spasticity + autonomic + mobility + ADLs; (3) **Chronic pain management**: - Multimodal opioid-sparing (gabapentinoids + SNRIs + topical + ketamine + procedures + cannabinoids selected); - CBT for chronic pain; - Mindfulness + meditation; - PT + OT; - Procedures (spinal cord stim selected); (4) **Substance use treatment**: addiction medicine + behavioral; integrated dual diagnosis treatment; medication-assisted treatment if indicated (buprenorphine for OUD); (5) **Depression treatment**: SSRI + CBT + peer support; high prevalence in SCI; suicide risk; (6) **Relationship + family + caregiver**: counseling + education + sexual health + peer support; (7) **Vocational + community reintegration**: vocational rehab + ADA accommodations + return to work/school; (8) **Long-term complications surveillance**: UTI, pressure injury, secondary medical conditions; (9) **Adaptive sports + recreation**: improves mood + function + community; (10) **Goals + values discussion**: patient-centered care + quality of life focus; (11) **Multidisciplinary care coordination**: case manager + medical home; (12) **Modern**: integrated comprehensive care + technology + emerging therapies (exoskeletons, epidural stim research) + advocacy

---

SCI + comorbidities integrative care: multidisciplinary including addiction + psychiatry + pain. Chronic pain multimodal + substance use treatment + depression + family + vocational + adaptive sports. Modern: integrated comprehensive lifelong care.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'integrative', 'neurology', 'adult',
  'Consortium for SCI; AAPM&R', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี SCI + chronic pain + depression + substance use + relationship issues — comprehensive integrative care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี — post-CABG + Parkinson disease + diabetes + osteoporosis + chronic LBP — comprehensive multidisciplinary rehab', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Complex Multimorbid Integrative Rehabilitation"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Complex Multimorbid Integrative Rehabilitation: (1) **Multidisciplinary team**: physiatrist + cardiology + neurology + endocrinology + ortho + PT + OT + SLP + nursing + dietitian + pharmacy + psychology + social work + family + caregiver; (2) **Comprehensive assessment**: medical + functional + cognitive + nutritional + psychosocial + medications + advance care planning + values + goals; (3) **Coordinated care plan**: - **Cardiac rehab post-CABG** (Phase II — supervised exercise, risk factor modification, education, psychosocial); - **PD rehab** (LSVT-BIG + LSVT-LOUD + Tai Chi + fall prevention + medication optimization); - **DM management** (glycemic + SGLT2/GLP-1 + lifestyle + nutrition); - **Osteoporosis** (DEXA + Ca/vit D + bisphosphonate + fall prevention); - **Chronic LBP** (multimodal + opioid-sparing + PT + CBT); (4) **Polypharmacy management**: Beers + STOPP/START + deprescribing + interactions; (5) **Multimodal exercise** addressing multiple conditions simultaneously; (6) **Fall prevention**: comprehensive — multiple risk factors; (7) **Mental health**: depression high prevalence chronic illness + PD; (8) **Nutritional optimization**: protein + Ca + vit D + Mediterranean; (9) **Patient + family education + self-management**; (10) **Goals of care + shared decision-making**: realistic + values-based; (11) **Care coordination**: medical home + transitions; (12) **Modern**: integrated chronic disease + rehab + value-based + technology-enabled + patient + family-centered

---

Complex multimorbid integrative rehab: comprehensive multidisciplinary + coordinated care plan + multimodal exercise + polypharmacy management + mental health + family. Modern: integrated value-based patient-centered chronic disease management.', NULL,
  'hard', 'signs_symptoms', 'review',
  'rehab_medicine', 'integrative', 'signs_symptoms', 'adult',
  'AAPM&R; AGS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี — post-CABG + Parkinson disease + diabetes + osteoporosis + chronic LBP — comprehensive multidisciplinary rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 72 ปี acute ischemic stroke L MCA — R hemiplegia + global aphasia + NIHSS 18 — admit stroke unit day 2 hemodynamically stable', '[{"label":"A","text":"Delay all mobilization 7 days"},{"label":"B","text":"Early Mobilization Protocol (AVERT-informed)"},{"label":"C","text":"tPA repeat dose"},{"label":"D","text":"Surgical decompression"},{"label":"E","text":"Routine MRI daily"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Early Mobilization Protocol (AVERT-informed): (1) **Timing**: เริ่ม out-of-bed activity 24-48 h post-stroke เมื่อ medically stable (BP, neuro stable); (2) **Dose**: short, frequent sessions (AVERT-III: high-dose very early mobilization ภายใน 24h อาจ worse outcome — ต้อง titrate); (3) **Team**: stroke unit nurse + PT + OT + SLP; (4) **Assessment**: NIHSS, mRS, Barthel/FIM baseline, dysphagia screen (water swallow) ก่อนให้กิน, SLP formal evaluation; (5) **Position + skin + DVT prophylaxis** (IPC + LMWH ตามแนวทาง); (6) **Aphasia communication**: yes/no + gesture + AAC + family education; (7) **Goal-setting**: SMART + patient/family-centered; (8) **Documentation**: NIHSS, FIM trajectory; **Modern**: stroke-unit care + early multidisciplinary rehab reduces mortality + dependency (Cochrane)

---

Early mobilization 24-48 h หลัง stable + multidisciplinary stroke unit. AVERT III ระวัง very high dose ต้น 24h. Dysphagia screen ก่อน PO. FIM/NIHSS baseline. Aphasia communication strategies.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'AHA/ASA Stroke Rehab 2016; AVERT trials', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 72 ปี acute ischemic stroke L MCA — R hemiplegia + global aphasia + NIHSS 18 — admit stroke unit day 2 hemodynamically stable'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 58 ปี post-stroke 3 wk — L hemiparesis upper limb >> lower — UE Fugl-Meyer 35/66 — มี selective finger movement', '[{"label":"A","text":"Botulinum toxin only"},{"label":"B","text":"Constraint-Induced Movement Therapy (CIMT)"},{"label":"C","text":"Sling continuously without practice"},{"label":"D","text":"Wait for spontaneous recovery"},{"label":"E","text":"Surgery for tendon transfer now"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Constraint-Induced Movement Therapy (CIMT): (1) **Criteria EXCITE-style**: ≥10° wrist extension + ≥10° finger extension ที่ ≥2 fingers; (2) **Protocol**: mitt/sling ที่ unaffected UE 90% waking hours × 2 wk + intensive shaping/task practice 6 h/day; (3) **Modified CIMT (mCIMT)**: 3 h/day × 10 wk — practical; (4) **Evidence**: improved real-world arm use (Motor Activity Log) + Wolf Motor Function Test; (5) **Adjuncts**: mirror therapy, mental practice, FES (functional electrical stim), robot-assisted (MIT-Manus, Armeo), VR, BCI (research); (6) **Outcome measures**: Fugl-Meyer UE, ARAT, WMFT, MAL; (7) **Team**: OT-led + PT + family; (8) **Selection**: motivation + cognition + caregiver support important; **Modern**: neuroplasticity-based + task-specific high-repetition (Kleim/Jones principles)

---

CIMT criteria: ≥10° active wrist + finger extension. Intensive shaping + restraint of unaffected arm. mCIMT practical. Fugl-Meyer/WMFT/MAL outcomes. Neuroplasticity task-specific practice.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'EXCITE trial; AHA/ASA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 58 ปี post-stroke 3 wk — L hemiparesis upper limb >> lower — UE Fugl-Meyer 35/66 — มี selective finger movement'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย stroke 6 wk — dysphagia confirmed FEES — silent aspiration + delayed pharyngeal trigger — currently NGT', '[{"label":"A","text":"NPO indefinitely"},{"label":"B","text":"Dysphagia Multimodal Therapy"},{"label":"C","text":"Continue thin liquids freely"},{"label":"D","text":"Surgical cricopharyngeal myotomy first-line"},{"label":"E","text":"Tracheostomy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Dysphagia Multimodal Therapy: (1) **Compensatory**: chin tuck, head rotation to weak side, supraglottic + super-supraglottic swallow, effortful swallow, Mendelsohn maneuver; (2) **Diet modification**: IDDSI levels (puree, minced moist, soft) + thickened liquids (mildly/moderately/extremely thick) — note: thickened liquids reduce aspiration แต่เพิ่ม residue/dehydration; (3) **Rehabilitative exercises**: Shaker (head lift), Masako (tongue hold), EMST (expiratory muscle strength training), lingual resistance; (4) **NMES (neuromuscular electrical stim)**: VitalStim — evidence mixed but adjunctive; (5) **Feeding tube**: NGT short-term; PEG ถ้า >4 wk + poor recovery prognosis; (6) **Aspiration pneumonia prevention**: oral hygiene (key!), positioning, monitoring, vaccinations; (7) **Team**: SLP + dietitian + nursing + family + physician; (8) **Re-assessment**: serial FEES/VFSS; **Modern**: instrumental assessment + targeted exercise + oral care bundle

---

Dysphagia: compensatory maneuvers + diet (IDDSI) + rehabilitative exercises (Shaker, EMST). PEG ถ้า prolonged. Oral hygiene สำคัญ aspiration pneumonia. Serial FEES/VFSS. SLP-led team.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'ASHA Dysphagia; IDDSI Framework', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย stroke 6 wk — dysphagia confirmed FEES — silent aspiration + delayed pharyngeal trigger — currently NGT'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย post-stroke 4 mo — L spastic foot drop + equinovarus during gait — MAS knee 2 + ankle 3 — interfere gait', '[{"label":"A","text":"Oral diazepam high dose"},{"label":"B","text":"Focal Spasticity Management — Botulinum Toxin + AFO + PT"},{"label":"C","text":"Bed rest 6 wk"},{"label":"D","text":"Hip replacement"},{"label":"E","text":"Refer hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Focal Spasticity Management — Botulinum Toxin + AFO + PT: (1) **Goal-setting**: GAS (goal attainment scaling), gait, comfort; (2) **BoNT-A injection**: gastrocnemius medial + lateral, soleus, tibialis posterior (equinovarus pattern); typical onabotulinumtoxinA 200-400 U distributed; ultrasound/EMG guidance; (3) **Adjunct**: stretching + serial casting หลัง BoNT (within 2 wk peak effect), strengthening, gait training; (4) **AFO**: rigid vs articulated vs posterior leaf spring ตาม strength/spasticity/gait; functional AFO (ToeOFF) สำหรับ active patients; (5) **Oral antispasticity**: baclofen, tizanidine — systemic SE limit (sedation); (6) **Outcome**: Tardieu, MAS, gait speed (10MWT), 6MWT, PRO; (7) **Re-injection** q3-4 mo; (8) **Refractory**: ITB (intrathecal baclofen), SDR (selective dorsal rhizotomy — peds), orthopedic surgery (tendon transfer/lengthening); **Modern**: US-guided + goal-attainment + integrated rehab

---

Focal spasticity (foot drop, equinovarus): BoNT-A + AFO + PT + stretching/casting. US/EMG-guided. GAS + MAS + gait speed outcomes. Oral antispastic ระวัง sedation. ITB/SDR refractory. Goal-directed.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'AANEM; AAPM&R Spasticity Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย post-stroke 4 mo — L spastic foot drop + equinovarus during gait — MAS knee 2 + ankle 3 — interfere gait'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี post-stroke 2 mo — มี post-stroke depression PHQ-9 16 + cognitive complaints — interferes therapy', '[{"label":"A","text":"Ignore depression — focus PT only"},{"label":"B","text":"Post-Stroke Depression (PSD) Management"},{"label":"C","text":"Benzodiazepine long-term"},{"label":"D","text":"ECT first-line"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-Stroke Depression (PSD) Management: (1) **Prevalence**: ~30% prevalence; under-recognized; impairs rehab participation + outcome + mortality; (2) **Screen**: PHQ-9, HADS, อาจ Stroke Aphasic Depression Questionnaire ถ้า aphasia; (3) **Pharmacotherapy**: SSRI first-line (sertraline, citalopram — caution QTc dose limit, escitalopram); SNRI alternative; avoid TCA (anticholinergic + cardiac); FLAME suggested fluoxetine motor benefit แต่ subsequent (FOCUS/AFFINITY) negative — ไม่ routine fluoxetine for motor; (4) **Psychotherapy**: CBT, problem-solving therapy, motivational interviewing — adapted for cognitive/communication impairment; (5) **rTMS**: emerging for refractory; (6) **Address contributors**: pain, sleep, fatigue, family stress, medication SE; (7) **Suicide risk** assessment; (8) **Family education**; (9) **Cognitive screen**: MoCA — pseudo-dementia component; (10) **Team integration**: psychiatry consult ถ้า complex; **Modern**: integrated rehab + mental health + family-centered

---

Post-stroke depression 30% prevalence. PHQ-9 screen (or stroke-aphasic version). SSRI first-line. CBT adapted. ไม่ routine fluoxetine motor (FOCUS/AFFINITY neg). Treat contributors. Integrate mental health.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'AHA/ASA PSD Statement; FOCUS/AFFINITY trials', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี post-stroke 2 mo — มี post-stroke depression PHQ-9 16 + cognitive complaints — interferes therapy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี stroke chronic 8 mo — gait slow (10MWT 0.6 m/s) — community ambulation goal — fall risk', '[{"label":"A","text":"Wheelchair only"},{"label":"B","text":"Gait Rehabilitation Program"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Stop all therapy at plateau"},{"label":"E","text":"BoNT only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Gait Rehabilitation Program: (1) **Assessment**: 10MWT (0.4 limited household, 0.4-0.8 limited community, >0.8 community per Perry classification), 6MWT, Berg Balance Scale, Timed Up and Go, Dynamic Gait Index; (2) **Interventions**: - **Task-specific overground gait training** + treadmill (with/without body-weight support — BWSTT — evidence equivocal vs overground LEAPS trial); - **High-intensity gait training** (HIGT) emerging strong evidence; - **Aerobic conditioning**; - **Strength**: hip + knee + ankle; - **Balance**: perturbation training, Tai Chi; - **FES** for foot drop; (3) **Assistive devices**: cane, single-point/quad, walker — match function; **AFO** ถ้า foot drop; (4) **Robotics + exoskeleton**: emerging — selected; (5) **VR + dual-task training**; (6) **Fall prevention**: home assessment + OT + community; (7) **Outcome**: gait speed predicts mortality + community ambulation; (8) **Team**: PT-led + OT + physiatrist; **Modern**: high-intensity task-specific + technology adjuncts

---

Gait rehab: 10MWT classification, task-specific overground + HIGT, strength + balance + aerobic, FES/AFO/devices. Fall prevention. Gait speed prognostic. Modern: high-intensity task-specific + technology.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'Perry; LEAPS; AHA/ASA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี stroke chronic 8 mo — gait slow (10MWT 0.6 m/s) — community ambulation goal — fall risk'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี aphasia non-fluent (Broca-type) post-stroke 6 wk — frustrated + family wants intensive program', '[{"label":"A","text":"Discharge — wait for spontaneous recovery"},{"label":"B","text":"Aphasia Intensive Treatment + Family-Centered Approach"},{"label":"C","text":"Surgery"},{"label":"D","text":"Antipsychotic"},{"label":"E","text":"Disable communication device"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Aphasia Intensive Treatment + Family-Centered Approach: (1) **Classification + assessment**: WAB (Western Aphasia Battery), BDAE, BNT (Boston Naming), discourse, functional communication (CAL); (2) **Intensity matters**: ≥5 h/wk shown effective (Cochrane); intensive comprehensive aphasia programs (ICAP) 2-6 wk; (3) **Approaches**: - **Melodic Intonation Therapy (MIT)** for non-fluent; - **Constraint-Induced Aphasia Therapy (CIAT)** — restrict gesture/compensation; - **Script training, semantic feature analysis, phonological component analysis**; - **Communication partner training** + family/caregiver coaching; - **AAC** (augmentative + alternative communication) ถ้า severe; (4) **Technology**: tablet apps, telepractice; (5) **Group therapy + aphasia groups**: psychosocial + functional + reduces isolation; (6) **Pharmacology**: limited evidence — piracetam, donepezil, memantine, amphetamine — adjuncts not standard; (7) **Mood**: address PSD; (8) **Functional goals**: SMART, PROs; **Modern**: high-intensity + functional + technology + partner training

---

Aphasia: classification (WAB) + intensive (≥5 h/wk) + MIT/CIAT/SFA + partner training + AAC. Group therapy. Functional goals + family-centered. Tech adjuncts. Address mood. Modern: ICAP + telepractice.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'ASHA; Cochrane Aphasia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี aphasia non-fluent (Broca-type) post-stroke 6 wk — frustrated + family wants intensive program'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 68 ปี stroke 6 mo — มี shoulder pain + subluxation L (palpable gap 1 finger) — interfere therapy', '[{"label":"A","text":"Continuous overhead pulleys"},{"label":"B","text":"Hemiplegic Shoulder Subluxation + Pain Management"},{"label":"C","text":"Aggressive PROM forceful"},{"label":"D","text":"Tendon release surgery first"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hemiplegic Shoulder Subluxation + Pain Management: (1) **Prevention** key: positioning + handling education to all staff + family + avoid pulling on affected arm + lap tray/arm support when seated + NO overhead pulley exercise (causes impingement); (2) **Subluxation management**: - **Shoulder strapping/slings**: prevent further subluxation while upright; - **NMES (FES)** to supraspinatus + deltoid: reduces subluxation + pain (evidence); - **Strengthening** as motor return; (3) **Pain causes ddx**: subluxation, rotator cuff (impingement, tear), adhesive capsulitis, complex regional pain syndrome (CRPS-I shoulder-hand), spasticity, central post-stroke pain; (4) **Management**: PT (ROM + scapular + strengthening), modalities, intra-articular/subacromial steroid injection (selected), BoNT for spastic pattern (subscapularis, pectoralis), suprascapular nerve block; (5) **CRPS**: bisphosphonates, corticosteroids, PT, mirror therapy; (6) **Imaging**: US, MRI for refractory; **Modern**: multimodal + prevention + early intervention

---

Hemiplegic shoulder: prevention (positioning, handling, avoid pulleys). NMES for subluxation. DDx: subluxation, RC, AC, CRPS, spasticity. Multimodal Tx. BoNT for spastic pattern. Education team + family.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'rehab_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AHA/ASA; AAPM&R', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 68 ปี stroke 6 mo — มี shoulder pain + subluxation L (palpable gap 1 finger) — interfere therapy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย SCI C5 ASIA B — 6 wk post-injury — เริ่ม rehab — assessment + goal-setting', '[{"label":"A","text":"Independent ambulation expected"},{"label":"B","text":"C5 Tetraplegia — Functional Outcomes + Goals"},{"label":"C","text":"Full hand function expected"},{"label":"D","text":"Discharge home immediately"},{"label":"E","text":"Ventilator dependent always"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** C5 Tetraplegia — Functional Outcomes + Goals: (1) **ASIA/ISNCSCI exam**: motor (key muscles C5-T1, L2-S1), sensory (light touch + pinprick), AIS grade, NLI, ZPP; serial exams (24-72h, 1 mo, 3 mo) — recovery patterns; (2) **C5 key innervations**: deltoid + biceps + brachialis (elbow flexion preserved), no triceps; (3) **Expected outcomes C5 motor complete** (per Consortium): - Power wheelchair w/ hand controls; manual w/ rim projections short distances; - Feeding w/ adaptive equipment (universal cuff, mobile arm support); - Dressing UE w/ assistance; - Bladder/bowel: assist; - Transfer: dependent w/ lift; - Driving w/ adapted van; (4) **Tenodesis grip** (passive finger flexion w/ wrist extension) — preserve by NOT fully extending fingers w/ wrist extension; (5) **Equipment**: power w/c (sip-puff, head, chin control variants), environmental control (eye gaze, voice), adapted computer access, mobile arm support; (6) **Respiratory**: assist cough, IS, vital capacity monitor — C5 spared diaphragm but weak accessory; (7) **Multidisciplinary**: PM&R + PT + OT + SLP + RT + nursing + social work + psychology + peer support; (8) **Long-term**: skin, bladder, bowel, autonomic, mental health; **Modern**: TMR, exoskeletons (research), epidural stim research

---

C5 tetraplegia: ASIA exam, key muscles deltoid + biceps, no triceps. Power w/c + adaptive feeding/dressing. Tenodesis grip preserve. Power w/c controls. Multidisciplinary lifelong. Modern technologies.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'Consortium SCI Medicine; ISNCSCI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย SCI C5 ASIA B — 6 wk post-injury — เริ่ม rehab — assessment + goal-setting'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'SCI T6 paraplegic 3 mo — มี severe headache + BP 200/110 + sweating profuse above lesion + bradycardia — flushed face — chronic indwelling Foley', '[{"label":"A","text":"Lay flat + IV fluid bolus"},{"label":"B","text":"Autonomic Dysreflexia (AD) — Emergency"},{"label":"C","text":"Wait — self-resolves"},{"label":"D","text":"Diuretic only"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Autonomic Dysreflexia (AD) — Emergency: (1) **Pathophys**: noxious stimulus below NLI → sympathetic surge → severe HTN; carotid + aortic baroreceptors → parasympathetic above lesion (HA, flushing, sweating, bradycardia, nasal congestion); (2) **Lesions at/above T6** (above splanchnic outflow) at risk; (3) **Immediate management**: - **Sit patient up** (orthostatic-effect ↓BP); - **Loosen clothing/binders**; - **Identify + remove trigger**: bladder (catheter kinked/blocked, distension) → check Foley, irrigate, replace ถ้า blocked; bowel (impaction) → manual disimpaction w/ lidocaine jelly AFTER BP control; skin (pressure ulcer, ingrown nail); fracture; UTI; pregnancy; sexual stimulation; (4) **Pharmacologic**: rapid-acting antihypertensive — nitrate paste (1 inch nitroglycerin) wipe off after, nifedipine bite-and-swallow (controversial), captopril SL, hydralazine IV ถ้า refractory; (5) **Monitor BP q5min**; baseline SCI patients have low BP — "normal" 110 อาจสูง relative; (6) **After resolution**: identify + prevent recurrence; (7) **Education**: patient + family + medical alert card; (8) **Pregnancy/labor**: epidural anesthesia critical; **Modern**: education + emergency preparedness — fatal stroke/seizure possible

---

AD emergency: lesion T6+. Sit up + loosen + remove trigger (bladder #1, bowel #2, skin). NTG paste / nifedipine. Monitor q5min. Baseline low BP. Education + alert card. Fatal complications possible.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'Consortium SCI Medicine — AD Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'SCI T6 paraplegic 3 mo — มี severe headache + BP 200/110 + sweating profuse above lesion + bradycardia — flushed face — chronic indwelling Foley'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'SCI T4 complete 6 mo — sacral pressure injury stage 3 — outpatient', '[{"label":"A","text":"Continue sitting on wound"},{"label":"B","text":"Pressure Injury — Comprehensive Approach"},{"label":"C","text":"Wet-to-dry indefinitely"},{"label":"D","text":"Antibiotic only no offloading"},{"label":"E","text":"Amputation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pressure Injury — Comprehensive Approach: (1) **Stage** (NPIAP/EPUAP): Stage 1 (non-blanchable erythema) → 2 (partial-thickness) → 3 (full-thickness to subcutaneous) → 4 (to bone/muscle) + unstageable + DTI; (2) **Local wound care Stage 3**: clean (saline/wound cleanser), debride necrotic (sharp, autolytic, enzymatic), exudate management (foam, alginate, hydrocolloid), depth dressing (alginate for cavity), monitor; assess for infection (cellulitis, osteo); (3) **Offloading critical**: NO sitting on wound — alternative positions, specialty mattress, pressure-redistributing W/C cushion (ROHO, gel), tilt-in-space, weight-shifts q15-30 min; (4) **Nutrition**: protein 1.25-1.5 g/kg, calories 30-35 kcal/kg, micronutrients (vit C, zinc, arginine — selected); albumin/prealbumin/CRP track; (5) **Address etiology**: spasticity (BoNT, baclofen), incontinence (improve continence), shear/friction, equipment fit; (6) **Surgical consult**: flap closure ถ้า refractory + medically stable + non-smoker + adherent — myocutaneous flap; (7) **Imaging**: MRI for osteomyelitis suspicion; (8) **Team**: WOCN + PT + OT + nutrition + plastics + ID + SCI rehab; (9) **Prevention** key — daily skin checks, education; **Modern**: NPWT (negative pressure), advanced biologics, telewound

---

Pressure injury Stage 3: staging, local care + debridement + dressings, OFFLOADING critical, nutrition (protein 1.25-1.5), etiology, surgical consult flap. Team WOCN. Prevention education. NPWT/biologics modern.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'NPIAP/EPUAP; Consortium SCI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'SCI T4 complete 6 mo — sacral pressure injury stage 3 — outpatient'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'SCI T10 — 2 yr post-injury — recurrent UTI + new neurogenic bladder issues', '[{"label":"A","text":"Chronic prophylactic antibiotic routinely"},{"label":"B","text":"Neurogenic Bladder + UTI Management"},{"label":"C","text":"Indwelling Foley permanent"},{"label":"D","text":"Restrict all fluid"},{"label":"E","text":"Surgical urinary diversion now"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neurogenic Bladder + UTI Management: (1) **Type by lesion**: above S2 = upper motor neuron (UMN, spastic, detrusor-sphincter dyssynergia — DSD); cauda/conus = lower motor neuron (LMN, flaccid, areflexic, overflow); (2) **Urodynamics**: gold standard — pressure, capacity, DSD, compliance, leak point pressure; high pressure (>40 cm H2O storage) → upper tract risk; (3) **Management strategies**: - **Clean intermittent catheterization (CIC)**: preferred standard q4-6h — lowest complication vs indwelling; - **Anticholinergics/β3-agonist** (mirabegron) for detrusor overactivity; - **BoNT-A detrusor injection** for refractory DO; - **Indwelling**: SPT > urethral ถ้า must; - **Augmentation cystoplasty** rare; (4) **UTI** (CDC: symptomatic + bacteriuria + pyuria): treat symptomatic; ASYMPTOMATIC bacteriuria → do NOT treat (common in CIC); urine cultures > dipstick; (5) **Recurrent UTI workup**: stones, residuals, hydroupterosis, immune; (6) **Upper tract surveillance**: renal US + creatinine annual; (7) **Sexual + reproductive**: fertility (men ↓), sexual function, women — pregnancy planning; (8) **Education**: hand hygiene, single-use catheter, fluids; **Modern**: hydrophilic catheters, sacral neuromodulation selected

---

Neurogenic bladder: UMN spastic+DSD; LMN flaccid. Urodynamics. CIC preferred. Anticholinergic/β3, BoNT detrusor. Treat symptomatic UTI only — NOT asymptomatic bacteriuria. Renal US annual. Education.', NULL,
  'hard', 'renal_gu', 'review',
  'rehab_medicine', 'clinical_decision', 'renal_gu', 'adult',
  'Consortium SCI; AUA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'SCI T10 — 2 yr post-injury — recurrent UTI + new neurogenic bladder issues'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'SCI cervical 4 yr post-injury — chronic neuropathic pain (burning below NLI) — VAS 7/10 — opioids escalating', '[{"label":"A","text":"Opioid monotherapy escalating"},{"label":"B","text":"SCI Neuropathic Pain — Multimodal"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Surgery (cordotomy) first-line"},{"label":"E","text":"Discharge — no treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** SCI Neuropathic Pain — Multimodal: (1) **Classification (ISCIP)**: nociceptive (musculoskeletal, visceral) vs neuropathic (at-level, below-level) vs other; this patient at/below-level NP; (2) **Pharmacology (evidence-based)**: - **Gabapentin/pregabalin** first-line; - **TCA** (amitriptyline/nortriptyline) — anticholinergic SE; - **SNRI** (duloxetine, venlafaxine); - Lamotrigine selected; - Cannabinoids — selected, mixed evidence; - **Opioids**: limited evidence chronic, escalation concerns + neurogenic bowel worsening — opioid-sparing; (3) **Interventional**: - Spinal cord stimulation — emerging (dorsal column, DRG); - Intrathecal pumps (morphine, ziconotide) selected; (4) **Non-pharm**: CBT chronic pain, mindfulness, acceptance + commitment therapy (ACT), exercise/PT, TENS, virtual reality (modulates pain via VR analgesia); (5) **Address contributors**: spasticity, mood, sleep, social; (6) **Mental health integration**: depression + anxiety; (7) **Adaptive sports + meaningful activity** improves pain coping; (8) **Goal**: function + QOL not pain elimination; **Modern**: opioid-sparing multimodal + neuromodulation + behavioral

---

SCI neuropathic pain: ISCIP classification. Gabapentin/pregabalin + TCA/SNRI first-line. Opioid-sparing. SCS emerging. CBT + mindfulness + exercise. Address contributors. Modern: multimodal + neuromodulation.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'ISCIP; Consortium SCI Pain', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'SCI cervical 4 yr post-injury — chronic neuropathic pain (burning below NLI) — VAS 7/10 — opioids escalating'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'SCI paraplegic T8 — 6 mo — มาขอ adaptive sports + community reintegration', '[{"label":"A","text":"Discourage participation — too risky"},{"label":"B","text":"Adaptive Sports + Community Reintegration"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Hospice"},{"label":"E","text":"No community activities"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adaptive Sports + Community Reintegration: (1) **Benefits**: physical (CV, strength, weight), psychological (mood, self-efficacy, body image), social (peer, community); evidence: lower depression + better QOL; (2) **Classification per international para-sport** (IPC) — fair competition; (3) **Sports options paraplegic**: wheelchair basketball, rugby, tennis, racing; handcycling; swimming; adaptive skiing; sailing; rock climbing; archery; (4) **Equipment + funding**: sport-specific W/C, prosthetics, adaptive equipment — high cost; (5) **Medical considerations**: skin (pressure injury from sport W/C), thermoregulation impaired (cooling), autonomic dysreflexia (avoid "boosting"), bladder/bowel timing, UE overuse (rotator cuff), nutrition, hydration; (6) **Pre-participation evaluation**: CV (post-SCI ↓capacity), MSK, skin, bladder/bowel, equipment fit; (7) **Vocational + driving + travel**: driving evaluation, adapted vehicle, accessibility, travel planning; (8) **Peer mentorship + advocacy**: organizations (PVA, Disabled Sports USA); (9) **Family + caregiver education**; **Modern**: paralympic pathway + recreational integration + technology-enabled

---

Adaptive sports + community: physical/psych/social benefits. Equipment + classification. Medical considerations (skin, thermoreg, AD, UE overuse). Peer mentorship. Vocational + driving. Family. Modern integrated.', NULL,
  'easy', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'PVA; Disabled Sports USA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'SCI paraplegic T8 — 6 mo — มาขอ adaptive sports + community reintegration'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'SCI L1 incomplete (AIS D) 4 mo — มี ambulation potential — gait training', '[{"label":"A","text":"No ambulation — power w/c only"},{"label":"B","text":"Incomplete SCI Gait Rehabilitation"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Surgical fusion only"},{"label":"E","text":"Refer hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Incomplete SCI Gait Rehabilitation: (1) **Prognosis**: AIS D good ambulation potential — most regain community ambulation (LEMS predictive); (2) **Assessment**: LEMS (lower extremity motor score), WISCI-II (Walking Index for SCI), 10MWT, 6MWT, TUG, Berg; (3) **Interventions**: - **Task-specific overground gait training** + high-intensity; - **Body-weight supported treadmill training (BWSTT)** — equivalent to overground per SCILT; - **Robotic-assisted gait training** (Lokomat, ReWalk, EksoBionics) — adjunct, evidence mixed but useful; - **FES** for foot drop or quad weakness; - **Strength training**; - **Balance + core**; - **Aerobic conditioning**; (4) **Orthotics**: AFO (foot drop), KAFO (quad weakness), reciprocating gait orthosis (paraplegic standing/limited ambulation), HKAFO; (5) **Assistive devices**: cane, crutches (forearm/Lofstrand), walker; (6) **Exoskeletons** (community ambulation): emerging — ReWalk, Indego, Ekso — selected patients; (7) **Spasticity** + pain + bladder addressing; (8) **Outcome measures**: WISCI-II, gait speed, LEMS; (9) **Goal-setting**: SMART, patient-centered; **Modern**: high-intensity task-specific + technology adjuncts + community ambulation focus

---

Incomplete SCI gait: AIS D good prognosis. LEMS/WISCI-II/10MWT outcomes. Task-specific overground + BWSTT + robotics + FES + orthotics. Exoskeletons emerging. High-intensity. Goal-directed.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'Consortium SCI; SCILT trial', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'SCI L1 incomplete (AIS D) 4 mo — มี ambulation potential — gait training'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'SCI tetraplegic 2 yr — มี chronic shoulder pain bilateral — manual W/C user', '[{"label":"A","text":"Continue same propulsion technique"},{"label":"B","text":"Shoulder Overuse in Manual W/C User"},{"label":"C","text":"Surgical shoulder fusion"},{"label":"D","text":"Stop all activity bedrest"},{"label":"E","text":"Opioid only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Shoulder Overuse in Manual W/C User: (1) **Prevalence**: 30-70% manual W/C users develop shoulder pain; impacts function + independence; (2) **Etiology**: repetitive propulsion + transfers + weight relief + reach — rotator cuff (impingement, tear), AC, bicipital tenosynovitis, instability; (3) **PVA Preservation of Upper Limb Function** guidelines: - Minimize forces during propulsion (longer stroke, smooth pattern); - Optimize W/C setup (rear axle anterior reduces shoulder load, light W/C); - Power-assist wheels or power W/C transition consider; - Transfer training (head-hips relationship, level surface, slide board); - Avoid extreme positions (overhead, behind back); (4) **Treatment**: PT (RC strengthening + scapular stabilizers + posture), modalities, NSAIDs (cautious), injections (subacromial, AC), surgical (RC repair selected); (5) **Assessment**: shoulder exam, US/MRI, WUSPI (Wheelchair Users Shoulder Pain Index); (6) **Prevention** key + lifelong: equipment, technique, conditioning, weight management; (7) **Body composition**: prevent metabolic syndrome (lower CV fitness post-SCI); (8) **Team**: PT + OT + physiatrist + seating clinic; **Modern**: power-assist + ergonomic equipment + early intervention

---

W/C user shoulder pain: 30-70%. PVA Preservation UE Function guidelines — equipment + technique + transfer. PT RC + scapular. Power-assist transition. WUSPI assessment. Prevention lifelong.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'rehab_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'PVA Preservation of UE Function CPG', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'SCI tetraplegic 2 yr — มี chronic shoulder pain bilateral — manual W/C user'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'TBI severe 3 wk post-injury — Rancho IV (confused, agitated) — pulling lines + striking staff', '[{"label":"A","text":"Benzodiazepine high dose"},{"label":"B","text":"Agitated TBI (Rancho IV) — Behavioral + Pharmacological"},{"label":"C","text":"Physical restraint primary"},{"label":"D","text":"Discharge home immediately"},{"label":"E","text":"Bedrest sedated"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Agitated TBI (Rancho IV) — Behavioral + Pharmacological: (1) **Rancho Los Amigos** I-VIII — Level IV: confused, agitated, response to internal confusion; expected stage; transient typically days-weeks; (2) **Environmental + Behavioral (FIRST)**: - Calm low-stim environment (single room, dim lighting, quiet); - Consistent staff/family; - Structured routine; - Frequent orientation + reassurance; - Reduce restraints (use selective — environmental safer); - Identify triggers (pain, full bladder, hunger, sleep deprivation, infection, medication); - Family education + co-therapy; (3) **Address contributors**: pain (assess + treat — multimodal opioid-sparing), constipation, urinary retention/UTI, sleep, sensory (vision/hearing), DT/seizure post-TBI; (4) **Pharmacology** (when behavioral fails + safety): - **Avoid benzodiazepines + first-gen antipsychotics + anticholinergics** (worsen cognition); - **Beta-blocker** (propranolol) for agitation evidence — Level I (Fugate); - **Atypical antipsychotics** (quetiapine, olanzapine) cautious; - **Anticonvulsants** (valproate, carbamazepine) selected; - **Amantadine** for arousal in low Rancho; - **Trazodone** for sleep; (5) **Agitated Behavior Scale (ABS)** monitor; (6) **Team**: physiatry + neuropsychology + nursing + PT + OT + SLP + behavioral + family; (7) **Safety + restraint minimization**; **Modern**: trauma-informed + family co-therapy

---

Rancho IV TBI agitation: environmental + behavioral first. Identify contributors. Propranolol Level I evidence. AVOID benzos + first-gen antipsych + anticholinergic. ABS monitor. Multidisciplinary + family.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'Rancho; Fugate Propranolol', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'TBI severe 3 wk post-injury — Rancho IV (confused, agitated) — pulling lines + striking staff'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'TBI 6 wk post — minimally conscious state (MCS) — family + team discussing prognosis + interventions', '[{"label":"A","text":"Withdraw all therapy immediately"},{"label":"B","text":"Disorders of Consciousness (DoC) Management"},{"label":"C","text":"Sedate continuously"},{"label":"D","text":"Discharge home no follow-up"},{"label":"E","text":"Routine surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Disorders of Consciousness (DoC) Management: (1) **Definitions**: coma, vegetative state/unresponsive wakefulness syndrome (VS/UWS), minimally conscious state (MCS-/+), emergence from MCS; (2) **Assessment**: **Coma Recovery Scale-Revised (CRS-R)** — gold standard, repeated; clinical exam misclassifies up to 40% — repeated assessment + ancillary; (3) **Ancillary**: fMRI + EEG (cognitive motor dissociation — covert awareness in ~15-20% behaviorally unresponsive); (4) **Treatment**: - **Amantadine** 200-400 mg/day evidence (Giacino NEJM 2012) — improves recovery in DoC 4-16 wk post-injury; - Address barriers (medications — minimize sedating, sleep, pain, hydrocephalus, seizures, infection); - **Sensory stimulation programs** — evidence weak but reasonable; - **rTMS, tDCS** emerging; (5) **Rehab participation**: tilt-table, ROM, splinting (contracture prevention), positioning, family training, environmental modification; (6) **Prognosis discussions**: caution — improvement can occur > 1 yr particularly in TBI vs anoxic; serial assessments; (7) **Goals of care + advance directives**: family-centered, neuroethics, palliative integration; (8) **Family support**: education + counseling + respite; **Modern**: covert consciousness detection + neuromodulation + DoC programs

---

DoC: CRS-R repeated assessment, fMRI/EEG covert awareness. Amantadine NEJM evidence. Address contributors. Sensory + rehab participation. Prognosis caution — TBI improvement > 1 yr. Family + neuroethics.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'Giacino NEJM 2012; AAN/ACRM DoC Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'TBI 6 wk post — minimally conscious state (MCS) — family + team discussing prognosis + interventions'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 25 ปี sport-related concussion — symptoms 3 wk (HA, dizziness, cognitive fog) — persistent', '[{"label":"A","text":"Prolonged rest indefinite"},{"label":"B","text":"Persistent Post-Concussion — Targeted Multidisciplinary"},{"label":"C","text":"Strict bed rest 6 mo"},{"label":"D","text":"Opioid for HA"},{"label":"E","text":"Return to contact sport immediately"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Persistent Post-Concussion — Targeted Multidisciplinary: (1) **Definition**: symptoms > 2-4 wk; subtypes addressed individually; (2) **Assessment**: SCAT5/6, BESS balance, VOMS (vestibular/ocular motor screening), cognitive (computerized — ImPACT), symptom inventory; (3) **Subtype + targeted treatment**: - **Vestibular/ocular**: vestibular rehab (VOR ex, gaze stabilization, habituation, balance), vision therapy; - **Cervicogenic**: PT cervical (manual + exercise); - **Cognitive/fatigue**: graded cognitive activity, cognitive rehab, sleep hygiene; - **Mood/anxiety**: CBT, SSRI; - **Migraine/HA**: acute (NSAID/triptan) + preventive (TCA, topiramate, propranolol, CGRP); - **Autonomic/exercise intolerance**: Buffalo Concussion Treadmill Test → sub-symptom threshold aerobic exercise (Leddy) — strong evidence; (4) **Active recovery** > prolonged rest (>48-72h rest prolongs recovery) — gradual return to activity (sport-specific 6-step protocol); (5) **Return-to-learn** + return-to-work + return-to-play; (6) **Multidisciplinary**: physiatry/sports med + neuropsych + PT (vestib/cervical) + OT + SLP + behavioral health; (7) **Avoid**: prolonged rest, second-impact risk, opioids; (8) **Long-term**: rare CTE concerns + meaningful counseling; **Modern**: subtype-targeted + sub-symptom exercise + multidisciplinary

---

Persistent post-concussion: subtype-targeted (vestib/ocular, cervical, cognitive, mood, migraine, autonomic). Active recovery > prolonged rest. Buffalo Test → sub-symptom aerobic (Leddy). RTL/RTW/RTP graded.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'CISG Amsterdam Consensus; AAPM&R', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 25 ปี sport-related concussion — symptoms 3 wk (HA, dizziness, cognitive fog) — persistent'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'TBI 4 mo post — มี cognitive impairment (attention + executive function) — interfering work — IQ preserved', '[{"label":"A","text":"No intervention — accept deficits"},{"label":"B","text":"Cognitive Rehabilitation — Attention + Executive"},{"label":"C","text":"Heavy sedation"},{"label":"D","text":"Surgery"},{"label":"E","text":"Discharge — no follow-up"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cognitive Rehabilitation — Attention + Executive: (1) **Comprehensive neuropsychological assessment**: domains (attention, processing speed, memory, executive, language, visuospatial); strengths + weaknesses; (2) **Cognitive rehabilitation approaches** (INCOG/ACRM evidence): - **Attention Process Training (APT)**: hierarchical drills + functional integration; - **Time Pressure Management** for slowed processing; - **Goal Management Training (GMT)** for executive; - **Metacognitive strategy training**: self-monitoring + strategy use; - **External aids**: smartphones/apps for memory + organization (evidence strong); - **Environmental modifications**: reduce distractions, structure; (3) **Restorative vs compensatory**: combination — restorative drills + compensatory strategies for real-world; (4) **Computer-based cognitive training**: adjunct (limited generalization without functional integration); (5) **Pharmacology** adjuncts: methylphenidate for attention/processing speed (evidence), amantadine, modafinil for fatigue, donepezil selected — limited evidence; (6) **Functional integration**: real-world tasks (work, school, ADLs); (7) **Vocational rehab + workplace accommodations**: graduated return, ADA; (8) **Family + community education**; (9) **Address contributors**: sleep, mood, pain, medications; **Modern**: technology-assisted (apps) + metacognitive + functional

---

Cognitive rehab: comprehensive neuropsych. APT + GMT + metacog + external aids (apps strong evidence). Restorative + compensatory. Methylphenidate adjunct. Functional + vocational. Address contributors.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'INCOG; ACRM Cognitive Rehab', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'TBI 4 mo post — มี cognitive impairment (attention + executive function) — interfering work — IQ preserved'
  );

commit;

