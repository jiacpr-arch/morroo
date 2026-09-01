-- ===============================================================
-- หมอรู้ — Board seed: เวชศาสตร์ฟื้นฟู (rehab_medicine) — part 2/4 (50 MCQs)
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
  s.id, 'board', NULL, 'TBI 2 wk — post-traumatic agitation + arousal disorder — sleep-wake disrupted', '[{"label":"A","text":"Benzodiazepine continuous"},{"label":"B","text":"TBI Sleep + Arousal Management"},{"label":"C","text":"No assessment — ignore sleep"},{"label":"D","text":"Heavy sedation 24h"},{"label":"E","text":"Discharge no follow-up"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** TBI Sleep + Arousal Management: (1) **Sleep disorders post-TBI**: insomnia + fragmentation + hypersomnia + circadian disruption + sleep apnea (50% TBI screen w/ HSAT/PSG); (2) **Assessment**: PSQI, Epworth, actigraphy, sleep diary, PSG if OSA suspected; (3) **Sleep hygiene**: consistent schedule, environment, light exposure (bright light AM), avoid stimulants/screens evening, exercise; (4) **Pharmacotherapy**: - **Melatonin** + ramelteon for circadian; - **Trazodone** sedating; - **Mirtazapine** if depression; - **Zolpidem/zopiclone** short-term cautious (falls, abuse); - **AVOID benzodiazepines** (cognitive impairment, dependency); - **Modafinil** for daytime hypersomnia; (5) **CBT-I**: first-line for chronic insomnia, adapted for TBI; (6) **Treat OSA**: CPAP — improves cognition + symptoms; (7) **Address contributors**: pain, depression, anxiety, medications, environment; (8) **Arousal**: amantadine for low arousal (Rancho), methylphenidate for attention/fatigue; (9) **Light therapy** for circadian + depression; (10) **Family education + structure home routine**; **Modern**: targeted sleep medicine + actigraphy + CBT-I

---

