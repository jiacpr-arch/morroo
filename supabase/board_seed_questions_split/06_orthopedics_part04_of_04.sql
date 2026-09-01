-- ===============================================================
-- หมอรู้ — Board seed: ออร์โธปิดิกส์ (orthopedics) — part 4/4 (50 MCQs)
-- Safe to paste into Supabase SQL Editor. Re-runnable.
-- ===============================================================

begin;

-- mcq_subjects for this specialty (idempotent)
insert into public.mcq_subjects
  (name, name_th, icon, audience, board_specialty, exam_type, question_count)
values
  ('ortho_clinical_decision', 'ออร์โธปิดิกส์ · การตัดสินใจทางเวชกรรม', '🩺', 'board', 'orthopedics', NULL, 0),
  ('ortho_basic_science', 'ออร์โธปิดิกส์ · วิทยาศาสตร์การแพทย์พื้นฐาน', '🧬', 'board', 'orthopedics', NULL, 0),
  ('ortho_ems_mgmt', 'ออร์โธปิดิกส์ · การจัดการระบบบริการการแพทย์ฉุกเฉิน', '🚨', 'board', 'orthopedics', NULL, 0),
  ('ortho_integrative', 'ออร์โธปิดิกส์ · ข้อสอบบูรณาการ', '🧩', 'board', 'orthopedics', NULL, 0)
on conflict (name) do nothing;

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

**Limb embryology** — กลไก limb formation + congenital anomaly

