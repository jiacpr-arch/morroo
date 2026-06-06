-- ===============================================================
-- หมอรู้ — Board seed: เวชศาสตร์ฟื้นฟู (rehab_medicine) — part 4/4 (50 MCQs)
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
  s.id, 'board', NULL, 'GMFCS — Gross Motor Function Classification System in cerebral palsy', '[{"label":"A","text":"10 levels"},{"label":"B","text":"GMFCS for Cerebral Palsy"},{"label":"C","text":"Changes daily"},{"label":"D","text":"Same for all ages"},{"label":"E","text":"Not standardized"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** GMFCS for Cerebral Palsy: (1) **Purpose**: standardized classification of gross motor function severity in CP — communication, prognosis, intervention planning, research; widely adopted; (2) **5 levels** (age-specific descriptions): - **Level I**: walks without limitations; - **Level II**: walks with limitations (long distances, terrain, balance); - **Level III**: walks using hand-held mobility device; community uses wheels; - **Level IV**: self-mobility w/ limitations; may use powered mobility; - **Level V**: transported in manual w/c; (3) **Age bands**: < 2 yr, 2-4, 4-6, 6-12, 12-18 — each age band has specific descriptors; (4) **Stability**: GMFCS level is stable over time after age 2 (predictive for life); permits prognostic discussions; (5) **GMFM (Gross Motor Function Measure)**: separate — performance measure (88 items GMFM-88 or 66-item GMFM-66) — tracks change over time; complementary to GMFCS; (6) **Hip surveillance** by GMFCS: - GMFCS I: less frequent radiograph; - GMFCS II-V: regular hip surveillance (especially III-V) — risk subluxation/dislocation; programs (e.g., Australian, Swedish CPUP) reduce dislocation; (7) **Other classifications**: - **MACS** (Manual Ability Classification System) — UE function; - **CFCS** (Communication Function); - **EDACS** (Eating + Drinking Ability); (8) **Application**: clinical care + research + family communication + transition planning; (9) **Modern**: stratified care + outcome-tracking + integrated multidisciplinary CP care

---