TBI sleep: insomnia, fragmentation, OSA common. Sleep hygiene + melatonin/trazodone/mirtazapine. AVOID benzo. CBT-I. CPAP for OSA. Light therapy. Amantadine/methylphenidate. Address contributors.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'INCOG Sleep; AAPM&R', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'TBI 2 wk — post-traumatic agitation + arousal disorder — sleep-wake disrupted'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี TBI 6 mo — ready return to work — knowledge worker role', '[{"label":"A","text":"Return immediately full duties"},{"label":"B","text":"Return-to-Work after TBI"},{"label":"C","text":"No return ever"},{"label":"D","text":"Discharge — no rehab"},{"label":"E","text":"Disability without trial"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Return-to-Work after TBI: (1) **Assessment**: cognitive (neuropsych) + physical + behavioral + job demands analysis; (2) **Predictors**: pre-injury employment, age, severity, cognitive function, psychosocial, social support; (3) **Process**: - **Vocational rehab counselor** integration; - **Worksite assessment** + job analysis; - **Graduated return**: half-days → full → full duties; - **Accommodations (ADA/equivalent)**: reduced hours, flex schedule, quiet workspace, written instructions, breaks, assistive technology (text-to-speech, organization apps), additional time, task simplification; - **Job coach** support on-site selected; (4) **Cognitive support**: external aids (calendars, reminders, smartphones); metacognitive strategies; (5) **Endurance + stamina**: graded activity; rest scheduling; (6) **Emotional + behavioral support**: CBT, peer support, family; (7) **Driving evaluation** if needed for work (CDRS clinical driving rehab specialist); (8) **Modifications longer-term**: job redesign, vocational change ถ้า cannot return; (9) **Outcomes**: monitor + adjust; team meetings; (10) **Resources**: vocational rehab agencies, ADA, employer education; **Modern**: technology-enabled accommodations + supported employment model

---

RTW after TBI: comprehensive cognitive + physical + behavioral + worksite analysis. Graduated return + accommodations + job coach. External aids. CBT + peer. Driving eval. Long-term monitor.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'INCOG; Vocational Rehab', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี TBI 6 mo — ready return to work — knowledge worker role'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'TBI 1 yr post — มี post-traumatic seizures + behavioral issues + chronic HA', '[{"label":"A","text":"Sedate continuously"},{"label":"B","text":"Late Post-TBI Complications — Comprehensive"},{"label":"C","text":"No follow-up"},{"label":"D","text":"Surgery as primary"},{"label":"E","text":"Refer hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Late Post-TBI Complications — Comprehensive: (1) **Post-traumatic epilepsy (PTE)**: ~10-20% severe TBI; risk factors (severity, penetrating, depressed skull fx, contusion, ICH, early seizure); diagnose w/ EEG + clinical; AED: levetiracetam first-line (favorable cognitive profile vs phenytoin/carbamazepine); avoid sedating + cognitive-impairing AEDs; consider tapering after seizure-free interval; (2) **Behavioral + neuropsychiatric**: - Depression (high), anxiety, PTSD, agitation, apathy, disinhibition, mania-like; - SSRI first-line; CBT; trauma-focused; - Address apathy w/ stimulants/amantadine selected; - Atypical antipsychotic for severe agitation cautious; - AVOID benzo + anticholinergic; (3) **Chronic HA**: post-traumatic HA — migraine/tension subtypes; preventive (TCA, propranolol, topiramate, CGRP — selected); acute opioid-sparing; address contributors (sleep, mood, cervical); (4) **Cognitive impairment + dementia risk**: long-term cognitive monitoring; (5) **Sleep, endocrine (hypopituitarism — screen!), vestibular, sensory**; (6) **Substance use** post-TBI elevated — screen + treat; (7) **Family + community + vocational**: long-term support; (8) **Driving + safety**; (9) **Caregiver burden + respite**; **Modern**: chronic disease model + integrated care

---

Late TBI complications: PTE (levetiracetam), neuropsychiatric (SSRI, CBT, avoid benzo), chronic HA preventive, cognitive monitor, endocrine (hypopituitarism!), substance use, family + vocational. Chronic disease model.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'AAN PTE; INCOG', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'TBI 1 yr post — มี post-traumatic seizures + behavioral issues + chronic HA'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี post-transtibial amputation (BKA) 3 wk — diabetic — preparing prosthesis', '[{"label":"A","text":"Bed rest no shaping"},{"label":"B","text":"Transtibial (BKA) Pre-Prosthetic + Prosthetic Phase"},{"label":"C","text":"Skip K-level assessment"},{"label":"D","text":"Discharge no prosthesis"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Transtibial (BKA) Pre-Prosthetic + Prosthetic Phase: (1) **Pre-prosthetic phase**: - Residual limb shaping: shrinkers (preferred) or figure-8 ace wrap (correct technique distal-to-proximal pressure); - Wound + skin care; daily inspection; - Edema control + maturation; - **ROM**: prevent knee flexion contracture (positioning prone time, avoid pillow under knee); - Strengthening (core + remaining + UE); - Cardiovascular conditioning; - Pain management (phantom + residual); - Transfers + mobility w/ assistive device + single leg; (2) **Diabetes optimization**: glycemic control, foot care contralateral (high risk), vascular surveillance; (3) **Education**: skin checks, weight management, contralateral foot, prosthesis care, expectations; (4) **K-level assessment**: functional ambulation potential (K0-K4) guides prosthetic prescription; this patient typically K1-K3; (5) **Prosthetic prescription**: socket (PTB, TSB, gel liner), suspension (suction, pin lock, lanyard, sleeve), foot (SACH, single-axis, multiaxial, energy-storing, dynamic response, microprocessor for K3-K4), pylon; (6) **Fitting + training**: cast/scan → diagnostic → definitive; PT gait training (weight shift, step length symmetry, advanced); (7) **Long-term**: socket adjustments + replacements; contralateral surveillance; **Modern**: microprocessor feet + osseointegration selected + advanced liners

---

BKA: shaping (shrinker), prevent knee flexion contracture, glycemic + foot care contralateral, K-level prescription, socket/suspension/foot components. Long-term care. Modern technology adjuncts.', NULL,
  'medium', 'trauma', 'review',
  'rehab_medicine', 'clinical_decision', 'trauma', 'adult',
  'AAPM&R; VA/DoD Amputee CPG', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี post-transtibial amputation (BKA) 3 wk — diabetic — preparing prosthesis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย post-transfemoral amputation (AKA) — 6 mo — มี phantom limb pain refractory to gabapentin', '[{"label":"A","text":"Opioid escalation alone"},{"label":"B","text":"Refractory Phantom Limb Pain (PLP) — Multimodal"},{"label":"C","text":"Amputation higher level"},{"label":"D","text":"Bed rest"},{"label":"E","text":"Discharge no treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Refractory Phantom Limb Pain (PLP) — Multimodal: (1) **Prevalence**: 50-80% amputees; mechanisms — peripheral (neuroma) + spinal sensitization + cortical reorganization; (2) **Multimodal approach**: - **Mirror therapy** (Ramachandran): low-cost, evidence supportive — daily 15-30 min; - **Graded motor imagery (GMI)**: laterality recognition → imagined movement → mirror therapy — 6 wk; - **Pharmacology**: gabapentin/pregabalin (max + adherence?), TCA (amitriptyline), SNRI (duloxetine), opioid-sparing, ketamine selected, IV lidocaine selected, NMDA antagonists; (3) **Neuromodulation**: - **TENS** non-invasive; - **rTMS** of motor cortex emerging; - **Spinal cord stimulation** selected refractory; - **Peripheral nerve stimulation**; (4) **Surgical/procedural**: - **Targeted Muscle Reinnervation (TMR)**: reroutes amputated nerves to local muscle — reduces neuroma + improves prosthetic myoelectric control; strong evidence; - **Regenerative Peripheral Nerve Interface (RPNI)**: free muscle graft to nerve; - Neuroma resection + revision (selected); (5) **Psychological**: CBT, ACT, mindfulness, hypnosis; address PTSD if war/trauma; (6) **Prosthetic fit optimization**: addresses residual limb pain often contributing; (7) **Multidisciplinary team**; **Modern**: TMR/RPNI + neuromodulation + multimodal integrated

---

PLP refractory: mirror therapy + GMI + pharmacology + neuromodulation + TMR/RPNI surgical + psychological. Multimodal. TMR strong evidence. Address residual limb pain. Multidisciplinary.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'VA/DoD; TMR evidence', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย post-transfemoral amputation (AKA) — 6 mo — มี phantom limb pain refractory to gabapentin'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย unilateral upper limb amputation (transradial) — active 30 yo — considering prosthesis options', '[{"label":"A","text":"Refuse all prosthesis"},{"label":"B","text":"Upper Limb Prosthesis Selection — Transradial"},{"label":"C","text":"Bed rest"},{"label":"D","text":"Body-powered always best for everyone"},{"label":"E","text":"Discharge no training"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Upper Limb Prosthesis Selection — Transradial: (1) **Options**: - **Body-powered**: cables + harness + hook (split hook) or hand; durable, sensory feedback via cables, lower cost; good for heavy/dirty environments; - **Externally-powered (myoelectric)**: surface EMG electrodes drive motor; multifunction (open/close, wrist rotation, multiarticulating hands); cosmetic + functional; higher cost + maintenance + weight; - **Hybrid**; - **Passive cosmetic**; - **Activity-specific** (sports); (2) **Selection factors**: functional goals + occupation + activities + cosmesis + lifestyle + cost + adherence; (3) **TMR/RPNI**: improves myoelectric control + reduces neuroma; intuitive multifunctional control; (4) **Advanced**: pattern recognition (instead of direct EMG channel mapping), proprioceptive feedback emerging, multi-articulating hands (i-Limb, bebionic, Michelangelo), powered wrist/elbow; (5) **Training**: occupational therapy intensive — sequential donning, control, ADLs, sports/work integration; (6) **Bilateral training** + contralateral overuse prevention; (7) **Outcomes**: ACMC (Assessment of Capacity for Myoelectric Control), SHAP, prosthesis use diary; (8) **Long-term**: prosthesis replacement, training updates, peer support, vocational; **Modern**: TMR + pattern recognition + sensory feedback (research)

---

UE prosthesis: body-powered (durable, feedback) vs myoelectric (multifunction, cosmetic) vs hybrid. TMR improves myoelectric. Patient-centered selection. OT intensive training. Outcomes ACMC/SHAP. TMR + pattern recognition modern.', NULL,
  'medium', 'trauma', 'review',
  'rehab_medicine', 'clinical_decision', 'trauma', 'adult',
  'AAPM&R; ACMC; TMR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย unilateral upper limb amputation (transradial) — active 30 yo — considering prosthesis options'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย BKA 8 mo — มี skin breakdown + recurrent abrasions on residual limb — socket fit issue', '[{"label":"A","text":"Continue same socket — no changes"},{"label":"B","text":"Residual Limb Skin Problems — Socket Fit Optimization"},{"label":"C","text":"Discontinue prosthesis permanently"},{"label":"D","text":"Surgical revision first-line"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Residual Limb Skin Problems — Socket Fit Optimization: (1) **Etiology**: socket fit (volume change, weight change, edema, atrophy), gait issues, hygiene, liner wear, sweat/heat, vascular issues; (2) **Common conditions**: pressure ulcers (distal end, fibular head, patellar tendon area), abrasions, contact dermatitis (silicone allergy), folliculitis, verrucous hyperplasia (chronic edema), bursae, eczema, hyperhidrosis; (3) **Assessment**: full residual limb exam, socket fit, gait analysis, hygiene, liner; (4) **Management**: - **Socket modifications**: prosthetist adjustment, new socket, socks (add/remove for volume — ply system), gel/silicone liner change; - **Skin care**: gentle wash + dry, moisturize, antimicrobial selected; - **Hyperhidrosis**: aluminum chloride, BoNT, oral; - **Verrucous hyperplasia**: total contact socket + treat underlying; - **Contact dermatitis**: change liner material, topical steroid; - **Bursae**: ice, NSAID, injection, surgical selected; (5) **Education**: daily skin inspection, hygiene, sock management, weight stability, prosthesis off if sore; (6) **Team**: prosthetist + physiatrist + PT + dermatology selected; (7) **Imaging/labs**: if osteomyelitis suspected; **Modern**: 3D-scanning custom sockets + advanced liners + hygiene

---

Residual limb skin: socket fit + volume + gait + hygiene. Pressure ulcers, dermatitis, hyperhidrosis, verrucous. Prosthetist socket modification + sock ply + liner change. Skin care + education. Team.', NULL,
  'medium', 'trauma', 'review',
  'rehab_medicine', 'clinical_decision', 'trauma', 'adult',
  'AAPM&R; ISPO', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย BKA 8 mo — มี skin breakdown + recurrent abrasions on residual limb — socket fit issue'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย post-AKA 3 mo — มี hip flexion contracture 25° + gait dysfunction', '[{"label":"A","text":"Bedrest in supine"},{"label":"B","text":"Hip Flexion Contracture Post-AKA"},{"label":"C","text":"Pillow under residual continuously"},{"label":"D","text":"Surgical fusion"},{"label":"E","text":"Refer hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hip Flexion Contracture Post-AKA: (1) **Etiology + Prevention**: hip flexors (iliopsoas, rectus) shorten — prone positioning prevention (15-30 min q-shift TID), avoiding prolonged sitting/supine w/ pillow under residual; (2) **Consequences**: gait — excessive lordosis, vaulting, increased energy expenditure, prosthetic alignment difficulty; (3) **Assessment**: Thomas test, gait analysis, ROM; goniometric measure; (4) **Treatment**: - **Stretching**: prone positioning daily 15-30 min TID; Thomas test position stretch; - **Strengthening**: hip extensors (glutes), core; - **PT**: manual therapy + exercise; - **Modalities**: heat + stretch; - **Serial casting** rarely for AKA contracture; - **Surgical release** for severe refractory; (5) **Prosthetic compensation**: socket flexion alignment + foot/knee tuning by prosthetist (improves gait); (6) **Patient education + adherence**: critical — home program; (7) **Address contributors**: pain, spasticity (rare), positioning habits, equipment (W/C, bed); (8) **Outcome**: ROM + gait analysis + 6MWT + symmetry; (9) **Team**: prosthetist + PT + physiatrist; **Modern**: 3D gait analysis + biomechanical optimization

---

Hip flexion contracture post-AKA: prevent w/ prone positioning. Stretching + strengthening + PT. Prosthetic alignment compensation. Education critical. Gait analysis. Multidisciplinary.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'rehab_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAPM&R; VA/DoD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย post-AKA 3 mo — มี hip flexion contracture 25° + gait dysfunction'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย bilateral AKA 6 mo — preparing for prosthetic ambulation + community goals', '[{"label":"A","text":"Bedrest"},{"label":"B","text":"Bilateral Transfemoral Amputee — Prosthetic Ambulation"},{"label":"C","text":"Single conventional knee mandatory"},{"label":"D","text":"No prosthesis ever"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bilateral Transfemoral Amputee — Prosthetic Ambulation: (1) **Energy expenditure**: bilateral AKA → 280% increase vs intact; CV demand high — many don''t achieve community ambulation; (2) **Selection factors**: cardiovascular reserve (CPET), strength, motivation, age, comorbidities, balance, cognition; (3) **Stubbies** (short prostheses, no knees, low CG): initial training option — lower energy + balance; transition to full when ready; (4) **Full prostheses**: microprocessor knees (C-Leg, Genium) reduce energy + falls + improve confidence — recommended for bilateral; energy-storing feet; (5) **Training program**: - Pre-gait: balance + standing tolerance + core; - Parallel bars → walker → crutches/canes; - Endurance gradual; - Functional tasks; (6) **Adjunct**: W/C remains primary mobility for many bilateral AKA in community — combine; (7) **Multidisciplinary**: prosthetist + PT + OT + physiatrist + cardiology (CV clearance) + psychology; (8) **Long-term**: socket adjustments, replacement, contralateral integrity, equipment; (9) **Outcome**: AMPRO/AMP, 6MWT, falls, PROs; **Modern**: microprocessor knees, advanced control, osseointegration selected reduces socket issues

---

Bilateral AKA: 280% energy. CV reserve key. Stubbies → full. Microprocessor knees recommended. W/C combined. Multidisciplinary + CV clearance. AMPRO/6MWT outcomes. Modern technology + osseointegration.', NULL,
  'hard', 'trauma', 'review',
  'rehab_medicine', 'clinical_decision', 'trauma', 'adult',
  'AAPM&R; VA/DoD Bilateral', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย bilateral AKA 6 mo — preparing for prosthetic ambulation + community goals'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย amputee 3 yr post-amputation — มี contralateral limb concerns (DM + PAD) — surveillance', '[{"label":"A","text":"No surveillance — wait symptoms"},{"label":"B","text":"Contralateral Limb Preservation — DM/PAD Amputee"},{"label":"C","text":"Discharge no follow-up"},{"label":"D","text":"Routine prophylactic amputation"},{"label":"E","text":"Bed rest"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Contralateral Limb Preservation — DM/PAD Amputee: (1) **Risk**: 5-yr contralateral amputation rate 30-50% in DM/PAD amputees; reduce by surveillance + intervention; (2) **Multidisciplinary surveillance**: - **Podiatry**: q3-6 mo high-risk diabetic foot exam (10g monofilament, vibration, ABI, palpation, skin); - **Vascular surgery**: ABI + duplex + intervention if disease; - **Endocrinology**: glycemic control (A1c < 7%), CV risk; - **Wound care + WOCN**: any wound aggressive Tx; - **Orthotics/footwear**: diabetic shoes + custom insoles (Medicare benefit USA); (3) **Pressure offloading**: total contact cast for ulcers; pressure reduction footwear; (4) **Smoking cessation** critical; (5) **Patient education**: daily foot inspection (mirror), shoe checks (foreign bodies), no barefoot, moisturize, nail care, prompt reporting; (6) **CV optimization**: statin, antiplatelet, BP, glycemic, exercise; (7) **Address pressure + repetitive trauma** from prosthetic side compensatory gait; (8) **Mental health + adherence support**: peer; (9) **Weight management**; (10) **Refer prompt**: any new ulcer, infection, ischemia; **Modern**: integrated DM-vascular-podiatry-rehab teams + telehealth

---

Contralateral limb preservation DM/PAD: 30-50% 5-yr risk. Podiatry + vascular + endo + WOCN + orthotics. Offloading + footwear. Smoking cessation. Daily inspection education. CV optimization. Integrated team.', NULL,
  'medium', 'trauma', 'review',
  'rehab_medicine', 'clinical_decision', 'trauma', 'adult',
  'ADA Diabetic Foot; SVS PAD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย amputee 3 yr post-amputation — มี contralateral limb concerns (DM + PAD) — surveillance'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'นักกีฬาฟุตบอลอายุ 22 ปี ACL reconstruction (BPTB autograft) 6 mo post-op — ต้องการ return-to-sport', '[{"label":"A","text":"Return at 4 mo timeline only"},{"label":"B","text":"ACL Return-to-Sport Criteria + Program"},{"label":"C","text":"Bedrest 1 yr"},{"label":"D","text":"Surgery revision"},{"label":"E","text":"Stop sport permanently"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ACL Return-to-Sport Criteria + Program: (1) **Time alone insufficient**: ≥9-12 mo recommended (reduces re-injury); time + criteria; (2) **Objective criteria battery**: - **Strength**: Limb Symmetry Index (LSI) ≥ 90% (quadriceps + hamstrings isokinetic); - **Hop tests** (single-leg hop, triple, crossover, 6m timed) LSI ≥ 90%; - **Movement quality**: drop vertical jump assessment (knee valgus angles, LESS — Landing Error Scoring System); - **PROs**: IKDC, KOOS, Tegner; - **Psychological readiness**: ACL-RSI ≥ 60-77 (fear of reinjury predictor); (3) **Phased program**: phase 1 swelling/ROM/quad activation → 2 strength + closed-chain → 3 power/plyometric → 4 sport-specific drills → 5 unrestricted return; (4) **Neuromuscular training**: emphasis perturbation, plyometrics, agility, sport-specific cutting/pivoting; (5) **Graft considerations**: BPTB (this patient) anterior knee pain risk; hamstring graft slower strength recovery; quad tendon emerging; (6) **Re-injury**: 15-30% within 2 yr; ACL-RSI predicts; girls/younger higher risk; (7) **Prevention** programs (FIFA 11+, Sportsmetrics) for prevention contralateral + future; (8) **Multidisciplinary**: surgeon + PT + athletic trainer + psych + coach; **Modern**: criteria-based + psychological + biomechanics + injury prevention

---

ACL RTS: ≥9-12 mo + objective criteria. LSI ≥90% strength + hop tests. Movement quality (DVJ, LESS). PROs + ACL-RSI psychological. Phased program. 15-30% reinjury. Prevention programs. Multidisciplinary.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'rehab_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AOSSM; APTA ACL Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'นักกีฬาฟุตบอลอายุ 22 ปี ACL reconstruction (BPTB autograft) 6 mo post-op — ต้องการ return-to-sport'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'นักกีฬาวิ่งระยะยาวอายุ 28 ปี — chronic exertional medial tibial pain — running progression issues', '[{"label":"A","text":"Increase mileage 50% next week"},{"label":"B","text":"Medial Tibial Stress Syndrome (Shin Splints) — Rehabilitation"},{"label":"C","text":"Surgical fasciotomy first-line"},{"label":"D","text":"Casting 6 wk"},{"label":"E","text":"Discharge no PT"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Medial Tibial Stress Syndrome (Shin Splints) — Rehabilitation: (1) **Diagnosis**: diffuse medial tibial pain along posteromedial border (distal 2/3) during/after activity; tender to palpation > 5 cm linear; exclude stress fracture (focal point tenderness + bone scan/MRI), compartment syndrome (compartmental pressure), tendinopathy; (2) **Risk factors**: training error (volume + intensity + surface change), foot mechanics (overpronation, pes planus), BMI/sex (female), bone density, calcium/vit D, prior MTSS; (3) **Management**: - **Activity modification**: reduce volume + intensity, cross-train (cycling, swimming, pool running) maintain CV; - **Progressive loading return**: pain-guided gradual; - **Strengthening**: tibialis posterior, intrinsic foot, hip abductors + ext rotators (kinetic chain); - **Stretching**: calf complex; - **Footwear**: appropriate, replace > 500-800 km; - **Orthotics**: arch support for overpronation; - **Modalities**: ice, NSAIDs short-term, ESWT selected; (4) **Address training error** + periodization; (5) **Bone health**: vit D, Ca, female athlete triad/RED-S screen (energy deficiency, menstrual, bone); (6) **Imaging**: MRI ถ้า refractory or suspect stress fx; (7) **Prevention**: gradual progression (10% rule), strengthening, recovery; (8) **Multidisciplinary**: sports med + PT + athletic trainer + nutritionist; **Modern**: kinetic chain + load management + bone health

---

MTSS: diffuse posteromedial tibial pain. R/o stress fx. Risk: training error + mechanics + bone. Tx: load mgmt + cross-train + strengthen kinetic chain + footwear. Bone health (RED-S). Periodization.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'rehab_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'BJSM; AMSSM Sports Med', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'นักกีฬาวิ่งระยะยาวอายุ 28 ปี — chronic exertional medial tibial pain — running progression issues'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'นักกีฬาเทนนิสอายุ 35 ปี chronic lateral elbow pain 6 mo (tennis elbow) — failed initial Tx', '[{"label":"A","text":"Corticosteroid injection — repeated"},{"label":"B","text":"Chronic Lateral Epicondylopathy"},{"label":"C","text":"Casting 3 mo"},{"label":"D","text":"Surgical release first-line"},{"label":"E","text":"Discharge — wait years"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic Lateral Epicondylopathy: (1) **Pathology**: degenerative tendinopathy of ECRB (Extensor Carpi Radialis Brevis) origin — NOT inflammation ("tendinosis"); (2) **Assessment**: pain over lateral epicondyle + tender + provocative (resisted wrist ext, Cozen, Mill, middle finger ext); PROs (PRTEE); imaging (US, MRI) ถ้า atypical; (3) **Conservative (mainstay)**: - **Wait + watch** (often self-limited 12-18 mo); - **Activity modification**: equipment (grip size, racquet stiffness), technique (shot mechanics) — sports med specialist + coach; - **PT**: eccentric strengthening (Tyler twist w/ Theraband), heavy slow resistance, scapular kinetic chain, wrist extensor stretch + grip; - **Counterforce brace** (forearm strap); - **Topical NSAID**, modalities; (4) **Injections**: - **Corticosteroid**: short-term pain relief but worse 6-12 mo outcomes (Coombes JAMA) — avoid; - **PRP**: emerging evidence in tendinopathy; - **Autologous blood, prolotherapy**: limited evidence; - **Anesthetic dry needling**, tenotomy; (5) **ESWT**: evidence supportive; (6) **Surgical**: refractory > 6-12 mo conservative — tenotomy/debridement; (7) **Address kinetic chain**: shoulder + core + technique; **Modern**: eccentric loading + sports tech analysis + biologic options

---

Lateral epicondylopathy: degenerative tendinopathy (not inflammation). Eccentric load (Tyler twist) + kinetic chain + technique + equipment. AVOID repeated corticosteroid (worse long-term). PRP/ESWT options. Surgery refractory.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'rehab_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAOS; Coombes JAMA 2013', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'นักกีฬาเทนนิสอายุ 35 ปี chronic lateral elbow pain 6 mo (tennis elbow) — failed initial Tx'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'นักกีฬาบาสเกตบอล grade 2 ankle sprain (lateral) — 2 wk post-injury — สามารถ partial weight bear ได้', '[{"label":"A","text":"Cast immobilization 6 wk"},{"label":"B","text":"Ankle Sprain Functional Rehabilitation"},{"label":"C","text":"Bedrest 4 wk"},{"label":"D","text":"Discharge no PT"},{"label":"E","text":"Surgical first-line"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ankle Sprain Functional Rehabilitation: (1) **Grading**: Gr 1 (stretch), Gr 2 (partial tear), Gr 3 (complete); (2) **Acute phase**: POLICE/PEACE & LOVE (Protection, Optimal Loading, Ice, Compression, Elevation, then Education + load); early mobilization > immobilization (functional bracing > rigid cast); (3) **Subacute rehab progression**: - **ROM** restoration; - **Strengthening**: peroneal (eversion w/ Theraband), DF/PF/inv, intrinsic; - **Proprioception/balance** (KEY!) wobble board, single-leg, BAPS, perturbation — reduces re-injury; - **Functional drills**: walking → jogging → cutting → sport-specific; - **Plyometrics** + agility; (4) **Return-to-sport criteria**: pain-free, full ROM, strength symmetric, proprioception restored, sport-specific testing (hop, cutting); (5) **External support**: brace/tape during return + high-risk activities; (6) **Re-injury prevention**: continued proprioceptive program — chronic ankle instability common (40%) if inadequate rehab; (7) **Chronic ankle instability**: persistent giving way → consider lateral ankle reconstruction (Brostrom); (8) **PROs**: FAAM, CAIT; (9) **Address kinetic chain**: hip strength, core; (10) **Imaging**: MRI ถ้า refractory; **Modern**: early mobilization + proprioception + functional return

---

Ankle sprain: early mobilization + proprioception (KEY) + functional progression. CAI common if undertreated. Brace return. Brostrom for chronic. FAAM/CAIT. Kinetic chain. Modern functional rehab.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'rehab_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'BJSM Ankle Consensus 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'นักกีฬาบาสเกตบอล grade 2 ankle sprain (lateral) — 2 wk post-injury — สามารถ partial weight bear ได้'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'นักวิ่ง marathon อายุ 30 ปี — patellofemoral pain syndrome (PFPS) 3 mo — bilateral', '[{"label":"A","text":"Quad-only strengthening"},{"label":"B","text":"Patellofemoral Pain Syndrome (PFPS) — Multimodal"},{"label":"C","text":"Knee brace continuous"},{"label":"D","text":"Surgical release first-line"},{"label":"E","text":"Complete rest 3 mo"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Patellofemoral Pain Syndrome (PFPS) — Multimodal: (1) **Diagnosis**: anterior knee pain w/ loading (stairs, squat, prolonged sitting — "theater sign"); R/o other causes (chondromalacia, patellar tendinopathy, ITB, meniscus); (2) **Multifactorial**: hip weakness (abductors + ext rotators — KEY), quad imbalance (VMO), foot mechanics (overpronation), training load, malalignment; (3) **Evidence-based Tx (BJSM consensus)**: - **Exercise therapy** combined hip + knee (strong evidence): hip strengthening (glute med, ext rotators — clamshells, single-leg bridges, side-stepping) + quad strengthening (closed-chain, eccentric); - **Gait retraining**: increase cadence, reduce overstride, address valgus collapse; - **Patellar taping** (McConnell) short-term; - **Foot orthoses** for overpronation; - **Manual therapy** adjunct; (4) **Load management**: temporarily reduce volume + intensity, cross-train; (5) **Avoid**: passive treatments alone, prolonged rest; (6) **Surgical**: rarely indicated PFPS; (7) **Education**: pathophysiology + self-management + load management; (8) **PROs**: AKPS (Kujala), Lower Extremity Functional Scale; (9) **Return-to-run progression** when symptom-controlled; **Modern**: hip-focused + gait retraining + load management

---

PFPS: multifactorial — hip > knee. Combined hip + knee exercise (strong evidence). Gait retraining. Foot orthoses selective. Load management. PROs AKPS. Avoid quad-only, prolonged rest, early surgery.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'rehab_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'BJSM PFP Consensus 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'นักวิ่ง marathon อายุ 30 ปี — patellofemoral pain syndrome (PFPS) 3 mo — bilateral'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'นักกีฬาอายุ 19 ปี diagnosed Female Athlete Triad / RED-S — endurance runner', '[{"label":"A","text":"Continue training — push through"},{"label":"B","text":"Relative Energy Deficiency in Sport (RED-S) — Multidisciplinary"},{"label":"C","text":"Ignore menstrual changes"},{"label":"D","text":"Increase training volume"},{"label":"E","text":"Hormone replacement only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Relative Energy Deficiency in Sport (RED-S) — Multidisciplinary: (1) **Definition** (IOC 2014, update 2018, 2023): syndrome from low energy availability — broader than Triad; affects multiple systems (menstrual, bone, immune, cardiovascular, GI, metabolic, hematological, psychological) + performance; (2) **Female Athlete Triad**: low energy availability + menstrual dysfunction + low BMD; (3) **Assessment**: - Energy availability calc (kcal/kg FFM/day, < 30 risk); - Menstrual history; - DEXA bone density (Z-score, hx fractures, stress fx); - Labs: hormonal (LH, FSH, estradiol, T3, cortisol, IGF-1), iron, vit D; - ECG (cardiac risk); - Mental health (eating disorder, depression, anxiety) — DSM-5; (4) **Stratification** + RED-S Risk Assessment Tool (red/yellow/green); (5) **Management — multidisciplinary**: - Sports medicine physician; - Sports dietitian (increase energy availability — goal); - Mental health/psychology + eating disorder specialist; - Endocrinology if hormonal; - Coach + family education; (6) **Treatment**: - Increase energy availability (food intake or decrease training); - Treat eating disorder if present; - Bone health (Ca + vit D + weight-bearing + medication selected); - Hormonal therapy controversial — address root cause first; (7) **Training modification** + return-to-sport when criteria met; (8) **Long-term** monitoring; **Modern**: RED-S framework + multidisciplinary + early identification

---

RED-S: low energy availability syndrome. Triad component. Multidisciplinary — sports med + dietitian + mental health + endocrine + coach. Address EA first. Bone + ED + hormones. RED-S risk tool.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'rehab_medicine', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'IOC RED-S 2023; ACSM/AMSSM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'นักกีฬาอายุ 19 ปี diagnosed Female Athlete Triad / RED-S — endurance runner'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'นักว่ายน้ำอายุ 24 ปี — chronic shoulder pain 4 mo (swimmer''s shoulder) — high volume training', '[{"label":"A","text":"Continue same volume"},{"label":"B","text":"Swimmer''s Shoulder — Rehabilitation"},{"label":"C","text":"Surgical decompression first"},{"label":"D","text":"Casting 6 wk"},{"label":"E","text":"Stop swimming forever"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Swimmer''s Shoulder — Rehabilitation: (1) **Etiology multifactorial**: overuse + repetitive overhead; impingement (subacromial + internal posterior — GIRD), RC tendinopathy + tears (selectively), labral pathology, instability (multidirectional common swimmers), scapular dyskinesis, stroke mechanics, training error; (2) **Assessment**: comprehensive — ROM (GIRD: glenohumeral internal rotation deficit), strength (RC + scapular + core), stability, impingement signs, kinetic chain, stroke analysis (coach + video); (3) **Treatment**: - **Activity modification**: temporarily reduce yardage + intensity, cross-train, technique (stroke mechanics — coach); - **PT**: rotator cuff + scapular stabilizer strengthening (serratus, lower trap), posterior capsule stretching (sleeper stretch, cross-body), kinetic chain (hip/core), eccentric loading for tendinopathy; - **Stroke modification**: early vertical forearm, body rotation, breathing pattern, distance per stroke; - **Modalities**: ice, NSAIDs short-term; - **Injection** (subacromial) selected; (4) **Address instability** w/ stability program + brace selected; (5) **Prevention** integrated: prehab, periodization, recovery; (6) **Return-to-swim progression**: pain-free + criteria-based; (7) **PROs**: KJOC, ASES; (8) **Multidisciplinary**: sports med + PT + athletic trainer + coach + dietitian; **Modern**: stroke biomechanics + kinetic chain + load management

---

Swimmer''s shoulder: multifactorial — impingement + RC + GIRD + scapular + instability + stroke. Activity modification + RC/scapular strengthening + posterior capsule stretch + stroke analysis. Multidisciplinary.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'rehab_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAOS; FINA Sports Med', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'นักว่ายน้ำอายุ 24 ปี — chronic shoulder pain 4 mo (swimmer''s shoulder) — high volume training'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 5 ปี cerebral palsy bilateral spastic — GMFCS III — เดินด้วย walker — multidisciplinary care plan', '[{"label":"A","text":"Single-discipline PT only"},{"label":"B","text":"CP GMFCS III — Comprehensive Rehab"},{"label":"C","text":"Surgery first-line"},{"label":"D","text":"Discharge — no intervention"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** CP GMFCS III — Comprehensive Rehab: (1) **GMFCS classification** I-V (Gross Motor Function Classification System) — Level III: walks w/ handheld mobility device, may use wheels for community; functional severity-stratified care; (2) **Functional outcomes** (GMFM-66, GMFM-88): trajectory + intervention monitoring; ≥95% reach motor potential by age 6-7 (Rosenbaum trajectories); (3) **Multidisciplinary team**: pediatrician + physiatrist + orthopaedist + neurologist + PT + OT + SLP + special education + social work + family + ortotist; (4) **Spasticity management**: - **PT**: stretching + strengthening + functional training; - **Orthotics**: AFO common (rigid, articulated, GRF) for foot drop + crouch + stability; - **Oral antispasticity**: baclofen, tizanidine, diazepam — sedation limit; - **Focal — BoNT-A**: targeted (gastrocnemius, hamstrings, hip adductors, biceps) — improves function + delays surgery; max dose by weight; - **Generalized — intrathecal baclofen (ITB) pump**: severe spasticity affecting function; - **Selective Dorsal Rhizotomy (SDR)**: selected ambulators (typically GMFCS II-III, age 3-8, good cognition); (5) **Orthopaedic**: hip surveillance (radiograph yearly — hip displacement risk), tendon lengthening, multilevel single-event surgery, scoliosis; (6) **OT**: ADLs, UE function, adaptive equipment, school; (7) **SLP**: dysarthria, AAC if needed, feeding; (8) **Education**: school IEP, accessibility, peer interaction; (9) **Family + caregiver education + respite**; (10) **Long-term transition** to adult care; **Modern**: family-centered + GMFCS-stratified + technology-enhanced

---

CP GMFCS III: stratified care. Multidisciplinary. Spasticity (BoNT, ITB, SDR), orthotics (AFO), hip surveillance, ortho selected. Family-centered. Long-term transition. GMFM outcomes.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'peds',
  'Rosenbaum GMFCS; AACPDM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'เด็กชายอายุ 5 ปี cerebral palsy bilateral spastic — GMFCS III — เดินด้วย walker — multidisciplinary care plan'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กอายุ 2 ปี global developmental delay — มี hypotonia + motor delay — family wants early intervention', '[{"label":"A","text":"Wait until school age"},{"label":"B","text":"Early Intervention for Developmental Delay"},{"label":"C","text":"Single discipline only"},{"label":"D","text":"No therapy — observe"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Early Intervention for Developmental Delay: (1) **Assessment**: comprehensive developmental (Bayley III, Mullen, AIMS) across domains (motor, cognitive, language, social-emotional, adaptive); medical workup for etiology (genetic, metabolic, neuroimaging selected); hearing + vision; (2) **Etiology workup**: history (prenatal, perinatal, postnatal), family hx, exam (dysmorphology, neuro), genetic (chromosomal microarray first-tier, FXS, WES selected), metabolic (selected), EEG, MRI as indicated; (3) **Early Intervention Programs** (Part C IDEA USA; equivalent local systems): - Birth to 3 yr; - IFSP (Individualized Family Service Plan); - Home- + community-based; - Family-centered + coaching model; - Multidisciplinary: PT + OT + SLP + early childhood educator + social work + nursing; (4) **Specific interventions**: - PT: gross motor, postural control, mobility; - OT: fine motor, sensory, ADL, feeding; - SLP: language, communication, AAC if severe; - Behavioral; (5) **Family education + coaching**: empower parents — interactions, routines-based intervention; (6) **Transition to school**: at age 3 to IEP (special education); (7) **Address comorbidities**: seizures, sleep, GI, feeding, behavioral; (8) **Specialist referrals**: pediatric neurology, genetics, GI, dev-behavioral pediatrics; (9) **Equipment + AT**: adaptive seating, mobility, communication; (10) **Long-term monitoring** + family support; **Modern**: family-centered + coaching + routines-based + early neuroplasticity

---

Early intervention dev delay: comprehensive assessment + etiology workup + EI program (IFSP, family-coaching, multidisciplinary). Specific therapy. Family-centered. Transition to IEP. Long-term monitoring.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'peds',
  'AAP; IDEA Part C', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'เด็กอายุ 2 ปี global developmental delay — มี hypotonia + motor delay — family wants early intervention'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กอายุ 8 ปี Duchenne muscular dystrophy — ambulatory แต่เริ่มมี Gowers sign + frequent falls', '[{"label":"A","text":"Aggressive eccentric exercise"},{"label":"B","text":"Duchenne Muscular Dystrophy — Rehab + Multidisciplinary"},{"label":"C","text":"No corticosteroid"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Discharge no follow-up"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Duchenne Muscular Dystrophy — Rehab + Multidisciplinary: (1) **Multidisciplinary care** (DMD Care Considerations Group): neuromuscular specialist + cardiology + pulmonology + ortho + physiatry + PT + OT + endocrine + GI/nutrition + psychiatry + social work + family; (2) **Stage-based management** (early ambulatory, late ambulatory, early non-ambulatory, late non-ambulatory): (3) **Physical therapy**: - Stretching daily (heel cords, hamstrings, hip flexors, ITB) prevent contractures; - Submaximal aerobic + functional activity; - AVOID eccentric + maximal eccentric exercise (damage); - Aquatic therapy; (4) **Orthotics**: night AFO/KAFO to preserve ROM; daytime as needed; (5) **Mobility + equipment**: power w/c when ambulation lost (typically 8-13 yr); standing program (standing frame); adaptive seating; (6) **Pharmacology**: - **Corticosteroids** (prednisone, deflazacort) — slow disease progression, prolong ambulation, preserve cardiac/pulm; SE managed; - **Exon-skipping** (eteplirsen, golodirsen, viltolarsen — exon 51/53/45 specific); - **Givinostat** (HDAC inhibitor); - **Gene therapy** (delandistrogene moxeparvovec — emerging); - **Vamorolone** alternative steroid; (7) **Cardiac**: ACEi/ARB + BB starting age 10 + MRI; (8) **Pulmonary**: PFT serial, cough assist, NIV when nocturnal hypoventilation; (9) **Scoliosis surgery** selectively; (10) **Bone health, GI, psychosocial**; (11) **Transition to adult care**; **Modern**: emerging genetic + comprehensive care extends lifespan

---

DMD multidisciplinary stage-based. Stretching + submax exercise + AVOID eccentric. Corticosteroid slow progression. Exon-skipping + gene therapy emerging. Cardiac/pulm proactive. Long-term + transition.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'peds',
  'DMD Care Considerations 2018-2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'เด็กอายุ 8 ปี Duchenne muscular dystrophy — ambulatory แต่เริ่มมี Gowers sign + frequent falls'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กอายุ 4 ปี autism spectrum disorder — referred for rehab — motor + sensory + communication concerns', '[{"label":"A","text":"Single-discipline behavioral only"},{"label":"B","text":"ASD Multidisciplinary Rehab"},{"label":"C","text":"Antipsychotic alone — no behavioral"},{"label":"D","text":"Discharge no intervention"},{"label":"E","text":"Heavy sedation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ASD Multidisciplinary Rehab: (1) **Comprehensive assessment**: developmental + behavioral (ADOS-2 diagnostic), cognitive (Mullen/WPPSI), language (REEL, CELF), motor (BOT, M-ABC), sensory (Sensory Profile), adaptive (Vineland); medical (genetic, metabolic selected); (2) **Comorbidities**: ID, ADHD, anxiety, seizures, GI, sleep, feeding, motor coordination disorder; (3) **Evidence-based interventions**: - **Behavioral** (NDBI — naturalistic developmental behavioral interventions; ESDM, JASPER, PRT, ABA-based) — strong evidence; - **Speech-language therapy** + AAC (PECS, devices) if non-verbal; - **OT**: sensory integration (selected), fine motor, ADLs; - **PT**: gross motor coordination, postural; - **Social skills training**; - **Parent-mediated** + parent training; (4) **Educational**: IEP, structured teaching (TEACCH), inclusion + supports; (5) **Pharmacotherapy** (targeted symptoms — not ASD core): risperidone/aripiprazole for irritability (FDA-approved), stimulants for ADHD, SSRI for anxiety, melatonin for sleep; (6) **Medical comorbidities**: GI (constipation common), sleep, feeding (selective eating), seizures; (7) **Family education + support**: respite, peer, advocacy; (8) **Transition planning** (school + adult); (9) **Caregiver mental health**; **Modern**: NDBI + family-centered + neurodiversity-affirming + targeted comorbidity

---

ASD multidisciplinary: NDBI (ESDM, JASPER) strong evidence + SLP + OT + PT + social skills + parent-mediated. Educational. Targeted pharma for comorbidity. Family support. Modern: neurodiversity-affirming.', NULL,
  'medium', 'psych_behavior', 'review',
  'rehab_medicine', 'clinical_decision', 'psych_behavior', 'peds',
  'AAP; ACOG ASD Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'เด็กอายุ 4 ปี autism spectrum disorder — referred for rehab — motor + sensory + communication concerns'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กอายุ 12 ปี spina bifida (myelomeningocele) thoracic-level — multidisciplinary transition + bladder/bowel', '[{"label":"A","text":"Single discipline"},{"label":"B","text":"Spina Bifida Comprehensive Care"},{"label":"C","text":"No bladder management — wait incontinence"},{"label":"D","text":"Latex products fine"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Spina Bifida Comprehensive Care: (1) **Multidisciplinary clinic** (gold standard): pediatric urology + neurosurgery + orthopaedics + physiatry + PT + OT + nursing + social work + nutrition + psychology + family; (2) **Neurogenic bladder**: CIC + anticholinergic/β3 + monitor upper tract (renal US, urodynamics); preserve renal function — leading cause mortality historically; SPT/augmentation selected; (3) **Neurogenic bowel**: bowel program (timing, stimulation, suppositories, enemas — antegrade continence enema via cecostomy/MACE selected), high-fiber, fluids; (4) **Hydrocephalus + Chiari II**: shunt monitoring + neurosurgery follow-up; symptoms (HA, vomiting, neuro decline, vision); (5) **Mobility**: thoracic level → wheelchair primary, standing programs (parapodium, KAFO), upper limb propulsion + shoulder preservation; (6) **Orthopaedic**: scoliosis (high rate thoracic level), hip + knee deformity, foot deformity, fractures (low BMD); (7) **Skin**: pressure injury prevention (insensate), daily checks, equipment fit; (8) **Latex allergy** — high prevalence — latex-free environment; (9) **Cognitive**: executive function issues common ("cocktail party syndrome"), neuropsych eval, school IEP; (10) **Sexual + reproductive** (adolescent/adult): counseling, fertility, pregnancy planning; (11) **Transition to adult care** (age 18-21) — challenging; (12) **Family + advocacy**; **Modern**: SBA (Spina Bifida Association) care guidelines + lifespan integrated

---

Spina bifida: multidisciplinary clinic. Neurogenic bladder (CIC + monitor) + bowel + hydrocephalus + Chiari + mobility + scoliosis + skin + latex allergy + cognitive + sexual + transition. Family.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'peds',
  'Spina Bifida Association Guidelines 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'เด็กอายุ 12 ปี spina bifida (myelomeningocele) thoracic-level — multidisciplinary transition + bladder/bowel'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กอายุ 6 ปี post-pediatric brain tumor (medulloblastoma) — completed chemo/radiation — multiple deficits', '[{"label":"A","text":"No follow-up — survived"},{"label":"B","text":"Pediatric Cancer Survivorship Rehab"},{"label":"C","text":"Single discipline"},{"label":"D","text":"Discharge to PCP only"},{"label":"E","text":"Avoid school"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Cancer Survivorship Rehab: (1) **Multidisciplinary**: oncology + physiatrist + PT + OT + SLP + neuropsychology + endocrinology + audiology + ophthalmology + social work + education + family; (2) **Late effects screening + management**: - **Neurocognitive**: chemo/radiation effects — attention, processing speed, memory, executive; neuropsych eval; cognitive rehab + school IEP/504 + accommodations; - **Motor + balance**: ataxia, weakness, neuropathy (vincristine), spasticity — PT + OT; - **Endocrinopathies**: GH deficiency (growth failure — GH replacement), hypothyroidism, gonadal failure — endocrine screen + treat; - **Cardiotoxicity** (anthracycline): echo + ECG surveillance; - **Hearing loss** (platinum agents, radiation): audio + hearing aids; - **Vision** (radiation): ophthalmology; - **Secondary malignancy** risk: surveillance; - **Fertility** future considerations; - **Psychosocial**: PTSD, anxiety, depression, social difficulties; family adjustment; (3) **School reintegration**: gradual + accommodations + IEP/504 + teacher education; (4) **Survivorship clinic + lifelong follow-up** (COG LTFU guidelines); (5) **Patient + family education + advocacy + peer support**; (6) **Adaptive PE + recreation**; (7) **Health behaviors**: nutrition, exercise, no tobacco, sun protection; (8) **Transition to adult survivorship care**; **Modern**: COG Long-Term Follow-Up Guidelines + survivorship clinics + integrated rehab

---

Pediatric cancer survivorship rehab: multidisciplinary late-effects (neurocognitive, motor, endocrine, cardiotoxicity, hearing, vision, secondary malignancy, fertility, psychosocial). School + survivorship clinic. COG guidelines.', NULL,
  'hard', 'hemato_onco', 'review',
  'rehab_medicine', 'clinical_decision', 'hemato_onco', 'peds',
  'COG LTFU Guidelines; Children''s Oncology Group', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'เด็กอายุ 6 ปี post-pediatric brain tumor (medulloblastoma) — completed chemo/radiation — multiple deficits'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กอายุ 3 ปี — brachial plexus birth palsy — no recovery elbow flexion at 6 mo of age', '[{"label":"A","text":"Wait years for surgery"},{"label":"B","text":"Obstetric Brachial Plexus Palsy (OBPP) — Multidisciplinary"},{"label":"C","text":"No therapy needed"},{"label":"D","text":"Discharge"},{"label":"E","text":"Bedrest"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Obstetric Brachial Plexus Palsy (OBPP) — Multidisciplinary: (1) **Classification**: - Erb''s (C5-C6): waiter''s tip; - Extended Erb''s (C5-C7); - Klumpke (C8-T1) rare; - Total (C5-T1) + possible Horner''s; (2) **Prognosis**: ~80% recovery by 1 yr; but absent biceps recovery by 3 mo (Gilbert) or 6 mo (Waters) → poor — consider microsurgical reconstruction; (3) **Multidisciplinary team**: physiatry + neurosurgery/plastic + ortho + PT + OT + nursing + family; (4) **Early management** (birth to 3 mo): - PROM gentle: shoulder, elbow, forearm, wrist (parents trained); - Avoid pulling/stretching forcefully; - Positioning to prevent contractures + skin care; (5) **Assessment**: Active Movement Scale (AMS), Mallet (functional), Toronto Test Score, ROM, sensory; (6) **Microsurgery indication** (3-9 mo age): nerve graft + nerve transfer; outcomes best early; (7) **Secondary surgery** (1+ yr): muscle transfers, joint releases, tendon transfers for residual deformity; (8) **PT/OT**: ROM + strengthening + bimanual function + sensory + functional/ADL; (9) **Botulinum toxin** for muscle imbalance (e.g., subscapularis for shoulder internal rotation contracture); (10) **Joint surveillance**: shoulder (glenohumeral dysplasia from imbalance), elbow, forearm; (11) **Long-term**: school + adult function; family + child education; **Modern**: early multidisciplinary + microsurgery + neuromuscular reeducation

---

OBPP: classify (Erb most common). 80% recover but no biceps by 3-6 mo → microsurgery candidate. AMS/Mallet. Early PT/OT + PROM + family training. Microsurgery + secondary procedures. Joint surveillance.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'peds',
  'AAOS OBPP; Waters/Gilbert', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'เด็กอายุ 3 ปี — brachial plexus birth palsy — no recovery elbow flexion at 6 mo of age'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 62 ปี post-MI + PCI 1 wk — phase II cardiac rehab + exercise prescription', '[{"label":"A","text":"Maximum intensity immediately"},{"label":"B","text":"Cardiac Rehab Phase II Exercise Prescription"},{"label":"C","text":"Bedrest 6 mo"},{"label":"D","text":"Single session only"},{"label":"E","text":"Anaerobic high-intensity only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cardiac Rehab Phase II Exercise Prescription: (1) **Pre-program evaluation**: Symptom-limited CPET (cardiopulmonary exercise test) — VO2 peak, anaerobic threshold (AT/VT1), heart rate (HR), BP, ECG, symptoms — gold standard for prescription; alternative submaximal (modified Bruce, 6MWT); (2) **Exercise prescription (FITT-VP)**: - **Frequency**: 3-5 sessions/wk (supervised + home); - **Intensity**: 40-80% HRR (Karvonen) or VO2 reserve; RPE 11-14 (Borg 6-20); or HR at AT; aim moderate-vigorous; - **Time**: 20-60 min aerobic + 5-10 min warm-up/cool-down; resistance 1-3 sets × 10-15 reps; - **Type**: aerobic (treadmill, cycle, elliptical, walking) + resistance (after 2-3 wk Phase II) + flexibility; - **Volume + Progression**: gradual; (3) **Monitoring**: continuous ECG initial sessions, BP, symptoms, RPE; (4) **Resistance training**: 1-3 sets, 8-15 reps, RPE 11-13, avoid Valsalva; (5) **Risk stratification** (low/moderate/high) — guides monitoring + supervision; (6) **Patient education**: meds, signs/symptoms, when to call, lifestyle; (7) **HIIT**: emerging evidence improves VO2 vs MICT — selected patients; (8) **Psychosocial + smoking cessation + dietary**; (9) **Outcomes**: VO2 peak, MET capacity, HR-rate response, BP, PROs; **Modern**: CPET-guided + HIIT + technology

---

Cardiac rehab Phase II: pre CPET + FITT-VP prescription. 40-80% HRR, RPE 11-14, 20-60 min, 3-5×/wk. Aerobic + resistance + flexibility. Risk stratify + monitor. HIIT emerging. Psychosocial + lifestyle.', NULL,
  'medium', 'cardiovascular', 'review',
  'rehab_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'AACVPR; AHA Cardiac Rehab', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 62 ปี post-MI + PCI 1 wk — phase II cardiac rehab + exercise prescription'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย HFrEF (EF 30%) NYHA III — referred cardiac rehab', '[{"label":"A","text":"No exercise — too dangerous"},{"label":"B","text":"HF Cardiac Rehab — HF-ACTION Lessons"},{"label":"C","text":"Maximum intensity always"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** HF Cardiac Rehab — HF-ACTION Lessons: (1) **HF-ACTION trial**: safe + modestly effective in HFrEF (trend mortality reduction, improved QOL + exercise capacity); cardiac rehab Class I HFrEF NYHA II-III on GDMT; (2) **Evaluation**: clinical status (stable + euvolemic), CPET, echo + functional status; coordinate w/ HF team; (3) **Exercise prescription**: - Aerobic: 60-70% HRR or RPE 11-13; intervals selected; 30-40 min; 3-5×/wk; - Resistance: low-mod intensity, 1-2 sets, avoid Valsalva; - Progress gradually; - Inspiratory muscle training (IMT) adjunct evidence; (4) **GDMT optimization** (4 pillars HFrEF): ARNI/ACEi/ARB + BB + MRA + SGLT2i; up-titrate before/during rehab; (5) **Monitoring**: weight (daily home), symptoms (DOE, edema, fatigue), HR, BP, ECG; recognize decompensation; (6) **Patient education**: HF (low-Na diet, fluid restriction, daily weights), meds, signs/symptoms (when call), self-care; (7) **Comorbidities**: DM, CKD, AF, COPD — addressed; (8) **Psychosocial**: depression (high in HF), anxiety, social — CBT, screen + treat; (9) **Devices**: ICD, CRT, LVAD — modifications; (10) **Advance care planning**: appropriate stage; (11) **Outcomes**: VO2, 6MWT, QOL (KCCQ, MLHFQ), hospitalization; **Modern**: home-based + telerehab + GDMT integration + HFpEF emerging evidence

---

HFrEF cardiac rehab Class I (HF-ACTION). CPET-guided 60-70% HRR. Aerobic + resistance (low Valsalva). IMT adjunct. GDMT 4 pillars optimization. Monitor decompensation. Psychosocial. Modern: home/telerehab.', NULL,
  'medium', 'cardiovascular', 'review',
  'rehab_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'HF-ACTION; AHA/ACC HF Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย HFrEF (EF 30%) NYHA III — referred cardiac rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย post-CABG 2 wk — sternotomy precautions + Phase I/II transition', '[{"label":"A","text":"No precautions immediately"},{"label":"B","text":"Post-Sternotomy Precautions + Phase I/II"},{"label":"C","text":"Bedrest 6 wk"},{"label":"D","text":"Full lifting day 1"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-Sternotomy Precautions + Phase I/II: (1) **Sternotomy precautions** (vary by institution but typical 6-8 wk): - No lifting > 5-10 lb; - No pushing/pulling heavy; - No driving 4-6 wk; - Avoid arms overhead aggressive; - No pulling self up using arms (use "snake-out" technique — log roll + use legs); - Cough w/ pillow splint; - Maintain incision care; (2) "Move in the Tube" / "Keep Your Move in the Tube" emerging — less restrictive, allows functional UE within pain-free arc; evidence supports earlier UE use w/o sternal complications; (3) **Phase I (inpatient)**: early mobilization, education, IS use, gradual ambulation, family education; (4) **Phase II (outpatient)**: structured exercise, risk factor modification, education, psychosocial; (5) **Exercise prescription**: see standard cardiac rehab; modifications during sternotomy healing phase (UE limited initially); (6) **Wound care + monitoring**: sternal dehiscence (rare), infection (DM, obesity, smoking risk), arrhythmia (postop AF common); (7) **Pain management**: multimodal opioid-sparing; (8) **Psychosocial**: postop depression + cognitive changes (post-pump); (9) **Education**: meds (anticoagulation, antiplatelet, statin, BB, ACEi), lifestyle, when call physician; (10) **Long-term**: lifelong secondary prevention; **Modern**: ERAS cardiac + earlier mobilization + less restrictive precautions evidence

---

Post-CABG: sternal precautions 6-8 wk (no >5-10 lb, no heavy push/pull, snake-out, splint cough). "Tube" emerging less restrictive. Phase I→II. Monitor dehiscence/AF. Multimodal pain. Long-term prevention.', NULL,
  'medium', 'cardiovascular', 'review',
  'rehab_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'AACVPR; ERAS Cardiac', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย post-CABG 2 wk — sternotomy precautions + Phase I/II transition'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย post heart transplant 8 wk — cardiac rehab considerations', '[{"label":"A","text":"Use HR targets standard"},{"label":"B","text":"Heart Transplant Cardiac Rehab"},{"label":"C","text":"No exercise"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Discharge — no rehab"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Heart Transplant Cardiac Rehab: (1) **Unique physiology**: denervated heart — no vagal/sympathetic intrinsic response; resting HR elevated (90-110), slow rise + slow recovery w/ exercise; rely on circulating catecholamines (humoral); altered HR response — use RPE > HR target alone; (2) **Exercise prescription**: - **Use RPE primary** (11-14); - Extended warm-up + cool-down (slow HR adaptation); - Aerobic + resistance progressing; - Monitor signs/symptoms; (3) **Outcomes**: VO2 peak improves but blunted vs normal — typically 50-70% predicted; (4) **Medications + considerations**: - Immunosuppressants (calcineurin inhibitors — nephrotoxicity, HTN, DM; mycophenolate, prednisone), monitor SE; - Steroid effects (myopathy, osteopenia — resistance training important, bone health); - Antimicrobial prophylaxis; (5) **Rejection surveillance**: biopsy, echo, BNP; new symptoms → urgent eval; (6) **CV vasculopathy** (CAV — late complication): silent ischemia (denervated — no chest pain), screening; (7) **Infection precautions** during immunosuppression: handwashing, vaccinations (no live), exposure avoidance; (8) **Comorbidities**: HTN, DM, CKD, dyslipidemia — manage; (9) **Psychosocial**: post-transplant adjustment + survivor concerns + family + return to activity/work; (10) **Long-term**: malignancy risk + skin checks; **Modern**: cardiac rehab improves outcomes post-transplant + lifelong integration

---

Heart transplant rehab: denervated heart — use RPE, extended warm/cool, blunted VO2. Immunosuppression considerations + steroid SE + rejection + CAV + infection. Comorbidities. Psychosocial. Modern integrated.', NULL,
  'hard', 'cardiovascular', 'review',
  'rehab_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'ISHLT Rehab; AACVPR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย post heart transplant 8 wk — cardiac rehab considerations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย PAD intermittent claudication — referred supervised exercise therapy', '[{"label":"A","text":"Avoid exercise"},{"label":"B","text":"PAD Supervised Exercise Therapy (SET)"},{"label":"C","text":"Rest until pain-free always"},{"label":"D","text":"Single session"},{"label":"E","text":"Surgery first-line all"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** PAD Supervised Exercise Therapy (SET): (1) **Evidence**: SET first-line for IC — improves walking distance + QOL > meds + placebo; Class IA recommendation (AHA/ACC, ESC); CMS coverage for PAD SET (USA) since 2017; (2) **Protocol** (Gardner-Skinner type): - 3 sessions/wk × 12 wk supervised; - Treadmill walking — walk until moderate-severe claudication (3-4/5), rest until resolved, repeat; total 30-60 min including rest; - Gradual progression speed + grade; (3) **Mechanisms**: collateral development, mitochondrial/metabolic, endothelial, muscle adaptations, gait economy; (4) **Home-based** alternative: structured + monitored — emerging evidence comparable selected patients; (5) **Walking impairment** assessment: WIQ (Walking Impairment Questionnaire), treadmill (Gardner protocol — max walking distance MWD + pain-free PFD), 6MWT; (6) **CV risk reduction** (key): - Smoking cessation; - Statin (high-intensity); - Antiplatelet (aspirin or clopidogrel); - BP + DM control; - Mediterranean diet; - Vorapaxar/rivaroxaban selected; (7) **Revascularization** for severe/disabling — endovascular or open; (8) **Multidisciplinary**: vascular + PCP + cardiology + PT + dietitian; (9) **Foot care + ulcer prevention** in DM PAD; (10) **CLI/CLTI** — limb-threatening — urgent revascularization; **Modern**: SET + CV risk reduction integrated, home-based emerging

---

PAD: SET first-line Class IA (AHA/ACC). 3×/wk × 12 wk treadmill walk to claudication. CV risk reduction critical (statin, antiplatelet, smoking). Home-based emerging. Multidisciplinary. Foot care.', NULL,
  'easy', 'cardiovascular', 'review',
  'rehab_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'AHA/ACC PAD Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย PAD intermittent claudication — referred supervised exercise therapy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 78 ปี post-MI — frail + multimorbid — "too sick" for cardiac rehab? — referral question', '[{"label":"A","text":"Exclude — too frail"},{"label":"B","text":"Older + Frail Cardiac Rehab — Inclusion + Adaptation"},{"label":"C","text":"Standard prescription same as young"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Older + Frail Cardiac Rehab — Inclusion + Adaptation: (1) **Underutilization**: frail/older underrefferred despite benefit; equity gap; aim to INCLUDE w/ adaptations; (2) **Risk stratification** + comprehensive geriatric assessment: function (gait, balance, ADL), cognition, mood, sensory, polypharmacy, social; CFS (Clinical Frailty Scale), CHAMPS; (3) **Adapted exercise prescription**: - Lower starting intensity (40-60% HRR or RPE 9-11); - Shorter duration → progress; - Include balance + strength + flexibility (functional focus); - Tai Chi, chair-based, recumbent options; - Fall prevention integrated; (4) **Address contributors**: pain, sleep, depression, anemia, sarcopenia; (5) **Nutrition**: protein 1.2-1.5 g/kg + Mediterranean; (6) **Polypharmacy management**: Beers + STOPP/START + deprescribing; (7) **Cognitive + delirium prevention**; (8) **Multidisciplinary**: cardiology + geriatrics + physiatrist + PT + OT + dietitian + pharmacy + social work; (9) **Home-based + telerehab** options for transportation barriers; (10) **Goals of care + shared decision**: function, QOL focus; advance care planning; (11) **Caregiver involvement**; (12) **Outcomes**: function (SPPB, gait speed), QOL, falls; **Modern**: equity-focused inclusion + adaptations + integrated geriatric cardiology

---

Frail/older cardiac rehab: INCLUDE w/ adaptations. CGA. Lower starting intensity + functional focus + balance/strength + fall prevention. Address contributors + polypharmacy. Multidisciplinary. Telerehab. Equity.', NULL,
  'medium', 'cardiovascular', 'review',
  'rehab_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'AACVPR; AGS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 78 ปี post-MI — frail + multimorbid — "too sick" for cardiac rehab? — referral question'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย COPD GOLD III — mMRC 3 — referred pulmonary rehab', '[{"label":"A","text":"Single discipline only"},{"label":"B","text":"Pulmonary Rehabilitation — COPD"},{"label":"C","text":"Surgery first-line"},{"label":"D","text":"Discharge no rehab"},{"label":"E","text":"Bed rest"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pulmonary Rehabilitation — COPD: (1) **Evidence**: PR is Grade A recommendation for symptomatic COPD (mMRC ≥ 2 or post-exacerbation) — improves dyspnea, exercise capacity, QOL, reduces hospitalizations; cost-effective; underutilized; (2) **Indications**: COPD + other chronic respiratory (ILD, bronchiectasis, asthma, pulm HTN, lung Ca, pre/post lung transplant/resection); (3) **Pre-PR evaluation**: medical + exercise (6MWT or CPET) + PROs (CAT, mMRC, SGRQ); (4) **Exercise component (FITT-VP)**: - Aerobic: 60-80% peak (RPE 4-6/10 dyspnea); 20-60 min; 3-5×/wk; cycle/treadmill/walking; - Resistance: 1-3 sets, 8-15 reps, focus large muscle groups, RPE moderate; - Interval training: HIIT alternative — less dyspnea limitation; - Inspiratory Muscle Training (IMT) adjunct selected (low MIP); - Functional + balance; (5) **Duration**: 6-12 wk minimum + maintenance; (6) **Multidisciplinary**: respiratory therapist + PT + OT + nutrition + nurse + psychologist + physician; (7) **Education**: disease, meds (inhaler technique), oxygen, action plan, smoking cessation, nutrition; (8) **Psychosocial**: anxiety + depression screening + treatment; (9) **O2 supplementation** during exercise if desat (SpO2 < 88%); (10) **Smoking cessation** integrated; (11) **Post-exacerbation PR** especially effective; (12) **Home-based + tele-PR** alternatives for access; **Modern**: post-exacerbation + tele-PR + integrated chronic disease

---

PR for COPD: Grade A. Aerobic + resistance + IMT + functional. 6-12 wk. Multidisciplinary. Education + meds + O2 + smoking cessation + psychosocial. Post-exacerbation key. Tele-PR access. Modern integrated.', NULL,
  'easy', 'respiratory', 'review',
  'rehab_medicine', 'clinical_decision', 'respiratory', 'adult',
  'ATS/ERS PR Statement 2013, 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย COPD GOLD III — mMRC 3 — referred pulmonary rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย post-acute COVID-19 (long COVID) 4 mo — dyspnea + fatigue + exercise intolerance', '[{"label":"A","text":"Aggressive GET — push through symptoms"},{"label":"B","text":"Post-COVID-19 Rehabilitation"},{"label":"C","text":"No rehab — wait"},{"label":"D","text":"Bedrest 1 yr"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-COVID-19 Rehabilitation: (1) **Heterogeneous presentation**: pulmonary, cardiac (myocarditis, POTS), neurologic (cognitive, neuropathy), MSK (deconditioning, myopathy), psychiatric (anxiety, PTSD), autonomic, ME/CFS-like; (2) **Assessment**: comprehensive — cardiopulmonary (CPET, echo, PFT), neurocognitive, autonomic (tilt table, HUTT), MSK, psychosocial; rule out persistent organ damage; (3) **PESE (Post-Exertional Symptom Exacerbation)** screen — if present, AVOID standard graded exercise therapy (GET) — can worsen; use **pacing** + symptom-titrated activity; (4) **Pulmonary rehab elements**: breathing exercises (diaphragmatic, pursed-lip), aerobic if tolerated, IMT, education; (5) **Cardiac rehab elements**: for POTS — recumbent → upright progression (CHOP protocol), volume expansion (fluid + salt), compression, fludrocortisone/midodrine/IVA selected; (6) **Cognitive rehab**: external aids, paced cognitive activity, treat sleep + mood; (7) **PT**: graded mobility, strength, balance — SYMPTOM-TITRATED; (8) **Psychological**: CBT, ACT, mindfulness for symptom coping (not implying psychogenic); (9) **Sleep, nutrition, energy management**: pacing strategies, activity diary; (10) **Multidisciplinary clinic**: physiatry + pulm + cardio + neuro + psych + PT + OT + SLP + social work; (11) **Patient + family education + advocacy**: validate experience; (12) **Return-to-activity**: gradual + paced; return-to-sport criteria; **Modern**: PESE-aware + multidisciplinary post-COVID clinics + pacing

---

Post-COVID rehab: heterogeneous. SCREEN for PESE — avoid GET if present, use pacing. POTS protocols. Pulm + cardiac + cognitive + MSK + psych elements. Multidisciplinary clinic. Validate + family. Modern: pacing.', NULL,
  'hard', 'respiratory', 'review',
  'rehab_medicine', 'clinical_decision', 'respiratory', 'adult',
  'WHO Post-COVID; AAPM&R PASC', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย post-acute COVID-19 (long COVID) 4 mo — dyspnea + fatigue + exercise intolerance'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย post-lung transplant 6 wk — pulmonary rehab planning', '[{"label":"A","text":"No rehab post-transplant"},{"label":"B","text":"Post-Lung Transplant Pulmonary Rehab"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Maximum intensity immediately"},{"label":"E","text":"Discharge — wait rejection"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-Lung Transplant Pulmonary Rehab: (1) **Pre-transplant** "prehab": maintain exercise tolerance + nutrition + strength — predicts outcomes; (2) **Early post-transplant** (inpatient): mobilization day 1-2 if stable, IS, airway clearance, breathing exercises, gradual ambulation; (3) **Outpatient PR** (typically 4-12 wk post-transplant when stable): - Aerobic (treadmill, cycle); - Resistance — important due to steroid myopathy + critical illness; - IMT adjunct; - Education on meds + signs of rejection + infection; (4) **Exercise prescription**: HR less reliable (denervation, meds — use RPE); start moderate progress; monitor SpO2 + symptoms; (5) **Immunosuppression effects**: steroid myopathy + osteopenia (resistance training + Ca/vit D + bisphosphonate selected), DM, HTN, nephrotoxicity, infection risk; (6) **Rejection** surveillance (bronchoscopy + biopsy + PFTs) — patient watches for ↓SpO2, dyspnea, fever, FEV1 drop; (7) **CLAD/BOS** (chronic lung allograft dysfunction): ongoing concern — PR ongoing; (8) **Infection precautions** w/ immunosuppression: handwashing, vaccinations (no live), avoid exposure, mask in crowded; (9) **Psychosocial**: post-transplant adjustment, survivor concerns, family + return to work; (10) **Long-term**: lifelong PR + comprehensive care + skin cancer screening + malignancy risk; **Modern**: integrated transplant + rehab + tele-PR

---

Lung transplant PR: prehab + early mobilization + outpatient program. RPE-guided (denervation). Resistance for steroid myopathy. Immunosuppression considerations + rejection + CLAD/BOS + infection + psychosocial. Lifelong.', NULL,
  'hard', 'respiratory', 'review',
  'rehab_medicine', 'clinical_decision', 'respiratory', 'adult',
  'ISHLT; ATS/ERS PR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย post-lung transplant 6 wk — pulmonary rehab planning'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี post-acute respiratory failure ICU 3 wk — ICU-acquired weakness + delirium — transferring rehab', '[{"label":"A","text":"Bedrest 4 wk"},{"label":"B","text":"Post-ICU Rehab — ICU-Acquired Weakness + PICS"},{"label":"C","text":"Single discipline"},{"label":"D","text":"Discharge home no services"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-ICU Rehab — ICU-Acquired Weakness + PICS: (1) **Post-Intensive Care Syndrome (PICS)**: physical (ICU-AW — critical illness polyneuropathy + myopathy), cognitive impairment, psychiatric (anxiety, depression, PTSD); family — PICS-F; (2) **Assessment**: MRC sum score (muscle strength), 6MWT, FIM, neurocog (MoCA), HADS, IES-R (PTSD); pulmonary, swallow (high dysphagia rate post-intubation); (3) **Early mobilization in ICU** (prevention) — evidence + safe (TEAM RCT mixed, but generally beneficial w/ protocol); (4) **Rehab interventions**: - PT: progressive mobility (bed → edge → stand → ambulation), strengthening, endurance; - OT: ADLs + adaptive equipment; - SLP: swallow + voice (post-intubation) + cognitive; - RT: airway clearance, IS, IMT; - Nutrition: protein-rich, calorie adequate, address sarcopenia; - Cognitive rehab + sleep + mood + family; (5) **Delirium** ongoing management — environment, sleep, sensory, address meds, treat contributors; (6) **Pulmonary**: weaning trach, IMT, breathing exercises; (7) **Address: pain, sleep, nutrition, mood, family** all contributors; (8) **Multidisciplinary IRF or LTAC** based on intensity needs; (9) **Long-term PICS clinic**: outcomes track years post-discharge; (10) **Family education + support — PICS-F**; **Modern**: ICU mobility + post-ICU clinics + integrated rehab

---

Post-ICU: PICS triad. Early ICU mobilization. Assessment MRC/6MWT/FIM/MoCA. PT + OT + SLP + RT + nutrition + cognitive + family. IRF/LTAC. Long-term PICS clinic. Family PICS-F. Modern integrated.', NULL,
  'medium', 'respiratory', 'review',
  'rehab_medicine', 'clinical_decision', 'respiratory', 'adult',
  'SCCM PICS; ABCDEF Bundle', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี post-acute respiratory failure ICU 3 wk — ICU-acquired weakness + delirium — transferring rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย cystic fibrosis อายุ 22 ปี — chronic productive cough + declining FEV1 — airway clearance + exercise', '[{"label":"A","text":"Bedrest"},{"label":"B","text":"CF Comprehensive Rehab"},{"label":"C","text":"No ACT"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Discharge — no follow-up"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** CF Comprehensive Rehab: (1) **Multidisciplinary CF center**: pulm + RT + PT + dietitian + nurse + social work + psychologist + family; (2) **Airway clearance techniques (ACT)** daily core: - Active Cycle of Breathing Technique (ACBT); - Autogenic drainage; - PEP (positive expiratory pressure) — flutter, acapella, PARI PEP; - High-frequency chest wall oscillation (HFCWO — vest); - Postural drainage + percussion (less common now); - Adjunct nebulized hypertonic saline 7% + dornase alfa; (3) **Exercise**: aerobic + resistance — improves FEV1, QOL, BMD, mucus clearance; integrated as ACT; tailored intensity; (4) **CFTR modulators** (game-changing): elexacaftor/tezacaftor/ivacaftor (Trikafta) for eligible mutations — dramatically improves outcomes; (5) **Nutrition**: high-calorie + protein + fat + supplements (ADEK vitamins); BMI target; pancreatic enzyme replacement (PERT); (6) **CFRD** (CF-related diabetes) screening + management; (7) **Infections** — culture-directed antibiotics (P. aeruginosa, B. cepacia, MRSA, NTM); infection control between CF patients (segregation); (8) **Mental health**: depression + anxiety high prevalence; screen + treat (CF Foundation Mental Health Guidelines); (9) **Bone health, fertility, transition adult care**; (10) **Pre/post lung transplant rehab**; **Modern**: CFTR modulators + integrated multidisciplinary + telemedicine

---

CF: multidisciplinary center. ACT daily + exercise. CFTR modulators (Trikafta) game-changing. Nutrition + PERT + CFRD. Infection control. Mental health. Long-term care + transition + transplant. Modern integrated.', NULL,
  'medium', 'respiratory', 'review',
  'rehab_medicine', 'clinical_decision', 'respiratory', 'adult',
  'CF Foundation Guidelines; CFTR Modulators', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย cystic fibrosis อายุ 22 ปี — chronic productive cough + declining FEV1 — airway clearance + exercise'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี post-breast Ca + axillary node dissection 6 mo — มี ipsilateral upper limb lymphedema', '[{"label":"A","text":"Avoid all exercise"},{"label":"B","text":"Breast Cancer-Related Lymphedema (BCRL)"},{"label":"C","text":"Just monitor — no Tx"},{"label":"D","text":"Diuretic alone"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Breast Cancer-Related Lymphedema (BCRL): (1) **Risk**: ~20% post-ALND + radiation; reduced w/ SLN biopsy + axillary reverse mapping; (2) **Staging (ISL)**: Stage 0 (subclinical) → I (reversible) → II (irreversible) → III (lymphostatic elephantiasis); (3) **Assessment**: limb volume (perometer, water displacement, circumferential), bioimpedance (L-Dex — early detection), symptoms, function, ROM, strength; rule out DVT, infection, recurrence; (4) **Complete Decongestive Therapy (CDT) — gold standard**: - **Phase 1 (intensive 2-4 wk)**: MLD (manual lymphatic drainage), multilayer short-stretch bandaging, exercise w/ bandage, skin care; - **Phase 2 (maintenance lifelong)**: compression garment (custom or off-shelf — Class 2-3), self-MLD, exercise, skin care; (5) **Compression**: garment 24-h or daytime + night bandaging/Tribute selected; (6) **Pneumatic compression pumps**: adjunct; (7) **Exercise** SAFE: strengthening (PAL trial — weights safe and helpful), aerobic; (8) **Surgical**: vascularized lymph node transfer, lympho-venous anastomosis, liposuction — selected refractory/stage II-III; (9) **Skin care**: prevent infection — moisturize, avoid trauma, treat promptly; lifelong cellulitis risk; (10) **Education + adherence + psychosocial**; (11) **CLT** (certified lymphedema therapist) PT/OT specialty; **Modern**: early detection (L-Dex) + early intervention + surgical advances

---

BCRL: 20% ALND risk. ISL staging. CDT gold standard (MLD + bandaging + exercise + skin care intensive → garment maintenance). Exercise safe (PAL). Surgical for refractory. Early detection (L-Dex) + lifelong.', NULL,
  'medium', 'hemato_onco', 'review',
  'rehab_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'ISL Consensus; PAL Trial', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี post-breast Ca + axillary node dissection 6 mo — มี ipsilateral upper limb lymphedema'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี post-lung Ca resection (lobectomy) — chemo planning — "prehabilitation" question', '[{"label":"A","text":"Bedrest before surgery"},{"label":"B","text":"Prehabilitation — Oncologic"},{"label":"C","text":"No prehab"},{"label":"D","text":"Surgery delay 1 yr"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Prehabilitation — Oncologic: (1) **Concept**: optimize pre-treatment functional status to improve outcomes (postoperative morbidity, length of stay, QOL, treatment tolerance); (2) **Multimodal prehab** (most evidence): exercise + nutrition + psychological + smoking cessation + alcohol reduction; (3) **Exercise**: aerobic + resistance + IMT — 4 wk minimum often, longer better; CPET-guided when possible; (4) **Nutrition**: optimize protein, address sarcopenia + malnutrition, immunonutrition (selected — arginine, omega-3, nucleotides), pre + post; (5) **Smoking cessation**: ideally 4-8 wk pre-op — reduces pulm complications, wound; (6) **Alcohol reduction**: 4 wk pre-op recommended; (7) **Psychological**: anxiety + depression screen + treat, mindfulness, CBT; (8) **Comorbidity optimization**: DM (A1c), CV, COPD/anemia/cardiac eval; (9) **Multidisciplinary**: surgery + oncology + physiatry + PT + dietitian + psychology + smoking cessation; (10) **Evidence**: meta-analyses show reduced postop complications, shorter LOS, faster functional recovery (especially abdominal, thoracic surgery); (11) **Logistics**: prehab clinics, home-based, telerehab — increase access; (12) **Continuation**: prehab → rehab postop continuum; (13) **ERAS integration**; **Modern**: multimodal multidisciplinary + technology-enabled access

---

Prehab: optimize pre-Tx — multimodal exercise + nutrition + psych + smoking + alcohol + comorbidity. CPET-guided. Multidisciplinary. Evidence reduced complications + LOS. ERAS integration. Modern multimodal.', NULL,
  'medium', 'hemato_onco', 'review',
  'rehab_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'Carli; ERAS Society', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี post-lung Ca resection (lobectomy) — chemo planning — "prehabilitation" question'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี post-chemo (taxane + platinum) — chemotherapy-induced peripheral neuropathy (CIPN) — function limited', '[{"label":"A","text":"Opioid only escalating"},{"label":"B","text":"CIPN Management"},{"label":"C","text":"No intervention"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** CIPN Management: (1) **Common offenders**: platinum (cisplatin, oxaliplatin), taxanes (paclitaxel), vinca (vincristine), bortezomib, thalidomide; mechanism varies (oxaliplatin acute cold-induced + chronic, taxane axonal); (2) **Assessment**: clinical exam (sensory, motor, autonomic), PROs (CIPN20, FACT/GOG-Ntx), QST, NCS selected, functional (balance, hand function); CTCAE grading; (3) **Prevention**: limited proven — duloxetine NOT prevention; cryotherapy (taxane hand/foot — limited evidence); dose modification when CTCAE Gr 2-3; (4) **Treatment**: - **Duloxetine** — ONLY agent w/ Grade A evidence (Smith JAMA 2013) for painful CIPN; - Limited evidence: gabapentin, pregabalin, TCA, topical (capsaicin, lidocaine, ketamine/amitriptyline compound); - AVOID opioid escalation chronic; (5) **Non-pharmacologic**: - **Exercise** evidence growing — balance, sensorimotor, aerobic, resistance; - **PT/OT**: balance training, functional, adaptive equipment, fall prevention; - **Acupuncture** selected (mixed evidence); - **Scrambler therapy** — emerging; - **TENS, mind-body**; (6) **Multidisciplinary**: oncology + physiatry + neurology + PT + OT + pain medicine + behavioral; (7) **Address contributors**: B12 deficiency (metformin), DM, alcohol; (8) **Functional + safety**: fall prevention, equipment, modifications; (9) **Patient education + survivorship integration**; **Modern**: exercise + duloxetine + multimodal + survivorship clinics

---

CIPN: platinum + taxane common. CTCAE grading. Duloxetine Grade A for painful CIPN. Exercise emerging. PT/OT balance + fall prevention. Avoid opioid escalation. Multidisciplinary. Survivorship integration.', NULL,
  'medium', 'hemato_onco', 'review',
  'rehab_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'ASCO CIPN Guidelines; Smith JAMA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี post-chemo (taxane + platinum) — chemotherapy-induced peripheral neuropathy (CIPN) — function limited'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี post-head and neck cancer (radiation + neck dissection) — dysphagia + trismus + neck pain + lymphedema', '[{"label":"A","text":"Single discipline only"},{"label":"B","text":"Head & Neck Cancer Rehab"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Discharge"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Head & Neck Cancer Rehab: (1) **Multimodal late effects from surgery + radiation + chemo**: dysphagia, trismus, neck/shoulder dysfunction (spinal accessory nerve), xerostomia, dental, taste/smell, voice/speech, lymphedema (face/neck), pain, fatigue, psychosocial; (2) **Multidisciplinary**: ENT + radiation oncology + medical oncology + physiatrist + SLP + PT + OT + dentistry + nutrition + lymphedema therapist + psychology; (3) **Dysphagia**: SLP — VFSS/FEES; exercises (Mendelsohn, effortful swallow, Shaker, Masako, McNeill); diet modification (IDDSI); PEG transitional; pre-treatment swallowing exercises ("prophylactic") improves outcomes; (4) **Trismus**: jaw stretching devices (TheraBite, Dynasplint), passive + active ROM, manual; (5) **Spinal accessory nerve dysfunction (post-neck dissection)**: shoulder pain + dysfunction (trap weakness) — PT scapular + RC, posture, education; (6) **H&N lymphedema**: MLD + compression face/neck (specialized therapist + garments), self-management; (7) **Xerostomia**: saliva substitutes, pilocarpine, hydration, dental fluoride; (8) **Voice**: SLP; (9) **Pain**: multimodal (neuropathic + nociceptive); (10) **Nutrition**: high-protein, supplements, PEG transitional; (11) **Dental**: pre-radiation dental clearance + fluoride trays + osteoradionecrosis prevention; (12) **Psychosocial + survivorship**; **Modern**: prehab swallowing + multidisciplinary survivorship

---

H&N cancer rehab: multimodal late effects. Multidisciplinary. Dysphagia (prophylactic exercises evidence) + trismus + SA nerve + lymphedema + xerostomia + voice + pain + nutrition + dental + psychosocial.', NULL,
  'hard', 'hemato_onco', 'review',
  'rehab_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN; ASCO H&N Survivorship', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี post-head and neck cancer (radiation + neck dissection) — dysphagia + trismus + neck pain + lymphedema'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี advanced cancer + cachexia + functional decline — palliative rehab planning', '[{"label":"A","text":"Aggressive rehab — restore baseline"},{"label":"B","text":"Palliative + Hospice Rehab"},{"label":"C","text":"No rehab — hospice only"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Single discipline"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Palliative + Hospice Rehab: (1) **Definition**: rehab in life-limiting illness — goal: maximize function + QOL + dignity + symptom control; align w/ patient goals + prognosis; (2) **Integration w/ palliative care**: physiatrist + palliative care + oncology + PT + OT + SLP + chaplain + social work + family; (3) **Cancer cachexia**: complex syndrome (anorexia, weight loss, muscle wasting, inflammation); not reversed by nutrition alone; multimodal — exercise (preserves muscle), nutrition (high-protein), pharmacology (megestrol, olanzapine, corticosteroid short-term, anamorelin selected); (4) **Symptom management**: pain (multimodal), dyspnea, fatigue, nausea, anxiety, depression, delirium; (5) **Function-focused goals**: ADL preservation, mobility, transfers, falls prevention; energy conservation (4 P''s: pacing, planning, prioritizing, positioning); equipment (W/C, walker, raised toilet, shower chair, hospital bed home); (6) **Caregiver education + support**: training, respite, anticipatory grief; (7) **Communication + GoC**: prognostic awareness, advance directives, hospice transition; (8) **Discharge planning** + home health + DME; (9) **Outcomes**: function-focused (Karnofsky, PPS — palliative performance scale), symptoms (ESAS), QOL; (10) **Hospice rehab**: focus comfort + dignity + family; (11) **Bereavement support**; **Modern**: integrated rehab + palliative care + family-centered + value-based

---

Palliative rehab: function + QOL + dignity. Multidisciplinary + palliative care. Cachexia multimodal (exercise + nutrition + pharma). Symptom mgmt. Energy conservation 4P. Caregiver + GoC + hospice. Family.', NULL,
  'medium', 'hemato_onco', 'review',
  'rehab_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'AAHPM; ASCO Palliative', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี advanced cancer + cachexia + functional decline — palliative rehab planning'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี post-hematopoietic stem cell transplant (HSCT) 6 wk — deconditioning + GVHD risk', '[{"label":"A","text":"Bedrest 1 yr"},{"label":"B","text":"Post-HSCT Rehab"},{"label":"C","text":"No rehab post-HSCT"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-HSCT Rehab: (1) **Pre-HSCT prehab**: optimize function + nutrition + psych; (2) **Inpatient post-HSCT** (during neutropenia): - In-room therapy (PT, OT) maintain mobility + strength + endurance; - Isolation/protective considerations; - Address fatigue, mucositis, GI, infection; - Bedside cycle ergometer; (3) **Early post-discharge**: progressive aerobic + resistance + flexibility — evidence improves outcomes; supervised initially; (4) **Acute GVHD** manifestations + rehab implications: skin, GI, liver — symptom mgmt + nutrition + skin care; immunosuppressant effects (steroid myopathy → resistance training important); (5) **Chronic GVHD** (3 mo+): skin (sclerodermatous → ROM + stretching + scar management), oral (dryness, ROM, sicca, dental), ocular (sicca, drops), pulmonary (BOS — pulm rehab), MSK (myositis, fasciitis, contractures), genital — multidisciplinary + targeted rehab; (6) **Long-term effects**: cardiac, endocrine, secondary malignancy, cognitive (chemo-fog), psychosocial, sexual; (7) **Multidisciplinary**: BMT + physiatry + PT + OT + SLP + nutrition + behavioral + survivorship; (8) **Vaccination + infection precautions** (re-vaccination schedule); (9) **Survivorship clinic** + lifelong follow-up; (10) **Return to work + school**: graded; **Modern**: prehab + in-room ICU mobilization + tele-PR + integrated survivorship

---

Post-HSCT rehab: prehab + inpatient in-room + early outpatient. Acute + chronic GVHD multidisciplinary targeted. Long-term effects + survivorship. Vaccination + infection. Return-to-work. Modern integrated.', NULL,
  'hard', 'hemato_onco', 'review',
  'rehab_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'ASBMT; FACT', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี post-hematopoietic stem cell transplant (HSCT) 6 wk — deconditioning + GVHD risk'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี chronic low back pain 2 yr — failed PT + meds — interdisciplinary pain program eligibility', '[{"label":"A","text":"Opioid escalation"},{"label":"B","text":"Interdisciplinary Pain Rehabilitation Program (IPRP)"},{"label":"C","text":"Surgery"},{"label":"D","text":"Single discipline PT"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Interdisciplinary Pain Rehabilitation Program (IPRP): (1) **Concept**: comprehensive biopsychosocial chronic pain rehab — integrated team — addresses pain + function + behavior simultaneously; Cochrane + meta-analyses strong evidence improves function + QOL > usual care; (2) **Team**: physiatrist (pain medicine board) + psychologist + PT + OT + nursing + pharmacist + social work + chaplain selected; (3) **Components**: - **Education**: pain neuroscience (PNE — explains pain physiology, central sensitization, reduces fear); - **PT**: graded exercise, functional restoration, pacing, posture, ergonomics, conditioning; - **OT**: ADLs, work simulation, ergonomics, energy conservation; - **Psychological**: CBT (cognitive restructuring, behavioral activation), ACT, mindfulness, exposure for fear-avoidance, sleep, stress; biofeedback; - **Medication management**: rationalize, opioid tapering, optimize adjuvants; - **Vocational**: return to work focus; (4) **Format**: typically 3-4 wk full-day intensive; outpatient or residential; (5) **Outcomes**: pain (not elimination but reduction), function (PROs — ODI, PROMIS), mood, sleep, opioid reduction, return to work; cost-effective; (6) **Selection**: motivation + multidisciplinary candidate; not for active substance use without addressing, severe psychiatric uncontrolled; (7) **Less effective**: passive treatments alone, opioid escalation, single-discipline; (8) **Coverage challenge** US insurance — underutilized; **Modern**: biopsychosocial + tele-IPRP emerging + value-based

---

Chronic pain IPRP: comprehensive biopsychosocial. Team. CBT/ACT + PNE + graded exercise + meds rationalize + vocational. 3-4 wk intensive. Function-focused outcomes. Strong evidence. Modern: tele-IPRP.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'Cochrane IPRP; AAPM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี chronic low back pain 2 yr — failed PT + meds — interdisciplinary pain program eligibility'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี chronic CRPS-I L lower limb 8 mo post-ankle sprain — burning + allodynia + skin changes', '[{"label":"A","text":"Bedrest + immobilization"},{"label":"B","text":"Complex Regional Pain Syndrome (CRPS) — Multimodal"},{"label":"C","text":"Opioid only"},{"label":"D","text":"Sympathectomy first-line"},{"label":"E","text":"Amputation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Complex Regional Pain Syndrome (CRPS) — Multimodal: (1) **Budapest criteria** (dx): continuing pain disproportionate, w/ symptoms + signs in ≥ 3-4 categories (sensory — hyperalgesia/allodynia; vasomotor — temp/color; sudomotor/edema; motor/trophic) + no alternative dx; (2) **Multimodal** (interdisciplinary key): - **PT/OT** EARLY + intensive: graded motor imagery (GMI: laterality → imagined → mirror therapy — strong evidence), desensitization, ROM (active), strengthening, functional, mirror therapy, pool therapy; AVOID overly aggressive passive; - **Pharmacology**: bisphosphonate (alendronate, pamidronate IV — evidence in early CRPS), corticosteroid (short-course early), gabapentin/pregabalin, TCA, ketamine (IV selected), IV lidocaine selected, vit C (preventive evidence post-wrist fx — Zollinger); - **Procedures**: sympathetic block (stellate UE, lumbar LE) — diagnostic + therapeutic; SCS (selected, evidence in chronic refractory); intrathecal therapy selected; - **Psychological**: CBT, ACT, mindfulness, biofeedback, trauma-focused; - **Behavioral activation**; (3) **Early diagnosis + treatment** key; chronic refractory difficult; (4) **Education**: pain neuroscience + active rehab + function focus; (5) **Address contributors**: sleep, mood, social, work; (6) **Outcomes**: pain reduction + function + QOL; (7) **Multidisciplinary team essential**; **Modern**: early Dx + GMI + interventional adjuncts

---

CRPS: Budapest criteria. EARLY interdisciplinary. GMI + desensitization + active PT/OT (avoid aggressive passive). Bisphosphonate + corticosteroid + neuropathic. SCS refractory. Psychological. Modern: early multimodal.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'Budapest Criteria; Birklein', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี chronic CRPS-I L lower limb 8 mo post-ankle sprain — burning + allodynia + skin changes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี chronic neck pain — central sensitization features — fibromyalgia features — multimodal', '[{"label":"A","text":"Opioid escalation"},{"label":"B","text":"Fibromyalgia + Central Sensitization Rehab"},{"label":"C","text":"Bed rest"},{"label":"D","text":"Single discipline only"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Fibromyalgia + Central Sensitization Rehab: (1) **2016 ACR criteria**: WPI ≥ 7 + SS ≥ 5 OR WPI 3-6 + SS ≥ 9 + symptoms ≥ 3 mo + no alternative; (2) **Multidisciplinary** approach: physiatrist + rheumatology + PT + OT + psychology + sleep medicine + pain medicine; (3) **Education**: pain neuroscience (validate + explain central sensitization, not "in head") — reduces catastrophizing + improves engagement; (4) **Exercise** (strongest evidence): - Aerobic (low-impact: walking, cycling, aquatic) gradual progression; - Resistance training; - Mind-body (yoga, Tai Chi — evidence); - START LOW + go slow + sustain; (5) **Pharmacology** (FDA-approved): - Duloxetine (SNRI), milnacipran (SNRI), pregabalin — modest effect; - Amitriptyline (off-label, evidence); - AVOID opioids (limited evidence + central sensitization risk); (6) **CBT** + ACT + mindfulness — evidence; (7) **Sleep**: address — restorative sleep important; CBT-I; (8) **Address comorbidities**: depression, anxiety, IBS, migraine, autonomic; (9) **Adjuncts**: acupuncture, TENS, balneotherapy — modest; (10) **Self-management** + pacing + activity diary; (11) **Function-focus** (not pain elimination): PROs FIQ, PROMIS; (12) **Multidisciplinary education programs**; **Modern**: biopsychosocial + central sensitization framework + self-management

---

Fibromyalgia: 2016 ACR. Multidisciplinary. Exercise strongest evidence (aerobic + resistance + mind-body, gradual). FDA: duloxetine/milnacipran/pregabalin. AVOID opioids. CBT/ACT/mindfulness. Sleep. Function-focus.', NULL,
  'medium', 'rheumatology', 'review',
  'rehab_medicine', 'clinical_decision', 'rheumatology', 'adult',
  'ACR 2016; EULAR Fibromyalgia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี chronic neck pain — central sensitization features — fibromyalgia features — multimodal'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี chronic LBP — opioid 80 MME daily 5 yr — escalating dose + functional decline', '[{"label":"A","text":"Abrupt discontinuation"},{"label":"B","text":"Long-Term Opioid Therapy — Tapering + Multimodal"},{"label":"C","text":"Increase opioid dose"},{"label":"D","text":"Discharge — no follow-up"},{"label":"E","text":"Single discipline"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Long-Term Opioid Therapy — Tapering + Multimodal: (1) **Assessment**: function, pain, mood, OUD (DSM-5 criteria), risk (PDMP, COMM, ORT), benefit, harm; (2) **Indications taper**: lack of meaningful benefit + escalating dose + functional decline + risk (>50 MME, concurrent benzo, mental health, substance hx, advancing age); (3) **CDC + HHS guidelines**: individualized, gradual (10% per wk to month — slower for high dose + long duration), shared decision, monitor + treat withdrawal, monitor mental health; AVOID rapid/forced tapering — increases overdose + suicide; (4) **OUD screening**: if criteria met → buprenorphine/MAT (medication for OUD) referral — pause taper, transition; (5) **Multimodal pain mgmt** in lieu: - Adjuvants (gabapentinoid, TCA, SNRI, topical); - Acetaminophen, NSAID (cautious); - PT + active exercise + functional; - CBT, ACT, mindfulness; - Interventional (selected); - Sleep, mood, social; (6) **Mental health support**: depression, anxiety, PTSD common; CBT, SSRI; (7) **Address sleep, function, social**; (8) **IPRP** referral for complex; (9) **Naloxone** prescription patient + family education; (10) **Patient engagement + trust + shared decision**: avoid abandonment; (11) **Education**: realistic expectations, non-pharm strategies; **Modern**: opioid stewardship + biopsychosocial + harm reduction

---

LTOT taper: shared, individualized, gradual (10%/wk-mo). Screen OUD → MAT. Multimodal non-opioid + PT + CBT + interventional. Mental health. Avoid rapid/abandonment. Naloxone. IPRP. Modern: stewardship + harm reduction.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'CDC 2022 Opioid Guidelines; HHS Tapering', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี chronic LBP — opioid 80 MME daily 5 yr — escalating dose + functional decline'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย chronic LBP — เลือก interventional pain procedure — facet vs SI vs epidural', '[{"label":"A","text":"Single intervention without evaluation"},{"label":"B","text":"Interventional Pain — Indication-Matched"},{"label":"C","text":"Random injection"},{"label":"D","text":"Surgery first-line all"},{"label":"E","text":"Opioid only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Interventional Pain — Indication-Matched: (1) **Comprehensive eval first**: history + exam + imaging + conservative trial; correlate symptoms to pathology; (2) **Lumbar radicular pain**: - Epidural steroid injection (transforaminal > interlaminar for unilateral; particulate vs non-particulate considerations — non-particulate for cervical/transforaminal to avoid embolic complications); - Short + intermediate-term benefit; - Surgical consideration if neuro deficit/refractory; (3) **Lumbar facet (zygapophyseal) joint pain**: - Dx: medial branch block (MBB) — 2 confirmed positive blocks (controlled prevalence false-positives); - Tx: radiofrequency ablation (RFA) of medial branches — 6-12 mo benefit, repeatable; (4) **Sacroiliac joint pain**: - Dx: SI provocation tests (≥ 3 positive — Laslett cluster) + intra-articular block (gold standard); - Tx: intra-articular steroid, RFA (lateral branches), fusion (selected refractory); (5) **Discogenic pain**: - Provocative discography controversial; - Tx limited interventionally — IDET, biacuplasty — limited evidence; - Surgical (fusion, disc replacement) selected; (6) **Spinal cord stimulation**: FBSS, CRPS, PDPN, IS — Class I evidence selected; (7) **Vertebroplasty/kyphoplasty**: acute osteoporotic compression fracture — selected; (8) **Within multimodal**: not standalone — combined w/ PT + active + psychological; (9) **Risks**: infection, hematoma, neuro, vascular; consent; (10) **Multidisciplinary**: pain medicine + physiatry + PT + behavioral; **Modern**: indication-matched + outcome-driven + multimodal integration

---

Interventional: indication-matched. Radicular → ESI; facet → MBB then RFA; SI → block; discogenic limited; SCS for FBSS/CRPS. Multimodal not standalone. Risks. Modern: outcome-driven + integrated.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'ASIPP; SIS; ASRA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย chronic LBP — เลือก interventional pain procedure — facet vs SI vs epidural'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี post-herpetic neuralgia thoracic dermatome 4 mo — burning + allodynia', '[{"label":"A","text":"Opioid only escalating"},{"label":"B","text":"Post-Herpetic Neuralgia (PHN) Multimodal"},{"label":"C","text":"Surgery first-line"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-Herpetic Neuralgia (PHN) Multimodal: (1) **Prevention**: shingles vaccine (Shingrix recombinant — efficacious + preferred); early antiviral within 72 h reduces PHN risk; (2) **Diagnosis**: pain in zoster dermatome > 90 d post-rash onset; (3) **First-line pharmacology**: - **Gabapentin or pregabalin** (titrate); - **TCA** (amitriptyline, nortriptyline — anticholinergic + cardiac SE elderly); - **SNRI** (duloxetine); - **Topical lidocaine 5% patch** (well-tolerated); - **Topical capsaicin 8% patch** (Qutenza — single application 30-60 min, lasts months — second/third-line); (4) **Second-line**: opioids (tramadol > strong; limited chronic use); (5) **Interventional**: - Intercostal nerve block (thoracic) — selected; - Epidural steroid — limited evidence chronic PHN; - Sympathetic block; - **Spinal cord stimulation** refractory; - Intrathecal (selected); (6) **Non-pharm**: TENS, acupuncture (limited evidence), PT/OT for function; (7) **Address contributors**: sleep, mood (depression high), social isolation; CBT; (8) **Multidisciplinary** for refractory + functional impact; (9) **Patient education**: prognosis (improves over months-yr in many), self-management; (10) **Functional + QOL focus**; **Modern**: prevention (vaccine) + multimodal + early intervention

---

PHN: prevention (Shingrix). Pharma: gabapentin/pregabalin/TCA/SNRI/lido patch/capsaicin 8%. Opioids limited. SCS refractory. Function + sleep + mood. Multidisciplinary. Modern: prevention + multimodal.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'AAN/EFNS NP; CDC Shingrix', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี post-herpetic neuralgia thoracic dermatome 4 mo — burning + allodynia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 40 ปี chronic widespread pain + insomnia + depression + work disability — biopsychosocial assessment', '[{"label":"A","text":"Single-modality only"},{"label":"B","text":"Biopsychosocial Pain Assessment + Plan"},{"label":"C","text":"Pain medication alone"},{"label":"D","text":"Surgery"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Biopsychosocial Pain Assessment + Plan: (1) **Comprehensive assessment**: - **Biological**: physical exam, imaging, labs, sleep, comorbidities; - **Psychological**: PHQ-9 (depression), GAD-7 (anxiety), PCL-5 (PTSD), PCS (pain catastrophizing), TSK (kinesiophobia), CSI (central sensitization inventory), substance use, sleep (PSQI, ISI); - **Social**: work, family, finances, support, advocacy, ACEs (adverse childhood experiences); (2) **Multidimensional pain assessment**: NRS, BPI (Brief Pain Inventory), pain diagram, function (ODI, RMDQ, PROMIS); (3) **Function-focused care plan**: SMART goals, return-to-activity gradient; (4) **Multimodal interventions**: - Active PT/OT (graded, functional); - CBT/ACT/mindfulness; - Sleep medicine + CBT-I; - Mood treatment (SSRI/SNRI); - Address substance use; - Vocational rehab; - Pharma rational (adjuvants > opioids); - Interventional selected; (5) **Education**: pain neuroscience (PNE) validates + reduces catastrophizing; (6) **Social work + advocacy**: housing, finances, transportation, employer; (7) **Family + peer support**; (8) **Trauma-informed care**: ACEs + PTSD frequently underlying chronic pain; (9) **Health equity**: address SDOH; (10) **Outcomes**: function + QOL + mood + pain + opioid reduction + RTW; (11) **Care coordination**: IPRP for complex; **Modern**: biopsychosocial + trauma-informed + health equity + value-based

---

Chronic pain biopsychosocial: comprehensive assessment (bio + psych + social) — multidimensional pain + function. Multimodal — active + CBT + sleep + mood + voc + meds + interventional. PNE + trauma-informed + equity.', NULL,
  'medium', 'psych_behavior', 'review',
  'rehab_medicine', 'clinical_decision', 'psych_behavior', 'adult',
  'IASP; AAPM Biopsychosocial', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 40 ปี chronic widespread pain + insomnia + depression + work disability — biopsychosocial assessment'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี episodic vertigo precipitated by head position changes — 30 sec spinning — Dix-Hallpike positive R posterior canal', '[{"label":"A","text":"Vestibular suppressant indefinitely"},{"label":"B","text":"BPPV — Diagnosis + Canalith Repositioning"},{"label":"C","text":"Bedrest 2 wk"},{"label":"D","text":"Surgery first-line"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** BPPV — Diagnosis + Canalith Repositioning: (1) **Most common cause** of vertigo; posterior canal 85-95%; (2) **Diagnosis**: Dix-Hallpike — geotropic torsional + upbeating nystagmus (R post-canal w/ R Dix-Hallpike), latency 5-15 s, duration < 60 s, fatigues; (3) **Treatment**: - **Epley maneuver** (canalith repositioning): 4 positions held 30-60 s each; success > 80% single treatment, > 95% w/ repeated; - **Semont maneuver** alternative; - **Brandt-Daroff** home exercise — habituation if canalith repositioning fails; (4) **Lateral (horizontal) canal BPPV**: supine roll test (Pagnini-McClure) — diagnose; treat — Lempert/Gufoni/BBQ roll; (5) **Anterior canal** rare; (6) **Post-treatment instructions**: positional restrictions controversial — modern evidence does NOT require strict restrictions; (7) **Refractory** consider: alternate canal, recurrence (~50% within years), persistent canalith — repeat maneuvers; rarely posterior canal occlusion surgery for refractory; (8) **DDx**: vestibular neuritis (constant vertigo), Meniere''s (episodic + hearing + tinnitus), migraine vertigo, central (HINTS — Head Impulse, Nystagmus, Test of Skew — central if upright nystagmus + skew + normal HIT); (9) **Education + recurrence prevention**; (10) **Multidisciplinary**: physiatry + ENT + vestibular PT; **Modern**: video Frenzel goggles + VR rehab + remote diagnosis emerging

---

BPPV posterior canal: Dix-Hallpike torsional upbeating geotropic nystagmus. Epley maneuver >80% success. Semont/Brandt-Daroff alternatives. Lateral: roll test + Lempert/BBQ. Recurrence common. Education.', NULL,
  'easy', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'AAO-HNS BPPV CPG; Bhattacharyya', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี episodic vertigo precipitated by head position changes — 30 sec spinning — Dix-Hallpike positive R posterior canal'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี acute vestibular neuritis 5 d ago — persistent imbalance + chronic dizziness', '[{"label":"A","text":"Continuous meclizine long-term"},{"label":"B","text":"Unilateral Vestibular Hypofunction — Vestibular Rehab"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Unilateral Vestibular Hypofunction — Vestibular Rehab: (1) **Acute phase Tx**: short-course corticosteroid (early < 3 d, evidence modest), vestibular suppressants (meclizine, benzo) short-term ONLY (< 3 d) — prolonged use delays compensation; antiemetics; (2) **Vestibular rehabilitation therapy (VRT)**: evidence-based; promotes compensation: - **Gaze stabilization (VOR x1, x2)**: focus on target while head moves H + V; - **Adaptation** exercises (x1, x2 viewing); - **Substitution** exercises (saccadic, COR, smooth pursuit); - **Habituation** (Norré, Cawthorne-Cooksey) for motion-provoked vertigo; - **Balance + gait training**: static → dynamic, dual-task, surface variations, head turns, eyes-open/closed; - **Functional + sport-specific** progression; (3) **Assessment**: vHIT, caloric, VEMP, posturography, DGI, TUG, mini-BESTest, ABC scale, DHI (Dizziness Handicap Inventory), 10MWT; (4) **Home program**: daily 3-5×, several minutes; intensity-titrated (mild symptoms during/after — adaptive); (5) **Subset**: Persistent Postural-Perceptual Dizziness (PPPD) chronic — VRT + CBT + SSRI; (6) **Outcomes**: DHI, ABC, gait/balance, return to activity; (7) **Multidisciplinary**: vestibular PT + neurology/ENT + physiatry + psychology if PPPD; (8) **Patient education + reassurance + active engagement**; **Modern**: VR-based VRT + telerehab + chronic dizziness as PPPD

---

Unilateral vestib hypofunction VRT: gaze stab + adaptation + substitution + habituation + balance/gait. AVOID prolonged suppressants (delay compensation). Assessment vHIT/caloric + functional. PPPD chronic — CBT + SSRI.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'APTA VRT CPG; Bárány Society', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี acute vestibular neuritis 5 d ago — persistent imbalance + chronic dizziness'
  );

commit;

