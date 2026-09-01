-- ===============================================================
-- หมอรู้ — Board seed: เวชศาสตร์ฟื้นฟู (rehab_medicine) — part 3/4 (50 MCQs)
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
  s.id, 'board', NULL, 'ผู้ป่วย Meniere disease confirmed — fluctuating hearing + tinnitus + vertigo — referred VRT', '[{"label":"A","text":"Surgery first-line"},{"label":"B","text":"Meniere Disease — Multimodal"},{"label":"C","text":"VRT during acute attacks only"},{"label":"D","text":"No counseling"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Meniere Disease — Multimodal: (1) **Diagnosis (AAO-HNS 2015)**: definite — 2+ spontaneous vertigo episodes ≥ 20 min, fluctuating low-mid freq SNHL one ear, fluctuating aural symptoms; (2) **Management staged**: - **Diet + lifestyle**: low-Na (< 2 g/d) + reduce caffeine + alcohol + nicotine; stress reduction; - **Pharmacologic**: betahistine (limited evidence US), diuretic (HCTZ + triamterene — modest); intratympanic steroid for refractory; - **Vestibular suppressants** for acute episode only; antiemetics; - **Intratympanic gentamicin**: chemical ablation for refractory unilateral — risk hearing loss; - **Surgery**: endolymphatic sac decompression (limited evidence), labyrinthectomy (terminal, deaf), vestibular nerve section (selected hearing-sparing); (2) **VRT role**: between attacks for chronic imbalance + de-compensation; targets central compensation; not effective during acute; not first-line for vertigo episodes; (3) **Counseling**: episode management + safety (don''t drive during) + fall prevention; (4) **Hearing aid** + tinnitus management (sound therapy, CBT); (5) **Cognitive + psychological**: anxiety + depression high — CBT + SSRI; (6) **Multidisciplinary**: ENT + audiology + vestibular PT + psychology + physiatry; (7) **Education + advocacy + peer support**; (8) **Bilateral 30-50% over years**; **Modern**: stepped care + outcomes-driven + counseling integration

---

Meniere: stepped care. Diet (low Na) + diuretic + betahistine + intratympanic steroid → gentamicin/surgery refractory. VRT between attacks for de-compensation (not acute). Audiology + tinnitus + psych. Multidisciplinary.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'AAO-HNS Meniere 2015', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย Meniere disease confirmed — fluctuating hearing + tinnitus + vertigo — referred VRT'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี vestibular migraine — episodic vertigo + headache + sound/light sensitivity', '[{"label":"A","text":"Surgery"},{"label":"B","text":"Vestibular Migraine — Diagnosis + Management"},{"label":"C","text":"No prevention — only acute"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Bedrest"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Vestibular Migraine — Diagnosis + Management: (1) **Bárány Society + IHS criteria**: ≥ 5 episodes vestibular symptoms 5 min - 72 h moderate-severe + current/past migraine + migraine features in ≥ 50% (HA migraine type, photo/phonophobia, aura) + not better by other; (2) **Common — possibly most common cause episodic vertigo** + often missed; (3) **Treatment** — analogous to migraine: - **Lifestyle**: regular sleep + hydration + meals + exercise + stress management + trigger avoidance (caffeine, alcohol, MSG, aged cheese, others identified by diary); - **Acute**: triptans, NSAID, antiemetic, vestibular suppressant (limited); - **Preventive** (≥4 episodes/mo or significant disability): TCA (amitriptyline, nortriptyline), BB (propranolol, metoprolol), AED (topiramate, valproate), CCB (verapamil, flunarizine), CGRP mAb emerging selected; (4) **Vestibular rehab**: helpful for inter-ictal balance/imbalance + chronic dizziness; (5) **CBT** for chronic; (6) **Comorbidities**: anxiety/depression high — treat; PPPD overlap; sleep; (7) **Multidisciplinary**: neurology/HA + ENT + vestibular PT + physiatry + psychology; (8) **Headache diary** for identification + treatment response; (9) **Patient education**: chronic but manageable condition; (10) **Outcomes**: episode frequency, severity, function, DHI; **Modern**: CGRP-era + integrated care

---

Vestibular migraine: Bárány criteria. Likely most common episodic vertigo. Lifestyle + acute (triptan) + preventive (TCA/BB/AED/CCB/CGRP). VRT for inter-ictal. CBT + mood + sleep. Multidisciplinary. Modern: CGRP.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'Bárány VM Criteria', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี vestibular migraine — episodic vertigo + headache + sound/light sensitivity'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 75 ปี chronic dizziness + multiple falls + multifactorial — geriatric vestibular evaluation', '[{"label":"A","text":"Single discipline only"},{"label":"B","text":"Multifactorial Dizziness + Falls — Geriatric"},{"label":"C","text":"Medication alone"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multifactorial Dizziness + Falls — Geriatric: (1) **Multifactorial in elderly**: vestibular (bilateral vestibular hypofunction common — "presbyastasis"), proprioceptive (DM neuropathy, B12, cervical), visual (cataract, macular degen, contrast), CV (orthostatic, vasovagal), cognitive (executive, dual-task), polypharmacy (sedating, anticholinergic, antihypertensive, hypoglycemic), MSK (gait, weakness, sarcopenia); (2) **Comprehensive geriatric assessment**: gait, balance (Berg, TUG, mini-BESTest, FGA), vestib (vHIT, dynamic visual acuity, posturography), proprioception, vision, CV (orthostatic, ECG), cognition (MoCA), medication review (Beers, STOPP/START), home safety, social; (3) **Multimodal intervention**: - **Exercise + balance training** (KEY): Otago, Tai Chi, group classes, individualized PT; - **Vestibular rehab** if vestib component; - **Medication review** + deprescribing (Beers); - **Vision + hearing optimization**; - **Vitamin D + Ca** + bone health; - **Address orthostatic hypotension** (volume, compression, midodrine selected); - **Home safety + OT eval**; - **Footwear + assistive device** appropriate; - **Cognitive considerations**; (4) **Evidence**: multifactorial intervention reduces falls 30%+ (Cochrane); (5) **Multidisciplinary**: geriatrician + physiatry + PT + OT + neurology + cardiology + ophthalmology + pharmacy; (6) **CDC STEADI** framework; (7) **Education + family + community resources**; (8) **Outcome**: falls (diary), function, confidence (ABC scale); **Modern**: integrated comprehensive falls clinics + community programs

---