อธิบาย limb development + signaling centers + clinical correlations (radial club hand, polydactyly, syndactyly, transverse deficiency)', '[{"label":"A","text":"Limbs form in week 1 of gestation"},{"label":"B","text":"Limb Embryology + Development"},{"label":"C","text":"AER controls dorso-ventral axis"},{"label":"D","text":"SHH controls limb length only"},{"label":"E","text":"Syndactyly is failure of cell division"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Limb Embryology + Development: (1) **timing** — limb buds appear week 4 of gestation; upper limb (week 4-5) precedes lower limb (~ 24-48h later); critical period of teratogen sensitivity weeks 4-8; (2) **3 signaling centers controlling limb growth in 3 axes**: (a) **Apical Ectodermal Ridge (AER)** — controls proximo-distal axis growth; produces **FGF (fibroblast growth factor — FGF4, FGF8)**; removal → truncation of limb (transverse deficiency); (b) **Zone of Polarizing Activity (ZPA)** — posterior mesoderm of limb bud; controls antero-posterior (radio-ulnar) axis; produces **Sonic Hedgehog (SHH)**; mutations → polydactyly, radial club hand; (c) **Wnt7a + dorsal ectoderm** — controls dorso-ventral axis; (3) **mesoderm contributions**: (a) lateral plate mesoderm → bone, cartilage, ligament, tendon, dermis; (b) paraxial mesoderm (somites) → muscle (myogenic precursors migrate in) + dermis + vasculature; (c) neural crest → nerves; (4) **apoptosis** in interdigital regions separates digits — failure → **syndactyly** (most common upper limb congenital anomaly); (5) **clinical correlations**: (a) **transverse deficiency** (e.g., Symbrachydactyly, congenital below-elbow amputation) — AER disruption or vascular event (typically failure to receive distal signals); (b) **radial club hand (radial deficiency)** — failure of anteroposterior axis from ZPA/SHH disruption; associated with VACTERL, Holt-Oram (TBX5), thrombocytopenia-absent radius (TAR), Fanconi anemia; **screen these syndromes!**; (c) **polydactyly** — over-expression of SHH or related; postaxial more common (familial, isolated, AR); preaxial often syndromic (trisomy, Holt-Oram); (d) **syndactyly** — failure of apoptosis; (e) **constriction band syndrome (amniotic band)** — extrinsic disruption from amniotic bands; (f) **cleft hand (ectrodactyly)** — central deficiency; (g) **macrodactyly, hypoplasia, Madelung deformity** — various etiologies; (6) **classification systems**: (a) Swanson IFSSH classification (transverse arrest, longitudinal — radial/central/ulnar/postaxial, failure of differentiation, duplication, overgrowth, undergrowth, congenital constriction band, generalized abnormality); (b) Oberg-Manske-Tonkin (OMT) — modern molecular-based; (7) **management approach**: multidisciplinary (peds ortho, hand, plastic, genetics, social work, occupational therapy); functional > cosmetic; timing typically 6 months - 2 years for reconstruction; family education + counseling

---

Limb embryology: bud week 4. 3 signaling centers: AER (FGF — proximo-distal), ZPA (SHH — antero-posterior), Wnt7a (dorso-ventral). Apoptosis separates digits. Clinical: transverse deficiency (AER), radial club hand (ZPA/SHH disruption — screen VACTERL, Holt-Oram, TAR, Fanconi), polydactyly (SHH excess), syndactyly (failed apoptosis), constriction band, cleft hand. IFSSH/OMT classification. Multidisciplinary care.', NULL,
  'hard', 'msk_nontrauma', 'review',
  'orthopedics', 'basic_science', 'msk_nontrauma', 'peds',
  'IFSSH; OMT Classification', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

**Limb embryology** — กลไก limb formation + congenital anomaly

อธิบาย limb development + signaling centers + clinical correlations (radial club hand, polydactyly, syndactyly, transverse deficiency)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

**Skeletal muscle physiology** — fiber types + energy metabolism + force generation

อธิบาย muscle fiber types (type I, IIa, IIx) + energy metabolism + sliding filament theory + clinical correlations (atrophy, denervation, training)', '[{"label":"A","text":"Type I fibers are anaerobic"},{"label":"B","text":"Skeletal Muscle Physiology"},{"label":"C","text":"Sliding filament theory is obsolete"},{"label":"D","text":"All muscles have only one fiber type"},{"label":"E","text":"Atrophy preferentially affects Type I first"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Skeletal Muscle Physiology: (1) **fiber types** — based on myosin heavy chain isoforms + metabolic profile: (a) **Type I (slow-twitch, slow-oxidative)** — red (myoglobin-rich), aerobic metabolism (mitochondria-rich), fatigue-resistant, low force, postural muscles (soleus, paraspinals), endurance athletes; (b) **Type IIa (fast-twitch, fast-oxidative-glycolytic)** — intermediate, aerobic + anaerobic, moderate fatigue resistance, moderate force, mixed activities; (c) **Type IIx/IIb (fast-twitch, fast-glycolytic)** — white, anaerobic metabolism, rapid fatigue, high force, powerful brief activities (sprinting, jumping); (d) human muscle has mixed fibers — different proportion in different muscles + individuals (athletic phenotype); training can shift between IIa ↔ IIx but not I ↔ II readily; (2) **sliding filament theory (Huxley)**: (a) sarcomere — basic unit (Z-line to Z-line) contains thick (myosin) + thin (actin + tropomyosin + troponin) filaments; (b) **cross-bridge cycling**: ATP binds myosin → myosin detaches from actin → ATP hydrolyzed to ADP + Pi (myosin head cocks) → Ca²⁺ binds troponin C → tropomyosin shifts → actin binding sites exposed → myosin binds actin → power stroke (releases ADP + Pi, pulls actin) → ATP rebinds (cycle continues); rigor mortis from lack of ATP; (c) muscle contraction shortens sarcomere (Z-lines closer, H-zone + I-band shorten, A-band stays same); (3) **energy metabolism** — order of activation: (a) ATP (existing — seconds), (b) **creatine phosphate (PCr)** — rapid regeneration of ATP (~ 10-15 seconds), (c) anaerobic glycolysis — glucose → lactate (~ 1-3 minutes, byproduct lactate), (d) aerobic oxidation — glucose, fatty acids, amino acids → ATP via Krebs + electron transport (sustained); (4) **clinical correlations**: (a) **muscle atrophy** from disuse, immobilization, denervation, sarcopenia (aging) — preferentially affects Type II first; (b) **denervation atrophy** — fasciculations, fibrillations (EMG), eventual fibro-fatty replacement; (c) **Volkmann''s ischemic contracture** — muscle necrosis + fibrosis after compartment syndrome; (d) **muscular dystrophy** — Duchenne (dystrophin gene X-linked, calf pseudohypertrophy, Gowers sign — child climbs body to stand), Becker (milder); (e) **myasthenia gravis** — autoimmune ACh receptor; (f) **rhabdomyolysis** — muscle necrosis → myoglobin → AKI (post-trauma, crush, statins); (g) **exercise training** — Type I/IIa hypertrophy with endurance, IIa hypertrophy with resistance; (h) **delayed onset muscle soreness (DOMS)** — eccentric exercise → microtrauma → adaptation

---

Skeletal muscle: Type I (slow, red, aerobic, postural), Type IIa (fast, intermediate), Type IIx (fast, white, anaerobic, powerful). Sliding filament: actin-myosin cross-bridge cycling with ATP + Ca²⁺. Energy: ATP → PCr → glycolysis → aerobic. Atrophy preferentially Type II. Clinical: denervation, Volkmann''s, muscular dystrophy (Duchenne — dystrophin), MG, rhabdo, training adaptations.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'basic_science', 'msk_nontrauma', 'adult',
  'Modern Muscle Physiology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

**Skeletal muscle physiology** — fiber types + energy metabolism + force generation

อธิบาย muscle fiber types (type I, IIa, IIx) + energy metabolism + sliding filament theory + clinical correlations (atrophy, denervation, training)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

**Normal gait cycle** — สำคัญสำหรับ evaluate gait abnormalities + post-injury / post-arthroplasty / pediatric ortho

อธิบาย gait cycle phases + muscle activation + clinical correlations (Trendelenburg, drop-foot, antalgic gait)', '[{"label":"A","text":"Swing phase is 60% of gait cycle"},{"label":"B","text":"Normal Gait Cycle + Clinical Correlations"},{"label":"C","text":"Trendelenburg gait is from quadriceps weakness"},{"label":"D","text":"Drop foot gait is from gluteal weakness"},{"label":"E","text":"Single-limb support is 80% of stance"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Normal Gait Cycle + Clinical Correlations: (1) **gait cycle** — from initial contact (heel strike) of one foot to next initial contact of same foot; divided into: (a) **stance phase** (~ 60% of cycle) — foot on ground; (b) **swing phase** (~ 40% of cycle) — foot off ground; (2) **8 sub-phases (Rancho Los Amigos)**: stance: (a) initial contact (heel strike), (b) loading response (foot flat), (c) mid-stance, (d) terminal stance (heel off), (e) pre-swing (toe off); swing: (f) initial swing, (g) mid-swing, (h) terminal swing; (3) **key events**: heel strike → flat foot → mid-stance → heel off → toe off; double-limb support (~ 20% — both feet on ground) at beginning + end of stance — reduced in running, increased in cautious gait (elderly, post-injury); single-limb support (~ 40%); cadence ~ 100-115 steps/min average adult; (4) **muscle activation**: (a) **heel strike + loading**: anterior tibialis + dorsiflexors (eccentric — controlled foot lowering); quadriceps (eccentric — controls knee flexion); hip extensors (gluteus maximus, hamstrings — extend hip); (b) **mid-stance**: quadriceps (knee extension), hip abductors (**gluteus medius** — stabilizes pelvis on stance leg, prevents contralateral drop); ankle plantarflexors stabilize; (c) **terminal stance + pre-swing**: ankle plantarflexors (gastroc-soleus — propulsion); hip flexors (iliopsoas — initiate swing); (d) **swing**: hip flexors (advance limb), knee flexors (avoid foot drag), ankle dorsiflexors (foot clearance); (5) **clinical gait abnormalities**: (a) **Trendelenburg gait** — gluteus medius weakness (Superior Gluteal Nerve injury, hip OA/AVN, post-THA) → contralateral pelvic drop during stance phase OR compensated by trunk lean toward affected side; (b) **antalgic gait** — pain → shortened stance phase on affected side, longer on unaffected; (c) **drop foot gait** (steppage gait) — tibialis anterior weakness (peroneal nerve injury, L5 radiculopathy) → exaggerated hip + knee flexion in swing to clear foot, foot slap on initial contact; (d) **circumduction gait** — leg length discrepancy, knee stiffness — swings affected leg around; (e) **scissor gait** — spastic adductors (CP, MS, stroke) — knees cross during gait; (f) **ataxic gait** — wide-based unsteady (cerebellar, sensory ataxia); (g) **shuffling gait** — Parkinson''s; (h) **vaulting** — leg-length discrepancy, contralateral plantarflexion to advance long limb; (6) **clinical use**: gait analysis lab (3D motion capture, force plate, EMG — comprehensive evaluation); applications: CP surgical planning, post-stroke, post-THA/TKA, prosthetic gait optimization, sports biomechanics

---

Gait cycle: stance (60%) + swing (40%). 8 sub-phases. Key muscles: anterior tibialis (heel strike eccentric), quadriceps (loading), gluteus medius (single-leg stance — pelvic stability), gastroc-soleus (push-off), hip flexors (swing initiation). Clinical: Trendelenburg (glut med — pelvis drops contralateral), antalgic (pain — shortened stance), drop foot (peroneal/L5), circumduction (LLD/stiff knee), scissor (spastic), ataxic (cerebellar), shuffling (PD). Gait labs for analysis.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'basic_science', 'msk_nontrauma', 'adult',
  'Perry Gait Analysis', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

**Normal gait cycle** — สำคัญสำหรับ evaluate gait abnormalities + post-injury / post-arthroplasty / pediatric ortho

อธิบาย gait cycle phases + muscle activation + clinical correlations (Trendelenburg, drop-foot, antalgic gait)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

**MRI in MSK imaging** — basic principles + sequences + clinical applications

อธิบาย MRI principles (T1, T2, STIR, PD) + tissue characterization + common MSK MRI applications', '[{"label":"A","text":"MRI uses ionizing radiation"},{"label":"B","text":"MRI in MSK Imaging"},{"label":"C","text":"T1 shows fluid as bright"},{"label":"D","text":"Gadolinium safe in all patients including dialysis"},{"label":"E","text":"MRI better than CT for cortical fractures"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** MRI in MSK Imaging: (1) **MRI physics** — based on hydrogen proton magnetization (most tissues contain water + fat); strong external magnetic field (1.5T, 3T, 7T research) aligns protons → radiofrequency (RF) pulse perturbs → relaxation (T1, T2) → signal detected → image reconstruction; no ionizing radiation; (2) **basic sequences + tissue characterization**: (a) **T1-weighted** — fat bright, water dark, anatomy; good for marrow architecture, sub-acute hemorrhage (methemoglobin — bright), fat-containing lesions (lipoma — bright); (b) **T2-weighted** — water bright (fluid, edema, inflammation, hemorrhage), fat bright (in conventional T2; suppressed in T2 FS), CSF bright; good for pathology detection; (c) **STIR (Short Tau Inversion Recovery)** or **T2-fat suppressed** — fluid bright + fat suppressed → highly sensitive for marrow edema (occult fracture, osteomyelitis, stress fracture, tumor); (d) **PD (Proton Density)** — middle ground, common for cartilage + menisci + ligament; (e) **gradient echo (GRE)** — sensitive to blood products + calcium (susceptibility artifact); (f) **DWI (diffusion-weighted)** — characterizes infection, tumor cellularity; (g) **Gadolinium-enhanced T1** — vascular tissues + tumor + active inflammation + abscess ring enhancement; **AVOID gadolinium in renal insufficiency** (GFR < 30) due to nephrogenic systemic fibrosis (NSF) risk; (3) **MR arthrogram** — direct intra-articular gadolinium injection → distends joint + outlines structures → best for labral tears (shoulder, hip), osteochondral defects, ligament injuries; (4) **clinical MSK MRI applications**: (a) **soft tissue assessment** — superior to CT for: ligaments, tendons, menisci, cartilage, muscle, nerves, bone marrow; (b) **occult fracture** — STIR shows bone marrow edema (e.g., scaphoid, hip stress, sacral); (c) **osteomyelitis vs cellulitis** — bone marrow edema + ring-enhancing abscess; (d) **soft tissue tumor** — characterization; (e) **stress fracture** — earlier detection than X-ray; (f) **spine** — disc herniation, stenosis, infection, tumor, demyelination; (g) **avascular necrosis** — early changes before X-ray; (5) **contraindications/limitations**: pacemakers (most modern MRI-compatible), cochlear implants, ferromagnetic foreign bodies (especially intraocular), claustrophobia; metal artifact (MARS sequences reduce); long scan time + cost; (6) **CT comparison**: CT better for cortical bone, fracture details, calcified lesions, fast (trauma — polytrauma evaluation), implant assessment

---

MRI MSK: T1 (fat bright, marrow + sub-acute blood + fat), T2 (fluid bright — pathology), STIR/T2-FS (fluid bright + fat suppressed — best for marrow edema: occult fracture, OM, stress fx), PD (cartilage, meniscus, ligament), GRE (blood/calcium), DWI, Gd (vascular, tumor, abscess — AVOID GFR < 30 — NSF). MR arthrogram for labrum/cartilage. Applications: soft tissue, occult fx, OM vs cellulitis, tumor, AVN, spine. CT better for cortical/calcified/trauma.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'orthopedics', 'basic_science', 'msk_nontrauma', 'adult',
  'Standard MSK Imaging', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

**MRI in MSK imaging** — basic principles + sequences + clinical applications

อธิบาย MRI principles (T1, T2, STIR, PD) + tissue characterization + common MSK MRI applications'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

**Biomechanics ของ hip joint** — joint reaction forces + abductor mechanism + clinical relevance

อธิบาย hip joint reaction force + Pauwels angle + abductor mechanism + clinical applications (THA design, cane use, single-leg stance)', '[{"label":"A","text":"Cane should be on same side as affected hip"},{"label":"B","text":"Hip Joint Biomechanics"},{"label":"C","text":"Hip JRF is equal to body weight in single-leg stance"},{"label":"D","text":"Weight loss does not affect hip joint forces"},{"label":"E","text":"Pauwels I is more unstable than Pauwels III"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hip Joint Biomechanics: (1) **hip joint** — ball-and-socket joint (femoral head in acetabulum); 3° freedom; deep socket + labrum + ligaments + capsule provide stability + mobility; (2) **joint reaction force (JRF)** — sum of all forces acting across joint; depends on muscle forces + body weight: (a) **single-leg stance** — body weight (W) acts at center of gravity medial to hip + abductor muscle force (F_abd) acts laterally; for equilibrium around hip joint center, abductor muscle must produce sufficient torque; (b) **abductor mechanism** — lever arm of abductors (short — 5 cm from center of hip) vs lever arm of body weight (longer — 10 cm) → abductor force must be ~ 2x body weight just to maintain balance; total JRF (abductor + body weight vector summed) = ~ 3-4x body weight in single-leg stance; (c) **walking** — JRF increases with cadence (4-6x BW); running 8-10x BW; stairs even higher; (3) **Pauwels angle** in femoral neck fractures — angle between fracture line + horizontal — > 50° (Pauwels III) = vertical fracture line → shear forces predominate → instability + higher non-union rate; (4) **abductor mechanism (lever arm + force) — clinical implications**: (a) **gluteus medius (primary hip abductor) weakness** → Trendelenburg gait; (b) **cane use in contralateral hand** — push down on cane creates upward force opposite to body weight → reduces moment arm of body weight → significantly reduces JRF (~ 30-50% in single-leg stance); cane in CONTRALATERAL hand (lever arm of cane + body weight on opposite side of hip cancel); (c) **avoid carrying heavy objects ipsilateral side** (increases JRF), prefer contralateral; (d) **weight loss** — directly reduces JRF (1 lb = 4 lb force at hip per step); (e) **hip preservation** — restore femoral offset (lateral distance from hip center to femoral shaft) + leg length in THA → optimal abductor mechanics + reduces wear + instability; (5) **THA design principles**: (a) restore femoral offset (under-restoration → abductor insufficiency, weakness, limp; over-restoration → trochanteric bursitis, leg discrepancy); (b) restore center of rotation; (c) appropriate cup version/inclination (Lewinnek safe zone — anteversion 5-25°, inclination 30-50°); (d) **leg length equalization** important; (6) **labrum** — sealing function + nourishment + stability; tear → instability + early arthritis; (7) **acetabular dysplasia + impingement (FAI — Cam, Pincer)** — biomechanical etiology of early arthritis; (8) **stress shielding** — rigid femoral stem absorbs load → bone resorption proximal femur (Wolff''s law)

---

Hip biomechanics: JRF = 3-4x BW in single-leg stance (abductor 2x BW + body weight). 4-6x BW walking, 8-10x running. Abductor mechanism: short lever arm vs longer body weight lever. Cane in CONTRALATERAL hand reduces JRF 30-50%. Pauwels III vertical fracture → shear instability. THA: restore offset + center of rotation + LL + Lewinnek safe zone. Weight loss directly reduces JRF. Labrum + FAI biomechanics matter. Stress shielding from rigid stems.', NULL,
  'hard', 'msk_nontrauma', 'review',
  'orthopedics', 'basic_science', 'msk_nontrauma', 'adult',
  'Pauwels; Lewinnek Safe Zone', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

**Biomechanics ของ hip joint** — joint reaction forces + abductor mechanism + clinical relevance

อธิบาย hip joint reaction force + Pauwels angle + abductor mechanism + clinical applications (THA design, cane use, single-leg stance)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

**Orthopedic implant materials** — metals + polymers + ceramics + applications + concerns

อธิบาย common implant materials (titanium, stainless steel, cobalt-chrome, polyethylene, PEEK, ceramics) + properties + clinical applications', '[{"label":"A","text":"Stainless steel has lowest modulus matching bone"},{"label":"B","text":"Orthopedic Implant Materials"},{"label":"C","text":"Metal-on-metal is current standard for THA"},{"label":"D","text":"Ceramic is too weak for any THA use"},{"label":"E","text":"UHMWPE has not improved since 1960s"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Orthopedic Implant Materials: (1) **Metals**: (a) **titanium + alloys (Ti-6Al-4V)** — modulus of elasticity closer to bone (less stress shielding), excellent biocompatibility (osseointegration — for cementless implants), corrosion resistant, MRI-compatible (lower artifact); used: spinal screws, fracture fixation plates/screws, dental, cementless hip stems; concerns: notch sensitivity, lower fatigue strength than CoCr, soft metal (poor for bearing surfaces); allergy rare; (b) **cobalt-chrome (CoCr) alloy** — high strength + wear resistance + corrosion resistance; used for bearing surfaces (hip head + knee femoral component) + porous coatings; concerns: high modulus → stress shielding, metal ion release (Co + Cr — concern with MoM bearings — pseudotumor, ALTR), nickel allergy (~ 10%); (c) **stainless steel (316L)** — strong, ductile, inexpensive; used for fracture plates/screws, K-wires, surgical instruments; concerns: high modulus, metal ion release, nickel content, NOT for permanent bearing; (d) **tantalum (porous trabecular metal)** — highly porous → bone ingrowth, low modulus close to bone, used for revision THA acetabular augments, cones for severe bone loss; expensive; (e) **magnesium alloys** — bioresorbable emerging for fixation in select pediatric/temporary; (2) **Polymers**: (a) **ultra-high molecular weight polyethylene (UHMWPE)** — bearing surface for TKA, THA, shoulder arthroplasty (paired against CoCr or ceramic); historic standard; concerns: wear → particulate → **osteolysis + aseptic loosening** (major historical cause of revision); (b) **highly cross-linked polyethylene (XLPE)** — modern improvement, gamma irradiation creates cross-links → reduces wear 50-90% → reduces osteolysis + loosening; standard for modern THA; (c) **vitamin-E enhanced XLPE** — antioxidant prevents oxidative degradation; (d) **PEEK (polyetheretherketone)** — radiolucent, modulus close to bone; used: spinal cages (interbody), some plates, suture anchors; (e) **PMMA (polymethyl methacrylate, bone cement)** — for cemented fixation; exothermic polymerization (heat); concerns: "bone cement implantation syndrome" — embolism + hypotension intra-op (especially elderly cemented hip hemi); (3) **Ceramics**: (a) **alumina (Al₂O₃)** — hard, wear-resistant; used for femoral head + acetabular liner; brittle (fracture risk historically 1-5%, modern materials 0.01%); excellent biocompatibility; (b) **zirconia + zirconia-toughened alumina (ZTA, BIOLOX delta)** — improved fracture resistance + wear; modern standard for ceramic-on-ceramic; (c) **hydroxyapatite (HA) coating** — bioactive bone-binding for cementless implant; (d) ceramic-on-ceramic — excellent wear (< 1 mm³/year) but "squeaking" 1-3% + fracture rare; (4) **modern THA bearing**: ceramic-on-XLPE most common (low wear + low fracture risk); ceramic-on-ceramic premium (lowest wear), metal-on-XLPE classic; **avoid metal-on-metal** (ALVAL, ARMD — pseudotumor, except for resurfacing in select males); (5) **implant failure modes**: (a) infection (PJI), (b) aseptic loosening (wear-induced osteolysis → most common with traditional UHMWPE), (c) instability/dislocation, (d) periprosthetic fracture, (e) material failure (rare with modern); (6) **MRI compatibility** of implants — titanium > stainless steel > CoCr

---

Implant materials: titanium (low modulus, biocompatible, fixation), CoCr (bearing surfaces, strong, wear-resistant), stainless steel (cheaper fixation), tantalum (porous, revision augments), UHMWPE (historic bearing → osteolysis), XLPE (modern — 50-90% less wear), PEEK (spine, radiolucent), PMMA (cement), alumina/zirconia (ceramic bearing). Modern THA: ceramic-on-XLPE. AVOID MoM (ALTR/pseudotumor). Failure modes: infection, loosening (wear-osteolysis), instability, fracture.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'basic_science', 'msk_nontrauma', 'adult',
  'AAOS Implant Materials', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

**Orthopedic implant materials** — metals + polymers + ceramics + applications + concerns

อธิบาย common implant materials (titanium, stainless steel, cobalt-chrome, polyethylene, PEEK, ceramics) + properties + clinical applications'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

**Local anesthetics in orthopedics** — mechanism + properties + duration + toxicity

อธิบาย local anesthetics (lidocaine, bupivacaine, ropivacaine) + mechanism + duration + dose limits + LAST (local anesthetic systemic toxicity) management + regional blocks', '[{"label":"A","text":"Esters have lower allergy risk than amides"},{"label":"B","text":"commonly used in orthopedics"},{"label":"C","text":"Lipid emulsion not used in LAST"},{"label":"D","text":"Bupivacaine has shorter duration than lidocaine"},{"label":"E","text":"All local anesthetics are renally excreted"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Local Anesthetics: (1) **mechanism** — block voltage-gated sodium channels on neuronal axons → prevent depolarization + action potential propagation → block sensation + motor; (2) **classification**: (a) **amides** (metabolized in liver) — lidocaine, bupivacaine, ropivacaine, mepivacaine; suffix "-caine" with one "i" before -caine often = amide; (b) **esters** (metabolized by plasma cholinesterase) — procaine, chloroprocaine, tetracaine, cocaine; higher allergy risk (PABA metabolite); (3) **commonly used in orthopedics**: (a) **lidocaine** — onset 1-2 min, duration 1-2 hours (with epinephrine 2-3 hours); max dose **5 mg/kg without epinephrine, 7 mg/kg with epinephrine** (epinephrine vasoconstriction → reduces systemic absorption + prolongs duration); (b) **bupivacaine** — slower onset 5-10 min, **long duration 4-8 hours** (with epi up to 12h); max dose **2.5 mg/kg** (3 mg/kg with epi); high cardiotoxicity (Na channel blockade in heart → arrhythmia); used for prolonged regional blocks; (c) **ropivacaine** — slower onset, duration similar to bupivacaine, **lower cardiotoxicity** than bupivacaine, preferred for large regional blocks; max 3-4 mg/kg; (d) **liposomal bupivacaine (Exparel)** — prolonged-release formulation, 72-hour duration; (e) **chloroprocaine** — rapid onset, very short duration (45 min), useful for surgical anesthesia in epidural; (4) **avoid epinephrine** in: digits + extremities with end-arteries traditionally taught (modern evidence — safe in healthy digits with appropriate concentration < 1:100,000), penis, nose tip, earlobe; in patients with severe HTN, cardiovascular disease; (5) **LAST (Local Anesthetic Systemic Toxicity)** — emergency: (a) symptoms — early CNS (perioral numbness, metallic taste, tinnitus, dizziness, seizure) → coma; cardiovascular — bradycardia, arrhythmia, hypotension, cardiac arrest; (b) **treatment** — immediate stop injection, ABCs, supplemental O2, **20% lipid emulsion (Intralipid) bolus 1.5 mL/kg → infusion 0.25 mL/kg/min** — sequesters lipid-soluble anesthetic; benzodiazepines for seizure; avoid vasopressin + calcium channel blocker; epinephrine doses lower than ACLS (< 1 μg/kg); ACLS modified (no procainamide, lidocaine); (6) **regional anesthesia in orthopedics**: (a) **Bier block** (IV regional) — tourniquet + IV lidocaine in extremity — for short hand/wrist surgery; (b) **brachial plexus blocks** — interscalene (shoulder), supraclavicular (arm), infraclavicular, axillary (hand/forearm); (c) **fascia iliaca compartment block** — hip fracture analgesia (femoral + LFCN + obturator); (d) **femoral nerve block + adductor canal block** — knee surgery (adductor canal preserves quad strength); (e) **popliteal sciatic block** — foot/ankle surgery; (f) **continuous catheters** for prolonged blocks; (g) **ultrasound guidance** standard modern technique (reduces complications, improves accuracy); (7) ortho applications — reduce opioid use, faster recovery, multimodal pain management

---

Local anesthetics: block Na channels → no AP. Amides (lido, bupi, ropi — liver metabolism) vs esters (allergy risk). Lidocaine 5 mg/kg (7 with epi), bupivacaine 2.5 mg/kg (long but cardiotoxic), ropivacaine (lower cardiotoxic). Epinephrine prolongs + reduces absorption. LAST: CNS → CV → ARREST; treat with 20% LIPID EMULSION + ACLS modified. Regional blocks: brachial plexus, fascia iliaca, femoral, adductor canal, popliteal sciatic — US-guided standard.', NULL,
  'medium', 'procedures', 'review',
  'orthopedics', 'basic_science', 'procedures', 'adult',
  'ASRA LAST Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

**Local anesthetics in orthopedics** — mechanism + properties + duration + toxicity

อธิบาย local anesthetics (lidocaine, bupivacaine, ropivacaine) + mechanism + duration + dose limits + LAST (local anesthetic systemic toxicity) management + regional blocks'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

**Tourniquet physiology + safe practices** ในผ่าตัด ortho — สำคัญสำหรับ bloodless field

อธิบาย tourniquet physiology + pressure recommendations + safe time + complications + applications', '[{"label":"A","text":"Tourniquet can stay inflated indefinitely"},{"label":"B","text":"Tourniquet Physiology + Practice"},{"label":"C","text":"Lower extremity needs lower pressure than upper extremity"},{"label":"D","text":"Esmarch should not be removed before closure in finger surgery"},{"label":"E","text":"Tourniquet is safe in severe PVD"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Tourniquet Physiology + Practice: (1) **purpose** — provides bloodless surgical field → improves visualization + reduces blood loss + shorter operative time; (2) **types**: (a) **pneumatic tourniquet** — most common, modern; (b) **rubber esmarch bandage** — for exsanguination before pneumatic inflation, or as primary tourniquet in select cases; (c) **digital tourniquet** for finger surgery (Penrose drain — must be removed before closure to avoid being forgotten — "never event"); (3) **pressure recommendations**: (a) **upper extremity** — typically 200-250 mmHg, or **50 mmHg above systolic blood pressure (SBP)**; (b) **lower extremity** — 250-350 mmHg, or **100 mmHg above SBP**; (c) **limb occlusion pressure (LOP)** — measure individualized pressure required to occlude arterial flow (modern recommendation) — Doppler-confirmed → set tourniquet at LOP + safety margin (50-100 mmHg above LOP) → reduces complications vs fixed high pressure; (4) **safe tourniquet time**: (a) **maximum 2 hours** recommended — beyond → ischemia + reperfusion injury risk increases; (b) deflate periodically — "tourniquet break" of 10-15 minutes after each 90-120 minutes; reperfusion → metabolic acidosis temporary; (c) **avoid tourniquet in**: severe peripheral vascular disease, AV fistula, sickle cell disease (risk crisis — controversial), tumor (theoretical tumor cell dissemination — but used routinely with controversy), severe vascular calcification; (5) **complications**: (a) **nerve injury** — most common — pressure neuropraxia (especially radial > ulnar > median upper, peroneal > tibial lower); usually transient, can be permanent (~ 1:5,000); higher with prolonged time + high pressure + thin patients; (b) **muscle injury** — ischemia → rhabdo, compartment syndrome (rare); (c) **vascular injury** — atheroma dislodgement, DVT, post-tourniquet syndrome; (d) **skin injury** — under-padding, wrong placement (wrinkles, alcohol-soaked drapes); (e) **post-tourniquet syndrome** — swelling, stiffness, pallor, weakness 1-6 weeks; (f) **PE/DVT** — release of tourniquet → embolism; (g) **systemic hemodynamic effects** — release → hypotension + acidosis + hyperkalemia + brief; (6) **safe practices**: (a) appropriate cuff size + correct placement (proximal limb on muscle bellies, not over joints, nerves, bony prominences), (b) padding underneath (wrinkles cause injury), (c) drape carefully (alcohol prep can soak into padding → chemical burn under cuff), (d) exsanguinate by elevation + Esmarch (avoid in infection, malignancy), (e) record time + pressure clearly, (f) deflate when no longer needed (don''t routinely leave inflated through closure), (g) communicate with anesthesia (hemodynamic effects); (7) **modern alternatives**: tranexamic acid (TXA) reduces need for prolonged tourniquet in TKA

---

Tourniquet: bloodless field. Pressure: 50 mmHg above SBP (UE), 100 mmHg above SBP (LE), or modern LOP-based (Doppler) + 50-100 mmHg margin. Max time 2h, break 10-15 min after 90-120 min. Complications: nerve injury (most common — neuropraxia, can be permanent), muscle/rhabdo, post-tourniquet syndrome, embolism. Avoid in PVD, sickle cell. Proper placement + padding + dry drapes critical. TXA reduces need.', NULL,
  'easy', 'procedures', 'review',
  'orthopedics', 'basic_science', 'procedures', 'adult',
  'AAOS Tourniquet Safety', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

**Tourniquet physiology + safe practices** ในผ่าตัด ortho — สำคัญสำหรับ bloodless field

อธิบาย tourniquet physiology + pressure recommendations + safe time + complications + applications'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

**Effects of medications on bone + soft tissue healing** — perioperative management of common medications

อธิบาย effects ของ corticosteroid, NSAIDs, methotrexate, biologic DMARDs (anti-TNF), bisphosphonate ต่อ surgical healing + perioperative considerations', '[{"label":"A","text":"Stop methotrexate before all surgery"},{"label":"B","text":"Medication Effects on Orthopedic Healing + Perioperative Management"},{"label":"C","text":"NSAIDs always best for fracture healing"},{"label":"D","text":"Smoking does not affect bone healing"},{"label":"E","text":"Bisphosphonates have no risks"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Medication Effects on Orthopedic Healing + Perioperative Management: (1) **corticosteroids** — impair wound + bone healing (inhibit fibroblast proliferation, collagen synthesis, angiogenesis, immune function); long-term use → osteoporosis, AVN, infection risk; (a) **perioperative**: do NOT abruptly stop chronic users (adrenal insufficiency); **stress-dose steroid** for major surgery if chronic high-dose (> 20 mg prednisolone/day or equivalent > 3 weeks within past year) — hydrocortisone 50-100 mg IV at induction + 50 mg q8h × 24-48h then taper; (b) avoid intra-articular steroid within 3 months pre-joint arthroplasty (increased infection risk); (2) **NSAIDs** — variable effect on bone healing: (a) inhibit prostaglandin synthesis (COX inhibition) → may impair early fracture healing in animal studies; clinical evidence mixed — most studies show no significant clinical effect with short-term use; (b) avoid in: severe comminuted fractures, non-union concern, spine fusion (controversial), pediatric long bone fracture; (c) reasonable for short-term post-op pain + multimodal analgesia + reducing opioid use; (d) renal + GI + CV considerations; (e) selective COX-2 better GI profile but CV concerns; (3) **methotrexate (MTX)** — DMARD for RA, psoriasis; perioperative: (a) **continue MTX through surgery** (no increased infection risk per ACR/AAHKS guidelines + multiple studies); (b) hold if active infection or significant renal dysfunction; (c) low-dose folate supplementation continued; (4) **biologic DMARDs (anti-TNF — adalimumab, etanercept, infliximab, certolizumab; IL-6 — tocilizumab; B-cell — rituximab; JAK inhibitors — tofacitinib, baricitinib)** — perioperative for elective surgery: (a) **hold during peri-operative period** — timing based on dosing interval (e.g., adalimumab — hold ~ 1-2 doses pre-op = 2-4 weeks; etanercept — 1 week; infliximab — 4-6 weeks); (b) **resume when wound healed** (typically 2 weeks post-op); (c) screen TB + hepatitis before initiation; (5) **bisphosphonates** — anti-resorptive: (a) generally safe to continue perioperatively; (b) **osteonecrosis of the jaw (ONJ)** risk — minimize invasive dental procedures during therapy; **atypical femur fracture (AFF)** — subtrochanteric/diaphyseal, prodromal thigh pain, transverse + lateral cortex thickening — bilateral risk (screen contralateral); (c) **denosumab** (anti-RANKL) — same ONJ + AFF risk; **rebound vertebral fractures if stopped abruptly without transition** to bisphosphonate; (6) **anticoagulants** — perioperative bridging: warfarin INR < 1.5 typically required; DOAC hold 24-48h depending; resume post-op based on bleeding risk + DVT prophylaxis dose; (7) **smoking** — single most important modifiable risk factor for impaired healing — counsel cessation 4-8 weeks pre-op (significantly reduces infection, non-union, wound complications); (8) **glycemic control** — HbA1c < 7.5-8 for elective arthroplasty (reduces infection risk); (9) **vitamin D + nutrition** — vitamin D deficiency (< 30 ng/mL) common → optimize

---

Medications + healing: corticosteroid impairs (stress-dose if chronic high-dose, avoid IA steroid 3 mo pre-arthroplasty), NSAIDs variable (avoid in non-union concern, spine fusion), MTX continue through surgery (no infection risk), biologic DMARDs HOLD perioperatively (resume 2 wk post-wound healing), bisphosphonate continue (ONJ + AFF risk), denosumab — rebound fractures if stopped abruptly. Smoking cessation 4-8 wk pre-op (largest modifiable). HbA1c < 7.5-8 elective arthroplasty.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'basic_science', 'msk_nontrauma', 'adult',
  'ACR/AAHKS Perioperative Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

**Effects of medications on bone + soft tissue healing** — perioperative management of common medications

อธิบาย effects ของ corticosteroid, NSAIDs, methotrexate, biologic DMARDs (anti-TNF), bisphosphonate ต่อ surgical healing + perioperative considerations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

**Compartment pressure measurement** + interpretation

อธิบาย technique + interpretation + perfusion pressure (ΔP) + indications for fasciotomy', '[{"label":"A","text":"Pulselessness is the earliest sign"},{"label":"B","text":"Compartment Pressure Measurement"},{"label":"C","text":"Absolute pressure > 50 mmHg required for fasciotomy"},{"label":"D","text":"Always wait 24 hours before fasciotomy"},{"label":"E","text":"Only measure one compartment per limb"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Compartment Pressure Measurement: (1) **acute compartment syndrome (ACS)** = elevated intra-compartmental pressure → impaired tissue perfusion → ischemia/necrosis; clinical diagnosis primary but pressure measurement supports + helps in equivocal/obtunded patients; (2) **most reliable clinical signs** — pain out of proportion + pain with passive stretch of involved compartment muscles; 5 P''s classically taught (Pain, Paresthesia, Pallor, Paralysis, Pulselessness) — but **late signs**, especially pulselessness (often last to appear, may be preserved); (3) **measurement technique**: (a) **Stryker device** (handheld with disposable side-port needle + transducer) — most common; (b) **arterial line transducer system** (in OR/ICU); (c) **slit catheter** for continuous monitoring; (d) **needle insertion** into compartment perpendicular, advance slowly, calibrate, hold transducer at level of measurement, read; (e) measure **each compartment** of the limb — leg has 4 (anterior, lateral, deep posterior, superficial posterior); forearm has 3 (volar, dorsal, mobile wad); hand has multiple; (4) **interpretation**: (a) **absolute pressure** — > 30 mmHg threshold traditionally; but variable with patient blood pressure; (b) **perfusion pressure (ΔP)** = **diastolic BP - compartment pressure** — physiologic measure; **ΔP < 30 mmHg → fasciotomy** (improved accuracy vs absolute pressure, accounts for individual perfusion needs); recommended by Whitesides + McQueen; (c) normal compartment pressure 0-10 mmHg; (d) **trend over time** more useful than single value; (5) **fasciotomy indications**: (a) clinical compartment syndrome — proceed without delay; (b) pressure measurement supports in equivocal cases — ΔP < 30 mmHg; (c) crush injury, prolonged ischemia, reperfusion, tibial fracture, supracondylar humerus fracture in children, snake bite, exertional CS in athletes; (6) **leg fasciotomy** — 4-compartment via 2 incisions (medial + lateral): anterior + lateral compartments through lateral incision; deep posterior + superficial posterior through medial incision; complete release through entire compartment fascia; (7) **forearm fasciotomy** — volar (extended Henry — releases superficial + deep flexor + carpal tunnel + lacertus + mobile wad) + dorsal incisions; (8) **hand fasciotomy** — multiple incisions for 10 compartments; (9) **gluteal compartment syndrome** — rare, prolonged immobilization (drug overdose); fasciotomy posterior approach; (10) **avoid delay** > 6-8 hours from onset → irreversible muscle necrosis → Volkmann''s contracture, nerve damage, possible amputation; (11) **always document carefully** — high medicolegal risk; serial exams documented

---

Compartment pressure: clinical dx primary. Measurement (Stryker, arterial line) for equivocal/obtunded. ΔP = DBP - compartment pressure — **< 30 mmHg = fasciotomy** (better than absolute > 30). 5 P''s (pulselessness LATE). Indications: clinical CS, equivocal + ΔP < 30, high-risk injuries. Leg fasciotomy 4 compartments via 2 incisions. Forearm — volar (Henry + CTR) + dorsal. Don''t delay > 6-8h. Document serial exams (medicolegal).', NULL,
  'medium', 'trauma', 'review',
  'orthopedics', 'basic_science', 'trauma', 'adult',
  'Whitesides; McQueen', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

**Compartment pressure measurement** + interpretation

อธิบาย technique + interpretation + perfusion pressure (ΔP) + indications for fasciotomy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

**Fat embolism syndrome (FES)** — pathophysiology + clinical features + management

อธิบาย FES pathophysiology + Gurd criteria + management', '[{"label":"A","text":"Fat embolism only affects lungs"},{"label":"B","text":"Fat Embolism Syndrome (FES)"},{"label":"C","text":"Fat embolism never causes neurologic symptoms"},{"label":"D","text":"Diagnosis is by CT scan only"},{"label":"E","text":"Treatment is high-dose steroids in all patients"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Fat Embolism Syndrome (FES): (1) **definition** — clinical syndrome from fat emboli released into systemic circulation, typically after long bone fracture or intramedullary nailing/reaming; (2) **incidence** — subclinical fat embolism in essentially all long bone fractures + reamed IM nail (echocardiographic + lab evidence); clinical FES occurs in 1-3% of long bone + pelvic fractures, higher with bilateral femur + delayed fixation; (3) **pathophysiology**: (a) **mechanical theory** — disrupted marrow fat enters venous circulation → emboli to pulmonary capillaries → ARDS-like picture + bypass to systemic via patent foramen ovale (~ 25% population) or pulmonary shunt → brain + skin; (b) **biochemical theory** — released free fatty acids cause inflammatory response + capillary leak + ARDS; (c) systemic inflammatory response; (4) **clinical features** — classic triad (24-72h after injury): (a) **respiratory distress** (75%) — tachypnea, hypoxemia, ARDS-pattern bilateral infiltrates on CXR; (b) **neurologic** (50%) — confusion, agitation, coma, focal deficits; (c) **petechial rash** (50-60%) — most specific feature — axilla, conjunctiva, oral mucosa, neck — non-dependent areas; (d) other — fever, tachycardia, retinopathy (cotton-wool spots), anemia, thrombocytopenia, hypocalcemia, elevated lipase, fat in urine; (5) **Gurd criteria** (1970) for diagnosis: (a) **major** (need 1): petechial rash, respiratory insufficiency, cerebral dysfunction unrelated to head injury; (b) **minor**: fever > 38.5, tachycardia > 110, retinopathy, jaundice, renal changes, anemia, thrombocytopenia, ESR elevated, fat macroglobulinemia; (6) **differential diagnosis** — pulmonary embolism (DVT), pneumonia, ARDS from other cause, sepsis, head injury (for neurologic features); (7) **management — primarily supportive**: (a) **early operative fixation** of long bone fractures within 24-48h reduces FES incidence ("early total care" historically — now "damage control orthopedics" for polytrauma + ARDS; current evidence balances both); (b) **supportive ICU care** — oxygen ± mechanical ventilation (lung-protective settings), hemodynamic support, IV fluids carefully (avoid overload), monitor coagulation; (c) **DVT prophylaxis** (mechanical + chemical when bleeding controlled); (d) **steroids** — controversial — historical use, some evidence for prevention with high-dose methylprednisolone but not standard; (e) **mortality** 5-15% with modern care; full recovery common in survivors; (8) **prevention**: (a) early fracture stabilization, (b) avoid unnecessary delay, (c) careful intramedullary reaming + nailing technique (use small holes, slow reaming, vent pressure), (d) consider non-reamed nail in polytrauma + lung injury, (e) damage control orthopedics for severe polytrauma

---

Fat embolism: 1-3% long bone fractures. Triad 24-72h after injury: respiratory distress (ARDS) + neurologic + petechial rash (axilla, conjunctiva, oral — non-dependent). Gurd criteria. Pathogenesis: mechanical + biochemical. Management: supportive ICU + early fracture fixation (reduces incidence). Damage control for polytrauma + lung injury. Steroids controversial. Mortality 5-15%. Prevent by early stabilization + careful IM reaming.', NULL,
  'medium', 'trauma', 'review',
  'orthopedics', 'basic_science', 'trauma', 'adult',
  'Gurd Criteria; Pape OTA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

**Fat embolism syndrome (FES)** — pathophysiology + clinical features + management

อธิบาย FES pathophysiology + Gurd criteria + management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

**Vitamin D + calcium metabolism** + bone health implications

อธิบาย vitamin D synthesis + activation + PTH + calcium homeostasis + clinical correlations (rickets, osteomalacia, osteoporosis)', '[{"label":"A","text":"25-OH vitamin D is the active form"},{"label":"B","text":"Vitamin D + Calcium Metabolism"},{"label":"C","text":"PTH is released in response to high calcium"},{"label":"D","text":"Vitamin D deficiency does not affect bone"},{"label":"E","text":"Calcium has no role in muscle function"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Vitamin D + Calcium Metabolism: (1) **vitamin D sources**: (a) skin synthesis from 7-dehydrocholesterol → cholecalciferol (D3) under UVB light (most physiologic — 30 min sun exposure can provide adequate); (b) dietary — D2 (ergocalciferol — plant-based, fortified foods) + D3 (animal-based — fatty fish, egg yolks, fortified dairy); (2) **activation**: (a) **25-hydroxylation in liver** → 25(OH)D (calcidiol — circulating form, **best clinical marker of vitamin D status**); (b) **1α-hydroxylation in kidney** → 1,25(OH)2D (calcitriol — active form); regulated by PTH (stimulates) + phosphate (inhibits) + calcium (inhibits); also some 1α-hydroxylase in immune cells + skin (extrarenal); (3) **actions of calcitriol**: (a) **intestine** — increases calcium + phosphate absorption (binds VDR → increases calcium-binding protein + TRPV6 channel); (b) **bone** — increases osteoclast activity (mobilize calcium) + supports mineralization; (c) **kidney** — increases calcium reabsorption (with PTH); (d) **immune** — modulates immune function; (e) **muscle** — strength + balance; (4) **PTH (parathyroid hormone)** — released from parathyroid glands in response to LOW serum ionized calcium (via calcium-sensing receptor); actions: (a) **bone** — increases osteoclastic activity → releases calcium + phosphate; (b) **kidney** — increases calcium reabsorption (distal tubule), decreases phosphate reabsorption, increases 1α-hydroxylase activity; (c) net effect — raises serum calcium + lowers phosphate; (5) **calcium homeostasis** — tight regulation: (a) **PTH** raises calcium (rapid); (b) **calcitriol** raises calcium (intestinal absorption — slower); (c) **calcitonin** lowers calcium (minor in adults); (d) **FGF-23** (from osteocytes) — regulates phosphate (inhibits reabsorption); (6) **vitamin D deficiency**: (a) **definition** — 25(OH)D < 20 ng/mL deficient; 20-30 insufficient; > 30 sufficient (debated); (b) **causes** — inadequate sun exposure, dietary, malabsorption (celiac, IBD, bariatric), liver/renal disease, anticonvulsants (increase metabolism), obesity (sequestered in adipose); (c) **consequences**: rickets in children (impaired mineralization → bowed legs, rachitic rosary, widened wrists, delayed milestones), osteomalacia in adults (impaired mineralization → bone pain, muscle weakness, pseudofractures Looser zones, increased fracture risk), proximal myopathy + falls in elderly, secondary hyperparathyroidism, osteoporosis exacerbation; (7) **supplementation**: (a) **800-2000 IU/day** maintenance; **higher loading dose** (50,000 IU weekly × 8 weeks) for deficiency; (b) **calcium 1000-1200 mg/day** dietary or supplemental; (c) target 25(OH)D > 30 ng/mL; (8) **clinical correlations in orthopedics**: (a) **bone healing** — adequate vitamin D + calcium important for fracture healing; check + replete; (b) **osteoporosis** — universal recommendation for vit D + Ca with anti-osteoporosis drugs; (c) **hip fracture patients** — high prevalence of deficiency, replete to prevent re-fracture + falls; (d) **post-arthroplasty** — vitamin D deficient patients have higher complication rates per recent studies; (e) **pediatric orthopedics** — vitamin D deficiency contributes to rickets + bone fragility

---

Vitamin D: synthesized in skin (UVB) → 25-OH in liver (best marker) → 1,25-OH (active) in kidney (PTH-stimulated). Actions: intestinal Ca/P absorption + bone resorption + kidney reabsorption. PTH responds to LOW Ca — raises Ca, lowers P. Deficiency: < 20 ng/mL. Consequences: rickets (peds), osteomalacia (adults), osteoporosis, falls. Repletion: 800-2000 IU + Ca 1000-1200 mg. Check + replete in fracture, osteoporosis, hip fracture, arthroplasty patients.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'orthopedics', 'basic_science', 'msk_nontrauma', 'adult',
  'Endocrine Society Vitamin D', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

**Vitamin D + calcium metabolism** + bone health implications

อธิบาย vitamin D synthesis + activation + PTH + calcium homeostasis + clinical correlations (rickets, osteomalacia, osteoporosis)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

**Nuclear medicine imaging** ใน orthopedics — bone scan + indications + interpretation

อธิบาย technetium bone scan (3-phase) + indications + interpretation + comparison with PET-CT', '[{"label":"A","text":"Bone scan uses ionizing X-ray only"},{"label":"B","text":"Nuclear Medicine in Orthopedics"},{"label":"C","text":"3-phase scan only assesses bone phase"},{"label":"D","text":"WBC scan is not useful for chronic OM"},{"label":"E","text":"Bone scan is the best test for soft tissue tumors"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Nuclear Medicine in Orthopedics: (1) **Technetium-99m methylene diphosphonate (Tc-99m MDP) bone scan** — most common; binds to hydroxyapatite at sites of bone turnover (osteoblast activity), reflects bone remodeling; (2) **3-phase bone scan**: (a) **flow phase** — dynamic images during injection (~ first minute) — assesses **blood flow** to area; positive in cellulitis, septic arthritis, acute inflammation; (b) **blood pool phase** — static images at 5-10 minutes — assesses **soft tissue hyperemia**; positive in cellulitis, inflammation, early infection; (c) **delayed phase** — static images at 2-4 hours after radiotracer cleared from soft tissue — assesses **bone uptake** specifically; positive in fracture, infection, neoplasm, metabolic bone disease; (d) **4th phase (24-hour)** — sometimes added for distinguishing infection from cellulitis (infection persists, cellulitis fades); (3) **indications**: (a) **occult fracture** — stress fracture (especially femoral neck, navicular, metatarsal), child abuse, hip fracture in elderly with normal X-ray; (b) **infection (osteomyelitis)** — sensitive + non-specific; better when combined with **WBC scan (Indium-111 or Tc-99m HMPAO-labeled WBC)** for chronic OM diagnosis; (c) **metastatic disease** — whole-body screening for skeletal mets (breast, prostate, lung); compared with PET-CT (more specific); (d) **Paget''s disease, fibrous dysplasia, osteomyelitis assessment**; (e) **complex regional pain syndrome (CRPS)** — increased uptake all 3 phases classically; (f) **prosthetic joint loosening vs infection** — combined bone scan + WBC scan; (g) **AVN of femoral head** — early phase decreased uptake (avascular), late phase increased (revascularization); (h) **growth plate assessment**, congenital anomalies; (4) **interpretation pitfalls**: (a) very young children — normally high uptake at physes (growth plates); (b) Paget''s disease — markedly increased uptake; (c) photopenia (cold lesion) — multiple myeloma, aggressive lytic tumor (lytic > blastic — bone scan less sensitive than CT for lytic only); (d) post-surgical changes — uptake persists 12-18 months around hardware; (5) **other nuclear medicine**: (a) **PET-CT with FDG (fluorodeoxyglucose)** — assesses glucose metabolism, sensitive for tumor (primary + recurrence + metastases), infection, inflammation; combined with CT for anatomic localization; (b) **PET-CT with Na-18F (sodium fluoride)** — better bone-specific PET, replacing some bone scan; (c) **SPECT-CT** combines functional bone scan + anatomic CT — improved localization; (6) **comparison**: bone scan high sensitivity, low specificity; PET-CT higher resolution + specificity for tumor; MRI better for soft tissue + early changes; (7) **radiation dose** — bone scan ~ 4-6 mSv (relevant for pediatric)

---

Bone scan: Tc-99m MDP, binds hydroxyapatite — reflects bone turnover. 3-phase: flow (blood flow), blood pool (soft tissue), delayed (bone) — distinguishes infection vs cellulitis. Indications: occult fracture (stress), OM, skeletal mets, prosthetic loosening vs infection (+WBC scan), AVN, CRPS, Paget. Pitfalls: pediatric physes, multiple myeloma cold lesions. PET-CT (FDG, Na-18F) — tumor + infection. SPECT-CT — combined. MRI for soft tissue.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'basic_science', 'msk_nontrauma', 'adult',
  'SNM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

**Nuclear medicine imaging** ใน orthopedics — bone scan + indications + interpretation

อธิบาย technetium bone scan (3-phase) + indications + interpretation + comparison with PET-CT'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

**Surgical antibiotic prophylaxis in orthopedics** — evidence-based principles

อธิบาย principles + timing + drug choice + duration for different ortho procedures (arthroplasty, fracture, spine, sports surgery)', '[{"label":"A","text":"Antibiotic should be given 2 hours before incision"},{"label":"B","text":"Surgical Antibiotic Prophylaxis in Orthopedics"},{"label":"C","text":"Vancomycin alone covers all pathogens"},{"label":"D","text":"Continue prophylaxis 7 days post-op for all arthroplasty"},{"label":"E","text":"Dental prophylaxis required indefinitely post-arthroplasty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Surgical Antibiotic Prophylaxis in Orthopedics: (1) **principles** — reduce surgical site infection (SSI) rate; antibiotic must achieve adequate tissue concentration at the time of incision + throughout the period of contamination; (2) **timing**: (a) **administer within 60 minutes before incision** (within 120 min for vancomycin + fluoroquinolones due to infusion time); (b) ideally complete infusion before tourniquet inflation; (c) too early (> 60 min before incision) → reduced efficacy; too late (after incision) → reduced efficacy; (3) **drug choice — first-line** (CDC/SCIP/AAOS guidelines): (a) **cefazolin 2 g IV (3 g for > 120 kg)** — first-line for most orthopedic surgery (covers S. aureus, Streptococcus, some gram-negative); cefazolin > cefuroxime for ortho (better gram-positive); (b) **vancomycin** alternative or addition: (i) beta-lactam allergy (true IgE-mediated — not just rash with penicillin), (ii) MRSA-colonized patients (positive nasal screening), (iii) high MRSA prevalence institutions, (iv) revision arthroplasty with prior infection; vancomycin alone has worse gram-negative coverage → typically combined with cefazolin if both indicated; (c) **clindamycin** — alternative for true beta-lactam allergy if vancomycin not feasible; (d) **gentamicin** — added for: contaminated open fractures, GU surgery preparation; (4) **redosing intraoperatively**: cefazolin q 4 hours during long surgery (half-life ~ 2 hours); after significant blood loss (> 1500 mL); (5) **duration**: (a) **single pre-op dose ± intra-op redosing** sufficient for most clean orthopedic surgery; (b) **24 hours postoperative** for arthroplasty (currently 24-hour standard; some shorter); not longer — does not reduce SSI + increases C. diff + resistance; (c) **prolonged for open fractures** based on Gustilo classification (covered separately): I-II — 24-48 hours cefazolin; III — extended (48-72h) with gram-negative coverage; (6) **specific orthopedic settings**: (a) **clean elective (TKA, THA, ACDF, spine fusion)** — cefazolin pre-op + 24h; (b) **open fracture** — based on Gustilo type; (c) **arthroscopy** — single pre-op dose; (d) **fragility hip fracture** — cefazolin pre-op + 24h; (7) **MRSA screening + decolonization** — pre-op nasal swab; if positive → 5-day mupirocin ointment + chlorhexidine wash + add vancomycin to prophylaxis; (8) **dental prophylaxis post-arthroplasty** — AAOS + ADA evidence-based guideline 2012/2014: **no longer routinely recommended** for healthy patients (no clear evidence link dental procedures to PJI); selective for immunocompromised + first 2 years post-arthroplasty; (9) **avoid prolonged prophylaxis** — no benefit + increases C. diff + resistance + adverse effects

---

Ortho antibiotic prophylaxis: cefazolin 2-3 g IV within 60 min pre-incision (vancomycin 120 min). Add vancomycin for beta-lactam allergy, MRSA carrier, revision after prior infection. Redose cefazolin q 4h + after major blood loss. Duration: pre-op + 24h post-op for most (no longer). Open fractures: extended based on Gustilo. MRSA screening + decolonization pre-arthroplasty. Dental prophylaxis post-arthroplasty NOT routine (AAOS/ADA 2014).', NULL,
  'easy', 'id', 'review',
  'orthopedics', 'basic_science', 'id', 'adult',
  'AAOS; SCIP; ADA Joint Statement', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

**Surgical antibiotic prophylaxis in orthopedics** — evidence-based principles

อธิบาย principles + timing + drug choice + duration for different ortho procedures (arthroplasty, fracture, spine, sports surgery)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

**Venous thromboembolism (VTE) pathophysiology + prophylaxis** ใน orthopedics

อธิบาย VTE pathophysiology + Virchow''s triad + risk factors + prophylaxis choices + duration after ortho surgery', '[{"label":"A","text":"Aspirin is not effective for VTE prophylaxis"},{"label":"B","text":"VTE Pathophysiology + Prophylaxis in Orthopedics"},{"label":"C","text":"Mechanical prophylaxis is not useful"},{"label":"D","text":"Duration of prophylaxis is 1 week for THA"},{"label":"E","text":"TXA increases VTE risk significantly"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** VTE Pathophysiology + Prophylaxis in Orthopedics: (1) **Virchow''s triad** (1856) — 3 factors predisposing to thrombosis: (a) **venous stasis** (immobilization, surgery, paralysis, prolonged travel); (b) **endothelial injury** (surgery, trauma, central lines, fractures); (c) **hypercoagulability** (cancer, OCP/HRT, pregnancy, inherited thrombophilias — Factor V Leiden, protein C/S deficiency, antithrombin III deficiency, antiphospholipid syndrome, MTHFR, prothrombin gene mutation); (2) **orthopedic patients HIGH RISK** — combination: prolonged operative time + immobilization + endothelial injury + inflammatory response; (3) **highest VTE risk surgeries** without prophylaxis: total hip arthroplasty (40-60% DVT, 1-2% fatal PE), total knee arthroplasty (40-80% DVT — even higher than THA), hip fracture surgery (50% DVT); (4) **risk stratification** — Caprini score for individual risk; major surgery duration > 45 min, age > 60, cancer, prior VTE, obesity, immobility, OCP, pregnancy add risk; (5) **prophylaxis options** (AAOS + ACCP guidelines): (a) **mechanical** — sequential compression devices (SCDs), foot pumps, graduated compression stockings; early mobilization; useful as adjunct or alone if bleeding risk high; (b) **chemical**: (i) **aspirin** (81 mg or 325 mg BID) — AAOS-endorsed option for elective hip + knee arthroplasty in healthy patients without prior VTE (PEPPER trial, Lancet 2019 — multiple RCTs support); equivalent to anticoagulants with lower bleeding; (ii) **LMWH (enoxaparin 40 mg daily, dalteparin)** — gold standard, broad use, monitor renal; (iii) **fondaparinux** — synthetic Xa inhibitor; (iv) **DOACs (rivaroxaban, apixaban, edoxaban)** — oral, no monitoring, equivalent efficacy; (v) **warfarin** — historic, requires INR monitoring (2-3); (vi) **UFH** — limited role due to inferior efficacy; (6) **duration**: (a) **elective THA** — 28-35 days; (b) **elective TKA** — 10-14 days; (c) **hip fracture** — 28-35 days; (d) prolonged in higher-risk patients; (7) **special situations**: (a) **spine surgery** — controversial — mechanical prophylaxis preferred initially due to epidural hematoma risk; chemical when bleeding risk reduced; (b) **arthroscopy** — generally not routine, selective; (c) **fracture without surgery (cast immobilization of lower limb)** — selective based on risk; (8) **TXA (tranexamic acid)** — for blood loss reduction, does NOT increase VTE risk (well-studied in arthroplasty); (9) **screening** — pre-op risk assessment; **DO NOT routine pre-op duplex** scan; (10) **diagnosis VTE**: D-dimer (sensitive, not specific), duplex US (DVT diagnostic), CTA chest (PE), V/Q scan (alternative if contrast contraindicated); (11) **treatment**: therapeutic anticoagulation (LMWH, DOAC, warfarin) for 3+ months; IVC filter for contraindication to anticoagulation; thrombolysis for massive PE

---

VTE in ortho: high risk (THA, TKA, hip fracture). Virchow''s triad: stasis + endothelial injury + hypercoagulability. Prophylaxis: mechanical (SCD) + chemical (aspirin AAOS-endorsed for low-risk arthroplasty per PEPPER + multiple RCTs, LMWH gold standard, DOACs, fondaparinux, warfarin). Duration: 28-35d THA, 10-14d TKA, 28-35d hip fracture. Spine: mechanical first (epidural hematoma risk). TXA reduces blood loss without ↑ VTE. Modern: shared decision risk-stratified.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'basic_science', 'msk_nontrauma', 'adult',
  'AAOS; ACCP; PEPPER Trial', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

**Venous thromboembolism (VTE) pathophysiology + prophylaxis** ใน orthopedics

อธิบาย VTE pathophysiology + Virchow''s triad + risk factors + prophylaxis choices + duration after ortho surgery'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

**Bone graft + substitutes** — types + properties + indications

อธิบาย autograft vs allograft + properties (osteoconductive, osteoinductive, osteogenic) + bone substitutes (DBM, ceramics, BMP) + clinical applications', '[{"label":"A","text":"Allograft has osteogenic cells"},{"label":"B","text":"Bone Graft + Substitutes"},{"label":"C","text":"Autograft has no osteogenic property"},{"label":"D","text":"BMP-2 has no clinical applications"},{"label":"E","text":"Demineralized bone matrix has no osteoinductive properties"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bone Graft + Substitutes: (1) **3 essential properties** of bone graft material: (a) **osteoconductive** — provides scaffold for new bone growth (cells from host migrate into graft); ceramics, allograft, autograft; (b) **osteoinductive** — induces stem cells to differentiate into osteoblasts; growth factors (BMP) primarily; autograft has it; allograft minimal (after processing); demineralized bone matrix (DBM); (c) **osteogenic** — contains live cells (osteoblasts, mesenchymal stem cells) that directly form bone; **only autograft** has this; allograft + synthetics have NONE; (2) **autograft** — gold standard — has ALL 3 properties: (a) **cancellous autograft** (iliac crest most common, also distal radius, proximal tibia) — highly osteoconductive + osteoinductive + osteogenic; rapid incorporation; used for fracture non-union, fusion (spine, arthrodesis), filling defects, ankle arthrodesis; (b) **cortical autograft** (fibula, iliac crest) — structural support; slower incorporation; used for segmental bone loss, anterior cervical fusion; (c) **vascularized autograft (free vascularized fibula)** — maintains osteogenic cells via vascular pedicle; for large segmental defects, AVN femoral head, congenital pseudarthrosis tibia, post-tumor resection; (d) **disadvantages** — donor site morbidity (pain, infection, hematoma, fracture, nerve injury — LFCN at ASIS, sciatic notch, meralgia paresthetica), limited quantity, prolonged operative time; (3) **allograft** — cadaveric: osteoconductive + minimal osteoinductive (after processing) + NO osteogenic; (a) **fresh frozen** — preserves more growth factors but disease transmission risk; (b) **freeze-dried** — sterile, preserves osteoconductive but less osteoinductive; (c) **irradiated** — sterile but reduces mechanical strength; (d) **demineralized bone matrix (DBM)** — processed allograft with calcium removed → exposes BMPs → enhanced osteoinductive; available as putty, gel, strips; (e) advantages — no donor morbidity, available, larger quantity, structural pieces; (f) disadvantages — slower incorporation, immune response, disease transmission risk (low — 1:1.6 million HIV, hepatitis), expense; (4) **bone substitutes / synthetic**: (a) **calcium sulfate (CaSO4)** — osteoconductive, resorbs rapidly (6-12 weeks), used in non-load-bearing applications + as antibiotic carrier; (b) **calcium phosphate** (hydroxyapatite, tricalcium phosphate, biphasic) — osteoconductive, slower resorption + bone-like; (c) **bioactive glass** — osteoconductive + may release ions promoting bone; (d) **coralline hydroxyapatite** — natural coral-derived; (5) **growth factors / biologics**: (a) **rhBMP-2 (recombinant human bone morphogenetic protein-2 — InFuse)** — FDA-approved for tibial nonunion, ALIF (anterior lumbar interbody fusion), and selected other; potent osteoinductive; concerns — heterotopic ossification, swelling, controversial cancer risk in cervical use; (b) **rhBMP-7 (OP-1)** — withdrawn from US market; (c) **PRP (platelet-rich plasma)** — adjunct, debated efficacy; (d) **bone marrow aspirate concentrate (BMAC)** — concentrated mesenchymal stem cells + growth factors, used in osteonecrosis, non-union; (e) **stem cell therapies** investigational; (6) **clinical applications**: spine fusion (autograft + BMP), non-union (autograft + BMAC), fracture (cancellous autograft), filling defects after tumor resection (allograft, synthetic), distraction osteogenesis (Ilizarov)

---

Bone graft properties: osteoconductive (scaffold), osteoinductive (BMP — stimulates), osteogenic (live cells). Autograft = ALL 3 (gold standard but donor morbidity). Allograft = osteoconductive + minimal osteoinductive. DBM = enhanced osteoinductive (BMPs exposed). Synthetic (CaSO4, CaP, bioactive glass) = osteoconductive only. rhBMP-2 = potent osteoinductive. Vascularized fibula for large defects + AVN. PRP + BMAC adjuncts. Each graft chosen by need.', NULL,
  'medium', 'procedures', 'review',
  'orthopedics', 'basic_science', 'procedures', 'adult',
  'AAOS Bone Graft', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

**Bone graft + substitutes** — types + properties + indications

อธิบาย autograft vs allograft + properties (osteoconductive, osteoinductive, osteogenic) + bone substitutes (DBM, ceramics, BMP) + clinical applications'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**EMS/Management**

ผู้บาดเจ็บ multi-trauma มาจากรถมอเตอร์ไซค์ชนรถยนต์ ห้องฉุกเฉิน trauma center อายุ 35 ปี

GCS 13, BP 92/56, HR 124, RR 28, SpO2 91% on RA, obvious deformity right thigh + chest pain + abdominal tenderness, no obvious external bleeding

จงอธิบาย ATLS primary survey approach + ortho''s role', '[{"label":"A","text":"Head CT before airway management always"},{"label":"B","text":"ATLS Primary Survey in Multi-Trauma — ABCDE"},{"label":"C","text":"Wait for definitive vascular surgeon before pelvic binder"},{"label":"D","text":"High volume crystalloid 5L bolus standard"},{"label":"E","text":"Splinting deformed limbs is the priority before airway"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ATLS Primary Survey in Multi-Trauma — ABCDE: (1) **A — Airway** with cervical spine protection: assess patency (look, listen, feel), patient talking = airway intact; intervene — chin lift/jaw thrust (no head tilt with C-spine concern), oral/nasal airway, **intubate** if GCS ≤ 8 or unable to protect; **cervical collar + spine board** initially (remove board < 2 hours pressure ulcer risk); definitive airway = cuffed tube in trachea; surgical airway (cricothyroidotomy) if cannot intubate cannot ventilate; (2) **B — Breathing**: expose chest, look + feel + auscultate; identify life-threatening: **tension pneumothorax** (decompression with needle 2nd ICS midclavicular or 5th ICS midaxillary → chest tube), **open pneumothorax** (3-sided dressing → chest tube), **massive hemothorax** (chest tube + autotransfusion + thoracotomy if > 1500 mL initial or 200 mL/h × 3 hr), **flail chest with pulmonary contusion** (analgesia, oxygen, mechanical ventilation), **cardiac tamponade** (pericardiocentesis or surgical); 100% O2 + monitor SpO2 + ETCO2; (3) **C — Circulation** with hemorrhage control: 5 sources of hemorrhage — "blood on the floor + 4 more" (external + chest + abdomen + retroperitoneum/pelvis + long bone fractures); (a) external hemorrhage — direct pressure, tourniquet (extremity, junctional), wound packing + topical hemostatics (Combat Gauze, QuikClot); (b) **2 large bore IV lines** (16-18g) + crystalloid bolus 1L (caution — large volume worsens coagulopathy + dilutes); modern — early balanced transfusion 1:1:1 PRBC:FFP:platelets; (c) **massive transfusion protocol (MTP)** — for shock class III-IV; (d) TXA within 3 hours (CRASH-2); (e) **pelvic binder** for suspected pelvic injury (hypotension, deformity); (f) **damage control resuscitation** — permissive hypotension (SBP 80-90, MAP 65) until surgical control + euvolemia + reverse coagulopathy + correct acidosis + warm; (g) lab — type + cross, CBC, BMP, lactate, ABG, coags, fibrinogen, TEG/ROTEM if available, urine pregnancy; (4) **D — Disability**: neurologic — GCS, pupils, gross motor + sensation, glucose; spine immobilization; head CT if GCS ≤ 13 or focal deficit; (5) **E — Exposure / Environment**: completely undress + log roll to inspect back; **warm** patient to prevent hypothermia (warming blankets, warmed fluids, blood warmer) — **lethal triad** = hypothermia + acidosis + coagulopathy; (6) **adjuncts** — monitor (cardiac, BP, SpO2), Foley (if no urethral injury — RUG first if blood at meatus or pelvic injury), NG/OG tube, CXR + pelvic X-ray + FAST → CT scan if stable; (7) **secondary survey** after stabilization — head-to-toe exam, AMPLE history; (8) **orthopedic role in primary survey**: (a) **pelvic binder** for hemodynamic instability; (b) **gross long-bone alignment + splinting** (traction splint for femoral shaft — reduces blood loss + pain); (c) **open fracture management** — antibiotic + tetanus + irrigate + cover; (d) **damage control orthopedics** for unstable polytrauma — external fixator for stabilization, definitive later when stable; (e) early identification + reduction of dislocations (hip, knee — vascular emergency)

---

ATLS Primary Survey ABCDE: Airway + C-spine (intubate GCS ≤ 8), Breathing (treat tension PTX/open PTX/hemothorax/tamponade), Circulation ("floor + 4" — control hemorrhage, MTP 1:1:1, TXA, pelvic binder, permissive hypotension), Disability (GCS), Exposure (warm — avoid lethal triad: hypothermia + acidosis + coagulopathy). Adjuncts: monitor + Foley + NG + CXR + pelvic + FAST → CT. Ortho role: pelvic binder, splint long bones, damage control orthopedics.', NULL,
  'easy', 'trauma', 'review',
  'orthopedics', 'ems_mgmt', 'trauma', 'adult',
  'ATLS 10th Edition', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**EMS/Management**

ผู้บาดเจ็บ multi-trauma มาจากรถมอเตอร์ไซค์ชนรถยนต์ ห้องฉุกเฉิน trauma center อายุ 35 ปี

GCS 13, BP 92/56, HR 124, RR 28, SpO2 91% on RA, obvious deformity right thigh + chest pain + abdominal tenderness, no obvious external bleeding

จงอธิบาย ATLS primary survey approach + ortho''s role'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**EMS/Management**

ชายไทย 28 ปี crush injury ขาขวา open wound 8 cm with bone exposed + active arterial bleeding ส่งจาก field มา ED 1 ชั่วโมงหลัง injury

VS: BP 105/68, HR 115, alert

จงอธิบาย initial management ของ open fracture ใน ED + Pre-hospital', '[{"label":"A","text":"Antibiotics can wait 24 hours after presentation"},{"label":"B","text":"Open Fracture Initial Management Pre-hospital + ED"},{"label":"C","text":"High-pressure irrigation with betadine is preferred"},{"label":"D","text":"Push exposed bone back into the wound"},{"label":"E","text":"Tetanus not needed for any open fracture"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Open Fracture Initial Management Pre-hospital + ED: (1) **pre-hospital**: (a) ABCs first; (b) **control bleeding** — direct pressure first; **tourniquet** for uncontrolled extremity hemorrhage (CAT, SOFTT-W — high above wound, tight enough to stop bleeding, mark time, do not loosen periodically); (c) cover wound with **sterile/clean moist saline dressing** (do not push bone back into wound — culture-document position seen); (d) **splint** in position found; (e) NV check distal; (f) rapid transport to trauma center; (g) NPO if possible; (h) IV access; (2) **ED initial management**: (a) **ATLS primary survey** — open fracture is NOT priority over ABC; (b) **immediate IV access + resuscitation**; (c) **immediate IV antibiotic within 1 hour of presentation** (single most important factor reducing infection risk per multiple studies); choice based on **Gustilo classification**: (i) **Gustilo I** (wound < 1 cm, low energy, minimal contamination) — **cefazolin 2 g IV** × 24 hr; (ii) **Gustilo II** (wound 1-10 cm, moderate, no extensive soft tissue) — cefazolin; (iii) **Gustilo III** — cefazolin + aminoglycoside (gentamicin) for 48-72 hours, or piperacillin-tazobactam alternative; (iv) **farm/anaerobic contamination** — add penicillin or metronidazole for Clostridium; (3) **tetanus prophylaxis**: (a) **Td or Tdap** if > 5 years since last dose with dirty wound; (b) **TIG (tetanus immune globulin)** for unknown/incomplete immunization + dirty wound; (c) check status; (4) **rigorous wound assessment**: (a) inspect — extent, contamination, neurovascular status, soft tissue coverage; (b) photograph if possible; (c) sterile saline-soaked dressing — DO NOT pour Betadine/hydrogen peroxide into wound (tissue toxicity); (d) splint anatomically; (e) prophylactic compartment syndrome monitoring; (5) **definitive surgical management**: (a) **surgical debridement + irrigation in OR**: timing — historically "6-hour rule" relaxed — recent evidence (multiple meta-analyses) shows **within 24 hours acceptable if antibiotic started early** (modern AAOS/AO guidance); (b) **aggressive debridement** of all devitalized tissue + foreign material in OR; (c) **copious low-pressure saline irrigation** (3-9 L depending on Gustilo type) — high-pressure damages tissue per FLOW trial NEJM 2015 (saline = soap for outcomes); (d) **fracture stabilization** appropriate to grade + location — IM nail for closed-equivalent IIIA tibia/femur, external fixator for damage control; (e) **wound management** — primary closure for IIIA selected clean (no longer dogma to leave open); VAC + delayed closure for contaminated; soft tissue flap (rotational, free) for IIIB requiring coverage; (f) **repeat debridement q 48-72h** until clean before closure; (6) **screening other injuries** (compartment syndrome, NV injury, associated injuries); (7) **complications/outcomes**: infection — modern rates I: 0-2%, II: 2-7%, IIIA: 7-10%, IIIB: 10-50%, IIIC: > 25%; nonunion; chronic osteomyelitis; amputation; (8) **multidisciplinary**: ortho + plastic + vascular + ID + general surgery

---

Open fracture: PRE-HOSPITAL — direct pressure, tourniquet for uncontrolled bleeding, sterile moist dressing, splint, transport. ED: ATLS + **antibiotic within 1 hr** (most important — cefazolin Gustilo I-II; + aminoglycoside Gustilo III; + penicillin/metronidazole for farm contamination), tetanus, splint, NV check. DEFINITIVE: debridement + low-pressure saline irrigation + stabilization in OR within 24h (relaxed from 6h with early abx). VAC + delayed closure for contaminated. Plastic for IIIB coverage.', NULL,
  'easy', 'trauma', 'review',
  'orthopedics', 'ems_mgmt', 'trauma', 'adult',
  'OTA; FLOW Trial NEJM 2015', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**EMS/Management**

ชายไทย 28 ปี crush injury ขาขวา open wound 8 cm with bone exposed + active arterial bleeding ส่งจาก field มา ED 1 ชั่วโมงหลัง injury

VS: BP 105/68, HR 115, alert

จงอธิบาย initial management ของ open fracture ใน ED + Pre-hospital'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**EMS/Management**

Mass casualty incident — รถบัสตกหุบเขา 30 ผู้บาดเจ็บมาห้องฉุกเฉินพร้อมกัน, ทรัพยากร limited

จงอธิบาย mass casualty triage system (START / SALT) + role of orthopedic team', '[{"label":"A","text":"Treat the most severely injured patient regardless of survivability"},{"label":"B","text":"Mass Casualty Triage + Orthopedic Role"},{"label":"C","text":"All patients require immediate definitive surgical care"},{"label":"D","text":"Use full primary + secondary survey for each patient at scene"},{"label":"E","text":"Triage categories are static and never reassessed"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mass Casualty Triage + Orthopedic Role: (1) **mass casualty incident (MCI)** = injured patient number exceeds available resources → need triage to maximize survival → "doing the greatest good for greatest number"; (2) **START (Simple Triage and Rapid Treatment)** — most widely used adult MCI triage system, pre-hospital, 30 seconds per patient assessment: (a) **green/minor (walking wounded)** — "if you can walk, come over here" → low priority; (b) assess remaining (those who can''t walk): (i) **respirations** — if absent + no response to head positioning → **black (deceased/expectant)**; if RR > 30 → **red (immediate)**; (ii) **perfusion** — capillary refill > 2 sec OR no radial pulse → **red (immediate)**; (iii) **mental status** — unable to follow simple commands → **red (immediate)**; otherwise → **yellow (delayed)**; (3) **categories**: (a) **RED (immediate)** — life-threatening injuries with reasonable chance of survival with prompt treatment — priority; (b) **YELLOW (delayed)** — serious but stable, can wait for treatment without significant deterioration; (c) **GREEN (minor/walking wounded)** — non-life-threatening, can wait or self-care; (d) **BLACK (expectant/deceased)** — deceased OR injuries incompatible with survival under current resources; (4) **SALT (Sort, Assess, Lifesaving interventions, Treatment and/or Transport)** — newer evidence-based, recommended by CDC: (a) **sort** — global sort (walk → wave → still), (b) **assess** individuals, (c) **brief lifesaving interventions** allowed: hemorrhage control (tourniquet, direct pressure), open airway (chin lift, recovery position), 2 rescue breaths (children), chest decompression, autoinjectors; (d) categories — immediate, expectant, delayed, minimal, dead; (5) **JumpSTART** — pediatric modification of START; (6) **principles**: (a) **dynamic** — reassess + retriage; (b) **commander designated** — incident commander coordinates; (c) **secondary triage** at receiving facility re-evaluates; (d) **forward triage** to limit hospital overflow; (e) **rule of thirds** — 1/3 immediate, 1/3 delayed, 1/3 minor (varies by event); (7) **orthopedic role in MCI**: (a) **hemorrhage control** — limb tourniquet for catastrophic extremity bleeding (junctional and limb); (b) **rapid extremity assessment** — open fractures, dislocations, hemorrhage, compartment syndrome; (c) **field-grade fracture stabilization** — splinting, traction splint for femoral fractures (reduces blood loss + pain); (d) **damage control orthopedics** — external fixator for unstable pelvic + long bone fractures; (e) **delayed definitive surgery** when resources permit; (f) **organize OR resources** + collaboration with general/vascular/trauma surgery; (g) **family communication, documentation, mass disaster forensic identification**; (8) **disaster preparedness** — hospital + system plans; PPE; communication systems; mock drills; mental health support for responders; (9) **ethics** — utilitarian + transparent + consistent; psychological + moral distress on responders

---

MCI triage: START (Simple Triage Rapid Treatment) — 30s per patient. (1) walking wounded = GREEN; (2) RR > 30 OR cap refill > 2s/no radial pulse OR can''t follow commands = RED (immediate); else YELLOW (delayed); apneic post-positioning = BLACK. SALT = newer (sort, assess, lifesaving, treatment/transport). Categories: red/yellow/green/black. JumpSTART pediatric. Ortho role: tourniquet, splint, damage control ex-fix, organize OR resources. Disaster preparedness essential.', NULL,
  'medium', 'trauma', 'review',
  'orthopedics', 'ems_mgmt', 'trauma', 'adult',
  'START; SALT; CDC', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**EMS/Management**

Mass casualty incident — รถบัสตกหุบเขา 30 ผู้บาดเจ็บมาห้องฉุกเฉินพร้อมกัน, ทรัพยากร limited

จงอธิบาย mass casualty triage system (START / SALT) + role of orthopedic team'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**EMS/Management**

ผู้ป่วยอายุ 22 ปี รถมอเตอร์ไซค์ชน open femur fracture + ankle dislocation + suspected pelvic fracture (lateral compression) + suspected cervical spine injury — pre-hospital paramedic ใน ambulance

จงอธิบาย splinting + immobilization + transport principles', '[{"label":"A","text":"Remove all impaled objects in the field"},{"label":"B","text":"Pre-hospital Splinting + Immobilization + Transport"},{"label":"C","text":"Femoral traction splint indicated in all hip dislocations"},{"label":"D","text":"Spine board can be kept indefinitely"},{"label":"E","text":"Splinting is never needed before transport"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pre-hospital Splinting + Immobilization + Transport: (1) **principles**: (a) immobilize fractures + dislocations in **position found** generally; (b) splint **above + below** joint of injury (long bone fracture immobilizes joint above + below); (c) **assess + document NV status before + after splinting** (capillary refill, pulses, sensation, motor); (d) **gentle realignment of grossly deformed limbs** with diminished perfusion to relieve neurovascular compromise — gentle longitudinal traction (DO NOT force); for clearly malaligned with neurovascular compromise, gentle realignment in line; (e) cover open wounds + control hemorrhage before splinting; (f) **expedient transport** — "scoop + run" for unstable polytrauma; (2) **specific orthopedic immobilization**: (a) **suspected cervical spine** — rigid cervical collar + manual stabilization + spine board for transport; remove from board ASAP at hospital (pressure injury risk > 2 hours); maintain in-line position during airway management; (b) **suspected pelvic fracture** (hemodynamic instability, pelvic deformity, perineal/scrotal hematoma, blood at urethral meatus, severe mechanism) — **pelvic binder** (T-POD, commercial) or pelvic sheet at level of greater trochanters → reduces pelvic volume + tamponades venous bleeding (primary source 85%); avoid log rolling repeatedly; (c) **femoral shaft fracture** — **traction splint** (Hare, Sager, Kendrick) — restores length + reduces blood loss + reduces pain; contraindicated if knee/hip dislocation, ankle/foot injury, open fracture with bone protruding; (d) **other long bone fractures** — rigid splint (vacuum, padded board, SAM), pneumatic splint, manufactured splint; immobilize joint above + below; (e) **dislocations** — splint in position found unless NV compromise; spontaneous reduction of patella, shoulder may occur — document; **hip dislocations** are emergencies (AVN risk) — early transport; (f) **suspected spine injury below cervical** — full spine board + log roll; modern evidence — selective spinal immobilization (NEXUS criteria, Canadian C-spine rule) reduces unnecessary use in many EMS systems; (3) **open fracture in field**: (a) **control hemorrhage** — direct pressure → tourniquet if uncontrolled; (b) **cover with sterile moist gauze** — do not push bone back; (c) splint anatomically; (d) NV check; (e) document; (4) **mangled extremity** with vascular compromise: tourniquet + rapid transport + early arrival communication; (5) **special situations**: (a) **impaled object** — DO NOT remove (may be tamponading bleeding) — stabilize in place; (b) **amputated part** — wrap in saline-moistened gauze → plastic bag → on ice (NOT direct contact with ice); transport with patient; (c) **degloving injury** — preserve flap; (6) **pain management** in field — IV opioids, ketamine, IN fentanyl; (7) **documentation** — mechanism, time, NV status, interventions, response; (8) **communication** with receiving hospital — early notification + activation of trauma team

---

Pre-hospital splinting: position found generally + above/below joint + NV check before/after. Gentle realignment if NV compromise. C-spine: collar + spine board (remove < 2h at hospital). Pelvic suspicion: binder at greater trochanters. Femur: traction splint (Hare/Sager — reduces blood loss + pain). Open fracture: control bleed, sterile moist dressing, no bone push. Amputated part: saline gauze + plastic bag + on ice. Impaled object: stabilize, don''t remove. Rapid transport. Document. Communicate to receiving.', NULL,
  'easy', 'trauma', 'review',
  'orthopedics', 'ems_mgmt', 'trauma', 'adult',
  'AAOS Pre-hospital; NAEMT', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**EMS/Management**

ผู้ป่วยอายุ 22 ปี รถมอเตอร์ไซค์ชน open femur fracture + ankle dislocation + suspected pelvic fracture (lateral compression) + suspected cervical spine injury — pre-hospital paramedic ใน ambulance

จงอธิบาย splinting + immobilization + transport principles'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**EMS/Management**

ผู้ป่วย minor trauma ในห้องฉุกเฉิน — รถยนต์ชนความเร็วต่ำ ไม่มี LOC, no neurologic symptoms, alert + oriented, GCS 15, can walk, mild neck pain ตอนนี้ใส่ cervical collar ตั้งแต่ pre-hospital

จงอธิบาย NEXUS + Canadian C-Spine Rule + indications สำหรับ imaging + clinical clearance', '[{"label":"A","text":"All patients must have C-spine imaging regardless of exam"},{"label":"B","text":"Cervical Spine Clearance — NEXUS + Canadian C-Spine Rule"},{"label":"C","text":"Plain X-ray is more sensitive than CT"},{"label":"D","text":"Distracting injury allows clinical clearance"},{"label":"E","text":"Spine board can stay indefinitely"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cervical Spine Clearance — NEXUS + Canadian C-Spine Rule: (1) **purpose** — efficient decision tool to identify patients requiring cervical spine imaging vs safe clinical clearance, avoiding unnecessary imaging while not missing significant injury; (2) **NEXUS Low-Risk Criteria** (5 criteria) — patient is cervical spine cleared **WITHOUT imaging** if ALL: (a) no posterior midline cervical spine tenderness; (b) no evidence of intoxication; (c) normal level of alertness (GCS 15, no AMS); (d) no focal neurologic deficit; (e) no painful distracting injury (e.g., long bone fracture, severe burn) — if any criterion fails → imaging indicated; **sensitivity ~ 99%** for cervical spine injury; (3) **Canadian C-Spine Rule (CCR)** — more specific algorithm, may be more sensitive (some studies): (a) **high-risk factors mandating imaging** — age ≥ 65, dangerous mechanism (fall ≥ 3 ft/5 stairs, axial load to head e.g., diving, MVC > 100 km/h, rollover, ejection, motorized recreational vehicle, bicycle vs car), paresthesias in extremities → if any → IMAGING; (b) **low-risk factors allowing safe assessment of ROM** — simple rear-end MVC, sitting in ED, ambulatory at any time, delayed onset neck pain, absence of midline tenderness → if none → cannot assess ROM; (c) **ROM testing** — if able to actively rotate neck 45° L + R → no imaging; if not → imaging; (4) **patient selection** for application: (a) NEXUS — all stable trauma patients; (b) CCR — alert (GCS 15), stable, with neck pain + tenderness OR with dangerous mechanism / new paresthesias / age > 65; CCR not for: GCS < 15, unstable vitals, age < 16, acute paralysis, known spine disease, return for same injury; (5) **imaging choice**: (a) **CT cervical spine** — best modality, sensitivity > 98%, in adults with risk factors or unable to be clinically cleared; replaced plain X-ray for trauma evaluation in most centers; (b) **MRI** — for: suspected ligamentous injury (clinical concern with normal CT), neurologic deficit, suspected cord injury, unconscious patient who cannot be examined (still debated); (c) **plain X-ray** (3 views: AP, lateral, odontoid) — limited modern use; selective in low-risk pediatric or low-resource settings; (6) **collar removal protocol**: (a) **clinical clearance** (NEXUS/CCR positive) without imaging — for low-risk awake reliable patient; remove collar; (b) **after CT cervical** with no acute injury found in awake reliable patient → remove collar; (c) **obtunded patient with normal CT** — controversial: most centers remove collar with normal high-quality CT (multiple meta-analyses support — CCSG meta-analysis), some still add MRI; (d) **persistent neck pain + tenderness despite normal CT** — consider MRI for occult ligamentous injury, or maintain immobilization + repeat exam later; (7) **special populations**: pediatrics (CCR not validated < 16, PECARN cervical rule emerging), elderly (high risk for occult fracture — low threshold for imaging), AS/DISH (high suspicion even with minor trauma — MRI), ankylosing conditions; (8) avoid prolonged spine board use (pressure ulcer)

---

C-spine clearance: NEXUS — clinically clear if ALL: no midline tenderness, no intoxication, alert, no focal neuro, no distracting injury. CCR — high-risk (age ≥ 65, dangerous mechanism, paresthesias) → imaging; low-risk + able to rotate 45° L/R → no imaging. CT modality of choice (replaced X-ray). MRI for ligamentous, neuro, obtunded persistent concern. Elderly + AS/DISH = HIGH risk even minor trauma → MRI. Remove collar after clearance (pressure ulcer).', NULL,
  'medium', 'trauma', 'review',
  'orthopedics', 'ems_mgmt', 'trauma', 'adult',
  'NEXUS; Canadian C-Spine Rule', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**EMS/Management**

ผู้ป่วย minor trauma ในห้องฉุกเฉิน — รถยนต์ชนความเร็วต่ำ ไม่มี LOC, no neurologic symptoms, alert + oriented, GCS 15, can walk, mild neck pain ตอนนี้ใส่ cervical collar ตั้งแต่ pre-hospital

จงอธิบาย NEXUS + Canadian C-Spine Rule + indications สำหรับ imaging + clinical clearance'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**EMS/Management**

ผู้ป่วย polytrauma อายุ 28 ปี รถยนต์ชน multiple injuries: closed femoral shaft + open tibial + unstable pelvic fracture + chest contusion + ARDS + coagulopathy in ICU

จงอธิบาย concept of damage control orthopedics (DCO) vs early total care (ETC) + decision making', '[{"label":"A","text":"Always do definitive fixation within 6 hours regardless of physiology"},{"label":"B","text":"Damage Control Orthopedics (DCO) vs Early Total Care (ETC)"},{"label":"C","text":"Damage control means no surgery ever"},{"label":"D","text":"External fixator is permanent fixation"},{"label":"E","text":"DCO worsens outcomes in unstable polytrauma"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Damage Control Orthopedics (DCO) vs Early Total Care (ETC): (1) **historical context**: (a) **early total care (ETC)** — historical paradigm — fix all fractures definitively within 24-48 hours after polytrauma; rationale — early stabilization improves outcomes (reduces ARDS, fat embolism, MOF, mortality); supported by Bone JBJS 1989 + subsequent studies; (b) **damage control orthopedics (DCO)** — paradigm shift for severely injured polytrauma patients — temporary stabilization with **external fixator** initially → delayed definitive fixation when patient stable; introduced by Scalea + Pape in late 1990s/2000s; (2) **rationale for DCO**: (a) prolonged complex surgery in physiologically compromised patient → "**second hit**" of inflammatory cascade → worsens lung injury, ARDS, MOF; (b) **lethal triad** (hypothermia + acidosis + coagulopathy) in polytrauma — major surgery worsens; (c) prevents this second hit while still providing fracture stabilization for resuscitation; (3) **classification of polytrauma severity** for DCO decision: (a) **stable** — adequate resuscitation, normal hemodynamics, no major organ dysfunction → **ETC** (definitive treatment); (b) **borderline** — initially responsive resuscitation but at risk for deterioration → individualized; (c) **unstable** — persistent hemodynamic instability, ongoing resuscitation → **DCO**; (d) **in extremis** — peri-arrest, severe physiologic derangement → **DCO + life-saving only**; (4) **markers favoring DCO**: (a) shock — persistent hypotension, vasopressor requirement, base deficit > 6, lactate > 4; (b) coagulopathy (INR > 1.5, fibrinogen < 200), thrombocytopenia; (c) hypothermia (< 35°C); (d) ARDS, pulmonary contusion, high FiO2 requirement; (e) high ISS > 25, NISS > 40; (f) elevated IL-6 (inflammatory marker — research); (g) severe head injury; (5) **DCO technique**: (a) **external fixator** for femur, tibia, pelvis fractures — quick (< 1 hour), provides skeletal stabilization, allows nursing/mobilization, reduces blood loss + pain; (b) **wound debridement + temporary coverage** for open fractures; (c) **definitive fixation when stable** — typically 5-14 days when physiologic recovery + reversal of acidosis + coagulopathy + cleared lung injury; (d) **conversion ex-fix to IM nail** for femur/tibia — relatively safe within 2-3 weeks (longer increases pin tract infection risk); (6) **pelvic fracture DCO** — pelvic binder + external fixator + preperitoneal packing ± angioembolization for hemorrhage control; definitive ORIF when stable; (7) **modern nuanced view** — "early appropriate care (EAC)" — neither all DCO nor all ETC: definitive fixation if patient is physiologically responsive within 36 hours (Vallier OTA), DCO if persistent instability; individualized; (8) **outcomes**: DCO has reduced mortality + complications in unstable polytrauma vs ETC (multiple studies)

---

Damage Control Orthopedics (DCO) vs Early Total Care (ETC): ETC = definitive fixation < 24-48h (reduces ARDS, fat embolism — appropriate for STABLE polytrauma). DCO = ex-fix + temporary stabilization → delayed definitive — for UNSTABLE polytrauma (avoids "second hit"). Use DCO if: shock/coagulopathy/hypothermia/ARDS/severe head injury/in extremis. Conversion ex-fix → IM nail within 2-3 weeks. Modern: Early Appropriate Care (EAC) — individualized based on physiology.', NULL,
  'medium', 'trauma', 'review',
  'orthopedics', 'ems_mgmt', 'trauma', 'adult',
  'Pape Scalea DCO; Vallier EAC', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**EMS/Management**

ผู้ป่วย polytrauma อายุ 28 ปี รถยนต์ชน multiple injuries: closed femoral shaft + open tibial + unstable pelvic fracture + chest contusion + ARDS + coagulopathy in ICU

จงอธิบาย concept of damage control orthopedics (DCO) vs early total care (ETC) + decision making'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**EMS/Management**

ผู้ป่วย polytrauma มาห้องฉุกเฉิน BP 80/40, HR 140, รถยนต์ชนหนัก ออกเลือดเยอะ — open pelvis + bilateral femur + abdomen tenderness

Lab: Hb 6.0 (ดรอป), platelet 110, INR 1.8, fibrinogen 120, lactate 7.0, base excess -10

จงอธิบาย massive transfusion protocol (MTP) + balanced resuscitation', '[{"label":"A","text":"Crystalloid 5 L bolus best initial resuscitation"},{"label":"B","text":"Massive Transfusion Protocol (MTP) in Trauma"},{"label":"C","text":"Wait for lab results before starting blood products"},{"label":"D","text":"TXA contraindicated in trauma"},{"label":"E","text":"Permissive hypotension safe in head injury"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Massive Transfusion Protocol (MTP) in Trauma: (1) **definition** — variable: (a) **10+ units PRBC in 24 hours**; (b) **3+ units PRBC in 1 hour** with ongoing bleeding; (c) anticipated massive transfusion based on **shock index (HR/SBP) > 1.0** or ABC score ≥ 2 (penetrating mechanism, SBP < 90, HR > 120, FAST positive); (d) modern definitions are time-based and dynamic; (2) **trauma-induced coagulopathy (TIC)** — develops early in severe trauma: (a) tissue damage + shock → endothelial dysfunction; (b) consumption of clotting factors; (c) dilution from resuscitation; (d) acidosis + hypothermia worsen clotting; (e) "lethal triad" — hypothermia + acidosis + coagulopathy; (f) hyperfibrinolysis (especially head injury, prolonged shock) — TXA addresses; (g) modern fluid-restrictive resuscitation aims to prevent dilutional coagulopathy; (3) **balanced transfusion (1:1:1)**: (a) PROPPR trial JAMA 2015 — 1:1:1 ratio PRBC:FFP:platelets equivalent to 1:1:2 for survival but with hemostatic advantages; (b) start MTP immediately when bleeding patient activates protocol — DO NOT wait for labs; (c) typical "pack" — 6 PRBC + 6 FFP + 1 unit platelets (apheresis = 6-pack equivalent); (4) **TXA (tranexamic acid)** — antifibrinolytic — give within 3 hours of trauma per CRASH-2 + WOMAN trials; **1 g IV bolus over 10 min → 1 g IV infusion over 8 hours**; reduces mortality; (5) **adjuncts**: (a) **cryoprecipitate** if fibrinogen < 150-200 mg/dL — "the most clottable protein"; (b) **calcium** — replacement (citrate in blood products chelates calcium → hypocalcemia); ionized Ca > 1.0 mmol/L; (c) **prothrombin complex concentrate (PCC)** for warfarin reversal or refractory bleeding; (d) **recombinant factor VIIa** — limited use, expensive, thrombotic risk; (e) **vitamin K** for warfarin reversal; (f) **DDAVP** for uremic platelets or vWD; (6) **viscoelastic testing — TEG (thromboelastography) or ROTEM** — modern goal-directed approach: (a) **R time prolonged** → FFP/PCC; (b) **K time prolonged** → cryoprecipitate (fibrinogen); (c) **MA decreased** → platelets; (d) **LY30 elevated** → TXA (hyperfibrinolysis); (7) **permissive hypotension** — accept SBP 80-90 (MAP 65) until surgical control + euvolemia in non-CNS injured patients; avoids dilution + dislodging clots; **NOT for traumatic brain injury** (need MAP > 80 for cerebral perfusion); (8) **damage control resuscitation (DCR)** — combines: balanced transfusion + permissive hypotension + early hemorrhage control + reverse coagulopathy + correct acidosis + warm; (9) **REBOA** (resuscitative endovascular balloon occlusion of aorta) — zone I (above celiac) for non-compressible torso hemorrhage; zone III (between renal + bifurcation) for pelvic hemorrhage; bridge to definitive control; complications + selection critical; (10) **temperature management** — warm fluids + blood, warming blankets, room warm; (11) **multidisciplinary team** — trauma surgery, anesthesia, transfusion medicine, blood bank

---

MTP: activate if 10+ U PRBC in 24h or 3+ in 1h with bleeding, or shock index > 1/ABC score ≥ 2. Balanced 1:1:1 PRBC:FFP:platelets (PROPPR). TXA within 3h (1g IV bolus + 1g over 8h — CRASH-2). Cryoprecipitate for fibrinogen < 150-200. Calcium replacement. TEG/ROTEM goal-directed. Permissive hypotension (SBP 80-90, NOT in TBI). Damage control resuscitation. REBOA selective. Address lethal triad (hypothermia + acidosis + coagulopathy).', NULL,
  'medium', 'trauma', 'review',
  'orthopedics', 'ems_mgmt', 'trauma', 'adult',
  'PROPPR JAMA 2015; CRASH-2', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**EMS/Management**

ผู้ป่วย polytrauma มาห้องฉุกเฉิน BP 80/40, HR 140, รถยนต์ชนหนัก ออกเลือดเยอะ — open pelvis + bilateral femur + abdomen tenderness

Lab: Hb 6.0 (ดรอป), platelet 110, INR 1.8, fibrinogen 120, lactate 7.0, base excess -10

จงอธิบาย massive transfusion protocol (MTP) + balanced resuscitation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**EMS/Management**

เด็กชายอายุ 6 ปี ตกจักรยานชน head + abdomen + femur fracture — มาห้องฉุกเฉิน

VS: BP 105/60, HR 145, RR 30, GCS 12

จงอธิบาย key differences in pediatric trauma management (anatomy, physiology, dose-based) + special considerations', '[{"label":"A","text":"Pediatric vital signs are same as adult"},{"label":"B","text":"Pediatric Trauma — Key Differences from Adult"},{"label":"C","text":"Hypotension is the first sign of shock in children"},{"label":"D","text":"Salter-Harris classification does not exist in pediatrics"},{"label":"E","text":"Children rarely have non-accidental trauma"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Trauma — Key Differences from Adult: (1) **anatomic differences**: (a) **larger head:body ratio** → more head injury; (b) **higher fulcrum cervical spine** (C2-C3 vs C5-C6 in adults) → upper cervical injuries common; (c) **flexible bones + ligaments** — can sustain spinal cord injury without radiographic abnormality (**SCIWORA** — MRI shows abnormalities); (d) **physes (growth plates)** — Salter-Harris fractures, growth disturbance; (e) **softer pliable ribs** → less rib fractures BUT more underlying organ injury without rib fracture protection (pulmonary contusion, cardiac); (f) **larger surface area to mass ratio** → faster heat loss → **hypothermia risk high** — keep warm; (g) **liver/spleen relatively unprotected by ribs** → more abdominal injuries; (h) **smaller airway** — smaller ETT, edema disproportionate effect; (2) **physiologic differences**: (a) **maintain blood pressure** until late (sympathetic surge — compensates by tachycardia + vasoconstriction) → BP normal in significant shock until decompensation; **tachycardia** is most reliable early sign of shock; **bradycardia** + hypotension = pre-arrest; (b) **higher cardiac output per kg** but lower absolute blood volume; (c) **rapid metabolic acidosis** with shock; (d) **immature CNS** → more diffuse injury, axonal injury, longer recovery; (3) **assessment**: (a) GCS — modified pediatric GCS for verbal/preverbal; (b) AVPU scale; (c) **vitals normal ranges age-specific** (HR + RR higher in children); (d) Broselow tape — weight-based estimation + dosing reference (color-coded); (e) family-centered care (parental presence beneficial); (4) **fluid resuscitation**: (a) **20 mL/kg crystalloid bolus** — initial; up to 3 boluses; (b) **PRBC 10-20 mL/kg** if persistent shock; (c) avoid over-resuscitation (risk fluid overload in pediatric); (d) modern — balanced resuscitation principles apply to pediatric; (5) **airway management**: (a) **cuffed ETT now preferred** in modern practice (formerly uncuffed for < 8 yr); (b) **smaller ETT size** (age/4 + 4 — older formula; modern weight-based); (c) **straight (Miller) blade** under 2 years (large floppy epiglottis); (d) succinylcholine — caution (hyperkalemia risk in burn, denervation, muscular dystrophy); (e) **risk of right mainstem intubation** higher (short trachea); (6) **specific orthopedic in pediatrics**: (a) **Salter-Harris classification** for physeal injuries; (b) **higher remodeling potential** → tolerated some malalignment; (c) **closed reduction + cast** for most fractures; (d) **flexible IM nails (ESIN/TEN)** for femur/forearm fractures in older children; (e) **plate fixation** for adolescents; (f) **avoid intramedullary nail** through proximal femoral physis (AVN risk); (g) **supracondylar humerus** common — CRPP; (h) **toddler fracture** — spiral tibia + child protective consideration; (7) **non-accidental trauma (NAT) screening**: (a) history doesn''t match injury; (b) delayed presentation; (c) multiple fractures different ages; (d) **specific patterns** — metaphyseal corner ("bucket handle"), posterior rib, fractures < 12 months, bilateral; (e) **mandatory reporting** to CPS; (f) **skeletal survey** if any suspicion; (8) **psychosocial** — pain assessment age-specific (Wong-Baker, FLACC), parental presence + support, child life specialists, follow-up; (9) **long-term outcomes** — growth disturbance from physeal injury, psychological impact

---

Pediatric trauma differences: large head:body, higher cervical fulcrum (C2-3, SCIWORA), flexible bones (rib fractures less but underlying injury more), physes (Salter-Harris), hypothermia risk, BP normal until late (tachycardia early shock sign — bradycardia + hypotension = pre-arrest). Fluids 20 mL/kg crystalloid + 10-20 mL/kg PRBC. Modern: cuffed ETT preferred. SH classification, remodeling potential, flexible IM nails, closed reduction. NAT screen — pattern recognition + mandatory reporting + skeletal survey. Family-centered care.', NULL,
  'medium', 'trauma', 'review',
  'orthopedics', 'ems_mgmt', 'trauma', 'peds',
  'ATLS Pediatric', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**EMS/Management**

เด็กชายอายุ 6 ปี ตกจักรยานชน head + abdomen + femur fracture — มาห้องฉุกเฉิน

VS: BP 105/60, HR 145, RR 30, GCS 12

จงอธิบาย key differences in pediatric trauma management (anatomy, physiology, dose-based) + special considerations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**EMS/Management**

หญิงไทยอายุ 82 ปี frail, lives alone, underlying HT + AF on warfarin หกล้มในบ้าน ปวด hip 6 ชั่วโมง paramedic นำส่ง ED — ไม่สามารถ weight bear

VS: BP 142/86, HR 92 (AF), warmth normal, no neurologic deficit
X-ray: displaced intertrochanteric hip fracture

จงอธิบาย geriatric hip fracture clinical pathway + ortho-geriatric co-management', '[{"label":"A","text":"Delay surgery 1 week for medical optimization"},{"label":"B","text":"Geriatric Hip Fracture Clinical Pathway + Ortho-Geriatric Co-Management"},{"label":"C","text":"Avoid fascia iliaca block in elderly"},{"label":"D","text":"Use opioid-only pain regimen"},{"label":"E","text":"Hip precautions not needed post-op"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Geriatric Hip Fracture Clinical Pathway + Ortho-Geriatric Co-Management: (1) **importance** — hip fracture in elderly = sentinel event: (a) **1-year mortality 20-30%** (some series higher in frail/comorbid), (b) only ~ 50% return to pre-fracture functional status, (c) high rate of institutionalization, (d) cost burden major; (2) **early ED management**: (a) **rapid assessment + diagnosis** — clinical exam + X-ray (AP pelvis + lateral hip); MRI if X-ray equivocal but high clinical suspicion (occult); (b) **multimodal pain control** — avoid opioid-only (delirium risk); **fascia iliaca compartment block** (ED ultrasound-guided) early — significantly reduces opioid use, pain, delirium; acetaminophen scheduled; (c) IV access + labs (CBC, BMP, coag, T+C, glucose, troponin if CV symptoms, ECG, type and cross 2 units); (d) **rapid medical optimization** — assess + correct: anticoagulation reversal (warfarin → vitamin K 5 mg PO/IV + PCC if INR > 2 or urgent surgery; DOAC — specific reversal or surgery 24-48h after last dose), anemia + transfusion threshold (Hb < 8 — 9 ICU/symptomatic), electrolytes, hydration, blood pressure, oxygenation; (e) **early surgery within 24-48 hours** strongly recommended — multiple meta-analyses + AAOS/NICE/BOA guidelines show reduced mortality + complications (Cochrane); avoid unnecessary delays; (3) **ortho-geriatric co-management model**: (a) joint geriatrician + orthopedic surgeon care; (b) **proven mortality reduction** (Cochrane meta-analysis); (c) elements: rapid medical optimization, delirium prevention/management, nutrition, multidisciplinary discharge planning, mobilization, falls + osteoporosis assessment + treatment, secondary prevention; (4) **surgical management**: (a) **intertrochanteric fracture** — **cephalomedullary nail** (CMN — modern preferred for unstable patterns, reverse oblique, subtrochanteric extension) OR sliding hip screw (DHS — stable patterns OK); (b) **femoral neck displaced (Garden III-IV)** — arthroplasty: hemiarthroplasty (low-demand) or total hip arthroplasty (active independent ambulator) per HEALTH trial NEJM 2019; (c) **femoral neck non-displaced (Garden I-II)** — cannulated screws OR arthroplasty (some advocate due to high reoperation rate with screws); (d) **subtrochanteric** — long cephalomedullary nail; (5) **post-op care**: (a) **immediate mobilization day 0-1** (weight-bear as tolerated typically — modern implant designs allow), (b) **multimodal pain control** + opioid-sparing, (c) **delirium prevention** (CAM screening, avoid Foley, sleep hygiene, reorient, avoid restraints, family presence), (d) DVT prophylaxis, (e) GI ulcer prophylaxis (selective), (f) early nutrition assessment + supplements (protein + caloric); (6) **falls + osteoporosis secondary prevention**: (a) DEXA, (b) calcium + vit D, (c) bisphosphonate or denosumab (NICE guidelines — fracture liaison service ideally), (d) home safety assessment, (e) gait + balance training (PT), (f) review meds → discontinue/modify those increasing fall risk; (7) **discharge planning** — early multidisciplinary; rehabilitation facility, home with services, or extended care; (8) **end-of-life considerations** for frail patients — palliative care consultation; goals of care discussion; non-operative selective (severe medical futility); (9) **quality measures** — time to surgery, multidisciplinary co-management, secondary prevention rates, mortality, length of stay, 30-day readmission

---

Geriatric hip fracture pathway: high mortality (20-30%/yr). Early ED — multimodal pain (fascia iliaca block!), rapid medical optimization, anticoagulation reversal. Surgery within 24-48h (reduces mortality — Cochrane). Ortho-geriatric co-management proven. Intertrochanteric: CMN. Displaced femoral neck: arthroplasty (THA active, hemi low-demand — HEALTH NEJM 2019). Post-op: early mobilization, delirium prevention, DVT prophylaxis. Secondary prevention osteoporosis + falls. Multidisciplinary discharge planning.', NULL,
  'easy', 'trauma', 'review',
  'orthopedics', 'ems_mgmt', 'trauma', 'adult',
  'AAOS Hip Fracture CPG; NICE; BOA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**EMS/Management**

หญิงไทยอายุ 82 ปี frail, lives alone, underlying HT + AF on warfarin หกล้มในบ้าน ปวด hip 6 ชั่วโมง paramedic นำส่ง ED — ไม่สามารถ weight bear

VS: BP 142/86, HR 92 (AF), warmth normal, no neurologic deficit
X-ray: displaced intertrochanteric hip fracture

จงอธิบาย geriatric hip fracture clinical pathway + ortho-geriatric co-management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**EMS/Management**

เด็กชายอายุ 6 ปี ตกจักรยานบนสนามเด็กเล่น ปวดข้อศอกขวา + บวม + ผิดรูป + เริ่มชาปลายมือ paramedic ตรวจ field

VS: BP 100/65, HR 110, alert
PE: gross deformity elbow, decreased radial pulse, capillary refill 4 s, paresthesia distal, no open wound

จงอธิบาย field management + transport + ED management of suspected supracondylar humerus fracture', '[{"label":"A","text":"Splint elbow in full flexion 90° immediately"},{"label":"B","text":"Suspected Pediatric Supracondylar Fracture Field + ED Management"},{"label":"C","text":"Force realignment of displaced fracture in field"},{"label":"D","text":"Discharge home if Gartland II with poor pulse"},{"label":"E","text":"Wait 48 hours for surgery in white pulseless hand"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspected Pediatric Supracondylar Fracture Field + ED Management: (1) **pre-hospital (paramedic) management**: (a) **assess + document** ABCs, GCS, NV status (radial pulse, capillary refill, motor + sensory in median + AIN + ulnar + radial nerve distribution); (b) **gentle splint in position found** — typically slight flexion (30°) — do **NOT force into 90° flexion** (kinks brachial artery + compresses neurovascular structures further if displaced); (c) **avoid forceful realignment** in field — gentle alignment only if vascular compromise + extreme deformity; (d) **NV reassessment + documentation** after splint; (e) elevation if possible; (f) NPO; (g) IV access if available; (h) opioid analgesia (IV/IN); (i) **expedient transport to pediatric ED/orthopedic care** — Gartland III with NV compromise = surgical emergency; (j) communicate with receiving facility for activation; (2) **ED management**: (a) **rapid pediatric ATLS** assessment; (b) **document NV exam** carefully — specifically check **AIN (anterior interosseous nerve)** — OK sign (FPL + FDP index — "can you make an OK sign?"), median, radial, ulnar nerve function; radial + capillary refill; (c) **X-ray** — AP + lateral elbow — **anterior humeral line** key (should pass through middle third of capitellum); Gartland classification: I (non-displaced), II (displaced posteriorly but posterior cortex intact — hinged), III (completely displaced — most unstable), IV (multi-directional instability — rare); (d) **vascular assessment with pulse oximetry + Doppler** if pulse weak; (e) **pain control** — IV opioid; consider regional block (axillary or supraclavicular) for distal-only injury; (f) **NPO + admit** for likely OR; (g) **emergent OR for Gartland III** (especially with NV compromise) within hours; (3) **surgical management**: (a) **closed reduction + percutaneous pinning (CRPP)** — gold standard; (b) **2-3 lateral pins** (modern preferred — avoids ulnar nerve risk of medial pin); (c) medial pin selective with mini-incision (better stability biomechanically but ulnar nerve risk — iatrogenic injury 2-15%); (d) **assess pulse + perfusion after reduction**: (i) **pink pulseless hand** (perfused via collaterals) — usually observe (most recover); (ii) **white pulseless hand** — vascular emergency → emergent vascular exploration of brachial artery (entrapment, transection, intimal injury); (e) cast immobilization 3-4 weeks at 60-80° flexion (not full flexion); (f) pin removal in clinic 3-4 weeks; (g) PT for ROM after pin removal; (4) **complications + monitoring**: (a) **compartment syndrome (Volkmann''s)** — vigilance, especially with prolonged ischemia or excessive flexion; classic triad — pain, paresthesia, pain with passive stretch; **5 P''s late**; emergent fasciotomy if confirmed; (b) **AIN palsy** — common transient neuropraxia (recovers 2-4 months); (c) **ulnar nerve injury** — iatrogenic from medial pin; (d) **malunion + cubitus varus** ("gunstock deformity") — late complication of malalignment; (e) **radial nerve injury** — less common; (5) **family communication, follow-up, return precautions

---

Supracondylar humerus pediatric: pre-hospital — gentle splint in slight flexion (NOT 90° — kinks artery), document NV, opioid, NPO, expedient transport. ED — rapid ATLS + ANTERIOR HUMERAL LINE on X-ray + Gartland classification + AIN check (OK sign) + radial pulse/cap refill + pain control. Gartland III + NV compromise = emergent CRPP. Pink pulseless = observe; white pulseless = vascular exploration. 2-3 lateral pins (medial pin → ulnar n risk). Monitor compartment syndrome (Volkmann''s). AIN palsy usually recovers.', NULL,
  'medium', 'trauma', 'review',
  'orthopedics', 'ems_mgmt', 'trauma', 'peds',
  'AAOS Pediatric Supracondylar CPG 2011', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**EMS/Management**

เด็กชายอายุ 6 ปี ตกจักรยานบนสนามเด็กเล่น ปวดข้อศอกขวา + บวม + ผิดรูป + เริ่มชาปลายมือ paramedic ตรวจ field

VS: BP 100/65, HR 110, alert
PE: gross deformity elbow, decreased radial pulse, capillary refill 4 s, paresthesia distal, no open wound

จงอธิบาย field management + transport + ED management of suspected supracondylar humerus fracture'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**EMS/Management**

ชายไทยอายุ 30 ปี โดนสุนัขจรจัดกัดมือซ้าย wound 3 cm + 1.5 cm laceration over MCP joint of right hand 2 ชั่วโมงก่อน — animal not captured

VS: stable
PE: 2 puncture + 1 laceration wounds left hand + dorsum right MCP 3rd finger laceration
Last tetanus 8 ปีก่อน

จงอธิบาย bite wound management + special considerations (animal vs human + fight bite)', '[{"label":"A","text":"Primary closure of all bite wounds"},{"label":"B","text":"Bite Wound Management — Animal + Human + Fight Bite"},{"label":"C","text":"Antibiotics not needed for any bite"},{"label":"D","text":"Fight bite always safe outpatient management without exploration"},{"label":"E","text":"Rabies prophylaxis never indicated in domestic animal bites"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bite Wound Management — Animal + Human + Fight Bite: (1) **general principles**: (a) **all bite wounds high infection risk** (especially cat, human, deep, hand) — polymicrobial oral flora; (b) thorough wound irrigation with normal saline (low pressure, copious); (c) **avoid primary closure** for most bite wounds — leave open or delayed primary closure (especially hand, puncture, > 12 hours old, signs of infection); face lacerations sometimes primary closure for cosmesis; (d) elevate, immobilize injured extremity; (e) tetanus update; (2) **antibiotic prophylaxis** — indicated for: hand bites, deep puncture, joint/bone involvement, immunocompromise, asplenia, all cat bites, all human bites, > 12 hours old, presented late, signs of infection; (a) **amoxicillin-clavulanate (Augmentin)** — covers Pasteurella + S. aureus + Eikenella + anaerobes; **first-line oral**; (b) IV options — ampicillin-sulbactam, piperacillin-tazobactam, ceftriaxone + metronidazole, ertapenem; (c) **penicillin allergy** — doxycycline + clindamycin/metronidazole; (d) **duration** — 3-5 days prophylaxis; 7-14 days for established infection; (3) **specific pathogens**: (a) **Pasteurella multocida** — cat (75%) + dog (50%) — rapid (< 24h) cellulitis; (b) **Capnocytophaga canimorsus** — dog — severe sepsis in asplenic, immunocompromised, alcoholic; (c) **Eikenella corrodens** — human, fight bite — penicillin-susceptible (cephalosporin-resistant); (d) **S. aureus** + Streptococcus — all; (e) **anaerobes** — common; (f) **Bartonella** — cat (cat scratch); (4) **special — human bite + fight bite**: (a) **fight bite** = laceration over MCP joint after striking opponent''s teeth → tooth penetrates joint capsule → high risk of septic arthritis + osteomyelitis (frequently missed initially as innocuous laceration); (b) **assume joint penetration** in any laceration over knuckle in patient who hit someone or denies origin; (c) **explore in OR** under anesthesia for fight bite (irrigation, debridement, capsule inspection); (d) **antibiotics IV** — broader spectrum cover Eikenella (penicillin/amoxicillin-clavulanate, ampicillin-sulbactam); (e) hand surgery consultation; (5) **rabies prophylaxis**: (a) **risk assessment** — high-risk: bat, raccoon, fox, skunk, wild carnivores; dog/cat — depends on regional epidemiology, animal availability for observation; in Thailand — rabies endemic — high suspicion; (b) **post-exposure prophylaxis (PEP)** if indicated: wash wound thoroughly + soap/water + virucidal; **rabies vaccine** (4-5 doses on days 0, 3, 7, 14, ± 28 depending on protocol; modified for immunocompromised); **rabies immunoglobulin (RIG)** 20 IU/kg infiltrated around wound if previously unimmunized; (c) **observe healthy domestic animal** 10 days — if no rabies signs → no PEP needed (initiate PEP if unable to capture/observe); (6) **tetanus**: (a) **Td or Tdap** if > 5 years since last dose with dirty wound; (b) **TIG (tetanus immune globulin)** for unknown/incomplete immunization + dirty wound; (7) **wound culture** — generally not useful for prophylaxis; useful for established infection; (8) **follow-up** — 24-48 hours for infection check; immediate return precautions; (9) **report animal bites** per local regulations

---

Bite wounds: irrigate copiously, LEAVE OPEN (no primary closure, esp. hand/late/infected). Prophylactic abx: amoxicillin-clavulanate (covers Pasteurella + Eikenella + S. aureus + anaerobes) for hand bites, deep, joints, cats, humans, > 12 h, immunocompromised. Tetanus + rabies risk assessment (Thailand endemic — vaccine + RIG; observe healthy domestic 10 d). FIGHT BITE over MCP — assume joint penetration, OR exploration, hand surgery consult. Specific pathogens (Pasteurella, Eikenella, Capnocytophaga). Follow up 24-48h.', NULL,
  'medium', 'id', 'review',
  'orthopedics', 'ems_mgmt', 'id', 'adult',
  'IDSA SSTI Bite Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**EMS/Management**

ชายไทยอายุ 30 ปี โดนสุนัขจรจัดกัดมือซ้าย wound 3 cm + 1.5 cm laceration over MCP joint of right hand 2 ชั่วโมงก่อน — animal not captured

VS: stable
PE: 2 puncture + 1 laceration wounds left hand + dorsum right MCP 3rd finger laceration
Last tetanus 8 ปีก่อน

จงอธิบาย bite wound management + special considerations (animal vs human + fight bite)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**EMS/Management**

ชายไทยอายุ 30 ปี s/p closed reduction + long-leg cast for tibial fracture 3 วันก่อน เริ่มปวดมากในปลายขา + ชา + ปลายเท้าเริ่มเย็น + ปวดมากเมื่อขยับนิ้วเท้า, ไม่ดีขึ้นกับ pain medications

จงอธิบาย cast care principles + warning signs + complications + emergency management', '[{"label":"A","text":"Pain in cast is normal and always managed with more opioids"},{"label":"B","text":"Cast Care + Complications"},{"label":"C","text":"Cast should not be cut even if compartment syndrome suspected"},{"label":"D","text":"Patient may insert objects to relieve itch"},{"label":"E","text":"No follow-up needed after cast application"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cast Care + Complications: (1) **cast care patient education**: (a) **elevate extremity** above heart level for first 48-72 hours to reduce swelling; (b) **keep cast dry** — protect with plastic during bathing; do not submerge; consider waterproof liner for showering; (c) **ice intermittently** over cast in first 48h; (d) **avoid inserting objects** to scratch (skin breakdown, retained foreign body); (e) **finger/toe wiggling exercises** + ROM at unaffected joints; (f) **weight-bearing instructions** — clarify (NWB, TTWB, PWB, WBAT); (g) **follow-up plan** + emergency contact information; (h) avoid getting cast wet, dirty, or damaged; (2) **warning signs requiring urgent evaluation** — "Worsening pain, paresthesia, pallor, paralysis, pulselessness, perishingly cold" (5+ P''s): (a) **increasing pain** despite analgesics — most concerning sign of complication; (b) **pain on passive stretch** of toes/fingers; (c) **numbness/tingling** distal; (d) **pallor/cyanosis** distal; (e) **inability to move** distal digits; (f) **cool/cold** distal extremity; (g) **swelling** above + below cast; (h) **fever + foul odor** from cast (suspect underlying infection); (i) **persistent pressure pain** at single spot under cast (pressure ulcer); (j) cast cracking, loose, or wet; (3) **complications + management**: (a) **acute compartment syndrome** — emergency: bivalve cast (or remove) immediately + assess; if confirmed → emergent fasciotomy; (b) **cast tightness + swelling** — bivalve initially, may need recasting after swelling resolves; (c) **pressure ulcer/sore** under cast — windowing the cast over pressure point for inspection + relief; (d) **infection** — bone/soft tissue under cast (pin tract for external fix) — labs + imaging + remove cast for inspection; (e) **DVT** — leg cast immobilization risk; selective prophylaxis based on patient risk; (f) **disuse atrophy + stiffness** — early mobilization at unaffected joints, isometric exercises; (g) **CRPS (complex regional pain syndrome)** — particularly after distal radius/wrist; aggressive PT, early recognition; (h) **fracture displacement under cast** — repeat X-ray at 1-2 weeks + as clinically indicated; recasting or surgery if loss of reduction; (4) **bivalving + windowing**: (a) **bivalve** — cut cast longitudinally on both sides → split open like clamshell — relieves pressure while maintaining alignment; useful for swelling, suspected compartment syndrome (preserves alignment while allowing inspection + monitoring); (b) **windowing** — cut window over specific area of pressure or suspected pathology — allows local inspection + treatment; replace window with padding to prevent edema window edema; (5) **cast removal + transition**: (a) **cast saw** — vibrating blade (not rotating) — safe with proper technique but burns if held in one place; explain to patient (reduces anxiety); (b) **transition to functional brace** for selected late fractures; (6) **cast types**: (a) **plaster of Paris** — moldable, cheaper, more time to set; (b) **fiberglass** — lighter, water-resistant, modern; (c) **prefab splints** for emergency; (d) **functional braces** for selected late fractures; (7) **special populations**: (a) **pediatric** — risk of compartment syndrome from cast tightness (rapid swelling), regular monitoring; (b) **elderly** — pressure ulcers, deconditioning, DVT, functional decline

---

Cast care: elevate, keep dry, avoid inserting objects, monitor distal NV. Warning signs (5+ P''s): worsening pain, pain on passive stretch, paresthesia, pallor, paralysis, cold, pulselessness, fever/foul odor (infection). Complications: compartment syndrome (bivalve emergently!), pressure sore (window cast), infection, DVT, CRPS, displacement (repeat X-ray). Bivalve preserves alignment + allows inspection. Window for local pathology. Cast saw vibrates (safe with proper technique). Pediatric — rapid swelling + compartment risk.', NULL,
  'easy', 'procedures', 'review',
  'orthopedics', 'ems_mgmt', 'procedures', 'adult',
  'AAOS Cast Management', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**EMS/Management**

ชายไทยอายุ 30 ปี s/p closed reduction + long-leg cast for tibial fracture 3 วันก่อน เริ่มปวดมากในปลายขา + ชา + ปลายเท้าเริ่มเย็น + ปวดมากเมื่อขยับนิ้วเท้า, ไม่ดีขึ้นกับ pain medications

จงอธิบาย cast care principles + warning signs + complications + emergency management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**EMS/Management**

หญิงไทยอายุ 78 ปี on warfarin (atrial fibrillation, INR 3.5) หกล้มต้องเข้า OR สำหรับ hip fracture

นอกจากนี้มี hematoma หน้าผากเล็กน้อย + head CT — small subdural

จงอธิบาย anticoagulation reversal strategies + perioperative management — warfarin + DOAC + antiplatelet', '[{"label":"A","text":"Protamine reverses warfarin"},{"label":"B","text":"Anticoagulation Reversal in Trauma + Pre-operative"},{"label":"C","text":"Idarucizumab reverses rivaroxaban"},{"label":"D","text":"Platelet transfusion always indicated in ICH with antiplatelets"},{"label":"E","text":"Bridging therapy needed in all atrial fibrillation patients"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anticoagulation Reversal in Trauma + Pre-operative: (1) **warfarin reversal**: (a) **vitamin K 5-10 mg PO/IV** — onset 6-12 hours (slower) — essential for sustained reversal; (b) **prothrombin complex concentrate (PCC, 4-factor — Kcentra, Beriplex)** 25-50 IU/kg IV — **rapid (10-15 min) + complete reversal** — preferred for urgent reversal (intracranial bleeding, urgent surgery within 6 hours); (c) **fresh frozen plasma (FFP)** 10-15 mL/kg — slower (need to thaw), less complete reversal, volume-intensive (consider in elderly with HF), used when PCC unavailable; (d) target INR < 1.5 for surgery (< 1.3 for neurosurgery); recheck INR + give additional doses as needed; (e) **bridge restart anticoagulation** post-op based on surgical bleeding risk + ongoing AF/VTE risk; (2) **DOAC (direct oral anticoagulant) reversal**: (a) **dabigatran (direct thrombin inhibitor)** — **idarucizumab (Praxbind)** 5 g IV — specific monoclonal antibody, rapid + complete; hemodialysis alternative (dabigatran is dialyzable, others are not); (b) **rivaroxaban, apixaban, edoxaban (factor Xa inhibitors)** — **andexanet alfa (Andexxa)** — specific recombinant decoy Xa — high cost, limited availability; alternative — **4-factor PCC** 50 IU/kg (off-label but supported by multiple studies for emergent reversal); (c) **timing without specific reversal** — postpone surgery 24-48 hours after last dose for most procedures if possible; (d) check **drug-specific assays** if available (dabigatran — TT/dTT/ECT; Xa inhibitors — anti-Xa levels); (3) **antiplatelet reversal**: (a) **aspirin + clopidogrel + ticagrelor + prasugrel** — irreversibly inhibit platelets for 7-10 days; (b) **platelet transfusion** for severe bleeding or emergent surgery with significant platelet dysfunction — limited efficacy for newer agents (ticagrelor inhibits via reversible binding so transfused platelets affected); recent PATCH trial — platelet transfusion in ICH with antiplatelet may worsen outcomes; (c) **DDAVP (desmopressin)** 0.3 μg/kg IV — improves platelet function modestly, useful adjunct; (d) **TXA** as antifibrinolytic adjunct; (4) **heparin reversal**: (a) **unfractionated heparin (UFH)** — **protamine sulfate** 1 mg per 100 U heparin, max 50 mg IV; (b) **LMWH (enoxaparin)** — partial reversal with protamine (50-60% reversal); (5) **clinical decision making** — risks of thrombosis vs bleeding: (a) **emergent surgery + active bleeding** → immediate reversal; (b) **urgent (< 24h)** → reverse + delay if can wait for partial DOAC clearance; (c) **elective** → hold per drug protocol + reschedule; (d) **bridging therapy** in high VTE/thromboembolic risk patients (recent embolic stroke, mechanical valve, recent VTE within 3 months) — LMWH bridge selective; PERIOP-2 + BRIDGE trials — most patients do NOT need bridging for AF without recent embolic events; (6) **post-op restart anticoagulation** — balance bleeding risk vs thromboembolic risk; typically restart within 24-72 hours post-op; (7) **multidisciplinary** — anesthesia, cardiology/hematology, surgical team

---

Anticoagulation reversal: warfarin → vitamin K + PCC (rapid + complete) > FFP (slow, volume). DOACs → dabigatran: idarucizumab (Praxbind); Xa inhibitors (riva/apix/edox): andexanet alfa OR 4-factor PCC. Heparin → protamine (UFH; partial for LMWH). Antiplatelets → platelet transfusion (limited for newer agents, PATCH trial in ICH may worsen) + DDAVP + TXA. Elective: hold per protocol. Bridging only for high-risk (recent embolism, mechanical valve, recent VTE) — most AF don''t need (PERIOP-2/BRIDGE). Restart post-op 24-72h.', NULL,
  'hard', 'trauma', 'review',
  'orthopedics', 'ems_mgmt', 'trauma', 'adult',
  'ACCP; ASRA Perioperative', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**EMS/Management**

หญิงไทยอายุ 78 ปี on warfarin (atrial fibrillation, INR 3.5) หกล้มต้องเข้า OR สำหรับ hip fracture

นอกจากนี้มี hematoma หน้าผากเล็กน้อย + head CT — small subdural

จงอธิบาย anticoagulation reversal strategies + perioperative management — warfarin + DOAC + antiplatelet'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**EMS/Management**

ผู้ป่วยอายุ 35 ปี ในห้องฉุกเฉิน — open ankle fracture + dislocation + compartment syndrome

จงอธิบาย key elements of documentation + medico-legal considerations in orthopedic emergencies + informed consent', '[{"label":"A","text":"Copy-paste exam from previous visit without verification"},{"label":"B","text":"Documentation + Medico-legal in Orthopedic Emergencies"},{"label":"C","text":"Documentation only needed if complications occur"},{"label":"D","text":"Informed consent not needed in any orthopedic emergency"},{"label":"E","text":"Backdating documentation is acceptable"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Documentation + Medico-legal in Orthopedic Emergencies: (1) **principles** — orthopedic emergencies are common malpractice sources (compartment syndrome, missed cervical spine, missed scaphoid, cauda equina syndrome, NV injury); thorough documentation = best defense + best patient care; (2) **history documentation**: (a) **mechanism of injury** — detailed (force vector, direction, velocity, fall height, body position, witnesses); (b) **time of injury** + time of presentation; (c) **patient-reported symptoms** — pain (severity, location, character, exacerbating/relieving), function, NV symptoms; (d) **prior medical history** — relevant comorbidities, medications (especially anticoagulants), prior injuries/surgeries; (e) **social history** — handedness, occupation, sports, smoking, alcohol; (f) **allergies** + tetanus status; (3) **examination documentation**: (a) **NV exam BEFORE + AFTER any intervention** (reduction, splinting, transport) — specifically: pulses (radial/ulnar/DP/PT), capillary refill, sensation (specific dermatomes), motor function (specific muscle groups/nerves), pain on passive stretch (compartment); (b) **wound description** — size, depth, contamination, exposed structures, photograph if possible; (c) **deformity, swelling, ecchymosis, range of motion**; (d) **specific tests** — Tinel, Phalen, Lachman, Spurling, Ortolani, etc. (whichever relevant); (e) **vital signs** + clinical state; (4) **imaging documentation**: (a) **interpretation + actions taken**; (b) include specific findings + measurements + correlation with clinical exam; (c) note if imaging is read by radiologist vs ordering physician; (d) document reasoning for ordering or not ordering additional imaging; (5) **decision-making documentation**: (a) **differential diagnosis considered**; (b) **clinical reasoning** for management choice; (c) **patient/family discussion** + understanding; (d) **shared decision making** documented; (6) **informed consent**: (a) **elements** — diagnosis, proposed treatment, alternatives (including non-treatment), benefits + risks, expected outcomes + complications, time for questions, voluntary nature, capacity assessment; (b) **specific risks** to discuss for ortho surgery: infection, bleeding, NV injury, DVT/PE, MI/stroke, scar, stiffness, hardware failure, nonunion/malunion, need for additional surgery, anesthesia risks, instrument retention, post-traumatic OA, AVN (for hip), tumor (for knee), cauda equina (for spine) — tailor to procedure; (c) **emergency exception** — implied consent for emergency life- or limb-threatening situations without capacity; (d) **minor consent** — parents/guardians; (e) **interpreter** for non-English speakers — document; (f) **discuss in language patient understands**; (7) **communication documentation**: (a) **all conversations** with patient, family, consultants, primary care, transferring physicians; (b) **timing + content** of phone calls; (c) **handoffs** of care; (d) **discharge instructions** — written + verbal — when to return, follow-up plan, contact information, activity restrictions; (8) **specific high-risk situations**: (a) **compartment syndrome** — serial exams documented, time of decision, who made decisions, who notified, time to OR; (b) **NV injury** — pre + post-intervention; (c) **delayed transport** — reasons; (d) **non-compliance** — counseled, documented; (e) **left AMA** — counseled risks + benefits, witnessed; (9) **electronic medical record best practices** — accurate timestamp, no backdating, no alterations after the fact (addenda OK with timestamp), avoid copy-paste of templates without verification; (10) **multidisciplinary care documentation** — consultations + recommendations + actions; (11) **handoffs/SBAR + escalation** — clear, structured; (12) **patient confidentiality** + privacy laws (HIPAA equivalent in Thailand — PDPA); (13) **never events** — wrong site/side/patient surgery (use surgical checklist + time-out + site marking)

---

Ortho documentation + medico-legal: thorough = both good care + defense. Document mechanism, NV exam BEFORE + AFTER intervention, wound description + photo, all decisions + reasoning, conversations, handoffs. Informed consent: dx, treatment, alternatives, benefits/risks/complications (tailored), capacity, voluntary, interpreter. Emergency exception valid. High-risk = compartment syndrome (serial NV documented), missed cervical spine, scaphoid, CES, NV injury. Time-out + site marking for never events. PDPA compliance.', NULL,
  'easy', 'procedures', 'review',
  'orthopedics', 'ems_mgmt', 'procedures', 'adult',
  'AAOS Risk Management', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**EMS/Management**

ผู้ป่วยอายุ 35 ปี ในห้องฉุกเฉิน — open ankle fracture + dislocation + compartment syndrome

จงอธิบาย key elements of documentation + medico-legal considerations in orthopedic emergencies + informed consent'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**EMS/Management**

ผู้ป่วย polytrauma มอเตอร์ไซค์ชน ที่โรงพยาบาลชุมชน 100 km จาก trauma center หลัก — รพ. ขาด orthopedic surgeon + MRI

GCS 13, BP 90/60, HR 130, open femur + abdominal injury

จงอธิบาย trauma system + regionalization + transfer decisions + communication', '[{"label":"A","text":"Keep all polytrauma patients at local hospital"},{"label":"B","text":"Trauma System + Regional Transfer + Communication"},{"label":"C","text":"Send patient without communication or records"},{"label":"D","text":"Refuse transfer if receiving facility busy"},{"label":"E","text":"No need to stabilize before transfer"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Trauma System + Regional Transfer + Communication: (1) **trauma system levels** (American College of Surgeons): (a) **Level I** — comprehensive: 24/7 in-house trauma surgeon + multiple subspecialists + research + education + high volume; (b) **Level II** — initial definitive trauma care, similar to Level I but no research/education requirement; (c) **Level III** — initial assessment, resuscitation, surgery for non-complex injuries, transfer of complex; (d) **Level IV** — primarily resuscitation + stabilization + rapid transfer; (e) Thailand has trauma center designation system per Ministry of Public Health; (2) **regional trauma coordination**: (a) **inclusive trauma system** — all hospitals participate at appropriate level + transfer based on capability; (b) **field triage protocols** (CDC field triage criteria) — paramedics bypass closest hospital to go to appropriate level trauma center based on injury severity + mechanism + comorbidities; (c) **"golden hour"** concept — early definitive care improves outcomes; (3) **transfer criteria — when to transfer**: (a) **physiologic** — persistent hypotension, GCS < 14, RR < 10 or > 29; (b) **anatomic** — penetrating to head/neck/torso/proximal extremities, flail chest, pelvic fracture, paralysis, open/depressed skull fracture, 2+ proximal long bone fractures, mangled extremity, amputation proximal to wrist/ankle; (c) **mechanism** — high-energy MVC, falls > 20 ft, auto vs pedestrian, ejection; (d) **comorbidity** — age > 55, anticoagulation, pregnancy > 20 wk, immunosuppression, bleeding disorder; (e) **resource needs** — required services not available at current facility; (4) **transfer decision in this case**: (a) ATLS stabilization first; (b) **damage control** — IV access, fluid resuscitation, MTP if needed, control external bleeding, fracture stabilization (splint, ex-fix); (c) **secure airway** if needed; (d) **early antibiotic + tetanus** for open fracture; (e) **call trauma center directly** — speak to receiving trauma surgeon — "sender to receiver" conversation; (f) **transfer agreement** + documentation + records + imaging sent ahead; (g) **don''t delay transfer** for excessive imaging or non-essential procedures ("definitive care delay" worsens outcomes); (h) **mode of transport** — ground vs helicopter — based on distance, time, weather, patient stability; (5) **communication SBAR for transfer**: (a) **S — Situation** — patient ID, vital signs, current stability; (b) **B — Background** — mechanism, injuries identified, treatments given; (c) **A — Assessment** — current clinical picture, concerns; (d) **R — Recommendation** — what you need from receiving facility, expected arrival; (e) **document time + receiving physician name**; (6) **pre-transfer preparation**: (a) airway secured + tube confirmed; (b) IV access + drips, transfusion if active; (c) NG/Foley if needed; (d) splint/immobilize; (e) wound dressed; (f) tetanus + antibiotic; (g) imaging on disc/electronic transfer; (h) records + medications + ID; (i) family notified; (j) transfer team briefed; (7) **EMTALA equivalent** — patient stabilization before transfer + receiving hospital acceptance; (8) **quality + outcomes**: (a) regional trauma system reduces mortality; (b) appropriate triage = improved survival; (c) telemedicine + tele-radiology for remote consultation; (9) **disaster preparedness** — interhospital coordination, surge capacity, mutual aid agreements

---

Trauma system: regionalized, Levels I-IV. Transfer when injury severity exceeds capability. Field triage criteria. Stabilize per ATLS → call receiving trauma surgeon (sender-receiver) → SBAR communication → pre-transfer preparation (airway, IV, splint, antibiotic, tetanus, records, imaging) → don''t delay transfer for non-essentials. Document time + receiving physician. Helicopter vs ground based on distance/time/stability. Telemedicine adjunct. Regional system reduces mortality.', NULL,
  'medium', 'trauma', 'review',
  'orthopedics', 'ems_mgmt', 'trauma', 'adult',
  'ACS Resources for Optimal Care of Trauma Patient', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**EMS/Management**

ผู้ป่วย polytrauma มอเตอร์ไซค์ชน ที่โรงพยาบาลชุมชน 100 km จาก trauma center หลัก — รพ. ขาด orthopedic surgeon + MRI

GCS 13, BP 90/60, HR 130, open femur + abdominal injury

จงอธิบาย trauma system + regionalization + transfer decisions + communication'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**EMS/Management**

ผู้ป่วยอายุ 45 ปี ที่โรงพยาบาลในจังหวัดห่างไกล ปวด + บวมข้อมือ X-ray ไม่ชัดเจน — รพ. ไม่มี ortho specialist

มีระบบ telemedicine + tele-radiology available

จงอธิบาย role + best practices ของ telemedicine ใน orthopedics + remote consultation', '[{"label":"A","text":"Telemedicine replaces all in-person ortho care"},{"label":"B","text":"Telemedicine + Remote Orthopedic Consultation"},{"label":"C","text":"Telemedicine cannot help in rural areas"},{"label":"D","text":"HIPAA/privacy compliance unnecessary in telemedicine"},{"label":"E","text":"Telemedicine should always be used regardless of clinical scenario"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Telemedicine + Remote Orthopedic Consultation: (1) **roles + applications**: (a) **acute consultation** — fracture interpretation, urgent decision support, reduction guidance, transfer triage; (b) **post-op follow-up** — wound check, ROM assessment, removal of sutures planning; (c) **chronic management** — OA, rheumatologic conditions, post-arthroplasty long-term follow-up; (d) **second opinions** — complex cases; (e) **interprofessional education** — case discussions, didactic; (f) **rural + underserved care** — addresses geographic disparities; (g) **screening + triage** — appropriate referral, prioritization; (2) **modalities**: (a) **synchronous video consultation** (real-time) — patient interview + visual exam + family involvement; live discussion; (b) **store-and-forward (asynchronous)** — images, X-rays, photos, records reviewed offline; (c) **remote patient monitoring** — wearables (motion, pain), post-op tracking; (d) **tele-radiology** — image interpretation by remote radiologist (often standard already); (e) **digital health platforms** — apps, e-consult, secure messaging; (3) **best practices**: (a) **clear referral question** + clinical context + recent imaging; (b) **appropriate exam techniques** for video — guide patient through self-exam (gait, ROM, motor, sensation — limited but useful), use family/in-clinic provider as physical hands; (c) **secure platforms** — HIPAA/PDPA-compliant (encryption, authentication, audit trail); (d) **documentation** equivalent to in-person; (e) **informed consent** for telemedicine (explain modality, limitations, what cannot be done virtually); (f) **integration with EMR**; (g) **provider licensing + credentialing** across jurisdictions; (h) **rural site facilitator** (nurse, PA, physician) often invaluable for hands-on assessment; (4) **specific orthopedic applications**: (a) **fracture management** — X-ray review, classification, treatment recommendation, splinting/casting guidance; (b) **wound assessment** — post-op photos for healing, infection signs; (c) **physical therapy** + rehabilitation — remote exercise prescriptions, virtual PT sessions; (d) **sports medicine** — return-to-play decisions with remote exam; (e) **chronic pain management**; (f) **pediatric orthopedics** — gait assessment, follow-up; (5) **limitations**: (a) **hands-on exam** limited (palpation, joint stress testing, NV exam — depending on assistant); (b) **technical issues** — connectivity, equipment, training; (c) **patient-related** — technology literacy, language barriers, vision/hearing impairment; (d) **legal + reimbursement** — varies by jurisdiction + insurance; (e) **clinical equipoise** — when in-person is necessary, do not delay (e.g., suspected compartment syndrome, NV compromise, suspected open fracture, severe trauma); (6) **clinical decision** in this case: (a) review X-ray via tele-radiology + photos; (b) **remote orthopedic consult** for splinting + management; (c) **transfer criteria** if surgery needed; (d) **follow-up plan** via telemedicine + return precautions; (7) **outcomes evidence** — multiple studies show non-inferior outcomes for selected ortho conditions; high patient satisfaction; cost-effective for rural + underserved; (8) **integration with trauma system** — adjunct, not replacement for in-person care when needed; (9) **modern post-COVID expansion** — accelerated adoption + payer support; (10) **future** — AI-assisted diagnosis, VR examination, robotic-assisted procedures

---

Telemedicine in ortho: acute consultation (fracture, transfer decisions), post-op follow-up, chronic management, second opinions, rural care. Modalities: synchronous video, store-and-forward, tele-radiology, remote monitoring. Best practices: secure platform (PDPA), clear question, exam adaptation (use site facilitator), informed consent, documentation. Limitations: hands-on, technical, legal. Don''t delay in-person when needed (compartment syndrome, NV). Non-inferior for selected; cost-effective for rural. Post-COVID expansion.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'orthopedics', 'ems_mgmt', 'msk_nontrauma', 'adult',
  'AAOS Telemedicine Position', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**EMS/Management**

ผู้ป่วยอายุ 45 ปี ที่โรงพยาบาลในจังหวัดห่างไกล ปวด + บวมข้อมือ X-ray ไม่ชัดเจน — รพ. ไม่มี ortho specialist

มีระบบ telemedicine + tele-radiology available

จงอธิบาย role + best practices ของ telemedicine ใน orthopedics + remote consultation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**EMS/Management**

ก่อน TKA elective surgery — pre-op safety checklist, time-out, site marking — เพื่อป้องกัน wrong-site surgery + complications

จงอธิบาย Universal Protocol + WHO surgical safety checklist + never events + culture of safety', '[{"label":"A","text":"Time-out not necessary for routine cases"},{"label":"B","text":"Operating Room Safety + Universal Protocol + WHO Surgical Safety Checklist + Never Events"},{"label":"C","text":"Site marking by surgeon without patient involvement"},{"label":"D","text":"Wrong-site surgery is acceptable rare event"},{"label":"E","text":"Just culture means no accountability ever"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Operating Room Safety + Universal Protocol + WHO Surgical Safety Checklist + Never Events: (1) **wrong-site surgery + never events** — preventable adverse events that should never occur (wrong site, wrong patient, wrong procedure, retained surgical item, intraoperative death, severe complications); estimated ~ 40 wrong-site surgeries/week in US — significant ortho-relevant (high in extremity + spine surgery); (2) **Universal Protocol (Joint Commission, 2004) — 3 components**: (a) **pre-procedure verification** — patient identification, procedure, site, side, consent reviewed; check for required imaging + implants + instruments + blood products; (b) **site marking** — surgeon marks operative site with permanent marker initials + visible at incision after prep + drape; mark with patient participation (engagement reduces errors); for spine — level confirmation intra-op with radiographic + neuromonitoring; (c) **time-out** — pause immediately before incision — surgeon + anesthesia + nursing + entire team confirm: (i) correct patient identity (2 identifiers), (ii) correct site + side, (iii) correct procedure, (iv) consent valid, (v) imaging available + matches, (vi) antibiotic prophylaxis given on time, (vii) DVT prophylaxis, (viii) blood available if needed, (ix) implant availability, (x) anticipated critical events; all team members agree before proceeding; if disagreement or uncertainty → STOP; (3) **WHO Surgical Safety Checklist (2008)** — 19-item checklist proven to reduce mortality + complications (Haynes NEJM 2009 — pilot study 8 countries showed mortality 1.5% → 0.8%, complications 11% → 7%): (a) **sign in** (before anesthesia) — patient ID, site marked, anesthesia check, allergies, airway/aspiration risk, blood loss risk; (b) **time out** (before incision) — team introductions, patient + site + procedure confirmation, antibiotic timing, imaging displayed, anticipated critical events; (c) **sign out** (before patient leaves OR) — procedure performed recorded, instrument + sponge + needle count, specimen labeling, equipment problems, recovery + management concerns; (4) **specific orthopedic risks for never events**: (a) **wrong limb/side** — extremity surgery (R vs L); (b) **wrong spinal level** — multiple similar vertebrae; intra-op imaging mandatory; (c) **retained surgical item** — sponges, instruments, broken K-wires/screws — counts + radiopaque markers + intra-op X-ray if uncertain; (d) **bone cement implantation syndrome** in cemented hip — anesthesia + surgeon awareness, slow careful technique; (e) **fat embolism syndrome** during IM nailing; (f) **wrong implant size**; (g) **tourniquet over-use** + nerve injury; (5) **culture of safety**: (a) **just culture** — non-punitive for system errors, accountability for reckless behavior; (b) **psychological safety** — anyone can speak up + stop the line; (c) **debriefing** after adverse events + near-misses; (d) **root cause analysis (RCA)** — systematic investigation of errors; (e) **continuous quality improvement (CQI)** — measure + improve outcomes; (f) **simulation** for high-risk scenarios; (g) **leadership engagement**; (h) **transparency** with patients + families when errors occur (open disclosure); (6) **specific quality metrics in ortho**: (a) SSI rate, (b) DVT/PE rate, (c) readmission rate, (d) PJI rate, (e) length of stay, (f) patient-reported outcome measures (PROMs), (g) functional outcomes, (h) revision rates, (i) implant survival; (7) **reporting + transparency** — internal incident reporting, external (sentinel event reports), implant registries (Australia/Sweden/UK lead, modern global ICOR); (8) **patient + family engagement** — preoperative education + informed consent, post-op care plan, return precautions

---

OR safety: Universal Protocol — pre-procedure verification + site marking (with patient) + TIME-OUT (entire team confirms patient/site/procedure/consent/abx/imaging before incision). WHO Surgical Safety Checklist (sign-in/time-out/sign-out) — proven to reduce mortality + complications (Haynes NEJM). Specific ortho risks: wrong side, wrong spinal level (intra-op imaging), retained items, bone cement syndrome, fat embolism. Just culture + psychological safety + RCA + CQI. Quality metrics: SSI, DVT, PJI, PROMs, registry. Open disclosure when errors occur.', NULL,
  'easy', 'procedures', 'review',
  'orthopedics', 'ems_mgmt', 'procedures', 'adult',
  'Joint Commission Universal Protocol; WHO', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**EMS/Management**

ก่อน TKA elective surgery — pre-op safety checklist, time-out, site marking — เพื่อป้องกัน wrong-site surgery + complications

จงอธิบาย Universal Protocol + WHO surgical safety checklist + never events + culture of safety'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Integrative Case**

ผู้ป่วยอายุ 24 ปี ขับมอเตอร์ไซค์ชนรถยนต์ — สวมหมวก แต่ระดับ moderate severe TBI (GCS 8 on arrival → intubated, GCS T7) + closed femoral shaft fracture + open tibial Gustilo II + posterior hip dislocation + concomitant pulmonary contusion + ARDS + coagulopathy from TBI

VS post-intubation: BP 100/60, HR 110, ICP monitor showed 18 mmHg

จงอธิบาย integrative management — ortho + neuro + trauma + ICU + multidisciplinary', '[{"label":"A","text":"Definitive IM nail of femur within 1 hour regardless of TBI status"},{"label":"B","text":"Polytrauma + TBI + Multiple Orthopedic Injuries — Integrative Multidisciplinary Approach"},{"label":"C","text":"Delay hip dislocation reduction until 48 hours"},{"label":"D","text":"High-dose mannitol + aggressive fluid restriction"},{"label":"E","text":"Do not stabilize fractures until TBI fully resolved"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Polytrauma + TBI + Multiple Orthopedic Injuries — Integrative Multidisciplinary Approach: (1) **principles + competing priorities**: (a) **TBI management priorities** — maintain cerebral perfusion (CPP = MAP - ICP > 60-70 mmHg), prevent secondary brain injury (avoid hypotension SBP > 100, hypoxia SpO2 > 94, hypercarbia ETCO2 35-40, hyperthermia, hyponatremia), control ICP (head of bed 30°, sedation, mannitol/hypertonic saline, drainage if EVD); (b) **orthopedic priorities** — reduction of hip dislocation (AVN risk), stabilization of femur (reduces blood loss + fat embolism), open fracture management; (c) **balance** — orthopedic surgery causes hemodynamic instability + cytokine release + "second hit" that worsens TBI + ARDS; (2) **immediate priorities** (order may overlap): (a) **A** — airway secured (intubated); (b) **B** — pulmonary contusion + ARDS — lung-protective ventilation (PEEP 8-10, low TV 6 mL/kg IBW, plateau pressure < 30); (c) **C** — fluid resuscitation balanced (avoid hypotension, but cautious to avoid worsening contusion/ARDS), BT 1:1:1, TXA, MTP if active bleeding; (d) **D** — neuro — head CT, ICP monitor, neurosurgery consult; (e) **E** — exposure, warm, secondary survey; (3) **hip dislocation — reduce within 6 hours** to prevent AVN (4.8% < 6h vs 52% > 6h) — emergent closed reduction under sedation; (4) **damage control orthopedics for femur + tibia**: (a) **external fixator** for femur + tibia — quick (< 1 hour), low blood loss, less inflammatory response than IM nail; provides skeletal stability; (b) **open fracture management** — IV antibiotic + tetanus + irrigation + debridement; (c) **avoid early reamed IM nailing** in TBI + ARDS — reaming releases fat emboli → worsens lung injury ("second hit"); damage control approach reduces ARDS in TBI + chest injury; (d) **definitive fixation** delayed 5-14 days when patient stable, ARDS recovered, ICP controlled, coagulopathy resolved; (5) **timing reconciliation**: (a) **EPOCH + early appropriate care (EAC)** principle — definitive fixation when physiologically responsive; (b) **avoid > 24-48 hr delay** of all orthopedic care if possible (deconditioning, complications); (c) hip dislocation reduction is non-negotiable emergency; (6) **ICU management**: (a) **multidisciplinary** — trauma surgery, neurosurgery, ortho, anesthesia/critical care, pulmonary, infectious disease, nutrition, PT/OT; (b) **VTE prophylaxis** — mechanical immediately; chemical when bleeding/ICP controlled (usually 24-48h after stable); (c) **nutrition** — early enteral (within 24-48h); (d) **glycemic control** — moderate; (e) **stress ulcer prophylaxis**; (f) **delirium prevention** — minimize sedation when possible; (g) **family communication + goals of care**; (7) **TBI-specific**: (a) avoid hypotension + hypoxia (worse outcomes); (b) seizure prophylaxis 7 days; (c) prognostication delayed (don''t withdraw care prematurely in young TBI); (d) repeat CT for clinical deterioration; (e) GCS + neurologic exam regularly; (8) **ortho longer-term**: (a) **plan definitive fixation** when stable; (b) hardware choice + timing — IM nail for femur once stable, IM nail or plate for tibia; (c) wound management for open fracture (VAC, debridement); (d) early PT/OT once stable to prevent contractures, joint stiffness; (e) heterotopic ossification screening + prophylaxis (common in TBI + spine injury); (9) **rehabilitation transition** — early start; coordinate orthopedic + neuro rehab; (10) **family-centered care + ethics** — communication, prognostication, decision-making; (11) **long-term outcomes** — coordinated rehab improves function + reduces disability

---

Polytrauma + TBI + ortho: integrative care. Priorities — maintain CPP (avoid hypotension, hypoxia, hypercarbia), reduce hip dislocation < 6h (AVN), damage control orthopedics (ex-fix for femur/tibia — avoid early reamed IM nail which releases fat emboli → worsens TBI/ARDS), open fracture (abx + tetanus + I&D), delayed definitive fixation 5-14d when stable. Multidisciplinary ICU (trauma + neuro + ortho + critical care + PT). VTE prophylaxis (mechanical immediate, chemical 24-48h). HO screening. Coordinated rehab.', NULL,
  'hard', 'trauma', 'review',
  'orthopedics', 'integrative', 'trauma', 'adult',
  'Pape; EAC; Brain Trauma Foundation', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Integrative Case**

ผู้ป่วยอายุ 24 ปี ขับมอเตอร์ไซค์ชนรถยนต์ — สวมหมวก แต่ระดับ moderate severe TBI (GCS 8 on arrival → intubated, GCS T7) + closed femoral shaft fracture + open tibial Gustilo II + posterior hip dislocation + concomitant pulmonary contusion + ARDS + coagulopathy from TBI

VS post-intubation: BP 100/60, HR 110, ICP monitor showed 18 mmHg

จงอธิบาย integrative management — ortho + neuro + trauma + ICU + multidisciplinary'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Integrative Case**

หญิงไทยอายุ 65 ปี DM2 (HbA1c 9.5%) underlying HT + ESRD on hemodialysis + CAD s/p PCI + peripheral vascular disease (ABI 0.6) + smoker — มี non-healing diabetic foot ulcer + osteomyelitis 1st MT 1 ปี + Charcot midfoot + falls at home

Viable forefoot but chronic non-healing
VS stable

จงอธิบาย integrative multidisciplinary management', '[{"label":"A","text":"Single specialty (orthopedics alone) sufficient"},{"label":"B","text":"Complex Diabetic Foot — Integrative Multidisciplinary Care"},{"label":"C","text":"Aminoglycoside is first-line antibiotic in ESRD"},{"label":"D","text":"Smoking cessation has no impact on wound healing"},{"label":"E","text":"Always proceed with below-knee amputation as first option"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Complex Diabetic Foot — Integrative Multidisciplinary Care: (1) **complexity** — multiple chronic conditions interconnected: DM + ESRD + PVD + CAD + smoking + non-healing wound + OM + Charcot + falls; each impacts others; (2) **multidisciplinary team essential**: (a) **endocrinology** — glycemic optimization (target HbA1c < 7.5-8 individualized, balance hypoglycemia risk in ESRD), insulin titration, comorbid management; (b) **nephrology** — ESRD care, dialysis schedule, fluid + electrolyte balance, anemia management; (c) **vascular surgery** — vascular assessment (ABI, angiography), revascularization (balloon angioplasty, stenting, bypass) — improves wound healing potential; (d) **infectious disease** — antibiotic selection + duration, deep tissue/bone culture-targeted (avoid nephrotoxic in ESRD — aminoglycoside contraindicated); (e) **orthopedic surgery (foot + ankle subspecialty)** — surgical management of OM, Charcot reconstruction, amputation decisions; (f) **podiatry** — wound care, debridement, offloading, custom footwear, regular surveillance; (g) **wound care nursing** — dressing changes, VAC management, education; (h) **plastic surgery** — flap coverage, free flap when needed; (i) **cardiology** — perioperative CV risk assessment + optimization; (j) **physical therapy** — gait training, balance, fall prevention; (k) **occupational therapy** — ADL adaptation, home safety assessment; (l) **nutrition** — protein-calorie + vitamin (A, C, zinc) for wound healing; (m) **social work** — psychosocial, adherence, financial barriers, family support; (n) **diabetes educator** — self-management, foot care education; (o) **palliative care** — symptom management + goals of care discussion if applicable; (3) **principles of management**: (a) **glycemic control** — HbA1c < 8 (looser in elderly with comorbidities), continuous glucose monitoring, avoid hypoglycemia; (b) **vascular optimization first** — revascularization improves healing potential + reduces amputation; (c) **smoking cessation** — single largest modifiable factor; (d) **infection control** — culture-targeted antibiotics, surgical resection of infected bone; (e) **wound care + offloading** — total contact cast, removable boot, surgical decompression; (f) **multidisciplinary coordination** + clear communication; (4) **specific decisions**: (a) **partial 1st ray amputation** — for localized OM + offloading; (b) **transmetatarsal amputation** vs **partial foot** vs **below-knee amputation** — based on extent of disease, viability, vascular status, patient functional goals; (c) **Charcot reconstruction** (if active resolved) — stable platform, plantigrade foot — improves bracing + reduces ulceration; (5) **prevention secondary**: (a) **lifetime custom footwear** + offloading; (b) **regular podiatry visits** (every 1-3 months); (c) **patient education**: daily foot inspection, no walking barefoot, appropriate trimming, prompt attention to any wound; (d) **risk reduction**: BP, lipid, glycemic, antiplatelet, statin; (6) **falls + fragility**: (a) home safety assessment, removal of trip hazards, lighting, grab bars; (b) PT for balance + strength; (c) screen + treat osteoporosis (DEXA, calcium + vit D, bisphosphonate caution in ESRD — denosumab + caution hypocalcemia); (d) review meds — discontinue/adjust those increasing fall risk; (7) **goals of care discussion** — patient values, functional priorities, quality of life vs aggressive intervention; (8) **outcomes** — multidisciplinary care reduces amputation + mortality + cost (multiple studies); (9) **palliative + end-of-life considerations** if appropriate

---

Complex diabetic foot: multidisciplinary essential (endo + nephro + vascular + ID + ortho + podiatry + wound care + plastic + CV + PT + OT + nutrition + SW + palliative + diabetes educator). Optimize glycemic (HbA1c < 8 individualized) + revascularize + smoking cessation + culture-targeted antibiotics (no aminoglycoside ESRD) + surgical resection. Charcot reconstruction. Partial vs trans-metatarsal vs BKA based on viability + function + goals. Lifetime offloading + custom shoes + podiatry. Falls prevention. Goals of care. Multidisciplinary reduces amputation + mortality.', NULL,
  'hard', 'msk_nontrauma', 'review',
  'orthopedics', 'integrative', 'msk_nontrauma', 'adult',
  'IWGDF; ADA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Integrative Case**

หญิงไทยอายุ 65 ปี DM2 (HbA1c 9.5%) underlying HT + ESRD on hemodialysis + CAD s/p PCI + peripheral vascular disease (ABI 0.6) + smoker — มี non-healing diabetic foot ulcer + osteomyelitis 1st MT 1 ปี + Charcot midfoot + falls at home

Viable forefoot but chronic non-healing
VS stable

จงอธิบาย integrative multidisciplinary management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Integrative Case**

หญิงไทยอายุ 88 ปี frail (severe dementia, lives in care facility, bed-bound mostly), pre-fracture mRS 5 (severely disabled), underlying CKD stage 4, CHF, AF on apixaban, recurrent UTIs — หกล้มจากเตียง pulled by caregiver, displaced left intertrochanteric hip fracture

Family ต้องการ shared decision-making + considering quality vs aggressive intervention

จงอธิบาย integrative geriatric ortho-palliative approach + shared decision making', '[{"label":"A","text":"Always avoid surgery in patients > 85"},{"label":"B","text":"Frail Elderly Hip Fracture — Integrative Geriatric-Palliative Approach + Shared Decision Making"},{"label":"C","text":"Cultural beliefs irrelevant in medical decisions"},{"label":"D","text":"Surgery always best regardless of frailty + goals"},{"label":"E","text":"Bedrest + traction superior to surgery in any frail patient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Frail Elderly Hip Fracture — Integrative Geriatric-Palliative Approach + Shared Decision Making: (1) **complexity** — extreme frailty + dementia + multiple comorbidities → balance benefits of surgery vs risks, quality of life vs aggressive intervention, patient''s previous values + family wishes; (2) **assessment**: (a) **frailty index** — Clinical Frailty Scale (CFS), Edmonton Frail Scale — quantify; (b) **pre-fracture function** — mRS 5 baseline (severely disabled); (c) **cognition** — dementia severity; (d) **comorbidity** burden — multiple severe; (e) **prognosis** without intervention: bed-bound pain, contractures, pressure ulcers, pneumonia, sepsis → death typically within weeks; (f) **prognosis with surgery**: 30-day mortality 10-20% in frail elderly, 1-year mortality 30-50% (higher with comorbidity), often functional decline + institutionalization; (3) **shared decision-making process**: (a) **identify decision-maker** — patient if capacity (often not in severe dementia), advance directive/living will, healthcare proxy, family consensus + caregiver input; (b) **explore patient values + goals** (prior expressed wishes, religious/cultural beliefs, what patient would have wanted); (c) **present realistic options + outcomes** transparently: (i) **surgical** — hemiarthroplasty or short cephalomedullary nail — preferred for pain control + nursing care + repositioning + avoid pressure ulcers; **even severely frail benefit from surgery** for pain + nursing care + dignity in many cases; (ii) **non-surgical (conservative)** — bedrest + traction + pain control — historically poor outcomes, severe pain, complications (pressure ulcers, pneumonia, contractures, DVT) → almost always worse than surgery for pain + comfort; reserved for: imminent death (hours-days), preference for comfort only, surgical contraindications (e.g., active untreated sepsis); (d) **palliative surgery** concept — surgery for symptom relief (pain) even with limited life expectancy; (e) **explicit goals of care** discussion — comfort, quality, function, dignity; (4) **if surgery chosen**: (a) **anesthesia evaluation** — regional anesthesia (spinal) often preferred over general (less cognitive impact); (b) **anticoagulation reversal** — apixaban — hold + delay surgery 24-48h vs andexanet alfa vs 4-factor PCC; (c) **minimal procedure** — quick stabilization (hemiarthroplasty + cephalomedullary nail), shortest OR time; (d) **multimodal pain control** — fascia iliaca block, scheduled acetaminophen, opioid sparing if possible; (e) **delirium prevention bundle** — minimize sedation, reorient, family presence, sleep hygiene, avoid restraints, early mobilization; (f) **early mobilization + transfer comfort**; (5) **if comfort care chosen**: (a) **adequate pain control** — IV/SC opioid, fascia iliaca block can be used for analgesia, regional anesthesia; (b) **positioning + pressure care** — frequent repositioning, pressure-relieving mattress; (c) **bowel + bladder care**; (d) **mouth care + hydration** (subcutaneous if not oral); (e) **family + caregiver support**; (f) **hospice referral** if applicable; (g) **DNR/DNI discussion**; (6) **multidisciplinary care**: (a) **ortho + geriatrics + palliative care + family medicine** team; (b) **consultative ethics** for difficult cases; (c) **social work + chaplain**; (d) **community + home + hospice services**; (7) **cultural sensitivity in Thai context**: (a) **family-centered decision making** (Thai culture values family consensus, often hierarchical with eldest deciding); (b) **Buddhist beliefs** — karma, suffering, acceptance; (c) **"merit-making" + spiritual rituals** at end of life; (d) **avoiding discussion of death** directly may be culturally preferred; (e) communication with sensitivity, indirect language when appropriate; (e) traditional healing practices respected; (f) extended family involvement; (8) **ethical principles** — beneficence, non-maleficence, autonomy, justice; substituted judgment when patient unable; best interest principle; (9) **documentation** — discussion + decisions + reasoning + parties involved; (10) **respect for patient + family + dignity** throughout

---

Frail elderly hip fracture: assess frailty + cognition + prior function + comorbidity. Shared decision with family/proxy + patient values. Surgery (hemiarthroplasty/CMN) often preferred even in frail for PAIN control + NURSING CARE + dignity (palliative surgery concept). Comfort care for imminent death or preference. Anesthesia: regional > general. Reverse apixaban. Multimodal pain + delirium prevention. Multidisciplinary ortho-geriatric-palliative. Thai cultural sensitivity (family hierarchy, Buddhist, indirect communication). Document discussion.', NULL,
  'hard', 'trauma', 'review',
  'orthopedics', 'integrative', 'trauma', 'adult',
  'AAOS Hip Fracture; AGS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Integrative Case**

หญิงไทยอายุ 88 ปี frail (severe dementia, lives in care facility, bed-bound mostly), pre-fracture mRS 5 (severely disabled), underlying CKD stage 4, CHF, AF on apixaban, recurrent UTIs — หกล้มจากเตียง pulled by caregiver, displaced left intertrochanteric hip fracture

Family ต้องการ shared decision-making + considering quality vs aggressive intervention

จงอธิบาย integrative geriatric ortho-palliative approach + shared decision making'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Integrative Case**

หญิงไทยอายุ 58 ปี breast cancer s/p mastectomy + chemo 5 ปีก่อน metastatic disease (bone + liver + lung) — มี multiple bony mets ทั่ว spine + pelvis + femur + new severe back pain, neurologic decline (saddle anesthesia + LE weakness)

Life expectancy ~ 6 months per oncology

MRI spine: lumbar epidural metastasis L3 with cord compression
X-ray hip: impending pathologic femoral neck fracture Mirels 11

จงอธิบาย integrative oncologic ortho-palliative care', '[{"label":"A","text":"No role for surgery in metastatic cancer"},{"label":"B","text":"Metastatic Cancer with Spinal Cord Compression + Impending Pathologic Fracture — Integrative Oncologic + Palliative + Orthopedic Care"},{"label":"C","text":"Always proceed with maximum aggressive treatment regardless of goals"},{"label":"D","text":"Palliative care not appropriate while undergoing surgery"},{"label":"E","text":"Hospice means giving up on patient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Metastatic Cancer with Spinal Cord Compression + Impending Pathologic Fracture — Integrative Oncologic + Palliative + Orthopedic Care: (1) **multidisciplinary team**: (a) **medical oncology** — primary cancer management, systemic therapy decisions; (b) **radiation oncology** — palliative radiation for bone mets + spinal cord compression; (c) **orthopedic surgery** — surgical decisions for fractures + stabilization; (d) **spine surgery (ortho or neurosurg)** — cord compression management; (e) **palliative care** — symptom management, goals of care, quality of life; (f) **pain medicine** — multimodal analgesia, regional/intrathecal options; (g) **physical therapy + occupational therapy** — function + safety; (h) **chaplain + social work** — spiritual + psychological + practical support; (i) **family + caregivers**; (2) **spinal cord compression — emergency**: (a) **urgent dexamethasone** 10 mg IV then 4 mg q 6h to reduce cord edema + improve neurologic outcome; (b) **MRI confirms diagnosis** + extent of compression; (c) **palliative surgery + radiation** — Patchell trial (Lancet 2005) — surgical decompression + stabilization + radiation superior to radiation alone for ambulation + survival in good-prognosis patients (≥ 3 months life expectancy, single lesion, neurologically symptomatic); (d) **radiation alone** for: poor prognosis (< 3 months), multilevel, paraplegia > 24-48 hours (poor neurologic recovery), unable to tolerate surgery; (e) **surgical procedure** — posterior or combined decompression + instrumented fusion; goal — restore ambulation + pain relief + spinal stability; minimum-invasive approaches reduce morbidity; (3) **impending pathologic fracture (Mirels 11)** — prophylactic fixation preferred over after-fracture: (a) **intramedullary nail (cephalomedullary)** for femoral mets — protects entire bone; (b) **embolization** considered for hypervascular mets (RCC, thyroid — less for breast); (c) **post-op radiation** to surgical site 8 Gy × 1 or 20-30 Gy in 5-10 fractions — prevents local progression + improves durability; (4) **systemic therapy considerations**: (a) **bone-modifying agents** — bisphosphonate (zoledronate) or denosumab monthly — reduces skeletal-related events (SREs), hypercalcemia, pain; monitor ONJ, AFF, hypocalcemia; (b) **systemic cancer therapy** — chemotherapy, targeted (HER2, CDK4/6), endocrine (ER+, AI, fulvestrant), immunotherapy; coordinate with surgery (hold before + restart after wound healing); (c) **hypercalcemia management** — IV fluids, bisphosphonate, calcitonin acute; (5) **pain management**: (a) **multimodal** — scheduled acetaminophen, NSAIDs (caution), opioids titrated, adjuvants (gabapentin, pregabalin for neuropathic, antidepressants for mood + pain); (b) **regional blocks** + neuraxial (epidural, intrathecal pump) for refractory; (c) **vertebroplasty/kyphoplasty** for painful vertebral mets without instability; (d) **palliative radiation** for painful bone mets — 8 Gy single fraction effective; (6) **palliative care principles**: (a) **goals of care discussion** — patient''s values + priorities; (b) **prognosis communication** — honest + compassionate; (c) **symptom management** — pain, dyspnea, nausea, fatigue, anxiety, depression; (d) **quality of life** focus; (e) **spiritual + emotional support**; (f) **caregiver support**; (g) **advance care planning** — directives, DNR, hospice; (7) **shared decision making**: (a) discuss surgical + non-surgical options transparently; (b) realistic outcomes + complications; (c) patient + family values + goals; (d) cultural + religious sensitivity (Buddhist context in Thailand — karma, suffering, family); (e) document decisions; (8) **hospice + end-of-life care** — when appropriate, transition from curative-intent to comfort-focused; bereavement support for family; (9) **transition to end-of-life** — recognize signs (declining function, cachexia, multiple symptoms); ensure comfort, dignity, presence; (10) **survivorship** for those with sustained response — ongoing care + surveillance

---

Metastatic cancer + cord compression + impending fracture: multidisciplinary (onco + RT + ortho/spine + palliative + pain + PT/OT + chaplain + SW + family). Cord compression: urgent dex + MRI + surgical decompression + stabilization + RT (Patchell trial — better ambulation + survival if good prognosis ≥ 3 mo). Impending pathologic fracture (Mirels ≥ 9): prophylactic IM nail + post-op RT. Bisphosphonate/denosumab. Pain: multimodal + regional + palliative RT (8 Gy × 1 effective). Goals of care + palliative + hospice. Cultural sensitivity. Honest prognosis. Shared decision.', NULL,
  'hard', 'hemato_onco', 'review',
  'orthopedics', 'integrative', 'hemato_onco', 'adult',
  'Patchell Lancet 2005; AAOS Metastatic Bone', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Integrative Case**

หญิงไทยอายุ 58 ปี breast cancer s/p mastectomy + chemo 5 ปีก่อน metastatic disease (bone + liver + lung) — มี multiple bony mets ทั่ว spine + pelvis + femur + new severe back pain, neurologic decline (saddle anesthesia + LE weakness)

Life expectancy ~ 6 months per oncology

MRI spine: lumbar epidural metastasis L3 with cord compression
X-ray hip: impending pathologic femoral neck fracture Mirels 11

จงอธิบาย integrative oncologic ortho-palliative care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Integrative Case**

ผู้ป่วยอายุ 28 ปี diving accident → C5 complete SCI (ASIA A) 3 weeks post-injury — paraplegia, intermittent autonomic dysreflexia, pressure ulcer beginning sacrum, neurogenic bladder + bowel, family + patient struggling psychologically

จงอธิบาย integrative SCI rehabilitation + multidisciplinary care + community reintegration', '[{"label":"A","text":"Single specialty (orthopedics alone) sufficient for SCI care"},{"label":"B","text":"Acute-Chronic SCI Rehabilitation — Integrative Multidisciplinary Care"},{"label":"C","text":"Autonomic dysreflexia treated with bedrest only"},{"label":"D","text":"Pressure ulcers do not need prevention"},{"label":"E","text":"Psychological support not needed for SCI patients"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute-Chronic SCI Rehabilitation — Integrative Multidisciplinary Care: (1) **SCI care levels** — acute (hospital) → subacute (SCI rehabilitation unit) → community/home; specialized SCI center improves outcomes (Cochrane); (2) **multidisciplinary team** essential: (a) **physiatry (PM&R)** — coordinates rehabilitation; (b) **orthopedic + spine surgery** — spine stabilization, ongoing musculoskeletal issues; (c) **neurology + neurosurgery** — for neurologic management; (d) **urology** — neurogenic bladder management; (e) **gastroenterology** — bowel program; (f) **plastic surgery + wound care** — pressure ulcer management; (g) **respiratory + pulmonary** — ventilator weaning if applicable, chest PT, sputum management (especially for high cervical); (h) **physical therapy** — mobility, transfers, wheelchair skills, ROM, strength training; (i) **occupational therapy** — ADLs, adaptive equipment, environmental modifications; (j) **speech therapy** — if applicable (swallowing, communication); (k) **psychology + psychiatry** — depression (50% in SCI), anxiety, PTSD, adjustment; (l) **social work + case management** — discharge planning, community resources, vocational; (m) **nutrition** — protein-calorie for wound healing, weight management; (n) **chaplain** — spiritual support; (o) **vocational rehabilitation** — return to work, education; (p) **peer support** — connecting with others who have SCI; (q) **family + caregivers** — education, training, support; (3) **specific medical management**: (a) **autonomic dysreflexia (AD)** — life-threatening, T6 + above injury — sudden hypertension + bradycardia + sweating above injury + flushing/pallor below from noxious stimulus (bladder distension > 75%, bowel impaction, pressure ulcer, UTI, tight clothing, ingrown nail) — **emergency**: (i) sit patient upright (orthostatic drop), (ii) loosen tight clothing, (iii) identify + remove noxious stimulus (catheterize bladder if no catheter or check existing catheter, disimpact bowel, examine skin), (iv) antihypertensive if BP > 150-160 (nifedipine 10 mg SL, nitrate spray, captopril), (v) prevention — bladder/bowel program, skin care, ingrown nail prevention; (b) **neurogenic bladder**: detrusor-sphincter dyssynergia common with C5 injury → **intermittent catheterization q 4-6h** preferred (avoids long-term indwelling catheter complications), anticholinergic (oxybutynin, mirabegron) to reduce detrusor overactivity, alpha-blocker for sphincter relaxation, Botox detrusor injection, urodynamic studies; (c) **neurogenic bowel**: scheduled bowel program (digital stimulation + suppository + manual evacuation q 1-2 days), high-fiber diet, adequate fluid, stool softeners, address constipation/impaction; (d) **pressure ulcer prevention + management**: pressure-relieving cushion + mattress, **turn q 2 hours** in bed, **weight shifts q 15 min** in wheelchair, skin inspection daily, nutrition, hydration, treat existing ulcer (debride, dress, off-load, may need flap reconstruction); (e) **VTE prophylaxis** — high risk in SCI (immobility) — LMWH + mechanical; (f) **respiratory care** — chest PT, assisted cough, monitoring for pneumonia; (g) **spasticity management** — baclofen, tizanidine, gabapentin, Botox injection, intrathecal baclofen pump for severe; (h) **pain management** — neuropathic pain common — gabapentin/pregabalin, antidepressants, opioid sparing; (i) **heterotopic ossification** — common in SCI (around hips/knees), aggressive PT, indomethacin, radiation; surgery if functional limitation; (4) **psychological + emotional**: (a) grief + adjustment to disability; (b) depression screening + treatment; (c) suicide risk assessment; (d) peer support; (e) family counseling; (f) gradual acceptance + adaptation; (5) **community reintegration**: (a) home modifications — accessible, ramps, bathroom adaptations; (b) vehicle adaptations; (c) vocational rehabilitation — return to work, education; (d) recreational activities — adaptive sports; (e) sexual function counseling + management; (f) fertility considerations; (g) durable medical equipment + power wheelchair; (h) personal care attendant + nursing if needed; (i) advocacy + disability rights; (6) **long-term complications + surveillance**: (a) UTI, urolithiasis, renal dysfunction; (b) cardiovascular disease; (c) DVT/PE; (d) pneumonia; (e) shoulder pain (overuse from wheelchair propulsion); (f) syringomyelia (late); (g) carpal tunnel (chronic); (h) accelerated aging; (i) screening + prevention; (7) **Thai context** — family support strong, may want intensive caregiver presence; cultural acceptance of disability evolving; Buddhist karma framework may help acceptance; spiritual resources

---

SCI rehabilitation: multidisciplinary (PM&R + ortho + uro + GI + plastic + wound + respiratory + PT + OT + psych + SW + chaplain + vocational + peer + family). Autonomic dysreflexia (T6+) = EMERGENCY: sit upright + remove stimulus (bladder distension #1) + antihypertensive. Neurogenic bladder: IC q 4-6h. Bowel program. Pressure ulcer prevention (q 2h turn, q 15 min wheelchair shift, off-load). VTE prophylaxis. Spasticity. Neuropathic pain. Heterotopic ossification. Psychological + family adjustment. Community reintegration + home modification + vocational. Long-term surveillance (UTI, CV, shoulder overuse).', NULL,
  'hard', 'neurology', 'review',
  'orthopedics', 'integrative', 'neurology', 'adult',
  'ASIA; PVA SCI Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Integrative Case**

ผู้ป่วยอายุ 28 ปี diving accident → C5 complete SCI (ASIA A) 3 weeks post-injury — paraplegia, intermittent autonomic dysreflexia, pressure ulcer beginning sacrum, neurogenic bladder + bowel, family + patient struggling psychologically

จงอธิบาย integrative SCI rehabilitation + multidisciplinary care + community reintegration'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Integrative Case**

เด็กชายอายุ 10 ปี cerebral palsy (spastic diplegia, GMFCS III) lower limb contractures + scoliosis 35° + hip subluxation + crouch gait + hip pain ลำบากในการเดิน + parents request improvement

VS stable

จงอธิบาย integrative CP management — multidisciplinary + decision tree + outcomes', '[{"label":"A","text":"Single staged surgery best in CP"},{"label":"B","text":"Cerebral Palsy — Integrative Multidisciplinary Care + Surgical Planning"},{"label":"C","text":"Spasticity management not needed in CP"},{"label":"D","text":"Hip surveillance unnecessary in CP"},{"label":"E","text":"Orthopedic surgery without rehabilitation sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cerebral Palsy — Integrative Multidisciplinary Care + Surgical Planning: (1) **cerebral palsy** — non-progressive disorder of movement + posture from CNS lesion before, during, or shortly after birth; spectrum of severity; commonly classified by motor type (spastic, dyskinetic, ataxic, mixed) + distribution (hemiplegia, diplegia, quadriplegia) + functional level; (2) **GMFCS (Gross Motor Function Classification System)** — 5 levels: I (walks without limitation) → II (walks with limitation) → III (walks with assistive device) → IV (limited self-mobility, may use powered) → V (transported in wheelchair); useful for prognosis + planning; this patient GMFCS III; (3) **multidisciplinary team**: (a) **developmental pediatrician** — overall care coordination; (b) **physical medicine + rehabilitation** — function, equipment; (c) **pediatric orthopedic surgery** — musculoskeletal; (d) **pediatric neurology** — seizures, spasticity, baclofen; (e) **neurosurgery** — selective dorsal rhizotomy (SDR), intrathecal baclofen pump for severe spasticity; (f) **physical therapy + occupational therapy** — function, daily living; (g) **speech therapy** — feeding, communication; (h) **orthotist** — AFOs, KAFOs, custom orthoses; (i) **gastroenterology + nutrition** — feeding tube, growth; (j) **psychology + social work** — family support, education advocacy, IEP; (k) **adaptive equipment specialists** — wheelchairs, assistive devices; (l) **gait analysis lab** for surgical planning; (4) **principles of management**: (a) **goals individualized** — function, comfort, prevention of secondary deformity, family priorities, child''s voice when possible; (b) **timing** — surgical interventions often best at age 6-12 (skeletal maturity, growth potential, gait pattern stable); (c) **prevention** — earlier intervention often better than late corrective surgery; (d) **multilevel + single-event multilevel surgery (SEMLS)** — modern trend — combine all needed procedures in one operation (single anesthesia, single recovery, addresses all levels simultaneously) — superior outcomes vs staged approach for CP; (5) **specific interventions**: (a) **spasticity management** — baclofen (oral), benzodiazepines, tizanidine, dantrolene; **botulinum toxin injection** for focal spasticity (gastrocnemius, hamstrings, adductors) — reduces spasticity, improves PT effectiveness, 3-6 month effect; **selective dorsal rhizotomy (SDR)** — neurosurgical procedure for spastic diplegia, age 4-8 typically, GMFCS II-III + spasticity, modest evidence for selected patients; **intrathecal baclofen pump** for severe spasticity (GMFCS IV-V); (b) **orthopedic surgery** based on specific deformity + functional need: (i) **hip surveillance + management** — annual hip X-ray (migration percentage), prevent dislocation; varus derotation osteotomy + adductor + iliopsoas lengthening, pelvic osteotomy for severe; (ii) **knee + hamstring contracture** — hamstring lengthening, distal femoral extension osteotomy for fixed flexion deformity, patellar tendon advancement for crouch; (iii) **foot + ankle** — gastrocnemius/Achilles lengthening (Strayer, Hoke), tibialis posterior lengthening, plantar release, calcaneal osteotomy; (iv) **rotational deformity** — derotational osteotomies (femoral, tibial); (v) **scoliosis** — bracing for moderate progressive (50-90°), surgical fusion for severe (> 90° + progression); (c) **AFO + orthoses** — improves gait + reduces equinus + prevents progression; (d) **assistive devices** — walker, crutches, wheelchairs; (e) **adaptive equipment** for ADLs; (6) **gait analysis** — 3D motion capture + force plate + EMG for surgical planning in CP — particularly for SEMLS planning, identifies primary vs compensatory deformities, predicts outcomes; (7) **post-op rehabilitation intensive** — PT for 6-12 months for SEMLS, gradual return to activity, prevention of recurrence; (8) **transitions of care** — adolescent → adult ortho care + adult medicine; vocational + educational + housing transition; (9) **family-centered care** — parents as partners, education, advocacy, respite, support groups; (10) **Thai context** — strong family involvement, multidisciplinary care available at university hospitals + specialty centers, some community resources

---

CP management: multidisciplinary (developmental peds + PM&R + peds ortho + neuro + neurosurg + PT/OT + speech + orthotist + GI + psych + SW). GMFCS classification guides. Spasticity: oral meds + Botox + SDR + intrathecal baclofen. Single-event multilevel surgery (SEMLS) age 6-12 — combine all needed procedures (hip + knee + foot + rotation). Hip surveillance (migration %) prevents dislocation. Gait analysis lab for SEMLS planning. Scoliosis bracing/fusion. Post-op intensive PT 6-12 months. Family-centered. Transitions of care. AFOs + adaptive equipment.', NULL,
  'hard', 'neurology', 'review',
  'orthopedics', 'integrative', 'neurology', 'peds',
  'Gross Motor Function Classification System', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Integrative Case**

เด็กชายอายุ 10 ปี cerebral palsy (spastic diplegia, GMFCS III) lower limb contractures + scoliosis 35° + hip subluxation + crouch gait + hip pain ลำบากในการเดิน + parents request improvement

VS stable

จงอธิบาย integrative CP management — multidisciplinary + decision tree + outcomes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Integrative Case**

หญิงไทยอายุ 22 ปี HbSS sickle cell disease — chronic painful crises, multiple admissions, AVN bilateral femoral heads (Steinberg III), recent painful crisis + femoral neck stress fracture

จงอธิบาย integrative SCD + orthopedic management', '[{"label":"A","text":"Avoid all transfusion in SCD patients before surgery"},{"label":"B","text":"Sickle Cell Disease + Orthopedic Manifestations — Integrative Care"},{"label":"C","text":"Tourniquet always safe in SCD"},{"label":"D","text":"S. aureus only osteomyelitis pathogen in SCD"},{"label":"E","text":"Cold temperature beneficial in SCD"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Sickle Cell Disease + Orthopedic Manifestations — Integrative Care: (1) **multidisciplinary team**: (a) **hematology** — primary SCD management, transfusion, hydroxyurea, voxelotor, crizanlizumab, gene therapy considerations; (b) **orthopedic surgery** — AVN management, osteomyelitis, stress fracture, joint replacement timing; (c) **pain management + chronic pain** — multimodal analgesia, opioid stewardship, integrative approaches; (d) **infectious disease** — osteomyelitis (Salmonella common), septic arthritis; (e) **emergency medicine** — acute crisis management; (f) **transfusion medicine** — exchange transfusion for pre-op + crisis; (g) **anesthesiology** — perioperative SCD considerations; (h) **psychology** — chronic disease + pain + mental health; (i) **social work** — adherence, support; (j) **family medicine + primary care**; (2) **orthopedic manifestations of SCD**: (a) **avascular necrosis (AVN)** — most common — femoral head (most), humeral head, talus, knee — from vaso-occlusive microvascular obstruction; (b) **osteomyelitis** — **Salmonella** > S. aureus (SCD specific — Salmonella from gut translocation in functional asplenia + vaso-occlusion); (c) **acute crisis** — bone pain from vaso-occlusion (any site); (d) **dactylitis** — early childhood hand-foot syndrome; (e) **growth + development** — delayed; (f) **leg ulcers** — chronic; (g) **stress fractures** — from chronic anemia + osteoporosis + altered biomechanics; (3) **AVN femoral head management** — staged approach (Steinberg/Ficat classification): (a) **early (pre-collapse)** — core decompression ± bone marrow aspirate concentrate (BMAC) injection → potentially preserves head; (b) **moderate** — vascularized fibular graft + core decompression — younger patients; (c) **collapse with arthritis** — **total hip arthroplasty (THA)** — earlier than typical OA THA (often 30s-40s); higher complication rate vs general population (infection 5-10%, dislocation, revision); (d) special considerations for THA in SCD: (i) hematology optimization pre-op (transfusion to target hemoglobin S < 30%), (ii) hydration + warmth + oxygen perioperatively to prevent crisis, (iii) careful anesthesia, (iv) longer hospital stay + monitoring, (v) higher complication rate but improved QoL + function in young SCD patient; (4) **stress fracture management**: (a) protected weight-bearing + crutches; (b) MRI/CT to characterize; (c) consider surgical fixation for high-risk locations (tension-side femoral neck); (d) address underlying SCD optimization; (5) **osteomyelitis SCD-specific**: (a) **Salmonella + S. aureus** coverage — ceftriaxone + cefazolin (or vancomycin if MRSA risk); (b) surgical drainage as indicated; (c) prolonged antibiotic therapy (6+ weeks); (d) optimize SCD; (6) **perioperative SCD management** — critical to prevent crisis: (a) **hydration** — IV fluid 1.5x maintenance pre/intra/post-op; (b) **oxygenation** — SpO2 > 95%, supplemental O2 as needed; (c) **temperature** — keep warm (cold triggers crisis); (d) **transfusion** — preoperative transfusion to target Hb 10 + HbS < 30% (Bachy/TAPS trials — exchange transfusion may not be required for most surgeries; simple transfusion or selective approach); (e) **pain management** — multimodal, scheduled, may need higher opioid doses (tolerance + chronic pain), avoid undertreatment which can trigger crisis; (f) **avoid tourniquet** when possible (vaso-occlusion); (g) **monitor for crisis** — acute chest syndrome (chest pain, fever, hypoxia, infiltrate) — most feared post-op complication; (h) **VTE prophylaxis** — increased risk; (i) **multidisciplinary planning**; (7) **chronic pain management**: (a) **multimodal** — non-opioid scheduled (acetaminophen, NSAIDs cautiously), neuropathic agents (gabapentin), regional blocks for procedures; (b) **opioid stewardship** — chronic pain + tolerance challenges; structured approach; (c) **integrative** — PT, acupuncture, mindfulness, CBT; (d) **mental health** — depression + anxiety common; (8) **SCD modifying therapy**: (a) **hydroxyurea** — increases HbF, reduces crises + ACS + transfusions + mortality; standard of care; (b) **L-glutamine** — adjunct; (c) **voxelotor** — increases HbF binding to oxygen; (d) **crizanlizumab** — anti-P-selectin, reduces crises; (e) **transfusion therapy** for selected; (f) **stem cell transplant** + **gene therapy** — curative options emerging; (9) **patient + family education + self-management** — early recognition of crisis, hydration, avoiding triggers; (10) **transitions** — pediatric to adult care

---

SCD + ortho: multidisciplinary (heme + ortho + pain + ID + transfusion + anesthesia + psych + SW). Orthopedic: AVN (most common — femoral head — core decompression early; THA for collapse — earlier than typical, higher complication rate), osteomyelitis (Salmonella + S. aureus), stress fracture, dactylitis. Perioperative: hydration + oxygen + warm + transfusion (Hb 10 + HbS < 30%, Bachy/TAPS — selective exchange) + multimodal pain + monitor for ACS (chest crisis). Hydroxyurea + modern SCD therapy. Chronic pain stewardship. Transitions.', NULL,
  'hard', 'hemato_onco', 'review',
  'orthopedics', 'integrative', 'hemato_onco', 'adult',
  'ASH SCD Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Integrative Case**

หญิงไทยอายุ 22 ปี HbSS sickle cell disease — chronic painful crises, multiple admissions, AVN bilateral femoral heads (Steinberg III), recent painful crisis + femoral neck stress fracture

จงอธิบาย integrative SCD + orthopedic management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Integrative Case**

ชายไทยอายุ 32 ปี hemophilia A (severe, < 1% factor VIII), recurrent hemarthroses since childhood → chronic hemophilic arthropathy bilateral knees + ankles, target joints, on prophylactic factor VIII

Failed conservative — pain + dysfunction interfering with work + family activities

จงอธิบาย integrative hemophilia + ortho management', '[{"label":"A","text":"Hemophilia patients should not undergo joint replacement"},{"label":"B","text":"Hemophilia + Orthopedic Surgery (Joint Arthroplasty) — Integrative Care"},{"label":"C","text":"Factor replacement not needed for surgery"},{"label":"D","text":"Inhibitor status irrelevant"},{"label":"E","text":"Emicizumab provides complete hemostasis during surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hemophilia + Orthopedic Surgery (Joint Arthroplasty) — Integrative Care: (1) **multidisciplinary team essential**: (a) **hematology + hemophilia treatment center (HTC)** — primary management, factor levels, inhibitor screening, perioperative factor replacement planning; (b) **orthopedic surgery (familiar with hemophilia)** — joint preservation procedures, arthroplasty when indicated; (c) **physical therapy** — joint preservation, post-op rehabilitation; (d) **hepatology** — many older patients have HCV from prior transfusions, ongoing surveillance + treatment; (e) **psychology + social work** — chronic disease, mental health, work + family; (f) **infectious disease** — HIV/HCV management, perioperative infection considerations; (g) **anesthesiology familiar with hemophilia**; (h) **dental + GU + medical specialties** for comorbidity; (2) **hemophilic arthropathy** — chronic disease from recurrent intra-articular hemorrhage: (a) **pathophysiology** — synovitis from iron deposition + cytokine release → cartilage damage → joint destruction → secondary OA-like changes; (b) **target joints** — joints with > 3 bleeds in 6 months — increased risk progression; (c) **common joints** — knees > ankles > elbows; (d) **Pettersson score** radiographic grading; (3) **management algorithm**: (a) **primary prevention — prophylactic factor replacement** — standard of care for severe hemophilia, reduces bleeds + arthropathy progression; modern extended half-life factor concentrates + non-factor therapy (emicizumab — bispecific antibody mimicking factor VIIIa, subQ weekly-monthly — reduces bleeds without need for factor); (b) **acute hemarthrosis**: (i) **immediate factor replacement** (target 80-100% for severe hemarthrosis), (ii) RICE, immobilization 24-48h, (iii) joint aspiration controversial — most spontaneously resolves, aspiration considered for tense painful joint not improving with factor; (c) **chronic synovitis**: (i) intensive prophylaxis, (ii) **radioactive synovectomy (radiosynoviorthesis)** — Yttrium-90, Phosphorus-32 — outpatient, effective for chronic synovitis, may reduce bleeds + slow progression, alternative to surgical synovectomy; (iii) **surgical synovectomy** (arthroscopic) for selected; (d) **end-stage arthropathy** — **total joint arthroplasty (TJA)** — when conservative measures fail + significant pain/disability + advanced radiographic disease: (i) **TKA** most common; (ii) **THA, total ankle arthroplasty (TAA), elbow arthroplasty** also performed; (iii) **outcomes** — improved pain + function comparable to non-hemophilic patients but higher complication rates; (4) **perioperative factor management — essential to prevent bleeding complications**: (a) **pre-op planning** with hematology — factor VIII/IX levels, inhibitor screen (especially severe hemophilia A — 25-30% develop inhibitors), pharmacokinetic study; (b) **factor replacement protocol** for major surgery (joint arthroplasty): (i) target 80-100% pre-op + intra-op + postop day 1-3, (ii) gradually decreasing levels 50-80% × 3-7 days, then 30-50% × additional days based on procedure; (iii) duration of replacement 10-14 days total typically (continued during rehabilitation); (iv) **continuous infusion vs intermittent bolus** options; (c) **inhibitor management** — if patient has inhibitors → bypassing agents (recombinant factor VIIa — NovoSeven; activated prothrombin complex concentrate — FEIBA); higher risk + cost + complexity; consider ITI (immune tolerance induction) before elective surgery; (d) **emicizumab patients** — modern non-factor therapy — does NOT replace factor for bleeding; still need factor for hemostasis during surgery; specific perioperative protocols; (e) **monitor factor levels** during peri-op; (5) **anesthesia considerations** — regional anesthesia (especially neuraxial) requires careful factor coverage; epidural hematoma risk; (6) **VTE prophylaxis** — controversial in hemophilia (consider mechanical only initially, selective chemical with factor replacement); (7) **post-op care**: (a) factor replacement continuation, (b) gentle PT (avoid bleeding), (c) infection monitoring (higher PJI risk in HCV+/HIV+ historically — controversial), (d) drains carefully managed; (8) **specific complications**: (a) bleeding (intra/post-op), (b) PJI (slightly higher than general population), (c) wound healing, (d) DVT/PE, (e) recurrent hemarthrosis if factor coverage inadequate; (9) **patient + family education**: bleed recognition, self-infusion if applicable, post-op management, when to seek care; (10) **modern advances** — gene therapy for hemophilia (etranacogene dezaparvovec for hemophilia B, valoctocogene roxaparvovec for hemophilia A) — curative potential

---

Hemophilia + arthropathy: multidisciplinary (heme/HTC + ortho + PT + anesthesia + hepatology + ID + psych). Pathophysiology: recurrent hemarthrosis → synovitis → joint destruction. Algorithm: PROPHYLACTIC factor replacement (standard) → acute hemarthrosis (factor + RICE) → chronic synovitis (radiosynovectomy/surgical) → end-stage (TJA). Perioperative factor: 80-100% pre + early, then taper × 10-14 days. INHIBITOR screen — if positive, bypassing agents (rFVIIa, FEIBA) + complexity. Emicizumab patients still need factor. Modern: gene therapy emerging.', NULL,
  'hard', 'hemato_onco', 'review',
  'orthopedics', 'integrative', 'hemato_onco', 'adult',
  'WFH', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Integrative Case**

ชายไทยอายุ 32 ปี hemophilia A (severe, < 1% factor VIII), recurrent hemarthroses since childhood → chronic hemophilic arthropathy bilateral knees + ankles, target joints, on prophylactic factor VIII

Failed conservative — pain + dysfunction interfering with work + family activities

จงอธิบาย integrative hemophilia + ortho management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Integrative Case**

หญิงไทยอายุ 28 ปี 28 weeks pregnant ตกบันได ปวดข้อมือ + back + ankle

VS stable, fetal HR normal

จงอธิบาย integrative considerations — pregnancy + orthopedic injury (imaging, anesthesia, medication, surgical timing)', '[{"label":"A","text":"Never image pregnant women for any indication"},{"label":"B","text":"Pregnancy + Orthopedic Injury — Integrative Multidisciplinary Considerations"},{"label":"C","text":"Warfarin safe in pregnancy"},{"label":"D","text":"NSAIDs first-line after 20 weeks"},{"label":"E","text":"All elective surgery contraindicated in pregnancy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pregnancy + Orthopedic Injury — Integrative Multidisciplinary Considerations: (1) **multidisciplinary team**: (a) **obstetrics** — fetal monitoring, placental abruption assessment, maternal-fetal medicine for high-risk; (b) **orthopedic surgery** — injury management; (c) **anesthesia** — pregnancy-safe agents + technique; (d) **radiology** — imaging selection + shielding; (e) **pharmacy** — pregnancy category review; (f) **family** + support; (2) **imaging considerations** — ALL emergency/necessary imaging should NOT be withheld for pregnancy concern (delayed diagnosis worse than minor radiation): (a) **X-ray** — minimal fetal exposure (single extremity X-ray < 0.01 mGy — well below 50 mGy fetal threshold); **shield abdomen + pelvis** with lead apron; informed consent + counseling; (b) **CT** — higher radiation; **abdomen/pelvis CT** ~ 25 mGy fetal exposure (below threshold); when needed (life-threatening), perform; minimize dose with low-dose protocols; (c) **MRI** — preferred for many indications (no ionizing radiation); **gadolinium contraindicated** in pregnancy (placental crossing, theoretical fetal harm), use non-contrast when possible; (d) **ultrasound** — completely safe; (e) **fluoroscopy** — minimize use during surgery, use shielding; (f) **nuclear medicine** — usually avoided; (3) **anesthesia considerations**: (a) **physiologic changes** — increased cardiac output, decreased FRC, increased aspiration risk, supine hypotension syndrome (after 20 weeks — tilt left 15° to displace gravid uterus from IVC), increased airway edema (smaller ETT), increased oxygen demand; (b) **regional anesthesia preferred** when feasible — avoids systemic medications, reduces aspiration risk; epidural/spinal commonly used for lower extremity surgery; brachial plexus block for upper extremity; (c) **general anesthesia** — rapid sequence intubation (full stomach), pre-oxygenation, avoid hypotension + hypoxia; many anesthetics safe in pregnancy when needed for maternal indication; (d) **fetal monitoring** intra-operatively if viable; obstetric backup; (e) **post-op pain management** — discussed below; (4) **medications + pregnancy**: (a) **acetaminophen** — first-line analgesic, generally safe (FDA Cat B); (b) **NSAIDs** — **avoid after 20 weeks** (third trimester) — premature ductus arteriosus closure, oligohydramnios, renal effects; short-term use early pregnancy OK; (c) **opioids** — short-term use generally safe; risks: respiratory depression neonatal if used near delivery, neonatal abstinence syndrome with chronic use; codeine + tramadol — caution (metabolizer variability); morphine acceptable; (d) **antibiotics** — generally safe: penicillins, cephalosporins, clindamycin; **avoid**: fluoroquinolones (cartilage), tetracyclines (teeth, bone), sulfonamides (third trimester — kernicterus); (e) **anticoagulation** — **LMWH preferred** (does not cross placenta); warfarin — teratogenic (warfarin embryopathy weeks 6-12, fetal hemorrhage near term); DOACs — limited data, avoid; (f) **DVT prophylaxis** — pregnancy is hypercoagulable state, LMWH if prolonged immobilization or surgery; (g) **steroids** — generally safe; betamethasone for fetal lung maturation if preterm delivery risk; (h) **tetanus toxoid** — safe in pregnancy; (i) **review FDA category** before any new medication; (5) **surgical timing**: (a) **emergent surgery** — perform regardless of trimester (maternal life > fetal); (b) **urgent surgery** — second trimester preferred when possible (lowest teratogenic + obstetric risk; first trimester — organogenesis, miscarriage; third trimester — preterm labor, technical difficulty); (c) **elective surgery** — postpone to after delivery; (d) **lateral positioning + tilt** to avoid IVC compression (after 20 weeks); (e) **fetal heart rate monitoring** before, during (if viable + practical), after surgery; (6) **DVT/VTE risk** — pregnancy hypercoagulable + immobility + trauma; mechanical + chemical prophylaxis as appropriate; (7) **trauma considerations**: (a) **fetal assessment** — fetal heart rate, biophysical profile; (b) **placental abruption screening** — Kleihauer-Betke test (fetal-maternal hemorrhage); (c) **uterine + placental** assessment; (d) **Rh immunoglobulin** if Rh-negative mother with possible fetal-maternal hemorrhage; (e) **obstetric consultation** for any trauma in pregnancy; (8) **shared decision-making + informed consent** — discuss risks/benefits with patient; sensitivity to maternal-fetal dual concerns; (9) **postpartum considerations** for definitive treatment if elective surgery deferred

---

Pregnancy + ortho: multidisciplinary (OB + ortho + anesthesia + radiology). Imaging: X-ray with lead shielding safe; CT when needed (single extremity OK; abdomen with thought); MRI preferred (no radiation), AVOID gadolinium. Anesthesia: regional > general (when feasible); RSI for GA (aspiration risk); lateral tilt > 20 weeks. Meds: acetaminophen safe, AVOID NSAIDs > 20 weeks (DA closure), opioids short-term OK, penicillin/ceph + clinda safe (avoid FQ, tetracycline, sulfa). Anticoagulation: LMWH preferred (warfarin teratogenic). Surgery: emergent any time; elective delay to second trimester or postpartum. Fetal monitoring. Rh Ig if needed.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'integrative', 'msk_nontrauma', 'adult',
  'ACOG; AAOS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Integrative Case**

หญิงไทยอายุ 28 ปี 28 weeks pregnant ตกบันได ปวดข้อมือ + back + ankle

VS stable, fetal HR normal

จงอธิบาย integrative considerations — pregnancy + orthopedic injury (imaging, anesthesia, medication, surgical timing)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Integrative Case**

ชายไทยอายุ 35 ปี IV drug user, chronic homeless ปวด + บวมข้อเข่าขวา + ไข้สูง 4 วัน — septic arthritis confirmed (joint aspiration positive)

Concurrent — new murmur, blood culture S. aureus, TTE shows tricuspid valve vegetation + multiple septic pulmonary emboli on CT chest

จงอธิบาย integrative management — addiction + infectious + orthopedic + harm reduction', '[{"label":"A","text":"Discharge AMA acceptable for non-adherent IV drug users"},{"label":"B","text":"Substance Use Disorder + Septic Arthritis + Endocarditis — Integrative Care"},{"label":"C","text":"MOUD not appropriate during acute admission"},{"label":"D","text":"Methadone + buprenorphine ineffective for OUD"},{"label":"E","text":"Harm reduction encourages drug use"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Substance Use Disorder + Septic Arthritis + Endocarditis — Integrative Care: (1) **multidisciplinary team**: (a) **infectious disease** — antibiotic management, source control coordination; (b) **orthopedic surgery** — septic arthritis surgical management; (c) **cardiology + cardiothoracic surgery** — endocarditis management, possible valve surgery; (d) **addiction medicine** — opioid use disorder (OUD) management, harm reduction, treatment options; (e) **internal medicine/hospitalist** — overall care coordination; (f) **psychiatry** — co-occurring disorders, mental health; (g) **social work** — housing, social services, post-discharge planning; (h) **case management**; (i) **peer support** — peer recovery coaches; (j) **palliative care** for chronic illness symptom management + goals of care; (k) **public health** for HIV/HCV screening + treatment; (2) **acute medical management**: (a) **sepsis bundle** — early IV antibiotic within 1 hour, fluid resuscitation, source control, monitor for septic shock; (b) **blood culture × 2-3 sites** before antibiotics + intra-op tissue cultures; (c) **empirical antibiotic — vancomycin + ceftriaxone (or cefepime)** — cover MRSA + gram-negative + Streptococcus; modify per culture + sensitivity; **MSSA confirmed** → transition to **cefazolin or nafcillin/oxacillin** (more effective than vancomycin for MSSA); (3) **orthopedic management — septic arthritis**: (a) **emergent arthrotomy + irrigation + debridement** of knee joint within 24 hours; (b) **arthroscopic** vs **open** — both acceptable; arthroscopic less morbidity, requires expertise; (c) **repeat drainage** if persistent symptoms + WBC/CRP; (d) cultures + sensitivities → guide antibiotic; (e) **IV antibiotic 2-4 weeks then transition oral** in modern practice for total 4-6 weeks; (f) **post-treatment** — joint damage common → secondary OA + chronic pain; (4) **endocarditis management** — life-threatening: (a) **prolonged IV antibiotic** — 4-6 weeks minimum (right-sided IE — 2-6 weeks acceptable for uncomplicated MSSA per recent evidence); (b) **TEE** for definitive vegetation + complications assessment; (c) **valve surgery indications** — uncontrolled infection, heart failure, large vegetations + embolic events, persistent bacteremia, perivalvular complications — usually right-sided IE managed medically unless complications; (d) **screening for other complications** — septic emboli (chest CT done — shows pulmonary septic emboli), brain MRI for CNS emboli, abdominal imaging for splenic/renal abscess; (5) **substance use disorder management — harm reduction + treatment**: (a) **opioid use disorder (OUD)** in IV drug user — life-threatening relapse + overdose risk + ongoing infections; (b) **medications for OUD (MOUD)** — evidence-based: (i) **methadone** — full agonist, requires daily clinic visits (in Thailand — methadone clinics expanding), (ii) **buprenorphine** — partial agonist, can be initiated in hospital, increasingly accessible, (iii) **extended-release naltrexone** — opioid antagonist, post-detox; (c) **initiation in hospital + warm handoff** to outpatient program reduces relapse + readmission + mortality (low-barrier access); (d) **harm reduction** — needle exchange programs, safer use education, naloxone training + distribution, syringe access; (e) **withdrawal management** — clonidine, anti-emetics, supportive; (f) **co-occurring substance use** — alcohol, methamphetamine, others; (g) **mental health comorbidity** — depression, anxiety, PTSD, trauma history common — co-occurring treatment; (6) **infection prevention going forward**: (a) HIV + HCV screening (offer PrEP, treat HCV); (b) tetanus + Hepatitis B vaccination; (c) skin + soft tissue infection prevention education; (7) **social determinants**: (a) **homelessness** — major obstacle to recovery + treatment adherence; (b) **housing** — supportive housing referral, shelter placement, Housing First model; (c) **food security**; (d) **transportation** for ongoing care; (e) **financial** — disability assessment, public benefits; (f) **legal issues**; (g) **family/social** — connect with supports if available; (8) **stigma reduction + therapeutic alliance**: (a) **compassionate non-judgmental care** — addiction is medical disease, not moral failing; (b) build trust + therapeutic relationship; (c) avoid early discharge against medical advice (AMA) — facilitate adequate care for medical condition; (d) **provider education** on SUD reduces stigma + improves care; (9) **post-discharge planning + warm handoff** — addiction treatment program, primary care, ID follow-up, mental health, peer support, housing; (10) **ethics + dignity** — respect for patient regardless of circumstances, harm reduction philosophy

---

IV drug user + septic arthritis + endocarditis: multidisciplinary (ID + ortho + cardiology/CT surg + addiction medicine + psych + SW + peer + public health). Sepsis bundle + empirical vanc + ceftriaxone → MSSA → cefazolin. Emergent arthrotomy/arthroscopic I&D + antibiotic 4-6 wk. TEE + screen septic emboli (chest, brain, abdomen). Endocarditis Rx 4-6 wk; surgery for complications. **MOUD essential — methadone, buprenorphine (start in hospital), naltrexone** + warm handoff (reduces relapse + mortality). Harm reduction (needle exchange, naloxone). HIV/HCV screen. Housing/food/transport. Compassionate, non-judgmental.', NULL,
  'hard', 'id', 'review',
  'orthopedics', 'integrative', 'id', 'adult',
  'IDSA; SAMHSA MOUD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Integrative Case**

ชายไทยอายุ 35 ปี IV drug user, chronic homeless ปวด + บวมข้อเข่าขวา + ไข้สูง 4 วัน — septic arthritis confirmed (joint aspiration positive)

Concurrent — new murmur, blood culture S. aureus, TTE shows tricuspid valve vegetation + multiple septic pulmonary emboli on CT chest

จงอธิบาย integrative management — addiction + infectious + orthopedic + harm reduction'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Integrative Case**

ผู้ป่วยอายุ 75 ปี end-stage metastatic prostate cancer (widespread bony mets), bed-bound, life expectancy weeks, ปวด chronic + acute exacerbation from pathological pelvic + spine fractures

Family wants comfort focus, declining surgery

จงอธิบาย integrative end-of-life ortho-palliative care', '[{"label":"A","text":"No role for any orthopedic intervention in end-of-life care"},{"label":"B","text":"End-of-Life Care + Skeletal Symptoms — Integrative Palliative Approach"},{"label":"C","text":"Opioids should be PRN only for chronic cancer pain"},{"label":"D","text":"Cultural considerations not relevant in end-of-life care"},{"label":"E","text":"Aggressive interventions always indicated until death"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** End-of-Life Care + Skeletal Symptoms — Integrative Palliative Approach: (1) **shift from curative to comfort-focused care** — recognize transition; principle of beneficence + autonomy + respect for patient''s wishes; (2) **multidisciplinary palliative team**: (a) **palliative medicine** — symptom management, prognostication, goals of care; (b) **hospice services** — home-based or facility-based comfort care; (c) **pain medicine** — refractory pain expertise; (d) **orthopedic palliative care** — selective interventions for QOL only; (e) **radiation oncology** — palliative radiation for bone pain; (f) **chaplaincy / spiritual care** — Buddhist monk in Thai context, other traditions; (g) **social work + case management** — practical support, financial, family; (h) **psychology + counseling** — psychological support for patient + family; (i) **family + caregivers** — central + supported; (3) **goals of care discussion**: (a) **explore patient''s values + wishes** — quality > quantity, comfort, dignity, presence with family, spiritual considerations; (b) **family understanding + agreement** — Thai cultural framework (family-centered decisions, eldest sibling or spouse often spokesperson); (c) **advance directives** — DNR, DNI, no aggressive intervention; (d) **document explicitly**; (e) **revisit as circumstances change**; (4) **symptom management**: (a) **pain — central focus**: (i) **WHO analgesic ladder** — acetaminophen → weak opioid (codeine, tramadol) → strong opioid (morphine, oxycodone, fentanyl); (ii) **scheduled (not PRN)** for chronic pain with breakthrough doses available; (iii) **opioid titration** — no ceiling for cancer pain; (iv) **opioid rotation** for tolerance or side effects; (v) **route**: oral preferred; SC/IV for non-oral; transdermal fentanyl for stable; PCA for self-titration; (vi) **adjuvants**: NSAIDs (caution renal/GI), corticosteroids (dexamethasone for bone pain + appetite + mood), neuropathic agents (gabapentin/pregabalin), antidepressants for mood + pain; (vii) **regional/neuraxial** — intrathecal pump or epidural for refractory pain — palliative care + anesthesia expertise; (viii) **palliative radiation** for painful bone metastasis — 8 Gy single fraction effective for pain (~ 60-80% response); (ix) **bisphosphonate/denosumab** — reduces bone pain + SREs (consider in months-life expectancy); (x) **vertebroplasty/kyphoplasty** for painful vertebral mets if expected to benefit; (b) **dyspnea**: opioid (oral or SC morphine), oxygen if hypoxic + relieves symptoms, fan to face, positioning; (c) **fatigue**: address reversible causes (anemia, depression), pacing, rest; (d) **nausea**: ondansetron, haloperidol, metoclopramide, dexamethasone; (e) **constipation** (universal with opioids): scheduled bowel regimen — senna/bisacodyl + osmotic + methylnaltrexone for opioid-induced refractory; (f) **delirium**: identify cause (medication, infection, hypercalcemia, hypoxia), haloperidol/risperidone if non-pharmacologic insufficient; benzodiazepines selectively (can worsen); (g) **oral care + secretions**; (h) **pressure ulcer prevention** — turn, pressure-relieving mattress, skin care; (5) **role of orthopedic surgery in end-of-life — highly selective**: (a) **palliative surgery** principle — symptom relief, improve dignity, allow nursing care; (b) **pathologic fracture** — fixation if expected to improve pain + comfort + allow positioning + nursing care (modified Mirels-like approach for life expectancy); even short life expectancy may benefit from fixation for pain relief; (c) **avoid major invasive surgery** with prolonged recovery if life expectancy short; (d) **simple stabilization** sometimes appropriate (e.g., IM nail for femoral mets if able to tolerate); (e) **non-operative comfort measures** for many: positioning, pressure relief, scheduled analgesia, immobilization splint for comfort; (6) **psychosocial + spiritual + emotional**: (a) presence + listening; (b) life review + legacy; (c) reconciliation + relationship attention; (d) spiritual + religious practices (Buddhist meditation, merit-making, chanting); (e) cultural rituals; (f) preparing family for loss; (g) anticipatory grief; (7) **family caregivers — central + supported**: (a) education on care techniques; (b) respite; (c) coping resources; (d) bereavement preparation; (e) post-bereavement support; (8) **dying process — recognize + support**: (a) clinical signs (decreased intake, mottling, breathing changes, decreased responsiveness); (b) communicate with family — what to expect; (c) presence + comfort; (d) honor patient''s preferred place of death; (e) **comfort care orders** at end of life — stop unnecessary interventions, comfort meds prn; (9) **Thai cultural context**: (a) family hierarchy (eldest or eldest son often decision spokesperson); (b) Buddhist beliefs about death + karma + suffering + impermanence; (c) merit-making (tham boon) for the dying; (d) preference for death at home in some families; (e) Buddhist monk presence at end; (f) family being present essential; (g) communication style (indirect, respect for elders, harmonious); (h) post-death rituals (3-day, 7-day, 100-day, 1-year)

---

End-of-life ortho-palliative: shift to comfort focus; multidisciplinary (palliative + hospice + pain + ortho + RT + chaplain + SW + family). Goals of care discussion; document DNR/DNI/comfort. Pain: WHO ladder, scheduled opioid no ceiling for cancer, adjuvants (steroid, gabapentin), regional, palliative RT 8 Gy × 1 for bone, bisphosphonate, vertebroplasty selective. Other symptoms: dyspnea (morphine + O2), constipation, nausea, delirium. Ortho — highly selective palliative surgery for pain + dignity + nursing care (even with short life expectancy may benefit). Cultural sensitivity (Buddhist, family hierarchy, merit-making, presence). Family bereavement.', NULL,
  'medium', 'hemato_onco', 'review',
  'orthopedics', 'integrative', 'hemato_onco', 'adult',
  'WHO Analgesic Ladder; Palliative Care', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Integrative Case**

ผู้ป่วยอายุ 75 ปี end-stage metastatic prostate cancer (widespread bony mets), bed-bound, life expectancy weeks, ปวด chronic + acute exacerbation from pathological pelvic + spine fractures

Family wants comfort focus, declining surgery

จงอธิบาย integrative end-of-life ortho-palliative care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Integrative Case**

นักฟุตบอลอาชีพ อายุ 22 ปี ปะทะคู่แข่ง รถยนต์ชน — sustains ACL tear + concussion in same play, briefly LOC + confused 30 min, headache, dizzy, photophobia, no focal deficit

จงอธิบาย integrative management of concurrent musculoskeletal + concussion + return-to-play decisions', '[{"label":"A","text":"Same-day surgery for ACL despite concussion"},{"label":"B","text":"Concurrent Sports Concussion + ACL Tear — Integrative Return-to-Play Decision-Making"},{"label":"C","text":"Return to play immediately after concussion if asymptomatic at 1 hour"},{"label":"D","text":"Time-based return to sport (6 months) without functional testing"},{"label":"E","text":"Concussion does not affect surgical decisions"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Concurrent Sports Concussion + ACL Tear — Integrative Return-to-Play Decision-Making: (1) **multidisciplinary team**: (a) **sports medicine physician** — overall coordination; (b) **orthopedic + sports surgery** — ACL management; (c) **neurology / sports concussion specialist** — concussion management; (d) **neuropsychology** — cognitive testing, baseline comparison; (e) **physical therapy** — rehabilitation; (f) **athletic trainer** — daily monitoring + return-to-play protocol; (g) **psychology + mental health** — psychological + emotional support; (h) **coaching staff** — communication, transition; (2) **concussion management — TBI principles**: (a) **definition** — mild traumatic brain injury → transient neurologic dysfunction from biomechanical force; (b) **diagnosis** — clinical (Symptoms checklist, balance test, cognitive screening, history); SCAT5 (Sport Concussion Assessment Tool); (c) **acute management** — remove from play immediately if suspected ("when in doubt, sit them out"); medical evaluation; **CT** if concerning features (LOC > 1 min, prolonged amnesia, focal deficit, severe headache, vomiting, seizure, declining GCS) — not routinely; (d) **graduated return-to-play protocol** (international consensus — Berlin/Amsterdam Concussion in Sport): (i) **complete rest 24-48h** then symptom-limited activity; (ii) **stage 1** — symptom-limited activity (daily activities); (iii) **stage 2** — light aerobic exercise; (iv) **stage 3** — sport-specific exercise; (v) **stage 4** — non-contact training drills; (vi) **stage 5** — full-contact practice (only after medical clearance); (vii) **stage 6** — return to sport; (viii) progress one stage per 24 hours minimum; symptom recurrence → drop back; full RTP typically 1-2+ weeks for adult, longer for younger athletes (more conservative); (e) **second-impact syndrome** — rare catastrophic brain swelling from second concussion before first resolved → high mortality + morbidity; absolute contraindication to RTP with persisting symptoms; (f) **chronic traumatic encephalopathy (CTE)** — concern with repetitive impacts (NFL); long-term considerations; (g) **post-concussion syndrome** — persistent symptoms > 10-14 days; (3) **ACL management priorities**: (a) **acute** — RICE, immobilization in brace, crutches, pain control; (b) **prehabilitation** — restore ROM + reduce effusion + quadriceps activation BEFORE reconstruction (better outcomes); (c) **MRI** for ACL + associated injuries (meniscus, bone bruise, MCL, PCL); (d) **timing of ACL reconstruction** — typically delay 3-6 weeks (or longer if effusion + ROM not restored) — but concussion DEFERS this; (4) **integrative decision — concussion must be cleared before elective ACL surgery + before RTP**: (a) **delay elective surgery** until concussion resolves AND patient cleared for sport (typically 1-4 weeks delay, sometimes longer); (b) urgent surgery (open fracture, vascular injury) — proceed regardless with anesthesia awareness; (c) **anesthesia considerations** post-concussion — avoid increased ICP, careful general anesthesia; regional anesthesia preferred; consult neurology if recent significant TBI; (d) elective ACL when stable; (5) **post-ACL surgery + return to sport** — different timelines: (a) **graduated rehabilitation 6-9 months** (some say longer to reduce re-rupture risk); (b) **functional testing** — limb symmetry index (LSI) > 90% for hop tests, ROM, strength; (c) **psychological readiness** — ACL-RSI scale; many athletes psychologically unprepared at typical time; (d) **STABILITY trial** — lateral extra-articular tenodesis (LET) augmentation reduces re-rupture in young athletes; (e) **modern criteria** — comprehensive return-to-sport battery vs time-based; (f) **ACL re-rupture rate** ~ 20-30% in young athletes who return to pivoting sports; (g) **ACL prevention program** (FIFA 11+, others) reduces injury; (6) **psychological + emotional**: (a) injury + concussion = significant impact on young athlete identity; (b) anxiety, depression risk; (c) motivation for prolonged rehabilitation; (d) reframe + recovery focus; (e) peer + family support; (7) **shared decision making** — discuss with athlete + family + agent (if professional) — realistic timelines, risks, benefits; (8) **long-term sport considerations** — repeated concussion risk → career considerations; OA risk from ACL; (9) **ethical** — protect athlete from premature RTP despite pressure from team/coach/family

---

Concurrent concussion + ACL: multidisciplinary (sports med + ortho + neuro/concussion + PT + AT + psych). Concussion: SCAT5 dx, REMOVE from play immediately, graduated RTP protocol (1-6 stages, 24h+ per stage, full RTP 1-2+ wk adult), monitor for second-impact syndrome, CTE concern long-term. ACL: prehab → reconstruction (delay 3-6 wk minimum, longer if concussion not cleared) → 6-9 mo rehab → functional tests (LSI > 90%) + psychological readiness (ACL-RSI). LET reduces re-rupture (STABILITY). Re-rupture 20-30%. Psychological support + reframe. Protect athlete from premature RTP.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'integrative', 'msk_nontrauma', 'adult',
  'AAOS; Berlin Concussion in Sport', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Integrative Case**

นักฟุตบอลอาชีพ อายุ 22 ปี ปะทะคู่แข่ง รถยนต์ชน — sustains ACL tear + concussion in same play, briefly LOC + confused 30 min, headache, dizzy, photophobia, no focal deficit

จงอธิบาย integrative management of concurrent musculoskeletal + concussion + return-to-play decisions'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Integrative Case**

คุณเป็น orthopedic surgeon at small district hospital ในจังหวัดที่ห่างไกล — ขาด MRI + operating microscope + specialist subspecialists, basic X-ray + fluoroscopy + basic surgical capability

ผู้ป่วยอายุ 35 ปี — open femur fracture (Gustilo II) + suspected scaphoid fracture (snuffbox tender, X-ray negative)

จงอธิบาย integrative practice + decision-making in resource-limited setting', '[{"label":"A","text":"Same standard care available in all settings worldwide"},{"label":"B","text":"Practicing in Resource-Limited Setting — Integrative Decision Making"},{"label":"C","text":"Heroic surgery beyond scope always acceptable"},{"label":"D","text":"Telemedicine never useful in remote settings"},{"label":"E","text":"Clinical exam unnecessary if imaging is unavailable"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Practicing in Resource-Limited Setting — Integrative Decision Making: (1) **principles**: (a) provide best available care while recognizing limitations; (b) appropriate referral + transfer to higher-level care when needed; (c) maximize use of available resources; (d) telemedicine + remote consultation where available; (e) clinical skills + thoughtful exam essential; (f) ethical: do no harm + maximize benefit + respect autonomy + justice; (2) **specific case approach**: (a) **open femur fracture Gustilo II**: (i) ATLS approach; (ii) **antibiotic within 1 hour** — cefazolin (available in most settings) + gentamicin if higher Gustilo; (iii) **tetanus**; (iv) **wound assessment** — irrigation with available sterile saline (large volume); sterile dressing; **DO NOT push bone back into wound**; (v) **splint** — femur traction splint (Hare/Sager) or skeletal traction (Steinmann pin in proximal tibia + traction setup) for immobilization + pain relief; (vi) **definitive management decision**: (1) if competent + equipment for **intramedullary nailing** → can be done locally — but generally requires C-arm fluoroscopy + appropriate implants; (2) **external fixator** as damage control if no IM nail capability — quick, low-tech, effective stabilization + allows transfer; (3) **transfer to higher-level center** for definitive IM nail if local capability limited — stabilize first; (b) **suspected scaphoid fracture with negative X-ray**: (i) **clinical suspicion strong** despite negative initial X-ray; (ii) **thumb spica splint/cast** for presumptive treatment; (iii) **repeat X-ray 10-14 days** when bony resorption may make fracture visible; (iv) MRI gold standard for occult — **refer for MRI** at higher-level facility if available + practical; (v) **CT** alternative — better availability + can show occult scaphoid; (vi) **bone scan** alternative if MRI/CT unavailable — sensitive but less specific; (vii) **conservative cast + serial X-ray** if no advanced imaging — pragmatic; (3) **resource-limited orthopedic principles**: (a) **emphasize clinical exam + history** — foundation of diagnosis (sometimes overlooked in modern imaging era); (b) **plain X-ray** + careful interpretation; (c) **simple effective interventions** — splinting, casting, traction; (d) **damage control orthopedics** with external fixator for unstable polytrauma → transfer; (e) **basic surgical techniques** — closed reduction, percutaneous pinning, simple ORIF for fractures within local capability; (f) **knowledge of when to transfer** — limit scope to local capability + transfer for complex; (4) **transfer + referral system**: (a) communicate with higher-level center; (b) document + send records, imaging; (c) stabilize before transfer; (d) **telemedicine consultation** if available — guidance + reassurance; (5) **education + training**: (a) continuing medical education — keep skills current; (b) telementoring for unfamiliar procedures; (c) attend conferences + workshops; (d) supervise less experienced colleagues; (6) **ethical decisions**: (a) **appropriate scope of practice** — do procedures you are competent + equipped for; (b) avoid heroic surgery beyond capability; (c) recognize limitations + refer; (d) **patient autonomy** + informed consent; (e) **prioritize most beneficial intervention** with limited resources; (7) **adaptation + improvisation** — sometimes necessary but balance with safety: (a) modify techniques for available equipment; (b) substitute when standard equipment unavailable (e.g., calcaneal pin + traction setup vs commercial traction splint); (c) document any non-standard care + rationale; (8) **community + public health perspective**: (a) **prevention** — road safety, helmet laws, occupational safety, fall prevention in elderly; (b) **rehabilitation** in community — physical therapy access; (c) **disability + reintegration** support; (d) **research** for local context; (9) **multidisciplinary in resource-limited** — may need to involve family medicine, surgery, ED colleagues for joint management; (10) **outcomes** — many ortho outcomes in resource-limited can be comparable to advanced settings with proper triage + basic care + transfer for complex; (11) **systems-level advocacy** — improve infrastructure + training + access to advanced care

---

Resource-limited ortho: clinical exam + careful X-ray foundation. Open femur Gustilo II: antibiotic + tetanus + irrigation + splint (traction splint or Steinmann skeletal traction) → ex-fix locally as damage control + TRANSFER for IM nail if needed. Suspected scaphoid with negative X-ray: thumb spica + repeat X-ray 10-14 days, refer for MRI/CT if available, or pragmatic conservative + serial X-ray. Damage control + transfer for complex. Telemedicine if available. Know scope of practice + when to refer. Adapt + improvise within safety limits. Prevention + community + systems advocacy.', NULL,
  'medium', 'trauma', 'review',
  'orthopedics', 'integrative', 'trauma', 'adult',
  'AAOS Global Outreach', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Integrative Case**

คุณเป็น orthopedic surgeon at small district hospital ในจังหวัดที่ห่างไกล — ขาด MRI + operating microscope + specialist subspecialists, basic X-ray + fluoroscopy + basic surgical capability

ผู้ป่วยอายุ 35 ปี — open femur fracture (Gustilo II) + suspected scaphoid fracture (snuffbox tender, X-ray negative)

จงอธิบาย integrative practice + decision-making in resource-limited setting'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Integrative Case**

ผู้บริหารโรงพยาบาล asked you (orthopedic surgeon) ที่จะ optimize value of total joint replacement program — efficiency + cost + outcomes + access

จงอธิบาย integrative approach to value-based ortho care + quality + outcomes + cost-effectiveness', '[{"label":"A","text":"Value-based care means only reducing cost regardless of outcomes"},{"label":"B","text":"Value-Based Orthopedic Care — Integrative Approach"},{"label":"C","text":"Patient-reported outcomes are not important"},{"label":"D","text":"Always use most expensive implants for best outcomes"},{"label":"E","text":"Variation in care is acceptable and not addressed"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Value-Based Orthopedic Care — Integrative Approach: (1) **value** = quality outcomes / cost — focus of modern healthcare; (2) **multidisciplinary value team**: (a) **orthopedic surgeons** — clinical decisions, surgical efficiency; (b) **hospital administration** — operations, finance; (c) **anesthesia** — perioperative management; (d) **physical therapy + rehabilitation** — optimize recovery; (e) **case management + social work** — discharge planning; (f) **nursing** — patient experience, complications; (g) **quality + safety** — measurement + improvement; (h) **finance + supply chain** — implant + supplies management; (i) **information technology** — electronic records, analytics; (j) **patient + family advisors** — patient experience perspective; (3) **dimensions of value**: (a) **quality**: (i) **clinical outcomes** — complication rates (SSI, DVT, dislocation, revision), mortality, readmissions; (ii) **patient-reported outcomes (PROMs)** — pain, function, satisfaction (KOOS, HOOS, Oxford scores, EQ-5D); (iii) **process measures** — antibiotic timing, VTE prophylaxis, multimodal pain management, mobilization same day; (iv) **patient experience** — Press-Ganey, NPS; (v) **safety** — never events, serious adverse events; (b) **efficiency + cost**: (i) **length of stay (LOS)** — modern TJA 1-2 days or outpatient/ASC; (ii) **OR efficiency** — turnover time, surgery duration, on-time starts; (iii) **implant cost** — standardize when possible, vendor negotiation; (iv) **resource utilization** — supplies, blood products, post-op imaging; (v) **bundled payment** vs fee-for-service; (vi) **readmission costs**; (vii) **post-acute care** — discharge to home vs SNF/rehab; (4) **specific value improvement strategies**: (a) **preoperative optimization** — Center for Joint Replacement model — HbA1c < 7.5-8, smoking cessation, BMI optimization, MRSA decolonization, anemia treatment, medical comorbidity → reduces complications + LOS + readmission; (b) **enhanced recovery after surgery (ERAS)** — multimodal pain (avoid opioid-only), regional anesthesia (femoral/adductor canal/spinal), TXA, multimodal antiemetic, early mobilization same day, rapid PT, oral nutrition; (c) **outpatient + ambulatory surgery center (ASC) TJA** — appropriate patient selection (younger, healthier, motivated) → comparable outcomes at lower cost (~ 30-40% reduction); careful patient selection; (d) **implant standardization + cost reduction** — formulary, vendor competition, value analysis; modern data — implant brand matters less than surgeon volume + technique; (e) **high-volume centers + surgeons** — improved outcomes + efficiency; designate centers of excellence; (f) **bundled payment models** — fixed payment for episode (90 days TJA) encourages cost-effective care + coordination; (g) **post-acute care** — home with PT > SNF (lower cost, equivalent outcomes for appropriate patients); telephone/video follow-up + home health vs frequent clinic visits; (h) **patient education + engagement** — pre-op classes, expectations, post-op planning → reduces complications + readmissions + improves satisfaction; (i) **multidisciplinary care pathway / clinical pathway** — standardized protocols reduce variation, improve outcomes; (j) **quality improvement / continuous improvement** — measure + analyze + improve; (k) **patient-reported outcomes** measurement + use in shared decision-making + benchmarking; (l) **technology — robotic-assisted, navigation, AI** — variable cost-effectiveness, may improve precision but require evidence of value; (m) **prevention of complications** — DVT prophylaxis, infection control, falls; (5) **registry data + benchmarking** — Australian Orthopaedic Association National Joint Replacement Registry (AOANJRR), UK NJR, Swedish, US AJRR — track outcomes nationally; allows benchmark comparison; identifies high-performing implants + techniques; (6) **shared decision-making** — discuss surgery vs continued non-operative; PROMs predict who benefits; reduce unnecessary surgery; (7) **equity + access**: (a) ensure access for underserved populations; (b) social determinants of health affect outcomes; (c) language + cultural barriers; (d) financial barriers — bundled payment risk-adjustment, charity care; (8) **research + innovation** — translational, clinical trials, real-world evidence; (9) **ethics in value-based care**: (a) avoid "cherry-picking" healthy patients to improve metrics — risk-adjustment essential; (b) avoid undertreatment to save cost; (c) patient-centered always; (d) shared decision-making respects autonomy; (10) **global comparison + Thai context** — Thailand has expanding TJA capacity, growing private sector, universal health coverage with cost constraints, need for evidence-based + value-based approach; (11) **outcomes — value-based ortho programs demonstrate**: improved outcomes + reduced costs + reduced LOS + improved satisfaction + reduced complications — clear evidence of benefit

---

Value-based ortho: value = quality outcomes / cost. Multidisciplinary team approach. Quality (clinical outcomes, PROMs, process, experience, safety) + efficiency/cost (LOS, OR efficiency, implant cost, readmission, post-acute care). Strategies: preop optimization (HbA1c, smoking, BMI, MRSA), ERAS (multimodal pain, regional, TXA, early mobilization), outpatient/ASC selected, implant standardization, high-volume centers, bundled payments, home with PT > SNF, patient education, clinical pathways, registries (AOANJRR, NJR, AJRR), shared decision-making. Equity + access essential. Avoid cherry-picking. Patient-centered.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'integrative', 'msk_nontrauma', 'adult',
  'Porter; AAHKS; AAOS Registry', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Integrative Case**

ผู้บริหารโรงพยาบาล asked you (orthopedic surgeon) ที่จะ optimize value of total joint replacement program — efficiency + cost + outcomes + access

จงอธิบาย integrative approach to value-based ortho care + quality + outcomes + cost-effectiveness'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Integrative Case**

ผู้ป่วยอายุ 70 ปี Thai-Buddhist รับประทาน traditional Thai herbs and supplements + visit traditional healer for hip pain (advanced OA), considering TKA + crystal/jewelry alternative healing, family wants involvement in all decisions, eldest son is decision-maker spokesperson

จงอธิบาย integrative culturally-competent care + shared decision making', '[{"label":"A","text":"Dismiss traditional Thai medicine as superstition"},{"label":"B","text":"Culturally Competent Care in Thai Context — Integrative Approach"},{"label":"C","text":"Refuse to discuss alternative treatments with patient"},{"label":"D","text":"Bypass family in decision-making for adult patient"},{"label":"E","text":"Insist on Western communication style with all patients"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Culturally Competent Care in Thai Context — Integrative Approach: (1) **principles of cultural competence**: (a) **respect** for patient''s beliefs, values, language, customs; (b) **awareness** of cultural factors affecting health behaviors + decision-making; (c) **adaptation** of care to be culturally appropriate while maintaining evidence-based standards; (d) **shared decision-making** that respects autonomy + cultural context; (e) **non-judgmental** approach to traditional + complementary practices; (f) **avoid stereotyping** — individuals vary within cultural groups; (2) **Thai cultural framework**: (a) **Buddhism** — predominant religion (95% Theravada), influences worldview: (i) **karma** — actions in past lives + present affect current circumstances; (ii) **suffering (dukkha)** — fundamental teaching, including illness as part of human condition; (iii) **acceptance + equanimity**; (iv) **impermanence (anicca)**; (v) **merit-making (tham boon)** — offerings to monks, alms, releasing animals; family often performs to benefit ill person; (vi) **meditation + chanting** as coping; (vii) sacred objects + amulets; (b) **family-centered decision-making**: (i) **hierarchy** — eldest male sibling, eldest son, or spouse often spokesperson; (ii) **collective decisions** — consensus important; (iii) **respect for elders (kreng jai)** — younger family defers; (iv) **avoiding direct confrontation** — indirect communication; (c) **traditional + alternative medicine**: (i) **Thai traditional medicine (TTM)** — herbal medicine, massage (Nuad Thai), spiritual healing — government-recognized + integrated; (ii) **TCM** influence; (iii) **religious healing** — visits to monks, temples; (iv) **amulets, holy water, blessed objects**; (v) **traditional healers (mor phaen boran)** alongside biomedical care; (d) **communication style**: (i) **politeness + respect** essential (sawaddee + wai gesture); (ii) **smile** (yim — multiple meanings, not just happiness); (iii) **indirect** expression of disagreement; (iv) **"mai pen rai"** ("it''s okay, no problem") — common but may mask concerns; (v) **age + status respect** (use khun + family name); (vi) **avoid confrontation in front of others** (face-saving); (e) **interactions with healthcare**: (i) **respect for physicians** as authority figure; (ii) **trust + relationship building**; (iii) **family involvement** in clinic visits + decisions; (iv) **financial considerations** — universal health coverage but private care preferred by some; (3) **integrating traditional + biomedical**: (a) **non-judgmental inquiry** about traditional practices being used (open question — "are you using anything else for your hip?"); (b) **drug-herb interactions** — review traditional herbal supplements for interactions (especially with anticoagulants, analgesics): (i) some Thai herbs (e.g., Ginkgo, ginseng, garlic, ginger) may increase bleeding risk; (ii) some may affect blood pressure or glucose; (iii) **stop most herbal supplements 1-2 weeks pre-op** to be safe; (c) **complementary practices** that don''t interfere with treatment — encourage if patient finds comforting (meditation, chanting, prayer, family presence); (d) **referral to integrative medicine** if available; (4) **shared decision making**: (a) **identify decision-makers** — patient + family hierarchy; (b) **invite family** to discussions if patient wishes; (c) **interpret medical information** in culturally accessible language; (d) **respect collective decision process** — may not get immediate answer; (e) **address values + concerns** — what does patient value? merit-making, dignity, family roles, work, religious practice; (f) **discuss risks + benefits realistically**; (g) **discuss alternatives** including continued conservative + complementary; (h) **multiple visits** for complex decisions; (i) **documentation** of decision-making process; (5) **specific TKA decision in this case**: (a) **explore patient''s understanding** of TKA + alternatives; (b) **explain procedure + outcomes + recovery** clearly with visual aids; (c) **address concerns** — karmic implications, ability to perform religious practices (kneeling, prostrating, walking — modify post-TKA); (d) **discuss timing** — religious holidays, family events, Buddhist Lent (no surgery if possible during Lent); (e) **involve family** in decision; (f) **respect ultimate decision** of patient/family — including delaying surgery; (6) **logistics + accommodations**: (a) **language** — Thai, possibly regional dialect (Northern, Southern, Isan/Northeastern); use professional interpreter if needed; (b) **food** — Buddhist may abstain from meat selectively; offer choices; (c) **gender preferences** — preference for same-gender provider for sensitive examinations; (d) **modesty** during examinations; (e) **family presence** during examinations + procedures (when possible); (f) **religious observances** — accommodate prayer, meditation; (g) **end-of-life specific** — monk visits, chanting at bedside; (7) **provider self-awareness**: (a) recognize own cultural biases; (b) avoid ethnocentrism; (c) ongoing education + humility; (8) **systemic** — culturally adapted health education materials, diverse workforce, community partnerships

---

Culturally competent care Thai context: respect Buddhist worldview (karma, suffering, merit-making), family-centered hierarchical decision-making (eldest son/spouse spokesperson, collective consensus, kreng jai), traditional medicine (Thai TTM, herbs — screen interactions, stop 1-2 wk pre-op if bleeding risk), polite indirect communication, face-saving, smile/mai pen rai may mask. Integrative — non-judgmental inquiry about traditional practices; encourage complementary if doesn''t interfere (meditation, chanting). Shared decision: identify decision-makers, invite family, multiple visits, respect ultimate decision. Religious accommodation. Modesty + same-gender provider. Provider self-awareness + cultural humility.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'integrative', 'msk_nontrauma', 'adult',
  'Cross Cultural Health', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Integrative Case**

ผู้ป่วยอายุ 70 ปี Thai-Buddhist รับประทาน traditional Thai herbs and supplements + visit traditional healer for hip pain (advanced OA), considering TKA + crystal/jewelry alternative healing, family wants involvement in all decisions, eldest son is decision-maker spokesperson

จงอธิบาย integrative culturally-competent care + shared decision making'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Integrative Case**

เด็กชายอายุ 18 เดือน นำมาห้องฉุกเฉินด้วย — multiple bruises various stages of healing on torso, posterior rib fracture + bilateral femur fractures on skeletal survey, parents inconsistent history ("baby fell off bed")

Mother seems withdrawn, baby thin + below growth chart

จงอธิบาย integrative non-accidental trauma evaluation + management + reporting + protection', '[{"label":"A","text":"Discharge home with parents without further evaluation"},{"label":"B","text":"Non-Accidental Trauma (NAT/Child Abuse) — Integrative Multidisciplinary Care"},{"label":"C","text":"Reporting is optional in suspected NAT"},{"label":"D","text":"Posterior rib fractures are common in accidental trauma"},{"label":"E","text":"Skeletal survey not needed if X-ray of fracture site is normal"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Non-Accidental Trauma (NAT/Child Abuse) — Integrative Multidisciplinary Care: (1) **principles**: (a) **NAT is preventable cause of death + disability in children** — under-recognized; (b) **clinical suspicion** essential — pattern recognition; (c) **mandatory reporting** legal + ethical; (d) **child safety priority**; (e) multidisciplinary protective approach; (2) **multidisciplinary team**: (a) **pediatric orthopedic surgery** — fracture management; (b) **pediatric / pediatric emergency medicine** — overall medical care; (c) **child protective services (CPS)** — investigation, safety planning; (d) **forensic pediatrician** (if available) — expert evaluation; (e) **social work** — psychosocial assessment, family support, resources; (f) **child psychiatry / psychology** — trauma assessment + treatment; (g) **law enforcement** — criminal investigation; (h) **legal — child advocate** — protection in court; (i) **nursing** — ongoing assessment, observation; (j) **hospital child abuse team** if available; (3) **red flags for NAT**: (a) **history inconsistencies** — story changes, doesn''t match injury pattern, delayed presentation, no history of trauma in young infant; (b) **specific fracture patterns** — **"classic metaphyseal lesion"** (CML, bucket-handle/corner fractures — pathognomonic for NAT); **posterior rib fractures** (especially in infants — squeezing during forceful violent shaking); **multiple fractures different stages of healing**; **bilateral** fractures; **spiral fractures of long bones in non-ambulatory children** (suspicious — toddler fracture only in walking children); **subdural hematoma + retinal hemorrhages in infants** (abusive head trauma — shaken baby syndrome); (c) **soft tissue findings** — bruises in non-bony prominent areas (torso, ear, neck, buttocks), patterned bruises (handprint, belt, cord), various stages of healing, burns in patterned (immersion, cigarette), bite marks, oral injuries; (d) **delayed presentation** for significant injury; (e) **caregiver behaviors** — flat affect, avoidance, anger at staff, defensive, blames child; (f) **child behaviors** — fear, withdrawal, no stranger anxiety in infant; (g) **growth + nutrition** — failure to thrive, malnutrition; (h) **prior episodes** or CPS involvement; (i) **environmental** — substance abuse, domestic violence, mental illness, poverty, single parent, very young parents (risk factors but not deterministic); (4) **evaluation**: (a) **detailed history** — separately from caregivers if possible; (b) **complete physical exam** — head to toe with attention to skin, mucous membranes, genitals, neurologic; (c) **fundoscopic exam** by ophthalmology for retinal hemorrhages in head injury; (d) **skeletal survey** mandatory for any suspicion in child < 2 years (radiographic series of entire skeleton — 19 views minimum) — identifies occult fractures + healing fractures; **repeat skeletal survey in 2 weeks** to identify additional fractures not initially visible; (e) **head imaging** — CT or MRI for any concern; (f) **abdominal imaging** if abdominal trauma suspected; (g) **laboratory** — CBC, coagulation, LFTs, electrolytes, urinalysis; toxicology; (h) **photographic documentation** of injuries; (i) **growth chart + nutritional assessment**; (j) **developmental assessment**; (5) **MANDATORY REPORTING** — legal obligation: (a) **report to CPS + law enforcement** as required by Thai law (Child Protection Act); (b) **clinical suspicion sufficient** — no need for certainty; (c) **immune from liability** for good-faith report (in most jurisdictions); (d) **failure to report** — legal + ethical consequences; (e) **document carefully** — observations + history + concerns; (f) **report can be made by any healthcare provider**; (6) **child safety + protection**: (a) **admit to hospital** for safety + further evaluation when NAT suspected; (b) **avoid releasing child** to potentially abusive caregivers; (c) **CPS involvement** for placement decisions; (d) **safety planning**; (e) **siblings** — must be assessed for safety (often at risk); (7) **medical management**: (a) **fracture treatment** as clinically indicated; (b) **multidisciplinary care** for complex injuries; (c) **support during hospitalization** — comfort, attention, normalcy as possible; (d) **psychological support** for older children with awareness; (8) **family-centered considerations**: (a) **non-judgmental** initial approach (avoid premature conclusions); (b) **assessment of family stressors** + needs; (c) **family preservation when safe** — services may allow safe reunification; (d) **alternative care arrangements** when not safe — foster care, relatives; (9) **provider role**: (a) advocate for child; (b) report; (c) document objectively; (d) testify if needed; (e) coordinate with multidisciplinary team; (10) **prevention**: (a) **education** for parents — coping with stress, child development, support; (b) **home visiting programs** for at-risk; (c) **community resources** — childcare, mental health, substance abuse, parenting classes; (d) **identification of at-risk families** + intervention; (11) **long-term outcomes** — abused children have increased risk of physical + mental health problems, developmental delays, behavioral issues, future violence (perpetration + victimization); early intervention + safety + nurturing relationships can mitigate

---

NAT (child abuse) evaluation: red flags = inconsistent history, posterior rib fractures, metaphyseal corner fractures ("bucket handle" — PATHOGNOMONIC), multiple fractures different ages, bilateral, non-ambulatory child with spiral, head injury with retinal hemorrhages (shaken baby), patterned bruises, FTT. EVAL: skeletal survey (mandatory < 2 yr suspicion, repeat 2 wk later), head imaging, fundoscopy, labs, photo doc. MANDATORY REPORTING (Thai Child Protection Act) — suspicion sufficient. ADMIT + protect (don''t release to abuser). Multidisciplinary (ortho + peds + SW + CPS + law enforcement + child psych + legal). Siblings at risk — assess. Prevention + family services.', NULL,
  'hard', 'trauma', 'review',
  'orthopedics', 'integrative', 'trauma', 'peds',
  'Child Protection Act Thailand; AAP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Integrative Case**

เด็กชายอายุ 18 เดือน นำมาห้องฉุกเฉินด้วย — multiple bruises various stages of healing on torso, posterior rib fracture + bilateral femur fractures on skeletal survey, parents inconsistent history ("baby fell off bed")

Mother seems withdrawn, baby thin + below growth chart

จงอธิบาย integrative non-accidental trauma evaluation + management + reporting + protection'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Integrative Case**

คุณเป็น ortho department head — ต้องการพัฒนา department + improve patient outcomes + train residents + contribute to global orthopedic health

จงอธิบาย integrative vision + leadership + research + education + global orthopedic health + future of orthopedic surgery', '[{"label":"A","text":"Technology adoption without evidence evaluation"},{"label":"B","text":"Integrative Vision for Modern Orthopedic Practice + Future"},{"label":"C","text":"Focus only on individual patient ignoring system + global perspective"},{"label":"D","text":"Maintain status quo without improvement"},{"label":"E","text":"Avoid all new technology and methods"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Integrative Vision for Modern Orthopedic Practice + Future: (1) **comprehensive department development**: (a) **clinical excellence** — evidence-based care, subspecialty coverage, multidisciplinary teams, value-based care, patient safety culture; (b) **education + training** — residency + fellowship, continuing medical education, simulation, mentorship; (c) **research + innovation** — clinical research, translational, registries, quality improvement; (d) **patient + community engagement** — health promotion, prevention, advocacy; (e) **multidisciplinary collaboration** — across specialties; (f) **technology adoption + critical evaluation**; (2) **leadership principles**: (a) **shared vision + culture**; (b) **psychological safety** — speak up, learn from errors; (c) **continuous improvement**; (d) **diversity + inclusion**; (e) **work-life integration + wellness** — burnout prevention; (f) **succession planning** + mentorship; (g) **transparent communication**; (h) **patient-first focus**; (3) **education + training**: (a) **competency-based residency** — defined milestones; (b) **simulation training** — surgical skills, communication; (c) **multidisciplinary teaching**; (d) **research mentorship** + scholarly activity; (e) **global health rotations** — exposure to international + resource-limited care; (f) **wellness + mental health** support for trainees; (g) **continuing education** — annual courses, conferences, webinars; (h) **lifelong learning** culture; (4) **research priorities**: (a) **clinical research** — RCTs, comparative effectiveness, real-world evidence; (b) **translational** — bench-to-bedside (cartilage regeneration, gene therapy, stem cells); (c) **patient-reported outcomes** + qualitative research; (d) **health services research** — value, access, equity; (e) **registry-based** — large-scale outcomes data; (f) **AI + machine learning** — diagnostic, predictive, surgical planning; (g) **implant + biomaterial** innovation; (h) **multi-institution collaboration**; (i) **funding** — NIH, industry partnerships, foundations; (5) **technology + innovation**: (a) **robotic-assisted surgery** — precision, learning curve, value evaluation; (b) **navigation systems** — preoperative planning, intra-op guidance; (c) **3D printing** — patient-specific implants, surgical planning models; (d) **augmented reality / virtual reality** — surgical visualization, training simulation; (e) **artificial intelligence** — diagnostic interpretation (fractures, OA, scoliosis), predictive analytics (outcomes, complications), workflow optimization, surgical decision support; (f) **wearables + remote monitoring** — patient tracking, rehabilitation; (g) **telemedicine + telehealth** — access expansion; (h) **gene therapy + biologics** — emerging cartilage restoration, hemophilia, others; (i) **regenerative medicine** — stem cells, scaffolds, growth factors; (j) **precision medicine** — genomics-guided treatment; (6) **global orthopedic health**: (a) **disparities** — high vs low income countries; rural vs urban; (b) **WHO Global Surgical Disability** — 5+ billion lack timely surgical care; (c) **trauma is leading cause of death + disability** globally — road traffic, falls, violence; (d) **musculoskeletal disorders** — major cause of disability worldwide (Global Burden of Disease); (e) **strategies**: (i) **capacity building** — training local providers, fellowship + visiting scholar programs; (ii) **infrastructure** — equipment, supplies, OR facilities; (iii) **research + evidence** for resource-limited contexts; (iv) **prevention** — road safety, fall prevention, occupational health, helmet laws; (v) **mobile clinics + outreach**; (vi) **partnerships** — university, NGO, government; (vii) **technology transfer** — appropriate technology; (viii) **advocacy** — World Health Assembly resolutions on trauma + musculoskeletal disorders; (ix) **disability inclusion** — rights, rehabilitation; (x) **ethical considerations** — avoid "surgical colonialism"; sustainable partnership; (7) **future of orthopedic surgery**: (a) **personalized + precision medicine** — biomarkers, genomics, AI-guided care; (b) **minimally invasive + ambulatory surgery** — same-day discharge for many procedures; (c) **biologic + regenerative** — cartilage restoration, tendon repair, gene therapy; (d) **robotic + AI-assisted** — precision, consistency, complex procedures; (e) **value-based + outcomes-driven**; (f) **patient empowerment** — wearables, apps, education; (g) **digital health integration**; (h) **expanded subspecialization**; (i) **global collaboration + equity**; (j) **prevention emphasis** — public health approach to MSK; (k) **multidisciplinary integration** — beyond ortho to comprehensive care; (l) **focus on quality of life + function** as primary outcomes; (8) **ethical dimensions**: (a) **equity + access** — geographic, socioeconomic, cultural; (b) **technology evaluation** — evidence before adoption; (c) **resource stewardship**; (d) **physician wellness + burnout** prevention; (e) **conflict of interest management**; (f) **patient autonomy** central; (g) **sustainable + environmentally responsible** practices; (9) **patient-centered always** — individual values + goals; shared decision-making; cultural humility; trauma-informed; respect; (10) **call to action** — orthopedic surgeons positioned to improve mobility + function + quality of life for patients globally — comprehensive, evidence-based, compassionate, innovative practice combined with prevention + advocacy + education + research will continue to advance the field

---

Integrative ortho vision: comprehensive department (clinical excellence + education + research + community engagement + multidisciplinary). Leadership (shared vision, psychological safety, wellness, diversity). Education (competency-based, simulation, global health rotations). Research (RCTs, registries, AI, translational, biologics). Technology (robotic, navigation, 3D printing, AR/VR, AI/ML — evaluate evidence). Global ortho health (5B lack surgical care, trauma + MSK leading causes disability — capacity building, infrastructure, prevention, partnerships, equity). Future: precision + personalized, regenerative, ambulatory, value-based, prevention. Patient-centered + equitable + sustainable + compassionate.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'orthopedics', 'integrative', 'msk_nontrauma', 'adult',
  'WHO; AAOS; Global Burden of Disease', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Integrative Case**

คุณเป็น ortho department head — ต้องการพัฒนา department + improve patient outcomes + train residents + contribute to global orthopedic health

จงอธิบาย integrative vision + leadership + research + education + global orthopedic health + future of orthopedic surgery'
  );

commit;