GMFCS: 5 levels CP gross motor severity. Age bands. Stable after age 2 → prognostic. GMFM performance measure complementary. Hip surveillance by level. MACS/CFCS/EDACS additional. Stratified care.', NULL,
  'easy', 'neurology', 'review',
  'rehab_medicine', 'basic_science', 'neurology', 'peds',
  'Palisano GMFCS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'GMFCS — Gross Motor Function Classification System in cerebral palsy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ICF — International Classification of Functioning, Disability, Health — framework', '[{"label":"A","text":"Single body function only"},{"label":"B","text":"ICF Framework (WHO 2001)"},{"label":"C","text":"Replaces ICD"},{"label":"D","text":"Medical-only model"},{"label":"E","text":"Not used"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ICF Framework (WHO 2001): (1) **Purpose**: biopsychosocial framework — common language for functioning + disability + health across health professions + research + policy; complement ICD; (2) **Components**: - **Body Functions + Structures**: physiological functions (b-codes) + anatomical parts (s-codes); impairments are problems; - **Activities**: execution of tasks/actions (d-codes); activity limitations; - **Participation**: involvement in life situations (d-codes shared with activities); restrictions; - **Contextual Factors**: - **Environmental**: physical + social + attitudinal (e-codes); - **Personal**: age, gender, race, lifestyle, coping, education (not classified); (3) **Qualifiers**: severity (0-4) for each code; (4) **Bio-psycho-social model**: disability not solely individual but interaction person + environment; (5) **Application rehabilitation**: - Holistic assessment + goal setting; - Documentation + communication; - Outcome measurement; - Research + policy; - Education; (6) **Core sets**: ICF-based standardized profiles for specific conditions (stroke, SCI, LBP, RA, etc.) — facilitate documentation; (7) **ICF-CY**: children + youth version; (8) **Outcome measures linked to ICF**: many — multidimensional approach; (9) **Strengths**: universal + comprehensive + biopsychosocial + non-discriminatory; (10) **Limitations**: complex + time to learn + documentation burden + need for tools; (11) **Modern application**: e-rehabilitation + interdisciplinary team common framework + person-centered + value-based care; (12) **Examples**: - Body function: range of motion, strength, cognition; - Activity: walking, dressing, communication; - Participation: work, recreation, social roles; - Environmental: family support, ramps, attitudes, services; - Personal: motivation, coping

---

ICF: WHO biopsychosocial framework. Components: Body Functions/Structures + Activities + Participation + Contextual (Environmental + Personal). Application: holistic assessment + outcomes + research. Core sets. ICF-CY pediatric. Person-centered.', NULL,
  'medium', 'signs_symptoms', 'review',
  'rehab_medicine', 'basic_science', 'signs_symptoms', 'mixed',
  'WHO ICF 2001', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ICF — International Classification of Functioning, Disability, Health — framework'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Biomechanics — joint reaction forces + lever systems in rehab', '[{"label":"A","text":"No effect on rehab"},{"label":"B","text":"Biomechanics of Joint Forces"},{"label":"C","text":"Same force regardless position"},{"label":"D","text":"Always class 1"},{"label":"E","text":"No lever effect"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Biomechanics of Joint Forces: (1) **Levers + classes**: - **Class 1**: fulcrum between effort + load (atlanto-occipital, scissors); - **Class 2**: load between effort + fulcrum (calf raise — distal foot fulcrum, gastroc effort, body load); - **Class 3** (most musculoskeletal): effort between fulcrum + load (elbow flexion — elbow fulcrum, biceps effort, hand load) — emphasizes speed/range over force; mechanical disadvantage; (2) **Joint reaction force** = sum of forces at joint = applied forces + muscle forces (often dominant); muscle force amplified due to short moment arms; (3) **Hip joint reaction force** (Pauwels): - Single-leg stance: hip JRF ~3× body weight (BW) — small abductor moment arm vs long body weight moment; - Walking: 3-5× BW; - Running: 6-10× BW; - Cane in contralateral hand: reduces JRF ~30% (longer moment arm); same hand only ~10%; ipsilateral hand on affected side counter-productive; (4) **Knee JRF**: walking 3-4× BW; stairs/squat 5-8× BW; running 7-12×; (5) **Implications for rehab**: - Cane (contralateral) for hip arthroplasty/arthritis — reduces JRF; - Weight reduction major (each lb hip JRF ~3-4 lb); - Strengthening adjacent (abductors, quadriceps); - Activity modification (avoid deep squat, jumps for joint-protected); - Footwear, surface (concrete > grass); - Bone density (Wolff''s law — bone adapts to load); - Cartilage — needs loading for nutrition but pathology w/ overload; (6) **Tendon mechanics**: stress, strain, viscoelastic; loading + recovery cycle; (7) **Posture + alignment**: static + dynamic — affects forces; (8) **Application**: orthoses, assistive devices, exercise progression, activity modification, gait analysis, surgical planning; **Modern**: musculoskeletal modeling + 3D gait analysis + finite element + personalized biomechanics

---

Biomechanics levers: class 1, 2, 3 (most MSK). JRF = applied + muscle forces; muscle dominates. Hip 3× BW single-leg, walking 3-5× BW; cane contralateral reduces 30%. Knee 3-4× BW walking. Application: assistive devices + weight + activity modification.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'rehab_medicine', 'basic_science', 'msk_nontrauma', 'adult',
  'Pauwels; Inman', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Biomechanics — joint reaction forces + lever systems in rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Bone remodeling + osteoporosis pathophysiology — fracture prevention', '[{"label":"A","text":"Bone is static"},{"label":"B","text":"Bone Biology + Osteoporosis"},{"label":"C","text":"Single cell type"},{"label":"D","text":"No regulation"},{"label":"E","text":"Treatment ineffective"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bone Biology + Osteoporosis: (1) **Bone cells**: - **Osteoblasts** (bone formation, from MSCs); - **Osteocytes** (terminal — mechano-sensing); - **Osteoclasts** (bone resorption, from monocyte lineage); (2) **Bone remodeling cycle**: activation (osteoclasts) → resorption → reversal → formation (osteoblasts) → mineralization; ~10% bone remodeled annually; coupled — coordinated; (3) **Regulation**: RANK/RANKL/OPG (osteoclastogenesis), sclerostin (Wnt inhibition), PTH, calcitriol (vit D), calcitonin, estrogen + testosterone (anti-resorptive), mechanical loading (Wolff''s law); (4) **Bone density measurement**: - **DXA** (gold standard): T-score (vs young adult — postmenopausal/men ≥ 50; osteoporosis T ≤ -2.5, osteopenia -1 to -2.5); Z-score (age-matched — pre-menopausal); - **CT, US, MRI**: research/alternative; (5) **Osteoporosis pathophysiology**: imbalance — resorption > formation (postmenopausal estrogen decline ↑ resorption; age-related ↓ formation); (6) **Fracture risk assessment** (FRAX): 10-yr probability major osteoporotic + hip fx — clinical factors + DXA; (7) **Treatment**: - **First-line**: bisphosphonates (alendronate, risedronate, IV zoledronate — anti-resorptive); - **Denosumab** (Prolia — RANKL inhibitor — anti-resorptive); rebound on cessation; - **Anabolic** (teriparatide, abaloparatide — PTH analogs; romosozumab — anti-sclerostin) for severe; sequential — anabolic → anti-resorptive; - **Estrogen, raloxifene** (SERM); - **Ca + Vit D** baseline; (8) **Lifestyle + nutrition**: protein, Ca, vit D, weight-bearing exercise, fall prevention, smoking + alcohol moderation; (9) **Fracture liaison service (FLS)**: post-fragility fracture — reduces subsequent fractures ~50%; (10) **Rehab integration**: bone health post-fx + post-immobilization + post-SCI/stroke (high osteoporosis); fall prevention; **Modern**: targeted + sequential therapy + FLS integration

---

Bone: osteoblast/osteocyte/osteoclast remodeling cycle. Regulation RANKL/OPG + PTH + vit D + estrogen + mechanical. DXA T-score. Osteoporosis = resorption > formation. Tx: bisphosphonates + denosumab + anabolic (teriparatide). FLS. Rehab integration.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'rehab_medicine', 'basic_science', 'endocrine_metabolic', 'adult',
  'AACE/ACE; ASBMR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Bone remodeling + osteoporosis pathophysiology — fracture prevention'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Pain neuroscience — peripheral + central + descending modulation', '[{"label":"A","text":"Single pathway"},{"label":"B","text":"PAG → RVM → dorsal horn"},{"label":"C","text":"No modulation"},{"label":"D","text":"Peripheral only"},{"label":"E","text":"No CNS role"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pain Neuroscience: (1) **Nociception pathway**: stimulus → nociceptor (Aδ + C fibers) → DRG → dorsal horn → spinothalamic (lateral) → thalamus → cortex (S1, S2, insula, ACC); (2) **Peripheral**: TRPV1, TRPA1, Nav1.7/8 channels, prostaglandins, bradykinin, CGRP, substance P; targets for analgesics (NSAID — COX; topical capsaicin — TRPV1); (3) **Spinal cord**: dorsal horn — lamina I + II (substantia gelatinosa) — modulation site; gate theory (Wall & Melzack) — Aβ activation inhibits C fiber (basis for TENS, rubbing); (4) **Ascending tracts**: spinothalamic (pain + temp), spinoreticular (arousal), spinomesencephalic (PAG modulation), spinohypothalamic (autonomic), DCML (vibration + proprioception, NOT pain primarily); (5) **Cortical**: discrimination (S1, S2) + affective (insula, ACC) + cognitive-emotional (PFC); pain is multidimensional experience; (6) **Descending modulation**: - **PAG → RVM → dorsal horn**: serotonergic + noradrenergic + opioid — basis for SNRI/TCA + opioids analgesia; - **DNIC/CPM** (conditioned pain modulation) — diffuse noxious inhibitory control; impaired in chronic pain; (7) **Central sensitization**: - Spinal — wind-up (NMDA), LTP-like, glia activation; - Supraspinal — cortical reorganization; - **Manifestations**: hyperalgesia (↑ response noxious), allodynia (pain non-noxious), expansion receptive fields; chronic pain + fibromyalgia + central pain; (8) **Neuropathic pain mechanisms**: peripheral (neuroma, ectopic), central (CNS lesion — central post-stroke, SCI), sensitization, ion channel changes (Nav1.7), neuro-immune; (9) **Targets — analgesics**: - NSAIDs (COX), acetaminophen (TRPV1 selected), opioids (μ-receptor → presynaptic + postsynaptic), local anesthetics (Nav), gabapentinoids (α2δ Ca channel), TCA/SNRI (descending), ketamine (NMDA), cannabinoids (CB1, CB2), topical (capsaicin, lidocaine); (10) **Non-pharm**: TENS (gate + endogenous opioid), exercise (descending modulation, BDNF, endorphins), CBT/mindfulness (cortical), placebo (endogenous opioid PAG); (11) **Pain neuroscience education (PNE)**: changes pain understanding + experience; **Modern**: targeted molecular + biopsychosocial + central sensitization framework

---

Pain: peripheral nociceptor (Aδ, C, TRP) → spinal (dorsal horn, gate theory) → ascending (STT) → cortex multidimensional. Descending PAG-RVM (5HT, NE, opioid — SNRI/TCA basis). Central sensitization. Mechanisms guide pharm + non-pharm.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'basic_science', 'neurology', 'adult',
  'IASP; Melzack', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Pain neuroscience — peripheral + central + descending modulation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Electrodiagnosis — NCS + EMG principles + clinical application', '[{"label":"A","text":"Single test"},{"label":"B","text":"Electrodiagnostic Testing"},{"label":"C","text":"No clinical use"},{"label":"D","text":"Painless always"},{"label":"E","text":"Replaces clinical exam"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Electrodiagnostic Testing: (1) **Components**: nerve conduction studies (NCS) + needle electromyography (EMG) + late responses (F-waves, H-reflexes); (2) **NCS — motor**: stimulate nerve → record from muscle; measures: - Distal motor latency (DML) — onset to peak/onset; - Amplitude (CMAP — compound muscle AP); - Conduction velocity; - Late responses (F-wave); (3) **NCS — sensory**: stimulate digit/nerve → record from nerve; measures: - Onset/peak latency; - Sensory NAP amplitude; - Sensory conduction velocity; (4) **EMG needle exam**: assesses motor unit electrical activity; - **Spontaneous activity**: fibrillations + positive sharp waves (denervation, myopathy), fasciculations (motor neuron, irritation), myotonia (myotonic dystrophy, hyperK PP, etc.), complex repetitive discharges (chronic neurogenic); - **Motor unit AP (MUAP)** morphology: amplitude + duration + phases; reinnervation → large polyphasic long-duration; myopathy → small short polyphasic; - **Recruitment**: reduced (neurogenic) vs early/full (myopathic); (5) **Localization (KEY for diagnosis)**: - **Demyelinating**: prolonged latencies, slowed velocities, conduction block (segmental); (e.g., GBS, CIDP, CMT1); - **Axonal**: decreased amplitudes, eventual denervation, reinnervation MUAPs; (e.g., DM neuropathy, ALS, GBS-AMAN); - **NMJ disorders**: repetitive nerve stim — decrement (myasthenia), increment (LEMS); jitter (single-fiber EMG); - **Myopathy**: short polyphasic MUAPs, early recruitment, ± fibrillations (inflammatory); (6) **Common indications**: radiculopathy, plexopathy, mononeuropathy (CTS, ulnar, peroneal), polyneuropathy (DM, etc.), motor neuron disease (ALS), myopathy, NMJ; (7) **Pearls**: temperature affects (warm 32-34°C limb), age + height, timing (denervation changes 2-3 wk post-injury), clinical correlation; (8) **Limitations**: technical, sampling, interpretation skill, patient cooperation; (9) **Reporting standards** (AANEM): complete + clinical correlation + localization + Tx implications; **Modern**: US adjunctive + standardized protocols + integrated clinical exam

---

EDX: NCS (motor + sensory) + EMG needle + late responses. Demyelinating (latency/velocity/block) vs axonal (amplitude/denervation/reinnervation). NMJ (decrement/increment). Myopathy (small polyphasic). Localization + Dx. Temperature + timing matters.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'basic_science', 'neurology', 'adult',
  'AANEM EDX', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Electrodiagnosis — NCS + EMG principles + clinical application'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Ultrasound in PM&R — musculoskeletal + nerve + intervention', '[{"label":"A","text":"Replaces all imaging"},{"label":"B","text":"Musculoskeletal Ultrasound"},{"label":"C","text":"No interventional use"},{"label":"D","text":"Single application"},{"label":"E","text":"Requires radiation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Musculoskeletal Ultrasound: (1) **Advantages**: real-time + dynamic + high resolution superficial + no radiation + accessible + low-cost + portable + comparison side-to-side + interventional guidance; (2) **Probe selection**: linear high-frequency (10-18 MHz) for superficial MSK; curved/low for deep; (3) **MSK applications**: - **Joints**: effusion, synovitis, erosions; - **Tendons**: tendinopathy (thickening, hypoechoic, hyperemia w/ Doppler), tears (partial vs full), calcification; rotator cuff, Achilles, patellar, common extensor; - **Ligaments**: tears, sprains; - **Muscles**: tears, hematoma, atrophy; - **Bursae**: bursitis; - **Bone**: cortical irregularity, periosteum, fracture (rib, sternum); - **Cartilage** limited; (4) **Nerve US (neuromuscular)**: - Median (CTS — cross-sectional area > 10-12 mm² at carpal tunnel suggestive); ulnar (cubital, wrist); peroneal; sciatic; brachial plexus; - Detects enlargement (entrapment, neuropathy), masses, anatomic variation; complementary to EDX; (5) **Interventional US-guidance** (preferred over landmark/blind for accuracy + safety): - Joint injections: subacromial, AC, GH, hip, knee, ankle, SI, facet; - Tendon: peritendinous (avoid intratendinous steroid); - Bursae; - Nerve blocks: peripheral (ulnar, radial, sciatic, femoral, etc.), genicular (knee neurolysis), suprascapular; - Botulinum toxin injections (spasticity, dystonia); - Hydrodissection nerve; - PRP, prolotherapy, viscosupplementation; (6) **Advantages vs fluoro**: no radiation, soft tissue, real-time needle visualization; (7) **Training + certification**: structured curriculum (AAPM&R, AIUM, fellowship); (8) **Limitations**: operator-dependent, depth, bone (acoustic shadow), training time; (9) **Documentation**: images + report standards; (10) **Modern**: POCUS in PM&R growing + high-resolution emerging + AI-assisted

---

MSK US: advantages real-time + dynamic + accessible + no radiation. Apps: joints, tendons (tendinopathy, tears), ligaments, muscle, nerve (CTS), interventional (joint, peripheral nerve, BoNT injections). US-guided > blind. Training required. Modern: POCUS + AI.', NULL,
  'medium', 'procedures', 'review',
  'rehab_medicine', 'basic_science', 'procedures', 'adult',
  'AIUM; AAPM&R', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Ultrasound in PM&R — musculoskeletal + nerve + intervention'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Outcome measurement — PROs + clinical scales in rehab — PROMIS', '[{"label":"A","text":"No outcomes needed"},{"label":"B","text":"Outcome Measurement in Rehab"},{"label":"C","text":"Single measure for everything"},{"label":"D","text":"Subjective only"},{"label":"E","text":"Not validated"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Outcome Measurement in Rehab: (1) **Categories**: - **Clinician-rated**: FIM, GMFM, Barthel, Berg Balance, 10MWT, 6MWT, TUG; - **Patient-reported outcomes (PROs)**: SF-36, PROMIS, condition-specific (e.g., ODI for back, KOOS for knee, DASH for arm, PDQ-39 for PD, MSIS-29 for MS, BCTQ for CTS); - **Performance-based**: handheld dynamometry, gait analysis, hop tests; (2) **PROMIS** (Patient-Reported Outcomes Measurement Information System) — NIH-developed: - Standardized + IRT-based; - Multi-domain: physical (function, pain, fatigue), mental (depression, anxiety), social, global; - Short forms + CAT (computer adaptive testing) — fewer items same precision; - T-score 50 = US population mean + 10 SD = 1 SD; - Translation + cross-cultural; - Universal + condition-agnostic; (3) **Properties to consider**: - Validity (content, construct, criterion); - Reliability (test-retest, internal); - Responsiveness (sensitivity to change); - Minimal clinically important difference (MCID); - Floor/ceiling; - Burden + acceptability; - Translation/cultural; (4) **Standardized core sets** for conditions (ICF-based): - Stroke (mRS, NIHSS, FAC, BI/FIM); - SCI (ASIA, SCIM, WISCI-II); - TBI (DRS, GOS-E); - LBP (ODI, RMDQ, NRS, GROC); - Common: PROMIS, EQ-5D, SF-36; (5) **Performance vs capability vs perception**: triangulate; (6) **Goal Attainment Scaling (GAS)**: individualized goals + standardized scoring; (7) **Use**: clinical (goal-setting + progress + decisions) + research + quality + payment; (8) **CMS IRF-PAI Section GG** (USA): standardized functional + cognitive items at admit + DC — replaced FIM for payment 2018+; (9) **Electronic capture**: EHR + apps + remote; (10) **Modern**: PROMIS + ICF core sets + GAS + technology + value-based care

---

Rehab outcomes: clinician-rated (FIM, scales, performance) + PROs (PROMIS, SF-36, condition-specific) + performance. PROMIS IRT-based multi-domain + CAT. Properties (validity, reliability, responsiveness, MCID). Core sets. GAS. CMS GG codes. Modern: tech + value-based.', NULL,
  'medium', 'signs_symptoms', 'review',
  'rehab_medicine', 'basic_science', 'signs_symptoms', 'adult',
  'PROMIS; CMS IRF-PAI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Outcome measurement — PROs + clinical scales in rehab — PROMIS'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Cardiopulmonary exercise testing (CPET) — interpretation + rehab application', '[{"label":"A","text":"Single variable"},{"label":"B","text":"CPET — Cardiopulmonary Exercise Testing"},{"label":"C","text":"No exercise prescription role"},{"label":"D","text":"Painful always"},{"label":"E","text":"Not validated"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** CPET — Cardiopulmonary Exercise Testing: (1) **Setup**: incremental exercise (treadmill or cycle) w/ continuous gas exchange (VO2, VCO2, VE) + ECG + BP + SpO2 + symptoms; (2) **Key variables**: - **VO2 peak**: max O2 uptake at exercise peak — overall functional capacity; - **VO2max**: "true" max — plateau or RER > 1.1, age-predicted; - **Anaerobic threshold (AT/VT1)**: lactate threshold inferred — V-slope, RER 1.0, ventilatory equivalents; - **VT2/RCP** (respiratory compensation point); - **VE/VCO2 slope** + intercept: ventilatory efficiency (elevated in HF, pulm HTN, PAH); - **Heart rate response, HR reserve, HRR (HR recovery 1 min)**; - **O2 pulse** (VO2/HR — surrogate stroke volume); - **Breathing reserve**; - **Peak RER** (effort indicator); - **Workload + duration**; (3) **Indications**: - **Pre-rehab prescription** (intensity zones); - **Functional limitation evaluation** (cardiac vs pulm vs deconditioning vs other); - **Pre-op risk stratification** (thoracic, abdominal, transplant); - **Prognosis** in HF (VO2 < 14 mL/kg/min — transplant candidacy); - **Pulmonary HTN, PAH** (prognosis); - **CPET-guided rehab in cancer, organ transplant**; (4) **Exercise prescription from CPET**: - Aerobic intensity at AT/VT1 (long endurance) or between VT1-VT2 (moderate-high); - HIIT can use peak workload intervals; (5) **Submaximal alternatives** when CPET unavailable: 6MWT, ISWT, Bruce treadmill; less precise but useful; (6) **Special populations**: - Denervated heart (transplant): RPE > HR; - Pacemaker/rate-fixed: VO2 + workload; - β-blocker: HR blunted — use RPE/workload; - Hypoxic populations: SpO2 monitor + O2 supplementation; (7) **Risks**: rare — arrhythmia, ischemia, MSK; pre-test screening; (8) **Multidisciplinary interpretation**: cardiology + pulm + physiatry + exercise physiologist; **Modern**: precision prescription + integrated outcome

---

CPET: VO2 peak + AT/VT1 + VE/VCO2 slope + HR/O2 pulse + RER. Indications: prescription + functional eval + prognosis + pre-op. AT-based intensity. Submax alternatives (6MWT). Special populations adjustments. Modern: precision exercise.', NULL,
  'hard', 'cardiovascular', 'review',
  'rehab_medicine', 'basic_science', 'cardiovascular', 'adult',
  'ATS/ERS CPET; ESC', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Cardiopulmonary exercise testing (CPET) — interpretation + rehab application'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Spinal cord — anatomy + tracts + clinical localization', '[{"label":"A","text":"Single tract"},{"label":"B","text":"Spinal Cord Anatomy + Tracts"},{"label":"C","text":"No clinical relevance"},{"label":"D","text":"All decussate medulla"},{"label":"E","text":"No blood supply"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Spinal Cord Anatomy + Tracts: (1) **Gross**: 31 segments (8C, 12T, 5L, 5S, 1Co); cord ends conus medullaris ~L1-L2 adult; cauda equina below; enlargements C5-T1 (UE) + L2-S3 (LE); (2) **Gray matter (H-shaped)**: - Anterior horn — motor neurons; - Posterior horn — sensory; - Lateral horn (T1-L2) — sympathetic; sacral (S2-4) — parasympathetic; (3) **White matter tracts**: - **Ascending sensory**: - **Dorsal columns** (DCML): fasciculus gracilis (LE, medial) + cuneatus (UE, lateral); fine touch, vibration, proprioception, 2-pt discrimination; ipsilateral until medulla nuclei → decussate; - **Spinothalamic** (lateral + anterior): pain + temp + crude touch; decussate immediately at entry level (within 1-2 segments) → contralateral; - **Spinocerebellar** (dorsal + ventral): proprioception to cerebellum (ipsilateral unconscious); - **Descending motor**: - **Lateral corticospinal**: 90% — decussated in medulla pyramids; distal limb fine motor; - **Anterior corticospinal**: 10% — uncrossed; trunk + proximal; - **Rubrospinal, reticulospinal, vestibulospinal, tectospinal**: postural + reflexive; (4) **Common SCI syndromes**: - **Complete transection** below: motor + sensory lost; - **Central cord** (older, hyperextension): UE > LE weakness, sacral sparing; - **Anterior cord** (ASA infarct): motor + pain/temp lost below; DCML preserved; poor prognosis; - **Posterior cord** rare: DCML lost; motor + ST preserved; - **Brown-Séquard** (hemicord — penetrating): ipsilateral motor + DCML loss; contralateral pain/temp loss (1-2 segments below); - **Conus medullaris**: mixed UMN/LMN, sacral, sudden + symmetric; - **Cauda equina**: LMN, multiple roots, asymmetric, radicular, slowly progressive (less commonly sudden — surgical emergency); (5) **Blood supply**: anterior spinal artery (anterior 2/3) + 2 posterior spinal (posterior 1/3); radicular contributors (Adamkiewicz T9-T12 — vulnerable); (6) **Cord vs vertebral level mismatch**: cord ends L1-L2 — discrepancy increases caudally (e.g., T10 vertebra ≈ L1 cord); (7) **Application clinical**: precise localization + injury patterns + prognosis + rehab; **Modern**: imaging + clinical exam + emerging therapeutics

---

Cord: gray (anterior motor, posterior sensory, lateral autonomic). White tracts — DCML (ipsi → medulla decussation; fine touch, vibration, proprio) + spinothalamic (immediate decussation; pain/temp) + corticospinal (medullary decussation). Syndromes localize. Blood supply (Adamkiewicz). Modern integrated.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'basic_science', 'neurology', 'adult',
  'Netter; ISNCSCI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Spinal cord — anatomy + tracts + clinical localization'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Peripheral nerve anatomy + classification of injury (Seddon, Sunderland)', '[{"label":"A","text":"Single grade"},{"label":"B","text":"Peripheral Nerve Injury Classification"},{"label":"C","text":"All require surgery"},{"label":"D","text":"No recovery possible"},{"label":"E","text":"Immediate full recovery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Peripheral Nerve Injury Classification: (1) **Anatomy**: axon + Schwann cell (myelin) + endoneurium → fascicle (perineurium) → epineurium; vascular supply (vasa nervorum); fascicular pattern intraneural; (2) **Seddon (1943) — physiologic**: - **Neuropraxia**: temporary conduction block (segmental demyelination); axon intact; recovery weeks-months without intervention; - **Axonotmesis**: axon disruption but endoneurium intact (axonal injury, Wallerian degeneration distal); recovery via axonal regrowth ~1 mm/day; - **Neurotmesis**: complete nerve disruption (including connective tissue); requires surgical repair; (3) **Sunderland (1951) — anatomic 5 degrees**: - **I**: neuropraxia (demyelinating block); recovery days-wks; - **II**: axon disrupted, endoneurium intact (axonotmesis); recovery weeks-months 1 mm/d; - **III**: axon + endoneurium disrupted, perineurium intact; incomplete recovery; - **IV**: axon + endo + perineurium disrupted, epineurium intact; poor recovery → surgical; - **V**: complete nerve disruption (neurotmesis); surgical repair; - **VI** (Mackinnon — mixed injury): combination grades in different fascicles; (4) **Wallerian degeneration**: distal axon degeneration starts day 2-3 post-axonal injury; complete by 2-3 weeks; (5) **Reinnervation**: 1 mm/d (1 inch/mo) regeneration rate; collateral sprouting from intact axons (recovery 2-6 mo); axonal regrowth slower (months-yr); (6) **Clinical signs**: motor + sensory + autonomic deficit; Tinel sign advances distally w/ regeneration; recovery pattern follows nerve distribution; (7) **EDX timing**: 2-3 wk post-injury for denervation potentials + assessment severity; serial; (8) **Imaging adjunct**: MRI, US (visualize nerve + lesion); (9) **Treatment**: - Conservative (compression, mild): rest + PT + therapy; - Surgical (transection, severe, plateau recovery): repair (epineurial, perineurial, fascicular), graft (sural nerve), nerve transfer (faster — bypass denervation time), TMR; - Rehab: ROM + splint (prevent contracture) + sensory re-education + functional + adaptive; (10) **Outcomes**: motor recovery, sensory return, function, EDX, PROs; **Modern**: nerve transfer + advanced grafting + biologics + selective neurectomy/TMR

---

Nerve injury: Seddon (neuropraxia, axonotmesis, neurotmesis); Sunderland I-V (+ VI Mackinnon). Wallerian degeneration distal. Recovery 1 mm/d. Conservative vs surgical (repair, graft, nerve transfer, TMR). Rehab. Modern: nerve transfer.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'basic_science', 'neurology', 'adult',
  'Seddon; Sunderland; Mackinnon', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Peripheral nerve anatomy + classification of injury (Seddon, Sunderland)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Rehabilitation pharmacology — managing spasticity systematically', '[{"label":"A","text":"Single drug for all"},{"label":"B","text":"Spasticity Pharmacology Systematic Review"},{"label":"C","text":"Surgery first-line"},{"label":"D","text":"Bedrest only"},{"label":"E","text":"No treatment needed"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Spasticity Pharmacology Systematic Review: (1) **Definition**: velocity-dependent increase in tonic stretch reflex (UMN); component of UMN syndrome (also weakness, slowness, fatigability, dyssynergia); (2) **Tx ladder**: address contributors + non-pharm → focal → systemic → invasive; (3) **Oral antispasticity**: - **Baclofen**: GABA-B agonist; titrate 5 mg TID → 80 mg/d max; SE — sedation, weakness, confusion; do NOT abruptly stop (withdrawal — fever, severe spasticity, seizure, rhabdo); renal dosing; - **Tizanidine**: α2-agonist; 2 mg → 36 mg/d max; SE — sedation, hypotension, dry mouth, LFT (monitor); preferred when spasms; - **Benzodiazepines** (clonazepam, diazepam): GABA-A; SE — sedation, dependence, cognition; useful spasms at night; - **Dantrolene**: peripheral (ryanodine receptor — Ca release); useful in cerebral spasticity less in spinal; SE — hepatotoxicity (monitor LFT), weakness systemic; - **Gabapentin/pregabalin**: GABA analog; useful for spasticity + neuropathic pain; SE — sedation, edema, dizziness; - **Cyproheptadine**: 5HT antagonist; selected spasms; - **Cannabinoids** (nabiximols/Sativex): MS spasticity evidence (where available); (4) **Focal**: - **BoNT-A** (target muscles, dose by weight + clinical, US/EMG-guided, q3-4 mo, adjunct PT/casting); - **Phenol/alcohol** motor point or nerve block (longer duration, technical, dysesthesia risk); (5) **Invasive**: - **ITB pump**: refractory generalized; trial → implant; risks (withdrawal/overdose); 24/7 emergency; - **SDR** (selected pediatric/adult — ambulatory CP/spastic diplegia); - **Surgical** orthopaedic (tendon lengthening/transfer) for established contracture; (6) **Multidisciplinary** + goal-setting (GAS) essential; (7) **Outcomes**: Ashworth, Tardieu, function, ROM, ADL, GAS, PROs; (8) **Address contributors** FIRST (UTI, constipation, pain, skin, infection — exacerbate); **Modern**: integrated ladder + goal-directed + US-guided focal + technology

---

Spasticity Rx ladder: address contributors → non-pharm → focal (BoNT, phenol) → systemic (baclofen, tizanidine, benzo, dantrolene, gabapentinoid, cannabinoid) → invasive (ITB, SDR, surgery). Goal-directed multidisciplinary.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'basic_science', 'neurology', 'adult',
  'AAPM&R; AANEM; AAN', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Rehabilitation pharmacology — managing spasticity systematically'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Wheelchair seating + pressure injury prevention biomechanics', '[{"label":"A","text":"Single cushion for all"},{"label":"B","text":"Wheelchair Seating + Pressure Injury Prevention"},{"label":"C","text":"Bedrest only"},{"label":"D","text":"No relief needed"},{"label":"E","text":"Pressure unrelated"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Wheelchair Seating + Pressure Injury Prevention: (1) **Pressure injury risk** in W/C users: insensate (SCI), prolonged sitting, friction/shear, moisture, malnutrition, age, deformity; (2) **Pressure-redistribution principles**: - **Reduce peak pressures** under bony prominences (ischial tuberosities, sacrum, greater trochanter, heel); - **Maximize contact area** (immersion in soft surface); - **Pressure-mapping** to optimize; (3) **Cushion types**: - **Foam** (basic, light, moderate redistribution); - **Gel** (good redistribution); - **Air** (ROHO — adjustable, maximum redistribution, requires adherence); - **Hybrid** (best of multiple); - **Custom contoured** for complex needs; - **Specialized** (alternating air, etc.); (4) **Pressure relief activities** (KEY for insensate): - **Push-ups** (lift) every 15-30 min for ~30 sec — high UE strain in SCI; - **Lateral lean / forward lean** alternative; - **Power tilt-in-space** for those unable to do active relief (KEY for high tetraplegic); - **Recline** (less effective alone — shear); (5) **Wheelchair fit**: - Seat width (1-2 cm clearance each side); - Seat depth (clearance behind knee 2-4 cm); - Seat height (footrest clears floor); - Backrest height (function-dependent); - Armrest height (90° elbow flex); - Tilt + recline; (6) **Postural support**: lateral supports + headrest + chest harness + abductor + heel loops; (7) **Skin care**: daily inspection (mirror), hygiene, moisturize, avoid maceration, address incontinence; (8) **Education + adherence**: critical — patient + caregiver; pressure-relief reminders (timers, smartwatch); (9) **Equipment maintenance**: cushion inflation (ROHO), wear check, replacement (3-5 yr typical); (10) **Multidisciplinary**: OT/PT seating clinic + supplier + physiatry + WOCN + patient; (11) **Outcomes**: pressure injury occurrence/recurrence, comfort, function, satisfaction; **Modern**: smart cushions + pressure-mapping + reminders + integrated WOCN

---

W/C seating + PrI prevention: cushions (foam → gel → air → hybrid). Pressure relief (push-up, lean, tilt) q15-30 min. W/C fit. Postural support. Skin care daily. Education adherence. Multidisciplinary seating clinic. Modern: smart + pressure-mapping.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'basic_science', 'neurology', 'adult',
  'RESNA; PVA; NPIAP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Wheelchair seating + pressure injury prevention biomechanics'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Pediatric motor development milestones + assessment', '[{"label":"A","text":"Single milestone"},{"label":"B","text":"Pediatric Motor Development"},{"label":"C","text":"No assessment"},{"label":"D","text":"Pathologic regression normal"},{"label":"E","text":"No early intervention"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Motor Development: (1) **Cephalocaudal + proximal-to-distal** progression; (2) **Gross motor milestones** (typical ranges; concern if exceed upper): - 2 mo: lifts head prone; - 4 mo: rolls front to back; supports head; - 6 mo: sits supported, rolls both directions; - 9 mo: sits independently, crawls, pulls to stand; - 12 mo: walks w/ support, takes first steps (range 9-18 mo); - 15-18 mo: walks well, climbs stairs (assistance); - 2 yr: runs, kicks ball, walks up stairs; - 3 yr: jumps, pedals tricycle, stands on one foot briefly; - 4 yr: hops, alternates stairs reciprocally; - 5 yr: skips, balances 10 sec; (3) **Fine motor**: - 4 mo: brings hands to midline, grasps; - 6 mo: transfers objects; - 9 mo: pincer grasp emerging; - 12 mo: refined pincer, releases voluntarily; - 18 mo: tower 3-4 blocks; - 2 yr: tower 6 blocks; - 3 yr: copies circle; - 4 yr: copies cross + square; - 5 yr: triangle, draws person 6 parts; (4) **Other domains**: language, social, cognitive — assess all; (5) **Red flags** for further evaluation: - Persistent fisting > 3 mo (CP risk); - Asymmetry (hemiplegic CP); - Lost milestones (regression — autism, neurodegenerative); - Hand preference < 18-24 mo (often pathologic in young — CP); - Not walking by 18 mo; - Not running by 2 yr; - Not stairs by 3 yr; - Hypertonia + hypotonia outside normal range; - Persistent primitive reflexes; - Toe-walking persistent (DMD R/o); (6) **Standardized assessments**: AIMS (Alberta Infant Motor Scale), Bayley III, PDMS-2 (Peabody), BOT-2, Mullen, GMFM (CP); (7) **Workup developmental delay**: history (prenatal, perinatal, family), exam (dysmorphology, neuro), hearing + vision, developmental testing, etiologic workup (genetic — CMA first-tier, FXS, WES selected; metabolic selected; neuroimaging selected); (8) **Early intervention**: Part C (USA <3 yr) + school-based (3+); family-centered; (9) **Multidisciplinary**: peds + dev-behavioral + neurology + PT + OT + SLP + family; **Modern**: validated tools + early identification + intervention + neuroplasticity

---

Peds motor dev: cephalocaudal + proximal-distal. Gross (head ctrl → roll → sit → crawl → stand → walk → run/jump/skip) + fine (grasp → pincer → block tower → drawing). Red flags (regression, asymmetry, persistent reflexes). Tools AIMS/Bayley/PDMS/GMFM. EI.', NULL,
  'easy', 'neurology', 'review',
  'rehab_medicine', 'basic_science', 'neurology', 'peds',
  'AAP; Bayley', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Pediatric motor development milestones + assessment'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Spinal cord injury — neuroanatomy of bladder + bowel control', '[{"label":"A","text":"Single innervation"},{"label":"B","text":"Neurogenic Bladder + Bowel Neuroanatomy"},{"label":"C","text":"No sympathetic role"},{"label":"D","text":"Conus same as suprapontine"},{"label":"E","text":"No reflex"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neurogenic Bladder + Bowel Neuroanatomy: (1) **Bladder innervation**: - **Sympathetic** (T11-L2 → hypogastric plexus → β3 detrusor relaxation + α1 internal sphincter contraction): storage; - **Parasympathetic** (S2-4 → pelvic nerve → muscarinic M3 detrusor contraction): emptying; - **Somatic** (S2-4 → pudendal nerve → external sphincter): voluntary control; - **Coordinated by pontine micturition center (PMC)** w/ cortical input (frontal); (2) **Lesion-based bladder pattern**: - **Suprapontine** (stroke, MS, dementia): detrusor overactivity, coordinated sphincter (synergic); urge incontinence; - **Spinal — UMN (above conus, T12-L1)**: detrusor overactivity + detrusor-sphincter dyssynergia (DSD) — high storage pressure, incomplete emptying, upper tract risk; - **LMN (conus/cauda equina)**: areflexic detrusor + atonic sphincter — overflow incontinence + retention; (3) **Bowel innervation**: - **Sympathetic** (T11-L2): inhibits motility; relaxes ileocecal; contracts internal anal sphincter; - **Parasympathetic** (S2-4 + vagus): stimulates motility; relaxes internal sphincter for defecation; - **Somatic** (S2-4 pudendal): external anal sphincter voluntary; (4) **Neurogenic bowel patterns**: - **UMN (above conus)**: spastic bowel — retains stool, intact reflexes (gastrocolic) for stimulated defecation; suppositories + digital stimulation effective; - **LMN (conus/cauda)**: areflexic + flaccid; no reflex defecation; manual evacuation primary; risk constipation + incontinence; (5) **Sexual function**: - Erection: psychogenic (T11-L2) + reflexogenic (S2-4); UMN preserves reflexogenic; LMN affects reflexogenic; - Ejaculation: sympathetic; often impaired; - Lubrication + orgasm similar; (6) **Sacral reflexes**: bulbocavernosus + anal wink — assess sacral integrity (intact in UMN, absent acute spinal shock + LMN); (7) **Spinal shock**: areflexic state acute SCI; days-weeks → emergence of reflexes; (8) **Clinical assessment**: PVR + urodynamics + rectal exam + sacral reflexes + bladder/bowel diary; (9) **Management aligned w/ pattern**: UMN — CIC + anticholinergic + bowel program w/ stim; LMN — CIC + manual; (10) **Application**: targeted therapy + complications prevention (renal, skin, UTI, dysreflexia); **Modern**: urodynamics + targeted + multidisciplinary

---

Bladder: symp (T11-L2, storage) + parasymp (S2-4, emptying) + somatic (pudendal, voluntary). PMC coordinates. UMN (DSD, overactive), LMN (areflexic). Bowel parallel. Sexual function. Sacral reflexes. Targeted Tx by pattern.', NULL,
  'hard', 'renal_gu', 'review',
  'rehab_medicine', 'basic_science', 'renal_gu', 'adult',
  'Consortium SCI; AUA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Spinal cord injury — neuroanatomy of bladder + bowel control'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Theoretical models of motor learning + skill acquisition', '[{"label":"A","text":"Single stage"},{"label":"B","text":"Motor Learning Theory + Application"},{"label":"C","text":"More feedback always better"},{"label":"D","text":"No practice variation needed"},{"label":"E","text":"Passive only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Motor Learning Theory + Application: (1) **Fitts & Posner — 3 stages**: - **Cognitive** (early): "what to do" — high errors + variable; explicit instruction + slowed; demonstration helpful; - **Associative** (intermediate): refining + correcting errors; less variable; awareness of errors; - **Autonomous** (late): automatic + low cognitive load; consistent; can dual-task; (2) **Practice variables**: - **Distribution**: massed vs distributed (rest between) — distributed better for learning + retention; - **Variability**: constant vs variable practice — variable better for transfer; - **Schedule**: blocked vs random (different skills interleaved) — random worse acquisition but BETTER retention + transfer ("contextual interference"); - **Whole vs part**: depends on skill complexity + integration; - **Mental practice**: imagery — effective complement; - **Observational learning** (modeling): demonstration + video; (3) **Feedback**: - **Knowledge of results (KR)**: outcome feedback; - **Knowledge of performance (KP)**: how performed; - **Frequency**: less frequent better retention ("guidance hypothesis" — too much feedback dependent); - **Bandwidth feedback**: only when error exceeds threshold; - **Self-controlled** feedback better than imposed; (4) **Motivational + attentional**: - **External focus** (on outcome/object) better than internal (on body part) for performance + learning; - **Autonomy support**; - **Enhanced expectancies**; (5) **Motor learning principles applied to rehab**: - Task-specific + meaningful; - Intensive + repetitive (consistent w/ neuroplasticity); - Variable practice for transfer; - Random practice schedule; - Appropriate feedback (KR, KP, frequency); - External focus; - Sufficient challenge — "just right"; - Goal-directed; (6) **OPTIMAL theory** (Wulf & Lewthwaite): autonomy + enhanced expectancies + external focus enhance motor learning; (7) **CIMT, mass practice, task-specific training, robotics, virtual reality**: applications; (8) **Adjuncts**: tDCS, BCI, FES paired w/ training; **Modern**: integration motor learning + neuroplasticity + technology

---

Motor learning: Fitts/Posner cognitive → associative → autonomous. Practice: distributed + variable + random (contextual interference). Feedback: KR/KP — less frequent better retention. External focus + autonomy + expectancies (OPTIMAL). Task-specific + meaningful. Modern integrated.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'basic_science', 'neurology', 'adult',
  'Fitts/Posner; Wulf/Lewthwaite OPTIMAL', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Theoretical models of motor learning + skill acquisition'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Inpatient Rehabilitation Facility (IRF) criteria + admission decision-making', '[{"label":"A","text":"Anyone qualifies"},{"label":"B","text":"IRF Admission Criteria + Decision-Making"},{"label":"C","text":"No screening"},{"label":"D","text":"Single discipline OK"},{"label":"E","text":"Discharge home all"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** IRF Admission Criteria + Decision-Making: (1) **Medicare IRF criteria (US)** — broadly applicable framework: - Patient requires + benefits from intensive multidisciplinary rehabilitation; - Tolerates + participates in 3 hours of therapy per day, 5 days per week (or 15 hours/week); - Requires physician supervision/face-to-face visits at least 3 days/week + ongoing medical oversight; - Requires nursing 24/7; - Requires intensive multidisciplinary rehabilitation w/ 2+ disciplines (PT + OT + SLP); - Pre-admission screen by qualified clinician; (2) **60% rule** (CMS): ≥ 60% of IRF admissions must have ≥ 1 of 13 qualifying conditions (stroke, SCI, congenital deformity, amputation, major MJ trauma, hip fx, brain injury, neurological disorders, burns, etc.); (3) **Levels of post-acute care**: - **IRF**: most intensive — high therapy + medical complexity; - **SNF (skilled nursing)**: less intensive — chronic, lower-tolerance, slower-paced; - **LTACH** (long-term acute care): medically complex w/ prolonged need; - **Home health + outpatient**: lower-intensity outpatient when ready; (4) **Pre-admission screening (PAS)** — comprehensive; documents IRF appropriateness; (5) **Admission process**: PAS → physician concurrence → admission; (6) **During stay**: weekly interdisciplinary team conferences; FIM/section GG documentation; ongoing assessment; (7) **Discharge planning** from day 1: integrate; family + community; (8) **Section GG (CMS IRF-PAI)**: standardized functional + cognitive items at admit + DC — payment + quality; (9) **Patient-centered + value-based care**: outcomes + cost considerations; (10) **Equity**: access disparities — address; (11) **International variation**: different criteria + systems but similar principles — intensive multidisciplinary rehabilitation for selected patients; (12) **Multidisciplinary leadership**: physiatrist + rehab nursing + PT/OT/SLP + social work + case management + family; **Modern**: outcome-driven + value-based + integrated continuum

---

IRF: intensive multidisciplinary rehab. Medicare criteria: 3h/d therapy x 5d/wk + physician + 24/7 nursing + 2+ disciplines + PAS. 60% rule. Section GG. Other levels: SNF/LTACH/home. Discharge planning day 1. Outcomes + value-based.', NULL,
  'medium', 'signs_symptoms', 'review',
  'rehab_medicine', 'ems_mgmt', 'signs_symptoms', 'adult',
  'CMS IRF; CARF', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Inpatient Rehabilitation Facility (IRF) criteria + admission decision-making'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Rehabilitation team structure + interdisciplinary vs multidisciplinary', '[{"label":"A","text":"Single discipline always"},{"label":"B","text":"Rehab Team Models"},{"label":"C","text":"No coordination"},{"label":"D","text":"No team conferences"},{"label":"E","text":"Patient not on team"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Rehab Team Models: (1) **Multidisciplinary**: each discipline separate, parallel evaluations + goals + treatments; minimal coordination; report individually; (2) **Interdisciplinary** (preferred rehab model): - Shared goals + integrated plan of care; - Regular team conferences (typically weekly); - Coordinated team interventions w/ overlap; - Patient + family as core team members; - Disciplines learn from each other; (3) **Transdisciplinary**: roles blur — members cross discipline boundaries; advanced model; (4) **Core team members**: - **Physiatrist** (team leader medical + functional); - **Rehab nursing** (24/7 medical + skin + bladder/bowel + medication + education + carry over therapy); - **Physical therapy (PT)** — mobility, gait, strength, balance, transfers; - **Occupational therapy (OT)** — ADLs, fine motor, cognition, home safety, adaptive equipment, return to work; - **Speech-language pathology (SLP)** — communication, swallow, cognitive-communication; - **Social work + case management** — discharge, resources, advocacy, family; - **Psychology/neuropsychology** — mood, cognition, behavioral; - **Recreation therapy** — leisure + community reintegration; - **Dietitian** — nutrition; - **Pharmacy** — medication review; (5) **Extended team**: orthotist/prosthetist, vocational, peer mentors, chaplain, physician specialists (neurology, ortho, urology, etc.), patient + family; (6) **Team meeting** (interdisciplinary conference): patient progress + goals + barriers + plan + DC; weekly typically; documented; (7) **Communication**: standardized tools (FIM, ICF-based, SBAR), EHR; (8) **Patient-centered**: patient + family as core; (9) **Outcomes**: standardized + tracked + reported; (10) **Quality + safety**: team training, root cause analysis, continuous improvement; (11) **Leadership**: physician + nursing + administrative; (12) **Modern**: technology-enabled + tele + value-based + patient-centered

---

Rehab team: multidisciplinary (parallel) → interdisciplinary (shared goals + team conferences — preferred) → transdisciplinary (role blur). Core: physiatrist + rehab RN + PT/OT/SLP + SW + psych + recreation + dietitian + pharmacy + family. Weekly meetings. Patient-centered.', NULL,
  'easy', 'signs_symptoms', 'review',
  'rehab_medicine', 'ems_mgmt', 'signs_symptoms', 'mixed',
  'ACRM; AAPM&R', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Rehabilitation team structure + interdisciplinary vs multidisciplinary'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Discharge planning + transitions of care in rehab', '[{"label":"A","text":"Discharge day before — no planning"},{"label":"B","text":"Discharge Planning + Transitions"},{"label":"C","text":"No family involvement"},{"label":"D","text":"No follow-up"},{"label":"E","text":"No home assessment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Discharge Planning + Transitions: (1) **Start day 1** of admission — integrate throughout; (2) **Comprehensive assessment**: - Medical stability + ongoing needs; - Functional status + safety; - Cognitive + mood + behavioral; - Home environment + accessibility (OT home evaluation); - Family + caregiver capacity + training; - Community resources + transportation; - Financial + insurance + DME coverage; - Patient + family preferences + goals; (3) **Discharge destinations** (continuum): - Home (independent or w/ family/caregiver) + outpatient or home health; - Home w/ home health (PT/OT/SLP/nursing visits); - SNF (continued rehab less intensive); - LTACH (medically complex); - Assisted living + nursing home; - Hospice; (4) **DME (durable medical equipment) needs**: wheelchair, walker, commode, hospital bed, lifts, oxygen, etc.; assessment + funding (Medicare/insurance/charity); pre-discharge fitting + delivery; (5) **Home modifications**: ramps, grab bars, widened doors, lowered counters, accessible bathroom — OT assessment + funding; (6) **Medication reconciliation**: thorough review + family education + pillbox + simplify regimen; (7) **Patient + family education**: condition, meds, signs/symptoms + when to call, equipment use, exercise + activity program, follow-up; teach-back method; written materials; (8) **Follow-up appointments**: physiatry, specialists, primary care, therapy continuation; (9) **Community referrals**: support groups, peer mentors, advocacy organizations, social services; (10) **Transportation planning**: accessible vehicle, paratransit; (11) **Address SDOH** (social determinants of health): housing, food, financial; (12) **Re-admission prevention**: identified high-risk + targeted intervention; (13) **Documentation + handoff**: thorough — receiving providers; (14) **Outcomes**: ED visits, re-admissions, function, satisfaction; **Modern**: integrated transitions + technology + community-based + value-based

---

Discharge planning: start day 1. Assess medical + function + home + family + community + financial. Destinations spectrum. DME + home mods + meds + education + follow-up + community resources + transportation + SDOH. Multidisciplinary. Modern: integrated transitions.', NULL,
  'medium', 'signs_symptoms', 'review',
  'rehab_medicine', 'ems_mgmt', 'signs_symptoms', 'mixed',
  'TJC; CMS Transitions', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Discharge planning + transitions of care in rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Quality + outcomes measurement — quality indicators + benchmarking in rehab', '[{"label":"A","text":"No measurement needed"},{"label":"B","text":"Quality + Outcomes in Rehab"},{"label":"C","text":"Single metric"},{"label":"D","text":"Only adverse events"},{"label":"E","text":"No improvement"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Quality + Outcomes in Rehab: (1) **Quality measurement domains** (IOM/STEEEP): Safe, Timely, Effective, Efficient, Equitable, Patient-centered; (2) **Outcome measures in IRF**: - **Functional outcomes**: FIM/GG codes, change scores, LOS efficiency; - **Discharge destination**: home vs SNF rate; - **Adverse events**: falls, pressure injuries, infections (CAUTI, CLABSI), DVT, re-admissions; - **Patient experience**: HCAHPS-equivalent; - **Mortality + complications**; - **Process measures**: assessment timely, evidence-based care; (3) **Benchmarking**: - **UDSMR** (Uniform Data System for Medical Rehab): national database for IRFs; - **eRehabData**; - **CARF accredited**; - **CMS Compare** (Care Compare); - **Internal year-over-year**; (4) **Quality improvement (QI) frameworks**: - **PDSA cycles** (Plan-Do-Study-Act); - **Lean** (waste reduction); - **Six Sigma** (variation reduction); - **Root cause analysis** for adverse events; - **Failure mode + effects analysis (FMEA)** — proactive; (5) **Patient safety**: just culture, near-miss reporting, incident review, evidence-based bundles (CAUTI bundle, falls bundle, pressure injury bundle); (6) **Specific bundles in rehab**: - **Falls prevention**: assessment, environment, education, supervision, technology; - **Pressure injury prevention**: skin assessment, surface, mobility, nutrition; - **CAUTI prevention**: indications, removal early, sterile technique; - **VTE prophylaxis** post-acute appropriate; (7) **Equity + disparities**: address race, ethnicity, language, SES, geography, disability access — disparities documented; (8) **Patient-centered outcomes** (PROs) integration; (9) **Value-based care** (CMS): bundle payments, IRF VBP, quality + cost linkage; (10) **Continuous learning culture**: leadership, training, transparency, just culture; **Modern**: data-driven + value-based + equity + patient-centered

---

Rehab quality: IOM STEEEP domains. Outcomes: functional (FIM/GG) + discharge dest + adverse events + experience + process. Benchmarking (UDSMR). QI (PDSA, Lean). Safety bundles (falls, PrI, CAUTI). Equity. PROs. Value-based. Modern: data + equity.', NULL,
  'medium', 'signs_symptoms', 'review',
  'rehab_medicine', 'ems_mgmt', 'signs_symptoms', 'mixed',
  'IOM; CMS IRF QRP; CARF', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Quality + outcomes measurement — quality indicators + benchmarking in rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Telerehabilitation — applications + evidence + implementation', '[{"label":"A","text":"No evidence"},{"label":"B","text":"VR / AR"},{"label":"C","text":"Only in-person works"},{"label":"D","text":"Same as in-person all"},{"label":"E","text":"Replaces all in-person"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Telerehabilitation: (1) **Definition**: rehab services delivered remotely via telecommunications technology — video + phone + apps + wearables + remote monitoring; (2) **Modalities**: - **Synchronous** (real-time video — like in-person session); - **Asynchronous** (recorded exercises + monitoring); - **Hybrid**; - **mHealth** (apps, wearables, sensors); - **VR / AR** for engagement + assessment; (3) **Applications**: - Cardiac + pulm rehab — strong evidence non-inferior to in-person for selected; - Stroke rehab (motor, cognitive); - Vestibular rehab; - MSK (LBP, OA); - Pain management; - Cognitive rehab; - Speech therapy + AAC; - PT/OT home programs; - Group therapy; - Pediatric (early intervention); - Geriatric (frailty, falls prevention); (4) **Advantages**: - Access (rural, mobility-limited, transportation barriers); - Convenience + adherence; - Cost (potentially lower); - Pandemic continuity (COVID-19 expanded); - Integration into home + life context; (5) **Limitations**: - Some hands-on therapy difficult; - Technology access/literacy (digital divide — equity); - Safety assessment limited; - Reimbursement variability; - Privacy + security (HIPAA); - Licensure (state lines USA); (6) **Evidence**: meta-analyses + RCTs — non-inferior or beneficial vs in-person for many; cost-effective; high satisfaction; (7) **Hybrid model** likely future: in-person + tele; (8) **Implementation**: - Selection (appropriate patient + condition); - Technology + training (patient + provider); - Safety planning; - Workflow integration + EHR; - Outcome measurement; - Reimbursement navigation; - Continuous improvement; (9) **Wearables + remote monitoring**: gait, activity, falls, heart rate; AI-assisted; (10) **Patient + family + provider education**; (11) **Multidisciplinary integration**; (12) **Equity considerations**: digital access; address disparities; **Modern**: hybrid + tech-enabled + AI + integrated value-based

---

Telerehab: synchronous + async + mHealth + VR. Applications wide (cardiac/pulm strong evidence, stroke, vestib, MSK, peds, geri). Advantages access + convenience. Limits hands-on + digital divide + privacy + licensure. Evidence supportive. Hybrid future. Modern: integrated.', NULL,
  'medium', 'signs_symptoms', 'review',
  'rehab_medicine', 'ems_mgmt', 'signs_symptoms', 'mixed',
  'ACRM Telerehab; ATA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Telerehabilitation — applications + evidence + implementation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Ethics in rehabilitation — informed consent + autonomy + capacity', '[{"label":"A","text":"No consent needed"},{"label":"B","text":"Rehab Ethics — Autonomy + Capacity"},{"label":"C","text":"Single decision-maker"},{"label":"D","text":"No capacity assessment"},{"label":"E","text":"No ethics in rehab"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Rehab Ethics — Autonomy + Capacity: (1) **Core principles**: - **Autonomy** (self-determination + informed consent); - **Beneficence** (do good); - **Nonmaleficence** (avoid harm); - **Justice** (fair distribution + equity); - **Confidentiality + dignity**; (2) **Informed consent**: - Diagnosis + prognosis disclosure; - Treatment options + benefits + risks + alternatives + no treatment option; - Patient understanding (teach-back); - Voluntary; - Documented; - Decision-specific (consent for specific intervention not blanket); (3) **Capacity assessment**: - Decision-specific (capacity for specific decision); - 4 elements (Appelbaum): understanding info, appreciating situation, reasoning, expressing choice; - Sliding scale based on risk; - Tools: ACE (Aid to Capacity Evaluation), MacCAT; - Not synonymous w/ "competence" (legal) or cognitive impairment alone; - Reversible factors (delirium, depression, sedation) address; (4) **Surrogate decision-making**: when patient lacks capacity — advance directive (living will + healthcare POA), surrogate hierarchy (state laws), best interest standard if no surrogate; (5) **Common ethical issues in rehab**: - **Withholding/withdrawing rehab** (futility — disagreements); - **Goals of care conflict** (between patient + family or team); - **Discharge decisions** (safe vs preferred); - **Refusing rehab**; - **Mandatory participation issues**; - **Adolescent decision-making + assent**; - **Cognitive impairment + dementia**; - **Resource allocation + equity**; - **Cultural + religious considerations**; - **Truth-telling + prognosis**; (6) **Resolution strategies**: - Communication + clarification; - Family meetings + interdisciplinary; - Ethics consultation; - Mediation + counseling; - Time-limited trials; - Re-evaluation; (7) **Special populations**: pediatric + adolescent (assent + parents), dementia, severe TBI (DoC), mental illness; (8) **Cultural humility + shared decision-making**; (9) **End-of-life + palliative integration**: GoC discussions; (10) **Documentation**: thorough; (11) **Education + training** team in ethics; **Modern**: shared decision-making + cultural humility + ethics integration

---

Rehab ethics: autonomy + beneficence + nonmal + justice. Informed consent (Dx + options + risks + understanding). Capacity decision-specific (4 elements). Surrogate hierarchy + advance directives. Common dilemmas. Resolution strategies. Cultural humility. Modern: shared decision-making.', NULL,
  'medium', 'psych_behavior', 'review',
  'rehab_medicine', 'ems_mgmt', 'psych_behavior', 'mixed',
  'ASBH; AAPM&R Ethics', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Ethics in rehabilitation — informed consent + autonomy + capacity'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Documentation + coding in rehab — physiatry billing essentials', '[{"label":"A","text":"No documentation"},{"label":"B","text":"Rehab Documentation + Coding"},{"label":"C","text":"Single template all"},{"label":"D","text":"Up-code OK"},{"label":"E","text":"Copy-paste fine"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Rehab Documentation + Coding: (1) **Documentation principles**: - **History**: presenting complaint, history of present illness, ROS, PMH, meds, allergies, social, family, functional, prior functional level; - **Examination**: vital signs, general, system-based, focused MSK + neuro (motor, sensory, reflexes, coordination, gait, balance), cognitive + mental, function; - **Assessment + plan**: diagnoses (ICD-10), goals (SMART), interventions, prognosis, expected outcomes; - **Functional documentation**: status, change, barriers, goals; (2) **E/M codes (CPT)** — outpatient + inpatient: - **2021 updates** outpatient: time- or MDM-based; - History + exam appropriate, not points; - **Time-based**: total time on day (face-to-face + non-face-to-face on date) — pre-counseling, examination, ordering, documentation, communication; - **MDM-based**: complexity of problems + amount of data + risk of management; (3) **Common codes**: - 99211-99215 (established office); - 99201-99205 (new — being replaced); - 99221-99223 (inpatient initial); - 99231-99233 (subsequent); - 99238-99239 (DC); - Critical care 99291-99292; - Prolonged service codes; - 99417 (prolonged outpatient w/ E/M); (4) **Procedural codes**: injections (joint, trigger point, BoNT, nerve blocks), EMG/NCS; (5) **ICD-10 diagnoses**: specific codes for conditions + functional status modifiers; (6) **Modifiers**: 25 (significant E/M same day as procedure), 59 (distinct procedural), KX, etc.; (7) **Coverage + payers**: Medicare, Medicaid, commercial — specific requirements; (8) **Compliance**: avoid up-coding, document medical necessity, avoid copy-paste w/o updating, accurate; (9) **Quality reporting**: MIPS (Merit-based Incentive Payment System) — quality + cost + improvement; (10) **EHR proficiency**: templates careful (compliance), efficiency, communication; (11) **Multidisciplinary documentation integration**; **Modern**: AI-assisted + outcomes-linked + value-based payment

---

Documentation: thorough Hx + exam + A/P + functional + goals + ICD-10. E/M 2021 outpatient time/MDM. Procedural codes (injections, EMG/NCS). Modifiers. Compliance + medical necessity. MIPS quality. EHR proficiency. Modern: AI + value-based.', NULL,
  'medium', 'signs_symptoms', 'review',
  'rehab_medicine', 'ems_mgmt', 'signs_symptoms', 'mixed',
  'CMS; CPT; AAPM&R Coding', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Documentation + coding in rehab — physiatry billing essentials'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Multidisciplinary team leadership — physiatrist roles', '[{"label":"A","text":"Single role"},{"label":"B","text":"Physiatrist Leadership in Rehab Team"},{"label":"C","text":"No team interaction"},{"label":"D","text":"Not a leader"},{"label":"E","text":"No procedures"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Physiatrist Leadership in Rehab Team: (1) **Medical lead** of multidisciplinary team: ultimate medical responsibility + decision-making; (2) **Roles**: - **Diagnostician**: comprehensive medical + functional + diagnostic; rule out + manage medical complications; - **Treatment planner**: develop + supervise comprehensive rehab plan; - **Procedural**: EMG/NCS, US-guided + landmark-based injections (joint, BoNT, trigger point, nerve blocks), interventional spine selected, prosthetic prescription; - **Pharmacotherapist**: spasticity, pain, mood, sleep, neurogenic bladder/bowel, comorbidities; - **Communicator**: w/ patient + family + team + referring physicians + payers; - **Educator**: patient + family + team + trainees; - **Advocate**: patient + community + policy; - **Researcher**: contribute to evidence; - **Administrator**: program development, quality, finance; (3) **Team leadership skills**: - Clear vision + goals; - Communication (active listening, conflict resolution); - Empowerment + trust + recognition; - Decision-making + delegation; - Conflict resolution; - Cultural humility + DEI; - Continuous improvement orientation; (4) **Team building**: - Regular meetings (interdisciplinary conferences); - Shared mission + values; - Role clarity + respect; - Education + cross-training; - Outcome focus + accountability; - Recognition + appreciation; - Conflict resolution; - Wellness + burnout prevention; (5) **System leadership**: - Programmatic development; - Quality + outcomes; - Resource allocation; - Strategic planning; - Stakeholder engagement; (6) **Advocacy + policy**: at institutional + national levels for patient + profession; (7) **Mentorship + development**: of team + trainees + colleagues; (8) **Self-care + burnout prevention**: critical for sustainability; (9) **Ethical foundation**: professionalism + integrity; (10) **Continuous learning + adaptability**; (11) **Lifelong development + leadership growth**; **Modern**: distributed leadership + dyad models (physician + administrative/nursing) + value-based + patient-centered

---

Physiatrist leadership: medical lead — diagnostician + planner + procedural + pharmaco + communicator + educator + advocate + researcher + admin. Team building. System + advocacy + mentorship + self-care + ethics. Modern: distributed + dyad + value-based.', NULL,
  'easy', 'signs_symptoms', 'review',
  'rehab_medicine', 'ems_mgmt', 'signs_symptoms', 'mixed',
  'AAPM&R; ACGME', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Multidisciplinary team leadership — physiatrist roles'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Reimbursement + payment models — IRF + value-based care', '[{"label":"A","text":"FFS only"},{"label":"B","text":"Rehab Payment Models"},{"label":"C","text":"No bundled payments"},{"label":"D","text":"No quality measurement"},{"label":"E","text":"Same payment all settings"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Rehab Payment Models: (1) **Traditional fee-for-service (FFS)**: payment per service — incentive volume; (2) **IRF Prospective Payment System (PPS)** USA (Medicare): - Bundled payment per case based on CMG (Case Mix Group) determined by functional status (was FIM → now GG codes) + tier (motor + cognitive) + comorbidities + age; - Per-discharge bundled rate covers all services; - Outliers payments for high-cost; - **Incentivizes efficient care + outcomes**; (3) **SNF PPS**: PDPM (Patient Driven Payment Model) — replaced RUG-IV — based on patient characteristics not therapy minutes; reduces over-utilization; (4) **Home health PPS**: PDGM (Patient-Driven Groupings Model); (5) **Bundled payments for episodes**: e.g., joint replacement bundle — pre + intra + post-acute combined — shared accountability; (6) **Accountable Care Organizations (ACOs)**: provider groups accountable for cost + quality of population — shared savings/losses; (7) **MIPS + APMs** (US): quality reporting + alternative payment models; (8) **IRF Quality Reporting Program (QRP)**: required reporting — payment penalty for non-compliance; (9) **IRF Value-Based Purchasing (VBP)**: emerging — payment tied to outcomes; (10) **Hospital Outpatient + Physician Fee Schedule**: outpatient PM&R; (11) **DMEPOS** (Durable Medical Equipment, Prosthetics, Orthotics, Supplies): separate Medicare fee schedule; (12) **Coverage variation by payer**: Medicare, Medicaid (state-variable), commercial; advocacy needed for coverage gaps (cognitive rehab, complex equipment); (13) **Global trends**: value-based, population health, bundled, transparency; (14) **Equity in payment + access**; (15) **Patient out-of-pocket** + financial toxicity considerations; **Modern**: outcome-driven + bundled + value-based + transparency + equity

---

Rehab payment: FFS → bundled/value-based. IRF PPS (CMG, GG codes, comorbidity, tiers). SNF PDPM. HH PDGM. Bundles (joint replacement). ACO. MIPS/APM. IRF QRP/VBP. DMEPOS. Coverage variability. Equity. Modern: outcome-driven.', NULL,
  'hard', 'signs_symptoms', 'review',
  'rehab_medicine', 'ems_mgmt', 'signs_symptoms', 'mixed',
  'CMS IRF PPS; MedPAC', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Reimbursement + payment models — IRF + value-based care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Quality improvement project — root cause analysis + interventions', '[{"label":"A","text":"Blame individuals"},{"label":"B","text":"QI in Rehab — RCA + Improvement"},{"label":"C","text":"No analysis needed"},{"label":"D","text":"Single intervention"},{"label":"E","text":"No measurement"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** QI in Rehab — RCA + Improvement: (1) **QI cycle** (PDSA): - Plan (problem ID + analysis + intervention design); - Do (small-scale test); - Study (data analysis); - Act (scale + standardize or revise); (2) **Tools**: - **Fishbone (Ishikawa) diagram**: cause categories — people, process, equipment, environment, materials, methods, management; - **5 Whys**: drill down to root cause; - **Pareto chart**: 80/20 — focus on vital few; - **Process map / value stream mapping**: visualize workflow; - **Control charts** (SPC): track variation; - **FMEA** (Failure Mode and Effects Analysis): proactive risk; - **A3 problem-solving**: structured one-page; (3) **Adverse event analysis**: - **Root cause analysis (RCA)**: post-event systematic + non-punitive (just culture) + identify systems factors + corrective actions + tracking; - **"Sharp end" (proximal — clinician)** vs **"blunt end" (latent — system)**: address both; - **Hindsight bias** beware; (4) **High-reliability organization (HRO) principles**: - Preoccupation w/ failure; - Reluctance to simplify; - Sensitivity to operations; - Commitment to resilience; - Deference to expertise; (5) **Improvement methodologies**: - **Lean** (waste reduction: defects, overproduction, waiting, non-utilized talent, transportation, inventory, motion, extra-processing — DOWNTIME); - **Six Sigma** (DMAIC — Define, Measure, Analyze, Improve, Control); - **Hybrid Lean Six Sigma**; - **Theory of constraints**; (6) **Rehab-specific applications**: - Reducing falls; - Pressure injury prevention; - Sepsis recognition + treatment; - Hospital-acquired conditions; - Discharge efficiency + planning; - Re-admission reduction; - Patient experience improvement; - Throughput + flow; - Team communication; (7) **Patient + family involvement**: co-design; (8) **Data + measurement**: pre/post + control + sustainability; (9) **Sustainability**: standardization, training, monitoring, leadership; (10) **Spread** + scaling successful interventions; (11) **Culture**: just + learning + psychological safety; **Modern**: data-driven + AI-enabled + co-designed + sustainable

---

QI: PDSA cycle. Tools (fishbone, 5 Whys, Pareto, process map, FMEA, A3). RCA non-punitive (just culture) — sharp + blunt end. HRO principles. Lean (DOWNTIME) + Six Sigma (DMAIC). Apps falls/PrI/sepsis/DC. Patient involvement. Sustainability. Modern: data-driven.', NULL,
  'medium', 'signs_symptoms', 'review',
  'rehab_medicine', 'ems_mgmt', 'signs_symptoms', 'mixed',
  'IHI; AHRQ', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Quality improvement project — root cause analysis + interventions'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Healthcare disparities + equity in rehabilitation', '[{"label":"A","text":"No disparities exist"},{"label":"B","text":"Rehab Equity + Disparities"},{"label":"C","text":"Equity not relevant rehab"},{"label":"D","text":"No interventions possible"},{"label":"E","text":"Single solution"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Rehab Equity + Disparities: (1) **Disparities documented**: - **Access**: rural, rural, racial/ethnic minorities, lower SES, Medicaid, uninsured, language barriers, disabilities, LGBTQ+ — less likely to receive IRF, intensive rehab; - **Outcomes**: poorer functional gains, longer LOS, higher complications; - **Specific conditions**: stroke, SCI, TBI, hip fx; (2) **Social Determinants of Health (SDOH)**: housing, food security, transportation, employment, education, social support, environment, healthcare access — major drivers; (3) **Structural racism + systemic factors**: historical + ongoing; healthcare embedded; (4) **Frameworks**: - **Healthy People 2030** SDOH focus; - **IHI Triple Aim + Quadruple Aim** + Health Equity (Quintuple); - **CMS Office of Minority Health**; - **WHO Commission Social Determinants**; (5) **Interventions to reduce disparities in rehab**: - **Screen for SDOH** routinely (CMS now requires hospitals); - **Address language** (interpreters, translated materials, bilingual staff); - **Cultural humility + competency training**; - **Workforce diversity**; - **Community partnerships**: CHWs (community health workers), peer mentors, faith-based; - **Telehealth + technology** w/ digital equity considerations; - **Mobile + community-based rehab**; - **Insurance navigation + financial assistance**; - **Transportation programs**: paratransit + ride-share; - **Universal design + accessibility**; - **Advocacy + policy**: insurance coverage, ADA enforcement, accessibility; (6) **Quality measurement disaggregated** by race/ethnicity/language/disability/insurance — track + address disparities; (7) **Patient + family voice + co-design**: lived experience input; (8) **Disability community**: "nothing about us without us" — incorporating disability community perspectives + leadership; (9) **Inclusive research**: representation in clinical trials + outcomes; (10) **Continuous learning + improvement**: equity as core quality dimension; (11) **Funding + resources** advocacy: voc rehab, Medicaid, DME, durable medical equipment, long-term services + supports; **Modern**: integrated SDOH + equity + community-centered + policy advocacy

---

Rehab equity: documented disparities (access, outcomes — racial/SES/rural/disability). SDOH drivers. Frameworks (Healthy People 2030, Quintuple Aim, equity). Interventions: SDOH screening + language + cultural humility + community + telehealth equitable + policy. Disaggregated measurement. Disability community voice. Modern: integrated equity.', NULL,
  'hard', 'psych_behavior', 'review',
  'rehab_medicine', 'ems_mgmt', 'psych_behavior', 'mixed',
  'Healthy People 2030; IHI Quintuple', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Healthcare disparities + equity in rehabilitation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Disaster + emergency preparedness — rehab services + considerations', '[{"label":"A","text":"No preparedness needed"},{"label":"B","text":"Disaster + Emergency Preparedness Rehab"},{"label":"C","text":"Single facility only"},{"label":"D","text":"No equipment continuity"},{"label":"E","text":"Ignore disabilities"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Disaster + Emergency Preparedness Rehab: (1) **Rehab populations vulnerable**: SCI, TBI, stroke, MS, ALS, ventilator-dependent, complex equipment users — disproportionate impact; (2) **Preparedness planning**: - **Patient-level**: emergency plan + supplies (medications 14+ d, equipment, batteries, oxygen, formula, manual W/C backup, caregiver info, evacuation plan + accessibility), medical ID, registries (disability + medical needs); - **Facility-level**: emergency operations plan, mass casualty, evacuation, sheltering in place, business continuity, surge capacity, supply chain, mutual aid; - **System-level**: regional coordination, AHRQ, state HSPD, ESF-8 (Health + Medical); (3) **Common disasters**: natural (hurricane, flood, earthquake, wildfire, tornado), pandemic, mass casualty (mass shooting, bombing, MVC), infrastructure failure (power, water), cyber; (4) **Specific rehab considerations**: - Medication access (anticonvulsants, anti-spasmodics, baclofen pump — withdrawal emergency, antibiotics, autonomic medications); - Equipment continuity (W/C charging, ventilator, oxygen, suction, feeding pump, ITB pump); - Sheltering accessibility (ADA-compliant); - Transportation accessibility; - Communication needs (AAC, sign language, accessible alert systems); - Caregiver support; (5) **Mass casualty rehab response**: - Acute → rehab integration (e.g., post-Boston Marathon bombing amputees + burns + blast); - Surge in IRF, SNF, community rehab needs; - Mental health (PTSD, acute stress); - Community rehabilitation; (6) **Pandemic-specific (COVID-19 lessons)**: - PPE + infection control; - Telerehab expansion; - Post-acute COVID rehab needs (PASC); - ICU-AW + PICS surge; - Healthcare workforce wellness; - Health equity disparities amplified; (7) **Recovery + resilience**: long-term mental health + community + economic + functional impacts; rehab essential in recovery phase; (8) **Workforce preparedness + training**: emergency response training; (9) **Equity in disaster**: disabilities + minority + elderly + poor disproportionately impacted — explicit equity planning; (10) **International + humanitarian rehab**: post-conflict, refugees, displaced — capacity building (WHO, Handicap International, ICRC); **Modern**: integrated emergency + climate change adaptation + equity-focused

---

Disaster prep rehab: vulnerable populations. Patient + facility + system levels. Medication + equipment continuity (baclofen pump withdrawal!). Accessibility shelter + transport + comm. Mass casualty surge. Pandemic lessons. Equity. International. Modern: integrated.', NULL,
  'medium', 'signs_symptoms', 'review',
  'rehab_medicine', 'ems_mgmt', 'signs_symptoms', 'mixed',
  'AAPM&R; HHS ASPR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Disaster + emergency preparedness — rehab services + considerations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Patient safety culture in rehab — building + sustaining + just culture', '[{"label":"A","text":"Blame culture"},{"label":"B","text":"Patient Safety Culture in Rehab"},{"label":"C","text":"No reporting needed"},{"label":"D","text":"Single safety champion"},{"label":"E","text":"No measurement"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Patient Safety Culture in Rehab: (1) **Definition**: organization values, attitudes, perceptions, competencies, behaviors related to safety; (2) **High-reliability** principles (Weick & Sutcliffe): preoccupation w/ failure, reluctance to simplify, sensitivity to operations, commitment to resilience, deference to expertise; (3) **Just culture**: balance accountability + system thinking; differentiate human error (console), at-risk behavior (coach), reckless behavior (discipline); avoid blame for honest mistakes — encourages reporting; (4) **Components of safety culture**: - **Leadership commitment** (CEO/CMO visible); - **Teamwork + communication**: TeamSTEPPS, SBAR, huddles, time-outs; - **Reporting culture**: anonymous + non-punitive event reporting + near-miss; - **Learning culture**: from events + sharing; - **Patient + family engagement**: partners in safety; - **Wellness + staffing** (burnout → errors); (5) **Measurement**: AHRQ Hospital Survey on Patient Safety Culture (HSOPSC), Safety Attitudes Questionnaire (SAQ), event rates, near-miss reports, harm rates; (6) **Common safety issues in rehab**: - Falls + injuries; - Pressure injuries; - Medication errors (polypharmacy + complex meds — baclofen pump, anticoagulation); - Equipment-related (W/C, transfer, lifts); - Infection (CAUTI, CLABSI, C. difficile); - VTE; - Communication failures (handoff); - Patient identification; - Restraint use; - Adverse drug events; (7) **Improvement strategies**: - Standardized protocols + bundles; - Checklists + time-outs; - Simulation training; - Root cause analysis (RCA) + corrective actions; - FMEA proactive risk assessment; - Walk-rounds (leadership); - Speak-up culture; - Patient + family engagement; (8) **Burnout + wellness** as safety issue: workforce well-being → patient safety; (9) **Equity in safety**: disparities documented + address; (10) **Continuous improvement**: feedback loops, transparency, learning organization; **Modern**: just culture + HRO + equity + workforce wellness + patient-engaged

---

Patient safety culture: HRO principles + just culture (differentiate error/at-risk/reckless). Leadership + teamwork (TeamSTEPPS, SBAR) + reporting + learning + patient engagement + wellness. AHRQ HSOPSC measure. Common issues + improvement strategies. Burnout = safety. Equity. Modern: just culture + wellness.', NULL,
  'medium', 'psych_behavior', 'review',
  'rehab_medicine', 'ems_mgmt', 'psych_behavior', 'mixed',
  'AHRQ HSOPSC; TeamSTEPPS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Patient safety culture in rehab — building + sustaining + just culture'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'International Classification of Functioning (ICF) — clinical application + core sets', '[{"label":"A","text":"No standardization"},{"label":"B","text":"ICF Core Sets — Clinical Application"},{"label":"C","text":"Single category"},{"label":"D","text":"Not used clinically"},{"label":"E","text":"Replaces all assessment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ICF Core Sets — Clinical Application: (1) **ICF Core Sets**: condition-specific subsets of ICF categories most relevant — facilitate documentation + outcome + research + team communication; (2) **Brief vs Comprehensive Core Sets** for each condition: - Brief (~10-30 categories) for clinical use; - Comprehensive (~100+) for research; (3) **Common Core Sets**: stroke, SCI (acute, post-acute, chronic), TBI, MS, RA, OA, LBP, chronic pain, depression, diabetes, CV, cancer, geriatrics, vocational rehabilitation, post-acute; > 30+ developed; (4) **Application steps**: - Select appropriate Core Set; - Assessment of patient using each category w/ qualifier (0-4 severity); - Identify problems + facilitators + barriers; - Goal-setting + intervention planning + team communication; - Outcome measurement (re-rate post-intervention); (5) **Linkage rules**: linking outcome measures + EHR data to ICF — facilitates integration; (6) **Rehab Cycle**: Assessment (ICF-based) → Goal Setting → Intervention → Evaluation → re-cycle; promotes structured + patient-centered care; (7) **Goal-setting**: SMART within ICF framework — capture body + activity + participation + environmental + personal; (8) **Multidisciplinary team common language**: PT, OT, SLP, nursing, physician all use ICF terms; (9) **Outcome measurement linked to ICF**: PROMIS, FIM, condition-specific measures can be mapped; (10) **Documentation**: structured ICF-based progress notes + reports; (11) **Education**: training in ICF takes time; (12) **Strengths**: comprehensive + biopsychosocial + universal + non-stigmatizing language; (13) **Limitations**: complexity + time + need for tools + variable implementation; (14) **Examples by condition**: e.g., stroke Brief Core Set includes b110 consciousness, b144 memory, b730 muscle power, d450 walking, d540 dressing, d710 social interaction, e125 communication products, e310 immediate family + many more; **Modern**: e-rehabilitation w/ ICF + standardized + value-based + outcomes-tracked

---

ICF Core Sets: condition-specific subsets. Brief (clinical) vs Comprehensive (research). > 30 developed. Apply via Rehab Cycle (assess → goal → intervene → evaluate). SMART goals within ICF. Team common language. Outcome linkage. Documentation + education + value-based.', NULL,
  'medium', 'signs_symptoms', 'review',
  'rehab_medicine', 'ems_mgmt', 'signs_symptoms', 'mixed',
  'WHO; Stucki ICF Core Sets', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'International Classification of Functioning (ICF) — clinical application + core sets'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Research + evidence-based practice in rehab — translating evidence to care', '[{"label":"A","text":"Expert opinion only"},{"label":"B","text":"Evidence-Based Practice in Rehab"},{"label":"C","text":"No translation needed"},{"label":"D","text":"Single discipline research"},{"label":"E","text":"Ignore patient values"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Evidence-Based Practice in Rehab: (1) **EBP** (Sackett): integration of best research evidence + clinical expertise + patient values + circumstances; (2) **Levels of evidence**: - **Systematic reviews + meta-analyses** of RCTs (highest); - **RCTs**; - **Cohort studies**; - **Case-control**; - **Case series + reports**; - **Expert opinion** (lowest); (3) **Evidence in rehab — challenges**: - Heterogeneous interventions + patients; - Difficulty blinding (sham PT); - Variable outcomes; - Multidisciplinary interventions (complex); - Underfunded research; - Translation gap; (4) **5-step EBP process**: - Ask focused question (PICO — Population, Intervention, Comparison, Outcome); - Acquire evidence (PubMed, Cochrane, PEDro for PT, OTseeker for OT); - Appraise critically (CASP, GRADE for quality + strength); - Apply to patient; - Assess outcomes + adjust; (5) **Knowledge translation** (KT) — implementation science: - KT-A (Knowledge-to-Action) cycle; - Barriers + facilitators identification; - Strategies (audit + feedback, education, reminders, champions, decision support); - Sustainability + spread; (6) **Clinical practice guidelines** (CPGs) + clinical decision support; (7) **Patient-centered research**: PCORI, patient + family engagement, PROs, real-world data; (8) **Big data + AI**: registries, EHR analytics, machine learning for prediction + personalization; (9) **Practice-based research networks**: real-world evidence + improvement; (10) **Funding sources**: NIH (NCMRR), NIDILRR, PCORI, foundations, industry; (11) **Outcomes research + comparative effectiveness**; (12) **Cost-effectiveness + value-based care**: economic evaluation; (13) **Research training + mentorship + protected time**; (14) **Multidisciplinary research teams**; (15) **Equity in research**: representation, accessibility, community partnerships; **Modern**: implementation science + real-world + value-based + equity-focused

---

EBP rehab: integration evidence + expertise + values. Levels (SR/MA → RCT → cohort → case). 5-step PICO. Knowledge translation cycle. CPGs. Patient-centered research (PCORI). Big data + AI. Cost-effective + value. Equity. Modern: implementation + real-world.', NULL,
  'medium', 'signs_symptoms', 'review',
  'rehab_medicine', 'ems_mgmt', 'signs_symptoms', 'mixed',
  'Sackett; CIHR KT', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Research + evidence-based practice in rehab — translating evidence to care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Workforce + interprofessional education in rehab', '[{"label":"A","text":"Single profession"},{"label":"B","text":"Interprofessional Education + Workforce"},{"label":"C","text":"No IPE needed"},{"label":"D","text":"Burnout ignore"},{"label":"E","text":"No diversity"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Interprofessional Education + Workforce: (1) **Workforce challenges in rehab**: - Aging population — increased demand; - Workforce shortages (PT, OT, SLP, physiatry, rehab nursing); - Maldistribution (rural underserved); - Burnout + attrition; - Diversity gaps; (2) **Interprofessional education (IPE)** (WHO + IPEC core competencies): - **Values + ethics**: respect + dignity across professions; - **Roles + responsibilities**: clarity + understanding; - **Interprofessional communication**: effective + respectful; - **Teams + teamwork**: principles + processes; (3) **IPE modalities**: - Joint classroom teaching; - Simulation (interprofessional); - Clinical placement w/ multiple disciplines; - Case-based learning; - Service-learning; (4) **Continuing professional development** + CME/CEU requirements; specialty certification (ABPMR, ABPTS, AOTA, etc.); (5) **Mentorship + sponsorship**: critical for development + retention; (6) **Diversity, equity, inclusion (DEI)**: workforce demographics + inclusive culture + community partnership + pipeline programs + bias training; (7) **Burnout + wellness**: high in healthcare — interventions: workload management, organizational change, peer support, mental health, recognition; (8) **Leadership development**: distributed leadership, succession planning, training; (9) **Global health + workforce sharing**: humanitarian, capacity building (WHO), brain drain considerations; (10) **Technology + workforce**: telehealth opportunities + tools + AI augmentation; (11) **Scope of practice** evolution — task shifting, advanced practice, telerehab; (12) **Generational considerations**: Boomer to Gen Z workforce; (13) **Resilience + sustainability**: wellness as core; (14) **Patient + family + community as team**: extension of team beyond healthcare; (15) **Quintuple aim** focus: outcomes, experience, cost, workforce well-being, equity; **Modern**: IPE + DEI + wellness + flexible + value-based

---

Workforce + IPE: WHO/IPEC competencies (values, roles, comm, teamwork). Modalities (joint classroom, sim, clinical, case). DEI + burnout + leadership + global + tech + scope evolution + generations + resilience + community + Quintuple Aim. Modern: IPE + wellness.', NULL,
  'easy', 'signs_symptoms', 'review',
  'rehab_medicine', 'ems_mgmt', 'signs_symptoms', 'mixed',
  'IPEC; WHO IPE', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Workforce + interprofessional education in rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Digital transformation + AI in rehabilitation — applications + ethics', '[{"label":"A","text":"No AI in rehab"},{"label":"B","text":"AI + Digital Transformation in Rehab"},{"label":"C","text":"AI replaces clinicians"},{"label":"D","text":"No ethics needed"},{"label":"E","text":"Single application"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** AI + Digital Transformation in Rehab: (1) **Current applications**: - **EHR + clinical decision support**: documentation, alerts, evidence-based reminders; - **Telerehab platforms**: synchronous + async; - **Wearables + sensors**: gait, activity, falls, sleep, HR — continuous monitoring; - **Smart equipment**: robotic gait trainers, exoskeletons, smart prostheses (microprocessor knees, myoelectric w/ pattern recognition); - **Virtual + augmented reality**: motor + cognitive rehab, vestibular, pain (VR analgesia), exposure therapy; - **AI for imaging**: MRI/CT/X-ray interpretation; - **Predictive analytics**: risk stratification, prognosis, falls, re-admission; - **NLP**: clinical documentation, voice; - **Generative AI**: education, documentation assistance, patient communication; - **Brain-computer interface (BCI)**: severe motor disability; (2) **Emerging applications**: - **Personalized medicine**: genomics + biomarkers + AI; - **Digital therapeutics** (FDA-approved apps for specific conditions); - **Robotic surgery + rehab**; - **Smart homes + IoT**: aging-in-place, environmental control; - **Digital twins**: simulation + planning; (3) **Benefits**: personalization + access + efficiency + outcomes + engagement + scaling; (4) **Risks + ethics**: - **Privacy + data security** (HIPAA + beyond); - **Bias + equity**: training data + algorithm bias — disparities risk amplification; - **Transparency + explainability**: black-box AI; - **Accountability + liability**; - **Digital divide**: equity in access (rural, low SES, elderly, disabled); - **Overreliance + automation bias** — clinical judgment essential; - **Job displacement** considerations + reskilling; - **Patient agency + informed consent** for AI; (5) **Regulation evolving** (FDA SaMD — software as medical device); (6) **Implementation**: change management + training + workflow integration + outcomes evaluation; (7) **Multidisciplinary**: clinicians + IT + data science + ethics + patient + family; (8) **Continuous evaluation**: outcomes + safety + equity + efficiency; (9) **Patient + family engagement**: co-design; (10) **Workforce upskilling**: digital literacy; **Modern**: human-centered + equitable + ethical + integrated + evidence-based AI

---

Digital + AI in rehab: EHR + telerehab + wearables + smart equipment + VR/AR + AI imaging + predictive + NLP + GenAI + BCI. Benefits + risks (privacy + bias + transparency + equity + overreliance). Regulation evolving. Implementation + workforce + co-design. Modern: human-centered + ethical + equitable.', NULL,
  'hard', 'signs_symptoms', 'review',
  'rehab_medicine', 'ems_mgmt', 'signs_symptoms', 'mixed',
  'FDA SaMD; WHO AI Ethics', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Digital transformation + AI in rehabilitation — applications + ethics'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี — stroke + HF + DM + chronic kidney disease + falls + polypharmacy — integrative rehab', '[{"label":"A","text":"Single discipline"},{"label":"B","text":"Multimorbid Stroke + HF + DM + CKD"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Discharge no follow-up"},{"label":"E","text":"Aggressive workup w/o coordination"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multimorbid Stroke + HF + DM + CKD: (1) **Multidisciplinary team**: physiatry + neurology + cardiology + endocrinology + nephrology + geriatrics + PT + OT + SLP + nursing + dietitian + pharmacy + psychology + social work + family; (2) **Stroke rehab core**: motor + cognitive + speech + ADL + dysphagia + secondary prevention; (3) **HF rehab integration**: - Coordinate w/ HF team; - GDMT optimization (ARNI/ACEi/ARB + BB + MRA + SGLT2i — last benefits CKD + DM also); - Exercise prescription RPE 11-13 + monitor weight + symptoms; - Daily weight + low Na + fluid management; (4) **DM optimization**: - Glycemic targets relaxed older (A1c 7-8%); - SGLT2i (CV + renal + HF benefit) + GLP-1 if able; - Avoid hypoglycemia + sulfonylurea; - Foot care + neuropathy assessment; - Nutrition; (5) **CKD considerations**: - Renal-adjusted dosing; - Avoid nephrotoxins (NSAIDs, contrast, aminoglycosides); - Fluid + Na + K balance; - Anemia + bone/mineral disease (CKD-MBD) management; - Coordinate nephrology + dialysis planning if approaching; (6) **Falls prevention**: comprehensive — multifactorial assessment + intervention; (7) **Polypharmacy review** (Beers + STOPP/START + ACB): - Statin + antiplatelet (post-stroke); - GDMT HF; - Anticoagulant if AF; - Adjust for CKD; - Deprescribe sedating + anticholinergic; (8) **Goals of care**: realistic function + QOL + values + advance planning; (9) **Caregiver + family education + respite**; (10) **Mental health**: depression high — screen + treat; (11) **Discharge planning**: home + services + community; (12) **Long-term**: continued multidisciplinary + chronic disease + transitions; (13) **Equity considerations**: SDOH; **Modern**: integrated chronic disease + rehab + value-based + technology-enabled

---

Multimorbid stroke + HF + DM + CKD: multidisciplinary integration. Stroke rehab + HF GDMT (SGLT2i benefits all) + DM (relaxed targets, SGLT2/GLP-1) + CKD (renal dosing, avoid nephrotoxin) + falls + polypharmacy + GoC + caregiver + mental health. Modern integrated.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'integrative', 'neurology', 'adult',
  'AHA/ACC; KDIGO; AGS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี — stroke + HF + DM + chronic kidney disease + falls + polypharmacy — integrative rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี — TBI + chronic pain + opioid use disorder + PTSD + depression + homelessness', '[{"label":"A","text":"Single discipline"},{"label":"B","text":"Complex TBI + OUD + Mental Health + SDOH"},{"label":"C","text":"Discharge to shelter only"},{"label":"D","text":"Opioid escalation"},{"label":"E","text":"Bedrest"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Complex TBI + OUD + Mental Health + SDOH: (1) **Multidisciplinary integrated**: physiatry + neuropsych + addiction medicine + psychiatry + pain medicine + PT + OT + SLP + social work + housing navigator + peer support + spiritual care + family; (2) **TBI rehab**: cognitive (attention, memory, executive — APT, external aids), behavioral, mood, sleep, communication; (3) **Chronic pain**: multimodal opioid-sparing — adjuvants (gabapentinoid + TCA/SNRI + topical), PT + active, CBT/ACT/mindfulness, interventional selected; pain neuroscience education; (4) **OUD treatment** (integrated dual diagnosis): - **MAT (Medication for OUD)**: buprenorphine/naloxone (Suboxone) — gold standard; methadone (clinic-based); naltrexone (XR) for selected; - **Counseling + behavioral**: CBT, motivational interviewing, contingency management; - **Peer support + recovery community**; - **Harm reduction**: naloxone, syringe services if needed; - **Address pain w/ MAT** — buprenorphine has analgesic effects; coordinate w/ pain team; (5) **PTSD treatment**: trauma-focused CBT (CPT, PE), EMDR, SSRI/SNRI + prazosin (nightmares); (6) **Depression**: SSRI/SNRI, CBT, integrated; (7) **Sleep**: CBT-I, sleep hygiene; (8) **Suicide risk** assessment + safety planning; (9) **Housing — Housing First** model: stable housing first → engagement + treatment; supportive housing; navigate housing services + benefits; (10) **Social support + benefits + financial**: SS disability, food, transportation, ID; (11) **Trauma-informed care**: throughout — recognize trauma history (ACEs); (12) **Cultural humility + advocacy**; (13) **Outcome**: function + QOL + engagement + housing + recovery + mental health; (14) **Long-term integrated chronic care**; **Modern**: integrated + trauma-informed + harm reduction + Housing First + equity

---

TBI + OUD + PTSD + depression + homeless: integrated multidisciplinary + Housing First. TBI cog + pain multimodal + MAT buprenorphine + trauma-focused CBT + SSRI/SNRI + sleep + suicide risk + housing + benefits + trauma-informed + cultural humility. Modern: integrated equity.', NULL,
  'hard', 'psych_behavior', 'review',
  'rehab_medicine', 'integrative', 'psych_behavior', 'adult',
  'SAMHSA; APA PTSD; AAPM&R', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี — TBI + chronic pain + opioid use disorder + PTSD + depression + homelessness'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยเด็กอายุ 8 ปี — CP GMFCS IV + epilepsy + intellectual disability + GI feeding issues + scoliosis — family-centered care', '[{"label":"A","text":"Single specialist"},{"label":"B","text":"Complex Pediatric CP Comprehensive Care"},{"label":"C","text":"No family involvement"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Discharge no follow-up"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Complex Pediatric CP Comprehensive Care: (1) **Multidisciplinary clinic + medical home**: pediatrician + dev-behavioral peds + physiatry + neurology + ortho + neurosurgery + GI + nutrition + ENT + ophthalmology + dentistry + PT + OT + SLP + special ed + social work + child life + family + caregivers; (2) **GMFCS IV considerations**: self-mobility limited; power w/c selected; transfers w/ assistance; need adaptive equipment + home modifications; (3) **Epilepsy management**: appropriate AED, ketogenic diet selected, VNS/RNS selected, surgery refractory; AED interaction w/ rehab meds (sedation, cognition); rescue plan; (4) **Cognitive/ID**: educational accommodations IEP, communication (AAC + assistive tech), behavioral support, family + school coordination; (5) **GI feeding**: dysphagia evaluation + management (SLP + GI), thickeners, modified textures, G-tube for safety + nutrition; GERD common (PPI selected); constipation (laxative regimen); nutritional optimization (dietitian); growth monitoring (specific CP curves); (6) **Scoliosis**: regular monitoring (radiograph); bracing limited evidence in neuromuscular; surgical fusion for progressive curves (typically > 50° + skeletal maturity considerations) — improves comfort + positioning + pulmonary; (7) **Pulmonary**: aspiration risk, recurrent pneumonia, restrictive lung disease (scoliosis + weakness), airway clearance + cough assist; vaccination; (8) **Hip surveillance**: regular radiograph — high dislocation risk GMFCS IV-V (40-90%); preventive (PT + BoNT + surgery for subluxation); (9) **Spasticity management**: BoNT focal, ITB for generalized severe; (10) **Pain assessment + management**: non-verbal — observational tools (FLACC, NCCPC); multimodal; (11) **Mental health + behavioral**: sleep, mood, behavior — comprehensive; (12) **Family support**: caregiver burden HIGH — respite + peer + mental health + financial + advocacy; siblings; (13) **Transition planning** to adult care (age 14+ start); (14) **Goals of care** + advance directives; (15) **Equity + advocacy**; **Modern**: medical home + family-centered + transition + integrated multidisciplinary

---

Complex peds CP GMFCS IV: multidisciplinary medical home. Epilepsy + ID + dysphagia/G-tube + scoliosis + pulm + hip surveillance + spasticity + non-verbal pain + mental health + caregiver burden (HIGH) + transition + GoC. Family-centered. Modern: medical home.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'integrative', 'neurology', 'peds',
  'AAP Medical Home; AACPDM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยเด็กอายุ 8 ปี — CP GMFCS IV + epilepsy + intellectual disability + GI feeding issues + scoliosis — family-centered care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี — Parkinson + dementia + multiple falls + caregiver stress + medication side effects', '[{"label":"A","text":"Standard antipsychotic for psychosis"},{"label":"B","text":"PD + Dementia + Falls + Caregiver"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Increase PD meds always"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** PD + Dementia + Falls + Caregiver: (1) **PDD vs DLB**: PDD if dementia > 1 yr after motor PD; DLB if cognition + motor < 1 yr; treatment similar; (2) **Multidisciplinary**: movement disorder neurology + physiatry + geriatrics + neuropsych + PT + OT + SLP + pharmacy + social work + palliative + family; (3) **PD motor**: levodopa mainstay + adjuncts (DA agonists, MAO-B selected); avoid amantadine + anticholinergics + DA agonists in dementia (worsen cognition + psychosis); DBS NOT appropriate w/ dementia usually; (4) **Cognitive treatment**: rivastigmine (FDA approved PDD), donepezil; (5) **Behavioral + psychotic symptoms** (BPSD + PD psychosis 40% w/ DLB/PDD): - **First**: rule out delirium contributors (infection, meds, dehydration, pain, sleep); - **Non-pharm** first; - **Pimavanserin** (FDA for PD psychosis — selective 5HT2A inverse agonist); - **Clozapine** (effective but agranulocytosis monitor); - **Quetiapine** (off-label); - **AVOID typical antipsychotics + most atypicals** in PDD/DLB (neuroleptic sensitivity — severe rxn); (6) **Falls** comprehensive: PT/OT balance + strength + home + cueing for freezing + equipment + footwear + vision + medication review (orthostatic — fludrocortisone/midodrine if BP issue); osteoporosis Tx; (7) **Sleep**: RBD treatment (melatonin, clonazepam selected), OSA, insomnia — CBT-I + melatonin (avoid benzo + zolpidem); (8) **Autonomic**: orthostatic hypotension + GI (constipation, gastroparesis) + bladder; (9) **Caregiver support — KEY**: education + skills + respite + peer + mental health + financial + advocacy; depression high; (10) **Goals of care + advance planning + palliative integration** (progressive neurodegenerative — hospice eligibility in advanced); (11) **Polypharmacy review** + careful additions; (12) **Driving + safety + finances + legal** capacity; (13) **Long-term care planning**; (14) **Equity + cultural** considerations; **Modern**: integrated + family-centered + palliative

---

PDD/DLB + falls + caregiver: PD meds careful (avoid amantadine/anticholinergic). Pimavanserin / clozapine for psychosis — AVOID typical AP (neuroleptic sensitivity!). Falls comprehensive. Sleep + autonomic. Caregiver support KEY. GoC + palliative + advance planning. Modern integrated.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'integrative', 'neurology', 'adult',
  'AAN PDD; LBDA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี — Parkinson + dementia + multiple falls + caregiver stress + medication side effects'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี — SCI + traumatic amputation + TBI + PTSD + family disruption — polytrauma', '[{"label":"A","text":"Single discipline"},{"label":"B","text":"Polytrauma Comprehensive Integrative Care"},{"label":"C","text":"No family involvement"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Discharge no follow-up"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Polytrauma Comprehensive Integrative Care: (1) **Polytrauma rehab — multiple major injuries simultaneously** — common military/veterans + MVC/blast injuries; VA Polytrauma System established; (2) **Multidisciplinary expanded team**: trauma + physiatry + neurology + neurosurgery + ortho + plastics + psychiatry + neuropsych + addiction + pain medicine + PT + OT + SLP + prosthetist + nursing + social work + spiritual + peer + family; (3) **SCI rehab**: ASIA/ISNCSCI + bladder/bowel + skin + autonomic + mobility + ADL + equipment; (4) **Amputee rehab**: stage-appropriate (residual limb + prosthesis selection + training); K-level + advanced prosthetic technology integration; TMR considerations; (5) **TBI rehab**: cognitive + behavioral + emotional + sleep + fatigue + headache + vestibular; severity-stratified; (6) **PTSD treatment**: trauma-focused CBT (CPT, PE), EMDR; SSRI/SNRI + prazosin (nightmares); integrated w/ rehab — graded exposure to triggers; (7) **Chronic pain multimodal**: neuropathic + nociceptive + phantom limb — multimodal opioid-sparing + interventional selected + CBT + mindfulness; (8) **Sleep + mood + substance use** screen + treat; (9) **Family support**: traumatic + ongoing — family therapy + education + respite + financial + advocacy; high divorce rate in polytrauma — preventive; (10) **Vocational + community reintegration**: voc rehab + supported employment + ADA accommodations + military transition (veterans); (11) **Driving evaluation** + adapted vehicle; (12) **Peer support** + survivor groups — key for recovery; (13) **Long-term comprehensive care**: lifelong + transitions; (14) **Goals of care + values + identity** discussion — life-altering; (15) **Spiritual care + meaning-making**; (16) **Outcome**: function + QOL + family + community + employment + mental health; **Modern**: VA Polytrauma model + integrated + peer-supported + trauma-informed

---

Polytrauma integrative: VA Polytrauma model. Multidisciplinary — SCI + amputee + TBI + PTSD + chronic pain + sleep/mood/substance + family + vocational + peer + spiritual. Trauma-focused CBT + EMDR. TMR + advanced prosthetics. Long-term. Modern: integrated trauma-informed.', NULL,
  'hard', 'trauma', 'review',
  'rehab_medicine', 'integrative', 'trauma', 'adult',
  'VA Polytrauma; AAPM&R', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี — SCI + traumatic amputation + TBI + PTSD + family disruption — polytrauma'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี — cancer survivorship (breast + colorectal) + cardiac (post-MI) + cognitive impairment — integrative', '[{"label":"A","text":"Discharge — survived cancer"},{"label":"B","text":"Cancer Survivorship + Multimorbid"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Aggressive without coordination"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cancer Survivorship + Multimorbid: (1) **Multidisciplinary survivorship**: oncology + survivorship clinic + cardio-oncology + physiatry + cardiology + neuropsych + PT + OT + nutrition + psychology + social work + family; (2) **Cancer-specific late effects management**: - **Lymphedema** (BC-related): CDT + maintenance garment + skin care + exercise; - **CIPN**: duloxetine + exercise + PT/OT balance + fall prevention; - **Chemo-brain (cognitive)**: neuropsych assessment + cognitive rehab + external aids + accommodations; - **Cardiotoxicity** (anthracycline + radiation): cardiology surveillance (echo, biomarkers) + cardiac rehab; cardio-oncology integrated; - **Secondary malignancy risk**: surveillance schedules; - **Fertility/menopause issues**; - **Sexual health**; - **Endocrine** (chemo-induced); - **Psychosocial** (PTSD, depression, fear of recurrence); (3) **Cardiac rehab integrated**: post-MI Phase II then Phase III maintenance; risk factor modification; coordinate w/ cardio-oncology for treatment effects; (4) **Cognitive impairment** assessment + intervention; consider contributors (chemo, radiation, sleep, mood, meds, vascular); cognitive rehab + accommodations; (5) **Health behaviors**: exercise (key for cancer outcomes + CV + cognition + mood), nutrition (Mediterranean, plant-forward), weight management, smoking cessation, alcohol moderation, sleep, sun protection; (6) **Comprehensive long-term FU**: COG-like for adult survivors; care plan + treatment summary + surveillance + lifestyle; (7) **Mental health**: depression + anxiety + fear of recurrence — CBT, mindfulness, SSRI; peer support; (8) **Palliative integration** appropriate; (9) **Goals of care + advance planning** discussion appropriate; (10) **Equity considerations**: disparities in survivorship; (11) **Family + community**; **Modern**: integrated survivorship + value-based + tech-enabled + equity

---

Cancer survivorship + multimorbid: multidisciplinary integrated. Late effects (lymphedema, CIPN, chemo-brain, cardiotoxicity, 2° malignancy, fertility/sexual/endocrine). Cardiac rehab + cardio-oncology. Cognitive rehab. Health behaviors. Mental health. Palliative. Equity. Modern integrated.', NULL,
  'hard', 'hemato_onco', 'review',
  'rehab_medicine', 'integrative', 'hemato_onco', 'adult',
  'ASCO Survivorship; ACS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี — cancer survivorship (breast + colorectal) + cardiac (post-MI) + cognitive impairment — integrative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี — MS progressive + chronic pain + depression + relationship + vocational issues', '[{"label":"A","text":"Single discipline"},{"label":"B","text":"Progressive MS Complex Integrative Care"},{"label":"C","text":"DMT alone"},{"label":"D","text":"No relationship address"},{"label":"E","text":"Bedrest"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Progressive MS Complex Integrative Care: (1) **Multidisciplinary MS clinic**: neurology MS + physiatry + PT + OT + SLP + urology + ophthalmology + neuropsych + psychiatry + sexual health + social work + voc rehab + family; (2) **Disease-modifying therapy (DMT)** discussion + selection (ocrelizumab for PPMS + active SPMS, siponimod selected, others); risk-benefit; (3) **Symptom-targeted multidisciplinary rehab**: - **Mobility + weakness**: PT + AFO + assistive devices + FES + dalfampridine; - **Spasticity**: stepwise + BoNT + ITB; - **Bladder/bowel**: urodynamics-guided + CIC + meds; - **Cognitive**: rehab + accommodations; - **Visual**: ophthalmology; - **Sexual**: counseling + PDE5i + lubrication + multidisciplinary; - **Sleep**: CBT-I + treat contributors; (4) **Chronic pain — multimodal**: neuropathic (gabapentin, pregabalin, duloxetine, amitriptyline, cannabinoids), MSK (PT, multimodal), spasms (baclofen + cool); opioid-sparing; CBT; mindfulness; PT; (5) **Depression treatment**: SSRI/SNRI + CBT + integrated rehab; suicide risk assessment; (6) **Relationship + family**: couples counseling, family education, intimacy + sexual counseling + adaptive strategies, role redefinition; high divorce rate — preventive support; peer support; (7) **Vocational**: voc rehab assessment + accommodations (ADA): scheduling, fatigue management, cooling, heat avoidance (Uthoff), telework, ergonomic + cognitive accommodations; supported employment for severe; (8) **Caregiver support**: education + respite + peer + mental health; (9) **Adaptive recreation + community** integration; (10) **Equipment + home modifications**; (11) **Wellness + lifestyle**: exercise (counters disease!), Mediterranean diet, smoking cessation, vitamin D, weight management, sleep, mood; (12) **Goals of care + advance planning** progressive disease; (13) **Driving**: cognitive + visual + motor; (14) **Health equity** + access advocacy; **Modern**: comprehensive MS clinic + symptom-targeted + lifestyle + DMT-integrated + family-centered

---

MS progressive integrative: comprehensive MS clinic. Symptom-targeted (mobility, spasticity, bladder, cognitive, visual, sexual, sleep) + pain multimodal + depression + relationship/family + vocational + caregiver + equipment + wellness + GoC. DMT integrated. Modern: family-centered.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'integrative', 'neurology', 'adult',
  'AAN MS; CMSC; NMSS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี — MS progressive + chronic pain + depression + relationship + vocational issues'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 75 ปี — frail + multiple comorbidities + recurrent hospitalizations + goals of care discussion', '[{"label":"A","text":"Aggressive rehab without discussion"},{"label":"B","text":"Frail Elderly Integrative + Goals of Care"},{"label":"C","text":"No goals discussion"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Bedrest"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Frail Elderly Integrative + Goals of Care: (1) **Comprehensive geriatric assessment (CGA)**: medical, functional (ADL, IADL, gait, balance), cognitive (MoCA), nutritional, polypharmacy, mood, sensory, social, environmental, advance directives, values; (2) **Multidisciplinary**: geriatrician + physiatry + PCP + PT + OT + dietitian + pharmacy + social work + chaplain + palliative + family + caregiver + nursing; (3) **Goals of care discussion** (Serious Illness Conversation Guide, Ariadne Labs): - Open-ended: "What''s most important to you?"; - Understanding (illness + prognosis); - Worries; - Sources of strength; - Critical abilities; - Trade-offs; - Family discussions; document; (4) **Advance care planning**: living will + healthcare POA + POLST/MOLST (specific medical orders — DNR/DNI, intubation, antibiotics, artificial nutrition); revisit periodically; (5) **Function-focused care**: maintain ADL/IADL where possible; energy conservation (4 P); adaptive equipment; home modifications; safety; (6) **Symptom management**: pain (multimodal — Beers-cautious), fatigue, dyspnea, depression, anxiety, sleep, constipation, anorexia; (7) **Polypharmacy review + deprescribing** (Beers, STOPP/START); align w/ goals; (8) **Hospitalization prevention**: care coordination, home health, telehealth, medication adherence, education, vaccination, fall prevention; (9) **Re-admission focus**: transitional care models (CMS); (10) **Hospice eligibility consideration**: prognosis ≤ 6 mo + comfort focus; hospice provides comprehensive home + team + meds + equipment + 24/7 + respite + bereavement; (11) **Caregiver burden + respite + mental health + financial + advocacy**; (12) **Cultural humility** + values; (13) **Spiritual care + meaning + dignity**; (14) **Equity + access**; (15) **Death + dying planning**: location preferences (often home), pronouncement, bereavement; **Modern**: integrated geriatric + palliative + value-based + family-centered + community-supported

---

Frail elderly integrative + GoC: CGA. Multidisciplinary + palliative. GoC discussion (Ariadne) + advance care planning (POLST). Function-focused. Symptom mgmt + deprescribe. Re-admission prevention. Hospice consideration. Caregiver + cultural + spiritual + equity. Modern integrated.', NULL,
  'medium', 'psych_behavior', 'review',
  'rehab_medicine', 'integrative', 'psych_behavior', 'adult',
  'ACP; AAHPM; AGS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 75 ปี — frail + multiple comorbidities + recurrent hospitalizations + goals of care discussion'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี — Down syndrome adult + multiple comorbidities + transition adult care + family caregiver aging', '[{"label":"A","text":"Pediatric care continues forever"},{"label":"B","text":"Adult w/ Down Syndrome + Transition Care"},{"label":"C","text":"No transition planning"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adult w/ Down Syndrome + Transition Care: (1) **Adult medical issues** in Down syndrome: - **Cardiac**: congenital + acquired (mitral valve, AS); echo periodic; - **Endocrine**: hypothyroidism (high — annual screen); DM; - **Hematologic**: leukemia (childhood — risk persists), polycythemia; - **GI**: celiac (5-15%, screen w/ symptoms), constipation, GERD; - **Atlantoaxial instability** (10-30%): symptomatic screening + flexion-extension XR — sports + surgical implications; - **Cervical spine** myelopathy risk; - **Sleep apnea** (high prevalence — PSG + CPAP/surgery); - **Vision** (cataracts, refractive, keratoconus): annual; - **Hearing loss**: annual; - **Dental**: regular; - **Mental health**: depression, anxiety, behavioral; OCD; psychosis selected; ADHD; autism comorbid; - **Early Alzheimer disease** (50+): screen — APP gene chromosome 21; (2) **Functional + cognitive variability**: ID + adaptive; ongoing assessment; (3) **Multidisciplinary adult clinic** (preferred): physiatry + adult medicine + cardiology + endocrinology + neurology + psychiatry + dentistry + ophthalmology + audiology + PT + OT + SLP + social work + family; (4) **Transition from pediatric (age 14+)**: gradual + planned + portable medical summary + adult-oriented; (5) **Functional optimization**: PT + OT + SLP + cognitive support + adaptive equipment + community integration + vocational (supported employment) + recreation; (6) **Family caregiver — aging considerations**: succession planning (future caregivers), special needs trust + financial, sibling involvement, adult day programs, group home transition planning, advance directives + GoC; (7) **Decision-making capacity** + supported decision-making frameworks vs guardianship; (8) **Healthy lifestyle**: exercise + Mediterranean + weight management + smoking cessation + sleep; (9) **Dementia screening** (modified for baseline ID): NTG-EDSD, CAMDEX-DS; reversible factors first; (10) **Advance care planning**: family-involved + simplified; (11) **Equity + advocacy + neurodiversity**; **Modern**: integrated adult medical home + family-centered + lifespan

---

Adult Down syndrome: cardiac + thyroid + AAI + OSA + vision/hearing + mental health + early AD screening. Multidisciplinary adult clinic. Transition from peds. Functional optimization + vocational. Family aging — succession planning, trust, group home, GoC. Decision-making support. Modern integrated.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'integrative', 'neurology', 'adult',
  'AAP Down Syndrome; NTG', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี — Down syndrome adult + multiple comorbidities + transition adult care + family caregiver aging'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี — chronic LBP + lumbar stenosis + diabetes + obesity + depression + work disability', '[{"label":"A","text":"Surgery first-line"},{"label":"B","text":"Chronic LBP + Multiple Comorbidities Biopsychosocial Care"},{"label":"C","text":"Opioid escalation"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Disability without trial"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic LBP + Multiple Comorbidities Biopsychosocial Care: (1) **Biopsychosocial assessment**: bio (LBP + stenosis + DM + obesity), psychological (depression, fear-avoidance, catastrophizing), social (work, finances, family); (2) **Comprehensive multidisciplinary**: physiatry + pain medicine + PT + OT + psychology + dietitian + endocrinology + voc rehab + employer + family; (3) **LBP + stenosis approach**: - **Conservative** (most): PT (flexion-based for stenosis, McKenzie selected, core stabilization + general conditioning), pain education, multimodal pharmacology (NSAIDs cautious DM/CKD, gabapentin for neurogenic claudication evidence, opioid-sparing); - **Interventional**: epidural steroid (selected), facet/MBB/RFA for facet component; - **Surgical**: severe stenosis w/ disabling claudication or neuro deficit — laminectomy ± fusion; outcomes good in appropriate candidates; (4) **DM optimization + weight management**: GLP-1 RA (semaglutide, tirzepatide) — major benefit for both DM + weight + CV; nutrition + exercise; (5) **Obesity treatment**: lifestyle + GLP-1/dual + bariatric for severe — addresses multiple conditions; reduces LBP + improves function; (6) **Depression + fear-avoidance**: CBT (KEY) + SSRI/SNRI (duloxetine — also analgesic); pain neuroscience education; address catastrophizing; (7) **Exercise (KEY)**: general aerobic + resistance + flexibility — addresses LBP + DM + obesity + mood simultaneously; supervised initially → independent; (8) **Vocational rehab**: FCE + worksite + ergonomic + graded RTW + accommodations + voc rehab counselor + retraining selected; (9) **Sleep + stress management**: integral; (10) **Smoking cessation** + alcohol; (11) **Patient education + self-management**: chronic disease self-management programs (Stanford CDSMP); (12) **Address SDOH**; (13) **Long-term**: lifestyle changes + multidisciplinary support; (14) **Outcomes**: function (ODI, RMDQ), pain, RTW, weight, A1c, depression; **Modern**: biopsychosocial + lifestyle (GLP-1) + integrated chronic disease + value-based

---

Chronic LBP + DM + obesity + depression: biopsychosocial multidisciplinary. PT + interventional + selective surgery. GLP-1 RA major benefit (DM + weight). CBT + duloxetine for depression + pain. Exercise KEY (multiple conditions). Vocational. Self-management. Modern: lifestyle + integrated.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'rehab_medicine', 'integrative', 'msk_nontrauma', 'adult',
  'AAPM&R; ACP LBP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี — chronic LBP + lumbar stenosis + diabetes + obesity + depression + work disability'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี — post-hip fracture + dementia + delirium + falls history + caregiver burden', '[{"label":"A","text":"Surgery delay 1 wk"},{"label":"B","text":"Geriatric Hip Fracture + Dementia Integrative"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Single discipline"},{"label":"E","text":"No delirium prevention"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Geriatric Hip Fracture + Dementia Integrative: (1) **Multidisciplinary**: orthogeriatrics co-management (improves outcomes + reduces mortality): ortho + geriatrician + physiatry + nursing + PT + OT + nutrition + pharmacy + social work + palliative + family; (2) **Acute medical optimization + delirium**: - Surgery early (< 24-48 h) reduces mortality + morbidity + delirium; - HELP bundle for delirium prevention + management: orientation, mobility, sleep, hydration, vision/hearing aids, family; - Avoid contributors (anticholinergic, opioid excess, benzo); - Multimodal pain — opioid-sparing + nerve blocks (fascia iliaca, FNB); - Address: infection (UTI, pneumonia), constipation, urinary retention, dehydration, hypoxia, metabolic, withdrawal; - Continuous reassessment CAM; (3) **Mobilization day 1 (KEY)** w/ ortho + weight-bearing as appropriate (typically WBAT modern); reduces complications + improves outcomes; (4) **Dementia adaptations to rehab**: simple instructions + consistency + structure + family + cuing + supervision + safety + behavioral approaches; (5) **Falls prevention** comprehensive: multifactorial — medications, vision, environment, bone health, exercise; (6) **Bone health (KEY)** secondary prevention: - DEXA + osteoporosis Tx (bisphosphonate IV common, denosumab); - Vitamin D + Ca; - Fracture Liaison Service (FLS) reduces re-fracture 50%; (7) **Nutrition optimization**: protein 1.2-1.5 g/kg, oral nutrition supplements (evidence reduces complications); (8) **Pain management**: multimodal opioid-sparing (acetaminophen + nerve block + non-pharm + careful adjuvants); (9) **Caregiver support + education**: discharge planning + home safety + DME + community resources + respite + mental health; caregiver burden HIGH dementia; (10) **Discharge planning**: home w/ services vs SNF vs LTC — function + caregiver capacity + cognitive status; (11) **Goals of care + advance directives**: prognosis (25-30% mortality 1 yr); function trajectory; values; (12) **Palliative integration appropriate**; (13) **Multifactorial**: comprehensive integrated; (14) **Outcomes**: mortality, function, falls, re-admission, QOL, caregiver well-being; **Modern**: orthogeriatric co-management + FLS + integrated multidisciplinary + family-centered

---

Geriatric hip fx + dementia: orthogeriatrics co-management. Early surgery (< 24-48h). HELP bundle delirium prevent. Multimodal pain (nerve block). Mobilize day 1. Bone health + FLS 50% reduction. Nutrition. Caregiver. GoC. Modern: co-management + FLS.', NULL,
  'medium', 'trauma', 'review',
  'rehab_medicine', 'integrative', 'trauma', 'adult',
  'AAOS Hip Fx; AGS; FLS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี — post-hip fracture + dementia + delirium + falls history + caregiver burden'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 25 ปี — refugee + SCI from war injury + PTSD + cultural + language + insurance issues', '[{"label":"A","text":"Single discipline"},{"label":"B","text":"Refugee + SCI Trauma Integrative + Cultural"},{"label":"C","text":"Family interpreter only"},{"label":"D","text":"Discharge — refer elsewhere"},{"label":"E","text":"No cultural consideration"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Refugee + SCI Trauma Integrative + Cultural: (1) **Multidisciplinary culturally-humble team**: physiatry + neuropsych + trauma-informed mental health + cultural broker + interpreters + social work + immigration + community support + family + peer; (2) **Trauma-informed care principles** (SAMHSA): - Safety (physical + emotional); - Trustworthiness + transparency; - Peer support; - Collaboration; - Empowerment + voice + choice; - Cultural + historical + gender humility; (3) **SCI rehab core**: ASIA + bladder/bowel + skin + autonomic + mobility + ADL + equipment; (4) **PTSD treatment**: trauma-focused CBT (CPT, PE), EMDR; SSRI/SNRI + prazosin (nightmares); CULTURALLY-ADAPTED interventions essential; community-based + culturally-relevant; (5) **Language access** (KEY): qualified medical interpreters (not family for clinical), translated written materials, bilingual staff; (6) **Cultural humility + competency**: - Understanding values, beliefs, practices, family structure, religion, decision-making norms; - Avoiding assumptions; - Co-creating care plan; - Cultural broker/community liaison; - Address cultural conceptions of disability + rehabilitation + mental health; (7) **Immigration + insurance navigation**: - Refugee resettlement agencies; - Public insurance enrollment (Medicaid varies by state + status); - Charity care; - Volunteer + community providers; - Refugee health screening; (8) **Social determinants address**: - Housing (refugee resettlement + accessible); - Food security; - Transportation; - Employment + vocational rehab (work authorization + voc training + ESL); - Education + ESL; - Social connections + community + religious; (9) **Mental health**: trauma + adjustment + depression + grief + survivor + family separation; integrated; (10) **Family + community**: family reunification efforts; community + religious organizations; (11) **Peer support**: refugee + disability peer mentors; (12) **Spiritual care + meaning-making + hope**; (13) **Advocacy**: systemic + individual + policy; (14) **Long-term integrated care + community building**; **Modern**: trauma-informed + culturally-humble + community-partnered + equity-focused + integrated

---

Refugee SCI + PTSD: trauma-informed care (safety + trust + peer + collaboration + empowerment + culture). SCI core + culturally-adapted PTSD Tx. Medical interpreters + translated materials. Cultural humility. Immigration + insurance navigation. SDOH + community. Spiritual. Advocacy. Modern: equity-focused integrated.', NULL,
  'hard', 'psych_behavior', 'review',
  'rehab_medicine', 'integrative', 'psych_behavior', 'adult',
  'SAMHSA TIC; UNHCR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 25 ปี — refugee + SCI from war injury + PTSD + cultural + language + insurance issues'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี — chronic pain + fibromyalgia + obesity + sleep apnea + depression + anxiety — chronic disease', '[{"label":"A","text":"Opioid escalation"},{"label":"B","text":"Multimorbid Central Sensitization Chronic Disease"},{"label":"C","text":"Single discipline"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multimorbid Central Sensitization Chronic Disease: (1) **Multidisciplinary team**: physiatry + pain medicine + rheumatology + sleep medicine + psychiatry + PT + OT + dietitian + psychology + social work + family; (2) **Central sensitization spectrum**: fibromyalgia + chronic widespread pain + IBS + chronic fatigue + migraine — overlapping mechanisms; (3) **Comprehensive assessment**: pain (multidimensional), function (PROMIS), mood (PHQ-9, GAD-7, PCS), sleep (PSQI, ISI, screen OSA), substance use; (4) **Sleep apnea diagnosis + treatment** (KEY): PSG, CPAP — improves pain + mood + cognition + CV + fatigue; addresses contributing factor; (5) **Weight management** integrated: nutrition (Mediterranean) + exercise + behavioral; GLP-1 RA (semaglutide/tirzepatide) — major benefit weight + cardiometabolic — also may reduce inflammation; bariatric surgery selected; (6) **Exercise — KEY** despite pain: aerobic (low-impact: walking, cycling, aquatic) + resistance + mind-body (yoga, Tai Chi); start LOW + go slow + sustain; helps pain + sleep + mood + weight + cardiometabolic; (7) **CBT/ACT/mindfulness**: KEY for chronic pain + depression + anxiety + sleep; pain neuroscience education; (8) **Pharmacotherapy rationalize**: - Duloxetine (SNRI) — pain + depression + fibromyalgia FDA; - Milnacipran or pregabalin for fibromyalgia FDA; - Amitriptyline; - SSRI for depression; - Avoid opioid + benzo; - Melatonin for sleep adjunct; - GLP-1 weight; (9) **Sleep**: CBT-I + sleep hygiene + treat OSA + treat contributors (pain, mood); (10) **Address mood + anxiety**: integrated; (11) **Self-management**: Stanford CDSMP, pacing, activity diary, peer support; (12) **Social + vocational support**: workplace accommodations, peer support, family education; (13) **Outcomes**: pain, function, sleep, mood, weight, cardiometabolic; (14) **Long-term integrated chronic disease model**; **Modern**: central sensitization framework + lifestyle (GLP-1 + exercise + sleep) + integrated multidisciplinary + value-based

---

Multimorbid chronic central sensitization: multidisciplinary. OSA Dx + CPAP KEY. Weight (GLP-1 major). Exercise KEY (low-impact start). CBT/ACT/mindfulness + PNE. Duloxetine/pregabalin FDA. Avoid opioid/benzo. CBT-I sleep. Self-management. Modern integrated.', NULL,
  'medium', 'rheumatology', 'review',
  'rehab_medicine', 'integrative', 'rheumatology', 'adult',
  'ACR Fibromyalgia; AASM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี — chronic pain + fibromyalgia + obesity + sleep apnea + depression + anxiety — chronic disease'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กอายุ 16 ปี — post-traumatic brain injury + behavioral + academic decline + family + school issues — adolescent rehab', '[{"label":"A","text":"Single discipline"},{"label":"B","text":"Adolescent TBI Comprehensive Care"},{"label":"C","text":"No school involvement"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Discharge no transition"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adolescent TBI Comprehensive Care: (1) **Adolescent considerations**: developmental stage (identity + autonomy + peer + risk-taking + brain development continues through 20s); psychosocial complexities; (2) **Multidisciplinary**: pediatric/adolescent physiatry + neurology + neuropsych + psychiatry + adolescent medicine + PT + OT + SLP + dietitian + special ed + school + family + adolescent + peer; (3) **Cognitive rehab**: APT, GMT, metacognitive strategies, external aids (apps + smartphone), tutoring + school re-integration; (4) **Behavioral + emotional**: TBI behavioral changes + adolescent + identity formation; CBT, behavioral interventions, family therapy, motivational interviewing; address contributors (sleep, mood, pain, substance); (5) **School re-integration**: - IEP/504 (US): accommodations — extended time, reduced workload, frequent breaks, quiet testing, scribe, note-taker, technology, modified schedule; - Gradual return + monitoring; - Education staff + peers; - Mental health support in school; (6) **Mental health**: depression, anxiety, PTSD common post-TBI + adolescent — screen + treat (CBT + SSRI selected); suicide risk assessment + safety planning; (7) **Sleep**: adolescent + TBI — common — CBT-I + sleep hygiene + screen OSA; melatonin selected; (8) **Substance use**: increased risk post-TBI; screen + integrated treatment; harm reduction; (9) **Driving**: cognitive + visual + motor + neuropsych evaluation + driving rehab; restrictions until ready; (10) **Vocational + future planning**: long-term — career considerations adapted to abilities; transition planning; (11) **Family support**: education + counseling + sibling + respite + financial; family adjustment; (12) **Adolescent autonomy + advocacy**: voice + choice + privacy + assent + emerging adulthood; (13) **Peer support + group**: TBI youth groups + general adolescent; (14) **Recreation + community + social**: meaningful activities; (15) **Long-term FU through transition to adult care**; (16) **Equity + advocacy**: school + community + insurance; **Modern**: adolescent-centered + family + school-integrated + transition-focused

---

Adolescent TBI: developmental considerations. Multidisciplinary + family + school. Cognitive rehab + external aids. Behavioral + emotional + identity. School re-integration IEP/504. Mental health + suicide + sleep + substance use. Driving. Vocational + transition. Family. Peer. Modern: adolescent-centered.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'integrative', 'neurology', 'peds',
  'AAP Adolescent; INCOG Peds', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'เด็กอายุ 16 ปี — post-traumatic brain injury + behavioral + academic decline + family + school issues — adolescent rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี — diabetes + PAD + diabetic foot ulcer + previous amputation + chronic pain — limb preservation', '[{"label":"A","text":"Amputate primarily"},{"label":"B","text":"Diabetic Foot + Limb Preservation Integrative"},{"label":"C","text":"Single discipline"},{"label":"D","text":"No offloading"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Diabetic Foot + Limb Preservation Integrative: (1) **High-risk diabetic foot**: prior amputation = highest contralateral risk (~50% in 5 yr); urgent + comprehensive prevention + management; (2) **Multidisciplinary limb preservation team**: podiatry + vascular surgery + endocrinology + ID + WOCN + plastic surgery + nutrition + physiatry + PT + OT + prosthetist + nursing + diabetes educator + behavioral health + family; (3) **Ulcer management**: - **Wagner/UT classification**; - **TIME framework**: tissue debridement + infection control + moisture balance + edge advancement; - **Sharp debridement**; - **Dressings**: depth + exudate-matched (alginate, foam, hydrogel, antimicrobial selected); - **NPWT** (VAC) for deep + cavitary; - **Offloading (KEY)**: total contact cast (TCC) gold standard, removable cast walker, healing sandals — without consistent offloading wound won''t heal; - **Infection management**: clinical + sometimes biopsy; oral abx for mild, IV for deep + systemic; osteomyelitis (probe-to-bone, MRI) — long course IV or oral; surgical debridement; - **Adjunctive**: HBO selected (Wagner 3+), biologics (Apligraf, Dermagraft, PRP), skin graft, flap; (4) **Vascular optimization**: ABI, duplex, angiography — revascularization (endovascular preferred where feasible, open bypass selected) — critical for healing CLI; (5) **Glycemic + metabolic**: A1c < 7-8% (older relaxed) — SGLT2i + GLP-1 + others; nutrition + protein + micronutrients (vit D, zinc, vit C); smoking cessation CRITICAL; (6) **Pain management**: neuropathic (gabapentinoid, SNRI, TCA, topical) + procedural (during dressing changes) + opioid-sparing; (7) **Footwear + offloading long-term**: custom diabetic shoes + insoles + accommodative (Medicare benefit); (8) **Education + self-monitoring**: daily inspection (mirror), no barefoot, shoe checks, prompt reporting any wound; (9) **Patient + family + caregiver education + adherence + access**; (10) **Mental health + social**: depression high; address SDOH; (11) **Cardiac + renal optimization**: high-risk CV + CKD; (12) **Long-term**: lifelong surveillance + multidisciplinary; (13) **Outcomes**: healing, infection control, limb salvage, mortality, function, QOL; **Modern**: integrated limb preservation team + advanced therapeutics + tele-monitoring

---

Diabetic foot + limb preservation: multidisciplinary team. Ulcer mgmt — TIME + debride + offload TCC (KEY) + infection + adjunctive (NPWT, HBO, biologics). Vascular optimization (revasc). Glycemic + smoking. Pain. Footwear. Education. Mental health. Modern: integrated limb preservation team.', NULL,
  'hard', 'trauma', 'review',
  'rehab_medicine', 'integrative', 'trauma', 'adult',
  'ADA Diabetic Foot; SVS CLI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี — diabetes + PAD + diabetic foot ulcer + previous amputation + chronic pain — limb preservation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 80 ปี — multimorbid + caregiver dyad + chronic pain + cognitive decline + advance care planning', '[{"label":"A","text":"Single discipline"},{"label":"B","text":"Geriatric Dyadic Care + Advance Planning"},{"label":"C","text":"Patient only — no caregiver"},{"label":"D","text":"Aggressive without planning"},{"label":"E","text":"No GoC"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Geriatric Dyadic Care + Advance Planning: (1) **Dyadic care approach**: patient + primary caregiver as unit of care — both have needs + influence each other; (2) **Comprehensive geriatric assessment** (patient + caregiver): - Patient: medical + functional + cognitive + psychosocial + advance directives + values; - Caregiver: physical health + mental health + Zarit Burden + skills + resources + respite needs + employment; (3) **Multidisciplinary**: geriatrician + physiatry + PT + OT + nursing + dietitian + pharmacy + social work + chaplain + palliative + family; (4) **Chronic pain management**: multimodal opioid-sparing (acetaminophen + topical + gabapentinoid careful + duloxetine), non-pharm (PT, CBT, mindfulness, modalities), interventional selected; Beers + STOPP/START careful; (5) **Cognitive decline assessment + treatment**: - Etiology workup (reversible — meds, B12, thyroid, depression); - Cholinesterase inhibitors selected; - Non-pharm first BPSD; - Address contributors; - Cognitive + functional accommodations; - Safety + supervision + driving + finances + legal; (6) **Polypharmacy** review + deprescribe; (7) **Functional optimization**: PT + OT + adaptive equipment + home modifications + safety; (8) **Falls prevention** comprehensive; (9) **Caregiver support (KEY)**: - **Education + skills**: condition + caregiving + managing behaviors + symptoms; - **Respite care**: home + day + short-stay; - **Peer support + community**: Alzheimer Association + local groups; - **Mental health**: caregiver depression high — screen + treat; - **Financial + legal**: planning + benefits + special needs; - **Advance planning + GoC** for caregiver future; - **Acknowledgment + appreciation + recognition**; (10) **Advance care planning** (KEY): - Serious Illness Conversation Guide; - Living will + healthcare POA + POLST/MOLST; - Hospice eligibility consideration; - Cultural + spiritual considerations; - Re-visit periodically; - Family meetings; (11) **Palliative integration**; (12) **Long-term care planning**: in-home services, assisted living, nursing home as needed; (13) **Equity + access**; (14) **Continuity + transitions**: hospital + clinic + home + community + EOL; **Modern**: dyadic + integrated geriatric + palliative + value-based + family-centered + community-supported

---

Geriatric dyadic + advance planning: dyad = patient + caregiver. Comprehensive assessment both. Multidisciplinary + palliative. Chronic pain multimodal. Cognitive decline + reversible. Polypharmacy. Functional + falls. CAREGIVER SUPPORT KEY. Advance care planning (Serious Illness Conv). Long-term planning. Modern: dyadic + integrated.', NULL,
  'medium', 'psych_behavior', 'review',
  'rehab_medicine', 'integrative', 'psych_behavior', 'adult',
  'AGS; Ariadne Labs; AAHPM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 80 ปี — multimorbid + caregiver dyad + chronic pain + cognitive decline + advance care planning'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 40 ปี — chronic spinal cord injury + new pregnancy + multidisciplinary planning', '[{"label":"A","text":"Standard pregnancy management"},{"label":"B","text":"SCI + Pregnancy Integrative Care"},{"label":"C","text":"C-section all SCI"},{"label":"D","text":"No epidural"},{"label":"E","text":"Bedrest"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** SCI + Pregnancy Integrative Care: (1) **Multidisciplinary**: high-risk obstetrics + SCI specialist (physiatry) + neurology + urology + anesthesiology + nursing + PT + OT + nutrition + social work + family + peer + lactation; pre-conception planning ideal; (2) **Pregnancy considerations w/ SCI**: - **Bladder**: increased UTI risk — surveillance + treatment, optimize CIC + meds, anticholinergic safety pregnancy; - **Bowel**: constipation + impaction risk worsen — optimize program; - **Skin**: pressure injury risk — weight + posture changes + equipment adjustment; - **DVT/PE**: increased risk in pregnancy + SCI — prophylaxis + activity; - **Anemia + nutrition** monitor; - **Spasticity**: may worsen — adjust meds (some teratogenic — baclofen reasonable, careful gabapentin/pregabalin); - **Respiratory** (high SCI): assess VC + diaphragm; - **Equipment**: W/C modifications as belly grows; transfers more difficult; (3) **Autonomic dysreflexia (AD) — KEY risk in T6+** during pregnancy + labor: - Increased baseline frequency; - Triggers (UTI common, constipation, ROM, contractions during labor); - Labor — "silent labor" presentation w/ AD instead of pain; - Anesthesia: EPIDURAL ANALGESIA essential (T10+) — prevents AD via blocking afferents; (4) **Delivery planning**: - Vaginal delivery possible most SCI — assisted delivery (forceps/vacuum) common due to abdominal weakness; - C-section per OB indications; - Anesthesia plan; - Multidisciplinary in-hospital team; (5) **Postpartum**: - Skin + bladder + bowel + AD continued surveillance; - Breastfeeding (most can; T4+ may have milk let-down issues — adjustments); - Transfers + ADLs w/ infant — adaptive equipment + family/caregiver assistance; - Mental health postpartum (depression risk + SCI); (6) **Equipment + home modifications**: infant care + transfer + cribs adapted + carriers; (7) **Parenting + family adaptation**: peer mentors + family support + community resources; (8) **Long-term**: continuity for both SCI + parenting; (9) **Outcomes**: maternal-fetal health, function, satisfaction; **Modern**: pre-conception planning + specialized centers + peer support + family-centered

---

SCI + pregnancy: multidisciplinary high-risk OB + SCI. Bladder/bowel/skin/DVT/anemia/spasticity (med adjust)/respiratory/equipment. AD KEY risk T6+ labor — EPIDURAL essential. Vaginal delivery possible w/ assisted. Postpartum skin/AD/breastfeeding/mental health. Adaptive equipment infant care. Modern: integrated.', NULL,
  'hard', 'renal_gu', 'review',
  'rehab_medicine', 'integrative', 'renal_gu', 'adult',
  'Consortium SCI Pregnancy', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 40 ปี — chronic spinal cord injury + new pregnancy + multidisciplinary planning'
  );

commit;

