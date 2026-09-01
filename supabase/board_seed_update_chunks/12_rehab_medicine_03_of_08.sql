-- ===============================================================
-- UPDATE chunk 3/8: rehab_medicine (25 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"Benzodiazepine continuous"},{"label":"B","text":"TBI Sleep + Arousal Management"},{"label":"C","text":"No assessment — ignore sleep"},{"label":"D","text":"Heavy sedation 24h"},{"label":"E","text":"Discharge no follow-up"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** TBI Sleep + Arousal Management: (1) **Sleep disorders post-TBI**: insomnia + fragmentation + hypersomnia + circadian disruption + sleep apnea (50% TBI screen w/ HSAT/PSG); (2) **Assessment**: PSQI, Epworth, actigraphy, sleep diary, PSG if OSA suspected; (3) **Sleep hygiene**: consistent schedule, environment, light exposure (bright light AM), avoid stimulants/screens evening, exercise; (4) **Pharmacotherapy**: - **Melatonin** + ramelteon for circadian; - **Trazodone** sedating; - **Mirtazapine** if depression; - **Zolpidem/zopiclone** short-term cautious (falls, abuse); - **AVOID benzodiazepines** (cognitive impairment, dependency); - **Modafinil** for daytime hypersomnia; (5) **CBT-I**: first-line for chronic insomnia, adapted for TBI; (6) **Treat OSA**: CPAP — improves cognition + symptoms; (7) **Address contributors**: pain, depression, anxiety, medications, environment; (8) **Arousal**: amantadine for low arousal (Rancho), methylphenidate for attention/fatigue; (9) **Light therapy** for circadian + depression; (10) **Family education + structure home routine**; **Modern**: targeted sleep medicine + actigraphy + CBT-I

---

TBI sleep: insomnia, fragmentation, OSA common. Sleep hygiene + melatonin/trazodone/mirtazapine. AVOID benzo. CBT-I. CPAP for OSA. Light therapy. Amantadine/methylphenidate. Address contributors.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'TBI 2 wk — post-traumatic agitation + arousal disorder — sleep-wake disrupted';

update public.mcq_questions
set choices = '[{"label":"A","text":"Return immediately full duties"},{"label":"B","text":"Return-to-Work after TBI"},{"label":"C","text":"No return ever"},{"label":"D","text":"Discharge — no rehab"},{"label":"E","text":"Disability without trial"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Return-to-Work after TBI: (1) **Assessment**: cognitive (neuropsych) + physical + behavioral + job demands analysis; (2) **Predictors**: pre-injury employment, age, severity, cognitive function, psychosocial, social support; (3) **Process**: - **Vocational rehab counselor** integration; - **Worksite assessment** + job analysis; - **Graduated return**: half-days → full → full duties; - **Accommodations (ADA/equivalent)**: reduced hours, flex schedule, quiet workspace, written instructions, breaks, assistive technology (text-to-speech, organization apps), additional time, task simplification; - **Job coach** support on-site selected; (4) **Cognitive support**: external aids (calendars, reminders, smartphones); metacognitive strategies; (5) **Endurance + stamina**: graded activity; rest scheduling; (6) **Emotional + behavioral support**: CBT, peer support, family; (7) **Driving evaluation** if needed for work (CDRS clinical driving rehab specialist); (8) **Modifications longer-term**: job redesign, vocational change ถ้า cannot return; (9) **Outcomes**: monitor + adjust; team meetings; (10) **Resources**: vocational rehab agencies, ADA, employer education; **Modern**: technology-enabled accommodations + supported employment model

---

RTW after TBI: comprehensive cognitive + physical + behavioral + worksite analysis. Graduated return + accommodations + job coach. External aids. CBT + peer. Driving eval. Long-term monitor.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 30 ปี TBI 6 mo — ready return to work — knowledge worker role';

update public.mcq_questions
set choices = '[{"label":"A","text":"Sedate continuously"},{"label":"B","text":"Late Post-TBI Complications — Comprehensive"},{"label":"C","text":"No follow-up"},{"label":"D","text":"Surgery as primary"},{"label":"E","text":"Refer hospice"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Late Post-TBI Complications — Comprehensive: (1) **Post-traumatic epilepsy (PTE)**: ~10-20% severe TBI; risk factors (severity, penetrating, depressed skull fx, contusion, ICH, early seizure); diagnose w/ EEG + clinical; AED: levetiracetam first-line (favorable cognitive profile vs phenytoin/carbamazepine); avoid sedating + cognitive-impairing AEDs; consider tapering after seizure-free interval; (2) **Behavioral + neuropsychiatric**: - Depression (high), anxiety, PTSD, agitation, apathy, disinhibition, mania-like; - SSRI first-line; CBT; trauma-focused; - Address apathy w/ stimulants/amantadine selected; - Atypical antipsychotic for severe agitation cautious; - AVOID benzo + anticholinergic; (3) **Chronic HA**: post-traumatic HA — migraine/tension subtypes; preventive (TCA, propranolol, topiramate, CGRP — selected); acute opioid-sparing; address contributors (sleep, mood, cervical); (4) **Cognitive impairment + dementia risk**: long-term cognitive monitoring; (5) **Sleep, endocrine (hypopituitarism — screen!), vestibular, sensory**; (6) **Substance use** post-TBI elevated — screen + treat; (7) **Family + community + vocational**: long-term support; (8) **Driving + safety**; (9) **Caregiver burden + respite**; **Modern**: chronic disease model + integrated care

---

Late TBI complications: PTE (levetiracetam), neuropsychiatric (SSRI, CBT, avoid benzo), chronic HA preventive, cognitive monitor, endocrine (hypopituitarism!), substance use, family + vocational. Chronic disease model.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'TBI 1 yr post — มี post-traumatic seizures + behavioral issues + chronic HA';

update public.mcq_questions
set choices = '[{"label":"A","text":"Bed rest no shaping"},{"label":"B","text":"Transtibial (BKA) Pre-Prosthetic + Prosthetic Phase"},{"label":"C","text":"Skip K-level assessment"},{"label":"D","text":"Discharge no prosthesis"},{"label":"E","text":"Hospice"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Transtibial (BKA) Pre-Prosthetic + Prosthetic Phase: (1) **Pre-prosthetic phase**: - Residual limb shaping: shrinkers (preferred) or figure-8 ace wrap (correct technique distal-to-proximal pressure); - Wound + skin care; daily inspection; - Edema control + maturation; - **ROM**: prevent knee flexion contracture (positioning prone time, avoid pillow under knee); - Strengthening (core + remaining + UE); - Cardiovascular conditioning; - Pain management (phantom + residual); - Transfers + mobility w/ assistive device + single leg; (2) **Diabetes optimization**: glycemic control, foot care contralateral (high risk), vascular surveillance; (3) **Education**: skin checks, weight management, contralateral foot, prosthesis care, expectations; (4) **K-level assessment**: functional ambulation potential (K0-K4) guides prosthetic prescription; this patient typically K1-K3; (5) **Prosthetic prescription**: socket (PTB, TSB, gel liner), suspension (suction, pin lock, lanyard, sleeve), foot (SACH, single-axis, multiaxial, energy-storing, dynamic response, microprocessor for K3-K4), pylon; (6) **Fitting + training**: cast/scan → diagnostic → definitive; PT gait training (weight shift, step length symmetry, advanced); (7) **Long-term**: socket adjustments + replacements; contralateral surveillance; **Modern**: microprocessor feet + osseointegration selected + advanced liners

---

BKA: shaping (shrinker), prevent knee flexion contracture, glycemic + foot care contralateral, K-level prescription, socket/suspension/foot components. Long-term care. Modern technology adjuncts.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 55 ปี post-transtibial amputation (BKA) 3 wk — diabetic — preparing prosthesis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Opioid escalation alone"},{"label":"B","text":"Refractory Phantom Limb Pain (PLP) — Multimodal"},{"label":"C","text":"Amputation higher level"},{"label":"D","text":"Bed rest"},{"label":"E","text":"Discharge no treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Refractory Phantom Limb Pain (PLP) — Multimodal: (1) **Prevalence**: 50-80% amputees; mechanisms — peripheral (neuroma) + spinal sensitization + cortical reorganization; (2) **Multimodal approach**: - **Mirror therapy** (Ramachandran): low-cost, evidence supportive — daily 15-30 min; - **Graded motor imagery (GMI)**: laterality recognition → imagined movement → mirror therapy — 6 wk; - **Pharmacology**: gabapentin/pregabalin (max + adherence?), TCA (amitriptyline), SNRI (duloxetine), opioid-sparing, ketamine selected, IV lidocaine selected, NMDA antagonists; (3) **Neuromodulation**: - **TENS** non-invasive; - **rTMS** of motor cortex emerging; - **Spinal cord stimulation** selected refractory; - **Peripheral nerve stimulation**; (4) **Surgical/procedural**: - **Targeted Muscle Reinnervation (TMR)**: reroutes amputated nerves to local muscle — reduces neuroma + improves prosthetic myoelectric control; strong evidence; - **Regenerative Peripheral Nerve Interface (RPNI)**: free muscle graft to nerve; - Neuroma resection + revision (selected); (5) **Psychological**: CBT, ACT, mindfulness, hypnosis; address PTSD if war/trauma; (6) **Prosthetic fit optimization**: addresses residual limb pain often contributing; (7) **Multidisciplinary team**; **Modern**: TMR/RPNI + neuromodulation + multimodal integrated

---

PLP refractory: mirror therapy + GMI + pharmacology + neuromodulation + TMR/RPNI surgical + psychological. Multimodal. TMR strong evidence. Address residual limb pain. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วย post-transfemoral amputation (AKA) — 6 mo — มี phantom limb pain refractory to gabapentin';

update public.mcq_questions
set choices = '[{"label":"A","text":"Refuse all prosthesis"},{"label":"B","text":"Upper Limb Prosthesis Selection — Transradial"},{"label":"C","text":"Bed rest"},{"label":"D","text":"Body-powered always best for everyone"},{"label":"E","text":"Discharge no training"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Upper Limb Prosthesis Selection — Transradial: (1) **Options**: - **Body-powered**: cables + harness + hook (split hook) or hand; durable, sensory feedback via cables, lower cost; good for heavy/dirty environments; - **Externally-powered (myoelectric)**: surface EMG electrodes drive motor; multifunction (open/close, wrist rotation, multiarticulating hands); cosmetic + functional; higher cost + maintenance + weight; - **Hybrid**; - **Passive cosmetic**; - **Activity-specific** (sports); (2) **Selection factors**: functional goals + occupation + activities + cosmesis + lifestyle + cost + adherence; (3) **TMR/RPNI**: improves myoelectric control + reduces neuroma; intuitive multifunctional control; (4) **Advanced**: pattern recognition (instead of direct EMG channel mapping), proprioceptive feedback emerging, multi-articulating hands (i-Limb, bebionic, Michelangelo), powered wrist/elbow; (5) **Training**: occupational therapy intensive — sequential donning, control, ADLs, sports/work integration; (6) **Bilateral training** + contralateral overuse prevention; (7) **Outcomes**: ACMC (Assessment of Capacity for Myoelectric Control), SHAP, prosthesis use diary; (8) **Long-term**: prosthesis replacement, training updates, peer support, vocational; **Modern**: TMR + pattern recognition + sensory feedback (research)

---

UE prosthesis: body-powered (durable, feedback) vs myoelectric (multifunction, cosmetic) vs hybrid. TMR improves myoelectric. Patient-centered selection. OT intensive training. Outcomes ACMC/SHAP. TMR + pattern recognition modern.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วย unilateral upper limb amputation (transradial) — active 30 yo — considering prosthesis options';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue same socket — no changes"},{"label":"B","text":"Residual Limb Skin Problems — Socket Fit Optimization"},{"label":"C","text":"Discontinue prosthesis permanently"},{"label":"D","text":"Surgical revision first-line"},{"label":"E","text":"Hospice"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Residual Limb Skin Problems — Socket Fit Optimization: (1) **Etiology**: socket fit (volume change, weight change, edema, atrophy), gait issues, hygiene, liner wear, sweat/heat, vascular issues; (2) **Common conditions**: pressure ulcers (distal end, fibular head, patellar tendon area), abrasions, contact dermatitis (silicone allergy), folliculitis, verrucous hyperplasia (chronic edema), bursae, eczema, hyperhidrosis; (3) **Assessment**: full residual limb exam, socket fit, gait analysis, hygiene, liner; (4) **Management**: - **Socket modifications**: prosthetist adjustment, new socket, socks (add/remove for volume — ply system), gel/silicone liner change; - **Skin care**: gentle wash + dry, moisturize, antimicrobial selected; - **Hyperhidrosis**: aluminum chloride, BoNT, oral; - **Verrucous hyperplasia**: total contact socket + treat underlying; - **Contact dermatitis**: change liner material, topical steroid; - **Bursae**: ice, NSAID, injection, surgical selected; (5) **Education**: daily skin inspection, hygiene, sock management, weight stability, prosthesis off if sore; (6) **Team**: prosthetist + physiatrist + PT + dermatology selected; (7) **Imaging/labs**: if osteomyelitis suspected; **Modern**: 3D-scanning custom sockets + advanced liners + hygiene

---

Residual limb skin: socket fit + volume + gait + hygiene. Pressure ulcers, dermatitis, hyperhidrosis, verrucous. Prosthetist socket modification + sock ply + liner change. Skin care + education. Team.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วย BKA 8 mo — มี skin breakdown + recurrent abrasions on residual limb — socket fit issue';

update public.mcq_questions
set choices = '[{"label":"A","text":"Bedrest in supine"},{"label":"B","text":"Hip Flexion Contracture Post-AKA"},{"label":"C","text":"Pillow under residual continuously"},{"label":"D","text":"Surgical fusion"},{"label":"E","text":"Refer hospice"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hip Flexion Contracture Post-AKA: (1) **Etiology + Prevention**: hip flexors (iliopsoas, rectus) shorten — prone positioning prevention (15-30 min q-shift TID), avoiding prolonged sitting/supine w/ pillow under residual; (2) **Consequences**: gait — excessive lordosis, vaulting, increased energy expenditure, prosthetic alignment difficulty; (3) **Assessment**: Thomas test, gait analysis, ROM; goniometric measure; (4) **Treatment**: - **Stretching**: prone positioning daily 15-30 min TID; Thomas test position stretch; - **Strengthening**: hip extensors (glutes), core; - **PT**: manual therapy + exercise; - **Modalities**: heat + stretch; - **Serial casting** rarely for AKA contracture; - **Surgical release** for severe refractory; (5) **Prosthetic compensation**: socket flexion alignment + foot/knee tuning by prosthetist (improves gait); (6) **Patient education + adherence**: critical — home program; (7) **Address contributors**: pain, spasticity (rare), positioning habits, equipment (W/C, bed); (8) **Outcome**: ROM + gait analysis + 6MWT + symmetry; (9) **Team**: prosthetist + PT + physiatrist; **Modern**: 3D gait analysis + biomechanical optimization

---

Hip flexion contracture post-AKA: prevent w/ prone positioning. Stretching + strengthening + PT. Prosthetic alignment compensation. Education critical. Gait analysis. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วย post-AKA 3 mo — มี hip flexion contracture 25° + gait dysfunction';

update public.mcq_questions
set choices = '[{"label":"A","text":"Bedrest"},{"label":"B","text":"Bilateral Transfemoral Amputee — Prosthetic Ambulation"},{"label":"C","text":"Single conventional knee mandatory"},{"label":"D","text":"No prosthesis ever"},{"label":"E","text":"Hospice"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bilateral Transfemoral Amputee — Prosthetic Ambulation: (1) **Energy expenditure**: bilateral AKA → 280% increase vs intact; CV demand high — many don''t achieve community ambulation; (2) **Selection factors**: cardiovascular reserve (CPET), strength, motivation, age, comorbidities, balance, cognition; (3) **Stubbies** (short prostheses, no knees, low CG): initial training option — lower energy + balance; transition to full when ready; (4) **Full prostheses**: microprocessor knees (C-Leg, Genium) reduce energy + falls + improve confidence — recommended for bilateral; energy-storing feet; (5) **Training program**: - Pre-gait: balance + standing tolerance + core; - Parallel bars → walker → crutches/canes; - Endurance gradual; - Functional tasks; (6) **Adjunct**: W/C remains primary mobility for many bilateral AKA in community — combine; (7) **Multidisciplinary**: prosthetist + PT + OT + physiatrist + cardiology (CV clearance) + psychology; (8) **Long-term**: socket adjustments, replacement, contralateral integrity, equipment; (9) **Outcome**: AMPRO/AMP, 6MWT, falls, PROs; **Modern**: microprocessor knees, advanced control, osseointegration selected reduces socket issues

---

Bilateral AKA: 280% energy. CV reserve key. Stubbies → full. Microprocessor knees recommended. W/C combined. Multidisciplinary + CV clearance. AMPRO/6MWT outcomes. Modern technology + osseointegration.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วย bilateral AKA 6 mo — preparing for prosthetic ambulation + community goals';

update public.mcq_questions
set choices = '[{"label":"A","text":"No surveillance — wait symptoms"},{"label":"B","text":"Contralateral Limb Preservation — DM/PAD Amputee"},{"label":"C","text":"Discharge no follow-up"},{"label":"D","text":"Routine prophylactic amputation"},{"label":"E","text":"Bed rest"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Contralateral Limb Preservation — DM/PAD Amputee: (1) **Risk**: 5-yr contralateral amputation rate 30-50% in DM/PAD amputees; reduce by surveillance + intervention; (2) **Multidisciplinary surveillance**: - **Podiatry**: q3-6 mo high-risk diabetic foot exam (10g monofilament, vibration, ABI, palpation, skin); - **Vascular surgery**: ABI + duplex + intervention if disease; - **Endocrinology**: glycemic control (A1c < 7%), CV risk; - **Wound care + WOCN**: any wound aggressive Tx; - **Orthotics/footwear**: diabetic shoes + custom insoles (Medicare benefit USA); (3) **Pressure offloading**: total contact cast for ulcers; pressure reduction footwear; (4) **Smoking cessation** critical; (5) **Patient education**: daily foot inspection (mirror), shoe checks (foreign bodies), no barefoot, moisturize, nail care, prompt reporting; (6) **CV optimization**: statin, antiplatelet, BP, glycemic, exercise; (7) **Address pressure + repetitive trauma** from prosthetic side compensatory gait; (8) **Mental health + adherence support**: peer; (9) **Weight management**; (10) **Refer prompt**: any new ulcer, infection, ischemia; **Modern**: integrated DM-vascular-podiatry-rehab teams + telehealth

---

Contralateral limb preservation DM/PAD: 30-50% 5-yr risk. Podiatry + vascular + endo + WOCN + orthotics. Offloading + footwear. Smoking cessation. Daily inspection education. CV optimization. Integrated team.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วย amputee 3 yr post-amputation — มี contralateral limb concerns (DM + PAD) — surveillance';

update public.mcq_questions
set choices = '[{"label":"A","text":"Return at 4 mo timeline only"},{"label":"B","text":"ACL Return-to-Sport Criteria + Program"},{"label":"C","text":"Bedrest 1 yr"},{"label":"D","text":"Surgery revision"},{"label":"E","text":"Stop sport permanently"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ACL Return-to-Sport Criteria + Program: (1) **Time alone insufficient**: ≥9-12 mo recommended (reduces re-injury); time + criteria; (2) **Objective criteria battery**: - **Strength**: Limb Symmetry Index (LSI) ≥ 90% (quadriceps + hamstrings isokinetic); - **Hop tests** (single-leg hop, triple, crossover, 6m timed) LSI ≥ 90%; - **Movement quality**: drop vertical jump assessment (knee valgus angles, LESS — Landing Error Scoring System); - **PROs**: IKDC, KOOS, Tegner; - **Psychological readiness**: ACL-RSI ≥ 60-77 (fear of reinjury predictor); (3) **Phased program**: phase 1 swelling/ROM/quad activation → 2 strength + closed-chain → 3 power/plyometric → 4 sport-specific drills → 5 unrestricted return; (4) **Neuromuscular training**: emphasis perturbation, plyometrics, agility, sport-specific cutting/pivoting; (5) **Graft considerations**: BPTB (this patient) anterior knee pain risk; hamstring graft slower strength recovery; quad tendon emerging; (6) **Re-injury**: 15-30% within 2 yr; ACL-RSI predicts; girls/younger higher risk; (7) **Prevention** programs (FIFA 11+, Sportsmetrics) for prevention contralateral + future; (8) **Multidisciplinary**: surgeon + PT + athletic trainer + psych + coach; **Modern**: criteria-based + psychological + biomechanics + injury prevention

---

ACL RTS: ≥9-12 mo + objective criteria. LSI ≥90% strength + hop tests. Movement quality (DVJ, LESS). PROs + ACL-RSI psychological. Phased program. 15-30% reinjury. Prevention programs. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'นักกีฬาฟุตบอลอายุ 22 ปี ACL reconstruction (BPTB autograft) 6 mo post-op — ต้องการ return-to-sport';

update public.mcq_questions
set choices = '[{"label":"A","text":"Increase mileage 50% next week"},{"label":"B","text":"Medial Tibial Stress Syndrome (Shin Splints) — Rehabilitation"},{"label":"C","text":"Surgical fasciotomy first-line"},{"label":"D","text":"Casting 6 wk"},{"label":"E","text":"Discharge no PT"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Medial Tibial Stress Syndrome (Shin Splints) — Rehabilitation: (1) **Diagnosis**: diffuse medial tibial pain along posteromedial border (distal 2/3) during/after activity; tender to palpation > 5 cm linear; exclude stress fracture (focal point tenderness + bone scan/MRI), compartment syndrome (compartmental pressure), tendinopathy; (2) **Risk factors**: training error (volume + intensity + surface change), foot mechanics (overpronation, pes planus), BMI/sex (female), bone density, calcium/vit D, prior MTSS; (3) **Management**: - **Activity modification**: reduce volume + intensity, cross-train (cycling, swimming, pool running) maintain CV; - **Progressive loading return**: pain-guided gradual; - **Strengthening**: tibialis posterior, intrinsic foot, hip abductors + ext rotators (kinetic chain); - **Stretching**: calf complex; - **Footwear**: appropriate, replace > 500-800 km; - **Orthotics**: arch support for overpronation; - **Modalities**: ice, NSAIDs short-term, ESWT selected; (4) **Address training error** + periodization; (5) **Bone health**: vit D, Ca, female athlete triad/RED-S screen (energy deficiency, menstrual, bone); (6) **Imaging**: MRI ถ้า refractory or suspect stress fx; (7) **Prevention**: gradual progression (10% rule), strengthening, recovery; (8) **Multidisciplinary**: sports med + PT + athletic trainer + nutritionist; **Modern**: kinetic chain + load management + bone health

---

MTSS: diffuse posteromedial tibial pain. R/o stress fx. Risk: training error + mechanics + bone. Tx: load mgmt + cross-train + strengthen kinetic chain + footwear. Bone health (RED-S). Periodization.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'นักกีฬาวิ่งระยะยาวอายุ 28 ปี — chronic exertional medial tibial pain — running progression issues';

update public.mcq_questions
set choices = '[{"label":"A","text":"Corticosteroid injection — repeated"},{"label":"B","text":"Chronic Lateral Epicondylopathy"},{"label":"C","text":"Casting 3 mo"},{"label":"D","text":"Surgical release first-line"},{"label":"E","text":"Discharge — wait years"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic Lateral Epicondylopathy: (1) **Pathology**: degenerative tendinopathy of ECRB (Extensor Carpi Radialis Brevis) origin — NOT inflammation ("tendinosis"); (2) **Assessment**: pain over lateral epicondyle + tender + provocative (resisted wrist ext, Cozen, Mill, middle finger ext); PROs (PRTEE); imaging (US, MRI) ถ้า atypical; (3) **Conservative (mainstay)**: - **Wait + watch** (often self-limited 12-18 mo); - **Activity modification**: equipment (grip size, racquet stiffness), technique (shot mechanics) — sports med specialist + coach; - **PT**: eccentric strengthening (Tyler twist w/ Theraband), heavy slow resistance, scapular kinetic chain, wrist extensor stretch + grip; - **Counterforce brace** (forearm strap); - **Topical NSAID**, modalities; (4) **Injections**: - **Corticosteroid**: short-term pain relief but worse 6-12 mo outcomes (Coombes JAMA) — avoid; - **PRP**: emerging evidence in tendinopathy; - **Autologous blood, prolotherapy**: limited evidence; - **Anesthetic dry needling**, tenotomy; (5) **ESWT**: evidence supportive; (6) **Surgical**: refractory > 6-12 mo conservative — tenotomy/debridement; (7) **Address kinetic chain**: shoulder + core + technique; **Modern**: eccentric loading + sports tech analysis + biologic options

---

Lateral epicondylopathy: degenerative tendinopathy (not inflammation). Eccentric load (Tyler twist) + kinetic chain + technique + equipment. AVOID repeated corticosteroid (worse long-term). PRP/ESWT options. Surgery refractory.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'นักกีฬาเทนนิสอายุ 35 ปี chronic lateral elbow pain 6 mo (tennis elbow) — failed initial Tx';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cast immobilization 6 wk"},{"label":"B","text":"Ankle Sprain Functional Rehabilitation"},{"label":"C","text":"Bedrest 4 wk"},{"label":"D","text":"Discharge no PT"},{"label":"E","text":"Surgical first-line"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ankle Sprain Functional Rehabilitation: (1) **Grading**: Gr 1 (stretch), Gr 2 (partial tear), Gr 3 (complete); (2) **Acute phase**: POLICE/PEACE & LOVE (Protection, Optimal Loading, Ice, Compression, Elevation, then Education + load); early mobilization > immobilization (functional bracing > rigid cast); (3) **Subacute rehab progression**: - **ROM** restoration; - **Strengthening**: peroneal (eversion w/ Theraband), DF/PF/inv, intrinsic; - **Proprioception/balance** (KEY!) wobble board, single-leg, BAPS, perturbation — reduces re-injury; - **Functional drills**: walking → jogging → cutting → sport-specific; - **Plyometrics** + agility; (4) **Return-to-sport criteria**: pain-free, full ROM, strength symmetric, proprioception restored, sport-specific testing (hop, cutting); (5) **External support**: brace/tape during return + high-risk activities; (6) **Re-injury prevention**: continued proprioceptive program — chronic ankle instability common (40%) if inadequate rehab; (7) **Chronic ankle instability**: persistent giving way → consider lateral ankle reconstruction (Brostrom); (8) **PROs**: FAAM, CAIT; (9) **Address kinetic chain**: hip strength, core; (10) **Imaging**: MRI ถ้า refractory; **Modern**: early mobilization + proprioception + functional return

---

Ankle sprain: early mobilization + proprioception (KEY) + functional progression. CAI common if undertreated. Brace return. Brostrom for chronic. FAAM/CAIT. Kinetic chain. Modern functional rehab.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'นักกีฬาบาสเกตบอล grade 2 ankle sprain (lateral) — 2 wk post-injury — สามารถ partial weight bear ได้';

update public.mcq_questions
set choices = '[{"label":"A","text":"Quad-only strengthening"},{"label":"B","text":"Patellofemoral Pain Syndrome (PFPS) — Multimodal"},{"label":"C","text":"Knee brace continuous"},{"label":"D","text":"Surgical release first-line"},{"label":"E","text":"Complete rest 3 mo"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Patellofemoral Pain Syndrome (PFPS) — Multimodal: (1) **Diagnosis**: anterior knee pain w/ loading (stairs, squat, prolonged sitting — "theater sign"); R/o other causes (chondromalacia, patellar tendinopathy, ITB, meniscus); (2) **Multifactorial**: hip weakness (abductors + ext rotators — KEY), quad imbalance (VMO), foot mechanics (overpronation), training load, malalignment; (3) **Evidence-based Tx (BJSM consensus)**: - **Exercise therapy** combined hip + knee (strong evidence): hip strengthening (glute med, ext rotators — clamshells, single-leg bridges, side-stepping) + quad strengthening (closed-chain, eccentric); - **Gait retraining**: increase cadence, reduce overstride, address valgus collapse; - **Patellar taping** (McConnell) short-term; - **Foot orthoses** for overpronation; - **Manual therapy** adjunct; (4) **Load management**: temporarily reduce volume + intensity, cross-train; (5) **Avoid**: passive treatments alone, prolonged rest; (6) **Surgical**: rarely indicated PFPS; (7) **Education**: pathophysiology + self-management + load management; (8) **PROs**: AKPS (Kujala), Lower Extremity Functional Scale; (9) **Return-to-run progression** when symptom-controlled; **Modern**: hip-focused + gait retraining + load management

---

PFPS: multifactorial — hip > knee. Combined hip + knee exercise (strong evidence). Gait retraining. Foot orthoses selective. Load management. PROs AKPS. Avoid quad-only, prolonged rest, early surgery.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'นักวิ่ง marathon อายุ 30 ปี — patellofemoral pain syndrome (PFPS) 3 mo — bilateral';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue training — push through"},{"label":"B","text":"Relative Energy Deficiency in Sport (RED-S) — Multidisciplinary"},{"label":"C","text":"Ignore menstrual changes"},{"label":"D","text":"Increase training volume"},{"label":"E","text":"Hormone replacement only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Relative Energy Deficiency in Sport (RED-S) — Multidisciplinary: (1) **Definition** (IOC 2014, update 2018, 2023): syndrome from low energy availability — broader than Triad; affects multiple systems (menstrual, bone, immune, cardiovascular, GI, metabolic, hematological, psychological) + performance; (2) **Female Athlete Triad**: low energy availability + menstrual dysfunction + low BMD; (3) **Assessment**: - Energy availability calc (kcal/kg FFM/day, < 30 risk); - Menstrual history; - DEXA bone density (Z-score, hx fractures, stress fx); - Labs: hormonal (LH, FSH, estradiol, T3, cortisol, IGF-1), iron, vit D; - ECG (cardiac risk); - Mental health (eating disorder, depression, anxiety) — DSM-5; (4) **Stratification** + RED-S Risk Assessment Tool (red/yellow/green); (5) **Management — multidisciplinary**: - Sports medicine physician; - Sports dietitian (increase energy availability — goal); - Mental health/psychology + eating disorder specialist; - Endocrinology if hormonal; - Coach + family education; (6) **Treatment**: - Increase energy availability (food intake or decrease training); - Treat eating disorder if present; - Bone health (Ca + vit D + weight-bearing + medication selected); - Hormonal therapy controversial — address root cause first; (7) **Training modification** + return-to-sport when criteria met; (8) **Long-term** monitoring; **Modern**: RED-S framework + multidisciplinary + early identification

---

RED-S: low energy availability syndrome. Triad component. Multidisciplinary — sports med + dietitian + mental health + endocrine + coach. Address EA first. Bone + ED + hormones. RED-S risk tool.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'นักกีฬาอายุ 19 ปี diagnosed Female Athlete Triad / RED-S — endurance runner';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue same volume"},{"label":"B","text":"Swimmer''s Shoulder — Rehabilitation"},{"label":"C","text":"Surgical decompression first"},{"label":"D","text":"Casting 6 wk"},{"label":"E","text":"Stop swimming forever"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Swimmer''s Shoulder — Rehabilitation: (1) **Etiology multifactorial**: overuse + repetitive overhead; impingement (subacromial + internal posterior — GIRD), RC tendinopathy + tears (selectively), labral pathology, instability (multidirectional common swimmers), scapular dyskinesis, stroke mechanics, training error; (2) **Assessment**: comprehensive — ROM (GIRD: glenohumeral internal rotation deficit), strength (RC + scapular + core), stability, impingement signs, kinetic chain, stroke analysis (coach + video); (3) **Treatment**: - **Activity modification**: temporarily reduce yardage + intensity, cross-train, technique (stroke mechanics — coach); - **PT**: rotator cuff + scapular stabilizer strengthening (serratus, lower trap), posterior capsule stretching (sleeper stretch, cross-body), kinetic chain (hip/core), eccentric loading for tendinopathy; - **Stroke modification**: early vertical forearm, body rotation, breathing pattern, distance per stroke; - **Modalities**: ice, NSAIDs short-term; - **Injection** (subacromial) selected; (4) **Address instability** w/ stability program + brace selected; (5) **Prevention** integrated: prehab, periodization, recovery; (6) **Return-to-swim progression**: pain-free + criteria-based; (7) **PROs**: KJOC, ASES; (8) **Multidisciplinary**: sports med + PT + athletic trainer + coach + dietitian; **Modern**: stroke biomechanics + kinetic chain + load management

---

Swimmer''s shoulder: multifactorial — impingement + RC + GIRD + scapular + instability + stroke. Activity modification + RC/scapular strengthening + posterior capsule stretch + stroke analysis. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'นักว่ายน้ำอายุ 24 ปี — chronic shoulder pain 4 mo (swimmer''s shoulder) — high volume training';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single-discipline PT only"},{"label":"B","text":"CP GMFCS III — Comprehensive Rehab"},{"label":"C","text":"Surgery first-line"},{"label":"D","text":"Discharge — no intervention"},{"label":"E","text":"Hospice"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** CP GMFCS III — Comprehensive Rehab: (1) **GMFCS classification** I-V (Gross Motor Function Classification System) — Level III: walks w/ handheld mobility device, may use wheels for community; functional severity-stratified care; (2) **Functional outcomes** (GMFM-66, GMFM-88): trajectory + intervention monitoring; ≥95% reach motor potential by age 6-7 (Rosenbaum trajectories); (3) **Multidisciplinary team**: pediatrician + physiatrist + orthopaedist + neurologist + PT + OT + SLP + special education + social work + family + ortotist; (4) **Spasticity management**: - **PT**: stretching + strengthening + functional training; - **Orthotics**: AFO common (rigid, articulated, GRF) for foot drop + crouch + stability; - **Oral antispasticity**: baclofen, tizanidine, diazepam — sedation limit; - **Focal — BoNT-A**: targeted (gastrocnemius, hamstrings, hip adductors, biceps) — improves function + delays surgery; max dose by weight; - **Generalized — intrathecal baclofen (ITB) pump**: severe spasticity affecting function; - **Selective Dorsal Rhizotomy (SDR)**: selected ambulators (typically GMFCS II-III, age 3-8, good cognition); (5) **Orthopaedic**: hip surveillance (radiograph yearly — hip displacement risk), tendon lengthening, multilevel single-event surgery, scoliosis; (6) **OT**: ADLs, UE function, adaptive equipment, school; (7) **SLP**: dysarthria, AAC if needed, feeding; (8) **Education**: school IEP, accessibility, peer interaction; (9) **Family + caregiver education + respite**; (10) **Long-term transition** to adult care; **Modern**: family-centered + GMFCS-stratified + technology-enhanced

---

CP GMFCS III: stratified care. Multidisciplinary. Spasticity (BoNT, ITB, SDR), orthotics (AFO), hip surveillance, ortho selected. Family-centered. Long-term transition. GMFM outcomes.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'เด็กชายอายุ 5 ปี cerebral palsy bilateral spastic — GMFCS III — เดินด้วย walker — multidisciplinary care plan';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait until school age"},{"label":"B","text":"Early Intervention for Developmental Delay"},{"label":"C","text":"Single discipline only"},{"label":"D","text":"No therapy — observe"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Early Intervention for Developmental Delay: (1) **Assessment**: comprehensive developmental (Bayley III, Mullen, AIMS) across domains (motor, cognitive, language, social-emotional, adaptive); medical workup for etiology (genetic, metabolic, neuroimaging selected); hearing + vision; (2) **Etiology workup**: history (prenatal, perinatal, postnatal), family hx, exam (dysmorphology, neuro), genetic (chromosomal microarray first-tier, FXS, WES selected), metabolic (selected), EEG, MRI as indicated; (3) **Early Intervention Programs** (Part C IDEA USA; equivalent local systems): - Birth to 3 yr; - IFSP (Individualized Family Service Plan); - Home- + community-based; - Family-centered + coaching model; - Multidisciplinary: PT + OT + SLP + early childhood educator + social work + nursing; (4) **Specific interventions**: - PT: gross motor, postural control, mobility; - OT: fine motor, sensory, ADL, feeding; - SLP: language, communication, AAC if severe; - Behavioral; (5) **Family education + coaching**: empower parents — interactions, routines-based intervention; (6) **Transition to school**: at age 3 to IEP (special education); (7) **Address comorbidities**: seizures, sleep, GI, feeding, behavioral; (8) **Specialist referrals**: pediatric neurology, genetics, GI, dev-behavioral pediatrics; (9) **Equipment + AT**: adaptive seating, mobility, communication; (10) **Long-term monitoring** + family support; **Modern**: family-centered + coaching + routines-based + early neuroplasticity

---

Early intervention dev delay: comprehensive assessment + etiology workup + EI program (IFSP, family-coaching, multidisciplinary). Specific therapy. Family-centered. Transition to IEP. Long-term monitoring.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'เด็กอายุ 2 ปี global developmental delay — มี hypotonia + motor delay — family wants early intervention';

update public.mcq_questions
set choices = '[{"label":"A","text":"Aggressive eccentric exercise"},{"label":"B","text":"Duchenne Muscular Dystrophy — Rehab + Multidisciplinary"},{"label":"C","text":"No corticosteroid"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Discharge no follow-up"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Duchenne Muscular Dystrophy — Rehab + Multidisciplinary: (1) **Multidisciplinary care** (DMD Care Considerations Group): neuromuscular specialist + cardiology + pulmonology + ortho + physiatry + PT + OT + endocrine + GI/nutrition + psychiatry + social work + family; (2) **Stage-based management** (early ambulatory, late ambulatory, early non-ambulatory, late non-ambulatory): (3) **Physical therapy**: - Stretching daily (heel cords, hamstrings, hip flexors, ITB) prevent contractures; - Submaximal aerobic + functional activity; - AVOID eccentric + maximal eccentric exercise (damage); - Aquatic therapy; (4) **Orthotics**: night AFO/KAFO to preserve ROM; daytime as needed; (5) **Mobility + equipment**: power w/c when ambulation lost (typically 8-13 yr); standing program (standing frame); adaptive seating; (6) **Pharmacology**: - **Corticosteroids** (prednisone, deflazacort) — slow disease progression, prolong ambulation, preserve cardiac/pulm; SE managed; - **Exon-skipping** (eteplirsen, golodirsen, viltolarsen — exon 51/53/45 specific); - **Givinostat** (HDAC inhibitor); - **Gene therapy** (delandistrogene moxeparvovec — emerging); - **Vamorolone** alternative steroid; (7) **Cardiac**: ACEi/ARB + BB starting age 10 + MRI; (8) **Pulmonary**: PFT serial, cough assist, NIV when nocturnal hypoventilation; (9) **Scoliosis surgery** selectively; (10) **Bone health, GI, psychosocial**; (11) **Transition to adult care**; **Modern**: emerging genetic + comprehensive care extends lifespan

---

DMD multidisciplinary stage-based. Stretching + submax exercise + AVOID eccentric. Corticosteroid slow progression. Exon-skipping + gene therapy emerging. Cardiac/pulm proactive. Long-term + transition.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'เด็กอายุ 8 ปี Duchenne muscular dystrophy — ambulatory แต่เริ่มมี Gowers sign + frequent falls';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single-discipline behavioral only"},{"label":"B","text":"ASD Multidisciplinary Rehab"},{"label":"C","text":"Antipsychotic alone — no behavioral"},{"label":"D","text":"Discharge no intervention"},{"label":"E","text":"Heavy sedation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ASD Multidisciplinary Rehab: (1) **Comprehensive assessment**: developmental + behavioral (ADOS-2 diagnostic), cognitive (Mullen/WPPSI), language (REEL, CELF), motor (BOT, M-ABC), sensory (Sensory Profile), adaptive (Vineland); medical (genetic, metabolic selected); (2) **Comorbidities**: ID, ADHD, anxiety, seizures, GI, sleep, feeding, motor coordination disorder; (3) **Evidence-based interventions**: - **Behavioral** (NDBI — naturalistic developmental behavioral interventions; ESDM, JASPER, PRT, ABA-based) — strong evidence; - **Speech-language therapy** + AAC (PECS, devices) if non-verbal; - **OT**: sensory integration (selected), fine motor, ADLs; - **PT**: gross motor coordination, postural; - **Social skills training**; - **Parent-mediated** + parent training; (4) **Educational**: IEP, structured teaching (TEACCH), inclusion + supports; (5) **Pharmacotherapy** (targeted symptoms — not ASD core): risperidone/aripiprazole for irritability (FDA-approved), stimulants for ADHD, SSRI for anxiety, melatonin for sleep; (6) **Medical comorbidities**: GI (constipation common), sleep, feeding (selective eating), seizures; (7) **Family education + support**: respite, peer, advocacy; (8) **Transition planning** (school + adult); (9) **Caregiver mental health**; **Modern**: NDBI + family-centered + neurodiversity-affirming + targeted comorbidity

---

ASD multidisciplinary: NDBI (ESDM, JASPER) strong evidence + SLP + OT + PT + social skills + parent-mediated. Educational. Targeted pharma for comorbidity. Family support. Modern: neurodiversity-affirming.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'เด็กอายุ 4 ปี autism spectrum disorder — referred for rehab — motor + sensory + communication concerns';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single discipline"},{"label":"B","text":"Spina Bifida Comprehensive Care"},{"label":"C","text":"No bladder management — wait incontinence"},{"label":"D","text":"Latex products fine"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Spina Bifida Comprehensive Care: (1) **Multidisciplinary clinic** (gold standard): pediatric urology + neurosurgery + orthopaedics + physiatry + PT + OT + nursing + social work + nutrition + psychology + family; (2) **Neurogenic bladder**: CIC + anticholinergic/β3 + monitor upper tract (renal US, urodynamics); preserve renal function — leading cause mortality historically; SPT/augmentation selected; (3) **Neurogenic bowel**: bowel program (timing, stimulation, suppositories, enemas — antegrade continence enema via cecostomy/MACE selected), high-fiber, fluids; (4) **Hydrocephalus + Chiari II**: shunt monitoring + neurosurgery follow-up; symptoms (HA, vomiting, neuro decline, vision); (5) **Mobility**: thoracic level → wheelchair primary, standing programs (parapodium, KAFO), upper limb propulsion + shoulder preservation; (6) **Orthopaedic**: scoliosis (high rate thoracic level), hip + knee deformity, foot deformity, fractures (low BMD); (7) **Skin**: pressure injury prevention (insensate), daily checks, equipment fit; (8) **Latex allergy** — high prevalence — latex-free environment; (9) **Cognitive**: executive function issues common ("cocktail party syndrome"), neuropsych eval, school IEP; (10) **Sexual + reproductive** (adolescent/adult): counseling, fertility, pregnancy planning; (11) **Transition to adult care** (age 18-21) — challenging; (12) **Family + advocacy**; **Modern**: SBA (Spina Bifida Association) care guidelines + lifespan integrated

---

Spina bifida: multidisciplinary clinic. Neurogenic bladder (CIC + monitor) + bowel + hydrocephalus + Chiari + mobility + scoliosis + skin + latex allergy + cognitive + sexual + transition. Family.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'เด็กอายุ 12 ปี spina bifida (myelomeningocele) thoracic-level — multidisciplinary transition + bladder/bowel';

update public.mcq_questions
set choices = '[{"label":"A","text":"No follow-up — survived"},{"label":"B","text":"Pediatric Cancer Survivorship Rehab"},{"label":"C","text":"Single discipline"},{"label":"D","text":"Discharge to PCP only"},{"label":"E","text":"Avoid school"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Cancer Survivorship Rehab: (1) **Multidisciplinary**: oncology + physiatrist + PT + OT + SLP + neuropsychology + endocrinology + audiology + ophthalmology + social work + education + family; (2) **Late effects screening + management**: - **Neurocognitive**: chemo/radiation effects — attention, processing speed, memory, executive; neuropsych eval; cognitive rehab + school IEP/504 + accommodations; - **Motor + balance**: ataxia, weakness, neuropathy (vincristine), spasticity — PT + OT; - **Endocrinopathies**: GH deficiency (growth failure — GH replacement), hypothyroidism, gonadal failure — endocrine screen + treat; - **Cardiotoxicity** (anthracycline): echo + ECG surveillance; - **Hearing loss** (platinum agents, radiation): audio + hearing aids; - **Vision** (radiation): ophthalmology; - **Secondary malignancy** risk: surveillance; - **Fertility** future considerations; - **Psychosocial**: PTSD, anxiety, depression, social difficulties; family adjustment; (3) **School reintegration**: gradual + accommodations + IEP/504 + teacher education; (4) **Survivorship clinic + lifelong follow-up** (COG LTFU guidelines); (5) **Patient + family education + advocacy + peer support**; (6) **Adaptive PE + recreation**; (7) **Health behaviors**: nutrition, exercise, no tobacco, sun protection; (8) **Transition to adult survivorship care**; **Modern**: COG Long-Term Follow-Up Guidelines + survivorship clinics + integrated rehab

---

Pediatric cancer survivorship rehab: multidisciplinary late-effects (neurocognitive, motor, endocrine, cardiotoxicity, hearing, vision, secondary malignancy, fertility, psychosocial). School + survivorship clinic. COG guidelines.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'เด็กอายุ 6 ปี post-pediatric brain tumor (medulloblastoma) — completed chemo/radiation — multiple deficits';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait years for surgery"},{"label":"B","text":"Obstetric Brachial Plexus Palsy (OBPP) — Multidisciplinary"},{"label":"C","text":"No therapy needed"},{"label":"D","text":"Discharge"},{"label":"E","text":"Bedrest"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Obstetric Brachial Plexus Palsy (OBPP) — Multidisciplinary: (1) **Classification**: - Erb''s (C5-C6): waiter''s tip; - Extended Erb''s (C5-C7); - Klumpke (C8-T1) rare; - Total (C5-T1) + possible Horner''s; (2) **Prognosis**: ~80% recovery by 1 yr; but absent biceps recovery by 3 mo (Gilbert) or 6 mo (Waters) → poor — consider microsurgical reconstruction; (3) **Multidisciplinary team**: physiatry + neurosurgery/plastic + ortho + PT + OT + nursing + family; (4) **Early management** (birth to 3 mo): - PROM gentle: shoulder, elbow, forearm, wrist (parents trained); - Avoid pulling/stretching forcefully; - Positioning to prevent contractures + skin care; (5) **Assessment**: Active Movement Scale (AMS), Mallet (functional), Toronto Test Score, ROM, sensory; (6) **Microsurgery indication** (3-9 mo age): nerve graft + nerve transfer; outcomes best early; (7) **Secondary surgery** (1+ yr): muscle transfers, joint releases, tendon transfers for residual deformity; (8) **PT/OT**: ROM + strengthening + bimanual function + sensory + functional/ADL; (9) **Botulinum toxin** for muscle imbalance (e.g., subscapularis for shoulder internal rotation contracture); (10) **Joint surveillance**: shoulder (glenohumeral dysplasia from imbalance), elbow, forearm; (11) **Long-term**: school + adult function; family + child education; **Modern**: early multidisciplinary + microsurgery + neuromuscular reeducation

---

OBPP: classify (Erb most common). 80% recover but no biceps by 3-6 mo → microsurgery candidate. AMS/Mallet. Early PT/OT + PROM + family training. Microsurgery + secondary procedures. Joint surveillance.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'เด็กอายุ 3 ปี — brachial plexus birth palsy — no recovery elbow flexion at 6 mo of age';

update public.mcq_questions
set choices = '[{"label":"A","text":"Maximum intensity immediately"},{"label":"B","text":"Cardiac Rehab Phase II Exercise Prescription"},{"label":"C","text":"Bedrest 6 mo"},{"label":"D","text":"Single session only"},{"label":"E","text":"Anaerobic high-intensity only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cardiac Rehab Phase II Exercise Prescription: (1) **Pre-program evaluation**: Symptom-limited CPET (cardiopulmonary exercise test) — VO2 peak, anaerobic threshold (AT/VT1), heart rate (HR), BP, ECG, symptoms — gold standard for prescription; alternative submaximal (modified Bruce, 6MWT); (2) **Exercise prescription (FITT-VP)**: - **Frequency**: 3-5 sessions/wk (supervised + home); - **Intensity**: 40-80% HRR (Karvonen) or VO2 reserve; RPE 11-14 (Borg 6-20); or HR at AT; aim moderate-vigorous; - **Time**: 20-60 min aerobic + 5-10 min warm-up/cool-down; resistance 1-3 sets × 10-15 reps; - **Type**: aerobic (treadmill, cycle, elliptical, walking) + resistance (after 2-3 wk Phase II) + flexibility; - **Volume + Progression**: gradual; (3) **Monitoring**: continuous ECG initial sessions, BP, symptoms, RPE; (4) **Resistance training**: 1-3 sets, 8-15 reps, RPE 11-13, avoid Valsalva; (5) **Risk stratification** (low/moderate/high) — guides monitoring + supervision; (6) **Patient education**: meds, signs/symptoms, when to call, lifestyle; (7) **HIIT**: emerging evidence improves VO2 vs MICT — selected patients; (8) **Psychosocial + smoking cessation + dietary**; (9) **Outcomes**: VO2 peak, MET capacity, HR-rate response, BP, PROs; **Modern**: CPET-guided + HIIT + technology

---

Cardiac rehab Phase II: pre CPET + FITT-VP prescription. 40-80% HRR, RPE 11-14, 20-60 min, 3-5×/wk. Aerobic + resistance + flexibility. Risk stratify + monitor. HIIT emerging. Psychosocial + lifestyle.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 62 ปี post-MI + PCI 1 wk — phase II cardiac rehab + exercise prescription';

commit;