Multifactorial dizziness + falls elderly: comprehensive geriatric assessment. Multimodal — exercise/balance + VRT + meds deprescribe + vision/hearing + ortho/HoTN + vit D + home safety. Multidisciplinary. STEADI.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'CDC STEADI; AGS/BGS Falls', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 75 ปี chronic dizziness + multiple falls + multifactorial — geriatric vestibular evaluation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี post-flexor tendon repair Zone II 2 wk — hand therapy protocol', '[{"label":"A","text":"Cast immobilization 6 wk"},{"label":"B","text":"Flexor Tendon Repair Zone II — Rehab"},{"label":"C","text":"Aggressive early active motion w/o protocol"},{"label":"D","text":"Discharge — no therapy"},{"label":"E","text":"Surgical revision day 14"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Flexor Tendon Repair Zone II — Rehab: (1) **Zone II ("no man''s land")**: fibro-osseous tunnel — historically poor outcomes due to adhesions; modern: early controlled motion essential; (2) **Modern strong repair** (4-6 strand core + epitendinous) tolerates early loading; (3) **Protocols**: - **Modified Duran (early passive motion)**: passive flex w/ hand therapist + dorsal blocking splint (wrist 20-30° flex, MCP 50-70° flex, IPs extended) × 4-6 wk; - **Kleinert (rubber-band traction)**: passive flexion via rubber band + active extension into splint; - **Early active motion (EAM)**: place-and-hold + true active — used w/ strong repairs (Indianapolis Saint Mary''s), Manchester protocols; better outcomes w/ modern repairs; (4) **Phased progression**: - 0-4 wk: dorsal block + early controlled motion; - 4-6 wk: composite + tendon glide; - 6-8 wk: discontinue splint + AROM, light functional; - 8-12 wk: strengthening progressive; - 12+ wk: return to full activity + heavy use; (5) **Hand therapist (CHT)** essential — protocols precise; (6) **Complications**: rupture (premature loading), adhesion (insufficient gliding), joint stiffness; (7) **Outcomes**: TAM (total active motion), strength, function (DASH, MHQ); (8) **Multidisciplinary**: hand surgeon + CHT + OT + patient/family education + adherence; (9) **Tenolysis** if adhesion-limited refractory; **Modern**: strong repair + early active motion + CHT

---

Flexor Z II: early controlled motion w/ dorsal block. Modified Duran/Kleinert/EAM. Strong modern repair tolerates EAM. Phased. CHT essential. Complications rupture vs adhesion. Outcomes TAM/DASH.', NULL,
  'hard', 'msk_nontrauma', 'review',
  'rehab_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'ASSH; Hand Therapy CPG', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี post-flexor tendon repair Zone II 2 wk — hand therapy protocol'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี carpal tunnel syndrome moderate — failed splint + meds — considering options', '[{"label":"A","text":"Long-term opioid"},{"label":"B","text":"Carpal Tunnel Syndrome Management"},{"label":"C","text":"Casting 3 mo"},{"label":"D","text":"No treatment"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Carpal Tunnel Syndrome Management: (1) **Diagnosis**: symptoms (median distribution paresthesia, nocturnal, Phalen/Tinel/median compression test), exam (sensory, motor — thenar, two-point), EDS (NCS — distal latency, amplitude, axonal; EMG if motor); MSK US emerging; (2) **Severity**: mild (sensory + intermittent), moderate (positive EDS + frequent), severe (motor + atrophy + denervation); (3) **Management staged**: - **Mild-moderate**: nocturnal splint (neutral wrist), activity modification, ergonomics, NSAID short-term, gabapentin selected; - **Steroid injection**: temporary; diagnostic + therapeutic; multiple injections discouraged; - **Surgical (CTR)**: failed conservative ≥ 3-6 mo OR severe (motor, atrophy, advanced EDS) — open or endoscopic similar outcomes; (4) **Post-op rehab**: wound care + early ROM (no immobilization usually) + scar massage + gradual loading + return to activity 4-6 wk light, full 6-12 wk; (5) **Hand therapy** (CHT-led): tendon + nerve gliding exercises, ergonomics, education; (6) **Pre-op + post-op**: address contributors (DM, hypothyroidism, pregnancy resolves spontaneously, RA, obesity, repetitive); (7) **Severe atrophy**: opponensplasty selected; (8) **Outcomes**: BCTQ (Boston Carpal Tunnel Questionnaire), DASH, symptom resolution, return to work; (9) **Workers compensation**: ergonomic mod + RTW planning; **Modern**: US-guided injection + endoscopic + ultra-minimally invasive emerging

---

CTS staged: mild-mod splint + NSAID + ergonomics + steroid Inj. Surgical for failed conservative or severe. Post-op rehab + CHT. Contributors. BCTQ outcomes. Modern: US-guided + endoscopic.', NULL,
  'easy', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'AAOS CTS CPG', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี carpal tunnel syndrome moderate — failed splint + meds — considering options'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี Dupuytren contracture digit ring + small — flexion contracture MCP + PIP — functional', '[{"label":"A","text":"Bedrest"},{"label":"B","text":"Hueston tabletop test"},{"label":"C","text":"Single intervention without rehab"},{"label":"D","text":"Amputation first"},{"label":"E","text":"Discharge — no Tx"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Dupuytren Contracture: (1) **Pathology**: fibroproliferative disorder palmar fascia → nodules + cords + flexion contracture; genetic + northern European > African descent; risk DM, alcohol, smoking, age, male; (2) **Assessment**: nodule + cord exam, **Hueston tabletop test** (cannot lay hand flat → likely need intervention), MCP + PIP contracture measurement; functional impact; (3) **Indications for treatment**: MCP contracture ≥ 30°, any PIP contracture, functional limit; (4) **Treatment options**: - **Needle aponeurotomy (NA, percutaneous)**: in-office, immediate, MCP > PIP responsive, higher recurrence (50-80% 5 yr); - **Collagenase clostridium histolyticum (CCH)** — Xiaflex: enzyme injection + day 2-3 manipulation; effective; modest recurrence; pricey, availability varies; - **Open fasciectomy**: surgical removal cord/diseased fascia; lower recurrence (~20-30% at 5 yr); longer recovery, complications (nerve, skin, infection); - **Dermofasciectomy + skin graft**: severe/recurrent; - **PIP arthrodesis or amputation**: last resort severe long-standing; (5) **Post-procedure rehab — CHT-led**: splinting (extension), ROM (active + passive), edema, scar, functional; commitment important; (6) **Recurrence common** — discuss expectations; (7) **Address contributors**: DM, alcohol; (8) **Patient-centered selection**: trade-offs (recurrence vs invasiveness vs recovery time); **Modern**: minimally invasive options + early intervention + CHT

---

Dupuytren: tabletop test + contracture measure. Indications MCP ≥30° or PIP. Options: NA + CCH + fasciectomy + skin graft + arthrodesis. CHT post-procedure splint + ROM. Recurrence common. Patient-centered.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'rehab_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'ASSH Dupuytren', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี Dupuytren contracture digit ring + small — flexion contracture MCP + PIP — functional'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี trigger finger (stenosing tenosynovitis) — flexor digitorum profundus thumb — locking', '[{"label":"A","text":"Bedrest immobilization 6 wk"},{"label":"B","text":"Trigger Finger Management"},{"label":"C","text":"Inject into tendon directly"},{"label":"D","text":"Amputation"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Trigger Finger Management: (1) **Pathology**: stenosing tenosynovitis A1 pulley → triggering/locking finger flexor tendon; thumb common — FPL through A1; risk DM, RA, repetitive use; (2) **Quinnell grade**: 1 uneven motion → 2 actively correctable triggering → 3 passively correctable → 4 fixed contracture; (3) **Treatment stepwise**: - **Conservative**: activity modification, NSAID short-term, splint (MCP extension blocking 4-6 wk evidence in mild); - **Corticosteroid injection** into tendon sheath (NOT tendon — risk rupture): success 70-90% first injection, lower w/ repeated; DM lower success + caution glucose; - **Surgical release A1 pulley**: failed 2+ injections OR severe Gr 3-4 — open or percutaneous; excellent outcomes; (4) **Pediatric trigger thumb**: often resolves spontaneously; surgery after age 1-2 if persistent; (5) **Post-op**: early ROM + return to function 1-2 wk; CHT brief OK; (6) **Complications**: bowstringing rare, nerve, recurrence; (7) **DM** higher recurrence + failure → address glycemic; (8) **Multidigit involvement**: consider underlying (RA, DM, mucopolysaccharidoses); (9) **Patient education + ergonomics**; **Modern**: US-guided injection + percutaneous release

---

Trigger finger: A1 pulley tenosynovitis. Conservative (splint + NSAID) → steroid injection sheath (NOT tendon) 70-90% → surgical release. Quinnell grading. DM lower success. CHT brief. Modern: US-guided.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'rehab_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'ASSH', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี trigger finger (stenosing tenosynovitis) — flexor digitorum profundus thumb — locking'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี post-distal radius fracture (intra-articular) ORIF 6 wk — hand therapy', '[{"label":"A","text":"Cast 12 wk"},{"label":"B","text":"Post-Distal Radius Fracture (ORIF) Rehab"},{"label":"C","text":"Aggressive ROM immediately heavy"},{"label":"D","text":"No therapy"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-Distal Radius Fracture (ORIF) Rehab: (1) **Common fragility fracture** (post-menopausal, elderly); high-energy in young; (2) **Post-op phases**: - **0-2 wk**: protect, edema control (compression, elevation), pain, immobilization or removable splint depending stability, fingers ROM; - **2-6 wk**: progressive wrist + forearm ROM (active assisted → active), continued edema + scar mgmt; - **6-12 wk**: strengthening (progressive — putty → grippers → resisted), proprioception, functional, gradual loading; - **12+ wk**: heavy loading + return to sport/work; (3) **Hand therapist (CHT)** central; (4) **Common issues + management**: - **Stiffness**: dynamic + static splinting + ROM; - **CRPS** (5-30% risk): vit C 500 mg/d preventive (Zollinger); early identification + Tx (GMI, mobilization, multimodal); - **Tendon issues**: EPL rupture (~5%) — Lister tubercle; tendon transfer (EIP to EPL); - **Carpal tunnel** post-injury; - **Malunion** functional impact assessment; (5) **Functional rehab**: ADLs, work simulation, ergonomics; (6) **Pain**: multimodal opioid-sparing; (7) **Bone health**: DXA + osteoporosis Tx in fragility fx (FLS — fracture liaison service); fall prevention; (8) **Outcomes**: PRWE, DASH, ROM, grip strength; (9) **Address contributors**: smoking, vit D, nutrition; **Modern**: early motion + CRPS prevention + bone health integration

---

DRF ORIF rehab: phased — protect + edema → ROM → strengthening → return. CHT central. Stiffness + CRPS (vit C prevention) + EPL rupture + carpal tunnel risks. Bone health FLS. PRWE/DASH outcomes.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'rehab_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAOS DRF; CHT', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี post-distal radius fracture (intra-articular) ORIF 6 wk — hand therapy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 80 ปี recurrent falls 3× past 6 mo — multifactorial — comprehensive evaluation', '[{"label":"A","text":"Bedrest — prevent falls"},{"label":"B","text":"Falls — Comprehensive Multifactorial Assessment + Intervention"},{"label":"C","text":"Single intervention"},{"label":"D","text":"Restraints continuous"},{"label":"E","text":"Discharge — no follow-up"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Falls — Comprehensive Multifactorial Assessment + Intervention: (1) **AGS/BGS + CDC STEADI** approach; (2) **Screening (annual)**: 3 questions (falls past yr, fear, unsteadiness); (3) **Multifactorial assessment** for high-risk: - History + circumstances of falls + meds + comorbidities; - **Gait + balance**: TUG (>13.5 s risk), 5× sit-to-stand, BBS, gait speed, FGA, mini-BESTest, dynamic gait; - **Strength**: 5× STS, hand grip; - **Cognition**: MoCA + executive; - **Vision**: acuity, contrast; - **Hearing**; - **Vestibular**: vHIT, posturography; - **Proprioception** + sensory; - **CV**: orthostatic vital signs, ECG; - **Foot + footwear**; - **Polypharmacy** (Beers, STOPP/START — FRIDS: fall-risk-increasing drugs); - **Home environment**; - **Mood + sleep**; - **Bone health + vit D + Ca**; - **Continence**; - **Social**; (4) **Multifactorial Intervention** (KEY — strong evidence): - **Exercise** (strongest): Otago, Tai Chi (especially), group + individualized + balance + strength; - **Medication review + deprescribing**; - **Vision + hearing optimization**; - **Vitamin D ≥ 800-1000 IU/d** if deficient; - **Home modifications** (OT); - **Cataract surgery**; - **Cardiovascular Tx** (pacemaker if syncope/cardioinhibitory); - **Footwear** + assistive devices; - **Cognitive considerations**; (5) **Bone health** (osteoporosis Tx, fracture liaison); (6) **Multidisciplinary**: geriatrician + physiatry + PT + OT + pharmacy + neurology + cardiology + ophth + audiology; (7) **Family + caregiver education + community resources**; (8) **Outcomes**: falls (diary), function, fear (ABC), confidence; **Modern**: comprehensive falls clinics + community + technology (wearables, AI)

---

Falls multifactorial: AGS/CDC STEADI. Comprehensive assessment + multifactorial intervention (Cochrane reduces 30%). Exercise (Tai Chi, Otago) KEY. Deprescribe FRIDS. Vision + vit D + home + bone health. Multidisciplinary.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'AGS/BGS Falls; CDC STEADI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 80 ปี recurrent falls 3× past 6 mo — multifactorial — comprehensive evaluation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 78 ปี frailty + sarcopenia + dependent ADL trajectory — community-dwelling', '[{"label":"A","text":"Bedrest"},{"label":"B","text":"Sarcopenia + Frailty Management"},{"label":"C","text":"Single discipline"},{"label":"D","text":"Nutritional supplement only"},{"label":"E","text":"Discharge no intervention"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Sarcopenia + Frailty Management: (1) **Definitions**: - **Sarcopenia** (EWGSOP2 2019): low muscle strength (grip, chair stand) + low muscle quantity (DXA, BIA, US, MRI) + low physical performance (gait speed, SPPB, TUG) — confirmatory; - **Frailty** (Fried 5 phenotype): weight loss, exhaustion, weakness (grip), slowness, low activity; or accumulation index (Rockwood); (2) **Assessment**: SARC-F screen (sarcopenia), CFS (Clinical Frailty Scale), comprehensive geriatric assessment; (3) **Multimodal intervention (KEY)**: - **Exercise — resistance** training (1-3 sets, 8-12 reps, 2-3 d/wk, 60-80% 1RM) — STRONGEST evidence; + aerobic + balance; - **Nutritional**: protein 1.0-1.5 g/kg/d (higher in older), leucine-enriched + amino acids, vitamin D supplementation (≥ 800-1000 IU/d if deficient), adequate calories; - **Address comorbidities**: chronic disease, polypharmacy, mood, sleep, social isolation; - **Polypharmacy review** + deprescribing; (4) **Specific pharmacotherapy**: investigational (myostatin inhibitors, anamorelin); testosterone selected; (5) **Cognitive + mood**; (6) **Social** + community programs + group exercise; (7) **Multidisciplinary**: geriatrician + physiatry + PT + dietitian + pharmacy + social work + nursing; (8) **Outcomes**: SPPB, gait speed, grip, IADL, falls, hospitalizations; (9) **Goals of care** + advance planning + values; (10) **Family + caregiver**; **Modern**: integrated geriatric rehab + community + technology-enabled

---

Sarcopenia/frailty: EWGSOP2 + Fried/Rockwood. SARC-F + CFS. Multimodal: resistance exercise STRONGEST + protein 1.0-1.5 + vit D + address comorbidity + deprescribe + social. Multidisciplinary. SPPB outcomes.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'rehab_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'EWGSOP2 2019; Fried', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 78 ปี frailty + sarcopenia + dependent ADL trajectory — community-dwelling'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 82 ปี mild cognitive impairment + early dementia — rehab considerations + adaptations', '[{"label":"A","text":"Standard rehab no adaptations"},{"label":"B","text":"Cognitive Impairment Rehab Adaptations"},{"label":"C","text":"Sedate continuously"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cognitive Impairment Rehab Adaptations: (1) **Comprehensive evaluation**: cognitive (MoCA, MMSE, neuropsych), function (IADL, ADL), behavior, mood, safety, caregiver; etiology (Alzheimer''s, vascular, Lewy body, FTD); medication review; (2) **Rehab adaptations**: - Simple + clear instructions, one step at a time; - Demonstration + tactile cuing; - Consistent staff + routine + environment; - Visual + auditory cues + reminders; - Errorless learning + spaced retrieval (good evidence MCI/early); - Task-specific functional training; - Environmental modifications (signs, labels, simplified); - Shorter, more frequent sessions; - Family + caregiver engagement central; (3) **Exercise**: aerobic + resistance + balance — preserves function, mood, possibly cognition (mixed evidence MCI/dementia); group classes; supervision; (4) **OT**: ADL retraining + adaptive equipment + home safety + cognitive aids (apps, calendars, reminders); (5) **PT**: gait, balance, falls prevention; (6) **SLP**: communication + swallow assessment + cognitive-communication; (7) **Mood**: depression high in dementia — non-pharm first + SSRI selected; (8) **Behavioral + psychological symptoms (BPSD)**: identify triggers + behavioral approaches first; cautious pharm (avoid antipsychotic when possible — boxed warning); (9) **Caregiver education + support + respite**; (10) **Goals of care + advance directives**: stage-appropriate; (11) **Driving + safety + finances + legal**; (12) **Multidisciplinary**: geriatrician/cognitive neurology + physiatry + PT + OT + SLP + neuropsych + social work + family; **Modern**: person-centered + dementia-friendly care + caregiver-focused

---

Cognitive impairment rehab: adaptations (simple + routine + cues + errorless learning + family). Exercise preserves function. OT + PT + SLP. Mood + BPSD non-pharm first. Caregiver. GoC. Multidisciplinary. Person-centered.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'AAN Dementia; AGS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 82 ปี mild cognitive impairment + early dementia — rehab considerations + adaptations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 80 ปี polypharmacy (15 medications) — referred for review + functional decline', '[{"label":"A","text":"Continue all medications"},{"label":"B","text":"Geriatric Polypharmacy + Deprescribing"},{"label":"C","text":"Discontinue all medications immediately"},{"label":"D","text":"No review"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Geriatric Polypharmacy + Deprescribing: (1) **Polypharmacy**: ≥5 meds — common in older + multimorbid; associated falls, ADRs, cognitive impairment, hospitalization, mortality, nonadherence; (2) **Comprehensive medication review**: - **Beers Criteria** (AGS): potentially inappropriate medications older adults — avoid or use w/ caution; - **STOPP/START** (European): STOPP = stop list; START = start list (e.g., bone health, anticoagulation indicated); - **MAI** (Medication Appropriateness Index); - Anticholinergic burden (ACB scale); - Drug-drug + drug-disease interactions; - Renal + hepatic dosing; (3) **Deprescribing process** (Reeve, Scott): - List all meds; - Identify potentially inappropriate; - Determine if can be deprescribed; - Plan + monitor + adjust; - Shared decision w/ patient + family; (4) **Common targets**: - **Benzodiazepines + Z-drugs**: falls, cognition — taper; - **Anticholinergics**: cognition; - **PPIs**: long-term re-evaluate; - **Antipsychotics for BPSD**: black box mortality; - **NSAIDs**: GI, renal, CV; - **Statins** if limited life expectancy + primary prevention discussion; - **Antihypertensives**: orthostatic risk — reassess targets; - **Antidiabetics**: hypoglycemia — relax A1c targets older; (5) **Critical not to under-prescribe**: pain, depression, bone health, anticoagulation when indicated; (6) **Multidisciplinary**: physiatry + geriatrician + pharmacy + PCP + nursing + family; (7) **Continuity** across transitions; (8) **Outcomes**: functional, falls, hospitalizations, QOL; **Modern**: technology (CDS — clinical decision support) + integrated team-based

---

Polypharmacy: Beers/STOPP/START + ACB. Deprescribing process: identify + assess + plan + monitor + shared decision. Common targets: benzo, anticholinergic, PPI, AP, NSAID, statin reassess. Avoid under-prescribing. Multidisciplinary.', NULL,
  'hard', 'psych_behavior', 'review',
  'rehab_medicine', 'clinical_decision', 'psych_behavior', 'adult',
  'AGS Beers 2023; STOPP/START', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 80 ปี polypharmacy (15 medications) — referred for review + functional decline'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 85 ปี delirium during inpatient rehab — interfering with progress', '[{"label":"A","text":"Sedate w/ benzodiazepine"},{"label":"B","text":"Delirium in Rehab Setting"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Restraint primary"},{"label":"E","text":"Discontinue rehab"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Delirium in Rehab Setting: (1) **Detection**: CAM (Confusion Assessment Method) — acute change + fluctuating + inattention + (disorganized thinking OR altered LOC); 4AT brief; (2) **Hypoactive (more common older + missed) vs hyperactive vs mixed**; (3) **Etiology workup**: DELIRIUMS mnemonic + thorough search — infection (UTI, pneumonia, CDIff), meds (anticholinergic, opioid, benzo, steroid, polypharmacy), metabolic (Na, glucose, Ca, BUN/Cr), hypoxia, alcohol/sedative withdrawal, constipation/retention, pain, sleep disruption, sensory deprivation, hospital environment, stroke/TBI; (4) **Non-pharmacological FIRST (KEY)**: - **HELP/ABCDEF bundle elements**: orientation, mobility, sleep, hydration, vision/hearing aids, sensory, music, family presence, normalize environment; - Reduce restraint (use selectively); - Optimize meds — remove offending; - Treat pain (multimodal opioid-sparing); - Address constipation, urinary retention, sleep; - Family + familiar objects; (5) **Pharmacological** (only for severe agitation/safety when non-pharm fails): - Low-dose haloperidol (0.5-1 mg) — risk EPS + QTc; - Atypical (quetiapine, risperidone) — risk; - AVOID benzodiazepines (worsen except alcohol/sedative withdrawal) + anticholinergics; - Caution dexmedetomidine; (6) **Rehab adjustments**: continue mobility (helps delirium!), shorter sessions, structure, supervision, safety; (7) **Family + caregiver education + presence**; (8) **Post-delirium**: cognitive sequelae monitoring (PICS); (9) **Multidisciplinary**: geriatrician + physiatry + PT + OT + nursing + family + psych selected; **Modern**: ABCDEF + HELP + delirium-aware rehab

---

Delirium: CAM Dx. DELIRIUMS workup (meds, infection, metabolic, pain, sleep, urine/stool). Non-pharm FIRST (HELP, ABCDEF). Continue mobility. Pharm last resort low-dose AP. AVOID benzo. Family + multidisciplinary.', NULL,
  'medium', 'psych_behavior', 'review',
  'rehab_medicine', 'clinical_decision', 'psych_behavior', 'adult',
  'ABCDEF Bundle; HELP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 85 ปี delirium during inpatient rehab — interfering with progress'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 78 ปี end-of-life — declining function + wishes to remain home — interdisciplinary planning', '[{"label":"A","text":"Aggressive rehab to baseline"},{"label":"B","text":"End-of-Life + Home-Based Care"},{"label":"C","text":"Hospital LTC"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Refuse home services"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** End-of-Life + Home-Based Care: (1) **Patient-centered + goals-based**: what matters most — function, comfort, dignity, family, location of death; advance directives + POLST/MOLST; (2) **Multidisciplinary team**: physiatry + palliative care/hospice + PCP + nursing + PT/OT + SLP + social work + chaplain + family + caregiver; (3) **Functional optimization within prognosis**: - Maintain mobility + ADL where possible; - Energy conservation (4 P); - Adaptive equipment + DME for home (hospital bed, W/C, commode, raised toilet, shower bench, lift); - Home modifications + safety; (4) **Symptom management**: pain (multimodal w/ adequate opioid in advanced disease), dyspnea (opioid, fan, position, O2 selected), nausea, constipation, anorexia, anxiety, depression; (5) **Caregiver education + support + respite + 24/7 contact**; (6) **Advance care planning + values discussion**: aligned care + avoid burdensome treatments; (7) **Spiritual care + meaning-making**: chaplain + family rituals; (8) **Hospice eligibility + transition**: prognosis ≤ 6 mo + comfort focus; hospice provides team + meds + equipment + 24/7 + respite + bereavement; (9) **Bereavement support**: family throughout + after; (10) **Cultural humility + preferences**; (11) **Death at home logistics**: pronouncement, mortuary, post-death support; (12) **Outcomes**: comfort, QOL, satisfaction, family well-being; **Modern**: integrated palliative rehab + home-based hospice + family-centered

---

End-of-life home: patient-centered + goals. Multidisciplinary including hospice. Functional optimization w/in prognosis. Symptom mgmt. Caregiver. Advance planning. Spiritual. Hospice eligibility. Bereavement. Cultural. Modern integrated.', NULL,
  'medium', 'psych_behavior', 'review',
  'rehab_medicine', 'clinical_decision', 'psych_behavior', 'adult',
  'AAHPM; CAPC', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 78 ปี end-of-life — declining function + wishes to remain home — interdisciplinary planning'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย Parkinson disease (Hoehn-Yahr 3) — gait freezing + falls + tremor — comprehensive rehab', '[{"label":"A","text":"Bedrest"},{"label":"B","text":"Parkinson Disease Rehab — Multidisciplinary"},{"label":"C","text":"Single discipline"},{"label":"D","text":"No exercise — risk falls"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Parkinson Disease Rehab — Multidisciplinary: (1) **Multidisciplinary**: movement disorder neurology + physiatry + PT + OT + SLP + neuropsych + nursing + social work + family; (2) **Stage-based** (Hoehn-Yahr): - Early: exercise + education + activity; - Mid (this patient): structured rehab + assistive devices; - Late: care needs + transitions; (3) **PT (evidence-based)**: - **LSVT BIG**: amplitude-based motor — 4 wk × 4 d/wk × 1 h evidence improves bradykinesia + gait + ADLs; - **Tango/dance therapy** — evidence; - **Tai Chi** — balance + falls; - **Aerobic + resistance**; - **Treadmill** training; - **Gait + cueing strategies for freezing**: auditory (metronome), visual (lines on floor), attention; large amplitude, conscious; weight-shifting; - **Balance + falls prevention**; (4) **OT**: ADLs, fine motor, handwriting (LSVT effective for micrographia), home safety; (5) **SLP**: - **LSVT LOUD**: voice amplitude — evidence improves loudness, intelligibility; - Dysphagia: VFSS/FEES + targeted therapy; - Cognitive-communication; (6) **Medication optimization**: levodopa + adjuncts (DA agonist, MAO-B, COMT); DBS for selected refractory; (7) **Non-motor symptoms**: depression (SSRI, ECT, rTMS), anxiety, sleep (RBD), constipation, autonomic, cognitive (donepezil/rivastigmine for PDD), psychosis (pimavanserin, clozapine, quetiapine — NOT typical AP); (8) **Caregiver + family support**; (9) **Advanced disease**: DBS, levodopa-carbidopa intestinal gel, apomorphine, palliative; (10) **Outcomes**: UPDRS, MDS-UPDRS, BERG, TUG, 10MWT, PDQ-39; **Modern**: LSVT + exercise + multidisciplinary + advanced therapies

---

PD rehab: stage-based multidisciplinary. LSVT BIG (PT) + LSVT LOUD (SLP) evidence-based. Tai Chi + dance. Cueing for freezing. OT + meds optimize + DBS selected. Non-motor. Caregiver. Modern integrated.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'MDS-PD Guidelines; LSVT', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย Parkinson disease (Hoehn-Yahr 3) — gait freezing + falls + tremor — comprehensive rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี relapsing-remitting MS — 5 yr disease — moderate disability + fatigue + spasticity', '[{"label":"A","text":"Avoid all exercise"},{"label":"B","text":"Multiple Sclerosis Rehab"},{"label":"C","text":"Single discipline"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multiple Sclerosis Rehab: (1) **Multidisciplinary**: neurology MS + physiatry + PT + OT + SLP + neuropsychology + urology + ophthalmology + psychiatry + social work + family; (2) **Symptom-targeted rehab**: - **Fatigue** (KEY symptom): energy conservation (4 P), graded aerobic + resistance exercise (NOT contraindicated — improves fatigue), cooling strategies, sleep hygiene, mood addressing; pharmacologic — amantadine, modafinil; - **Spasticity**: PT stretching + strengthening + spasm prevention; oral baclofen, tizanidine; ITB for severe; BoNT focal; SDR rare adult; - **Weakness + gait**: exercise + AFO + assistive devices; FES (Walkaide, Bioness); dalfampridine (4-AP) improves gait speed in selected; - **Balance + falls**: PT balance + Tai Chi; - **Bladder dysfunction**: urodynamics + CIC + anticholinergic/β3 + BoNT detrusor; - **Bowel**: scheduled, fiber/fluids; - **Cognitive**: neuropsych + cognitive rehab + accommodations; - **Visual**: optic neuritis + INO management; - **Mood**: depression (high), suicide risk, anxiety, pseudobulbar affect (dextromethorphan/quinidine); - **Sexual + reproductive**: counseling, pregnancy planning, DMT considerations; - **Pain**: neuropathic + spasm + MSK + multimodal; (3) **Disease-modifying therapy (DMT) coordination**; (4) **Exercise** safe + beneficial (HIIT emerging) — counters deconditioning; (5) **Uthoff phenomenon** — heat sensitivity — cooling strategies; (6) **Vocational rehab + ADA + RTW + adaptive equipment**; (7) **Family + caregiver support**; (8) **Modern**: comprehensive MS clinics + DMTs era + integrated rehab

---

MS rehab: symptom-targeted multidisciplinary. Fatigue energy conserve + exercise + amantadine. Spasticity + weakness/gait (dalfampridine, FES) + bladder (CIC) + cognitive + mood + sexual + pain. DMT. Exercise safe. Modern: comprehensive.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'AAN MS Rehab; CMSC', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี relapsing-remitting MS — 5 yr disease — moderate disability + fatigue + spasticity'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี ALS — bulbar onset 1 yr — dysphagia + dysarthria + weight loss', '[{"label":"A","text":"Single discipline"},{"label":"B","text":"ALS Multidisciplinary Care"},{"label":"C","text":"No advance planning"},{"label":"D","text":"Aggressive resistance exercise"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ALS Multidisciplinary Care: (1) **ALS Multidisciplinary Clinic** (gold standard): neurology + pulmonology + physiatry + PT + OT + SLP + nutrition + nursing + social work + respiratory therapist + psychology + chaplain — improves QOL + survival; (2) **Symptom-targeted**: - **Dysphagia**: SLP swallow eval (VFSS); compensatory + diet modification (IDDSI); preserve oral safely; PEG for nutrition (early before FVC < 50%); - **Dysarthria + communication**: SLP + AAC (alternative + augmentative — devices, eye-gaze, brain-computer interface — emerging); speech banking for personalized synthesis; - **Nutrition**: high-calorie + protein + supplements; PEG early; weight maintenance prognostic; - **Pulmonary**: serial PFT (FVC), NIV when SOB or FVC ≤ 50% or sniff < 60% — extends survival + improves QOL; cough assist; trach ventilation discussed; - **Mobility + weakness**: PT (preserve function, ROM, no aggressive resistance — avoid overuse), assistive devices (walker, w/c power), home modifications; - **Spasticity**: baclofen, tizanidine; - **Cramps + fasciculations**: quinine selected, gabapentin; - **Sialorrhea**: glycopyrrolate, BoNT salivary glands, scopolamine; - **Pseudobulbar affect**: dextromethorphan/quinidine; - **Depression + anxiety**: SSRI + counseling; - **Pain**: multimodal; (3) **Disease-modifying**: riluzole (modest), edaravone, AMX0035 (recently FDA), tofersen for SOD1; (4) **Advance care planning EARLY + ongoing**: ventilation + nutrition + end-of-life; (5) **Hospice integration**; (6) **Caregiver + family support critical** — burden high; (7) **Outcomes**: ALSFRS-R, FVC, QOL; **Modern**: multidisciplinary clinic + emerging therapeutics + advance planning

---

ALS multidisciplinary clinic (improves survival). Symptom-targeted: dysphagia/PEG + AAC + NIV + cough assist + mobility (no overuse) + spasticity + sialorrhea + PBA + mood. DMT (riluzole etc). Advance planning early. Caregiver.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'AAN ALS Practice Parameter', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี ALS — bulbar onset 1 yr — dysphagia + dysarthria + weight loss'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย MS — secondary progressive — wheelchair-bound 5 yr — caregiver burnout', '[{"label":"A","text":"Ignore caregiver"},{"label":"B","text":"Advanced MS + Caregiver-Centered Care"},{"label":"C","text":"Single discipline"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Hospice — no rehab"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Advanced MS + Caregiver-Centered Care: (1) **Comprehensive evaluation**: function, complications (pressure injuries, contractures, infections, DVT), psychosocial, caregiver; (2) **Multidisciplinary**: neurology + physiatry + PT + OT + SLP + nursing + social work + psychology + palliative care + family; (3) **Maintain quality of life + dignity**: - Mobility (power w/c, transfers, lift); - ADLs + adaptive equipment + personal care; - Communication (AAC if dysarthria/cognitive); - Nutrition + swallow safety; - Bladder/bowel; - Skin (pressure injury prevention); - Spasticity + pain management; - Cognitive + mood; - Sexual + intimacy; (4) **Caregiver burden assessment** (Zarit Burden Interview): physical + emotional + financial; (5) **Caregiver support** (KEY): - Education + training + skill-building; - Respite care (home, day, short-stay); - Peer support + MS Society resources; - Mental health (caregiver depression high); - Financial + legal + advocacy; - Family meetings + communication; - Acknowledgment + appreciation; (6) **Adaptive equipment + home modifications**: increase independence + reduce caregiver burden; (7) **Community resources**: MS Society, day programs, transportation; (8) **Advance care planning + GoC**: progressive trajectory; advance directives; palliative integration; hospice when appropriate; (9) **Crisis planning**: respite, hospital transitions; (10) **Cultural humility**; (11) **Outcomes**: function, complications, QOL (patient + caregiver), caregiver burden, satisfaction; **Modern**: caregiver-inclusive + technology + community + integrated palliative

---

Advanced MS + caregiver: multidisciplinary. Maintain QOL/dignity. Caregiver assessment (Zarit) + education + respite + peer + mental health + financial + family meeting. Adaptive equipment. GoC. Modern: caregiver-inclusive.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'CMSC; NMSS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย MS — secondary progressive — wheelchair-bound 5 yr — caregiver burnout'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี early Parkinson disease — newly diagnosed — exercise + lifestyle counseling', '[{"label":"A","text":"Wait — bedrest"},{"label":"B","text":"Early PD — Exercise as Disease-Modifying"},{"label":"C","text":"Single discipline reactive only"},{"label":"D","text":"Discharge no follow-up"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Early PD — Exercise as Disease-Modifying: (1) **Diagnosis confirmed**: motor (bradykinesia + rest tremor/rigidity) + supportive (response to levodopa); referral movement disorder; (2) **Exercise** (evidence growing — possibly disease-modifying): - **Aerobic moderate-vigorous** (cycling, treadmill — Park-in-Shape, SPARX trials show benefit) — recommended 150 min/wk moderate or 75 vigorous; - **Resistance** 2-3 d/wk; - **Balance + flexibility**; - **Tai Chi, dance (tango), boxing** — popular w/ evidence; - **PWR! Moves, LSVT BIG** for amplitude; (3) **Lifestyle**: Mediterranean diet, sleep hygiene, social engagement, cognitive engagement, smoking cessation, moderate caffeine (?protective); (4) **Mood + cognition** baseline + monitor: depression, anxiety, RBD, MCI; (5) **Education**: disease, expectations, support groups; (6) **Vocational + driving** counseling; (7) **Pharmacotherapy initiation** (timing controversial — symptom-based; levodopa mainstay; MAO-B inhibitor for mild; DA agonist; amantadine for dyskinesia later; deprenyl); (8) **Non-motor screen + management** (RBD, constipation, autonomic, anosmia, mood — often precede motor); (9) **Multidisciplinary involvement EARLY** (not just advanced) improves outcomes; (10) **Driving + safety**: cognitive + visual + motor + driving eval; (11) **Patient empowerment + self-management**; **Modern**: "Exercise as Medicine" + early multidisciplinary + emerging neuromodulation

---

Early PD: exercise as Rx (aerobic + resistance + balance + Tai Chi/boxing/dance) — possibly disease-modifying. Lifestyle. Multidisciplinary EARLY. Mood + cognition + non-motor screen. Pharma initiation. Education.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'MDS-PD; Park-in-Shape; SPARX', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี early Parkinson disease — newly diagnosed — exercise + lifestyle counseling'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย MS — bladder dysfunction (urgency, frequency, incontinence) — referred urology + rehab', '[{"label":"A","text":"Foley indefinitely"},{"label":"B","text":"MS Neurogenic Bladder Management"},{"label":"C","text":"No assessment"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** MS Neurogenic Bladder Management: (1) **Common in MS** (~75-90% over disease course); impacts QOL; (2) **Symptom-based assessment + urodynamics**: pattern — detrusor overactivity (most common — urgency, frequency, urge incontinence), DSD (incomplete emptying, hesitancy, infections), failure to store + failure to empty combined; (3) **Workup**: urodynamics + PVR (post-void residual) + UA/Cx + renal US selected; (4) **Conservative**: timed voiding, fluid management, pelvic floor PT (Kegels, biofeedback), avoid caffeine/alcohol; (5) **Storage failure (overactivity)**: - **Anticholinergics** (oxybutynin, tolterodine, solifenacin, darifenacin) — caution cognitive SE in MS; - **β3-agonist** (mirabegron) — less cognitive; - **BoNT-A detrusor injection** refractory; - **Sacral neuromodulation** selected; (6) **Empty failure (DSD, atony)**: - **Clean intermittent catheterization (CIC)** preferred when PVR elevated; - α-blockers (tamsulosin) selected; - Suprapubic catheter rarely; (7) **UTI**: treat symptomatic, NOT asymptomatic bacteriuria; address contributors; (8) **Renal preservation**: avoid high storage pressure; surveillance; (9) **Education + adaptive equipment + community + sexual** integration; (10) **Multidisciplinary**: urology + neurology + physiatry + pelvic floor PT + nursing + sexual health; (11) **Outcomes**: PROs (KHQ, OAB-q), QOL, UTI rate, function; **Modern**: target therapies + neuromodulation + integrated

---

MS bladder: urodynamics-guided. Storage (overactivity) — anticholinergic/β3/BoNT/SNM. Emptying — CIC. Pelvic floor PT. Treat sympt UTI only. Renal preservation. Multidisciplinary. Modern: targeted + neuromodulation.', NULL,
  'medium', 'renal_gu', 'review',
  'rehab_medicine', 'clinical_decision', 'renal_gu', 'adult',
  'AUA; AAN MS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย MS — bladder dysfunction (urgency, frequency, incontinence) — referred urology + rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 25 ปี Guillain-Barré syndrome (AIDP) post-ICU — 6 wk post — significant weakness — admit rehab', '[{"label":"A","text":"Aggressive maximal exercise"},{"label":"B","text":"Post-GBS Rehabilitation"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-GBS Rehabilitation: (1) **Multidisciplinary**: neurology + physiatry + PT + OT + SLP + RT + nutrition + psychology + family; (2) **Phased approach**: - **Plateau/early recovery**: mobility (transfers, sitting, standing tolerance, gait initiation), strength training (CAREFUL — avoid overwork weakness; submaximal eccentric/concentric, monitor fatigue + delayed weakness), endurance, ADLs, equipment; - **Recovery**: progressive strength, endurance, balance, functional + return-to-prior-activity, vocational; (3) **Avoid overuse weakness** (Bensman): submaximal, monitor symptoms post-exercise; (4) **Pulmonary**: IS, breathing exercises, IMT, cough assist if weak; airway clearance; serial vital capacity in recovering patients; (5) **Cardiovascular dysautonomia**: orthostatic hypotension common — gradual upright training, compression, fluids, salt, midodrine selected; arrhythmia monitor; (6) **Pain**: neuropathic + back/joint — gabapentin, TCA, multimodal; (7) **Fatigue**: significant + lasting — energy conservation, graded exercise, pacing; (8) **Mood**: depression + anxiety + PTSD common — screen, CBT, SSRI; (9) **Sensory**: numbness + dysesthesia — desensitization; (10) **Cranial nerve**: dysphagia + facial — SLP eval, swallow strategies; (11) **DVT prevention** during immobility phase; (12) **Family + caregiver education + support**; (13) **Long-term**: most recover but residual common (20%); fatigue often persistent; vocational + community reintegration; **Modern**: structured rehab + outcomes-tracked + multidisciplinary

---

GBS rehab: phased multidisciplinary. AVOID overuse weakness (submaximal). Pulm (cough assist, IMT, VC). Dysautonomia (ortho). Pain + fatigue + mood + sensory + dysphagia. DVT. Family. Long-term residual. Modern structured.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'Bensman; AAN GBS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 25 ปี Guillain-Barré syndrome (AIDP) post-ICU — 6 wk post — significant weakness — admit rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย post-burn 30% TBSA — deep partial + full-thickness — 3 wk post — rehab planning', '[{"label":"A","text":"No splint"},{"label":"B","text":"Burn Rehabilitation — Comprehensive"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Discharge — no scar mgmt"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Burn Rehabilitation — Comprehensive: (1) **Multidisciplinary burn center team**: burn surgeon + physiatrist + PT + OT + RT + nutrition + psychology + child life (peds) + nursing + social work; (2) **Phases**: - **Acute/critical**: resuscitation + early ROM/positioning + splinting (anti-deformity — neck ext, shoulder abducted, elbow ext, wrist neutral, hip ext, knee ext, ankle neutral), wound care, nutrition, pain; - **Surgical**: excision + grafting; rehab during inter-operative; - **Rehabilitative (this patient)**: aggressive ROM + strengthening + scar management + functional + community; - **Long-term**: continued; (3) **Splinting + positioning (KEY)**: prevents contractures — anti-deformity positions; serial casting/dynamic splinting for established; custom orthoses (CHT/OT); (4) **Range of motion**: aggressive + frequent — even painful; address potential burn-specific contractures (axillary, antecubital, popliteal, cervical); (5) **Strengthening + endurance**: progressive; (6) **Scar management** (KEY): - **Pressure garments** 23 h/d × 12-18+ mo (custom, 15-25 mmHg) — reduces hypertrophy; - **Silicone gel sheeting** evidence for hypertrophy; - **Massage** (scar mobilization); - **Moisturizer + sun protection**; - **Laser** (PDL, fractional CO2) — emerging strong evidence for hypertrophic scar + contracture; - **Steroid injection** for hypertrophic/keloid; - **Surgical scar revision/Z-plasty** for contracture refractory; (7) **Pain management**: multimodal — opioid + adjuvants (gabapentin), NSAID + non-pharm (VR distraction, hypnosis); (8) **Psychosocial**: PTSD, anxiety, depression, body image, family — CBT; (9) **Nutrition**: high-protein, calories, vit C, zinc; (10) **Functional + RTW + driving + return-to-community**; (11) **Pediatric considerations**: growth, contracture risk w/ growth, family; **Modern**: laser + biologics + multidisciplinary burn rehab

---

Burn rehab: multidisciplinary phased. Anti-deformity splinting + aggressive ROM + scar mgmt (pressure garments + silicone + laser + steroid). Pain multimodal + non-pharm. Psychosocial. Nutrition. Long-term. Modern: laser/biologics.', NULL,
  'medium', 'trauma', 'review',
  'rehab_medicine', 'clinical_decision', 'trauma', 'adult',
  'ABA Burn Rehab; ISBI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย post-burn 30% TBSA — deep partial + full-thickness — 3 wk post — rehab planning'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย post-burn hand — palmar burn deep partial — early management', '[{"label":"A","text":"Cast 6 wk"},{"label":"B","text":"Hand Burn — Rehabilitation"},{"label":"C","text":"No splint"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Amputation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hand Burn — Rehabilitation: (1) **Functional significance**: small surface but high impact; aggressive rehab essential; (2) **Acute management**: wound care + early surgery (excision + graft if deep), edema control (elevation), splinting ("position of safety" — wrist 20-30° ext, MCP 60-70° flex, IP ext, thumb opposition/abduction) — prevents intrinsic-minus + extrinsic shortening; (3) **Early ROM**: as soon as possible — daily PROM/AROM (even painful) by hand therapist (CHT); preserves tendon glide + joint motion; (4) **Post-graft phase**: typically 5-7 d immobilization → active ROM; protect graft initially; (5) **Specific issues**: - **Palmar burn** + deep — risk web space syndactyly, claw deformity, scar contracture (especially MCP flex contracture if not splinted); - **Dorsal burn** — risk boutonniere from PIP swelling/extensor injury; - **Web space** scar contracture — splinting + Z-plasty; (6) **Edema control**: elevation + compression (Coban) + active ROM; (7) **Scar management**: pressure gloves (custom, 12-18 mo), silicone, massage, laser (PDL, fractional CO2); (8) **Strengthening progressive**: putty + grippers + functional; (9) **Sensory re-education**: desensitization + protective sensation; (10) **Functional + ADL + fine motor + work**: integrated; (11) **CHT-led** central; (12) **Patient + family education + adherence**: home program critical; (13) **Outcomes**: TAM, DASH, MHQ, function; **Modern**: early surgery + aggressive rehab + laser scar + CHT

---

Hand burn: position of safety splinting (wrist ext, MCP flex, IP ext, thumb abduct). Early ROM by CHT. Edema control. Scar mgmt (pressure glove + silicone + laser). Specific issues palmar vs dorsal. Sensory + functional. CHT-led.', NULL,
  'medium', 'trauma', 'review',
  'rehab_medicine', 'clinical_decision', 'trauma', 'adult',
  'ABA; ASSH Burn Hand', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย post-burn hand — palmar burn deep partial — early management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กอายุ 7 ปี post-burn — รุนแรง full-thickness anterior neck — 1 yr post — cervical flexion contracture', '[{"label":"A","text":"Bedrest no splint"},{"label":"B","text":"Pediatric Neck Burn Contracture"},{"label":"C","text":"Cast neck flexed"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Neck Burn Contracture: (1) **Pediatric considerations**: contractures more severe relative to body growth; psychological + body image developmental impact; (2) **Multidisciplinary**: burn surgeon + plastic + physiatry + PT/OT (CHT) + child life + psychology + family; (3) **Anti-deformity positioning (KEY)** from acute: neck extension — no pillow under head, rolled towel under shoulders; sustained — splints + neck conformers (silicone neck collar, soft neck conformer day, more rigid splint night); (4) **Cervical contracture management**: - Sustained stretching + splinting; - Serial casting/dynamic; - Pressure garment + silicone (neck conformer); - Laser (PDL hypertrophy + fractional CO2 contracture); - Steroid injection + intralesional 5-FU; (5) **Surgical scar release**: - Z-plasty + W-plasty for linear contracture; - Local + regional flap; - Skin grafting; - Tissue expansion; - Free flap for severe; - Timing — mature scar (~12+ mo) usually, earlier for severe functional; (6) **Recurrence prevention**: long-term splinting + pressure + monitoring through growth — recurrence risk in pediatric high w/ growth; (7) **Functional + activity**: integration; (8) **Psychosocial + school**: peer support, school reintegration, body image, mental health; (9) **Family education + adherence + advocacy**; (10) **Camp + peer programs** improve outcomes psychosocial; (11) **Long-term follow-up** through growth + adulthood; **Modern**: laser + tissue expansion + integrated multidisciplinary + child life

---

Pediatric neck burn contracture: anti-deformity positioning (extension) + splinting + scar mgmt + surgical release (Z-plasty, flap, expansion). Pediatric risk recurrence w/ growth. Multidisciplinary + child life. Long-term FU.', NULL,
  'hard', 'trauma', 'review',
  'rehab_medicine', 'clinical_decision', 'trauma', 'peds',
  'ABA Pediatric; ISBI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'เด็กอายุ 7 ปี post-burn — รุนแรง full-thickness anterior neck — 1 yr post — cervical flexion contracture'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย post-burn 6 mo — PTSD + depression + body image + difficulty returning work', '[{"label":"A","text":"No psych intervention"},{"label":"B","text":"Burn Psychosocial + Vocational"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Burn Psychosocial + Vocational: (1) **Psychological sequelae prevalent** post-burn: PTSD (~20-40%), depression (~25%), anxiety, body image, sleep disturbances, substance use; predicts QOL > burn severity; (2) **Screening + assessment**: PCL-5, PHQ-9, GAD-7, body image scales, sleep, substance use, QOL (BSHS-B — Burn Specific Health Scale-Brief); (3) **Multimodal treatment**: - **Trauma-focused CBT**: gold standard PTSD; - **Prolonged exposure + EMDR**; - **SSRI/SNRI** for PTSD + depression + anxiety; - **Sleep**: CBT-I + meds selected; - **Body image therapy + scar camouflage** (makeup, clothing, tattoo to scar — adjuncts); - **Peer support + burn survivor groups**; - **Family therapy**; (4) **Substance use** integrated treatment; (5) **Vocational rehabilitation**: - Comprehensive assessment (function + cognitive + psych + job demands); - Worksite assessment + accommodations (ADA): scheduling, heat tolerance, sun protection, scar care breaks; - Graded RTW; - Job coach selected; - Vocational re-training if cannot return; (6) **Driving evaluation** if needed; (7) **Community + recreation reintegration**: burn camps, adaptive recreation, peer support; (8) **Family + caregiver + spouse considerations**: relationship + sexual concerns; (9) **Pediatric considerations**: school reintegration, peer/bullying, family; (10) **Multidisciplinary**: psychiatry + psychology + physiatry + voc rehab + peer + family + social work; **Modern**: integrated trauma-informed + survivor-centered + burn psychology

---

Burn psychosocial: PTSD/depression/anxiety/body image high. Screen. Trauma-focused CBT + EMDR + SSRI. Body image + peer support + camouflage. Vocational: assessment + accommodations + graded RTW + job coach. Family. Multidisciplinary.', NULL,
  'medium', 'psych_behavior', 'review',
  'rehab_medicine', 'clinical_decision', 'psych_behavior', 'adult',
  'ABA; Phoenix Society', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย post-burn 6 mo — PTSD + depression + body image + difficulty returning work'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย post-burn — chronic neuropathic pain + itching (pruritus) — refractory', '[{"label":"A","text":"Opioid only escalating"},{"label":"B","text":"Burn Pruritus + Neuropathic Pain — Multimodal"},{"label":"C","text":"No intervention — wait"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Burn Pruritus + Neuropathic Pain — Multimodal: (1) **Pruritus prevalence** very high post-burn (~70-90% during healing, ~50% long-term); QOL impact + sleep + mood; (2) **Pathophysiology**: peripheral (nerve regeneration, mast cells, histamine, IL) + central sensitization; (3) **Pruritus management**: - **Topical**: emollients (frequent), pramoxine (local anesthetic), doxepin cream, capsaicin selected; - **Systemic**: antihistamines (H1: cetirizine, hydroxyzine; H2: ranitidine adjunct), gabapentin/pregabalin (evidence in burn), TCA (doxepin), naltrexone (opioid-induced), SSRI/SNRI; - **Non-pharm**: cool environment, loose breathable clothing, cool compresses, distraction, massage, TENS, pressure garments + silicone (also help scar); (4) **Neuropathic pain post-burn** (small fiber neuropathy, neuroma): - **Gabapentin/pregabalin, TCA, SNRI** first-line; - **Topical lidocaine + capsaicin** patches; - **Opioid-sparing**; - **Interventional**: nerve blocks, sympathetic blocks selected; (5) **Scar management** integrated reduces both; pressure + silicone + laser (PDL hypertrophic, fractional CO2 contracture + pruritus); (6) **Sleep + mood addressing**: contribute to both — CBT, sleep hygiene; (7) **Multimodal — interdisciplinary**: combine; (8) **Multidisciplinary**: burn rehab + pain + dermatology + psychology + PT/OT; (9) **Patient education + self-management**; (10) **Outcomes**: itch scale, pain, sleep, function, QOL; **Modern**: laser + neuromodulation + multimodal

---

Burn pruritus + NP pain: prevalence high. Topical (emollients, doxepin, lido, capsaicin) + systemic (gabapentinoid, TCA, antihistamine). Scar mgmt (pressure + silicone + laser) integrated. Sleep + mood. Multidisciplinary multimodal.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'ABA; Burn Pruritus', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย post-burn — chronic neuropathic pain + itching (pruritus) — refractory'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย stroke — L foot drop + mild knee hyperextension during stance — AFO selection', '[{"label":"A","text":"No AFO needed"},{"label":"B","text":"AFO Selection — Functional Considerations"},{"label":"C","text":"Cast"},{"label":"D","text":"Surgery only"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** AFO Selection — Functional Considerations: (1) **AFO types + indications**: - **Posterior leaf spring (PLS, flexible polypropylene)**: mild foot drop, normal proximal control, swing-phase assist; - **Solid ankle AFO (rigid plastic)**: more severe spasticity/weakness, instability; controls coronal + sagittal; can cause increased knee flexion; - **Articulated AFO** (hinged): allows DF (selected), block PF (assist swing); - **Ground reaction force (GRF) AFO** (anterior shell): for crouch gait or knee hyperextension/buckling — knee extension moment via anterior tibial bar — useful for this patient (knee hyperextension); - **Energy-storing dynamic** (carbon fiber — ToeOFF, BlueRocker): active patients, push-off assist, less restrictive; - **AFO w/ free DF + PF stop**: foot drop + plantar fascia issue; (2) **Selection factors**: weakness pattern, spasticity, deformity, function, gait analysis, patient preference, cosmesis, activity level, weight; (3) **Custom (prosthetist/orthotist) vs off-shelf**; (4) **Gait analysis + fitting**: alignment, length, padding, donning/doffing; (5) **PT integration**: gait training w/ AFO; address impairments not solved by orthosis alone; (6) **Monitoring + adjustment**: pressure areas, skin, function, weight changes; replace 1-3 yr typically; (7) **FES alternative** for foot drop (Walkaide, Bioness L300, Odstock Dropped Foot Stimulator) — selected; (8) **Multidisciplinary**: orthotist + physiatry + PT + patient; **Modern**: 3D-scanned custom + carbon fiber + FES options

---

AFO: PLS (mild), solid (severe), articulated, GRF (knee hyperext/crouch — this case), energy-storing carbon fiber. Selection by impairment + function. Custom vs off-shelf. PT integration. FES alternative. Modern: 3D scan + carbon fiber.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'AAOP; ISPO', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย stroke — L foot drop + mild knee hyperextension during stance — AFO selection'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย C6 SCI — power wheelchair prescription + assessment', '[{"label":"A","text":"Manual w/c only"},{"label":"B","text":"Power Wheelchair Prescription — C6 Tetraplegic"},{"label":"C","text":"Generic w/c — no assessment"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Power Wheelchair Prescription — C6 Tetraplegic: (1) **Comprehensive seating + mobility assessment** (KEY): physiatrist + OT (or PT) + supplier; needs (mobility, transfers, pressure relief, function, environment, transport); (2) **Patient assessment**: function (motor — C6 partial wrist ext + tenodesis; transfers; pressure relief ability), cognition, vision, posture, deformity (scoliosis, contracture), skin, growth (peds); (3) **W/C category Medicare USA** (other systems similar): Group 1-5 — power Group 3+ for complex needs; (4) **Frame + drive wheels**: - **Mid-wheel drive** (e.g., Permobil M3): tight turning, smooth; - **Front-wheel** for outdoor; - **Rear-wheel** for higher speed; - **All-wheel** specialized; (5) **Controls (key for C6)**: - **Standard joystick**: hand if function permits — tenodesis-compatible mounting; - **Alternative**: chin, head, sip-puff, eye-gaze for higher-level SCI (C4-5); proportional or switch-based; - **Mounting + interface customization**; (6) **Seating system**: - Custom contoured seat + back; - Pressure-mapping; pressure-redistributing cushion (ROHO, gel, foam, hybrid); - Lateral supports + headrest as needed; - Tilt-in-space (KEY for pressure relief in C6 cannot independently); - Recline + leg elevation; - Standing function — selected; (7) **Power features**: tilt + recline + elevating legs (KEY) + seat elevation + standing; ventilator-compatible; (8) **Environment + transport**: home accessibility, vehicle (van w/ lift), wheelchair-accessible vehicle; (9) **Training**: OT/PT + caregiver; (10) **Long-term**: maintenance + replacement (5 yr typical) + growth/changes; **Modern**: technology-enabled + alternative controls + integrated assessment

---

Power w/c C6: comprehensive assessment. Joystick or alternative control. Mid-wheel drive. Custom seating + pressure-redistributing cushion. Power tilt + recline + leg elev (key pressure relief). Vehicle. OT/PT training. Modern integrated.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'RESNA; Consortium SCI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย C6 SCI — power wheelchair prescription + assessment'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 80 ปี chronic LBP + degenerative disc + needs lumbosacral orthosis (LSO) — selection', '[{"label":"A","text":"Long-term rigid brace alone"},{"label":"B","text":"Spinal Orthotics — LSO Selection"},{"label":"C","text":"No brace + bedrest"},{"label":"D","text":"Surgery"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Spinal Orthotics — LSO Selection: (1) **Spinal orthotic categories**: - **Cervical**: soft collar (limited evidence except acute), rigid (Philadelphia, Aspen), halo (most rigid — TBI/SCI surgical); - **Cervicothoracic** (Minerva, SOMI); - **Thoracolumbar** (Jewett, CASH, TLSO); - **Lumbosacral** (LSO — chairback, Knight, semirigid lumbosacral corset, custom-molded); - **Sacroiliac**; (2) **LSO purposes**: motion restriction (post-op, fracture), pain reduction (load reduction, proprioception, warmth, support), postural awareness, prevention progression; (3) **LSO options**: - **Soft corset** (limited rigid support — postural cuing, warmth, comfort); - **Semirigid w/ stays** (moderate); - **Rigid (chairback, Knight, TLSO)**: maximum motion restriction, post-fracture/surgery; (4) **Evidence chronic LBP**: limited rigorous — modest benefit in selected acute; chronic adjunct; AVOID prolonged use (deconditioning of paraspinals); (5) **For this patient**: semirigid LSO short-term + active rehab + addressing contributors; (6) **Compression fractures (osteoporotic)**: TLSO (Jewett, CASH) selected acute — modest evidence; vertebroplasty/kyphoplasty selected; bone health Tx; (7) **Adherence + skin care + breathing + fit assessment**; (8) **Active rehab integration KEY**: orthosis NOT alternative to exercise — combined; (9) **Multidisciplinary**: physiatry + orthotist + PT + ortho/neuro surgery selected; (10) **Pediatric scoliosis**: brace (Boston) — angle-dependent + skeletal maturity-based; (11) **Outcomes**: pain, function (ODI), adherence; **Modern**: brace + active rehab + selected indications + biomechanical optimization

---

LSO selection: soft (postural) → semirigid → rigid by indication. Chronic LBP: limited evidence — semirigid short-term + ACTIVE rehab. Compression fx: TLSO. Avoid prolonged (deconditioning). Multidisciplinary. Active rehab key.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'rehab_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAOP; ISPO', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 80 ปี chronic LBP + degenerative disc + needs lumbosacral orthosis (LSO) — selection'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี chronic LBP + neuro deficit — using mobile phone + computer extensively — assistive technology + ergonomics', '[{"label":"A","text":"No AT"},{"label":"B","text":"Assistive Technology + Ergonomics"},{"label":"C","text":"Generic devices"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Surgery only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Assistive Technology + Ergonomics: (1) **Assessment**: comprehensive — function (motor, cognitive, sensory), tasks (work + home + recreation), environment, equipment; (2) **AT categories**: - **Low-tech**: built-up handles, reachers, dressing aids, jar openers, raised toilet seats, shower bench; - **Mid-tech**: powered tools, devices w/ switches; - **High-tech**: computers (alternative keyboards, mice, switch access, eye-gaze, voice recognition), AAC devices, environmental control (smart home — voice-activated lights, thermostat, locks), smart phones (apps for organization, memory, communication, navigation), powered W/C, exoskeletons, BCI (emerging), robotics; (3) **Ergonomic assessment workplace**: - Chair (lumbar support, adjustable); - Desk + monitor height (eye level top of screen, 50-70 cm); - Keyboard + mouse (neutral wrist; ergonomic options); - Lighting + glare; - Posture + microbreaks (Pomodoro, every 20-30 min); - Voice-input + dictation alternatives; - Wrist rests selected (not constant pressure); (4) **OT-led** AT assessment + recommendation + training; (5) **Funding**: Medicare/Medicaid/insurance (US), vocational rehab, voluntary; **Modern**: rapid evolution — smart devices + AI + IoT + accessibility-built-in (iOS Accessibility, Android, Microsoft Adaptive); inclusive design; voice assistants; (6) **Outcomes**: function, satisfaction (QUEST), participation; (7) **Multidisciplinary**: OT + PT + physiatry + speech (AAC) + voc rehab + IT + employer; (8) **Training + adherence + community**: support; **Modern**: smart + universal design + integrated AT

---

AT + ergonomics: comprehensive assessment. Low/mid/high-tech spectrum. Ergonomic workplace (chair + monitor + keyboard + posture + breaks). OT-led. Smart devices + voice-input + accessibility built-in. Multidisciplinary. Modern: AI + IoT.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'rehab_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'RESNA; ISO 9241', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี chronic LBP + neuro deficit — using mobile phone + computer extensively — assistive technology + ergonomics'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย post-amputation BKA — driving evaluation + adaptive vehicle considerations', '[{"label":"A","text":"Drive without evaluation"},{"label":"B","text":"Driving Rehabilitation — Adapted Vehicle"},{"label":"C","text":"Never drive"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Bedrest"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Driving Rehabilitation — Adapted Vehicle: (1) **Comprehensive Driving Evaluation (CDE)** by Certified Driver Rehabilitation Specialist (CDRS) — OT or other; (2) **Clinical assessment**: vision (acuity, peripheral, contrast, glare, scanning), cognition (attention, processing speed, executive, memory, judgment), motor (strength, ROM, coordination, reaction time), sensation, medications (sedating); (3) **On-road evaluation**: simulator selected → road test by CDRS in adapted vehicle if needed; (4) **Adaptations BKA (right BKA — uses right pedals)**: - **Left-foot accelerator** + cover for right pedal — useful for right LE amputee; - **Hand controls** (mechanical or electronic — push-pull, push-twist, push-right-angle, etc.) — useful for SCI, paraplegic, severe LE impairment; - **Power steering + braking**; - **Spinner knob** for steering 1-handed; - **Pedal extensions** for short stature; - **Vehicle entry**: ramps, lifts, transfer seats, lowered vehicle floor for power w/c; - **Wheelchair-accessible vehicle (WAV)**: van w/ ramp/lift; (5) **Training + licensing**: graded training; some jurisdictions require re-test w/ adaptation noted on license; (6) **Considerations**: prosthesis fit + reaction time + endurance + complex environments + cognition + medications + seizure-free interval; (7) **Cost + funding** challenges — voc rehab, charities, insurance; (8) **Alternatives**: paratransit, ride-share, taxi, family; (9) **Community + independence** impact significant — driving is autonomy; (10) **Re-evaluation periodic** + after status changes; (11) **Multidisciplinary**: CDRS + physiatry + OT + ophthalmology + neuropsychology + family; **Modern**: tech-enabled adaptations + AV future + accessibility-built-in

---

Driving rehab: CDRS comprehensive eval (clinical + on-road). Adaptations: hand controls, left-foot accelerator, spinner knob, WAV. BKA selected (left-foot for right BKA). Training + licensing. Cost. Multidisciplinary. Modern: tech.', NULL,
  'medium', 'trauma', 'review',
  'rehab_medicine', 'clinical_decision', 'trauma', 'adult',
  'ADED; AOTA Driving', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย post-amputation BKA — driving evaluation + adaptive vehicle considerations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี post-LBP 6 mo — failed conservative — ต้องการ return to manual labor job', '[{"label":"A","text":"Permanent disability without trial"},{"label":"B","text":"Vocational Rehabilitation — Return-to-Work (RTW)"},{"label":"C","text":"Surgery first-line"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Vocational Rehabilitation — Return-to-Work (RTW): (1) **Comprehensive vocational assessment**: medical (impairment + function), job demands analysis (PDC, ergonomic, dictionary of occupational titles), psychological (depression, fear-avoidance, motivation), social (family, finances), employer relations; (2) **Function vs job demand match**: - **Functional Capacity Evaluation (FCE)**: standardized tests of work-related abilities (lifting, carrying, posture, endurance) — match to job requirements; - **Job site assessment** + ergonomic analysis; (3) **Interventions**: - **Work conditioning + work hardening**: progressive structured exercise programs simulating work demands — evidence in selected; - **Functional restoration program (FRP)**: interdisciplinary chronic pain + RTW focus (Mayer, Gatchel) — strong evidence chronic LBP RTW; - **Ergonomic modifications**: lifting techniques, mechanical aids, job redesign; - **Graded return**: hours, duties; - **Light duty**: temporary modified; - **Vocational re-training**: if cannot return — alternate career; (4) **Address contributors**: pain (multimodal), psychological (CBT for fear-avoidance, depression), substance use, social, sleep; (5) **Multidisciplinary team**: physiatry + PT + OT + psychology + voc rehab counselor + employer + insurance + family; (6) **Workers'' compensation system navigation** (if applicable): IME, return-to-work coordinator, case management; (7) **Outcomes**: RTW status (return, retain), function (ODI), pain, sustainability, cost; (8) **Education**: pain neuroscience, biopsychosocial, self-management; (9) **Evidence**: FRP + multidisciplinary > single-modal; (10) **Modern**: biopsychosocial + early intervention + employer integration + flexible work

---

RTW: comprehensive — function + job demands + psych. FCE + worksite. Work hardening/FRP + ergonomic + graded + re-training. Address pain + fear-avoidance + mood. Multidisciplinary + employer. Evidence FRP > single. Modern biopsychosocial.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'rehab_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAPM&R; APTA Voc', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี post-LBP 6 mo — failed conservative — ต้องการ return to manual labor job'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย TBI 9 mo — cognitive deficits — knowledge worker job — workplace accommodations', '[{"label":"A","text":"No accommodations — same as before"},{"label":"B","text":"Cognitive Disability Workplace Accommodations (ADA)"},{"label":"C","text":"No return ever"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cognitive Disability Workplace Accommodations (ADA): (1) **ADA (USA)** / equivalent: protects qualified persons w/ disability — reasonable accommodations to perform essential job functions; not job creation; interactive process w/ employer; (2) **Disclosure** is patient''s choice — pros/cons; required if requesting accommodation; (3) **Reasonable accommodations cognitive**: - **Environment**: quiet workspace, fewer distractions, private office vs cubicle, lighting adjustments; - **Schedule**: flexible hours, part-time return, extended breaks, regular short breaks (Pomodoro); - **Task modifications**: written instructions, checklists, simplified workflows, one-task focus, deadlines flexibility; - **Assistive technology**: text-to-speech, speech-to-text, organization apps, reminders, smartphones, planning software; - **Memory aids**: notebooks, calendars, recording devices; - **Job coach**: on-site support — supported employment model; - **Modified duties**: reduced multitasking, lower-stress tasks; - **Telework**: home environment + flexible; (4) **Employer education** about TBI + cognitive disability + strategies; (5) **Vocational rehab counselor**: coordinate w/ employer + advocacy; (6) **Job match assessment**: cognitive demands vs abilities; consider re-training if cannot return; (7) **Multidisciplinary**: neuropsych + physiatry + voc rehab + OT + employer + family; (8) **Address contributors**: fatigue, mood, sleep, pain — improve work capacity; (9) **Graduated RTW**: part-time → full; (10) **Monitor + adjust**: regular check-ins, evolving needs; (11) **Outcomes**: RTW status, retention, performance, satisfaction; **Modern**: ADA + supported employment + tech accommodations + flexible work

---

Cognitive accommodations: ADA framework. Environment + schedule + task mods + AT (apps, T2S, organization) + job coach + telework + modified duties. Employer education. Voc rehab. Graduated. Multidisciplinary. Modern: supported employment.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'ADA; Job Accommodation Network', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย TBI 9 mo — cognitive deficits — knowledge worker job — workplace accommodations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย amputee post-AKA — desires return to physical labor or new career — voc rehab', '[{"label":"A","text":"No return ever"},{"label":"B","text":"Amputee Vocational Rehabilitation"},{"label":"C","text":"Same heavy labor without changes"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Amputee Vocational Rehabilitation: (1) **Comprehensive eval**: function (prosthetic, ambulation, endurance), residual limb, prior occupation analysis, education, transferable skills, interests, motivation; (2) **Job demands analysis** + functional capacity eval + workplace accessibility; (3) **RTW options stratification**: - **Same job same employer**: if function permits + accommodations; - **Same job different employer/site**: better accessibility; - **Modified duties same employer**: reduced physical demands; - **Vocational re-training**: education for new career suited to abilities (sedentary, less physical) — common for AKA + heavy labor; - **Self-employment + entrepreneurship**: emerging options; - **Retirement/disability**: when re-employment not feasible; (4) **Prosthetic optimization for occupation**: activity-specific prosthetics (work boot adapters, sport-specific, heavy-duty components, K-level appropriate); (5) **Workplace accessibility + accommodations (ADA)**: parking, restroom, workspace, equipment; (6) **Training + education**: high school equivalency, community college, technical, on-the-job training, certifications; (7) **Vocational rehab counselor**: case mgmt + advocacy + funding navigation (state voc rehab agencies, VA for veterans); (8) **Address psychosocial**: identity, body image, motivation, depression, family; counseling + peer support; (9) **Driving evaluation** + adaptive vehicle if needed; (10) **Multidisciplinary team**: physiatry + prosthetist + PT + OT + voc rehab + psychology + family + employer; (11) **Outcomes**: RTW status, retention, income, satisfaction; **Modern**: integrated voc + advanced prosthetics + technology-enabled work

---

Amputee voc rehab: comprehensive eval. RTW options spectrum — same → modified → re-train → self-employment. Activity-specific prosthetics. Accommodations + training. Psychosocial. Funding (VR agencies, VA). Multidisciplinary.', NULL,
  'medium', 'trauma', 'review',
  'rehab_medicine', 'clinical_decision', 'trauma', 'adult',
  'RSA; VA Voc Rehab', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย amputee post-AKA — desires return to physical labor or new career — voc rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี SCI paraplegic 2 yr — wants to return to professional work — supported employment', '[{"label":"A","text":"Disability pension only"},{"label":"B","text":"Supported Employment + SCI Return-to-Work"},{"label":"C","text":"No accommodations"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Bedrest"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Supported Employment + SCI Return-to-Work: (1) **SCI RTW low** (~30-40%) — significant gap; predictors: pre-injury employment, education, age, function, support, motivation; (2) **Supported employment model**: - **Individual placement + support (IPS)**: rapid placement (skip lengthy training), individualized, integrated work + clinical, time-unlimited support, consumer preferences; - **Evidence strongest** in psychiatric but applied to SCI/TBI; - Job coach + ongoing support; (3) **Pre-RTW preparation**: - Function optimization (mobility, ADLs, prosthetics/orthotics, equipment); - Psychological readiness + motivation; - Vocational counseling + interests + skills assessment; - Education/training as needed; - Mock interviews + skill-building; (4) **Workplace assessment**: - Accessibility (ramps, doors, restrooms, parking — ADA-compliant); - Equipment + ergonomic (height-adjustable desks, transfer surfaces); - Schedule + commute + transportation; - Restrooms + intermittent catheterization considerations; - Pressure relief breaks; (5) **Accommodations (ADA)**: home/remote work, flexible schedule, accessible workspace, assistive tech, voice recognition, ergonomic; (6) **Transportation**: adapted vehicle (hand controls), accessible public transit, ride-share; (7) **Health considerations workplace**: pressure relief, hydration + bladder/bowel timing, autonomic dysreflexia, skin, fatigue, equipment; (8) **Caregiver + family support**: managing pre-/post-work; (9) **Multidisciplinary**: physiatry + PT + OT + voc rehab + psychology + employer + family; (10) **Funding**: state VR, SSA, employer, voluntary; (11) **Outcomes**: RTW, retention, income, satisfaction, integration; **Modern**: IPS + telework expansion + tech-enabled + employer education

---

SCI RTW: supported employment IPS model — rapid placement + individualized + integrated + ongoing. Workplace accessibility + accommodations + transportation + health (pressure, bladder, AD). Multidisciplinary. Modern: IPS + telework.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'IPS; RSA; PVA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี SCI paraplegic 2 yr — wants to return to professional work — supported employment'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี post-stroke — generalized spasticity affecting UE + LE — failed BoNT + oral antispasticity — refractory', '[{"label":"A","text":"Oral baclofen high dose only"},{"label":"B","text":"Refractory Spasticity — Intrathecal Baclofen (ITB) Pump"},{"label":"C","text":"No intervention"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Surgery — fusion"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Refractory Spasticity — Intrathecal Baclofen (ITB) Pump: (1) **Indications**: severe generalized spasticity interfering function (mobility, ADL, hygiene, comfort, positioning) refractory to oral + focal (BoNT) — SCI, MS, CP, stroke, TBI; (2) **Patient selection**: clear functional goals; trial benefit + tolerance + family/caregiver capability; (3) **Trial**: intrathecal bolus (50-100 mcg) — observe reduction Ashworth + function 4-8 h; pass → implant; (4) **Implantation**: subcutaneous pump (abdominal) + intrathecal catheter (T6-T12 typically); refilled q3-6 mo via percutaneous port; programmable rate + boluses; battery 5-7 yr; (5) **Titration**: starting + gradual increase; dosing varies (cerebral spasticity lower dose than spinal); (6) **Benefits**: reduces spasticity + spasms + improves hygiene + positioning + sleep + pain + may improve function in selected; reduces oral baclofen + SE; (7) **Complications**: - **Withdrawal** (sudden cessation — fever, severe spasticity, seizure, rhabdo, organ failure, death) — pump malfunction, catheter, refill error; EMERGENCY — IV/PO baclofen, benzo, support; - **Overdose** (drowsy → respiratory failure → coma) — flumazenil ineffective; supportive + naloxone trial; pump program review; - Infection, catheter migration/leak/break, pump failure, CSF leak; (8) **Multidisciplinary**: physiatry + neurosurgery + PT + OT + nursing + family; (9) **24/7 emergency contact + ID card + family education**; (10) **Alternative refractory**: SDR (selective dorsal rhizotomy — selected children + adults), orthopaedic; (11) **Outcomes**: Ashworth, Tardieu, function, goal attainment, QOL; **Modern**: ITB programmable + integrated + emerging neuromodulation

---

ITB pump: refractory spasticity. Trial → implant. Subcutaneous pump + intrathecal catheter, refill q3-6 mo. Withdrawal EMERGENCY (PO baclofen + benzo). Overdose. Multidisciplinary + 24/7. SDR alternative. Outcomes Ashworth/function.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'AAN ITB; AAPM&R', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี post-stroke — generalized spasticity affecting UE + LE — failed BoNT + oral antispasticity — refractory'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยเด็ก CP spastic diplegia GMFCS II — ambulating w/ AFOs — increasing spasticity affecting gait', '[{"label":"A","text":"Oral diazepam only"},{"label":"B","text":"Pediatric CP Spasticity — BoNT + Surgical Options"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric CP Spasticity — BoNT + Surgical Options: (1) **Goal-setting** (KEY): GAS, gait improvement, ADLs; not eliminating spasticity (some functional); (2) **BoNT-A** focal management: - Target muscles by gait analysis + pattern (e.g., spastic diplegia — gastroc-soleus, hamstrings, hip adductors); - Dosing weight-based (max ~12-20 U/kg total OnabotulinumtoxinA, varies by product); - US + EMG guidance; - Effect peak 2-4 wk, duration 3-4 mo, re-inject q3-6 mo; - Combine w/ post-BoNT serial casting + intensive PT for max effect; (3) **Orthopaedic**: - **Multilevel single-event surgery (SEMLS)**: address multiple deformities in one session — hamstring lengthening, psoas lengthening, gastroc-soleus lengthening, derotational osteotomies, foot — preferred over multiple separate; - 3D gait analysis-guided; (4) **Selective Dorsal Rhizotomy (SDR)**: - Selected ambulatory CP (typically GMFCS II-III, age 4-10, good cognition, good motor potential); - Reduces spasticity permanently, improves gait; - Requires intensive post-op PT 6-12 mo; - This patient potential candidate; (5) **Intrathecal Baclofen**: severe generalized spasticity; less common GMFCS I-II; (6) **Hip surveillance**: regular radiograph; address subluxation early; (7) **Multidisciplinary**: physiatry + ortho + neurosurgery + PT + OT + orthotist + family; (8) **Long-term**: continued surveillance through growth + into adulthood; transition; (9) **Outcomes**: GMFM-66, gait analysis, GAS, FMS, QOL (CPCHILD, KIDSCREEN); **Modern**: gait-analysis-guided + multimodal + early intervention

---

Pediatric CP spasticity: goal-directed. BoNT-A + serial casting + intensive PT focal. SEMLS for multiple deformities (gait-analysis-guided). SDR for selected ambulators. ITB severe. Hip surveillance. Multidisciplinary. Modern integrated.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'peds',
  'AACPDM; Cerebral Palsy Spasticity', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยเด็ก CP spastic diplegia GMFCS II — ambulating w/ AFOs — increasing spasticity affecting gait'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี MS — bilateral LE spastic gait + spasms + sleep disruption from cramps', '[{"label":"A","text":"Single high-dose oral medication"},{"label":"B","text":"MS Spasticity Comprehensive Management"},{"label":"C","text":"No intervention"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Surgery — fusion"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** MS Spasticity Comprehensive Management: (1) **Multidisciplinary**: neurology MS + physiatry + PT + OT + nursing + urology + sleep; (2) **Address contributors (KEY)** — exacerbate spasticity: - UTI, urinary retention/bladder distension; - Constipation; - Pressure injury/skin; - Pain; - Tight clothing/positioning; - Infection; - Fatigue/sleep deprivation; - Mood; - Treat root cause first; (3) **Non-pharm**: PT (stretching + strengthening + functional + balance), positioning + sleep position, orthotics (AFO), thermal modalities, exercise — pool effective (cool), cryotherapy; (4) **Pharmacologic — stepwise**: - **First-line oral**: baclofen (start 5 mg TID, titrate to 80 mg/d max — sedation, weakness; do NOT abruptly stop — withdrawal seizures), tizanidine (BID-QID, monitor LFT + hypotension), benzodiazepine (clonazepam, diazepam — sedation, dependence); - **Add-on**: gabapentin/pregabalin (also for pain), dantrolene (hepatotoxicity), cyproheptadine (sleep + spasm), cannabinoid (nabiximols/Sativex if available); - **Topical**: lidocaine, capsaicin for focal; (5) **Focal — BoNT-A**: gait pattern (gastroc, hamstring, adductors); functional goals; (6) **Refractory — ITB pump**: severe generalized + functional impact; (7) **Spasms at night**: hydration, position, baclofen evening, magnesium selected, anti-spasmodic timing; (8) **Sleep + mood addressed**: improve overall; (9) **Education + self-management + family**; (10) **Outcomes**: Ashworth, spasm frequency, function, sleep, PROs (MSSS-88); **Modern**: multimodal + cannabinoid evidence + nuanced

---

MS spasticity: multidisciplinary. Address contributors FIRST (UTI, constipation, pain). Non-pharm + orthotics + cooling. Stepwise pharma — baclofen + tizanidine + adjuncts. BoNT focal. ITB refractory. Sleep + mood. Education.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'MS Society; CMSC', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี MS — bilateral LE spastic gait + spasms + sleep disruption from cramps'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี TBI 1 yr — severe upper limb spasticity (MAS 4) — fixed contracture concern', '[{"label":"A","text":"No intervention — accept contracture"},{"label":"B","text":"Severe UE Spasticity + Contracture Prevention"},{"label":"C","text":"Restraint"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Amputation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe UE Spasticity + Contracture Prevention: (1) **Assessment**: pattern (e.g., flexor — pectoralis, biceps, FCR/U, FDS/FDP, intrinsics), Modified Ashworth Scale (MAS), Tardieu (R1 — fast catch angle vs R2 — slow ROM), functional impact, hygiene/skin, pain; (2) **Distinguish spasticity vs contracture**: - **Spasticity**: velocity-dependent (Tardieu); reversible w/ relaxation/anesthesia; - **Contracture**: fixed, no velocity, soft-tissue shortening; - **Combined often**; (3) **Comprehensive multimodal Tx**: - **PT/OT**: stretching + ROM (passive + active), splinting (custom resting hand splint at night + functional), positioning, sensory motor reeducation, task-specific; - **Splinting**: serial casting for established contracture; dynamic for ROM; - **Focal — BoNT-A**: targeted by pattern (e.g., flexor — biceps, BR, FCR/U, FDS, FDP, lumbricals, FPL, adductor pollicis); dosing weight-based + clinical; combined w/ post-injection serial casting/dynamic splinting + intensive PT (1-2 wk post peak effect window); - **Oral antispasticity** as adjunct; - **ITB** if generalized; (4) **Phenol/alcohol motor point or nerve block**: alternative/adjunct for selected — longer duration but technical + dysesthesia risk; obturator nerve, musculocutaneous, tibial; (5) **Surgical**: - Tendon lengthening, transfer, release; - Selective neurectomy (selected); - For established contracture + functional/hygiene goals; (6) **Goal-setting**: GAS, functional, hygiene, pain, cosmetic; (7) **Address contributors**: pain, sleep, fatigue, environment; (8) **Multidisciplinary**: physiatry + PT + OT + ortho + neurology + family + caregiver education for home; (9) **Outcomes**: Ashworth/Tardieu, ROM, function, hygiene, pain, GAS; **Modern**: US-guided + integrated multimodal + goal-directed

---

Severe UE spasticity: pattern + MAS/Tardieu. Distinguish from contracture. Multimodal: PT/OT + splinting/casting + BoNT-A targeted + serial casting + oral antispastic + ITB selected. Phenol/alcohol option. Surgery established. Goal-directed.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'AAPM&R Spasticity; AANEM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี TBI 1 yr — severe upper limb spasticity (MAS 4) — fixed contracture concern'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย post-stroke focal lower-limb spasticity — equinus pattern — BoNT-A injection planning', '[{"label":"A","text":"Inject without imaging guidance"},{"label":"B","text":"Lower Limb BoNT-A — Equinus Pattern"},{"label":"C","text":"Maximum dose every muscle"},{"label":"D","text":"No adjunctive therapy"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Lower Limb BoNT-A — Equinus Pattern: (1) **Target identification**: - **Equinus (PF spasticity)**: gastrocnemius (medial + lateral heads), soleus; - **Equinovarus**: + tibialis posterior, tibialis anterior (sometimes spastic), flexor digitorum/hallucis longus; - **Striatal toe**: extensor hallucis longus; - **Stiff knee gait**: rectus femoris (selectively — confirm w/ gait analysis); - **Adducted thigh/scissoring**: hip adductors; (2) **Dosing** OnabotulinumtoxinA: gastrocnemius medial + lateral 100-200 U each, soleus 150-300 U, tibialis posterior 75-200 U, hip adductors 75-300 U; total max ~600 U single session (dilution-titrated); (3) **Localization (KEY accuracy)**: - **Ultrasound guidance** (preferred — anatomy + needle visualization); - **EMG guidance** (motor activity confirmation); - **Electrical stimulation** (motor response); - Surface anatomy alone — less accurate; (4) **Onset 3-7 d, peak 2-4 wk, duration 3-4 mo**; (5) **Adjunctive (KEY)**: - **Stretching + ROM** post-injection; - **Serial casting** for established contracture (within 2 wk peak); - **AFO + orthotics**; - **Intensive PT/OT** task-specific gait training; - **Strength + functional**; (6) **Goal-directed**: function (gait speed, 10MWT), pain, hygiene, comfort; PROs (GAS); (7) **Re-injection q3-4 mo** based on goals + response; antibody formation rare; (8) **Contraindications**: pregnancy, breastfeeding, NMJ disorders (myasthenia, LEMS, ALS — caution), allergy; (9) **Multidisciplinary**: physiatry + PT + orthotist + neurology selected; (10) **Outcomes**: MAS, Tardieu, gait, GAS, function; **Modern**: US-guided + goal-directed + integrated rehab

---

BoNT-A equinus: target gastroc + soleus ± TP for equinovarus. US-guided localization (preferred). Dosing weight + clinical. Onset/peak/duration. CRITICAL adjuncts: PT + stretching + serial casting + AFO. Goal-directed. Re-injection q3-4mo.', NULL,
  'medium', 'neurology', 'review',
  'rehab_medicine', 'clinical_decision', 'neurology', 'adult',
  'AAN BoNT; PROCEED', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ผู้ป่วย post-stroke focal lower-limb spasticity — equinus pattern — BoNT-A injection planning'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Pathway involved in motor recovery post-stroke — neuroplasticity principle most important', '[{"label":"A","text":"Single repetition sufficient"},{"label":"B","text":"Motor Recovery + Neuroplasticity Principles (Kleim & Jones)"},{"label":"C","text":"Passive PROM only"},{"label":"D","text":"Bedrest enhances plasticity"},{"label":"E","text":"Plasticity ends day 1"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Motor Recovery + Neuroplasticity Principles (Kleim & Jones): (1) **Use It or Lose It**: failure to use specific brain function → degradation; (2) **Use It and Improve It**: training engaging neural circuit → enhances function; (3) **Specificity**: nature of training experience dictates nature of plasticity; (4) **Repetition Matters**: hundreds-thousands of repetitions for true plasticity (motor learning); (5) **Intensity Matters**: sufficient intensity required; (6) **Time Matters**: different forms of plasticity occur at different times during training; early stroke ~3 mo window of heightened plasticity (animal models + RCTs); chronic stroke plasticity continues but slower; (7) **Salience Matters**: meaningful task engages plasticity better; (8) **Age Matters**: training-induced plasticity occurs more readily in younger brains but throughout lifespan; (9) **Transference**: plasticity in one brain pathway can enhance acquisition of similar behaviors; (10) **Interference**: plasticity in one brain pathway can interfere w/ another; (11) **Application**: task-specific repetitive training (CIMT, intensive aphasia therapy, mass practice, LSVT BIG/LOUD); avoid learned non-use; engage meaningful tasks; (12) **Biological mechanisms**: LTP/LTD, dendritic spines, axonal sprouting, neurogenesis (limited adult), cortical map reorganization, vicarious areas, contralesional/ipsilesional balance, BDNF, GABA modulation; (13) **Adjuncts to enhance plasticity**: tDCS, rTMS, BDNF-promoting (exercise, fluoxetine — emerging neg), BCI; **Modern**: precision rehab + biomarker-guided + technology-enabled neuroplasticity

---

Kleim/Jones 10 principles neuroplasticity: use/improve, specificity, repetition, intensity, time (early window), salience, age, transference, interference. Application: task-specific + repetitive + intensive. Adjuncts emerging. Modern: precision.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'basic_science', 'neurology', 'adult',
  'Kleim & Jones 2008', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Pathway involved in motor recovery post-stroke — neuroplasticity principle most important'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หลักการ exercise physiology — VO2max determinants + training adaptation', '[{"label":"A","text":"No training adaptation possible"},{"label":"B","text":"VO2max + Training Adaptations"},{"label":"C","text":"Single bout sufficient"},{"label":"D","text":"Maximal intensity only"},{"label":"E","text":"Static only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** VO2max + Training Adaptations: (1) **VO2max** = max O2 utilization = HRmax × SVmax × (a-vO2 difference)max; (2) **Determinants**: - **Central (cardiac)**: stroke volume + HRmax (genetic, declines w/ age) → cardiac output; - **Peripheral (skeletal muscle)**: a-vO2 difference — mitochondrial density + capillary density + myoglobin + oxidative enzymes; - **Pulmonary**: rarely limiting except disease (diffusion, ventilation); - **Hemoglobin/blood** (CaO2); (3) **Training adaptations**: - **Aerobic (endurance)**: increased SV (cardiac hypertrophy — eccentric), increased mitochondrial density + oxidative enzymes, increased capillarization, increased blood volume, increased VO2max 5-25% (genetic ceiling), shift fiber Type IIx → IIa, increased fatty acid oxidation, improved lactate threshold; - **Resistance**: increased muscle hypertrophy (cross-sectional area), neural adaptation (recruitment, rate coding), increased strength, modest VO2max change; - **HIIT**: combines — improves both VO2max + lactate threshold rapidly; (4) **Principles**: overload (FITT-VP), specificity (SAID — specific adaptation to imposed demand), progressive overload, reversibility (detraining 2-4 wk), individuality (responders/non-responders genetic), recovery (super-compensation); (5) **Rehab application**: progressive aerobic + resistance + functional in cardiac, pulm, neurologic, MSK rehab; HIIT adaptation patient-specific; CPET-guided prescription; (6) **Special populations**: elderly (preserved trainability!), denervated heart (RPE-based), pulmonary disease (intervals), HF (Karvonen modified); (7) **Limits**: pathology (pulm, cardiac, hematologic); environmental (heat, altitude); medications; **Modern**: precision exercise prescription + genetic/biomarker individualization

---

VO2max: central (CO) + peripheral (a-vO2 diff). Adaptations aerobic (SV, mito, cap), resistance (hypertrophy + neural), HIIT both. Principles FITT-VP + SAID + reversibility. Rehab application across populations. Modern: precision.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'rehab_medicine', 'basic_science', 'msk_nontrauma', 'adult',
  'ACSM; Astrand', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'หลักการ exercise physiology — VO2max determinants + training adaptation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Mechanism of action of botulinum toxin + clinical implications', '[{"label":"A","text":"Postsynaptic receptor blocker"},{"label":"B","text":"Botulinum Toxin Pharmacology"},{"label":"C","text":"Permanent denervation"},{"label":"D","text":"Onset immediate (minutes)"},{"label":"E","text":"Antibodies never form"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Botulinum Toxin Pharmacology: (1) **Source**: Clostridium botulinum exotoxin; serotypes A (most clinical), B, C, D, E, F, G; (2) **Mechanism**: cleaves SNARE proteins required for vesicular fusion at neuromuscular junction → blocks acetylcholine release pre-synaptically → chemical denervation: - **OnabotulinumtoxinA (Botox), AbobotulinumtoxinA (Dysport), IncobotulinumtoxinA (Xeomin), PrabotulinumtoxinA (Jeuveau), DaxibotulinumtoxinA (Daxxify)**: cleaves SNAP-25; - **RimabotulinumtoxinB (Myobloc)**: cleaves synaptobrevin; (3) **Onset**: 3-7 d; **Peak**: 2-4 wk; **Duration**: 3-4 mo typically (varies — longer in larger muscles, immobile patients); newer formulations (Daxxify) longer; (4) **Recovery**: axonal sprouting → new NMJs + functional recovery NMJ; (5) **Diffusion**: dependent on volume + concentration + injection technique; minimize to target; (6) **Dose units NOT interchangeable** between products (different bioassays); (7) **Antibody formation** (immunoresistance): low w/ modern formulations (lower protein); risk factors — frequent dosing, high cumulative dose, booster within 4 wk (avoid!), young; preferred minimum interval ≥ 12 wk; complement-mediated; clinical loss of efficacy → consider switching serotype; (8) **Clinical indications**: spasticity (cerebral palsy, post-stroke, SCI, MS), focal dystonia (cervical, blepharospasm, hemifacial, oromandibular, focal limb), HF (sialorrhea), hyperhidrosis (axillary, palmar, gustatory), chronic migraine, urinary (detrusor overactivity, DSD), achalasia, anal fissure, cosmetic; (9) **Side effects**: local — pain, bruising, infection, weakness adjacent (diffusion); systemic — rare (autonomic, generalized weakness — boxed warning higher dose); (10) **Contraindications**: NMJ disorders (myasthenia, LEMS, ALS — caution), pregnancy, breastfeeding, allergy; (11) **Localization**: US, EMG, e-stim, anatomy — accuracy critical; **Modern**: targeted + US-guided + integrated multidisciplinary

---

BoNT: cleaves SNARE (SNAP-25 type A; synaptobrevin type B) blocking ACh pre-synaptic. Onset 3-7 d, peak 2-4 wk, duration 3-4 mo. Recovery via axonal sprouting. Antibodies (frequent dosing → resistance). Many clinical applications.', NULL,
  'medium', 'procedures', 'review',
  'rehab_medicine', 'basic_science', 'procedures', 'adult',
  'AAN BoNT; FDA labels', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Mechanism of action of botulinum toxin + clinical implications'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Gait cycle phases + normal kinematics — fundamental rehabilitation knowledge', '[{"label":"A","text":"Stance 30% only"},{"label":"B","text":"Normal Gait Cycle"},{"label":"C","text":"Swing eliminated"},{"label":"D","text":"No phases — continuous"},{"label":"E","text":"Same as run"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Normal Gait Cycle: (1) **Cycle definition**: heel-strike same foot → next heel-strike same foot = 1 cycle; ~60% stance + 40% swing typical comfortable speed; (2) **Stance phases (R foot)**: - **Initial contact (IC, heel strike, 0%)**: hip flexed ~30°, knee ext ~5°, ankle neutral; - **Loading response (LR, 0-10%)**: weight acceptance, double-limb support; controlled knee flexion (15°) absorbing shock; tibialis anterior eccentric controls foot drop; quadriceps eccentric controls knee flexion; - **Mid-stance (MSt, 10-30%)**: single-limb support; body advances over fixed foot; - **Terminal stance (TSt, 30-50%)**: heel-off; - **Pre-swing (PSw, 50-60%)**: toe-off; (3) **Swing phases**: - **Initial swing (ISw, 60-73%)**: limb advancement; - **Mid-swing (MSw, 73-87%)**: clearance; - **Terminal swing (TSw, 87-100%)**: limb deceleration prep for IC; (4) **Spatiotemporal**: stride length (1.4 m avg), step length, cadence (~110 steps/min), gait velocity (1.2-1.4 m/s preferred); (5) **Determinants of energy efficiency** (Saunders): pelvic rotation, pelvic tilt, knee flexion stance, foot mechanism, knee mechanism, lateral pelvic displacement — minimize COM displacement; (6) **Clinical gait deviations**: - Hemiplegic: circumduction, vaulting, equinovarus, knee hyperextension, anterior pelvic tilt; - Trendelenburg: glute med weakness → drop of contralateral pelvis swing; - Antalgic: shortened stance affected; - Steppage: foot drop; - Crouch: increased knee flex stance (CP, post-polio); - Scissoring: hip adductor spasticity; - Parkinsonian: shuffling, festinating, reduced arm swing, freezing; - Ataxic: wide base, unsteady; (7) **Analysis tools**: observational, video, instrumented 3D gait lab (cameras + force plates + EMG), wearables; (8) **Energy expenditure**: ~0.8 cal/m walking; gait dysfunction → increased — quantify; (9) **Outcomes**: 10MWT, 6MWT, gait analysis variables; **Modern**: 3D analysis + AI-enabled + wearable

---

Gait cycle: ~60% stance + 40% swing. Stance: IC → LR → MSt → TSt → PSw. Swing: ISw → MSw → TSw. Determinants minimize COM. Clinical deviations characteristic. Analysis tools observational → 3D + wearables.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'rehab_medicine', 'basic_science', 'msk_nontrauma', 'adult',
  'Perry; Sutherland', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Gait cycle phases + normal kinematics — fundamental rehabilitation knowledge'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Wound healing physiology — phases + factors affecting rehab', '[{"label":"A","text":"Single phase"},{"label":"B","text":"Wound Healing Physiology"},{"label":"C","text":"Heals 100% original strength"},{"label":"D","text":"Smoking accelerates"},{"label":"E","text":"No nutrition impact"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Wound Healing Physiology: (1) **Phases**: - **Hemostasis (immediate)**: platelets + clotting cascade + vasoconstriction; - **Inflammation (0-3 d)**: vasodilation, neutrophils → macrophages, cytokines; - **Proliferation (3-21 d)**: fibroblast proliferation + collagen III deposition + angiogenesis + epithelialization + granulation tissue; - **Remodeling (21 d - 1+ yr)**: collagen type III → I, cross-linking, strength gain (80% original by 1 yr — never 100%); (2) **Factors impairing healing**: - **Local**: infection, ischemia (PAD), pressure/shear, edema, foreign body, radiation, smoking (vasoconstriction), trauma; - **Systemic**: malnutrition (protein, zinc, vit C, A), DM, advanced age, immunosuppression, medications (steroids, chemo), comorbidities (CV, anemia), genetics; - **Specific deficiencies**: vit C (collagen cross-linking), zinc, protein, arginine; (3) **Optimization for healing**: - **Nutrition**: protein 1.25-1.5 g/kg, calories 30-35 kcal/kg, micronutrients, hydration; - **Glycemic control**; - **Smoking cessation**; - **Address vascular**; - **Pressure offloading**; (4) **Wound types + Tx**: clean acute (close), chronic (delayed — pressure, vascular, diabetic, venous — etiology-specific Tx + dressings); (5) **Advanced therapies**: - **NPWT** (negative pressure — VAC); - **Hyperbaric O2** (selected — DM foot, radiation, refractory chronic); - **Bioengineered skin equivalents** (Apligraf, Dermagraft); - **PRP, stem cells, growth factors** (selected); - **Surgical closure** primary/delayed; (6) **Rehab considerations**: - Mobility w/o disrupting wound; - Pressure relief + redistribution; - Splinting + positioning; - Scar management (silicone, pressure, laser, massage); - Range of motion + strengthening — progressive; - Functional return; (7) **Multidisciplinary**: WOCN + physiatry + PT + OT + nutrition + plastics + vascular + ID + endo; **Modern**: tissue engineering + biologics + integrated

---

Wound healing: hemostasis → inflammation → proliferation → remodeling (never 100%). Factors local + systemic. Optimization: nutrition + glycemic + smoking + vascular + pressure. Advanced therapies. Rehab considerations. Multidisciplinary.', NULL,
  'medium', 'trauma', 'review',
  'rehab_medicine', 'basic_science', 'trauma', 'adult',
  'Wound Healing Society', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Wound healing physiology — phases + factors affecting rehab'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Muscle physiology — fiber types + adaptations + atrophy', '[{"label":"A","text":"Single fiber type only"},{"label":"B","text":"Skeletal Muscle Physiology + Atrophy"},{"label":"C","text":"No adaptation"},{"label":"D","text":"Type II preferred endurance"},{"label":"E","text":"Bedrest preserves muscle"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Skeletal Muscle Physiology + Atrophy: (1) **Fiber types**: - **Type I (slow oxidative, red)**: high oxidative + capillary + myoglobin + mitochondria, low force, fatigue-resistant, endurance; - **Type IIa (fast oxidative-glycolytic, mixed)**: intermediate; - **Type IIx/IIb (fast glycolytic, white)**: high force + speed, fatigues quickly, anaerobic; humans mostly IIa + IIx; (2) **Recruitment**: size principle (Henneman) — small (slow) → large (fast) motor units recruited w/ increasing demand; (3) **Training adaptations**: - Resistance → hypertrophy + neural (size principle, rate coding, syncronization) + strength + IIx → IIa shift; - Endurance → oxidative enzymes + mitochondria + capillary + myoglobin + IIx → IIa + Type I maintenance; - Disuse/aging → atrophy + sarcopenia + Type II preferential loss (mostly Type IIx); (4) **Atrophy mechanisms**: - **Ubiquitin-proteasome** + autophagy systems; - **Akt-mTOR** pathway downregulation; - **Myostatin** upregulation (negative regulator muscle mass); - **FoxO** transcription factors; - **Inflammation, cortisol, denervation, malnutrition**; (5) **Critical illness myopathy (CIM)** + **polyneuropathy (CIP)**: ICU-AW; mechanism muscle protein loss + axonal dysfunction; (6) **Steroid myopathy**: type II preferential atrophy; (7) **Sarcopenia**: age-related (1-2%/yr after 50); intervention — resistance + protein + vit D + address comorbidities; (8) **Cachexia**: complex disease syndrome (cancer, CHF, COPD, CKD, AIDS); inflammation-driven; multimodal; (9) **Disuse atrophy**: ~5%/wk bedrest; (10) **Rehab application**: - Progressive resistance training to counter atrophy; - Protein 1.0-1.5+ g/kg/d; - Address inflammation/comorbidities; - Electrical stimulation (FES — preserves) selected; - Vibration, blood flow restriction (BFR) emerging; **Modern**: targeted + protein nutrition + technology-enabled

---

Muscle: Type I (slow oxidative) + IIa (mixed) + IIx (fast glycolytic). Size principle recruitment. Adaptations: resistance (hypertrophy + neural) + endurance (oxidative). Atrophy: ubiquitin + Akt-mTOR + myostatin. CIM/sarcopenia/cachexia. Rehab: resistance + protein.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'rehab_medicine', 'basic_science', 'msk_nontrauma', 'adult',
  'ACSM; Sarcopenia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Muscle physiology — fiber types + adaptations + atrophy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Functional electrical stimulation (FES) — mechanism + clinical use', '[{"label":"A","text":"Permanent denervation"},{"label":"B","text":"Functional Electrical Stimulation (FES)"},{"label":"C","text":"No clinical use"},{"label":"D","text":"Direct CNS only"},{"label":"E","text":"Pharmaceutical"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Functional Electrical Stimulation (FES): (1) **Mechanism**: electrical current applied to peripheral nerve (lower motor neuron intact) → depolarization → action potential → muscle contraction; surface electrodes or implanted; (2) **Parameters**: - Pulse width (200-300 μs sensory; 300-600 μs motor); - Frequency (20-50 Hz for fused tetanic contraction); - Amplitude (mA — sensory threshold → motor threshold → tetanic); - Duty cycle (on:off ratio — 1:3 to 1:1); - Waveform (biphasic balanced for safety); (3) **Indications**: - **Foot drop** post-stroke/MS/SCI: Walkaide, Bioness L300, Odstock — heel-strike-triggered tibialis anterior contraction during swing; alternative/adjunct to AFO; - **Hemiparetic UE**: NMES for wrist/finger extension + grasp/release; - **Shoulder subluxation** post-stroke: NMES supraspinatus + deltoid (reduces subluxation + pain); - **Cycling** (FES cycling) — SCI maintains lower limb muscle + bone + CV; - **Walking**: FES-assisted walking (Parastep, etc.) + complex hybrid orthoses; - **Hand neuroprostheses**: Freehand, NeuroControl — selected high SCI; - **Bladder/bowel** + diaphragmatic pacing — implanted; - **Strengthening** + maintaining muscle (post-disuse, denervation prevention selected); - **Cardiac**: muscle pump; (4) **Mechanism therapeutic**: muscle contraction + maintaining muscle volume + bone density (limited) + circulation + neuroplasticity (sensory + motor cortical) + reduced spasticity (reciprocal inhibition); (5) **Contraindications**: pacemaker (caution — selected types), pregnancy (lumbar/pelvic), active malignancy area, infection, broken skin, denervated muscle (LMN damaged — direct muscle stim required, less efficient); (6) **Skin care + monitoring**: electrode hygiene, skin checks; (7) **Combination w/ active therapy**: enhances learning vs passive; (8) **Multidisciplinary**: physiatry + PT + OT + biomedical engineer; **Modern**: implanted + closed-loop + wireless + BCI-integrated emerging

---

FES: electrical depolarization peripheral nerve → muscle contraction. Pulse width + freq + amplitude. Uses: foot drop, UE, shoulder subluxation, FES cycling SCI, hand neuroprostheses. Therapeutic + neuroplasticity. Active therapy combination. Modern: implanted + closed-loop.', NULL,
  'medium', 'procedures', 'review',
  'rehab_medicine', 'basic_science', 'procedures', 'adult',
  'IFESS; NMES Reviews', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Functional electrical stimulation (FES) — mechanism + clinical use'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Pharmacologic principles in neurorehabilitation — drugs affecting motor recovery', '[{"label":"A","text":"All drugs equal"},{"label":"B","text":"Pharmacology Affecting Motor Recovery"},{"label":"C","text":"No drugs affect recovery"},{"label":"D","text":"Benzodiazepines enhance plasticity"},{"label":"E","text":"Single drug cure"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pharmacology Affecting Motor Recovery: (1) **Potentially beneficial (evidence + theory)**: - **Amphetamines** (dexamphetamine): early enthusiasm + small RCTs; meta-analyses mostly negative for routine stroke; selected adjunct w/ PT; - **Fluoxetine**: FLAME suggested benefit motor stroke; FOCUS/AFFINITY/EFFECTS large RCTs negative — NOT recommended routinely; useful for depression w/ adjunct rehab; - **Amantadine**: NEJM Giacino 2012 — improves recovery in DoC TBI 4-16 wk; arousal + cognition; - **Methylphenidate**: attention + processing speed in TBI; cognitive enhancement; - **Donepezil**: limited TBI + post-stroke cognitive; - **Modafinil**: fatigue (MS, TBI); - **Citicoline**: limited overall evidence; - **Erythropoietin, statins, magnesium, GMI**: neuroprotection — limited clinical evidence in stroke recovery; (2) **Potentially harmful (avoid when possible)**: - **Benzodiazepines**: impair learning + plasticity; sedation; - **Anticholinergics**: cognitive impairment; - **First-generation antipsychotics** (haloperidol): impair recovery (animal); - **Phenytoin, phenobarbital**: cognitive impairment; - **Alpha-2 agonists** (clonidine, prazosin selected); - **Dopamine antagonists**: impair recovery (animal data); (3) **Considerations**: drug-drug interactions, polypharmacy, geriatric (Beers/STOPP), comorbidities, off-label use; (4) **Adjuncts to rehab not replacement**: pharma combined w/ intensive task-specific therapy; (5) **Emerging**: BDNF-promoting (exercise itself), G-CSF, stem cells (research), gene therapy; (6) **Neuromodulation**: tDCS, rTMS, vagus nerve stim (VNS — paired w/ rehab — RCT positive post-stroke UE — FDA approved); (7) **Multidisciplinary medication review** + minimize "non-recovery" drugs; **Modern**: precision pharmacology + biomarker-guided + integrated

---

Neurorehab pharm: amantadine TBI DoC + methylphenidate attention helpful. Fluoxetine motor neg (FOCUS/AFFINITY). AVOID benzo + anticholinergic + dopamine antagonist (impair recovery). Adjunct not replacement. Neuromodulation (VNS) emerging.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'basic_science', 'neurology', 'adult',
  'Giacino NEJM; FOCUS; AAN', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'Pharmacologic principles in neurorehabilitation — drugs affecting motor recovery'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ASIA/ISNCSCI classification — components + clinical implication', '[{"label":"A","text":"Single exam at 1 yr only"},{"label":"B","text":"ASIA/ISNCSCI Examination"},{"label":"C","text":"Motor exam only"},{"label":"D","text":"Subjective grading"},{"label":"E","text":"No clinical use"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ASIA/ISNCSCI Examination: (1) **Purpose**: standardized neurologic exam for SCI — communication, prognosis, research; revised periodically (2019 update); (2) **Components**: - **Motor**: 10 key muscles each side (C5-T1 UE + L2-S1 LE) graded 0-5; - **Sensory**: 28 key dermatomes each side, light touch + pinprick graded 0-2; - **Anorectal exam**: voluntary anal contraction (VAC) + deep anal pressure (DAP) — for sacral sparing classification; (3) **Key levels**: - **Neurologic Level of Injury (NLI)**: most caudal segment w/ intact motor + sensory bilaterally; - **Motor Level**: most caudal level w/ motor grade ≥ 3 (intact level above); - **Sensory Level**: most caudal w/ normal LT + PP; (4) **AIS Grade**: - **A — Complete**: no motor or sensory in sacral S4-5 + no VAC + no DAP; - **B — Sensory Incomplete**: sensory but not motor preserved below NLI, including sacral; no motor > 3 levels below; - **C — Motor Incomplete**: motor preserved below + > half key muscles below grade < 3; - **D — Motor Incomplete**: motor preserved below + ≥ half key muscles below grade ≥ 3; - **E — Normal**: all motor + sensory normal in patient w/ prior deficits; (5) **Zone of Partial Preservation (ZPP)**: in AIS A — most caudal segment w/ any preservation; (6) **Recovery prognostication**: - AIS A: 10-15% conversion (often C5-6 motor recovery); - AIS B: ~50% convert to motor incomplete; - AIS C: most → D; - AIS D: most achieve community ambulation; - LEMS (lower extremity motor score) predictive ambulation; (7) **Timing**: serial exams (acute → 72h → 1 mo → 3 mo → 1 yr) — most improvement first 6 mo; (8) **Pitfalls**: spinal shock initial, sedation/intubation, polytrauma; (9) **Application**: rehab planning + research + outcomes; **Modern**: standardized + electronic + integrated outcomes

---

ASIA/ISNCSCI: motor (10 key muscles) + sensory (28 dermatomes LT+PP) + anorectal. NLI, Motor + Sensory levels. AIS A-E grades. ZPP. Recovery prognostic — AIS conversion patterns. Serial exams.', NULL,
  'hard', 'neurology', 'review',
  'rehab_medicine', 'basic_science', 'neurology', 'adult',
  'ISNCSCI 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'ASIA/ISNCSCI classification — components + clinical implication'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'FIM (Functional Independence Measure) — components + use', '[{"label":"A","text":"20-100 scale"},{"label":"B","text":"FIM Instrument"},{"label":"C","text":"Single domain"},{"label":"D","text":"No reliability"},{"label":"E","text":"Only motor"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** FIM Instrument: (1) **Functional Independence Measure**: most widely used functional assessment in inpatient rehab; (2) **18 items, 7-point scale each (1-7)**: total 18-126; - **Motor (13 items)**: self-care (eating, grooming, bathing, dressing upper, dressing lower, toileting), sphincter (bladder, bowel), transfers (bed/chair/wheelchair, toilet, tub/shower), locomotion (walk/wheelchair, stairs); - **Cognitive (5 items)**: communication (comprehension, expression), social cognition (social interaction, problem-solving, memory); (3) **Rating scale**: 7 = complete independence; 6 = modified independence (device); 5 = supervision; 4 = minimal assist (75%+ patient); 3 = moderate assist (50-74%); 2 = maximal (25-49%); 1 = total assist (< 25%); (4) **Use**: - Admission + discharge in IRF (USA — required); - Outcome measurement; - Insurance + payment; - Research; - Goal-setting + progress tracking; (5) **Strengths**: widely used, reliable, validated, established norms; (6) **Limitations**: ceiling/floor effects (mild + severe), single dimension (cannot distinguish e.g. why low score), training required, time to administer; (7) **Alternatives + complement**: Barthel Index (simpler 10-item), Quality Indicators (CMS IRF-PAI section GG since 2018 — replaced FIM in payment), DASH/PROMIS for specific domains; (8) **Pediatric**: WeeFIM (similar items adapted ages 6 mo-7 yr); (9) **Application**: standardized communication across team + facility + payers; **Modern**: transitioning to GG codes (USA) + PROs + technology-enabled assessment

---

FIM: 18 items, 7-point scale (1-7). Motor 13 + Cognitive 5. IRF standard outcome. Admission + DC. Strengths reliable + standardized. Limits ceiling/floor. Pediatric WeeFIM. Transitioning to GG codes.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'rehab_medicine', 'basic_science', 'msk_nontrauma', 'adult',
  'UDSMR FIM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rehab_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'rehab_medicine'
      and q.scenario = 'FIM (Functional Independence Measure) — components + use'
  );

commit;

