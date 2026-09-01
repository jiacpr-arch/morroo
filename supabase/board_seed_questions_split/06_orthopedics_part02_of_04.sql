-- ===============================================================
-- หมอรู้ — Board seed: ออร์โธปิดิกส์ (orthopedics) — part 2/4 (50 MCQs)
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
  s.id, 'board', NULL, 'หญิงไทยอายุ 65 ปี s/p left total hip arthroplasty 6 เดือนก่อน หกล้มในห้องน้ำ ปวด hip ซ้ายอย่างรุนแรง

PE: left leg shortened + internally rotated + adducted (posterior dislocation classic), unable to bear weight, NV intact

X-ray pelvis: posterior dislocation of left THA prosthesis, femoral head out of acetabular component posteriorly, no obvious component loosening', '[{"label":"A","text":"Discharge no reduction"},{"label":"B","text":"Posterior Dislocation Post-THA (within first 6 months — high recurrence risk)"},{"label":"C","text":"Revision THA immediately first dislocation"},{"label":"D","text":"Amputation"},{"label":"E","text":"Steroid injection"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Posterior Dislocation Post-THA (within first 6 months — high recurrence risk): (1) **emergent closed reduction** in ED under sedation (or in OR if difficult/recurrent); evaluate stability through ROM after reduction; (2) post-reduction X-ray confirms concentric; (3) **abduction brace** 6-12 weeks ("hip precautions" — avoid hip flexion > 90°, adduction past midline, internal rotation past neutral — applies posterior approach); (4) PT — strengthening + education; (5) evaluate underlying cause: (a) component malposition (CT — cup anteversion/inclination outside safe zone Lewinnek), (b) impingement, (c) abductor weakness/disruption, (d) leg length discrepancy, (e) cognitive impairment/poor compliance; (6) **recurrent dislocations** (> 2-3) → operative revision options: cup repositioning, larger femoral head, dual mobility implant (lower dislocation), constrained liner (high failure), revision THA; (7) screen infection (CRP, ESR, aspiration ถ้า indicated) — late dislocation could be loosening

---

THA dislocation: 1-3% lifetime. Posterior approach > anterior approach for dislocation risk. Acute: closed reduction + brace + PT + investigate cause (component position, abductor, impingement). Recurrent: operative — cup revision, larger head, dual mobility, constrained liner. Always rule out infection.', NULL,
  'medium', 'trauma', 'review',
  'orthopedics', 'clinical_decision', 'trauma', 'adult',
  'AAOS; Hip Society Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'หญิงไทยอายุ 65 ปี s/p left total hip arthroplasty 6 เดือนก่อน หกล้มในห้องน้ำ ปวด hip ซ้ายอย่างรุนแรง

PE: left leg shortened + internally rotated + adducted (posterior dislocation classic), unable to bear weight, NV intact

X-ray pelvis: posterior dislocation of left THA prosthesis, femoral head out of acetabular component posteriorly, no obvious component loosening'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 22 ปี นักวิ่งระยะไกล ฝึกหนักช่วง 3 เดือน ปวด groin ขวา 6 สัปดาห์ ปวดมากขึ้นเมื่อ weight bear + วิ่ง

Menstrual: amenorrhea 6 months, BMI 17.5
PE: pain on hip internal rotation, antalgic gait, no obvious deformity

X-ray hip: subtle sclerotic line femoral neck superior cortex (compression side initially negative — often subtle)
MRI hip: bone marrow edema + linear hypointense line femoral neck inferior (compression side) — stress fracture
— low-risk compression side', '[{"label":"A","text":"Continue running with NSAIDs"},{"label":"B","text":"Female Athlete Triad — Compression Side Femoral Neck Stress Fracture"},{"label":"C","text":"Total hip arthroplasty"},{"label":"D","text":"Long-leg cast 12 weeks"},{"label":"E","text":"Steroid injection hip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Female Athlete Triad — Compression Side Femoral Neck Stress Fracture: (1) **non-weight-bearing crutches** + bed rest until pain-free → progressive WB as tolerated 6-12 weeks; (2) compression side (inferior/medial) — low risk: usually heals with non-op; tension side (superior/lateral) — high risk: percutaneous cannulated screw fixation (3 screws inverted triangle) เพื่อ prevent completion + displacement (catastrophic — AVN, nonunion); (3) **address Female Athlete Triad/RED-S**: nutritional rehabilitation (calorie + calcium + vit D), restore menstrual cycle, treat underlying eating disorder if present — multidisciplinary (sports med, endo, nutrition, psych); (4) DEXA — low BMD common; (5) gradual return to running with biomechanical/training modifications (cadence, volume, surface, footwear); (6) f/u MRI/X-ray; (7) bisphosphonate not first line in young women; (8) education prevention

---

Femoral neck stress fracture: female athletes, military recruits. Tension side (superior) = high risk → surgical fixation. Compression side (inferior) = low risk → non-weight bearing + healing. Always investigate Female Athlete Triad/RED-S (low energy availability + menstrual dysfunction + low BMD). Multidisciplinary management essential.', NULL,
  'hard', 'trauma', 'review',
  'orthopedics', 'clinical_decision', 'trauma', 'adult',
  'AOSSM; Female Athlete Triad Consensus 2014', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'หญิงไทยอายุ 22 ปี นักวิ่งระยะไกล ฝึกหนักช่วง 3 เดือน ปวด groin ขวา 6 สัปดาห์ ปวดมากขึ้นเมื่อ weight bear + วิ่ง

Menstrual: amenorrhea 6 months, BMI 17.5
PE: pain on hip internal rotation, antalgic gait, no obvious deformity

X-ray hip: subtle sclerotic line femoral neck superior cortex (compression side initially negative — often subtle)
MRI hip: bone marrow edema + linear hypointense line femoral neck inferior (compression side) — stress fracture
— low-risk compression side'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 35 ปี motorcycle accident open wound ต้นขาขวา 6 cm with bone exposed + active bleeding

V/S: BP 102/68, HR 118
PE: 6 cm wound thigh anterior + bone protruding, moderate contamination, NV distal intact, no degloving, soft tissue coverage adequate after debridement
Last tetanus > 10 years

X-ray femur: transverse midshaft femoral fracture, open Gustilo type IIIA (wound > 10 cm but adequate soft tissue coverage)', '[{"label":"A","text":"Wait 48 hours antibiotic only"},{"label":"B","text":"Open Femoral Shaft Fracture Gustilo IIIA"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Above-knee amputation immediately"},{"label":"E","text":"Cast immobilization only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Open Femoral Shaft Fracture Gustilo IIIA: (1) **ATLS + IV resuscitation**; (2) **IV antibiotic within 1 hour** — cefazolin (Gustilo I-II) or cefazolin + aminoglycoside (Gustilo III) or piperacillin-tazobactam; add penicillin/metronidazole if farm/anaerobic contamination; (3) tetanus prophylaxis update (Tdap + TIG if dirty + > 5 years); (4) **urgent debridement + irrigation in OR within 6-24 hours** (recent evidence — within 24h acceptable if antibiotics started early, prior "6-hour rule" relaxed) — remove all devitalized tissue + foreign material, copious irrigation (saline, low-pressure — high-pressure increases tissue damage); (5) **stabilize fracture** — reamed intramedullary nailing standard for IIIA closed-conversion; external fixation for damage control/grossly contaminated; (6) wound management: primary closure if clean + low tension; otherwise VAC + delayed closure 3-7 days; soft tissue flap for IIIB; (7) repeat debridement q 48-72h until clean; (8) infection prevention — modern infection rate IIIA 5%, IIIB 17%

---

Open fractures: emergency. ABCs → antibiotic within 1h → tetanus → debridement OR (24h acceptable with early abx) → stabilization. Gustilo I-II cefazolin; III add aminoglycoside or piperacillin-tazobactam. Femur IIIA: IM nail standard. Goal: prevent infection. Soft tissue dictates flap need (IIIB) or amputation (IIIC).', NULL,
  'medium', 'trauma', 'review',
  'orthopedics', 'clinical_decision', 'trauma', 'adult',
  'OTA; Eastern Association Trauma', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 35 ปี motorcycle accident open wound ต้นขาขวา 6 cm with bone exposed + active bleeding

V/S: BP 102/68, HR 118
PE: 6 cm wound thigh anterior + bone protruding, moderate contamination, NV distal intact, no degloving, soft tissue coverage adequate after debridement
Last tetanus > 10 years

X-ray femur: transverse midshaft femoral fracture, open Gustilo type IIIA (wound > 10 cm but adequate soft tissue coverage)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 32 ปี รถยนต์ชน knee against dashboard มาห้องฉุกเฉิน ปวด + ผิดรูปเข่าขวาอย่างรุนแรง

V/S: BP 124/78, HR 102
PE: gross deformity knee, palpable pedal pulses (DP, PT) — but ABI 0.7 right (vs 1.0 left), foot warm + capillary refill 2-3 s, decreased sensation lateral leg + dorsum foot (peroneal nerve), unable to dorsiflex foot, no open wound

X-ray + reduction performed → spontaneous reduction noted
CT angiography lower extremity: intimal flap popliteal artery with patent distal flow', '[{"label":"A","text":"Discharge home if pulses palpable"},{"label":"B","text":"vascular assessment essential"},{"label":"C","text":"ACL reconstruction emergent same day"},{"label":"D","text":"Above-knee amputation immediately"},{"label":"E","text":"Cast in extension 12 weeks without imaging"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Knee Dislocation (high-energy, multiligamentous injury) — vascular emergency: (1) emergent reduction (if not spontaneous) under sedation; (2) **vascular assessment essential** — even palpable pulses don''t exclude injury (intimal flap, dissection can thrombose later) — **ABI < 0.9** mandates **CT angiography** (modern standard) or formal angiography; (3) vascular surgery consult — repair intimal flap (resection + interposition vein graft, stenting), 4-compartment fasciotomy after revascularization if ischemia > 6 hours; (4) peroneal nerve injury 25-40% — observe, AFO for foot drop, neurolysis vs grafting if no recovery 3-6 months (poor prognosis); (5) immobilize in extension splint/external fixator for soft tissue rest; (6) **delayed multiligamentous reconstruction** (ACL + PCL + collaterals) 2-3 weeks after soft tissue settles in single stage; (7) DVT prophylaxis; (8) PT post-op intensive 6-12 months

---

Knee dislocation: vascular emergency. 10-30% popliteal artery injury. Even with palpable pulses — ABI < 0.9 → CTA. Delayed thrombosis common (intimal flap). Peroneal nerve injury 25-40%. Multiligamentous reconstruction (ACL+PCL+collaterals) delayed 2-3 weeks. Long rehabilitation. Knee Dislocation = Spontaneously reduced often missed.', NULL,
  'hard', 'trauma', 'review',
  'orthopedics', 'clinical_decision', 'trauma', 'adult',
  'OTA; KD Schenck classification', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 32 ปี รถยนต์ชน knee against dashboard มาห้องฉุกเฉิน ปวด + ผิดรูปเข่าขวาอย่างรุนแรง

V/S: BP 124/78, HR 102
PE: gross deformity knee, palpable pedal pulses (DP, PT) — but ABI 0.7 right (vs 1.0 left), foot warm + capillary refill 2-3 s, decreased sensation lateral leg + dorsum foot (peroneal nerve), unable to dorsiflex foot, no open wound

X-ray + reduction performed → spontaneous reduction noted
CT angiography lower extremity: intimal flap popliteal artery with patent distal flow'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 55 ปี หกล้มลงเข่าขวา ปวด + บวมเข่าขวา เหยียดเข่าไม่ได้

PE: palpable gap patella, large effusion, unable to perform straight leg raise actively, NV intact

X-ray knee AP/lateral/sunrise: transverse displaced patellar fracture, displacement 5 mm, intra-articular step 2 mm, intact extensor mechanism disrupted', '[{"label":"A","text":"Cylinder cast extension 12 weeks"},{"label":"B","text":"Displaced Transverse Patellar Fracture with Disrupted Extensor Mechanism"},{"label":"C","text":"Total patellectomy first"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Steroid injection"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Displaced Transverse Patellar Fracture with Disrupted Extensor Mechanism: (1) **operative ORIF** indicated เพราะ: displacement > 3 mm, articular step > 2 mm, loss of active knee extension; (2) **tension band wiring** (parallel K-wires + figure-of-8 stainless wire over anterior surface) — gold standard for simple transverse; biomechanical conversion tension → compression; high hardware-related complications 30-60% → removal common; (3) modern alternatives — cannulated screws + tension band, anterior plate for comminuted, suture/FiberWire tension band; (4) partial patellectomy + extensor mechanism repair for severely comminuted inferior pole; (5) avoid total patellectomy (loss of extensor mechanism + quadriceps lever); (6) post-op: immobilize in extension brace 2-6 weeks (locked initially, progressive ROM); WBAT in brace; (7) PT — gentle ROM 0-30° early, advance with healing; (8) full ROM + quadriceps strengthening; (9) f/u X-ray for displacement

---

Patellar fracture: extensor mechanism injury. Inability to SLR + displacement/step → ORIF. Tension band wiring classic (hardware removal 60%). Modern — cannulated screws + tension band, plate for comminuted. Avoid total patellectomy. Early ROM with bracing. Non-op for non-displaced + intact SLR.', NULL,
  'medium', 'trauma', 'review',
  'orthopedics', 'clinical_decision', 'trauma', 'adult',
  'AAOS; OTA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'หญิงไทยอายุ 55 ปี หกล้มลงเข่าขวา ปวด + บวมเข่าขวา เหยียดเข่าไม่ได้

PE: palpable gap patella, large effusion, unable to perform straight leg raise actively, NV intact

X-ray knee AP/lateral/sunrise: transverse displaced patellar fracture, displacement 5 mm, intra-articular step 2 mm, intact extensor mechanism disrupted'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 42 ปี รถยนต์ชน high-energy ปวด + บวมเข่าซ้ายอย่างรุนแรง

PE: massive swelling + ecchymosis, knee deformed, fracture blisters เริ่มมี, tense compartment forearm — wait, leg compartments tense + painful, distal pulses palpable but diminished, sensory intact

X-ray + CT knee: bicondylar tibial plateau fracture + metaphyseal-diaphyseal dissociation + medial split + lateral depression — Schatzker VI
Compartment pressure leg: 42 mmHg', '[{"label":"A","text":"Immediate ORIF same day"},{"label":"B","text":"Schatzker VI Tibial Plateau Fracture + Compartment Syndrome"},{"label":"C","text":"Cast immobilization 12 weeks only"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Amputation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Schatzker VI Tibial Plateau Fracture + Compartment Syndrome: (1) **emergent 4-compartment fasciotomy** of leg (anterior, lateral, deep posterior, superficial posterior) — compartment syndrome must be addressed within 6 hours; (2) **damage control orthopedics — spanning external fixator** across knee to provide initial stability, allow soft tissue to settle, monitor compartments; (3) **delayed definitive ORIF** (10-21 days) after soft tissue recovery (fracture blisters resolve, swelling decreased — wrinkle sign) — dual incision dual plate construct for bicondylar, restore articular congruity + axis + length; (4) bone grafting subchondral defects (autograft, allograft, BMP, calcium phosphate); (5) protected non-weight bearing 10-12 weeks; (6) early ROM with CPM; (7) screen vascular injury (ABI); (8) DVT prophylaxis; (9) high risk post-traumatic OA → counsel; (10) staged approach reduces wound complications (Egol JOT classic)

---

Schatzker VI: high-energy bicondylar + metaphyseal-diaphyseal dissociation. STAGED management: (1) ex-fix + fasciotomy emergent; (2) delayed ORIF after soft tissue (10-21d) — reduces wound infection from 80% → 5%. Compartment syndrome common — vigilance. PT-OA frequent. Goal: anatomic articular, restored axis, soft tissue salvage.', NULL,
  'hard', 'trauma', 'review',
  'orthopedics', 'clinical_decision', 'trauma', 'adult',
  'OTA; AO Foundation', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 42 ปี รถยนต์ชน high-energy ปวด + บวมเข่าซ้ายอย่างรุนแรง

PE: massive swelling + ecchymosis, knee deformed, fracture blisters เริ่มมี, tense compartment forearm — wait, leg compartments tense + painful, distal pulses palpable but diminished, sensory intact

X-ray + CT knee: bicondylar tibial plateau fracture + metaphyseal-diaphyseal dissociation + medial split + lateral depression — Schatzker VI
Compartment pressure leg: 42 mmHg'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 40 ปี ตกจากที่สูง 4 เมตร ลงเท้าขวา ปวด + บวม ankle ขวาอย่างรุนแรง

PE: marked swelling + fracture blisters เริ่มเกิดที่ ankle, deformity, NV intact distal, no open wound

X-ray + CT ankle: intra-articular distal tibial fracture (pilon/plafond), comminuted articular surface, metaphyseal extension, fibula fracture also — AO/OTA 43-C3', '[{"label":"A","text":"Immediate ORIF same day"},{"label":"B","text":"Pilon Fracture AO/OTA 43-C3 (high-energy intra-articular distal tibia with severe comminution + soft tissue compromise)"},{"label":"C","text":"Cast 12 weeks no surgery"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Below-knee amputation immediately"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pilon Fracture AO/OTA 43-C3 (high-energy intra-articular distal tibia with severe comminution + soft tissue compromise): (1) **damage control — spanning external fixator** across ankle joint (calcaneus + proximal tibia) immediately + fibula ORIF (anatomic plate restores length + alignment as a column); (2) **wait for soft tissue recovery** (10-21 days) — fracture blisters resolve, swelling decreased (wrinkle test) — Sirkin/Egol staged approach reduces wound complication catastrophe (90% → 5%); (3) **definitive ORIF distal tibia** — anatomic plate (medial or anterolateral plate), restore articular congruity + length + alignment + axial deformity correction; bone grafting subchondral defects; (4) non-weight bearing 10-12 weeks; (5) early ankle ROM; (6) DVT prophylaxis; (7) complications: wound dehiscence, infection, post-traumatic OA (high — 30-50%), stiffness, malunion; (8) salvage: ankle arthrodesis if PTOA; (9) primary arthrodesis for irreparable destruction selected

---

Pilon fracture: distal tibia intra-articular high-energy axial load. Soft tissue is the enemy. STAGED protocol: ex-fix + fibula ORIF → wait 10-21d → definitive tibia ORIF. Reduces catastrophic infection. High PTOA risk → counsel. Salvage by ankle arthrodesis.', NULL,
  'hard', 'trauma', 'review',
  'orthopedics', 'clinical_decision', 'trauma', 'adult',
  'OTA; Sirkin Staged Protocol JOT 1999', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 40 ปี ตกจากที่สูง 4 เมตร ลงเท้าขวา ปวด + บวม ankle ขวาอย่างรุนแรง

PE: marked swelling + fracture blisters เริ่มเกิดที่ ankle, deformity, NV intact distal, no open wound

X-ray + CT ankle: intra-articular distal tibial fracture (pilon/plafond), comminuted articular surface, metaphyseal extension, fibula fracture also — AO/OTA 43-C3'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 38 ปี เล่นแบดมินตัน รู้สึกเหมือนถูกตีหลังเท้า ฟังได้ยินเสียง pop ทันที + ปวด + เดินไม่ได้

PE: palpable gap 4 cm above calcaneus insertion, weakness plantarflexion, positive Thompson test (calf squeeze ไม่ทำให้เกิด passive plantarflexion), able to weak active plantarflexion via FHL/peroneals

US / MRI ankle: complete Achilles tendon rupture 4 cm proximal to calcaneal insertion, gap 3 cm, ends frayed', '[{"label":"A","text":"Long-leg cast 12 weeks plantarflexion"},{"label":"B","text":"Acute Achilles Tendon Rupture (active middle-aged athlete)"},{"label":"C","text":"Discharge no immobilization"},{"label":"D","text":"Above-knee amputation"},{"label":"E","text":"Steroid injection Achilles tendon"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Achilles Tendon Rupture (active middle-aged athlete): (1) **either operative or non-operative — modern evidence (Willits + recent meta-analyses) shows similar re-rupture rate (~4-5%) ถ้า functional rehabilitation + early weight-bearing protocol**; (2) **non-operative (functional rehab)**: equinus cast/boot 2 weeks → progressive heel lift in CAM boot with WBAT, gradual neutral over 6-8 weeks, PT — comparable re-rupture rate vs surgery with proper protocol; (3) **operative (open or percutaneous repair)**: end-to-end repair (Krackow stitches, Bunnell) — slightly lower re-rupture in some studies + faster return to sport in high-level athletes + better push-off strength; risks: wound complications (5-10%), sural nerve injury (percutaneous higher); (4) **delayed presentation (> 4-6 weeks)** or chronic — requires augmentation (FHL transfer, V-Y advancement, allograft); (5) shared decision-making — athlete level, medical comorbidities, surgical risk; (6) DVT risk during immobilization — prophylaxis selective; (7) return to sport 4-6 months

---

Achilles rupture: modern evidence — operative vs non-operative with functional rehab → similar re-rupture (4-5%). Shared decision. Surgery for high-level athletes (push-off strength, faster return). Non-op: equinus → progressive WB in boot 8 wk. Surgery: open or percutaneous repair. Chronic → augmentation (FHL transfer). Thompson test diagnostic.', NULL,
  'medium', 'trauma', 'review',
  'orthopedics', 'clinical_decision', 'trauma', 'adult',
  'AOFAS; Willits JBJS 2010', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 38 ปี เล่นแบดมินตัน รู้สึกเหมือนถูกตีหลังเท้า ฟังได้ยินเสียง pop ทันที + ปวด + เดินไม่ได้

PE: palpable gap 4 cm above calcaneus insertion, weakness plantarflexion, positive Thompson test (calf squeeze ไม่ทำให้เกิด passive plantarflexion), able to weak active plantarflexion via FHL/peroneals

US / MRI ankle: complete Achilles tendon rupture 4 cm proximal to calcaneal insertion, gap 3 cm, ends frayed'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 28 ปี เล่นฟุตบอล ถูกบิดเท้าขวา ปวด midfoot + บวม + เดินลำบาก

PE: midfoot swelling + plantar ecchymosis (Ross sign — pathognomonic), tender TMT joints, painful weight-bearing

X-ray foot AP + oblique + lateral + weight-bearing: widening between 1st-2nd metatarsal base > 2 mm, fleck sign (small avulsion fragment at base 2nd MT from Lisfranc ligament) — Lisfranc injury
Weight-bearing X-ray shows increased gap vs non-weight-bearing
CT confirms instability + small TMT fractures', '[{"label":"A","text":"Cast non-weight bearing 4 weeks only"},{"label":"B","text":"Lisfranc Tarsometatarsal Joint Injury (unstable, displacement > 2 mm, weight-bearing widening + fleck sign)"},{"label":"C","text":"Discharge home no imaging"},{"label":"D","text":"Steroid injection"},{"label":"E","text":"Amputation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Lisfranc Tarsometatarsal Joint Injury (unstable, displacement > 2 mm, weight-bearing widening + fleck sign): (1) **plantar ecchymosis pathognomonic** — high suspicion warranted; (2) X-ray non-WB often misses → **weight-bearing X-ray + comparison views + CT mandatory**; (3) **operative ORIF** for ANY displacement > 2 mm หรือ instability — anatomic reduction critical (any malalignment → PTOA); options: (a) trans-articular screws ("home run screw" 2nd MT base to medial cuneiform + bridge plates), (b) **dorsal bridge plating** (preserves articular cartilage, increasingly preferred), (c) **primary arthrodesis** of 1st-3rd TMT — recent evidence shows lower revision rate + better outcomes for purely ligamentous Lisfranc (Ly + Coetzee JBJS); (4) non-weight bearing 8-12 weeks post-op; (5) hardware removal 4-6 months for non-arthrodesis; (6) **non-operative (cast) only for truly non-displaced + stable** confirmed by weight-bearing imaging and CT; (7) high PTOA rate if missed — late arthrodesis salvage

---

Lisfranc injury: TMT joint complex. Plantar ecchymosis + fleck sign + 2-MT-medial cuneiform widening. Weight-bearing X-ray + CT essential. ANY displacement > 2 mm = surgical. Modern trend: primary arthrodesis for ligamentous Lisfranc (Ly/Coetzee). Bridge plating preserves cartilage. Missed → PTOA → late arthrodesis salvage.', NULL,
  'hard', 'trauma', 'review',
  'orthopedics', 'clinical_decision', 'trauma', 'adult',
  'AOFAS; Ly + Coetzee JBJS 2006', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 28 ปี เล่นฟุตบอล ถูกบิดเท้าขวา ปวด midfoot + บวม + เดินลำบาก

PE: midfoot swelling + plantar ecchymosis (Ross sign — pathognomonic), tender TMT joints, painful weight-bearing

X-ray foot AP + oblique + lateral + weight-bearing: widening between 1st-2nd metatarsal base > 2 mm, fleck sign (small avulsion fragment at base 2nd MT from Lisfranc ligament) — Lisfranc injury
Weight-bearing X-ray shows increased gap vs non-weight-bearing
CT confirms instability + small TMT fractures'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 35 ปี construction worker ตกจากที่สูง 3 เมตร ลงเท้าทั้งสองข้าง ปวด heel ทั้งสองข้าง + บวมมาก

PE: bilateral heel swelling + ecchymosis (Mondor sign — plantar arch ecchymosis), heel width increased, varus deformity, fracture blisters appearing
Neurovascular intact, check sensation tibial nerve
Check spine — frequently associated lumbar burst fracture

CT calcaneus: intra-articular calcaneal fracture, depressed posterior facet > 3 mm step, displacement of tuberosity fragment, Böhler angle reduced to 5° — Sanders type III', '[{"label":"A","text":"Immediate ORIF same day extended lateral"},{"label":"B","text":"Sanders III Intra-articular Calcaneal Fracture + Associated Lumbar Injury Screening"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Below-knee amputation"},{"label":"E","text":"Steroid injection"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Sanders III Intra-articular Calcaneal Fracture + Associated Lumbar Injury Screening: (1) **screen associated injuries** — concurrent lumbar burst/compression fracture 10-15%, contralateral calcaneus, talus, knee, tibial plateau — spine X-ray/CT, full secondary survey; (2) elevate, ice, splint, soft tissue rest; (3) **wait for soft tissue recovery** (10-21 days) — fracture blisters resolve, wrinkle test positive; (4) **operative ORIF** for displaced intra-articular (Sanders II-IV) in healthy active patients: (a) **extended lateral approach** + lateral plate — traditional, high wound complication rate 20-30%; (b) **sinus tarsi approach** (less invasive, lower wound complication) — current trend; (5) goals: restore Böhler angle, posterior facet articular congruity, heel height + width + alignment; (6) **non-operative** considered: minimally displaced, smokers, diabetics, peripheral vascular disease, workers compensation (controversial — HEALTH trial showed no difference); (7) non-weight bearing 10-12 weeks; (8) high PTOA rate — counsel; subtalar arthrodesis salvage; (9) DVT prophylaxis

---

Calcaneal fracture: axial load (fall from height). Always screen associated injuries (lumbar burst 10-15%, contralateral, talus, knee). Sanders classification on coronal CT. Operative for displaced intra-articular healthy patient — sinus tarsi approach trending (lower wound complications vs extended lateral). High PTOA → subtalar arthrodesis salvage. Soft tissue rest 10-21d critical.', NULL,
  'hard', 'trauma', 'review',
  'orthopedics', 'clinical_decision', 'trauma', 'adult',
  'AOFAS; Sanders JOT; HEALTH Trial', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 35 ปี construction worker ตกจากที่สูง 3 เมตร ลงเท้าทั้งสองข้าง ปวด heel ทั้งสองข้าง + บวมมาก

PE: bilateral heel swelling + ecchymosis (Mondor sign — plantar arch ecchymosis), heel width increased, varus deformity, fracture blisters appearing
Neurovascular intact, check sensation tibial nerve
Check spine — frequently associated lumbar burst fracture

CT calcaneus: intra-articular calcaneal fracture, depressed posterior facet > 3 mm step, displacement of tuberosity fragment, Böhler angle reduced to 5° — Sanders type III'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 38 ปี ออฟฟิศ ปวดหลังร้าวลงขาขวา 4 สัปดาห์ ปวดมากขึ้นนั่งนาน + ก้ม + ไอ จาม
ไม่มี bowel/bladder dysfunction

PE: positive straight leg raise right at 40°, weakness EHL right 4/5, decreased pinprick L5 dermatome dorsum foot, reflexes preserved

MRI L-spine: paracentral right disc herniation L4-L5 compressing exiting L5 nerve root, no other levels significantly affected, no cord/cauda compression', '[{"label":"A","text":"Emergent surgery same day"},{"label":"B","text":"Acute Lumbar Radiculopathy L4-L5 Disc Herniation Without Red Flags"},{"label":"C","text":"Long-term opioid 6 months"},{"label":"D","text":"Bedrest 6 weeks strict"},{"label":"E","text":"Spinal fusion immediately"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Lumbar Radiculopathy L4-L5 Disc Herniation Without Red Flags: (1) **non-operative trial 6-12 weeks first** — natural history favorable, 80-90% improve; (2) education + reassurance + activity modification (avoid prolonged sitting + heavy lifting แต่ encourage maintaining activity, no bed rest > 1-2 days); (3) **physical therapy** — directional preference (McKenzie extension), core stabilization, nerve mobilization; (4) pharmacologic: NSAIDs first line; short course oral steroid (limited evidence — consider in severe radicular pain); gabapentin/pregabalin for neuropathic pain; acetaminophen; avoid long-term opioids; (5) **epidural steroid injection** (transforaminal) — moderate evidence for short-term radicular pain relief, considered if persistent severe pain despite conservative; (6) **surgical microdiscectomy** ถ้า: failure of 6-12 weeks conservative + persistent radicular pain + correlating imaging + neurologic deficit (progressive motor weakness, intractable pain affecting QoL); urgent surgery for: cauda equina syndrome, progressive motor deficit; (7) SPORT trial — surgery faster recovery แต่ similar 2-yr outcomes vs conservative; (8) f/u red flags education

---

Lumbar radiculopathy from HNP: 80-90% resolve with conservative. Trial 6-12 weeks. PT + NSAIDs + ESI selective. Surgery for failed conservative or red flags (CES, progressive deficit). SPORT trial — faster recovery with surgery but similar 2-year outcomes. Microdiscectomy gold standard.', NULL,
  'easy', 'neurology', 'review',
  'orthopedics', 'clinical_decision', 'neurology', 'adult',
  'NASS Guidelines; SPORT Trial NEJM 2008', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 38 ปี ออฟฟิศ ปวดหลังร้าวลงขาขวา 4 สัปดาห์ ปวดมากขึ้นนั่งนาน + ก้ม + ไอ จาม
ไม่มี bowel/bladder dysfunction

PE: positive straight leg raise right at 40°, weakness EHL right 4/5, decreased pinprick L5 dermatome dorsum foot, reflexes preserved

MRI L-spine: paracentral right disc herniation L4-L5 compressing exiting L5 nerve root, no other levels significantly affected, no cord/cauda compression'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 45 ปี ปวดคอร้าวลงแขนซ้าย 3 สัปดาห์ ปวดมากขึ้นเมื่อ extension + lateral bend ซ้าย ชาปลายนิ้วโป้ง + ชี้ + กลาง อ่อนแรง biceps + brachioradialis

PE: positive Spurling test (head extension + rotation toward ipsilateral side reproduces pain), weakness biceps 4/5, decreased biceps reflex, decreased sensation C6 dermatome (thumb + index)

MRI C-spine: left paracentral C5-C6 disc herniation compressing exiting C6 root, no cord compression, no signal change cord', '[{"label":"A","text":"Emergent fusion same day"},{"label":"B","text":"Acute Cervical Radiculopathy C6 from C5-C6 Disc Herniation Without Myelopathy"},{"label":"C","text":"Long-term cervical traction at home"},{"label":"D","text":"Discharge no follow-up"},{"label":"E","text":"Long-term opioid"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Cervical Radiculopathy C6 from C5-C6 Disc Herniation Without Myelopathy: (1) **non-operative trial 6-12 weeks** — favorable natural history, 75-90% improve; (2) education + activity modification (avoid provocative posture, ergonomics); (3) PT — gentle ROM, isometric strengthening, traction (cervical), nerve glides, postural; (4) NSAIDs, short oral steroid trial, gabapentin/pregabalin for neuropathic pain; (5) soft cervical collar limited (deconditioning if prolonged); (6) **cervical epidural steroid injection** (interlaminar approach in cervical — transforaminal risk vascular injury/stroke) for severe persistent pain; (7) **surgical decompression** indications: failed conservative + persistent radicular pain + corresponding imaging + neurologic deficit; OR myelopathy; OR progressive motor weakness — options: **anterior cervical discectomy and fusion (ACDF)** — gold standard, or **cervical disc arthroplasty (CDA)** — motion-preserving alternative for single-level non-osteoporotic patients, or posterior foraminotomy (lateral herniation, preserves motion); (8) ACDF vs CDA — comparable outcomes; CDA may reduce adjacent segment disease

---

Cervical radiculopathy: trial conservative 6-12 weeks. Spurling test sensitive. ACDF gold standard for failed conservative. CDA motion-preserving alternative (single-level, young, no osteoporosis). Posterior foraminotomy for lateral herniation. Avoid transforaminal ESI cervical (stroke risk). Watch for myelopathy.', NULL,
  'medium', 'neurology', 'review',
  'orthopedics', 'clinical_decision', 'neurology', 'adult',
  'NASS Cervical Radiculopathy Guidelines 2010', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 45 ปี ปวดคอร้าวลงแขนซ้าย 3 สัปดาห์ ปวดมากขึ้นเมื่อ extension + lateral bend ซ้าย ชาปลายนิ้วโป้ง + ชี้ + กลาง อ่อนแรง biceps + brachioradialis

PE: positive Spurling test (head extension + rotation toward ipsilateral side reproduces pain), weakness biceps 4/5, decreased biceps reflex, decreased sensation C6 dermatome (thumb + index)

MRI C-spine: left paracentral C5-C6 disc herniation compressing exiting C6 root, no cord compression, no signal change cord'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 42 ปี ปวดหลังร้าวลงขาทั้ง 2 ข้าง 1 สัปดาห์ วันนี้เริ่ม urinary retention + saddle anesthesia + ขาอ่อนแรงทั้งสองข้าง

V/S: ปกติ
PE: bilateral lower extremity weakness 3/5 distal, decreased perianal + saddle sensation, decreased anal tone, post-void residual 600 mL on bladder scan, decreased Achilles + patellar reflex bilateral

MRI L-spine: large central disc herniation L4-L5 with severe canal stenosis compressing cauda equina, all roots distorted', '[{"label":"A","text":"Conservative 6-week trial"},{"label":"B","text":"Cauda Equina Syndrome (CES) — Surgical Emergency"},{"label":"C","text":"Discharge home with NSAIDs"},{"label":"D","text":"Bedrest 2 weeks reassessment"},{"label":"E","text":"Steroid injection only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cauda Equina Syndrome (CES) — Surgical Emergency: (1) **emergent surgical decompression within 24-48 hours** (some advocate < 24h, others < 48h — meta-analyses suggest earlier surgery → better neurologic recovery especially bladder function, but "as soon as feasible" key); (2) **wide laminectomy + decompression + discectomy** of offending herniation; preserve as much bone as needed for stability; instrumentation if instability; (3) NPO + IV + Foley catheter; (4) detailed neurologic + perineal exam + bladder scan (post-void residual > 200 mL highly suspicious); (5) **MRI lumbar emergent** definitive imaging; CT myelogram if MRI contraindicated; (6) urology consult — bladder function monitoring; (7) post-op: rehabilitation, monitor bowel/bladder/sexual function; many residual deficits even with timely surgery — counseling; (8) document carefully for medicolegal — CES common litigation; (9) etiologies: massive disc herniation (most common), tumor, epidural abscess, hematoma, trauma — treatment differs

---

Cauda equina syndrome: surgical emergency. Triad — bilateral leg pain/weakness, saddle anesthesia, bladder/bowel dysfunction. PVR > 200 mL sensitive. MRI emergent. Decompression < 24-48h (earlier = better outcomes especially bladder). Even with timely surgery — residual deficits common. CES = high medicolegal risk — document carefully.', NULL,
  'easy', 'neurology', 'review',
  'orthopedics', 'clinical_decision', 'neurology', 'adult',
  'NASS; AAOS; BJS CES Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 42 ปี ปวดหลังร้าวลงขาทั้ง 2 ข้าง 1 สัปดาห์ วันนี้เริ่ม urinary retention + saddle anesthesia + ขาอ่อนแรงทั้งสองข้าง

V/S: ปกติ
PE: bilateral lower extremity weakness 3/5 distal, decreased perianal + saddle sensation, decreased anal tone, post-void residual 600 mL on bladder scan, decreased Achilles + patellar reflex bilateral

MRI L-spine: large central disc herniation L4-L5 with severe canal stenosis compressing cauda equina, all roots distorted'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 70 ปี ปวดหลัง + ปวดร้าวลงขาทั้ง 2 ข้าง เมื่อยืน + เดิน > 5 นาที พักนั่ง/ก้ม → ดีขึ้น 2 ปี วันนี้เดินได้น้อยลง

PE: positive shopping cart sign (improvement with flexion), no significant motor weakness, mildly decreased Achilles reflex, normal vascular exam, normal ABI

MRI L-spine: multilevel central + lateral recess stenosis L3-L4 + L4-L5, ligamentum flavum hypertrophy, facet arthropathy, no instability on flexion-extension X-ray', '[{"label":"A","text":"Emergent fusion all levels"},{"label":"B","text":"Symptomatic Multilevel Lumbar Spinal Stenosis (Neurogenic Claudication)"},{"label":"C","text":"Bedrest 6 weeks"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Long-term opioid as first line"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Symptomatic Multilevel Lumbar Spinal Stenosis (Neurogenic Claudication): (1) **conservative first-line**: PT (flexion-based exercises, core stabilization, aerobic conditioning — stationary bike often tolerated better than walking), NSAIDs, weight loss, gabapentin/pregabalin selective; (2) **epidural steroid injection** — moderate short-term benefit (recent evidence — LESS trial showed modest effect); (3) avoid long-term opioids; (4) **surgical decompression** (laminectomy ± foraminotomy ± medial facetectomy) indicated: failure of 3-6 months conservative + significant functional limitation + corresponding imaging; SPORT trial — surgery superior to conservative at 2-4 years for stenosis; (5) **fusion added** only if: degenerative spondylolisthesis with instability, scoliosis with imbalance, iatrogenic instability from decompression; SLIP trial — fusion not superior to decompression alone for stable degenerative spondylolisthesis (controversial); (6) interspinous spacer minimal role current; (7) elderly — surgery often well-tolerated; counsel realistic outcomes (back pain may persist); (8) DDx: vascular claudication (improves with rest standing, ABI < 0.9) — differentiate

---

Lumbar spinal stenosis: degenerative, elderly. Neurogenic claudication — improves with flexion (shopping cart sign). Conservative first (PT, NSAIDs, ESI). Surgery (laminectomy) for failed conservative — SPORT trial supports. Fusion adds risk — reserved for instability/spondylolisthesis/scoliosis (SLIP trial). Differentiate from vascular (ABI).', NULL,
  'medium', 'neurology', 'review',
  'orthopedics', 'clinical_decision', 'neurology', 'adult',
  'NASS Lumbar Stenosis Guidelines; SPORT Trial', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 70 ปี ปวดหลัง + ปวดร้าวลงขาทั้ง 2 ข้าง เมื่อยืน + เดิน > 5 นาที พักนั่ง/ก้ม → ดีขึ้น 2 ปี วันนี้เดินได้น้อยลง

PE: positive shopping cart sign (improvement with flexion), no significant motor weakness, mildly decreased Achilles reflex, normal vascular exam, normal ABI

MRI L-spine: multilevel central + lateral recess stenosis L3-L4 + L4-L5, ligamentum flavum hypertrophy, facet arthropathy, no instability on flexion-extension X-ray'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 62 ปี ค่อย ๆ มีอาการเดินไม่มั่นคง 6 เดือน + ลำบากในการใช้มือ (ติดกระดุม เขียนแย่ลง) + ชาปลายมือทั้งสองข้าง ไม่มี neck pain ชัดเจน

PE: hyperreflexia BJ + KJ + AJ bilateral, positive Hoffmann''s sign bilateral, positive Babinski bilateral, wide-based unsteady gait, +Lhermitte sign with neck flexion, decreased pinprick distal hand bilateral

MRI C-spine: multilevel cervical spondylosis with severe canal stenosis C4-C5 + C5-C6 + C6-C7 with cord compression + T2 myelomalacia signal change', '[{"label":"A","text":"Conservative observation always"},{"label":"B","text":"Cervical Spondylotic Myelopathy (CSM) with Cord Signal Change"},{"label":"C","text":"Cervical traction long term"},{"label":"D","text":"Long-term opioid"},{"label":"E","text":"Steroid injection only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cervical Spondylotic Myelopathy (CSM) with Cord Signal Change: (1) **surgical decompression generally recommended** (AOSpine CSM guidelines) — natural history of moderate-severe myelopathy → progressive deterioration; even mild myelopathy with signal change favors surgery; (2) approach depends on: number of levels, cervical alignment (lordosis vs kyphosis), location of compression: (a) **anterior cervical discectomy and fusion (ACDF)** for 1-2 levels anterior compression; (b) anterior cervical corpectomy + fusion for retrovertebral pathology; (c) **posterior laminectomy + fusion** for multilevel (≥ 3) with preserved lordosis; (d) **laminoplasty** for multilevel with preserved lordosis, motion-preserving alternative to laminectomy + fusion; (4) avoid posterior approach if cervical kyphosis (won''t decompress); (5) goals: prevent progression, modest improvement (don''t promise return to normal); (6) post-op: collar, PT, gradual return; (7) mJOA score for severity (mild ≥ 15, moderate 12-14, severe < 12) — surgery indicated for moderate-severe; mild controversial — surgery vs structured monitoring

---

Cervical myelopathy: insidious. UMN signs (hyperreflexia, Hoffmann, Babinski, clonus), gait imbalance, hand clumsiness. AOSpine guidelines: surgery for moderate-severe CSM (mJOA < 15). Anterior (1-2 levels) vs posterior (≥ 3 levels with lordosis: laminoplasty/laminectomy + fusion). Kyphosis precludes posterior approach. Goal: prevent progression.', NULL,
  'hard', 'neurology', 'review',
  'orthopedics', 'clinical_decision', 'neurology', 'adult',
  'AOSpine CSM Guidelines 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 62 ปี ค่อย ๆ มีอาการเดินไม่มั่นคง 6 เดือน + ลำบากในการใช้มือ (ติดกระดุม เขียนแย่ลง) + ชาปลายมือทั้งสองข้าง ไม่มี neck pain ชัดเจน

PE: hyperreflexia BJ + KJ + AJ bilateral, positive Hoffmann''s sign bilateral, positive Babinski bilateral, wide-based unsteady gait, +Lhermitte sign with neck flexion, decreased pinprick distal hand bilateral

MRI C-spine: multilevel cervical spondylosis with severe canal stenosis C4-C5 + C5-C6 + C6-C7 with cord compression + T2 myelomalacia signal change'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 22 ปี กระโดดน้ำตื้น head-first โดน head ปวดคอ + ขยับแขน-ขาไม่ได้ทันที

V/S: BP 78/40, HR 50, RR 14
PE: motor — biceps weak 2/5, no triceps/wrist flexion/hand intrinsics; no LE movement; no perianal sensation; no voluntary anal contraction; no rectal tone — ASIA A C5 level; warm dry skin (neurogenic shock)

CT C-spine: C5 burst fracture + retropulsion fragment + 60% canal compromise
MRI C-spine: spinal cord contusion C5 level + T2 hyperintensity, no transection seen', '[{"label":"A","text":"High-dose methylprednisolone NASCIS protocol mandatory"},{"label":"B","text":"Acute Cervical Spinal Cord Injury C5 ASIA A + Neurogenic Shock + Spinal Shock"},{"label":"C","text":"Conservative cervical collar 12 weeks no surgery"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Bedrest only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Cervical Spinal Cord Injury C5 ASIA A + Neurogenic Shock + Spinal Shock: (1) **ATLS** + airway protection (C5 level — phrenic preserved but high cervical can lose diaphragm) + early intubation if signs respiratory failure (FVC < 15 mL/kg); (2) **neurogenic shock management** — IV fluids cautiously + vasopressors (norepinephrine) — MAP target 85-90 mmHg × 5-7 days (improves spinal cord perfusion + neurologic outcome per AANS/CNS guidelines); atropine for symptomatic bradycardia; (3) **immobilization** — rigid cervical collar + spine board (remove from board within 2 hours — pressure ulcer); (4) avoid hypotension + hypoxia (secondary injury); (5) **methylprednisolone NOT routinely recommended** anymore (NASCIS trials weak evidence + complications — AANS/CNS guidelines against); selective use within 8h is at clinician discretion; (6) **MRI + CT** — definitive characterization; (7) **early surgical decompression + stabilization** (within 24 hours when safe) — STASCIS trial → better neurologic recovery (2-grade improvement) with early surgery; (8) DVT prophylaxis (mechanical immediate, LMWH 24-72h after surgery); stress ulcer prophylaxis; bladder catheter; bowel program; PT/OT early; (9) acute SCI multidisciplinary team (rehab/SCI center transfer); (10) prognosis ASIA A complete — poor for ambulation

---

Acute SCI: ATLS + immobilization + MAP 85-90 (improves perfusion) + early decompression < 24h (STASCIS — improved recovery). Methylprednisolone no longer routine (controversial, AANS/CNS against). Neurogenic shock (hypotension + bradycardia from sympathetic loss) — fluids + vasopressors + atropine. Multidisciplinary team. ASIA A — poor prognosis recovery.', NULL,
  'hard', 'neurology', 'review',
  'orthopedics', 'clinical_decision', 'neurology', 'adult',
  'AANS/CNS SCI Guidelines; STASCIS Trial PLoS ONE 2012', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 22 ปี กระโดดน้ำตื้น head-first โดน head ปวดคอ + ขยับแขน-ขาไม่ได้ทันที

V/S: BP 78/40, HR 50, RR 14
PE: motor — biceps weak 2/5, no triceps/wrist flexion/hand intrinsics; no LE movement; no perianal sensation; no voluntary anal contraction; no rectal tone — ASIA A C5 level; warm dry skin (neurogenic shock)

CT C-spine: C5 burst fracture + retropulsion fragment + 60% canal compromise
MRI C-spine: spinal cord contusion C5 level + T2 hyperintensity, no transection seen'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 76 ปี postmenopause ก้มเก็บของแล้วปวดหลังกลางอย่างรุนแรง 2 สัปดาห์ ปวดมากขึ้นเมื่อขยับ + นั่ง ไม่ปวดร้าวลงขา ไม่มี neurologic deficit

PE: tender T12 spinous process + paraspinal, kyphosis เพิ่มขึ้น, normal motor + sensory + reflexes, no saddle anesthesia

X-ray spine: wedge compression fracture T12 with anterior height loss 30%, no retropulsion, no posterior wall involvement
MRI: bone marrow edema T12 (acute fracture vs subacute), no malignancy features', '[{"label":"A","text":"Emergent fusion same day"},{"label":"B","text":"Acute Osteoporotic Vertebral Compression Fracture (T12) Without Neurologic Compromise"},{"label":"C","text":"Long-term opioid only"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Bedrest 6 weeks"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Osteoporotic Vertebral Compression Fracture (T12) Without Neurologic Compromise: (1) **conservative first-line 4-8 weeks** — most heal spontaneously: pain control (acetaminophen + scheduled, NSAIDs short course caution elderly, calcitonin nasal spray for early analgesia), bracing (TLSO) for comfort + early mobilization, PT for posture + back extensor strengthening (after pain controlled); (2) avoid bedrest (deconditioning); (3) **vertebroplasty/kyphoplasty controversial** — recent RCTs (VERTOS IV, INVEST, VAPOUR mixed) — guidelines (AAOS, ACR) suggest selective use: persistent severe pain failing conservative > 4-6 weeks, painful subacute fracture with bone marrow edema on MRI; not for asymptomatic, healed, or chronic painful fractures; (4) **always treat osteoporosis** (secondary fracture prevention): DEXA, **calcium 1200 mg + vit D 800-1000 IU**, bisphosphonate (alendronate, zoledronate IV), or denosumab, or anabolic (teriparatide, romosozumab) for severe; (5) screen secondary causes (multiple myeloma — SPEP, mets); (6) fall prevention; (7) rule out malignancy: history, MRI features (epidural mass, pedicle destruction, soft tissue), inflammatory markers; (8) multidisciplinary geriatric care

---

Osteoporotic VCF: very common in elderly. Most heal conservatively (4-8 weeks) — analgesics + bracing + early mobilization. Vertebroplasty/kyphoplasty controversial — selective for persistent pain failing conservative + acute MRI edema. ALWAYS treat osteoporosis (bisphosphonate, anabolics) + screen malignancy. Fall prevention. Multidisciplinary.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAOS; NOF/Bone Health Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'หญิงไทยอายุ 76 ปี postmenopause ก้มเก็บของแล้วปวดหลังกลางอย่างรุนแรง 2 สัปดาห์ ปวดมากขึ้นเมื่อขยับ + นั่ง ไม่ปวดร้าวลงขา ไม่มี neurologic deficit

PE: tender T12 spinous process + paraspinal, kyphosis เพิ่มขึ้น, normal motor + sensory + reflexes, no saddle anesthesia

X-ray spine: wedge compression fracture T12 with anterior height loss 30%, no retropulsion, no posterior wall involvement
MRI: bone marrow edema T12 (acute fracture vs subacute), no malignancy features'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 35 ปี seatbelt-wearing passenger รถยนต์ชน หลังหัวซน head-on ปวดหลังกลาง + bruise belt-mark across abdomen + lap

V/S: BP 110/72, HR 105, abdomen mildly tender
PE: midline back tenderness L2, no neurologic deficit, palpable gap posterior elements L2, ecchymosis abdomen seatbelt distribution

CT spine: transverse fracture through L2 vertebral body + pedicles + posterior elements (flexion-distraction Chance fracture)
CT abdomen: small bowel mesenteric injury + free fluid — concurrent hollow viscus injury

MRI: posterior ligamentous complex disruption', '[{"label":"A","text":"TLSO brace only without imaging abdomen"},{"label":"B","text":"Lumbar Chance Fracture (Flexion-Distraction Injury) + Concurrent Intra-abdominal Injury"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Conservative bedrest 12 weeks"},{"label":"E","text":"Emergent cervical fusion"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Lumbar Chance Fracture (Flexion-Distraction Injury) + Concurrent Intra-abdominal Injury: (1) **screen abdominal injury essential** — 50% of Chance fractures have hollow viscus injury (small bowel, mesentery, pancreas) — general surgery consult, CT abdomen with contrast, serial exam; (2) **unstable injury** (3-column disruption ferentially per Denis — or AO Spine type B distraction) — operative stabilization indicated; (3) **posterior instrumented fusion + reduction** (pedicle screw + rod construct typically 1-2 levels above + below) — restore lordosis + alignment; (4) **bony Chance** (through bone only — Smith fracture) may heal with bracing (TLSO/CASH brace 12 weeks) — selective; **ligamentous Chance** does not heal → always operative; (5) MRI essential to assess posterior ligamentous complex (PLC); (6) thoracolumbar injury classification (TLICS) score guides — Chance scores 4-6+ → surgery; (7) DVT prophylaxis; (8) post-op early mobilization in TLSO; (9) screen aortic injury upper thoracic; pancreatic with elevated lipase

---

Chance fracture: flexion-distraction (seatbelt). 3-column disruption typically. ALWAYS screen abdominal injury (50% hollow viscus). Ligamentous → operative (does not heal). Bony Chance — bracing selective. Posterior instrumented fusion. TLICS score guides. PLC assessed by MRI.', NULL,
  'hard', 'trauma', 'review',
  'orthopedics', 'clinical_decision', 'trauma', 'adult',
  'AO Spine; TLICS Vaccaro', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 35 ปี seatbelt-wearing passenger รถยนต์ชน หลังหัวซน head-on ปวดหลังกลาง + bruise belt-mark across abdomen + lap

V/S: BP 110/72, HR 105, abdomen mildly tender
PE: midline back tenderness L2, no neurologic deficit, palpable gap posterior elements L2, ecchymosis abdomen seatbelt distribution

CT spine: transverse fracture through L2 vertebral body + pedicles + posterior elements (flexion-distraction Chance fracture)
CT abdomen: small bowel mesenteric injury + free fluid — concurrent hollow viscus injury

MRI: posterior ligamentous complex disruption'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 24 ปี กระโดดน้ำตื้น ปวดคอ + แขน-ขาทั้ง 4 อ่อนแรง partial

PE: motor C5 grade 3/5, C6 2/5, C7 2/5, C8/T1 1/5, lower extremity 2/5; sacral sparing — perianal sensation + voluntary anal contraction preserved — ASIA C; sensation diminished below C5

CT C-spine: C5 burst fracture + 50% retropulsion + posterior element fractures + facet subluxation
MRI: cord compression + edema C5 level, no transection', '[{"label":"A","text":"Conservative cervical collar 12 weeks"},{"label":"B","text":"Subaxial Cervical Burst Fracture C5 with Incomplete SCI (ASIA C — sacral sparing)"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Bedrest indefinitely"},{"label":"E","text":"Methylprednisolone NASCIS only no surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Subaxial Cervical Burst Fracture C5 with Incomplete SCI (ASIA C — sacral sparing): (1) **ATLS + cervical immobilization** + MAP 85-90 × 5-7 days (cord perfusion); (2) **early surgical decompression + stabilization < 24 hours** (STASCIS — improved recovery especially incomplete injuries); (3) **anterior cervical corpectomy + reconstruction + plate** typically (removes retropulsed fragment + reconstructs anterior column); ± posterior instrumentation for additional stability if 3-column instability, posterior element fractures, facet dislocation, severe kyphosis ("360° approach"); (4) closed reduction with traction (Gardner-Wells tongs, Crutchfield) considered for facet dislocation BEFORE MRI in awake cooperative patient with neurologic exam; controversial — many institutions get MRI first to rule out disc herniation; (5) SLIC score (subaxial cervical injury classification) guides surgery (score ≥ 5); (6) **avoid steroids routinely**; (7) rehab + SCI center transfer; sacral sparing favorable for some recovery; (8) DVT prophylaxis; (9) screen vertebral artery injury (CTA — present in 30% cervical fractures, especially facet/foramen transversarium)

---

Subaxial cervical burst + incomplete SCI: ATLS + immobilization + early decompression < 24h. Anterior corpectomy + reconstruction typical; combined 360° for instability. MAP 85-90 cord perfusion. SLIC score guides. Sacral sparing = incomplete injury = better prognosis. Vertebral artery injury screen with CTA. Steroids no longer routine.', NULL,
  'hard', 'neurology', 'review',
  'orthopedics', 'clinical_decision', 'neurology', 'adult',
  'AANS/CNS; SLIC Score', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 24 ปี กระโดดน้ำตื้น ปวดคอ + แขน-ขาทั้ง 4 อ่อนแรง partial

PE: motor C5 grade 3/5, C6 2/5, C7 2/5, C8/T1 1/5, lower extremity 2/5; sacral sparing — perianal sensation + voluntary anal contraction preserved — ASIA C; sensation diminished below C5

CT C-spine: C5 burst fracture + 50% retropulsion + posterior element fractures + facet subluxation
MRI: cord compression + edema C5 level, no transection'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 28 ปี ตกจากที่สูง 5 เมตร ปวดหลัง + ขา 2 ข้าง weakness บางส่วน

PE: midline tenderness L1, motor L2 4/5, L3 4/5, L4 4/5, L5 3/5 (incomplete neurologic injury), preserved sacral sensation + voluntary anal contraction, no saddle anesthesia

CT spine: L1 burst fracture with 50% retropulsion + 50% canal compromise + 30% vertebral body height loss + 20° kyphosis
MRI L-spine: cord/conus compression + edema, posterior ligamentous complex (PLC) — disrupted (high T2 signal)', '[{"label":"A","text":"Conservative bedrest 12 weeks only"},{"label":"B","text":"Thoracolumbar Burst Fracture with Incomplete Neurologic Injury + PLC Disruption — TLICS High Score → Surgical"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Cervical fusion same day"},{"label":"E","text":"Steroid injection"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Thoracolumbar Burst Fracture with Incomplete Neurologic Injury + PLC Disruption — TLICS High Score → Surgical: (1) **TLICS score**: burst (2) + incomplete neuro (3) + PLC disruption (3) = 8 → surgical; (2) **AO Spine TL classification**: A4 (complete burst) + neurology + PLC = surgery; (3) **posterior instrumented fusion + decompression** typical approach (pedicle screws 1-2 levels above + below, with indirect reduction by ligamentotaxis); (4) anterior approach (corpectomy + cage + plate) for severe anterior column comminution + retropulsion not addressable posteriorly; (5) combined approach for severe injury; (6) post-op TLSO 8-12 weeks selective; (7) **stable burst** (no PLC, no neurologic) — controversial — non-operative bracing (TLSO 8-12 weeks) acceptable per multiple RCTs (Wood, Bailey); (8) DVT prophylaxis; (9) rehabilitation; (10) bowel/bladder monitoring (conus medullaris — micturition concern); (11) urology consult; (12) screen associated injuries (calcaneus 10%, contralateral fractures, head/abdomen)

---

Thoracolumbar burst: TLICS score guides (≥ 5 surgical). Burst + neurology + PLC disruption → surgery. Posterior instrumented fusion typical; anterior for severe anterior column. Stable burst without neuro/PLC → TLSO acceptable. Screen calcaneal + associated injuries. Conus injury → bowel/bladder concern.', NULL,
  'medium', 'trauma', 'review',
  'orthopedics', 'clinical_decision', 'trauma', 'adult',
  'Vaccaro TLICS; AO Spine Classification', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 28 ปี ตกจากที่สูง 5 เมตร ปวดหลัง + ขา 2 ข้าง weakness บางส่วน

PE: midline tenderness L1, motor L2 4/5, L3 4/5, L4 4/5, L5 3/5 (incomplete neurologic injury), preserved sacral sensation + voluntary anal contraction, no saddle anesthesia

CT spine: L1 burst fracture with 50% retropulsion + 50% canal compromise + 30% vertebral body height loss + 20° kyphosis
MRI L-spine: cord/conus compression + edema, posterior ligamentous complex (PLC) — disrupted (high T2 signal)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 17 ปี นักกีฬายิมนาสติก ปวดหลังเรื้อรัง 6 เดือน ปวดมากขึ้นเมื่อ extension + ปวดร้าวลงขาทั้ง 2 ข้าง

PE: palpable step-off L5-S1 spinous process, hyperlordosis, hamstring tightness, no motor deficit, normal reflexes

X-ray L-spine lateral + standing: pars defect L5 + L5-S1 forward slip 35% (Meyerding II — "Scotty dog with collar" — pars defect at neck)
MRI: L5 pars defect bilateral + L5-S1 disc degeneration mild, no significant root compression', '[{"label":"A","text":"Immediate fusion all patients"},{"label":"B","text":"Adolescent Isthmic Spondylolisthesis L5-S1 Meyerding II (25-50% slip) — Pars Defect from Repetitive Hyperextension"},{"label":"C","text":"Discharge no treatment"},{"label":"D","text":"Long-term opioid"},{"label":"E","text":"Bedrest 6 months"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adolescent Isthmic Spondylolisthesis L5-S1 Meyerding II (25-50% slip) — Pars Defect from Repetitive Hyperextension: (1) **non-operative trial 6-12 weeks first** ส่วนใหญ่ — most cases respond: activity modification (avoid hyperextension sports temporarily — gymnastics, diving, football lineman), PT — core stabilization + hamstring flexibility + Williams flexion exercises (avoid extension), NSAIDs, TLSO bracing controversial; (2) **stress reaction (early — bone marrow edema on MRI/SPECT)** treated aggressively — bracing 3-6 months + activity restriction may heal pars; chronic established defect → no healing expected; (3) **surgery indicated**: failure of 6-12 months conservative + persistent significant pain + progression of slip + neurologic deficit + significant slip > 50% (high-grade Meyerding III-V) + slip progression; (4) options: (a) **pars repair** (Buck''s screw, Scott wiring, pedicle screw + hook) for young patient + isolated pars defect + no disc degeneration + low slip; (b) **L5-S1 fusion** (instrumented PLIF/TLIF or in situ) for higher-grade or chronic; reduction of high-grade controversial (L5 nerve root injury risk); (5) avoid contact sports until healed/recovered

---

Isthmic spondylolisthesis: pars defect from repetitive hyperextension (gymnasts, divers, football). Adolescent — most respond conservative (PT, activity modification, bracing). Pars repair for young + isolated defect. L5-S1 fusion for high-grade or failed conservative. Reduction of high-grade controversial (L5 root injury).', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'peds',
  'NASS Spondylolisthesis Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 17 ปี นักกีฬายิมนาสติก ปวดหลังเรื้อรัง 6 เดือน ปวดมากขึ้นเมื่อ extension + ปวดร้าวลงขาทั้ง 2 ข้าง

PE: palpable step-off L5-S1 spinous process, hyperlordosis, hamstring tightness, no motor deficit, normal reflexes

X-ray L-spine lateral + standing: pars defect L5 + L5-S1 forward slip 35% (Meyerding II — "Scotty dog with collar" — pars defect at neck)
MRI: L5 pars defect bilateral + L5-S1 disc degeneration mild, no significant root compression'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 55 ปี IV drug user ไข้ + ปวดหลังกลาง 5 วัน + วันนี้เริ่มอ่อนแรงขาทั้ง 2 ข้าง + ปัสสาวะลำบาก

V/S: BP 110/70, HR 110, Temp 39.0°C
PE: midline tenderness T8-T9 percussion, motor LE 3/5 bilateral, hyperreflexia LE, +Babinski, decreased perianal sensation

Lab: WBC 18,500 (PMN 88%), CRP 280, ESR 110, blood culture × 2 — pending
MRI T-spine + Gd: epidural abscess T8-T9 + cord compression + osteomyelitis vertebral body + adjacent discitis', '[{"label":"A","text":"Oral antibiotics outpatient"},{"label":"B","text":"Spinal Epidural Abscess + Vertebral Osteomyelitis with Cord Compression — Surgical Emergency"},{"label":"C","text":"Bedrest no antibiotics"},{"label":"D","text":"Discharge with NSAIDs"},{"label":"E","text":"Steroid injection epidural"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Spinal Epidural Abscess + Vertebral Osteomyelitis with Cord Compression — Surgical Emergency: (1) **emergent surgical decompression** (laminectomy + abscess drainage ± instrumented fusion if instability) — especially with neurologic deficit: better neurologic outcomes with early surgery + drainage vs medical alone; (2) **empirical IV broad-spectrum antibiotics** after blood culture + intra-op culture obtained: vancomycin (MRSA in IV drug user) + ceftriaxone/cefepime (gram-negative) — tailor to culture; S. aureus most common pathogen; (3) IV antibiotic duration **6-8 weeks minimum** (extending to 3 months in some); (4) blood culture × 2-3 before antibiotic; CT-guided biopsy/aspiration if no surgery; (5) screen sepsis source + endocarditis (echocardiogram — S. aureus bacteremia mandates), other foci; (6) supportive ICU care, hemodynamic; (7) ID consult; (8) consider HIV/HCV testing IV drug user; (9) addiction medicine; (10) non-operative selective: no neurologic deficit, small abscess without cord compression, multiple medical comorbidities + good response to antibiotic — close monitoring + repeat MRI; (11) complications: residual neurologic deficit, recurrence, sepsis, death (5-20%)

---

Spinal epidural abscess: emergency. Triad — fever, back pain, neurologic deficit. Risk factors: IV drugs, DM, immunocompromise, recent procedure. MRI + Gd diagnostic. Emergent decompression + drainage for neurologic compromise + IV antibiotics 6-8 weeks. S. aureus most common. Screen endocarditis. Mortality 5-20%.', NULL,
  'hard', 'neurology', 'review',
  'orthopedics', 'clinical_decision', 'neurology', 'adult',
  'IDSA Vertebral Osteomyelitis 2015', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 55 ปี IV drug user ไข้ + ปวดหลังกลาง 5 วัน + วันนี้เริ่มอ่อนแรงขาทั้ง 2 ข้าง + ปัสสาวะลำบาก

V/S: BP 110/70, HR 110, Temp 39.0°C
PE: midline tenderness T8-T9 percussion, motor LE 3/5 bilateral, hyperreflexia LE, +Babinski, decreased perianal sensation

Lab: WBC 18,500 (PMN 88%), CRP 280, ESR 110, blood culture × 2 — pending
MRI T-spine + Gd: epidural abscess T8-T9 + cord compression + osteomyelitis vertebral body + adjacent discitis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 68 ปี ปวดหลัง + ขาขวา 1 ปี ปวดมากขึ้นเรื่อย ๆ + รู้สึกเอียงตัว + เดินไกลไม่ได้ + ไม่สามารถยืนตรงได้

PE: lumbar coronal imbalance (truncal shift), hyperkyphosis, sagittal imbalance (positive sagittal vertical axis), right L4 radiculopathy (weakness EHL 4/5)

X-ray standing scoliosis: degenerative lumbar scoliosis Cobb 35° (L1-L4), sagittal vertical axis +9 cm (normal < 5 cm), pelvic incidence-lumbar lordosis mismatch (PI-LL) 25° (normal < 10°)
MRI: L3-L4, L4-L5 stenosis + lateral recess compression, multilevel disc degeneration', '[{"label":"A","text":"Emergent fusion same day no workup"},{"label":"B","text":"Symptomatic Adult Degenerative Scoliosis with Sagittal Imbalance + Radiculopathy"},{"label":"C","text":"Discharge no treatment"},{"label":"D","text":"Bedrest 6 months"},{"label":"E","text":"Long-term opioid"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Symptomatic Adult Degenerative Scoliosis with Sagittal Imbalance + Radiculopathy: (1) **conservative trial first**: PT (core strengthening, postural training, aerobic), NSAIDs, weight management, bracing limited (selective); ESI for radicular pain selective; (2) **counseling realistic expectations** — back pain may not fully resolve even with surgery; (3) **surgical indications**: failure of 6-12 months conservative + significant functional limitation + neurologic deficit + progressive deformity + intractable pain; (4) **goals**: decompression of symptomatic levels + correction of sagittal + coronal balance + stable fusion; (5) **complex surgery — long instrumented posterior fusion** ± osteotomies (Smith-Petersen osteotomy, pedicle subtraction osteotomy — PSO, vertebral column resection — VCR) ± interbody fusion (TLIF/LLIF/ALIF) to restore lumbar lordosis + correct PI-LL mismatch; (6) high complication rate (30-50% — wound, infection, hardware failure, PJK proximal junctional kyphosis, dural tear, neurologic, medical), high revision rate; (7) careful patient selection — comorbidity optimization (cardiac, DEXA → osteoporosis Rx, nutrition, smoking cessation); (8) restoration of sagittal balance (SVA < 5 cm, PI-LL < 10°, PT < 25°) most important predictor of outcome (Schwab/Lafage); (9) minimally invasive options selective

---

Adult degenerative scoliosis: conservative first. Surgery for failed conservative + functional limitation. Goals: decompression + sagittal/coronal balance + fusion. Long posterior fusion + osteotomies (PSO, VCR). Restoration of sagittal balance (SVA, PI-LL) critical predictor. High complication + revision rate — careful patient selection.', NULL,
  'hard', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'SRS Adult Spinal Deformity Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'หญิงไทยอายุ 68 ปี ปวดหลัง + ขาขวา 1 ปี ปวดมากขึ้นเรื่อย ๆ + รู้สึกเอียงตัว + เดินไกลไม่ได้ + ไม่สามารถยืนตรงได้

PE: lumbar coronal imbalance (truncal shift), hyperkyphosis, sagittal imbalance (positive sagittal vertical axis), right L4 radiculopathy (weakness EHL 4/5)

X-ray standing scoliosis: degenerative lumbar scoliosis Cobb 35° (L1-L4), sagittal vertical axis +9 cm (normal < 5 cm), pelvic incidence-lumbar lordosis mismatch (PI-LL) 25° (normal < 10°)
MRI: L3-L4, L4-L5 stenosis + lateral recess compression, multilevel disc degeneration'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 12 ปี mother สังเกตเห็นหลังคด ไม่ปวดหลัง ไม่มี neurologic symptoms ประจำเดือนยังไม่มา (Risser stage 1) Tanner stage III

PE: positive Adams forward bend test — right thoracic prominence (scoliometer 9°), shoulder asymmetry, normal motor/sensory, no café-au-lait, no midline cutaneous lesion

X-ray standing scoliosis: right thoracic curve Cobb 32° T6-T11, left lumbar 18° T11-L3, no neurologic asymmetry, no congenital anomaly, Risser 1, open triradiate cartilage', '[{"label":"A","text":"Observation only no intervention"},{"label":"B","text":"Adolescent Idiopathic Scoliosis (AIS) Right Thoracic Curve 32° + Skeletally Immature (Risser 1) — High Progression Risk"},{"label":"C","text":"Surgery immediately at 32°"},{"label":"D","text":"Long-term opioid"},{"label":"E","text":"Bedrest until maturity"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adolescent Idiopathic Scoliosis (AIS) Right Thoracic Curve 32° + Skeletally Immature (Risser 1) — High Progression Risk: (1) **bracing indicated** — Cobb 25-45° + skeletally immature (Risser 0-2, premenarchal/early): underarm thoracolumbosacral orthosis (TLSO — Boston brace, Wilmington, Charleston nighttime); (2) **brace 16-23 hours/day** — wear time correlates with success (BrAIST trial NEJM 2013 — bracing significantly reduces progression to surgical threshold from 48% → 28%); (3) PT exercise (Schroth method) adjunct; (4) follow up X-ray every 4-6 months until skeletal maturity (Risser 5 + 2 years post-menarchal); (5) **surgical posterior spinal fusion** indicated when: Cobb > 45-50° + skeletally immature, OR > 50° at skeletal maturity (continues to progress in adulthood 1°/year) — pedicle screw construct + selective fusion based on Lenke classification, restore alignment + balance; (6) screen secondary causes: full neurologic exam, MRI if atypical (left thoracic, rapid progression, neurologic findings, pain — all atypical for AIS) — congenital, neuromuscular, syrinx, Chiari; (7) genetic counseling — familial component but no clear inheritance; (8) reassurance — AIS does not generally affect pulmonary function unless curve > 80-90° thoracic

---

AIS: most common scoliosis. Bracing for 25-45° skeletally immature (BrAIST trial — effective, 16-23h/day). Posterior spinal fusion for > 45-50° immature or > 50° at maturity. Screen atypical features (left thoracic, neurologic, pain) → MRI. Skeletal maturity tracked by Risser sign + menarche. Lenke classification guides fusion levels.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'peds',
  'SRS; BrAIST Trial NEJM 2013', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'เด็กหญิงอายุ 12 ปี mother สังเกตเห็นหลังคด ไม่ปวดหลัง ไม่มี neurologic symptoms ประจำเดือนยังไม่มา (Risser stage 1) Tanner stage III

PE: positive Adams forward bend test — right thoracic prominence (scoliometer 9°), shoulder asymmetry, normal motor/sensory, no café-au-lait, no midline cutaneous lesion

X-ray standing scoliosis: right thoracic curve Cobb 32° T6-T11, left lumbar 18° T11-L3, no neurologic asymmetry, no congenital anomaly, Risser 1, open triradiate cartilage'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 28 ปี รถมอเตอร์ไซค์ชนตกศีรษะกระแทกพื้น ปวดคอ + แขนซ้ายอ่อนแรง + ขา 2 ข้างอ่อนแรง partial

PE: head tilt + rotation away from side of dislocation; motor — left C6 root 3/5, LE 4/5 bilateral, +sacral sparing

CT C-spine: unilateral C5-C6 facet dislocation (left) — "perched facet" with anterior subluxation 25% of vertebral body width
MRI C-spine: cord compression + edema C5-C6, no significant disc herniation seen anteriorly', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Acute Cervical Unilateral Facet Dislocation + Incomplete SCI"},{"label":"C","text":"Conservative cervical collar 12 weeks without imaging"},{"label":"D","text":"Methylprednisolone NASCIS only"},{"label":"E","text":"Lumbar laminectomy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Cervical Unilateral Facet Dislocation + Incomplete SCI: (1) **ATLS + cervical immobilization** + MAP 85-90 × 5-7 days; (2) **MRI first** to rule out concomitant disc herniation (some institutions reduce first in awake cooperative patient with serial neurologic exam — controversial; modern protocol typically MRI first if available promptly); (3) **closed reduction with cervical traction** (Gardner-Wells tongs, sequential weight addition with neuro check) in awake cooperative patient with monitoring — if no traumatic disc herniation; (4) **open reduction + posterior cervical fusion** if closed fails, or if traumatic disc herniation present (anterior discectomy + fusion first then posterior); (5) **circumferential 360° fusion** for highly unstable injury or bilateral facet dislocation; (6) SLIC score (≥ 5 = surgery — unilateral dislocation typically scores high); (7) vertebral artery injury screen with CTA (high incidence in facet dislocation through foramen transversarium); (8) early surgical decompression < 24 hours for SCI (STASCIS); (9) avoid steroids routinely; (10) DVT prophylaxis; (11) rehab

---

Cervical facet dislocation: ATLS + immobilization. MRI before reduction if available (disc herniation 50% bilateral, 30% unilateral). Closed reduction with traction in awake patient possible. Open reduction + posterior fusion + ADCF if disc. Vertebral artery injury common → CTA. Early decompression < 24h for SCI.', NULL,
  'hard', 'trauma', 'review',
  'orthopedics', 'clinical_decision', 'trauma', 'adult',
  'AANS/CNS Cervical Spine Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 28 ปี รถมอเตอร์ไซค์ชนตกศีรษะกระแทกพื้น ปวดคอ + แขนซ้ายอ่อนแรง + ขา 2 ข้างอ่อนแรง partial

PE: head tilt + rotation away from side of dislocation; motor — left C6 root 3/5, LE 4/5 bilateral, +sacral sparing

CT C-spine: unilateral C5-C6 facet dislocation (left) — "perched facet" with anterior subluxation 25% of vertebral body width
MRI C-spine: cord compression + edema C5-C6, no significant disc herniation seen anteriorly'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 25 ปี เล่นฟุตบอลถูกบิดเข่าซ้าย ได้ยิน pop + เข่าบวม immediate (within 4 hours) ขยับเข่าได้แต่รู้สึก unstable

PE: large effusion + decreased ROM, positive Lachman test (most sensitive ACL), positive anterior drawer + pivot shift (under anesthesia), no varus/valgus instability, intact PCL, distal NV intact

MRI knee: complete ACL tear midsubstance + bone bruise lateral femoral condyle + posterolateral tibial plateau (kissing contusion pattern of ACL), medial meniscus tear posterior horn flap — Type IIIA, lateral meniscus intact, PCL intact', '[{"label":"A","text":"Cast extension 12 weeks no surgery"},{"label":"B","text":"ACL reconstruction"},{"label":"C","text":"Discharge no treatment"},{"label":"D","text":"Knee arthrodesis"},{"label":"E","text":"Total knee arthroplasty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Complete ACL Tear + Medial Meniscus Tear in Young Active Athlete: (1) initial management: RICE + brace + crutches WBAT + early ROM + quadriceps activation; (2) prehabilitation ("prehab") — restore ROM + reduce effusion + quadriceps strength before surgery (better outcomes); (3) **ACL reconstruction** indicated: young active patient + functional instability + desires return to pivoting sports; (4) graft choice: **bone-patellar tendon-bone (BPTB) autograft** — classic, robust, faster return to sport in some studies; **hamstring autograft** (semitendinosus + gracilis) — less anterior knee pain, donor site morbidity; **quadriceps tendon autograft** — increasingly popular, less morbidity; allograft — less ideal in young due to higher re-rupture rate; (5) **timing**: typically delay until effusion resolves + ROM restored + quadriceps activation (often 3-6 weeks post-injury) — STABILITY trial supports lateral extra-articular tenodesis (LET) augmentation in young athletes to reduce re-rupture; (6) concomitant meniscal repair preferred over meniscectomy when possible (peripheral 1/3, vertical, longitudinal, < 4 weeks old); (7) postop rehab 6-9 months progressive — RTS criteria (LSI > 90%, hop tests, psychological readiness — ACL-RSI scale); (8) ACL prevention programs (FIFA 11+) for return; (9) **non-operative** acceptable for: low-demand sedentary, copers (~ 30% functional without ACL), older patients without instability symptoms

---

Acute ACL tear: hemarthrosis within hours. Lachman most sensitive. MRI + bone bruise + meniscus assessment. ACL reconstruction for young active. Graft choice (BPTB, hamstring, quadriceps autograft). Concomitant meniscal repair preferred. LET augmentation reduces re-rupture (STABILITY trial). 6-9 month rehab. Non-op for low-demand copers.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAOS ACL CPG; STABILITY Trial', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 25 ปี เล่นฟุตบอลถูกบิดเข่าซ้าย ได้ยิน pop + เข่าบวม immediate (within 4 hours) ขยับเข่าได้แต่รู้สึก unstable

PE: large effusion + decreased ROM, positive Lachman test (most sensitive ACL), positive anterior drawer + pivot shift (under anesthesia), no varus/valgus instability, intact PCL, distal NV intact

MRI knee: complete ACL tear midsubstance + bone bruise lateral femoral condyle + posterolateral tibial plateau (kissing contusion pattern of ACL), medial meniscus tear posterior horn flap — Type IIIA, lateral meniscus intact, PCL intact'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 22 ปี นักฟุตบอล บิดเข่าขวา 3 วันก่อน ปวด + เข่าล็อค เหยียดเข่าไม่ได้ (-10° extension block) + เดินกระเผลก

PE: positive McMurray + Thessaly + Apley grind, joint line tenderness medial, fixed flexion deformity 10° (mechanical block), no significant ligamentous instability

MRI knee: bucket-handle tear medial meniscus posterior horn extending into mid-segment with displaced fragment in intercondylar notch ("double PCL sign" — bucket handle fragment appearing as second PCL), normal ACL/PCL/collaterals', '[{"label":"A","text":"Discharge home no surgery"},{"label":"B","text":"Bucket-Handle Meniscal Tear with Mechanical Locking (Young Athlete) — Reparable Tear"},{"label":"C","text":"Long-term opioid"},{"label":"D","text":"Total knee arthroplasty"},{"label":"E","text":"Cast in flexion 12 weeks"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bucket-Handle Meniscal Tear with Mechanical Locking (Young Athlete) — Reparable Tear: (1) **urgent arthroscopic meniscal repair** indicated เพราะ: young patient + reparable tear (peripheral red-red or red-white zone, vertical longitudinal, < 4 weeks old, > 1 cm length) + meniscus preservation prevents PTOA; (2) **meniscal repair technique** (inside-out, outside-in, all-inside devices — modern FasT-Fix, Smith & Nephew TRUE-SPAN) — depending on tear location; (3) protected weight-bearing 4-6 weeks + ROM restriction (0-90° initially); (4) avoid deep flexion + pivoting × 4-6 months; (5) return to sport 4-6 months; (6) **meniscectomy** (partial or subtotal) only for unsalvageable tears (white-white zone, complex/degenerative, irreparable) — recognized as risk for early OA; minimize bone resection; (7) augmentation: fibrin clot, PRP, marrow venting to enhance healing for poorly vascularized; (8) MRI follow up if symptoms recur; (9) **always check ACL** — frequently associated (40-50%) — bucket handle medial often with ACL tear, may need concomitant ACL reconstruction (concomitant repair + ACLR superior outcomes); (10) chronic locked knee — irreducible, requires surgery

---

Bucket-handle meniscal tear: classic mechanical locking. "Double PCL sign" on MRI. Urgent arthroscopic repair (young, reparable). Meniscectomy = early OA → preserve when possible. Augment vascular zone tears. Always assess ACL (often concomitant). Modern all-inside devices. RTS 4-6 months.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAOS; ESSKA Meniscus Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 22 ปี นักฟุตบอล บิดเข่าขวา 3 วันก่อน ปวด + เข่าล็อค เหยียดเข่าไม่ได้ (-10° extension block) + เดินกระเผลก

PE: positive McMurray + Thessaly + Apley grind, joint line tenderness medial, fixed flexion deformity 10° (mechanical block), no significant ligamentous instability

MRI knee: bucket-handle tear medial meniscus posterior horn extending into mid-segment with displaced fragment in intercondylar notch ("double PCL sign" — bucket handle fragment appearing as second PCL), normal ACL/PCL/collaterals'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 32 ปี รถมอเตอร์ไซค์ชน dashboard กระแทกหน้าแข้ง ปวดเข่าซ้าย + บวมเล็กน้อย

PE: positive posterior drawer (most sensitive PCL), positive posterior sag sign, normal Lachman, no varus/valgus instability, mild effusion, NV intact

MRI knee: complete isolated PCL tear (substance), no ACL or collateral injury, no posterolateral corner injury, no meniscal tear, no posterior tibial bone bruise (suggestive)', '[{"label":"A","text":"Emergent surgery same day"},{"label":"B","text":"Isolated Complete PCL Tear (Grade III)"},{"label":"C","text":"Cast in flexion 12 weeks"},{"label":"D","text":"Long-term opioid"},{"label":"E","text":"Total knee arthroplasty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Isolated Complete PCL Tear (Grade III): (1) **non-operative management first-line** for isolated PCL tears เพราะ: better natural history vs ACL, PCL has better intrinsic healing, most patients functional without surgery; (2) **PCL-specific bracing** in extension (jack brace) × 4-6 weeks (resists posterior tibial sag); (3) PT — emphasize **quadriceps strengthening** (quad acts as PCL agonist by preventing posterior tibial translation); avoid open-chain hamstring exercises (antagonist to PCL); (4) progressive return to activity 3-6 months; (5) **PCL reconstruction** indicated for: combined ligamentous injury (most PCL injuries with combined are surgical), persistent symptomatic instability after 6 months conservative, displaced bony avulsion (fix the avulsion fragment); (6) **important to evaluate posterolateral corner (PLC)** in all PCL tears — combined PCL + PLC injury — PLC undertreated leads to PCL graft failure; (7) chronic isolated PCL may develop medial + patellofemoral compartment OA (altered biomechanics) → counsel; (8) reconstruction techniques: tibial inlay vs transtibial ("killer turn"), single vs double bundle, autograft/allograft

---

Isolated PCL tear: non-operative first-line (better natural history than ACL). Brace in extension + quadriceps strengthening. Surgery for combined injuries, displaced bony avulsion, failed conservative. ALWAYS evaluate PLC (PLC injury → PCL graft failure if untreated). Chronic PCL — medial + patellofemoral OA risk.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAOS; ISAKOS PCL Consensus', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 32 ปี รถมอเตอร์ไซค์ชน dashboard กระแทกหน้าแข้ง ปวดเข่าซ้าย + บวมเล็กน้อย

PE: positive posterior drawer (most sensitive PCL), positive posterior sag sign, normal Lachman, no varus/valgus instability, mild effusion, NV intact

MRI knee: complete isolated PCL tear (substance), no ACL or collateral injury, no posterolateral corner injury, no meniscal tear, no posterior tibial bone bruise (suggestive)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 26 ปี เล่นรักบี้ ถูกชนด้านนอกเข่าซ้าย ปวดด้านในเข่า

PE: tender medial joint line + over MCL origin femur, positive valgus stress at 30° flexion with 8 mm opening (vs intact 4 mm contralateral) + endpoint firm, no opening at full extension, normal Lachman, normal posterior drawer, no effusion

MRI knee: complete MCL tear (proximal/femoral attachment) — Grade III, no ACL/PCL/lateral injury, no meniscal tear', '[{"label":"A","text":"Emergent surgery same day"},{"label":"B","text":"Isolated Grade III MCL Tear"},{"label":"C","text":"Cast extension 12 weeks"},{"label":"D","text":"Total knee arthroplasty"},{"label":"E","text":"Long-term opioid"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Isolated Grade III MCL Tear: (1) **non-operative management gold standard** for isolated MCL — excellent healing potential (extra-articular ligament with good blood supply); (2) hinged knee brace (ROM brace) for 4-6 weeks — allows ROM but protects from valgus stress; full ROM permitted; (3) WBAT immediately; (4) PT — early ROM, progressive quadriceps + hamstring strengthening; (5) RTS 6-12 weeks (Grade III) when full ROM + no pain + valgus stability + strength symmetric; (6) **surgical repair/reconstruction** rarely indicated for isolated MCL — reserved for: (a) chronic symptomatic instability after 3-6 months conservative, (b) tibial-side avulsion (Stener-like lesion — pes anserinus interposition prevents healing), (c) combined ligament injury (ACL + MCL with persistent instability after ACL recon + conservative MCL), (d) bony avulsion; (7) always check **distal MCL tibial-side tear** — may not heal due to pes anserinus interposition + need repair; (8) chronic insufficiency may rarely require reconstruction (semitendinosus autograft, etc.); (9) early activity NOT detrimental

---

Isolated MCL tear: non-operative gold standard (excellent healing). Hinged brace 4-6 weeks + early ROM + WBAT. Surgery rare — reserved for tibial-side avulsion (pes interposition), combined ligament injury, chronic instability. Stener-like lesion (distal MCL) may not heal. Grade III complete tear — still heals well with conservative.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAOS; ISAKOS MCL', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 26 ปี เล่นรักบี้ ถูกชนด้านนอกเข่าซ้าย ปวดด้านในเข่า

PE: tender medial joint line + over MCL origin femur, positive valgus stress at 30° flexion with 8 mm opening (vs intact 4 mm contralateral) + endpoint firm, no opening at full extension, normal Lachman, normal posterior drawer, no effusion

MRI knee: complete MCL tear (proximal/femoral attachment) — Grade III, no ACL/PCL/lateral injury, no meniscal tear'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 30 ปี รถมอเตอร์ไซค์ชน knee twisting injury 3 สัปดาห์ ปวดด้านนอกเข่าขวา + รู้สึก unstable เมื่อเดิน + foot drop เริ่มมี

PE: positive dial test at 30° (10° increased external rotation tibia vs contralateral but symmetric at 90°), positive reverse pivot shift, varus thrust gait, foot drop right (peroneal nerve injury), positive posterolateral drawer

MRI knee: posterolateral corner (PLC) injury — popliteus + popliteofibular ligament + fibular collateral ligament (LCL) all torn, peroneal nerve edema, isolated PLC, intact ACL/PCL', '[{"label":"A","text":"Conservative bracing only"},{"label":"B","text":"Isolated Posterolateral Corner (PLC) Injury Grade III + Peroneal Nerve Injury — Surgical"},{"label":"C","text":"Total knee arthroplasty"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Cast in extension 12 weeks"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Isolated Posterolateral Corner (PLC) Injury Grade III + Peroneal Nerve Injury — Surgical: (1) **acute primary repair OR reconstruction within 2-3 weeks** preferred over delayed repair (LaPrade) — better outcomes with early intervention while tissue planes identifiable; chronic > 3 weeks → reconstruction; (2) **PLC reconstruction** using anatomic technique — LaPrade anatomic reconstruction (fibular collateral + popliteofibular + popliteus tendon) with semitendinosus/allograft (Achilles, anterior/posterior tibialis); (3) **peroneal nerve** — observe (most neuropraxia recover); neurolysis intraoperatively; if no recovery by 3-6 months, EMG, consider tendon transfer (posterior tibial to dorsiflex) or AFO; (4) **always assess for PCL injury** — combined PCL + PLC very common — undertreated PLC → PCL graft failure; (5) post-op rehab: brace 6 weeks, progressive WB, no isolated hamstring 4 months, RTS 9-12 months; (6) **non-operative** only for grade I-II isolated, no functional instability; (7) chronic untreated PLC → varus thrust gait, medial compartment OA, ACL graft failure; (8) physical exam — dial test + varus stress at 30° + reverse pivot shift sensitive

---

PLC injury: often missed → late instability + ACL graft failure. Acute repair/reconstruction (< 2-3 wk) > delayed. LaPrade anatomic reconstruction standard. Peroneal nerve injury common — observe most. Combined with PCL frequent — undertreated PLC = PCL graft failure. Dial test + varus + reverse pivot shift exam.', NULL,
  'hard', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'LaPrade PLC; AAOS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 30 ปี รถมอเตอร์ไซค์ชน knee twisting injury 3 สัปดาห์ ปวดด้านนอกเข่าขวา + รู้สึก unstable เมื่อเดิน + foot drop เริ่มมี

PE: positive dial test at 30° (10° increased external rotation tibia vs contralateral but symmetric at 90°), positive reverse pivot shift, varus thrust gait, foot drop right (peroneal nerve injury), positive posterolateral drawer

MRI knee: posterolateral corner (PLC) injury — popliteus + popliteofibular ligament + fibular collateral ligament (LCL) all torn, peroneal nerve edema, isolated PLC, intact ACL/PCL'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 15 ปี นักเต้น บิดเข่าซ้าย รู้สึก patella หลุดออก side แล้วเข้าเอง เข่าบวม + ปวด

PE: large effusion, tender medial patella + medial retinaculum (MPFL), positive apprehension test, J-sign on extension, generalized hyperlaxity (Beighton 7/9)

MRI knee: lateral patellar dislocation episode — MPFL tear (femoral attachment), bone bruise medial patella + lateral femoral condyle (kissing contusion), small osteochondral fragment from patella ("flake" sign), trochlear dysplasia (shallow trochlea), patella alta (Insall-Salvati 1.4)', '[{"label":"A","text":"Lateral release alone first surgery"},{"label":"B","text":"First-Time Lateral Patellar Dislocation in Adolescent + Osteochondral Fracture"},{"label":"C","text":"Total knee arthroplasty"},{"label":"D","text":"Cast extension 12 weeks"},{"label":"E","text":"Discharge no treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** First-Time Lateral Patellar Dislocation in Adolescent + Osteochondral Fracture: (1) **arthroscopy/arthrotomy + osteochondral fragment fixation or removal** if significant loose body (> 5 mm articular surface) — fragment fixation preferred when feasible (bioabsorbable nail, headless screw); (2) **MPFL reconstruction** considered first-time in young patient with: significant anatomic risk factors (trochlear dysplasia, patella alta, increased TT-TG distance > 20 mm, hyperlaxity, genu valgum, increased femoral anteversion); recurrent dislocator (≥ 2 episodes) — definitely; (3) **non-operative** for first-time without osteochondral fracture, without major risk factors: brace + PT (vastus medialis obliquus strengthening, hip abductor strengthening, taping) — recurrence 15-50%; (4) for recurrent dislocators + significant TT-TG > 20 mm → MPFL reconstruction + **tibial tubercle osteotomy** (medialization Fulkerson) ± **trochleoplasty** for severe dysplasia; (5) MPFL reconstruction graft (semitendinosus, gracilis, allograft); (6) avoid lateral release alone (proven ineffective without addressing pathology); (7) pediatric — preserve physis with reconstruction technique modification; (8) early ROM + PT post-op; (9) RTS 6-9 months

---

Patellar dislocation: lateral. MPFL primary restraint medially. First-time: conservative if no osteochondral fracture + few risk factors. MPFL reconstruction for recurrent or significant risk factors. Add TTO (medialization) if TT-TG > 20 mm. Trochleoplasty for severe dysplasia. Lateral release alone — ineffective.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'peds',
  'AAOS Patellar Instability', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'เด็กหญิงอายุ 15 ปี นักเต้น บิดเข่าซ้าย รู้สึก patella หลุดออก side แล้วเข้าเอง เข่าบวม + ปวด

PE: large effusion, tender medial patella + medial retinaculum (MPFL), positive apprehension test, J-sign on extension, generalized hyperlaxity (Beighton 7/9)

MRI knee: lateral patellar dislocation episode — MPFL tear (femoral attachment), bone bruise medial patella + lateral femoral condyle (kissing contusion), small osteochondral fragment from patella ("flake" sign), trochlear dysplasia (shallow trochlea), patella alta (Insall-Salvati 1.4)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 58 ปี laborer ปวดไหล่ขวา 6 เดือน ปวดมากตอนกลางคืน ยกแขนเหนือศีรษะลำบาก + อ่อนแรง 3 เดือนหลัง trauma เล็กน้อย

PE: positive Neer + Hawkins (impingement), positive empty can test + drop arm test (supraspinatus weakness 3/5), positive external rotation lag sign (infraspinatus), normal subscapularis (negative belly press)

MRI shoulder: full-thickness rotator cuff tear involving supraspinatus + anterior infraspinatus, retraction 3 cm to glenoid (Patte II), mild fatty infiltration Goutallier 2, no significant arthritis', '[{"label":"A","text":"Immediate rTSA for any tear"},{"label":"B","text":"Symptomatic Full-Thickness Rotator Cuff Tear in Active Middle-Aged Laborer"},{"label":"C","text":"Discharge no treatment"},{"label":"D","text":"Steroid injection monthly long-term"},{"label":"E","text":"Total shoulder arthroplasty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Symptomatic Full-Thickness Rotator Cuff Tear in Active Middle-Aged Laborer: (1) **PT + structured conservative first 3 months** — most patients improve symptoms even without anatomic healing: rotator cuff + scapular stabilizer exercises, posture, NSAIDs, subacromial corticosteroid injection (limited use — > 1 injection may damage cuff); (2) **arthroscopic rotator cuff repair** indicated: failure of conservative + symptomatic + young/active/laborer with reparable tear (< 4 cm, no advanced fatty infiltration Goutallier ≥ 3, no significant arthritis) + tear progression; (3) **acute traumatic tear** — earlier repair (within 3-4 months) better outcomes vs chronic; (4) **double-row vs single-row** — double-row more anatomic + biomechanical, may reduce re-tear especially for larger tears; (5) augmentation: biceps tenodesis if associated biceps pathology; PRP/scaffold limited evidence; (6) **massive irreparable tears** (> 5 cm, retraction to glenoid, Goutallier 3-4, > 65 ปี) options: arthroscopic debridement + biceps tenotomy/tenodesis, **superior capsular reconstruction (SCR)**, tendon transfers (latissimus dorsi, lower trapezius), **reverse total shoulder arthroplasty (rTSA)** for cuff tear arthropathy; (7) post-op: sling 4-6 weeks, no active ROM initially, progressive PT, return to laborer activity 6 months; (8) re-tear rate 20-40%; cuff repair improves pain even with re-tear

---

RC tear: conservative trial first (PT improves many without healing). Surgical repair for failed conservative + reparable + active patient. Acute traumatic — earlier repair better. Massive irreparable: SCR, tendon transfer, rTSA (cuff arthropathy). Goutallier fatty infiltration grade key prognosticator. Re-tear 20-40% but outcomes still improved.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAOS Rotator Cuff CPG; ASES', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 58 ปี laborer ปวดไหล่ขวา 6 เดือน ปวดมากตอนกลางคืน ยกแขนเหนือศีรษะลำบาก + อ่อนแรง 3 เดือนหลัง trauma เล็กน้อย

PE: positive Neer + Hawkins (impingement), positive empty can test + drop arm test (supraspinatus weakness 3/5), positive external rotation lag sign (infraspinatus), normal subscapularis (negative belly press)

MRI shoulder: full-thickness rotator cuff tear involving supraspinatus + anterior infraspinatus, retraction 3 cm to glenoid (Patte II), mild fatty infiltration Goutallier 2, no significant arthritis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 28 ปี นักเบสบอลพิทเชอร์ ปวดไหล่ลึก ๆ + ปวดเวลาขว้าง — pain in late cocking + early acceleration

PE: positive O''Brien (active compression test — pain with internal rotation + resisted forward flexion at 90°, relieved with external rotation), positive Speed test, decreased internal rotation (GIRD — glenohumeral internal rotation deficit 25°)

MR arthrogram: type II SLAP lesion (superior labrum from anterior to posterior — biceps anchor detachment), no rotator cuff tear, no Bankart, mild posterior labral fraying', '[{"label":"A","text":"Always SLAP repair regardless of age"},{"label":"B","text":"SLAP Tear Type II in Overhead Throwing Athlete"},{"label":"C","text":"Total shoulder arthroplasty"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Cast in adduction 6 weeks"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** SLAP Tear Type II in Overhead Throwing Athlete: (1) **conservative trial first 3-6 months** — PT essential: posterior capsular stretching (sleeper stretch, cross-body) for GIRD, scapular stabilization, dynamic stability, gradual return-to-throwing program; (2) NSAIDs, activity modification; (3) **surgical indications**: failure of comprehensive conservative + persistent symptoms + desire to return to overhead sport; (4) **surgical options controversial**: (a) **SLAP repair** (suture anchors to labrum) — traditional for type II in young athlete < 35-40 ปี — historic gold standard but high rate of stiffness, persistent pain, failure to return to elite throwing (especially baseball pitchers); (b) **biceps tenodesis** — increasingly preferred in older athletes (> 35-40 ปี) + lower demand patients + revision setting + concurrent biceps pathology — superior outcomes vs SLAP repair in many studies; (c) **biceps tenotomy** — older low-demand; (5) **return to elite pitching after SLAP repair only 50-60%** — counsel realistic expectations; (6) preventive — pitch count, mechanics, kinetic chain; (7) avoid SLAP repair > 40 ปี (better outcomes with tenodesis)

---

SLAP tear: overhead athletes. Conservative first (PT, GIRD correction). Surgery — SLAP repair vs biceps tenodesis. Repair traditional for young athlete; tenodesis increasingly preferred (better outcomes, especially > 35-40 ปี). RTS to elite pitching only 50-60% after repair — counsel. Tenotomy for elderly. O''Brien test sensitive.', NULL,
  'hard', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AOSSM SLAP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 28 ปี นักเบสบอลพิทเชอร์ ปวดไหล่ลึก ๆ + ปวดเวลาขว้าง — pain in late cocking + early acceleration

PE: positive O''Brien (active compression test — pain with internal rotation + resisted forward flexion at 90°, relieved with external rotation), positive Speed test, decreased internal rotation (GIRD — glenohumeral internal rotation deficit 25°)

MR arthrogram: type II SLAP lesion (superior labrum from anterior to posterior — biceps anchor detachment), no rotator cuff tear, no Bankart, mild posterior labral fraying'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 45 ปี ปวดไหล่ขวา 4 เดือน ปวดมากตอนยกแขนเหนือศีรษะ + นอนทับ

PE: positive Neer + Hawkins + Jobe (empty can — weakness due to pain 4/5, no true weakness), painful arc 60-120°, no significant atrophy, no obvious lag signs

X-ray shoulder: mild subacromial spur, no significant glenohumeral arthritis, Bigliani type II acromion
MRI: rotator cuff tendinopathy + subacromial-subdeltoid bursitis, NO full-thickness tear', '[{"label":"A","text":"Immediate arthroscopic decompression"},{"label":"B","text":"Subacromial Impingement Syndrome (Rotator Cuff Tendinopathy + Bursitis) Without Full-Thickness Tear"},{"label":"C","text":"Total shoulder arthroplasty"},{"label":"D","text":"Long-term opioid"},{"label":"E","text":"Bedrest in sling 12 weeks"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Subacromial Impingement Syndrome (Rotator Cuff Tendinopathy + Bursitis) Without Full-Thickness Tear: (1) **conservative management first-line 3-6 months** — overwhelming evidence: (a) **structured PT** — emphasis on **scapular stabilization** (lower trapezius, serratus anterior), **rotator cuff strengthening** (especially posterior cuff — infraspinatus/teres minor), posterior capsule stretching, postural correction; (b) activity modification; (c) NSAIDs short course; (d) **subacromial corticosteroid injection** — short-term pain relief (4-12 weeks), limit to 1-3 injections (cuff damage with repeated); (2) **CSAW + ARC trials (Lancet 2018, BMJ 2019) — subacromial decompression NOT superior to placebo/sham + PT** — major shift away from surgery for impingement without structural pathology; (3) **surgery (arthroscopic subacromial decompression + bursectomy ± acromioplasty)** reserved for: failure of comprehensive 6-12 months conservative + significant structural pathology (large bursal spur, calcific tendinitis); (4) calcific tendinitis specific treatment: lavage + needling, ESWT, surgical excision; (5) cuff tear progression workup if symptoms persist; (6) PT alone effective in 70-80%; (7) reassurance + education on natural history

---

Subacromial impingement: PT + NSAIDs + selective steroid injection first-line. CSAW + ARC trials → arthroscopic decompression NOT superior to placebo/PT alone — major paradigm shift. Surgery reserved for failed extensive conservative + structural pathology. Address scapular stabilization key. Conservative effective 70-80%.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAOS; CSAW Lancet 2018; ARC BMJ 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'หญิงไทยอายุ 45 ปี ปวดไหล่ขวา 4 เดือน ปวดมากตอนยกแขนเหนือศีรษะ + นอนทับ

PE: positive Neer + Hawkins + Jobe (empty can — weakness due to pain 4/5, no true weakness), painful arc 60-120°, no significant atrophy, no obvious lag signs

X-ray shoulder: mild subacromial spur, no significant glenohumeral arthritis, Bigliani type II acromion
MRI: rotator cuff tendinopathy + subacromial-subdeltoid bursitis, NO full-thickness tear'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 55 ปี laborer รู้สึก pop ที่ไหล่หน้าซ้ายเวลายกของหนัก + รู้สึกอ่อนแรง forearm flexion เล็กน้อย
ไม่ปวดมาก

PE: Popeye deformity (distal bulge upper arm with elbow flexion — proximal LHB rupture), mild ecchymosis, decreased forearm supination strength + elbow flexion 4+/5 (preserved largely due to brachialis + short head), no weakness elsewhere

US / MRI shoulder: complete long head of biceps (LHB) tendon rupture at proximal level, mild rotator cuff tendinopathy, no full-thickness cuff tear', '[{"label":"A","text":"Emergency repair all proximal LHB"},{"label":"B","text":"Proximal Long Head of Biceps (LHB) Tendon Rupture (Most Common)"},{"label":"C","text":"Discharge no follow-up"},{"label":"D","text":"Total shoulder arthroplasty"},{"label":"E","text":"Cast in flexion 6 weeks"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Proximal Long Head of Biceps (LHB) Tendon Rupture (Most Common): (1) **conservative management** for most patients — proximal LHB rupture has minimal functional consequence: minor loss of forearm supination (10-20%) + elbow flexion (10-15%) strength compensated by short head + brachialis + supinator; cosmetic Popeye deformity may bother some; (2) ice, NSAIDs, gradual return to activity 2-3 weeks; (3) **surgical biceps tenodesis** (suprapectoral or subpectoral, with anchor or interference screw) indicated: (a) young active patients + cosmetic concern + want full strength, (b) athletes/laborers especially with high supination demand (e.g., carpenter, mechanic), (c) concomitant SLAP/labral or rotator cuff pathology requiring surgery; (4) **biceps tenotomy** acceptable simpler alternative — accepts Popeye + minimal strength loss — older low-demand patients; (5) **distal biceps rupture** (at radial tuberosity) — different — typically operative repair in active adults due to 30-50% supination + 30% elbow flexion strength loss + endurance loss — surgical repair indicated for young active patients (Endobutton, suture anchors, bone tunnels); (6) screen rotator cuff pathology (often concomitant in LHB rupture)

---

Proximal LHB biceps rupture: conservative for most (minimal functional loss). Popeye deformity cosmetic. Tenodesis for young/active/cosmetic concerns or concurrent surgery. Tenotomy older alternative. DISTAL biceps rupture (radial tuberosity) — surgical for active patients (significant supination + elbow flexion strength loss). Screen rotator cuff pathology.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAOS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 55 ปี laborer รู้สึก pop ที่ไหล่หน้าซ้ายเวลายกของหนัก + รู้สึกอ่อนแรง forearm flexion เล็กน้อย
ไม่ปวดมาก

PE: Popeye deformity (distal bulge upper arm with elbow flexion — proximal LHB rupture), mild ecchymosis, decreased forearm supination strength + elbow flexion 4+/5 (preserved largely due to brachialis + short head), no weakness elsewhere

US / MRI shoulder: complete long head of biceps (LHB) tendon rupture at proximal level, mild rotator cuff tendinopathy, no full-thickness cuff tear'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 45 ปี เล่นเทนนิส + พิมพ์งานเยอะ ปวดด้านนอกข้อศอกขวา 3 เดือน ปวดมากเวลาบีบ + ยกของ

PE: tenderness lateral epicondyle + just distal at ECRB origin, positive Cozen test (resisted wrist extension reproduces pain), positive Mill test, no neurologic deficit

US lateral elbow: thickening + hypoechogenicity ECRB origin + neovascularization — tendinosis, no significant tear', '[{"label":"A","text":"Emergency surgery same week"},{"label":"B","text":"Lateral Epicondylitis (Lateral Epicondylosis / Tennis Elbow) — ECRB Tendinosis"},{"label":"C","text":"Long-term opioid daily"},{"label":"D","text":"Cast forearm 12 weeks"},{"label":"E","text":"Repeated steroid injections monthly long-term"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Lateral Epicondylitis (Lateral Epicondylosis / Tennis Elbow) — ECRB Tendinosis: (1) **conservative management first-line 6-12 months** — high spontaneous improvement rate (80-90% at 1-2 years even untreated): (a) activity modification, ergonomic adjustments, counterforce brace (Cho-Pat strap), (b) **PT — eccentric strengthening of wrist extensors** (Tyler twist with FlexBar) — strong evidence, (c) NSAIDs short course, (d) ice; (2) **corticosteroid injection** — short-term relief (< 6 weeks) but **WORSE long-term outcomes** vs wait-and-see (Coombes JAMA 2013 — increased recurrence + chronicity) — minimize use, reserve for severe acute pain; (3) **PRP (platelet-rich plasma) injection** — mixed evidence, may improve long-term outcomes vs steroid; (4) extracorporeal shockwave therapy (ESWT) — moderate evidence; (5) **percutaneous tenotomy** (needle, ultrasonic — TENEX) emerging; (6) **surgical (open or arthroscopic ECRB debridement)** reserved for: failure of 6-12 months comprehensive conservative + significant impact on function (10-15% require surgery); (7) education on natural history — chronic condition with high spontaneous improvement; (8) avoid prolonged steroid + repeated injections

---

Lateral epicondylitis: tendinosis of ECRB (not inflammation). Conservative 6-12 months — high spontaneous resolution. Eccentric exercises (FlexBar) strongest evidence. Steroid injection — short-term relief but worse long-term (Coombes JAMA). PRP mixed. Surgery only for failed comprehensive conservative. Natural history favorable.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAOS; Coombes JAMA 2013', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'หญิงไทยอายุ 45 ปี เล่นเทนนิส + พิมพ์งานเยอะ ปวดด้านนอกข้อศอกขวา 3 เดือน ปวดมากเวลาบีบ + ยกของ

PE: tenderness lateral epicondyle + just distal at ECRB origin, positive Cozen test (resisted wrist extension reproduces pain), positive Mill test, no neurologic deficit

US lateral elbow: thickening + hypoechogenicity ECRB origin + neovascularization — tendinosis, no significant tear'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 22 ปี นักเบสบอลพิทเชอร์ ปวด medial elbow + decreased throwing velocity + worse late cocking phase 3 เดือน

PE: tender medial epicondyle + UCL, positive moving valgus stress test, positive milking maneuver, no ulnar nerve symptoms, valgus instability at 30° flexion 4 mm opening vs 2 mm contralateral

MRI elbow: partial-thickness undersurface tear medial UCL (anterior bundle) — "T-sign" on MR arthrogram (contrast extension along undersurface), no full thickness tear, no loose bodies', '[{"label":"A","text":"Immediate surgery all partial tears"},{"label":"B","text":"Partial UCL Tear in Overhead Throwing Athlete (Pitcher) — \"T-sign\""},{"label":"C","text":"Long-term opioid"},{"label":"D","text":"Cast forearm 12 weeks"},{"label":"E","text":"Discharge no treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Partial UCL Tear in Overhead Throwing Athlete (Pitcher) — "T-sign": (1) **conservative first** — 3-6 months of comprehensive non-operative trial: rest from throwing 6-12 weeks, NSAIDs, PT — flexor-pronator strengthening + scapular + core, dynamic stabilization, gradual return-to-throwing program; (2) **PRP injection** for partial tears emerging — some evidence supports faster RTS in partial tears especially in non-elite throwers; (3) **surgical reconstruction** — Tommy John surgery / UCL reconstruction — indicated: failure of conservative + elite throwers + wish to return to high-level pitching + full-thickness tear; (4) **UCL reconstruction techniques**: original Jobe technique, **docking technique** (modified, less morbidity, comparable outcomes), figure-of-8, internal brace augmentation (Dugas — UCL repair with internal brace for proximal/distal avulsion-type tears in young athletes — faster RTS 6-9 months vs 12-15 months reconstruction); (5) graft: palmaris longus, gracilis, semitendinosus; (6) **return to pitching 12-18 months** post-reconstruction; (7) ulnar nerve transposition — selective (controversial routine); (8) pre-disposing — workload, pitch count, mechanics — prevention key; (9) RTS rate ~ 80% pitchers

---

UCL tear: pitcher''s elbow. Conservative trial first (rest + PT + PRP). UCL reconstruction (Tommy John) for failed conservative + elite + full-thickness. Docking technique modified Jobe. UCL repair + internal brace (Dugas) — proximal/distal avulsion young — faster RTS. RTS 12-18 months reconstruction. Prevention: pitch count, mechanics.', NULL,
  'hard', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AOSSM; Dugas UCL Repair', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 22 ปี นักเบสบอลพิทเชอร์ ปวด medial elbow + decreased throwing velocity + worse late cocking phase 3 เดือน

PE: tender medial epicondyle + UCL, positive moving valgus stress test, positive milking maneuver, no ulnar nerve symptoms, valgus instability at 30° flexion 4 mm opening vs 2 mm contralateral

MRI elbow: partial-thickness undersurface tear medial UCL (anterior bundle) — "T-sign" on MR arthrogram (contrast extension along undersurface), no full thickness tear, no loose bodies'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทหารใหม่อายุ 20 ปี เริ่มฝึก military training ปวดกลางเท้าซ้าย 3 สัปดาห์ ปวดมากขึ้นขณะวิ่ง พักดีขึ้น ไม่มี trauma

PE: tenderness + mild swelling dorsum foot over 2nd metatarsal shaft, no obvious deformity, no skin lesion, normal NV

X-ray foot: initial — no obvious fracture; repeat 3 weeks later — periosteal new bone + callus formation 2nd metatarsal mid-shaft
MRI foot: bone marrow edema + linear hypointense line 2nd metatarsal shaft — stress fracture', '[{"label":"A","text":"Surgical fixation all metatarsal stress fractures"},{"label":"B","text":"March Fracture (Stress Fracture 2nd Metatarsal) in Military Recruit — Low-Risk Stress Fracture"},{"label":"C","text":"Cast non-weight bearing 12 weeks long-leg"},{"label":"D","text":"Discharge no treatment continue training"},{"label":"E","text":"Above-knee amputation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** March Fracture (Stress Fracture 2nd Metatarsal) in Military Recruit — Low-Risk Stress Fracture: (1) **non-operative management** for low-risk metatarsal stress fracture (2nd, 3rd, 4th MT shaft) — heals reliably: rest from impact activity + relative rest (cross-train — swimming, cycling); WBAT in stiff-soled shoe or post-op shoe or short walking boot 4-8 weeks; gradual return to weight-bearing impact 6-8 weeks; gradual return to running 8-12 weeks with progressive program; (2) NSAIDs limited (theoretical concern about bone healing — controversial); (3) ice, edema control; (4) **address underlying risk factors**: training error (rapid increase in volume/intensity > 10% rule), biomechanics (cavus foot, hindfoot varus, leg length discrepancy, gait), nutrition (calorie intake, vitamin D, calcium), Female Athlete Triad/RED-S in females, BMD if recurrent or red flags; (5) gradual return to running program; (6) **high-risk stress fractures** (5th MT base — Jones fracture zone 2, proximal 2nd MT base, navicular, medial femoral neck, anterior tibial diaphysis, talus, patella, sesamoid) — require surgical fixation or strict non-WB casting due to nonunion risk; (7) prevention — graduated training, footwear, biomechanics

---

March fracture: stress fracture metatarsal shaft (2nd-4th) — low risk. Heals with relative rest + protected WB 6-8 weeks + gradual return. Address training error, biomechanics, nutrition, Female Athlete Triad. High-risk stress fractures (5th MT Jones, navicular, femoral neck tension side, anterior tibia) — surgical or strict non-WB casting (nonunion risk).', NULL,
  'easy', 'trauma', 'review',
  'orthopedics', 'clinical_decision', 'trauma', 'adult',
  'AOFAS; Female Athlete Triad', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ทหารใหม่อายุ 20 ปี เริ่มฝึก military training ปวดกลางเท้าซ้าย 3 สัปดาห์ ปวดมากขึ้นขณะวิ่ง พักดีขึ้น ไม่มี trauma

PE: tenderness + mild swelling dorsum foot over 2nd metatarsal shaft, no obvious deformity, no skin lesion, normal NV

X-ray foot: initial — no obvious fracture; repeat 3 weeks later — periosteal new bone + callus formation 2nd metatarsal mid-shaft
MRI foot: bone marrow edema + linear hypointense line 2nd metatarsal shaft — stress fracture'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 48 ปี ครู ปวดส้นเท้าซ้าย 6 เดือน ปวดมากที่สุดเมื่อก้าวแรกตอนเช้า + หลังนั่งนาน ดีขึ้นเมื่อเดินสักพัก

PE: tenderness medial calcaneal tuberosity (plantar fascia origin), positive Windlass test (great toe dorsiflexion reproduces pain), tight Achilles, no swelling, no skin changes

US plantar fascia: thickened plantar fascia 6 mm (normal < 4 mm) + hypoechogenic — plantar fasciitis
X-ray foot: calcaneal spur (incidental — does not correlate with pain)', '[{"label":"A","text":"Emergency surgery same week"},{"label":"B","text":"Chronic Plantar Fasciitis (Plantar Fasciosis)"},{"label":"C","text":"Long-term oral steroid"},{"label":"D","text":"Calcaneal spur excision routinely"},{"label":"E","text":"Cast non-weight bearing 12 weeks"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic Plantar Fasciitis (Plantar Fasciosis): (1) **conservative management first-line 6-12 months** — most resolve spontaneously: (a) **stretching** — plantar fascia-specific stretch (Rompe + DiGiovanni — better evidence than gastroc/Achilles alone) + Achilles/calf stretching; (b) **orthoses** — over-the-counter pre-fabricated insoles (no evidence custom superior — UK guidelines); heel cushion; arch support; (c) **night splints** (passive dorsiflexion) — moderate evidence for chronic; (d) NSAIDs short course; (e) activity modification, footwear (supportive); (f) ice massage; (g) PT — eccentric loading, manual therapy; (2) **corticosteroid injection** — short-term relief (4-12 wk) แต่ risks: plantar fascia rupture, fat pad atrophy, increased recurrence — limit to 1-2 injections; (3) **PRP injection** — moderate evidence, fewer complications vs steroid; (4) **ESWT (extracorporeal shockwave therapy)** — moderate evidence, FDA-approved for chronic > 6 months; (5) **percutaneous needle fasciotomy/TENEX** — emerging; (6) **surgical (partial plantar fasciotomy ± gastrocnemius recession)** reserved for: failure of 12 months comprehensive conservative — < 5% require surgery; (7) calcaneal spur is incidental finding (poor correlation with symptoms — do NOT routinely excise); (8) screen for inflammatory arthropathy if bilateral/young/atypical (SpA)

---

Plantar fasciitis: 80-90% resolve conservatively within 12 months. Plantar fascia-specific stretching strongest evidence. Insoles, night splints, NSAIDs adjuncts. Steroid injection short-term — limit (rupture, fat pad atrophy). PRP, ESWT emerging. Surgery rare (failed comprehensive). Calcaneal spur incidental — do NOT excise. Screen SpA if atypical.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AOFAS; Rompe Plantar Fascia Stretch', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'หญิงไทยอายุ 48 ปี ครู ปวดส้นเท้าซ้าย 6 เดือน ปวดมากที่สุดเมื่อก้าวแรกตอนเช้า + หลังนั่งนาน ดีขึ้นเมื่อเดินสักพัก

PE: tenderness medial calcaneal tuberosity (plantar fascia origin), positive Windlass test (great toe dorsiflexion reproduces pain), tight Achilles, no swelling, no skin changes

US plantar fascia: thickened plantar fascia 6 mm (normal < 4 mm) + hypoechogenic — plantar fasciitis
X-ray foot: calcaneal spur (incidental — does not correlate with pain)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 26 ปี นักฟุตบอล sprint แล้วรู้สึก pop ที่หลังต้นขาขวา ปวดมาก เดินกระเผลก

PE: ecchymosis posterior thigh distal, tender + palpable defect biceps femoris long head + semitendinosus origin, weakness knee flexion 3/5, weakness hip extension 4/5, positive prone slumped knee-bend test, no neurologic deficit

MRI thigh: high-grade partial tear hamstring origin (ischial tuberosity) — biceps femoris long head + semitendinosus + semimembranosus, > 2 cm retraction tendinous origin (proximal hamstring tendon avulsion)', '[{"label":"A","text":"Conservative bedrest 12 weeks regardless"},{"label":"B","text":"Proximal Hamstring Tendon Avulsion with Significant Retraction in Active Athlete"},{"label":"C","text":"Above-knee amputation"},{"label":"D","text":"Total hip arthroplasty"},{"label":"E","text":"Cast in flexion 12 weeks"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Proximal Hamstring Tendon Avulsion with Significant Retraction in Active Athlete: (1) **operative repair indicated** for: (a) complete 3-tendon avulsion (especially with > 2 cm retraction), (b) active patient (athlete) with functional demand, (c) acute injury (< 4-6 weeks ideal — easier dissection + better outcomes); (2) **surgical repair** — open repair via posterior gluteal crease approach, suture anchors to ischial tuberosity, identify + protect sciatic nerve (immediately deep to hamstring origin), restore tendon excursion; (3) post-op: brace in hip extension + knee flexion 6 weeks, gradual ROM, no active hamstring 6-8 weeks, PT, RTS 6-9 months; (4) **non-operative** for: low-grade partial tears (≤ 2 tendons + < 2 cm retraction), elderly/sedentary, late presentation (delayed surgery has worse outcomes — > 4-6 wk retracted): RICE + crutches WBAT + PT — progressive eccentric strengthening + flexibility + neuromuscular control; (5) **chronic proximal hamstring avulsion** (> 4-6 wk) — more difficult surgery: tendon-graft augmentation (allograft, ipsilateral semitendinosus advancement), Achilles allograft reconstruction; outcomes inferior to acute repair; (6) sciatic nerve symptoms — neurolysis at surgery; (7) **acute hamstring strain (grade I-II, no avulsion)** — non-operative — POLICE protocol + progressive Nordic eccentric (best evidence reduces recurrence) + PT + gradual return-to-running

---

Proximal hamstring tendon avulsion: surgery for complete avulsion + > 2 cm retraction + active patient (acute < 4-6 wk ideal). Identify + protect sciatic nerve. Chronic avulsion → graft reconstruction (inferior outcomes). Grade I-II strain → non-operative + Nordic eccentric (best evidence). RTS 6-9 months surgery, 2-12 wk strain.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AOSSM Hamstring; AAOS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 26 ปี นักฟุตบอล sprint แล้วรู้สึก pop ที่หลังต้นขาขวา ปวดมาก เดินกระเผลก

PE: ecchymosis posterior thigh distal, tender + palpable defect biceps femoris long head + semitendinosus origin, weakness knee flexion 3/5, weakness hip extension 4/5, positive prone slumped knee-bend test, no neurologic deficit

MRI thigh: high-grade partial tear hamstring origin (ischial tuberosity) — biceps femoris long head + semitendinosus + semimembranosus, > 2 cm retraction tendinous origin (proximal hamstring tendon avulsion)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 64 ปี ปวด hip ขวา 5 ปี ค่อย ๆ แย่ลง ปวดมาก + ขัด + ขยับยาก, FAILED 12 เดือน conservative (PT, NSAIDs, weight loss, intra-articular steroid)

BMI 28, no major comorbidity
PE: groin pain, internal rotation severely limited, Trendelenburg gait

X-ray hip: severe hip OA — joint space obliterated, subchondral cyst, osteophyte, sclerosis, no AVN, no acetabular dysplasia', '[{"label":"A","text":"Continue NSAIDs indefinitely"},{"label":"B","text":"Advanced Primary Hip OA Failed Conservative — Total Hip Arthroplasty (THA)"},{"label":"C","text":"Hip arthrodesis first"},{"label":"D","text":"Hemiarthroplasty preferred over THA in healthy 64"},{"label":"E","text":"Bedrest"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Advanced Primary Hip OA Failed Conservative — Total Hip Arthroplasty (THA): (1) **primary THA gold standard** — "operation of the century" — excellent pain relief + function + > 95% 10-year survival; (2) preoperative optimization: medical comorbidities (HbA1c < 7.5-8, smoking cessation 4 weeks, BMI < 40 ideal), dental evaluation, MRSA screening, anemia optimization; (3) **surgical approach** — posterior (most common, higher dislocation), direct anterior (faster early recovery, learning curve, LFCN injury), direct lateral (low dislocation, abductor weakness limp); no clear superiority long-term; (4) **bearing surfaces**: ceramic-on-cross-linked polyethylene most common modern; metal-on-metal largely abandoned (ALVAL, ARMD); ceramic-on-ceramic (squeaking 1-3%, fracture rare); (5) cementless femoral + acetabular fixation (modern standard for most), cemented for severely osteoporotic elderly; (6) post-op rehab: WBAT same day, PT, ambulation; (7) hip precautions for posterior approach 6-12 weeks (avoid flexion > 90°, adduction, internal rotation); (8) DVT prophylaxis (aspirin, LMWH, DOAC); (9) infection prevention (antibiotic prophylaxis cefazolin within 1 hour, TXA reduces transfusion); (10) long-term: dislocation 1-3%, infection 1%, aseptic loosening, periprosthetic fracture, ALTR — counsel; (11) FDA implant tracking; (12) follow-up X-ray to monitor wear/loosening

---

Primary THA: gold standard advanced hip OA failed conservative. > 95% 10-yr survival. Optimize medical comorbidities preop (HbA1c, BMI, smoking, MRSA, dental). Modern bearing: ceramic-on-XLPE. Cementless fixation standard. Posterior most common (dislocation risk). TXA + DVT prophylaxis. Long-term complications counseled. "Operation of the century".', NULL,
  'easy', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAHKS; AAOS; Learmonth Lancet 2007', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 64 ปี ปวด hip ขวา 5 ปี ค่อย ๆ แย่ลง ปวดมาก + ขัด + ขยับยาก, FAILED 12 เดือน conservative (PT, NSAIDs, weight loss, intra-articular steroid)

BMI 28, no major comorbidity
PE: groin pain, internal rotation severely limited, Trendelenburg gait

X-ray hip: severe hip OA — joint space obliterated, subchondral cyst, osteophyte, sclerosis, no AVN, no acetabular dysplasia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 72 ปี s/p left THA 15 ปีก่อน เริ่มปวดต้นขา + groin 1 ปี ปวดมากขึ้นเมื่อ weight bear + standing up, ไม่ตอบสนอง NSAIDs

PE: groin + thigh pain, antalgic gait, no warmth, no draining sinus

X-ray hip: cementless femoral stem with radiolucency Gruen zones 1, 2, 7, 5, calcar resorption, distal stem subsidence 4 mm vs prior X-ray — aseptic loosening femoral component, acetabular cup intact
Lab: CRP 5 (normal), ESR 18 (normal), aspiration negative for infection', '[{"label":"A","text":"Continue NSAIDs no surgery"},{"label":"B","text":"Aseptic Femoral Loosening Post-THA (15 ปี — late) — Revision Femoral Component"},{"label":"C","text":"Bedrest indefinitely"},{"label":"D","text":"Cast immobilization"},{"label":"E","text":"Antibiotics empirically without workup"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Aseptic Femoral Loosening Post-THA (15 ปี — late) — Revision Femoral Component: (1) **rule out infection first** — ALL painful THA must have CRP + ESR + hip aspiration before assuming aseptic (MSIS criteria) — done: negative; (2) workup: bilateral hip X-ray with comparison to immediate post-op, CT to assess bone stock + cup version; metal-ion levels if MoM; (3) **revision THA — femoral component** with options based on remaining bone stock: (a) **proximally porous-coated stem** (if bone stock adequate), (b) **distally fixed extended stem (Wagner SL, Restoration Modular, fluted tapered stem)** for proximal bone deficiency, (c) impaction grafting + cemented stem (rarely used), (d) custom stem for severe deficiency; (4) Paprosky femoral defect classification guides; (5) extended trochanteric osteotomy (ETO) often needed to remove well-fixed stem; (6) cup assessment intra-op — revise if loose, malpositioned, or worn; (7) cells with abductor mechanism + soft tissue evaluation; (8) higher risk of complications vs primary (infection 3-5%, dislocation 5-10%, fracture, instability); (9) post-op restrictions + protected WB; (10) physical therapy

---

Painful THA: ALWAYS rule out infection first (CRP + ESR + aspiration — MSIS). Aseptic femoral loosening → revision. Paprosky classification guides. Distally fixed stem for proximal bone loss. ETO often needed. Higher complication rate vs primary. Cup assessed concurrently. Modern revision good outcomes but inferior to primary.', NULL,
  'hard', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAHKS; Paprosky Classification', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'หญิงไทยอายุ 72 ปี s/p left THA 15 ปีก่อน เริ่มปวดต้นขา + groin 1 ปี ปวดมากขึ้นเมื่อ weight bear + standing up, ไม่ตอบสนอง NSAIDs

PE: groin + thigh pain, antalgic gait, no warmth, no draining sinus

X-ray hip: cementless femoral stem with radiolucency Gruen zones 1, 2, 7, 5, calcar resorption, distal stem subsidence 4 mm vs prior X-ray — aseptic loosening femoral component, acetabular cup intact
Lab: CRP 5 (normal), ESR 18 (normal), aspiration negative for infection'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 68 ปี s/p right TKA 8 weeks ago เริ่มปวด + บวม + แดง ข้อเข่าขวา 5 วัน + ไข้ต่ำ 37.8°C + drainage from incision

PE: warmth + erythema knee, mild effusion, tender, draining sinus, no neurologic deficit
Lab: WBC 13,000, CRP 145, ESR 88
Knee aspiration: WBC 28,000 (PMN 92%), gram stain negative, culture pending

MSIS criteria: 1 major (sinus tract communicating with prosthesis) + minor criteria meet — periprosthetic joint infection (PJI), acute postoperative (< 3 months)', '[{"label":"A","text":"Oral antibiotics outpatient discharge"},{"label":"B","text":"Acute Postoperative Periprosthetic Joint Infection (PJI < 3 months from surgery) — Confirmed MSIS"},{"label":"C","text":"Long-term opioid no surgery"},{"label":"D","text":"Discharge no antibiotics"},{"label":"E","text":"Single-stage replacement always in chronic PJI"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Postoperative Periprosthetic Joint Infection (PJI < 3 months from surgery) — Confirmed MSIS: (1) **debridement, antibiotics, and implant retention (DAIR)** — appropriate for acute postoperative (< 4-6 weeks from index surgery, or acute hematogenous with < 3 weeks symptoms) — well-fixed implants + susceptible organism + viable soft tissue: open thorough debridement + irrigation + **polyethylene liner exchange** + retention of metal components + 6-week IV organism-specific antibiotic (after intra-op cultures) → followed by oral suppression; success 50-70%; (2) **2-stage revision** — gold standard for chronic PJI (> 4-6 wk from surgery or chronic symptoms > 3 wk) or failed DAIR: (a) remove all components + thorough debridement + antibiotic-loaded cement spacer (articulating preferred for knee), (b) IV antibiotic 6 weeks, (c) antibiotic-free interval + verify eradication (normalized CRP/ESR, negative aspiration), (d) reimplantation; success 85-95%; (3) 1-stage revision — gaining favor in selected cases with low-virulence organism + healthy host; (4) hold antibiotic until intra-op cultures (unless septic); empiric vancomycin + cefepime/ceftriaxone; (5) chronic suppression for non-revisable patient; (6) infectious disease consult; (7) optimize host (DM, nutrition, smoking)

---

PJI: orthopedic emergency. MSIS criteria diagnosis. ACUTE postoperative (< 4-6 wk) or acute hematogenous (< 3 wk symptoms) + well-fixed implant → DAIR (irrigation + poly exchange + retention + 6 wk IV abx). CHRONIC or failed DAIR → 2-stage revision (gold standard). Hold antibiotics until cultures. ID consult. Host optimization.', NULL,
  'hard', 'id', 'review',
  'orthopedics', 'clinical_decision', 'id', 'adult',
  'MSIS; IDSA PJI 2013', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 68 ปี s/p right TKA 8 weeks ago เริ่มปวด + บวม + แดง ข้อเข่าขวา 5 วัน + ไข้ต่ำ 37.8°C + drainage from incision

PE: warmth + erythema knee, mild effusion, tender, draining sinus, no neurologic deficit
Lab: WBC 13,000, CRP 145, ESR 88
Knee aspiration: WBC 28,000 (PMN 92%), gram stain negative, culture pending

MSIS criteria: 1 major (sinus tract communicating with prosthesis) + minor criteria meet — periprosthetic joint infection (PJI), acute postoperative (< 3 months)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 58 ปี active เล่นกอล์ฟ ปวดเข่าด้านในขวา 2 ปี ดีขึ้นน้อยกับ conservative

BMI 27, ROM 0-130°, no significant instability
PE: tender medial joint line, varus 5°, intact ACL, full ROM, no flexion contracture, no lateral compartment pain, no patellofemoral symptoms

X-ray standing knee + Rosenberg + Skyline: isolated medial compartment OA — joint space obliterated medial, preserved lateral + patellofemoral, mild osteophytes', '[{"label":"A","text":"TKA always preferred"},{"label":"B","text":"advantages vs TKA"},{"label":"C","text":"Knee arthrodesis"},{"label":"D","text":"Bedrest 6 weeks"},{"label":"E","text":"Long-term opioid"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Isolated Medial Compartment OA + Active Patient + Specific Criteria — Unicompartmental Knee Arthroplasty (UKA): (1) UKA candidate criteria (Kozinn + Scott + modern criteria): (a) isolated medial (or lateral) compartment OA confirmed clinically + radiographically + intra-operatively, (b) intact ACL (anterior stability essential), (c) correctable varus deformity (< 10-15°), (d) ROM > 90° flexion, (e) flexion contracture < 10°, (f) no significant patellofemoral OA (mild patellofemoral OK), (g) BMI no longer absolute contraindication; activity level no longer contraindication (modern evidence allows active patients); age — modern UKA performed across age spectrum; (2) **advantages vs TKA**: more bone preservation, preserves cruciates → more native kinematics + proprioception, smaller incision, less blood loss, faster recovery, more "natural" feel, lower transfusion, lower cardiopulmonary risk; (3) **disadvantages**: higher revision rate at 10-15 years (5-10% vs 3-5% TKA), revision to TKA easier than failed TKA revision; (4) **TKA alternative** for multicompartmental, deformity, instability, advanced patellofemoral; (5) high tibial osteotomy (HTO) alternative for younger patients (< 50-55) with isolated medial + correctable malalignment + want to preserve native joint; (6) outcome optimization: high-volume surgeon, modern implant design, robotic-assisted (controversial benefit)

---

UKA: isolated single-compartment OA with intact cruciates + correctable deformity + ROM preserved. Better functional outcome + faster recovery vs TKA but higher revision rate at 10-15 yr. HTO alternative for young (< 55) + isolated medial + correctable. TKA for multicompartmental, instability, severe deformity. Patient selection key. Modern criteria more inclusive.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAHKS; Kozinn Scott', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 58 ปี active เล่นกอล์ฟ ปวดเข่าด้านในขวา 2 ปี ดีขึ้นน้อยกับ conservative

BMI 27, ROM 0-130°, no significant instability
PE: tender medial joint line, varus 5°, intact ACL, full ROM, no flexion contracture, no lateral compartment pain, no patellofemoral symptoms

X-ray standing knee + Rosenberg + Skyline: isolated medial compartment OA — joint space obliterated medial, preserved lateral + patellofemoral, mild osteophytes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 75 ปี ปวด + อ่อนแรงไหล่ขวา ยกแขนเหนือศีรษะไม่ได้ 5 ปี (chronic massive rotator cuff tear → cuff tear arthropathy)

PE: pseudoparalysis (active elevation < 90° but full passive ROM), positive impingement, drop arm, weakness external rotation, no infection signs

X-ray shoulder: superior migration of humeral head (acromiohumeral distance 4 mm — normal > 7 mm), Hamada IV (acetabularization acromion), glenohumeral OA — cuff tear arthropathy', '[{"label":"A","text":"Anatomic TSA without cuff"},{"label":"B","text":"Cuff Tear Arthropathy with Pseudoparalysis — Reverse Total Shoulder Arthroplasty (rTSA)"},{"label":"C","text":"Hemiarthroplasty preferred for cuff arthropathy"},{"label":"D","text":"Conservative no surgery indefinite"},{"label":"E","text":"Arthrodesis shoulder"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cuff Tear Arthropathy with Pseudoparalysis — Reverse Total Shoulder Arthroplasty (rTSA): (1) **reverse TSA indicated** — revolutionized treatment of cuff tear arthropathy: (a) reverses normal shoulder anatomy — semi-constrained ball-on-socket at glenoid + cup on humerus, (b) shifts center of rotation medially + distally + tensions deltoid, (c) deltoid replaces cuff function for elevation, (d) does NOT require functional cuff (unlike anatomic TSA which requires intact cuff); (2) **indications**: cuff tear arthropathy, irreparable massive cuff tear with pseudoparalysis, failed rotator cuff repair with cuff arthropathy, complex proximal humerus fracture in elderly (no tuberosity healing concern), revision arthroplasty, **chronic locked dislocation**, rheumatoid arthritis with cuff deficiency; (3) prerequisites: functional deltoid, intact axillary nerve, adequate bone stock glenoid (or augmented baseplate), acceptable infection workup; (4) **outcomes**: predictable pain relief + improved elevation (typically 120-150° from baseline pseudoparalysis), external rotation less predictable (consider latissimus dorsi transfer for ER deficiency), better than hemiarthroplasty for cuff arthropathy; (5) **complications**: instability (1-5%), infection (Cutibacterium acnes — "propi"), scapular notching (less with newer designs), acromial stress fracture (5-10%), neurologic, periprosthetic fracture; (6) post-op: sling, gradual deltoid activation + ROM; (7) age previously > 70 ปี, modern indications expanding to younger active patients selectively; (8) prosthesis survival > 90% at 10 years

---

Reverse TSA: revolutionary for cuff tear arthropathy + pseudoparalysis. Doesn''t need cuff — uses deltoid. Indications expanded: massive irreparable cuff tear, proximal humerus fracture in elderly, revision, locked dislocation, RA. Predictable elevation. Complications: notching, instability, fracture, infection (P. acnes). > 90% 10-yr survival. Age limits relaxing.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'ASES; AAOS Shoulder Arthroplasty', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'หญิงไทยอายุ 75 ปี ปวด + อ่อนแรงไหล่ขวา ยกแขนเหนือศีรษะไม่ได้ 5 ปี (chronic massive rotator cuff tear → cuff tear arthropathy)

PE: pseudoparalysis (active elevation < 90° but full passive ROM), positive impingement, drop arm, weakness external rotation, no infection signs

X-ray shoulder: superior migration of humeral head (acromiohumeral distance 4 mm — normal > 7 mm), Hamada IV (acetabularization acromion), glenohumeral OA — cuff tear arthropathy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 78 ปี s/p left THA 10 ปีก่อน หกล้มในห้องน้ำ ปวด thigh + hip ซ้าย เดินไม่ได้

PE: shortening + external rotation left leg, palpable crepitation thigh, NV intact

X-ray femur: spiral periprosthetic femur fracture around tip of cementless femoral stem, stem appears loose (subsidence, radiolucency), no acetabular fracture — **Vancouver B2** (fracture around stem with loose stem, adequate bone stock)', '[{"label":"A","text":"Cast immobilization 12 weeks"},{"label":"B","text":"Vancouver B2 Periprosthetic Femoral Fracture (around stem, loose stem, adequate bone stock) — Revision Surgery"},{"label":"C","text":"Discharge home with crutches"},{"label":"D","text":"ORIF without revising loose stem"},{"label":"E","text":"Above-knee amputation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Vancouver B2 Periprosthetic Femoral Fracture (around stem, loose stem, adequate bone stock) — Revision Surgery: (1) **operative revision** — Vancouver B2 mandates revision of loose stem + fracture fixation: (a) **revision to long-stemmed femoral implant** (modular tapered fluted stem — Wagner SL, Restoration Modular) that bypasses fracture by ≥ 2 cortical diameters + obtains distal fixation in intact bone; (b) cerclage cables/wires for fracture reduction; (c) consider strut allograft augmentation for cortical defects; (2) Vancouver classification: **A**(trochanteric — non-op for AG; ORIF for AL with avulsion of vastus origin), **B1** (around stem, stable stem, good bone — ORIF with locked plate ± cerclage, retain stem), **B2** (around stem, loose stem, good bone — revise long stem), **B3** (around stem, loose stem, poor bone — revise long stem + augmentation/allograft/proximal femoral replacement); **C** (distal to stem — ORIF locked plate, retain stem); (3) pre-op assessment: stem fixation (subsidence, radiolucency, calcar resorption), bone stock, soft tissue, host comorbidities; (4) DVT prophylaxis; (5) post-op WB depends on fixation; (6) PT + multidisciplinary geriatric care; (7) osteoporosis treatment; (8) fall prevention; (9) mortality + complications high in elderly (similar to hip fracture)

---

Periprosthetic femur fracture post-THA: Vancouver classification (B is most common — at stem). B1 stable stem = ORIF + retain. B2 loose stem + good bone = revise to long stem. B3 loose + poor bone = revise + augmentation/proximal femur replacement. C distal to stem = ORIF. Bypass fracture 2 cortical diameters. High complication + mortality similar to hip fracture.', NULL,
  'hard', 'trauma', 'review',
  'orthopedics', 'clinical_decision', 'trauma', 'adult',
  'Vancouver Classification; AAOS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'หญิงไทยอายุ 78 ปี s/p left THA 10 ปีก่อน หกล้มในห้องน้ำ ปวด thigh + hip ซ้าย เดินไม่ได้

PE: shortening + external rotation left leg, palpable crepitation thigh, NV intact

X-ray femur: spiral periprosthetic femur fracture around tip of cementless femoral stem, stem appears loose (subsidence, radiolucency), no acetabular fracture — **Vancouver B2** (fracture around stem with loose stem, adequate bone stock)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 42 ปี อดีตนักรักบี้ ปวด hip ซ้าย 3 ปี (advanced OA secondary to old acetabular fracture) ต้องการกลับมาเล่นกีฬา active, ผู้ป่วยตัวสูง 180 cm bone stock ดี

Discussion of options THA vs hip resurfacing

X-ray hip: end-stage OA, adequate femoral head + neck bone stock, no significant cysts, no severe deformity', '[{"label":"A","text":"THA only option for any patient"},{"label":"B","text":"Young Active Male with Advanced Hip OA + Adequate Bone Stock — Hip Resurfacing as Option"},{"label":"C","text":"Hip arthrodesis"},{"label":"D","text":"Conservative indefinitely"},{"label":"E","text":"Steroid injection only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Young Active Male with Advanced Hip OA + Adequate Bone Stock — Hip Resurfacing as Option: (1) **discuss THA vs hip resurfacing arthroplasty (HRA)** with patient — shared decision; (2) **hip resurfacing advantages**: (a) preserves femoral head + neck bone stock (revision-friendly), (b) larger head + lower dislocation rate vs THA, (c) more natural hip biomechanics + restoration of hip offset, (d) potentially better function for high-demand activity (some studies — equivalent return to sport), (e) easier revision to THA if needed; (3) **hip resurfacing disadvantages/risks**: (a) **metal-on-metal bearing** — adverse local tissue reaction (ALTR), pseudotumor, metal ion elevation (cobalt, chromium), ALVAL, raised concern in females + small components → most series report better outcomes in **males with larger femoral head** (> 50 mm); (b) femoral neck fracture (1-2% within first year); (c) limited implants on market (recalls — DePuy ASR, Birmingham hip exception remains); (d) require pre-op bone density adequate; (4) **patient selection criteria (Birmingham hip)**: male > female, age < 65 ปี typically, large femoral head (> 50 mm component), good bone density (no severe osteoporosis), no severe femoral head deformity/cysts, no metal allergy, no renal impairment; (5) **modern trend** — declining HRA use globally + favoring THA with cross-linked polyethylene + ceramic-on-ceramic in young active patients (less concern with metal ions, similar functional outcomes); (6) discuss with patient + informed consent + metal ion monitoring

---

Hip resurfacing arthroplasty: bone-preserving option for young active males with large femoral head. Birmingham hip remaining major implant. Risks: ALTR, pseudotumor, metal ion elevation, femoral neck fracture. Modern trend → declining use, favoring THA with XLPE/ceramic-on-ceramic. Strict patient selection (male, large head, no osteoporosis). Shared decision-making.', NULL,
  'hard', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAHKS; Birmingham Hip Resurfacing', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 42 ปี อดีตนักรักบี้ ปวด hip ซ้าย 3 ปี (advanced OA secondary to old acetabular fracture) ต้องการกลับมาเล่นกีฬา active, ผู้ป่วยตัวสูง 180 cm bone stock ดี

Discussion of options THA vs hip resurfacing

X-ray hip: end-stage OA, adequate femoral head + neck bone stock, no significant cysts, no severe deformity'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 55 ปี s/p right THA 6 เดือนก่อน ปวด + ยับยั้ง ROM ของ hip ขวา (loss of flexion to 80° from prior 110°) — ankylosing trend

PE: marked decreased ROM, palpable mass around hip

X-ray hip: extensive heterotopic ossification around hip (Brooker grade III — bone islands with < 1 cm between bone surfaces), implants well-fixed', '[{"label":"A","text":"Immediate aggressive excision without delay"},{"label":"B","text":"Heterotopic Ossification (HO) Post-THA Brooker Grade III + Functional ROM Restriction"},{"label":"C","text":"No further treatment ever"},{"label":"D","text":"Total joint revision"},{"label":"E","text":"Above-knee amputation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Heterotopic Ossification (HO) Post-THA Brooker Grade III + Functional ROM Restriction: (1) **observation initially** — HO progression usually slows by 6-12 months; bone scan to assess metabolic activity ("hot" bone scan = active formation, not ready for excision); (2) **prophylaxis at index surgery** to prevent — high risk patients (male, prior HO, ankylosing spondylitis, DISH, post-traumatic, posterior approach): (a) **indomethacin 25 mg TID × 6 weeks** post-op (NSAID — inhibits osteoblast differentiation), or selective COX-2; (b) **single-fraction radiation therapy** 6-8 Gy within 72 hours post-op (alternative — equivalent efficacy, avoids GI/renal effects of NSAIDs); (3) **surgical excision** considered for symptomatic HO causing functional limitation: (a) wait until HO mature (12-18 months) — bone scan shows decreased activity + serum alkaline phosphatase normalized → reduces recurrence; (b) wide excision + capsulotomy + restore ROM; (c) **prophylaxis post-excision** essential (otherwise recurrence near 100%) — indomethacin or single-dose radiation 6-8 Gy within 24-72 hours; (4) physical therapy for ROM restoration; (5) screen for ankylosing spondylitis, DISH, neurogenic causes (SCI, TBI) when severe/recurrent; (6) **acute traumatic HO** (post-burn, brain injury, SCI) — etidronate historic, indomethacin, radiation; modern bisphosphonate + radiation

---

Heterotopic ossification post-THA: more common in male, posterior approach, prior HO, AS, DISH. Prophylaxis: indomethacin 6 weeks OR single-dose radiation 6-8 Gy < 72h — for high-risk patients. Excision delayed 12-18 months until mature (bone scan, alk phos). MUST give prophylaxis post-excision (otherwise recurs near 100%). PT for ROM.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAOS; Brooker Classification', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 55 ปี s/p right THA 6 เดือนก่อน ปวด + ยับยั้ง ROM ของ hip ขวา (loss of flexion to 80° from prior 110°) — ankylosing trend

PE: marked decreased ROM, palpable mass around hip

X-ray hip: extensive heterotopic ossification around hip (Brooker grade III — bone islands with < 1 cm between bone surfaces), implants well-fixed'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 70 ปี ปวดเข่าทั้ง 2 ข้าง 8 ปี ค่อย ๆ แย่ลง ปวดตอนเดิน + ขึ้นบันได, BMI 35, FAILED conservative > 2 ปี (PT, NSAIDs, weight loss, steroid injection)

PE: bilateral varus deformity 12°, flexion contracture 10°, ROM 10-100°, crepitation, no instability
HbA1c 7.2%, no significant cardiac/renal disease

X-ray standing: severe bilateral tricompartmental OA (medial > lateral > patellofemoral) — Kellgren-Lawrence IV', '[{"label":"A","text":"Continue conservative indefinitely"},{"label":"B","text":"Bilateral End-Stage Tricompartmental Knee OA Failed Conservative — Total Knee Arthroplasty (TKA)"},{"label":"C","text":"Bilateral simultaneous TKA always preferred"},{"label":"D","text":"Knee arthrodesis first"},{"label":"E","text":"Long-term opioid"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bilateral End-Stage Tricompartmental Knee OA Failed Conservative — Total Knee Arthroplasty (TKA): (1) **TKA indicated** — proven excellent pain relief + function + > 90% 15-year survival; (2) preoperative optimization: HbA1c < 7.5-8 (some centers strict < 7), BMI consideration (some centers BMI > 40 require weight loss but evidence evolving — Obesity Society + AAHKS — BMI not absolute contraindication but increased complication risk), MRSA screening, smoking cessation, dental clearance, medical clearance; (3) **staged vs simultaneous bilateral TKA**: staged (8-12 weeks apart) safer profile (lower mortality + complications); simultaneous in selected healthy patient with adequate support; (4) **surgical technique**: standard PCL-substituting (posterior-stabilized) vs cruciate-retaining design (similar outcomes), patellar resurfacing (controversial), tourniquet + TXA (reduces transfusion 30%), antibiotic prophylaxis cefazolin within 1 hour, periarticular injection (multimodal — reduces opioid); (5) post-op rehabilitation: early WBAT + PT same day (rapid recovery protocols / enhanced recovery after surgery — ERAS), CPM controversial; (6) DVT prophylaxis (aspirin, LMWH, DOAC); (7) multimodal pain management (avoid opioid-only); (8) **outcomes** — excellent pain relief + function in 85-90% (10-15% with persistent unexplained pain — counsel); (9) complications: PJI (1%), DVT/PE, periprosthetic fracture, aseptic loosening, instability, polyethylene wear; (10) **patient education + expectation management** key

---

Primary TKA: gold standard end-stage knee OA failed conservative. > 90% 15-yr survival. Optimize preop (HbA1c, BMI, smoking, MRSA, dental). Staged > simultaneous bilateral generally. PCL-substituting vs cruciate-retaining similar. TXA + tourniquet + multimodal pain + ERAS. 10-15% with persistent unexplained pain — manage expectations.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAHKS; AAOS TKA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'หญิงไทยอายุ 70 ปี ปวดเข่าทั้ง 2 ข้าง 8 ปี ค่อย ๆ แย่ลง ปวดตอนเดิน + ขึ้นบันได, BMI 35, FAILED conservative > 2 ปี (PT, NSAIDs, weight loss, steroid injection)

PE: bilateral varus deformity 12°, flexion contracture 10°, ROM 10-100°, crepitation, no instability
HbA1c 7.2%, no significant cardiac/renal disease

X-ray standing: severe bilateral tricompartmental OA (medial > lateral > patellofemoral) — Kellgren-Lawrence IV'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 52 ปี ปวดเข่าด้านหน้าซ้าย 4 ปี (isolated patellofemoral OA — post-traumatic from prior patellar fracture) ปวดตอนขึ้นบันได + เดินลงทางลาด + นั่งนาน, FAILED conservative 2 ปี

PE: tender patellofemoral joint + retropatellar crepitation, mild Q-angle, no tibiofemoral pain, no instability

X-ray + skyline + MRI: isolated patellofemoral OA, preserved tibiofemoral compartments, severe patellofemoral cartilage loss + osteophyte', '[{"label":"A","text":"Total patellectomy always best"},{"label":"B","text":"patellofemoral arthroplasty (PFA)"},{"label":"C","text":"Arthroscopic debridement first for isolated OA"},{"label":"D","text":"Conservative indefinitely regardless of symptoms"},{"label":"E","text":"Bedrest 6 weeks"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Isolated Patellofemoral Arthritis Failed Conservative — Treatment Options: (1) continued conservative (PT — VMO + hip strengthening + flexibility, NSAIDs, brace, taping, weight loss, activity modification, steroid injection); (2) **arthroscopic debridement** — NOT effective for isolated OA without mechanical symptoms (USPSTF + OARSI against); (3) **patellofemoral arthroplasty (PFA)** — modern indication: isolated patellofemoral OA without tibiofemoral or significant trochlear dysplasia in younger patient; preserves tibiofemoral compartments + cruciate ligaments + meniscus; modern onlay designs (vs older inlay) have better outcomes; (4) **tibial tubercle osteotomy (TTO) — anteromedialization (Fulkerson)** — improves patellofemoral kinematics if maltracking + cartilage damage lateral facet; (5) **TKA** — definitive if isolated PF OA progresses or for older patients (PF OA component of OA); better long-term predictability; (6) **avoid total patellectomy** — historic procedure with poor outcomes (loss of extensor mechanism leverage, persistent pain + weakness); (7) cartilage restoration (microfracture, OATS, ACI/MACI) — selective for focal defects in young; (8) shared decision-making + counsel; (9) patient age + activity level + tibiofemoral status + obesity all factor

---

Isolated patellofemoral OA: options vary. PFA — modern indication for isolated PF OA in younger active patient (preserves rest of joint). TTO anteromedialization for maltracking. TKA definitive for older or progressing OA. AVOID total patellectomy (poor outcomes). Arthroscopic debridement ineffective for pure OA. Cartilage restoration for focal defects.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAOS; Fulkerson PFA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 52 ปี ปวดเข่าด้านหน้าซ้าย 4 ปี (isolated patellofemoral OA — post-traumatic from prior patellar fracture) ปวดตอนขึ้นบันได + เดินลงทางลาด + นั่งนาน, FAILED conservative 2 ปี

PE: tender patellofemoral joint + retropatellar crepitation, mild Q-angle, no tibiofemoral pain, no instability

X-ray + skyline + MRI: isolated patellofemoral OA, preserved tibiofemoral compartments, severe patellofemoral cartilage loss + osteophyte'
  );

commit;

