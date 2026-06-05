-- ===============================================================
-- UPDATE chunk 2/8: rehab_medicine (25 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"Single setting"},{"label":"B","text":"Community-Based Rehabilitation + Disability Services"},{"label":"C","text":"Single setting"},{"label":"D","text":"Random"},{"label":"E","text":"Refuse"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Community-Based Rehabilitation + Disability Services: (1) **WHO CBR (Community-Based Rehabilitation)**: rehabilitation + equalization of opportunities + social inclusion at community level; includes — health, education, livelihood, social, empowerment; (2) **Settings**: community centers, schools, workplaces, home; (3) **Multidisciplinary**: rehab professionals + community health workers + educators + employers + family + peer mentors + advocates; (4) **Disability rights**: - ADA (Americans with Disabilities Act) — access + accommodation + employment + transportation + communication; - UN Convention on Rights of Persons with Disabilities (CRPD); - Inclusive society — accessibility + employment + education + healthcare + recreation; (5) **Independent Living Movement**: peer support, consumer-directed, civil rights focus; (6) **Specific services**: - Vocational rehab; - Independent living centers; - Transportation; - Adaptive housing; - Education (IEP, 504); - Support groups + advocacy organizations; - Caregiver support; - Sport + recreation programs (Paralympics); (7) **Universal design** principles: accessible for all; environmental design + products; (8) **Long-term care + chronic disease management**; (9) **Health promotion + wellness** for people with disabilities; (10) **Modern**: technology-enabled independent living + remote care + community integration + telerehab; (11) **Equity + global health**: extending services to underserved populations

---

Community-based rehab + disability services: WHO CBR + ADA/CRPD + Independent Living Movement + universal design + multidisciplinary + community-centered. Modern: technology + global health + equity focus.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'Hospital implements community-based rehabilitation + disability services + advocacy';

update public.mcq_questions
set choices = '[{"label":"A","text":"In-person only"},{"label":"B","text":"Telerehabilitation + Digital Health"},{"label":"C","text":"Random"},{"label":"D","text":"Avoid technology"},{"label":"E","text":"Refuse"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Telerehabilitation + Digital Health: (1) **Modalities**: synchronous video (real-time therapy + assessment), asynchronous (exercise apps, education), hybrid models, remote monitoring (wearables, sensors); (2) **Applications**: outpatient therapy continuation, home-based programs, remote consultation, telehealth coaching, post-discharge follow-up, specialty rehab consultation; (3) **Conditions**: stroke, SCI, TBI, cardiac, pulmonary, MSK, pain, mental health, geriatric, pediatric, cancer; (4) **Evidence**: comparable outcomes to in-person for many conditions; improves access especially rural + underserved; (5) **Technology**: video platforms, mobile apps, wearable sensors, virtual reality, AI-coached exercise, robotic-assisted, gaming-based; (6) **Implementation barriers**: technology access + digital literacy (especially elderly, low SES), licensing + reimbursement, privacy + security, internet bandwidth, language; (7) **Quality + best practices**: appropriate visit selection, technology testing, backup plans, training, documentation; (8) **Hybrid care models**: combine telerehab with in-person; (9) **AI applications**: motion analysis, exercise quality monitoring, personalized programs, predictive analytics, virtual coaches; (10) **Equity**: address digital divide; provide alternatives; (11) **Patient engagement**: gamification + interactive content; (12) **Modern**: rapidly evolving + COVID-accelerated + technology integration + AI growing

---

Telerehab + digital health: multiple modalities + applications. Comparable outcomes for many conditions. Expands access. Implementation challenges (digital divide). AI growing. Modern: hybrid + technology-integrated + COVID-accelerated.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'Hospital implements telerehabilitation + digital health + technology in rehab';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Multimorbid Post-Stroke Integrative Rehab"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Hospice"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multimorbid Post-Stroke Integrative Rehab: (1) **Multidisciplinary team**: physiatrist + stroke neurology + cardiology + endocrinology + geriatrics + PT + OT + SLP + nursing + dietitian + psychology + social work + pharmacy + family + caregiver; (2) **Stroke-specific rehab** (motor + speech + cognitive + ADL); (3) **Comorbidity-specific**: - DM: glycemic control + SGLT2 + GLP-1 + dietary + exercise; - HF: GDMT (4 pillars) + lifestyle; - Frailty: nutrition + exercise + multidisciplinary; - Cognitive: assessment + strategies + safety; (4) **Polypharmacy management**: Beers + STOPP/START + deprescribing; (5) **Cardiac rehab integration**: post-stroke patients high CV risk; (6) **Secondary stroke prevention**: antiplatelet + statin + BP + AF screen + lifestyle; (7) **Goals of care + shared decision-making**: realistic functional goals + values + family; (8) **Discharge planning**: home with services vs SNF vs LTC; family + caregiver assessment; (9) **Long-term**: continued therapy + community + medical management; (10) **Mental health**: depression high prevalence post-stroke + chronic illness; (11) **Caregiver burden**: education + support + respite; (12) **Modern**: integrated chronic disease + rehab + family-centered + value-based

---

Multimorbid post-stroke integrative rehab: multidisciplinary + comorbidity-specific + polypharmacy + secondary prevention + goals of care + family. Modern: integrated chronic disease + value-based care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 60 ปี multimorbid + post-stroke + DM + HF + frailty + cognitive impairment — comprehensive integrative rehab';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single specialty"},{"label":"B","text":"SCI + Complex Comorbidities Integrative Care"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Hospice"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** SCI + Complex Comorbidities Integrative Care: (1) **Multidisciplinary**: physiatrist + addiction medicine + psychiatry + pain medicine + PT + OT + psychology + social work + sexual health + peer support; (2) **SCI rehab continuation**: bladder/bowel + skin + spasticity + autonomic + mobility + ADLs; (3) **Chronic pain management**: - Multimodal opioid-sparing (gabapentinoids + SNRIs + topical + ketamine + procedures + cannabinoids selected); - CBT for chronic pain; - Mindfulness + meditation; - PT + OT; - Procedures (spinal cord stim selected); (4) **Substance use treatment**: addiction medicine + behavioral; integrated dual diagnosis treatment; medication-assisted treatment if indicated (buprenorphine for OUD); (5) **Depression treatment**: SSRI + CBT + peer support; high prevalence in SCI; suicide risk; (6) **Relationship + family + caregiver**: counseling + education + sexual health + peer support; (7) **Vocational + community reintegration**: vocational rehab + ADA accommodations + return to work/school; (8) **Long-term complications surveillance**: UTI, pressure injury, secondary medical conditions; (9) **Adaptive sports + recreation**: improves mood + function + community; (10) **Goals + values discussion**: patient-centered care + quality of life focus; (11) **Multidisciplinary care coordination**: case manager + medical home; (12) **Modern**: integrated comprehensive care + technology + emerging therapies (exoskeletons, epidural stim research) + advocacy

---

SCI + comorbidities integrative care: multidisciplinary including addiction + psychiatry + pain. Chronic pain multimodal + substance use treatment + depression + family + vocational + adaptive sports. Modern: integrated comprehensive lifelong care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 35 ปี SCI + chronic pain + depression + substance use + relationship issues — comprehensive integrative care';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Complex Multimorbid Integrative Rehabilitation"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Hospice"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Complex Multimorbid Integrative Rehabilitation: (1) **Multidisciplinary team**: physiatrist + cardiology + neurology + endocrinology + ortho + PT + OT + SLP + nursing + dietitian + pharmacy + psychology + social work + family + caregiver; (2) **Comprehensive assessment**: medical + functional + cognitive + nutritional + psychosocial + medications + advance care planning + values + goals; (3) **Coordinated care plan**: - **Cardiac rehab post-CABG** (Phase II — supervised exercise, risk factor modification, education, psychosocial); - **PD rehab** (LSVT-BIG + LSVT-LOUD + Tai Chi + fall prevention + medication optimization); - **DM management** (glycemic + SGLT2/GLP-1 + lifestyle + nutrition); - **Osteoporosis** (DEXA + Ca/vit D + bisphosphonate + fall prevention); - **Chronic LBP** (multimodal + opioid-sparing + PT + CBT); (4) **Polypharmacy management**: Beers + STOPP/START + deprescribing + interactions; (5) **Multimodal exercise** addressing multiple conditions simultaneously; (6) **Fall prevention**: comprehensive — multiple risk factors; (7) **Mental health**: depression high prevalence chronic illness + PD; (8) **Nutritional optimization**: protein + Ca + vit D + Mediterranean; (9) **Patient + family education + self-management**; (10) **Goals of care + shared decision-making**: realistic + values-based; (11) **Care coordination**: medical home + transitions; (12) **Modern**: integrated chronic disease + rehab + value-based + technology-enabled + patient + family-centered

---

Complex multimorbid integrative rehab: comprehensive multidisciplinary + coordinated care plan + multimodal exercise + polypharmacy management + mental health + family. Modern: integrated value-based patient-centered chronic disease management.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 60 ปี — post-CABG + Parkinson disease + diabetes + osteoporosis + chronic LBP — comprehensive multidisciplinary rehab';

update public.mcq_questions
set choices = '[{"label":"A","text":"Delay all mobilization 7 days"},{"label":"B","text":"Early Mobilization Protocol (AVERT-informed)"},{"label":"C","text":"tPA repeat dose"},{"label":"D","text":"Surgical decompression"},{"label":"E","text":"Routine MRI daily"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Early Mobilization Protocol (AVERT-informed): (1) **Timing**: เริ่ม out-of-bed activity 24-48 h post-stroke เมื่อ medically stable (BP, neuro stable); (2) **Dose**: short, frequent sessions (AVERT-III: high-dose very early mobilization ภายใน 24h อาจ worse outcome — ต้อง titrate); (3) **Team**: stroke unit nurse + PT + OT + SLP; (4) **Assessment**: NIHSS, mRS, Barthel/FIM baseline, dysphagia screen (water swallow) ก่อนให้กิน, SLP formal evaluation; (5) **Position + skin + DVT prophylaxis** (IPC + LMWH ตามแนวทาง); (6) **Aphasia communication**: yes/no + gesture + AAC + family education; (7) **Goal-setting**: SMART + patient/family-centered; (8) **Documentation**: NIHSS, FIM trajectory; **Modern**: stroke-unit care + early multidisciplinary rehab reduces mortality + dependency (Cochrane)

---

Early mobilization 24-48 h หลัง stable + multidisciplinary stroke unit. AVERT III ระวัง very high dose ต้น 24h. Dysphagia screen ก่อน PO. FIM/NIHSS baseline. Aphasia communication strategies.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 72 ปี acute ischemic stroke L MCA — R hemiplegia + global aphasia + NIHSS 18 — admit stroke unit day 2 hemodynamically stable';

update public.mcq_questions
set choices = '[{"label":"A","text":"Botulinum toxin only"},{"label":"B","text":"Constraint-Induced Movement Therapy (CIMT)"},{"label":"C","text":"Sling continuously without practice"},{"label":"D","text":"Wait for spontaneous recovery"},{"label":"E","text":"Surgery for tendon transfer now"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Constraint-Induced Movement Therapy (CIMT): (1) **Criteria EXCITE-style**: ≥10° wrist extension + ≥10° finger extension ที่ ≥2 fingers; (2) **Protocol**: mitt/sling ที่ unaffected UE 90% waking hours × 2 wk + intensive shaping/task practice 6 h/day; (3) **Modified CIMT (mCIMT)**: 3 h/day × 10 wk — practical; (4) **Evidence**: improved real-world arm use (Motor Activity Log) + Wolf Motor Function Test; (5) **Adjuncts**: mirror therapy, mental practice, FES (functional electrical stim), robot-assisted (MIT-Manus, Armeo), VR, BCI (research); (6) **Outcome measures**: Fugl-Meyer UE, ARAT, WMFT, MAL; (7) **Team**: OT-led + PT + family; (8) **Selection**: motivation + cognition + caregiver support important; **Modern**: neuroplasticity-based + task-specific high-repetition (Kleim/Jones principles)

---

CIMT criteria: ≥10° active wrist + finger extension. Intensive shaping + restraint of unaffected arm. mCIMT practical. Fugl-Meyer/WMFT/MAL outcomes. Neuroplasticity task-specific practice.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 58 ปี post-stroke 3 wk — L hemiparesis upper limb >> lower — UE Fugl-Meyer 35/66 — มี selective finger movement';

update public.mcq_questions
set choices = '[{"label":"A","text":"NPO indefinitely"},{"label":"B","text":"Dysphagia Multimodal Therapy"},{"label":"C","text":"Continue thin liquids freely"},{"label":"D","text":"Surgical cricopharyngeal myotomy first-line"},{"label":"E","text":"Tracheostomy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Dysphagia Multimodal Therapy: (1) **Compensatory**: chin tuck, head rotation to weak side, supraglottic + super-supraglottic swallow, effortful swallow, Mendelsohn maneuver; (2) **Diet modification**: IDDSI levels (puree, minced moist, soft) + thickened liquids (mildly/moderately/extremely thick) — note: thickened liquids reduce aspiration แต่เพิ่ม residue/dehydration; (3) **Rehabilitative exercises**: Shaker (head lift), Masako (tongue hold), EMST (expiratory muscle strength training), lingual resistance; (4) **NMES (neuromuscular electrical stim)**: VitalStim — evidence mixed but adjunctive; (5) **Feeding tube**: NGT short-term; PEG ถ้า >4 wk + poor recovery prognosis; (6) **Aspiration pneumonia prevention**: oral hygiene (key!), positioning, monitoring, vaccinations; (7) **Team**: SLP + dietitian + nursing + family + physician; (8) **Re-assessment**: serial FEES/VFSS; **Modern**: instrumental assessment + targeted exercise + oral care bundle

---

Dysphagia: compensatory maneuvers + diet (IDDSI) + rehabilitative exercises (Shaker, EMST). PEG ถ้า prolonged. Oral hygiene สำคัญ aspiration pneumonia. Serial FEES/VFSS. SLP-led team.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วย stroke 6 wk — dysphagia confirmed FEES — silent aspiration + delayed pharyngeal trigger — currently NGT';

update public.mcq_questions
set choices = '[{"label":"A","text":"Oral diazepam high dose"},{"label":"B","text":"Focal Spasticity Management — Botulinum Toxin + AFO + PT"},{"label":"C","text":"Bed rest 6 wk"},{"label":"D","text":"Hip replacement"},{"label":"E","text":"Refer hospice"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Focal Spasticity Management — Botulinum Toxin + AFO + PT: (1) **Goal-setting**: GAS (goal attainment scaling), gait, comfort; (2) **BoNT-A injection**: gastrocnemius medial + lateral, soleus, tibialis posterior (equinovarus pattern); typical onabotulinumtoxinA 200-400 U distributed; ultrasound/EMG guidance; (3) **Adjunct**: stretching + serial casting หลัง BoNT (within 2 wk peak effect), strengthening, gait training; (4) **AFO**: rigid vs articulated vs posterior leaf spring ตาม strength/spasticity/gait; functional AFO (ToeOFF) สำหรับ active patients; (5) **Oral antispasticity**: baclofen, tizanidine — systemic SE limit (sedation); (6) **Outcome**: Tardieu, MAS, gait speed (10MWT), 6MWT, PRO; (7) **Re-injection** q3-4 mo; (8) **Refractory**: ITB (intrathecal baclofen), SDR (selective dorsal rhizotomy — peds), orthopedic surgery (tendon transfer/lengthening); **Modern**: US-guided + goal-attainment + integrated rehab

---

Focal spasticity (foot drop, equinovarus): BoNT-A + AFO + PT + stretching/casting. US/EMG-guided. GAS + MAS + gait speed outcomes. Oral antispastic ระวัง sedation. ITB/SDR refractory. Goal-directed.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วย post-stroke 4 mo — L spastic foot drop + equinovarus during gait — MAS knee 2 + ankle 3 — interfere gait';

update public.mcq_questions
set choices = '[{"label":"A","text":"Ignore depression — focus PT only"},{"label":"B","text":"Post-Stroke Depression (PSD) Management"},{"label":"C","text":"Benzodiazepine long-term"},{"label":"D","text":"ECT first-line"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-Stroke Depression (PSD) Management: (1) **Prevalence**: ~30% prevalence; under-recognized; impairs rehab participation + outcome + mortality; (2) **Screen**: PHQ-9, HADS, อาจ Stroke Aphasic Depression Questionnaire ถ้า aphasia; (3) **Pharmacotherapy**: SSRI first-line (sertraline, citalopram — caution QTc dose limit, escitalopram); SNRI alternative; avoid TCA (anticholinergic + cardiac); FLAME suggested fluoxetine motor benefit แต่ subsequent (FOCUS/AFFINITY) negative — ไม่ routine fluoxetine for motor; (4) **Psychotherapy**: CBT, problem-solving therapy, motivational interviewing — adapted for cognitive/communication impairment; (5) **rTMS**: emerging for refractory; (6) **Address contributors**: pain, sleep, fatigue, family stress, medication SE; (7) **Suicide risk** assessment; (8) **Family education**; (9) **Cognitive screen**: MoCA — pseudo-dementia component; (10) **Team integration**: psychiatry consult ถ้า complex; **Modern**: integrated rehab + mental health + family-centered

---

Post-stroke depression 30% prevalence. PHQ-9 screen (or stroke-aphasic version). SSRI first-line. CBT adapted. ไม่ routine fluoxetine motor (FOCUS/AFFINITY neg). Treat contributors. Integrate mental health.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 65 ปี post-stroke 2 mo — มี post-stroke depression PHQ-9 16 + cognitive complaints — interferes therapy';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wheelchair only"},{"label":"B","text":"Gait Rehabilitation Program"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Stop all therapy at plateau"},{"label":"E","text":"BoNT only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Gait Rehabilitation Program: (1) **Assessment**: 10MWT (0.4 limited household, 0.4-0.8 limited community, >0.8 community per Perry classification), 6MWT, Berg Balance Scale, Timed Up and Go, Dynamic Gait Index; (2) **Interventions**: - **Task-specific overground gait training** + treadmill (with/without body-weight support — BWSTT — evidence equivocal vs overground LEAPS trial); - **High-intensity gait training** (HIGT) emerging strong evidence; - **Aerobic conditioning**; - **Strength**: hip + knee + ankle; - **Balance**: perturbation training, Tai Chi; - **FES** for foot drop; (3) **Assistive devices**: cane, single-point/quad, walker — match function; **AFO** ถ้า foot drop; (4) **Robotics + exoskeleton**: emerging — selected; (5) **VR + dual-task training**; (6) **Fall prevention**: home assessment + OT + community; (7) **Outcome**: gait speed predicts mortality + community ambulation; (8) **Team**: PT-led + OT + physiatrist; **Modern**: high-intensity task-specific + technology adjuncts

---

Gait rehab: 10MWT classification, task-specific overground + HIGT, strength + balance + aerobic, FES/AFO/devices. Fall prevention. Gait speed prognostic. Modern: high-intensity task-specific + technology.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 70 ปี stroke chronic 8 mo — gait slow (10MWT 0.6 m/s) — community ambulation goal — fall risk';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge — wait for spontaneous recovery"},{"label":"B","text":"Aphasia Intensive Treatment + Family-Centered Approach"},{"label":"C","text":"Surgery"},{"label":"D","text":"Antipsychotic"},{"label":"E","text":"Disable communication device"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Aphasia Intensive Treatment + Family-Centered Approach: (1) **Classification + assessment**: WAB (Western Aphasia Battery), BDAE, BNT (Boston Naming), discourse, functional communication (CAL); (2) **Intensity matters**: ≥5 h/wk shown effective (Cochrane); intensive comprehensive aphasia programs (ICAP) 2-6 wk; (3) **Approaches**: - **Melodic Intonation Therapy (MIT)** for non-fluent; - **Constraint-Induced Aphasia Therapy (CIAT)** — restrict gesture/compensation; - **Script training, semantic feature analysis, phonological component analysis**; - **Communication partner training** + family/caregiver coaching; - **AAC** (augmentative + alternative communication) ถ้า severe; (4) **Technology**: tablet apps, telepractice; (5) **Group therapy + aphasia groups**: psychosocial + functional + reduces isolation; (6) **Pharmacology**: limited evidence — piracetam, donepezil, memantine, amphetamine — adjuncts not standard; (7) **Mood**: address PSD; (8) **Functional goals**: SMART, PROs; **Modern**: high-intensity + functional + technology + partner training

---

Aphasia: classification (WAB) + intensive (≥5 h/wk) + MIT/CIAT/SFA + partner training + AAC. Group therapy. Functional goals + family-centered. Tech adjuncts. Address mood. Modern: ICAP + telepractice.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 50 ปี aphasia non-fluent (Broca-type) post-stroke 6 wk — frustrated + family wants intensive program';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continuous overhead pulleys"},{"label":"B","text":"Hemiplegic Shoulder Subluxation + Pain Management"},{"label":"C","text":"Aggressive PROM forceful"},{"label":"D","text":"Tendon release surgery first"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hemiplegic Shoulder Subluxation + Pain Management: (1) **Prevention** key: positioning + handling education to all staff + family + avoid pulling on affected arm + lap tray/arm support when seated + NO overhead pulley exercise (causes impingement); (2) **Subluxation management**: - **Shoulder strapping/slings**: prevent further subluxation while upright; - **NMES (FES)** to supraspinatus + deltoid: reduces subluxation + pain (evidence); - **Strengthening** as motor return; (3) **Pain causes ddx**: subluxation, rotator cuff (impingement, tear), adhesive capsulitis, complex regional pain syndrome (CRPS-I shoulder-hand), spasticity, central post-stroke pain; (4) **Management**: PT (ROM + scapular + strengthening), modalities, intra-articular/subacromial steroid injection (selected), BoNT for spastic pattern (subscapularis, pectoralis), suprascapular nerve block; (5) **CRPS**: bisphosphonates, corticosteroids, PT, mirror therapy; (6) **Imaging**: US, MRI for refractory; **Modern**: multimodal + prevention + early intervention

---

Hemiplegic shoulder: prevention (positioning, handling, avoid pulleys). NMES for subluxation. DDx: subluxation, RC, AC, CRPS, spasticity. Multimodal Tx. BoNT for spastic pattern. Education team + family.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 68 ปี stroke 6 mo — มี shoulder pain + subluxation L (palpable gap 1 finger) — interfere therapy';

update public.mcq_questions
set choices = '[{"label":"A","text":"Independent ambulation expected"},{"label":"B","text":"C5 Tetraplegia — Functional Outcomes + Goals"},{"label":"C","text":"Full hand function expected"},{"label":"D","text":"Discharge home immediately"},{"label":"E","text":"Ventilator dependent always"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** C5 Tetraplegia — Functional Outcomes + Goals: (1) **ASIA/ISNCSCI exam**: motor (key muscles C5-T1, L2-S1), sensory (light touch + pinprick), AIS grade, NLI, ZPP; serial exams (24-72h, 1 mo, 3 mo) — recovery patterns; (2) **C5 key innervations**: deltoid + biceps + brachialis (elbow flexion preserved), no triceps; (3) **Expected outcomes C5 motor complete** (per Consortium): - Power wheelchair w/ hand controls; manual w/ rim projections short distances; - Feeding w/ adaptive equipment (universal cuff, mobile arm support); - Dressing UE w/ assistance; - Bladder/bowel: assist; - Transfer: dependent w/ lift; - Driving w/ adapted van; (4) **Tenodesis grip** (passive finger flexion w/ wrist extension) — preserve by NOT fully extending fingers w/ wrist extension; (5) **Equipment**: power w/c (sip-puff, head, chin control variants), environmental control (eye gaze, voice), adapted computer access, mobile arm support; (6) **Respiratory**: assist cough, IS, vital capacity monitor — C5 spared diaphragm but weak accessory; (7) **Multidisciplinary**: PM&R + PT + OT + SLP + RT + nursing + social work + psychology + peer support; (8) **Long-term**: skin, bladder, bowel, autonomic, mental health; **Modern**: TMR, exoskeletons (research), epidural stim research

---

C5 tetraplegia: ASIA exam, key muscles deltoid + biceps, no triceps. Power w/c + adaptive feeding/dressing. Tenodesis grip preserve. Power w/c controls. Multidisciplinary lifelong. Modern technologies.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วย SCI C5 ASIA B — 6 wk post-injury — เริ่ม rehab — assessment + goal-setting';

update public.mcq_questions
set choices = '[{"label":"A","text":"Lay flat + IV fluid bolus"},{"label":"B","text":"Autonomic Dysreflexia (AD) — Emergency"},{"label":"C","text":"Wait — self-resolves"},{"label":"D","text":"Diuretic only"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Autonomic Dysreflexia (AD) — Emergency: (1) **Pathophys**: noxious stimulus below NLI → sympathetic surge → severe HTN; carotid + aortic baroreceptors → parasympathetic above lesion (HA, flushing, sweating, bradycardia, nasal congestion); (2) **Lesions at/above T6** (above splanchnic outflow) at risk; (3) **Immediate management**: - **Sit patient up** (orthostatic-effect ↓BP); - **Loosen clothing/binders**; - **Identify + remove trigger**: bladder (catheter kinked/blocked, distension) → check Foley, irrigate, replace ถ้า blocked; bowel (impaction) → manual disimpaction w/ lidocaine jelly AFTER BP control; skin (pressure ulcer, ingrown nail); fracture; UTI; pregnancy; sexual stimulation; (4) **Pharmacologic**: rapid-acting antihypertensive — nitrate paste (1 inch nitroglycerin) wipe off after, nifedipine bite-and-swallow (controversial), captopril SL, hydralazine IV ถ้า refractory; (5) **Monitor BP q5min**; baseline SCI patients have low BP — "normal" 110 อาจสูง relative; (6) **After resolution**: identify + prevent recurrence; (7) **Education**: patient + family + medical alert card; (8) **Pregnancy/labor**: epidural anesthesia critical; **Modern**: education + emergency preparedness — fatal stroke/seizure possible

---

AD emergency: lesion T6+. Sit up + loosen + remove trigger (bladder #1, bowel #2, skin). NTG paste / nifedipine. Monitor q5min. Baseline low BP. Education + alert card. Fatal complications possible.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'SCI T6 paraplegic 3 mo — มี severe headache + BP 200/110 + sweating profuse above lesion + bradycardia — flushed face — chronic indwelling Foley';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue sitting on wound"},{"label":"B","text":"Pressure Injury — Comprehensive Approach"},{"label":"C","text":"Wet-to-dry indefinitely"},{"label":"D","text":"Antibiotic only no offloading"},{"label":"E","text":"Amputation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pressure Injury — Comprehensive Approach: (1) **Stage** (NPIAP/EPUAP): Stage 1 (non-blanchable erythema) → 2 (partial-thickness) → 3 (full-thickness to subcutaneous) → 4 (to bone/muscle) + unstageable + DTI; (2) **Local wound care Stage 3**: clean (saline/wound cleanser), debride necrotic (sharp, autolytic, enzymatic), exudate management (foam, alginate, hydrocolloid), depth dressing (alginate for cavity), monitor; assess for infection (cellulitis, osteo); (3) **Offloading critical**: NO sitting on wound — alternative positions, specialty mattress, pressure-redistributing W/C cushion (ROHO, gel), tilt-in-space, weight-shifts q15-30 min; (4) **Nutrition**: protein 1.25-1.5 g/kg, calories 30-35 kcal/kg, micronutrients (vit C, zinc, arginine — selected); albumin/prealbumin/CRP track; (5) **Address etiology**: spasticity (BoNT, baclofen), incontinence (improve continence), shear/friction, equipment fit; (6) **Surgical consult**: flap closure ถ้า refractory + medically stable + non-smoker + adherent — myocutaneous flap; (7) **Imaging**: MRI for osteomyelitis suspicion; (8) **Team**: WOCN + PT + OT + nutrition + plastics + ID + SCI rehab; (9) **Prevention** key — daily skin checks, education; **Modern**: NPWT (negative pressure), advanced biologics, telewound

---

Pressure injury Stage 3: staging, local care + debridement + dressings, OFFLOADING critical, nutrition (protein 1.25-1.5), etiology, surgical consult flap. Team WOCN. Prevention education. NPWT/biologics modern.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'SCI T4 complete 6 mo — sacral pressure injury stage 3 — outpatient';

update public.mcq_questions
set choices = '[{"label":"A","text":"Chronic prophylactic antibiotic routinely"},{"label":"B","text":"Neurogenic Bladder + UTI Management"},{"label":"C","text":"Indwelling Foley permanent"},{"label":"D","text":"Restrict all fluid"},{"label":"E","text":"Surgical urinary diversion now"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neurogenic Bladder + UTI Management: (1) **Type by lesion**: above S2 = upper motor neuron (UMN, spastic, detrusor-sphincter dyssynergia — DSD); cauda/conus = lower motor neuron (LMN, flaccid, areflexic, overflow); (2) **Urodynamics**: gold standard — pressure, capacity, DSD, compliance, leak point pressure; high pressure (>40 cm H2O storage) → upper tract risk; (3) **Management strategies**: - **Clean intermittent catheterization (CIC)**: preferred standard q4-6h — lowest complication vs indwelling; - **Anticholinergics/β3-agonist** (mirabegron) for detrusor overactivity; - **BoNT-A detrusor injection** for refractory DO; - **Indwelling**: SPT > urethral ถ้า must; - **Augmentation cystoplasty** rare; (4) **UTI** (CDC: symptomatic + bacteriuria + pyuria): treat symptomatic; ASYMPTOMATIC bacteriuria → do NOT treat (common in CIC); urine cultures > dipstick; (5) **Recurrent UTI workup**: stones, residuals, hydroupterosis, immune; (6) **Upper tract surveillance**: renal US + creatinine annual; (7) **Sexual + reproductive**: fertility (men ↓), sexual function, women — pregnancy planning; (8) **Education**: hand hygiene, single-use catheter, fluids; **Modern**: hydrophilic catheters, sacral neuromodulation selected

---

Neurogenic bladder: UMN spastic+DSD; LMN flaccid. Urodynamics. CIC preferred. Anticholinergic/β3, BoNT detrusor. Treat symptomatic UTI only — NOT asymptomatic bacteriuria. Renal US annual. Education.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'SCI T10 — 2 yr post-injury — recurrent UTI + new neurogenic bladder issues';

update public.mcq_questions
set choices = '[{"label":"A","text":"Opioid monotherapy escalating"},{"label":"B","text":"SCI Neuropathic Pain — Multimodal"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Surgery (cordotomy) first-line"},{"label":"E","text":"Discharge — no treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** SCI Neuropathic Pain — Multimodal: (1) **Classification (ISCIP)**: nociceptive (musculoskeletal, visceral) vs neuropathic (at-level, below-level) vs other; this patient at/below-level NP; (2) **Pharmacology (evidence-based)**: - **Gabapentin/pregabalin** first-line; - **TCA** (amitriptyline/nortriptyline) — anticholinergic SE; - **SNRI** (duloxetine, venlafaxine); - Lamotrigine selected; - Cannabinoids — selected, mixed evidence; - **Opioids**: limited evidence chronic, escalation concerns + neurogenic bowel worsening — opioid-sparing; (3) **Interventional**: - Spinal cord stimulation — emerging (dorsal column, DRG); - Intrathecal pumps (morphine, ziconotide) selected; (4) **Non-pharm**: CBT chronic pain, mindfulness, acceptance + commitment therapy (ACT), exercise/PT, TENS, virtual reality (modulates pain via VR analgesia); (5) **Address contributors**: spasticity, mood, sleep, social; (6) **Mental health integration**: depression + anxiety; (7) **Adaptive sports + meaningful activity** improves pain coping; (8) **Goal**: function + QOL not pain elimination; **Modern**: opioid-sparing multimodal + neuromodulation + behavioral

---

SCI neuropathic pain: ISCIP classification. Gabapentin/pregabalin + TCA/SNRI first-line. Opioid-sparing. SCS emerging. CBT + mindfulness + exercise. Address contributors. Modern: multimodal + neuromodulation.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'SCI cervical 4 yr post-injury — chronic neuropathic pain (burning below NLI) — VAS 7/10 — opioids escalating';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discourage participation — too risky"},{"label":"B","text":"Adaptive Sports + Community Reintegration"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Hospice"},{"label":"E","text":"No community activities"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adaptive Sports + Community Reintegration: (1) **Benefits**: physical (CV, strength, weight), psychological (mood, self-efficacy, body image), social (peer, community); evidence: lower depression + better QOL; (2) **Classification per international para-sport** (IPC) — fair competition; (3) **Sports options paraplegic**: wheelchair basketball, rugby, tennis, racing; handcycling; swimming; adaptive skiing; sailing; rock climbing; archery; (4) **Equipment + funding**: sport-specific W/C, prosthetics, adaptive equipment — high cost; (5) **Medical considerations**: skin (pressure injury from sport W/C), thermoregulation impaired (cooling), autonomic dysreflexia (avoid "boosting"), bladder/bowel timing, UE overuse (rotator cuff), nutrition, hydration; (6) **Pre-participation evaluation**: CV (post-SCI ↓capacity), MSK, skin, bladder/bowel, equipment fit; (7) **Vocational + driving + travel**: driving evaluation, adapted vehicle, accessibility, travel planning; (8) **Peer mentorship + advocacy**: organizations (PVA, Disabled Sports USA); (9) **Family + caregiver education**; **Modern**: paralympic pathway + recreational integration + technology-enabled

---

Adaptive sports + community: physical/psych/social benefits. Equipment + classification. Medical considerations (skin, thermoreg, AD, UE overuse). Peer mentorship. Vocational + driving. Family. Modern integrated.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'SCI paraplegic T8 — 6 mo — มาขอ adaptive sports + community reintegration';

update public.mcq_questions
set choices = '[{"label":"A","text":"No ambulation — power w/c only"},{"label":"B","text":"Incomplete SCI Gait Rehabilitation"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Surgical fusion only"},{"label":"E","text":"Refer hospice"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Incomplete SCI Gait Rehabilitation: (1) **Prognosis**: AIS D good ambulation potential — most regain community ambulation (LEMS predictive); (2) **Assessment**: LEMS (lower extremity motor score), WISCI-II (Walking Index for SCI), 10MWT, 6MWT, TUG, Berg; (3) **Interventions**: - **Task-specific overground gait training** + high-intensity; - **Body-weight supported treadmill training (BWSTT)** — equivalent to overground per SCILT; - **Robotic-assisted gait training** (Lokomat, ReWalk, EksoBionics) — adjunct, evidence mixed but useful; - **FES** for foot drop or quad weakness; - **Strength training**; - **Balance + core**; - **Aerobic conditioning**; (4) **Orthotics**: AFO (foot drop), KAFO (quad weakness), reciprocating gait orthosis (paraplegic standing/limited ambulation), HKAFO; (5) **Assistive devices**: cane, crutches (forearm/Lofstrand), walker; (6) **Exoskeletons** (community ambulation): emerging — ReWalk, Indego, Ekso — selected patients; (7) **Spasticity** + pain + bladder addressing; (8) **Outcome measures**: WISCI-II, gait speed, LEMS; (9) **Goal-setting**: SMART, patient-centered; **Modern**: high-intensity task-specific + technology adjuncts + community ambulation focus

---

Incomplete SCI gait: AIS D good prognosis. LEMS/WISCI-II/10MWT outcomes. Task-specific overground + BWSTT + robotics + FES + orthotics. Exoskeletons emerging. High-intensity. Goal-directed.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'SCI L1 incomplete (AIS D) 4 mo — มี ambulation potential — gait training';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue same propulsion technique"},{"label":"B","text":"Shoulder Overuse in Manual W/C User"},{"label":"C","text":"Surgical shoulder fusion"},{"label":"D","text":"Stop all activity bedrest"},{"label":"E","text":"Opioid only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Shoulder Overuse in Manual W/C User: (1) **Prevalence**: 30-70% manual W/C users develop shoulder pain; impacts function + independence; (2) **Etiology**: repetitive propulsion + transfers + weight relief + reach — rotator cuff (impingement, tear), AC, bicipital tenosynovitis, instability; (3) **PVA Preservation of Upper Limb Function** guidelines: - Minimize forces during propulsion (longer stroke, smooth pattern); - Optimize W/C setup (rear axle anterior reduces shoulder load, light W/C); - Power-assist wheels or power W/C transition consider; - Transfer training (head-hips relationship, level surface, slide board); - Avoid extreme positions (overhead, behind back); (4) **Treatment**: PT (RC strengthening + scapular stabilizers + posture), modalities, NSAIDs (cautious), injections (subacromial, AC), surgical (RC repair selected); (5) **Assessment**: shoulder exam, US/MRI, WUSPI (Wheelchair Users Shoulder Pain Index); (6) **Prevention** key + lifelong: equipment, technique, conditioning, weight management; (7) **Body composition**: prevent metabolic syndrome (lower CV fitness post-SCI); (8) **Team**: PT + OT + physiatrist + seating clinic; **Modern**: power-assist + ergonomic equipment + early intervention

---

W/C user shoulder pain: 30-70%. PVA Preservation UE Function guidelines — equipment + technique + transfer. PT RC + scapular. Power-assist transition. WUSPI assessment. Prevention lifelong.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'SCI tetraplegic 2 yr — มี chronic shoulder pain bilateral — manual W/C user';

update public.mcq_questions
set choices = '[{"label":"A","text":"Benzodiazepine high dose"},{"label":"B","text":"Agitated TBI (Rancho IV) — Behavioral + Pharmacological"},{"label":"C","text":"Physical restraint primary"},{"label":"D","text":"Discharge home immediately"},{"label":"E","text":"Bedrest sedated"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Agitated TBI (Rancho IV) — Behavioral + Pharmacological: (1) **Rancho Los Amigos** I-VIII — Level IV: confused, agitated, response to internal confusion; expected stage; transient typically days-weeks; (2) **Environmental + Behavioral (FIRST)**: - Calm low-stim environment (single room, dim lighting, quiet); - Consistent staff/family; - Structured routine; - Frequent orientation + reassurance; - Reduce restraints (use selective — environmental safer); - Identify triggers (pain, full bladder, hunger, sleep deprivation, infection, medication); - Family education + co-therapy; (3) **Address contributors**: pain (assess + treat — multimodal opioid-sparing), constipation, urinary retention/UTI, sleep, sensory (vision/hearing), DT/seizure post-TBI; (4) **Pharmacology** (when behavioral fails + safety): - **Avoid benzodiazepines + first-gen antipsychotics + anticholinergics** (worsen cognition); - **Beta-blocker** (propranolol) for agitation evidence — Level I (Fugate); - **Atypical antipsychotics** (quetiapine, olanzapine) cautious; - **Anticonvulsants** (valproate, carbamazepine) selected; - **Amantadine** for arousal in low Rancho; - **Trazodone** for sleep; (5) **Agitated Behavior Scale (ABS)** monitor; (6) **Team**: physiatry + neuropsychology + nursing + PT + OT + SLP + behavioral + family; (7) **Safety + restraint minimization**; **Modern**: trauma-informed + family co-therapy

---

Rancho IV TBI agitation: environmental + behavioral first. Identify contributors. Propranolol Level I evidence. AVOID benzos + first-gen antipsych + anticholinergic. ABS monitor. Multidisciplinary + family.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'TBI severe 3 wk post-injury — Rancho IV (confused, agitated) — pulling lines + striking staff';

update public.mcq_questions
set choices = '[{"label":"A","text":"Withdraw all therapy immediately"},{"label":"B","text":"Disorders of Consciousness (DoC) Management"},{"label":"C","text":"Sedate continuously"},{"label":"D","text":"Discharge home no follow-up"},{"label":"E","text":"Routine surgery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Disorders of Consciousness (DoC) Management: (1) **Definitions**: coma, vegetative state/unresponsive wakefulness syndrome (VS/UWS), minimally conscious state (MCS-/+), emergence from MCS; (2) **Assessment**: **Coma Recovery Scale-Revised (CRS-R)** — gold standard, repeated; clinical exam misclassifies up to 40% — repeated assessment + ancillary; (3) **Ancillary**: fMRI + EEG (cognitive motor dissociation — covert awareness in ~15-20% behaviorally unresponsive); (4) **Treatment**: - **Amantadine** 200-400 mg/day evidence (Giacino NEJM 2012) — improves recovery in DoC 4-16 wk post-injury; - Address barriers (medications — minimize sedating, sleep, pain, hydrocephalus, seizures, infection); - **Sensory stimulation programs** — evidence weak but reasonable; - **rTMS, tDCS** emerging; (5) **Rehab participation**: tilt-table, ROM, splinting (contracture prevention), positioning, family training, environmental modification; (6) **Prognosis discussions**: caution — improvement can occur > 1 yr particularly in TBI vs anoxic; serial assessments; (7) **Goals of care + advance directives**: family-centered, neuroethics, palliative integration; (8) **Family support**: education + counseling + respite; **Modern**: covert consciousness detection + neuromodulation + DoC programs

---

DoC: CRS-R repeated assessment, fMRI/EEG covert awareness. Amantadine NEJM evidence. Address contributors. Sensory + rehab participation. Prognosis caution — TBI improvement > 1 yr. Family + neuroethics.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'TBI 6 wk post — minimally conscious state (MCS) — family + team discussing prognosis + interventions';

update public.mcq_questions
set choices = '[{"label":"A","text":"Prolonged rest indefinite"},{"label":"B","text":"Persistent Post-Concussion — Targeted Multidisciplinary"},{"label":"C","text":"Strict bed rest 6 mo"},{"label":"D","text":"Opioid for HA"},{"label":"E","text":"Return to contact sport immediately"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Persistent Post-Concussion — Targeted Multidisciplinary: (1) **Definition**: symptoms > 2-4 wk; subtypes addressed individually; (2) **Assessment**: SCAT5/6, BESS balance, VOMS (vestibular/ocular motor screening), cognitive (computerized — ImPACT), symptom inventory; (3) **Subtype + targeted treatment**: - **Vestibular/ocular**: vestibular rehab (VOR ex, gaze stabilization, habituation, balance), vision therapy; - **Cervicogenic**: PT cervical (manual + exercise); - **Cognitive/fatigue**: graded cognitive activity, cognitive rehab, sleep hygiene; - **Mood/anxiety**: CBT, SSRI; - **Migraine/HA**: acute (NSAID/triptan) + preventive (TCA, topiramate, propranolol, CGRP); - **Autonomic/exercise intolerance**: Buffalo Concussion Treadmill Test → sub-symptom threshold aerobic exercise (Leddy) — strong evidence; (4) **Active recovery** > prolonged rest (>48-72h rest prolongs recovery) — gradual return to activity (sport-specific 6-step protocol); (5) **Return-to-learn** + return-to-work + return-to-play; (6) **Multidisciplinary**: physiatry/sports med + neuropsych + PT (vestib/cervical) + OT + SLP + behavioral health; (7) **Avoid**: prolonged rest, second-impact risk, opioids; (8) **Long-term**: rare CTE concerns + meaningful counseling; **Modern**: subtype-targeted + sub-symptom exercise + multidisciplinary

---

Persistent post-concussion: subtype-targeted (vestib/ocular, cervical, cognitive, mood, migraine, autonomic). Active recovery > prolonged rest. Buffalo Test → sub-symptom aerobic (Leddy). RTL/RTW/RTP graded.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 25 ปี sport-related concussion — symptoms 3 wk (HA, dizziness, cognitive fog) — persistent';

update public.mcq_questions
set choices = '[{"label":"A","text":"No intervention — accept deficits"},{"label":"B","text":"Cognitive Rehabilitation — Attention + Executive"},{"label":"C","text":"Heavy sedation"},{"label":"D","text":"Surgery"},{"label":"E","text":"Discharge — no follow-up"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cognitive Rehabilitation — Attention + Executive: (1) **Comprehensive neuropsychological assessment**: domains (attention, processing speed, memory, executive, language, visuospatial); strengths + weaknesses; (2) **Cognitive rehabilitation approaches** (INCOG/ACRM evidence): - **Attention Process Training (APT)**: hierarchical drills + functional integration; - **Time Pressure Management** for slowed processing; - **Goal Management Training (GMT)** for executive; - **Metacognitive strategy training**: self-monitoring + strategy use; - **External aids**: smartphones/apps for memory + organization (evidence strong); - **Environmental modifications**: reduce distractions, structure; (3) **Restorative vs compensatory**: combination — restorative drills + compensatory strategies for real-world; (4) **Computer-based cognitive training**: adjunct (limited generalization without functional integration); (5) **Pharmacology** adjuncts: methylphenidate for attention/processing speed (evidence), amantadine, modafinil for fatigue, donepezil selected — limited evidence; (6) **Functional integration**: real-world tasks (work, school, ADLs); (7) **Vocational rehab + workplace accommodations**: graduated return, ADA; (8) **Family + community education**; (9) **Address contributors**: sleep, mood, pain, medications; **Modern**: technology-assisted (apps) + metacognitive + functional

---

Cognitive rehab: comprehensive neuropsych. APT + GMT + metacog + external aids (apps strong evidence). Restorative + compensatory. Methylphenidate adjunct. Functional + vocational. Address contributors.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'TBI 4 mo post — มี cognitive impairment (attention + executive function) — interfering work — IQ preserved';

commit;
