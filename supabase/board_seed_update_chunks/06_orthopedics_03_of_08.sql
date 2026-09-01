-- ===============================================================
-- UPDATE chunk 3/8: orthopedics (25 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge no reduction"},{"label":"B","text":"Posterior Dislocation Post-THA (within first 6 months — high recurrence risk)"},{"label":"C","text":"Revision THA immediately first dislocation"},{"label":"D","text":"Amputation"},{"label":"E","text":"Steroid injection"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Posterior Dislocation Post-THA (within first 6 months — high recurrence risk): (1) **emergent closed reduction** in ED under sedation (or in OR if difficult/recurrent); evaluate stability through ROM after reduction; (2) post-reduction X-ray confirms concentric; (3) **abduction brace** 6-12 weeks ("hip precautions" — avoid hip flexion > 90°, adduction past midline, internal rotation past neutral — applies posterior approach); (4) PT — strengthening + education; (5) evaluate underlying cause: (a) component malposition (CT — cup anteversion/inclination outside safe zone Lewinnek), (b) impingement, (c) abductor weakness/disruption, (d) leg length discrepancy, (e) cognitive impairment/poor compliance; (6) **recurrent dislocations** (> 2-3) → operative revision options: cup repositioning, larger femoral head, dual mobility implant (lower dislocation), constrained liner (high failure), revision THA; (7) screen infection (CRP, ESR, aspiration ถ้า indicated) — late dislocation could be loosening

---

THA dislocation: 1-3% lifetime. Posterior approach > anterior approach for dislocation risk. Acute: closed reduction + brace + PT + investigate cause (component position, abductor, impingement). Recurrent: operative — cup revision, larger head, dual mobility, constrained liner. Always rule out infection.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 65 ปี s/p left total hip arthroplasty 6 เดือนก่อน หกล้มในห้องน้ำ ปวด hip ซ้ายอย่างรุนแรง

PE: left leg shortened + internally rotated + adducted (posterior dislocation classic), unable to bear weight, NV intact

X-ray pelvis: posterior dislocation of left THA prosthesis, femoral head out of acetabular component posteriorly, no obvious component loosening';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue running with NSAIDs"},{"label":"B","text":"Female Athlete Triad — Compression Side Femoral Neck Stress Fracture"},{"label":"C","text":"Total hip arthroplasty"},{"label":"D","text":"Long-leg cast 12 weeks"},{"label":"E","text":"Steroid injection hip"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Female Athlete Triad — Compression Side Femoral Neck Stress Fracture: (1) **non-weight-bearing crutches** + bed rest until pain-free → progressive WB as tolerated 6-12 weeks; (2) compression side (inferior/medial) — low risk: usually heals with non-op; tension side (superior/lateral) — high risk: percutaneous cannulated screw fixation (3 screws inverted triangle) เพื่อ prevent completion + displacement (catastrophic — AVN, nonunion); (3) **address Female Athlete Triad/RED-S**: nutritional rehabilitation (calorie + calcium + vit D), restore menstrual cycle, treat underlying eating disorder if present — multidisciplinary (sports med, endo, nutrition, psych); (4) DEXA — low BMD common; (5) gradual return to running with biomechanical/training modifications (cadence, volume, surface, footwear); (6) f/u MRI/X-ray; (7) bisphosphonate not first line in young women; (8) education prevention

---

Femoral neck stress fracture: female athletes, military recruits. Tension side (superior) = high risk → surgical fixation. Compression side (inferior) = low risk → non-weight bearing + healing. Always investigate Female Athlete Triad/RED-S (low energy availability + menstrual dysfunction + low BMD). Multidisciplinary management essential.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 22 ปี นักวิ่งระยะไกล ฝึกหนักช่วง 3 เดือน ปวด groin ขวา 6 สัปดาห์ ปวดมากขึ้นเมื่อ weight bear + วิ่ง

Menstrual: amenorrhea 6 months, BMI 17.5
PE: pain on hip internal rotation, antalgic gait, no obvious deformity

X-ray hip: subtle sclerotic line femoral neck superior cortex (compression side initially negative — often subtle)
MRI hip: bone marrow edema + linear hypointense line femoral neck inferior (compression side) — stress fracture
— low-risk compression side';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait 48 hours antibiotic only"},{"label":"B","text":"Open Femoral Shaft Fracture Gustilo IIIA"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Above-knee amputation immediately"},{"label":"E","text":"Cast immobilization only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Open Femoral Shaft Fracture Gustilo IIIA: (1) **ATLS + IV resuscitation**; (2) **IV antibiotic within 1 hour** — cefazolin (Gustilo I-II) or cefazolin + aminoglycoside (Gustilo III) or piperacillin-tazobactam; add penicillin/metronidazole if farm/anaerobic contamination; (3) tetanus prophylaxis update (Tdap + TIG if dirty + > 5 years); (4) **urgent debridement + irrigation in OR within 6-24 hours** (recent evidence — within 24h acceptable if antibiotics started early, prior "6-hour rule" relaxed) — remove all devitalized tissue + foreign material, copious irrigation (saline, low-pressure — high-pressure increases tissue damage); (5) **stabilize fracture** — reamed intramedullary nailing standard for IIIA closed-conversion; external fixation for damage control/grossly contaminated; (6) wound management: primary closure if clean + low tension; otherwise VAC + delayed closure 3-7 days; soft tissue flap for IIIB; (7) repeat debridement q 48-72h until clean; (8) infection prevention — modern infection rate IIIA 5%, IIIB 17%

---

Open fractures: emergency. ABCs → antibiotic within 1h → tetanus → debridement OR (24h acceptable with early abx) → stabilization. Gustilo I-II cefazolin; III add aminoglycoside or piperacillin-tazobactam. Femur IIIA: IM nail standard. Goal: prevent infection. Soft tissue dictates flap need (IIIB) or amputation (IIIC).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 35 ปี motorcycle accident open wound ต้นขาขวา 6 cm with bone exposed + active bleeding

V/S: BP 102/68, HR 118
PE: 6 cm wound thigh anterior + bone protruding, moderate contamination, NV distal intact, no degloving, soft tissue coverage adequate after debridement
Last tetanus > 10 years

X-ray femur: transverse midshaft femoral fracture, open Gustilo type IIIA (wound > 10 cm but adequate soft tissue coverage)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home if pulses palpable"},{"label":"B","text":"vascular assessment essential"},{"label":"C","text":"ACL reconstruction emergent same day"},{"label":"D","text":"Above-knee amputation immediately"},{"label":"E","text":"Cast in extension 12 weeks without imaging"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Knee Dislocation (high-energy, multiligamentous injury) — vascular emergency: (1) emergent reduction (if not spontaneous) under sedation; (2) **vascular assessment essential** — even palpable pulses don''t exclude injury (intimal flap, dissection can thrombose later) — **ABI < 0.9** mandates **CT angiography** (modern standard) or formal angiography; (3) vascular surgery consult — repair intimal flap (resection + interposition vein graft, stenting), 4-compartment fasciotomy after revascularization if ischemia > 6 hours; (4) peroneal nerve injury 25-40% — observe, AFO for foot drop, neurolysis vs grafting if no recovery 3-6 months (poor prognosis); (5) immobilize in extension splint/external fixator for soft tissue rest; (6) **delayed multiligamentous reconstruction** (ACL + PCL + collaterals) 2-3 weeks after soft tissue settles in single stage; (7) DVT prophylaxis; (8) PT post-op intensive 6-12 months

---

Knee dislocation: vascular emergency. 10-30% popliteal artery injury. Even with palpable pulses — ABI < 0.9 → CTA. Delayed thrombosis common (intimal flap). Peroneal nerve injury 25-40%. Multiligamentous reconstruction (ACL+PCL+collaterals) delayed 2-3 weeks. Long rehabilitation. Knee Dislocation = Spontaneously reduced often missed.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 32 ปี รถยนต์ชน knee against dashboard มาห้องฉุกเฉิน ปวด + ผิดรูปเข่าขวาอย่างรุนแรง

V/S: BP 124/78, HR 102
PE: gross deformity knee, palpable pedal pulses (DP, PT) — but ABI 0.7 right (vs 1.0 left), foot warm + capillary refill 2-3 s, decreased sensation lateral leg + dorsum foot (peroneal nerve), unable to dorsiflex foot, no open wound

X-ray + reduction performed → spontaneous reduction noted
CT angiography lower extremity: intimal flap popliteal artery with patent distal flow';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cylinder cast extension 12 weeks"},{"label":"B","text":"Displaced Transverse Patellar Fracture with Disrupted Extensor Mechanism"},{"label":"C","text":"Total patellectomy first"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Steroid injection"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Displaced Transverse Patellar Fracture with Disrupted Extensor Mechanism: (1) **operative ORIF** indicated เพราะ: displacement > 3 mm, articular step > 2 mm, loss of active knee extension; (2) **tension band wiring** (parallel K-wires + figure-of-8 stainless wire over anterior surface) — gold standard for simple transverse; biomechanical conversion tension → compression; high hardware-related complications 30-60% → removal common; (3) modern alternatives — cannulated screws + tension band, anterior plate for comminuted, suture/FiberWire tension band; (4) partial patellectomy + extensor mechanism repair for severely comminuted inferior pole; (5) avoid total patellectomy (loss of extensor mechanism + quadriceps lever); (6) post-op: immobilize in extension brace 2-6 weeks (locked initially, progressive ROM); WBAT in brace; (7) PT — gentle ROM 0-30° early, advance with healing; (8) full ROM + quadriceps strengthening; (9) f/u X-ray for displacement

---

Patellar fracture: extensor mechanism injury. Inability to SLR + displacement/step → ORIF. Tension band wiring classic (hardware removal 60%). Modern — cannulated screws + tension band, plate for comminuted. Avoid total patellectomy. Early ROM with bracing. Non-op for non-displaced + intact SLR.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 55 ปี หกล้มลงเข่าขวา ปวด + บวมเข่าขวา เหยียดเข่าไม่ได้

PE: palpable gap patella, large effusion, unable to perform straight leg raise actively, NV intact

X-ray knee AP/lateral/sunrise: transverse displaced patellar fracture, displacement 5 mm, intra-articular step 2 mm, intact extensor mechanism disrupted';

update public.mcq_questions
set choices = '[{"label":"A","text":"Immediate ORIF same day"},{"label":"B","text":"Schatzker VI Tibial Plateau Fracture + Compartment Syndrome"},{"label":"C","text":"Cast immobilization 12 weeks only"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Amputation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Schatzker VI Tibial Plateau Fracture + Compartment Syndrome: (1) **emergent 4-compartment fasciotomy** of leg (anterior, lateral, deep posterior, superficial posterior) — compartment syndrome must be addressed within 6 hours; (2) **damage control orthopedics — spanning external fixator** across knee to provide initial stability, allow soft tissue to settle, monitor compartments; (3) **delayed definitive ORIF** (10-21 days) after soft tissue recovery (fracture blisters resolve, swelling decreased — wrinkle sign) — dual incision dual plate construct for bicondylar, restore articular congruity + axis + length; (4) bone grafting subchondral defects (autograft, allograft, BMP, calcium phosphate); (5) protected non-weight bearing 10-12 weeks; (6) early ROM with CPM; (7) screen vascular injury (ABI); (8) DVT prophylaxis; (9) high risk post-traumatic OA → counsel; (10) staged approach reduces wound complications (Egol JOT classic)

---

Schatzker VI: high-energy bicondylar + metaphyseal-diaphyseal dissociation. STAGED management: (1) ex-fix + fasciotomy emergent; (2) delayed ORIF after soft tissue (10-21d) — reduces wound infection from 80% → 5%. Compartment syndrome common — vigilance. PT-OA frequent. Goal: anatomic articular, restored axis, soft tissue salvage.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 42 ปี รถยนต์ชน high-energy ปวด + บวมเข่าซ้ายอย่างรุนแรง

PE: massive swelling + ecchymosis, knee deformed, fracture blisters เริ่มมี, tense compartment forearm — wait, leg compartments tense + painful, distal pulses palpable but diminished, sensory intact

X-ray + CT knee: bicondylar tibial plateau fracture + metaphyseal-diaphyseal dissociation + medial split + lateral depression — Schatzker VI
Compartment pressure leg: 42 mmHg';

update public.mcq_questions
set choices = '[{"label":"A","text":"Immediate ORIF same day"},{"label":"B","text":"Pilon Fracture AO/OTA 43-C3 (high-energy intra-articular distal tibia with severe comminution + soft tissue compromise)"},{"label":"C","text":"Cast 12 weeks no surgery"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Below-knee amputation immediately"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pilon Fracture AO/OTA 43-C3 (high-energy intra-articular distal tibia with severe comminution + soft tissue compromise): (1) **damage control — spanning external fixator** across ankle joint (calcaneus + proximal tibia) immediately + fibula ORIF (anatomic plate restores length + alignment as a column); (2) **wait for soft tissue recovery** (10-21 days) — fracture blisters resolve, swelling decreased (wrinkle test) — Sirkin/Egol staged approach reduces wound complication catastrophe (90% → 5%); (3) **definitive ORIF distal tibia** — anatomic plate (medial or anterolateral plate), restore articular congruity + length + alignment + axial deformity correction; bone grafting subchondral defects; (4) non-weight bearing 10-12 weeks; (5) early ankle ROM; (6) DVT prophylaxis; (7) complications: wound dehiscence, infection, post-traumatic OA (high — 30-50%), stiffness, malunion; (8) salvage: ankle arthrodesis if PTOA; (9) primary arthrodesis for irreparable destruction selected

---

Pilon fracture: distal tibia intra-articular high-energy axial load. Soft tissue is the enemy. STAGED protocol: ex-fix + fibula ORIF → wait 10-21d → definitive tibia ORIF. Reduces catastrophic infection. High PTOA risk → counsel. Salvage by ankle arthrodesis.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 40 ปี ตกจากที่สูง 4 เมตร ลงเท้าขวา ปวด + บวม ankle ขวาอย่างรุนแรง

PE: marked swelling + fracture blisters เริ่มเกิดที่ ankle, deformity, NV intact distal, no open wound

X-ray + CT ankle: intra-articular distal tibial fracture (pilon/plafond), comminuted articular surface, metaphyseal extension, fibula fracture also — AO/OTA 43-C3';

update public.mcq_questions
set choices = '[{"label":"A","text":"Long-leg cast 12 weeks plantarflexion"},{"label":"B","text":"Acute Achilles Tendon Rupture (active middle-aged athlete)"},{"label":"C","text":"Discharge no immobilization"},{"label":"D","text":"Above-knee amputation"},{"label":"E","text":"Steroid injection Achilles tendon"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Achilles Tendon Rupture (active middle-aged athlete): (1) **either operative or non-operative — modern evidence (Willits + recent meta-analyses) shows similar re-rupture rate (~4-5%) ถ้า functional rehabilitation + early weight-bearing protocol**; (2) **non-operative (functional rehab)**: equinus cast/boot 2 weeks → progressive heel lift in CAM boot with WBAT, gradual neutral over 6-8 weeks, PT — comparable re-rupture rate vs surgery with proper protocol; (3) **operative (open or percutaneous repair)**: end-to-end repair (Krackow stitches, Bunnell) — slightly lower re-rupture in some studies + faster return to sport in high-level athletes + better push-off strength; risks: wound complications (5-10%), sural nerve injury (percutaneous higher); (4) **delayed presentation (> 4-6 weeks)** or chronic — requires augmentation (FHL transfer, V-Y advancement, allograft); (5) shared decision-making — athlete level, medical comorbidities, surgical risk; (6) DVT risk during immobilization — prophylaxis selective; (7) return to sport 4-6 months

---

Achilles rupture: modern evidence — operative vs non-operative with functional rehab → similar re-rupture (4-5%). Shared decision. Surgery for high-level athletes (push-off strength, faster return). Non-op: equinus → progressive WB in boot 8 wk. Surgery: open or percutaneous repair. Chronic → augmentation (FHL transfer). Thompson test diagnostic.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 38 ปี เล่นแบดมินตัน รู้สึกเหมือนถูกตีหลังเท้า ฟังได้ยินเสียง pop ทันที + ปวด + เดินไม่ได้

PE: palpable gap 4 cm above calcaneus insertion, weakness plantarflexion, positive Thompson test (calf squeeze ไม่ทำให้เกิด passive plantarflexion), able to weak active plantarflexion via FHL/peroneals

US / MRI ankle: complete Achilles tendon rupture 4 cm proximal to calcaneal insertion, gap 3 cm, ends frayed';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cast non-weight bearing 4 weeks only"},{"label":"B","text":"Lisfranc Tarsometatarsal Joint Injury (unstable, displacement > 2 mm, weight-bearing widening + fleck sign)"},{"label":"C","text":"Discharge home no imaging"},{"label":"D","text":"Steroid injection"},{"label":"E","text":"Amputation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Lisfranc Tarsometatarsal Joint Injury (unstable, displacement > 2 mm, weight-bearing widening + fleck sign): (1) **plantar ecchymosis pathognomonic** — high suspicion warranted; (2) X-ray non-WB often misses → **weight-bearing X-ray + comparison views + CT mandatory**; (3) **operative ORIF** for ANY displacement > 2 mm หรือ instability — anatomic reduction critical (any malalignment → PTOA); options: (a) trans-articular screws ("home run screw" 2nd MT base to medial cuneiform + bridge plates), (b) **dorsal bridge plating** (preserves articular cartilage, increasingly preferred), (c) **primary arthrodesis** of 1st-3rd TMT — recent evidence shows lower revision rate + better outcomes for purely ligamentous Lisfranc (Ly + Coetzee JBJS); (4) non-weight bearing 8-12 weeks post-op; (5) hardware removal 4-6 months for non-arthrodesis; (6) **non-operative (cast) only for truly non-displaced + stable** confirmed by weight-bearing imaging and CT; (7) high PTOA rate if missed — late arthrodesis salvage

---

Lisfranc injury: TMT joint complex. Plantar ecchymosis + fleck sign + 2-MT-medial cuneiform widening. Weight-bearing X-ray + CT essential. ANY displacement > 2 mm = surgical. Modern trend: primary arthrodesis for ligamentous Lisfranc (Ly/Coetzee). Bridge plating preserves cartilage. Missed → PTOA → late arthrodesis salvage.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 28 ปี เล่นฟุตบอล ถูกบิดเท้าขวา ปวด midfoot + บวม + เดินลำบาก

PE: midfoot swelling + plantar ecchymosis (Ross sign — pathognomonic), tender TMT joints, painful weight-bearing

X-ray foot AP + oblique + lateral + weight-bearing: widening between 1st-2nd metatarsal base > 2 mm, fleck sign (small avulsion fragment at base 2nd MT from Lisfranc ligament) — Lisfranc injury
Weight-bearing X-ray shows increased gap vs non-weight-bearing
CT confirms instability + small TMT fractures';

update public.mcq_questions
set choices = '[{"label":"A","text":"Immediate ORIF same day extended lateral"},{"label":"B","text":"Sanders III Intra-articular Calcaneal Fracture + Associated Lumbar Injury Screening"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Below-knee amputation"},{"label":"E","text":"Steroid injection"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Sanders III Intra-articular Calcaneal Fracture + Associated Lumbar Injury Screening: (1) **screen associated injuries** — concurrent lumbar burst/compression fracture 10-15%, contralateral calcaneus, talus, knee, tibial plateau — spine X-ray/CT, full secondary survey; (2) elevate, ice, splint, soft tissue rest; (3) **wait for soft tissue recovery** (10-21 days) — fracture blisters resolve, wrinkle test positive; (4) **operative ORIF** for displaced intra-articular (Sanders II-IV) in healthy active patients: (a) **extended lateral approach** + lateral plate — traditional, high wound complication rate 20-30%; (b) **sinus tarsi approach** (less invasive, lower wound complication) — current trend; (5) goals: restore Böhler angle, posterior facet articular congruity, heel height + width + alignment; (6) **non-operative** considered: minimally displaced, smokers, diabetics, peripheral vascular disease, workers compensation (controversial — HEALTH trial showed no difference); (7) non-weight bearing 10-12 weeks; (8) high PTOA rate — counsel; subtalar arthrodesis salvage; (9) DVT prophylaxis

---

Calcaneal fracture: axial load (fall from height). Always screen associated injuries (lumbar burst 10-15%, contralateral, talus, knee). Sanders classification on coronal CT. Operative for displaced intra-articular healthy patient — sinus tarsi approach trending (lower wound complications vs extended lateral). High PTOA → subtalar arthrodesis salvage. Soft tissue rest 10-21d critical.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 35 ปี construction worker ตกจากที่สูง 3 เมตร ลงเท้าทั้งสองข้าง ปวด heel ทั้งสองข้าง + บวมมาก

PE: bilateral heel swelling + ecchymosis (Mondor sign — plantar arch ecchymosis), heel width increased, varus deformity, fracture blisters appearing
Neurovascular intact, check sensation tibial nerve
Check spine — frequently associated lumbar burst fracture

CT calcaneus: intra-articular calcaneal fracture, depressed posterior facet > 3 mm step, displacement of tuberosity fragment, Böhler angle reduced to 5° — Sanders type III';

update public.mcq_questions
set choices = '[{"label":"A","text":"Emergent surgery same day"},{"label":"B","text":"Acute Lumbar Radiculopathy L4-L5 Disc Herniation Without Red Flags"},{"label":"C","text":"Long-term opioid 6 months"},{"label":"D","text":"Bedrest 6 weeks strict"},{"label":"E","text":"Spinal fusion immediately"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Lumbar Radiculopathy L4-L5 Disc Herniation Without Red Flags: (1) **non-operative trial 6-12 weeks first** — natural history favorable, 80-90% improve; (2) education + reassurance + activity modification (avoid prolonged sitting + heavy lifting แต่ encourage maintaining activity, no bed rest > 1-2 days); (3) **physical therapy** — directional preference (McKenzie extension), core stabilization, nerve mobilization; (4) pharmacologic: NSAIDs first line; short course oral steroid (limited evidence — consider in severe radicular pain); gabapentin/pregabalin for neuropathic pain; acetaminophen; avoid long-term opioids; (5) **epidural steroid injection** (transforaminal) — moderate evidence for short-term radicular pain relief, considered if persistent severe pain despite conservative; (6) **surgical microdiscectomy** ถ้า: failure of 6-12 weeks conservative + persistent radicular pain + correlating imaging + neurologic deficit (progressive motor weakness, intractable pain affecting QoL); urgent surgery for: cauda equina syndrome, progressive motor deficit; (7) SPORT trial — surgery faster recovery แต่ similar 2-yr outcomes vs conservative; (8) f/u red flags education

---

Lumbar radiculopathy from HNP: 80-90% resolve with conservative. Trial 6-12 weeks. PT + NSAIDs + ESI selective. Surgery for failed conservative or red flags (CES, progressive deficit). SPORT trial — faster recovery with surgery but similar 2-year outcomes. Microdiscectomy gold standard.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 38 ปี ออฟฟิศ ปวดหลังร้าวลงขาขวา 4 สัปดาห์ ปวดมากขึ้นนั่งนาน + ก้ม + ไอ จาม
ไม่มี bowel/bladder dysfunction

PE: positive straight leg raise right at 40°, weakness EHL right 4/5, decreased pinprick L5 dermatome dorsum foot, reflexes preserved

MRI L-spine: paracentral right disc herniation L4-L5 compressing exiting L5 nerve root, no other levels significantly affected, no cord/cauda compression';

update public.mcq_questions
set choices = '[{"label":"A","text":"Emergent fusion same day"},{"label":"B","text":"Acute Cervical Radiculopathy C6 from C5-C6 Disc Herniation Without Myelopathy"},{"label":"C","text":"Long-term cervical traction at home"},{"label":"D","text":"Discharge no follow-up"},{"label":"E","text":"Long-term opioid"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Cervical Radiculopathy C6 from C5-C6 Disc Herniation Without Myelopathy: (1) **non-operative trial 6-12 weeks** — favorable natural history, 75-90% improve; (2) education + activity modification (avoid provocative posture, ergonomics); (3) PT — gentle ROM, isometric strengthening, traction (cervical), nerve glides, postural; (4) NSAIDs, short oral steroid trial, gabapentin/pregabalin for neuropathic pain; (5) soft cervical collar limited (deconditioning if prolonged); (6) **cervical epidural steroid injection** (interlaminar approach in cervical — transforaminal risk vascular injury/stroke) for severe persistent pain; (7) **surgical decompression** indications: failed conservative + persistent radicular pain + corresponding imaging + neurologic deficit; OR myelopathy; OR progressive motor weakness — options: **anterior cervical discectomy and fusion (ACDF)** — gold standard, or **cervical disc arthroplasty (CDA)** — motion-preserving alternative for single-level non-osteoporotic patients, or posterior foraminotomy (lateral herniation, preserves motion); (8) ACDF vs CDA — comparable outcomes; CDA may reduce adjacent segment disease

---

Cervical radiculopathy: trial conservative 6-12 weeks. Spurling test sensitive. ACDF gold standard for failed conservative. CDA motion-preserving alternative (single-level, young, no osteoporosis). Posterior foraminotomy for lateral herniation. Avoid transforaminal ESI cervical (stroke risk). Watch for myelopathy.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 45 ปี ปวดคอร้าวลงแขนซ้าย 3 สัปดาห์ ปวดมากขึ้นเมื่อ extension + lateral bend ซ้าย ชาปลายนิ้วโป้ง + ชี้ + กลาง อ่อนแรง biceps + brachioradialis

PE: positive Spurling test (head extension + rotation toward ipsilateral side reproduces pain), weakness biceps 4/5, decreased biceps reflex, decreased sensation C6 dermatome (thumb + index)

MRI C-spine: left paracentral C5-C6 disc herniation compressing exiting C6 root, no cord compression, no signal change cord';

update public.mcq_questions
set choices = '[{"label":"A","text":"Conservative 6-week trial"},{"label":"B","text":"Cauda Equina Syndrome (CES) — Surgical Emergency"},{"label":"C","text":"Discharge home with NSAIDs"},{"label":"D","text":"Bedrest 2 weeks reassessment"},{"label":"E","text":"Steroid injection only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cauda Equina Syndrome (CES) — Surgical Emergency: (1) **emergent surgical decompression within 24-48 hours** (some advocate < 24h, others < 48h — meta-analyses suggest earlier surgery → better neurologic recovery especially bladder function, but "as soon as feasible" key); (2) **wide laminectomy + decompression + discectomy** of offending herniation; preserve as much bone as needed for stability; instrumentation if instability; (3) NPO + IV + Foley catheter; (4) detailed neurologic + perineal exam + bladder scan (post-void residual > 200 mL highly suspicious); (5) **MRI lumbar emergent** definitive imaging; CT myelogram if MRI contraindicated; (6) urology consult — bladder function monitoring; (7) post-op: rehabilitation, monitor bowel/bladder/sexual function; many residual deficits even with timely surgery — counseling; (8) document carefully for medicolegal — CES common litigation; (9) etiologies: massive disc herniation (most common), tumor, epidural abscess, hematoma, trauma — treatment differs

---

Cauda equina syndrome: surgical emergency. Triad — bilateral leg pain/weakness, saddle anesthesia, bladder/bowel dysfunction. PVR > 200 mL sensitive. MRI emergent. Decompression < 24-48h (earlier = better outcomes especially bladder). Even with timely surgery — residual deficits common. CES = high medicolegal risk — document carefully.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 42 ปี ปวดหลังร้าวลงขาทั้ง 2 ข้าง 1 สัปดาห์ วันนี้เริ่ม urinary retention + saddle anesthesia + ขาอ่อนแรงทั้งสองข้าง

V/S: ปกติ
PE: bilateral lower extremity weakness 3/5 distal, decreased perianal + saddle sensation, decreased anal tone, post-void residual 600 mL on bladder scan, decreased Achilles + patellar reflex bilateral

MRI L-spine: large central disc herniation L4-L5 with severe canal stenosis compressing cauda equina, all roots distorted';

update public.mcq_questions
set choices = '[{"label":"A","text":"Emergent fusion all levels"},{"label":"B","text":"Symptomatic Multilevel Lumbar Spinal Stenosis (Neurogenic Claudication)"},{"label":"C","text":"Bedrest 6 weeks"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Long-term opioid as first line"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Symptomatic Multilevel Lumbar Spinal Stenosis (Neurogenic Claudication): (1) **conservative first-line**: PT (flexion-based exercises, core stabilization, aerobic conditioning — stationary bike often tolerated better than walking), NSAIDs, weight loss, gabapentin/pregabalin selective; (2) **epidural steroid injection** — moderate short-term benefit (recent evidence — LESS trial showed modest effect); (3) avoid long-term opioids; (4) **surgical decompression** (laminectomy ± foraminotomy ± medial facetectomy) indicated: failure of 3-6 months conservative + significant functional limitation + corresponding imaging; SPORT trial — surgery superior to conservative at 2-4 years for stenosis; (5) **fusion added** only if: degenerative spondylolisthesis with instability, scoliosis with imbalance, iatrogenic instability from decompression; SLIP trial — fusion not superior to decompression alone for stable degenerative spondylolisthesis (controversial); (6) interspinous spacer minimal role current; (7) elderly — surgery often well-tolerated; counsel realistic outcomes (back pain may persist); (8) DDx: vascular claudication (improves with rest standing, ABI < 0.9) — differentiate

---

Lumbar spinal stenosis: degenerative, elderly. Neurogenic claudication — improves with flexion (shopping cart sign). Conservative first (PT, NSAIDs, ESI). Surgery (laminectomy) for failed conservative — SPORT trial supports. Fusion adds risk — reserved for instability/spondylolisthesis/scoliosis (SLIP trial). Differentiate from vascular (ABI).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 70 ปี ปวดหลัง + ปวดร้าวลงขาทั้ง 2 ข้าง เมื่อยืน + เดิน > 5 นาที พักนั่ง/ก้ม → ดีขึ้น 2 ปี วันนี้เดินได้น้อยลง

PE: positive shopping cart sign (improvement with flexion), no significant motor weakness, mildly decreased Achilles reflex, normal vascular exam, normal ABI

MRI L-spine: multilevel central + lateral recess stenosis L3-L4 + L4-L5, ligamentum flavum hypertrophy, facet arthropathy, no instability on flexion-extension X-ray';

update public.mcq_questions
set choices = '[{"label":"A","text":"Conservative observation always"},{"label":"B","text":"Cervical Spondylotic Myelopathy (CSM) with Cord Signal Change"},{"label":"C","text":"Cervical traction long term"},{"label":"D","text":"Long-term opioid"},{"label":"E","text":"Steroid injection only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cervical Spondylotic Myelopathy (CSM) with Cord Signal Change: (1) **surgical decompression generally recommended** (AOSpine CSM guidelines) — natural history of moderate-severe myelopathy → progressive deterioration; even mild myelopathy with signal change favors surgery; (2) approach depends on: number of levels, cervical alignment (lordosis vs kyphosis), location of compression: (a) **anterior cervical discectomy and fusion (ACDF)** for 1-2 levels anterior compression; (b) anterior cervical corpectomy + fusion for retrovertebral pathology; (c) **posterior laminectomy + fusion** for multilevel (≥ 3) with preserved lordosis; (d) **laminoplasty** for multilevel with preserved lordosis, motion-preserving alternative to laminectomy + fusion; (4) avoid posterior approach if cervical kyphosis (won''t decompress); (5) goals: prevent progression, modest improvement (don''t promise return to normal); (6) post-op: collar, PT, gradual return; (7) mJOA score for severity (mild ≥ 15, moderate 12-14, severe < 12) — surgery indicated for moderate-severe; mild controversial — surgery vs structured monitoring

---

Cervical myelopathy: insidious. UMN signs (hyperreflexia, Hoffmann, Babinski, clonus), gait imbalance, hand clumsiness. AOSpine guidelines: surgery for moderate-severe CSM (mJOA < 15). Anterior (1-2 levels) vs posterior (≥ 3 levels with lordosis: laminoplasty/laminectomy + fusion). Kyphosis precludes posterior approach. Goal: prevent progression.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 62 ปี ค่อย ๆ มีอาการเดินไม่มั่นคง 6 เดือน + ลำบากในการใช้มือ (ติดกระดุม เขียนแย่ลง) + ชาปลายมือทั้งสองข้าง ไม่มี neck pain ชัดเจน

PE: hyperreflexia BJ + KJ + AJ bilateral, positive Hoffmann''s sign bilateral, positive Babinski bilateral, wide-based unsteady gait, +Lhermitte sign with neck flexion, decreased pinprick distal hand bilateral

MRI C-spine: multilevel cervical spondylosis with severe canal stenosis C4-C5 + C5-C6 + C6-C7 with cord compression + T2 myelomalacia signal change';

update public.mcq_questions
set choices = '[{"label":"A","text":"High-dose methylprednisolone NASCIS protocol mandatory"},{"label":"B","text":"Acute Cervical Spinal Cord Injury C5 ASIA A + Neurogenic Shock + Spinal Shock"},{"label":"C","text":"Conservative cervical collar 12 weeks no surgery"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Bedrest only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Cervical Spinal Cord Injury C5 ASIA A + Neurogenic Shock + Spinal Shock: (1) **ATLS** + airway protection (C5 level — phrenic preserved but high cervical can lose diaphragm) + early intubation if signs respiratory failure (FVC < 15 mL/kg); (2) **neurogenic shock management** — IV fluids cautiously + vasopressors (norepinephrine) — MAP target 85-90 mmHg × 5-7 days (improves spinal cord perfusion + neurologic outcome per AANS/CNS guidelines); atropine for symptomatic bradycardia; (3) **immobilization** — rigid cervical collar + spine board (remove from board within 2 hours — pressure ulcer); (4) avoid hypotension + hypoxia (secondary injury); (5) **methylprednisolone NOT routinely recommended** anymore (NASCIS trials weak evidence + complications — AANS/CNS guidelines against); selective use within 8h is at clinician discretion; (6) **MRI + CT** — definitive characterization; (7) **early surgical decompression + stabilization** (within 24 hours when safe) — STASCIS trial → better neurologic recovery (2-grade improvement) with early surgery; (8) DVT prophylaxis (mechanical immediate, LMWH 24-72h after surgery); stress ulcer prophylaxis; bladder catheter; bowel program; PT/OT early; (9) acute SCI multidisciplinary team (rehab/SCI center transfer); (10) prognosis ASIA A complete — poor for ambulation

---

Acute SCI: ATLS + immobilization + MAP 85-90 (improves perfusion) + early decompression < 24h (STASCIS — improved recovery). Methylprednisolone no longer routine (controversial, AANS/CNS against). Neurogenic shock (hypotension + bradycardia from sympathetic loss) — fluids + vasopressors + atropine. Multidisciplinary team. ASIA A — poor prognosis recovery.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 22 ปี กระโดดน้ำตื้น head-first โดน head ปวดคอ + ขยับแขน-ขาไม่ได้ทันที

V/S: BP 78/40, HR 50, RR 14
PE: motor — biceps weak 2/5, no triceps/wrist flexion/hand intrinsics; no LE movement; no perianal sensation; no voluntary anal contraction; no rectal tone — ASIA A C5 level; warm dry skin (neurogenic shock)

CT C-spine: C5 burst fracture + retropulsion fragment + 60% canal compromise
MRI C-spine: spinal cord contusion C5 level + T2 hyperintensity, no transection seen';

update public.mcq_questions
set choices = '[{"label":"A","text":"Emergent fusion same day"},{"label":"B","text":"Acute Osteoporotic Vertebral Compression Fracture (T12) Without Neurologic Compromise"},{"label":"C","text":"Long-term opioid only"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Bedrest 6 weeks"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Osteoporotic Vertebral Compression Fracture (T12) Without Neurologic Compromise: (1) **conservative first-line 4-8 weeks** — most heal spontaneously: pain control (acetaminophen + scheduled, NSAIDs short course caution elderly, calcitonin nasal spray for early analgesia), bracing (TLSO) for comfort + early mobilization, PT for posture + back extensor strengthening (after pain controlled); (2) avoid bedrest (deconditioning); (3) **vertebroplasty/kyphoplasty controversial** — recent RCTs (VERTOS IV, INVEST, VAPOUR mixed) — guidelines (AAOS, ACR) suggest selective use: persistent severe pain failing conservative > 4-6 weeks, painful subacute fracture with bone marrow edema on MRI; not for asymptomatic, healed, or chronic painful fractures; (4) **always treat osteoporosis** (secondary fracture prevention): DEXA, **calcium 1200 mg + vit D 800-1000 IU**, bisphosphonate (alendronate, zoledronate IV), or denosumab, or anabolic (teriparatide, romosozumab) for severe; (5) screen secondary causes (multiple myeloma — SPEP, mets); (6) fall prevention; (7) rule out malignancy: history, MRI features (epidural mass, pedicle destruction, soft tissue), inflammatory markers; (8) multidisciplinary geriatric care

---

Osteoporotic VCF: very common in elderly. Most heal conservatively (4-8 weeks) — analgesics + bracing + early mobilization. Vertebroplasty/kyphoplasty controversial — selective for persistent pain failing conservative + acute MRI edema. ALWAYS treat osteoporosis (bisphosphonate, anabolics) + screen malignancy. Fall prevention. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 76 ปี postmenopause ก้มเก็บของแล้วปวดหลังกลางอย่างรุนแรง 2 สัปดาห์ ปวดมากขึ้นเมื่อขยับ + นั่ง ไม่ปวดร้าวลงขา ไม่มี neurologic deficit

PE: tender T12 spinous process + paraspinal, kyphosis เพิ่มขึ้น, normal motor + sensory + reflexes, no saddle anesthesia

X-ray spine: wedge compression fracture T12 with anterior height loss 30%, no retropulsion, no posterior wall involvement
MRI: bone marrow edema T12 (acute fracture vs subacute), no malignancy features';

update public.mcq_questions
set choices = '[{"label":"A","text":"TLSO brace only without imaging abdomen"},{"label":"B","text":"Lumbar Chance Fracture (Flexion-Distraction Injury) + Concurrent Intra-abdominal Injury"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Conservative bedrest 12 weeks"},{"label":"E","text":"Emergent cervical fusion"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Lumbar Chance Fracture (Flexion-Distraction Injury) + Concurrent Intra-abdominal Injury: (1) **screen abdominal injury essential** — 50% of Chance fractures have hollow viscus injury (small bowel, mesentery, pancreas) — general surgery consult, CT abdomen with contrast, serial exam; (2) **unstable injury** (3-column disruption ferentially per Denis — or AO Spine type B distraction) — operative stabilization indicated; (3) **posterior instrumented fusion + reduction** (pedicle screw + rod construct typically 1-2 levels above + below) — restore lordosis + alignment; (4) **bony Chance** (through bone only — Smith fracture) may heal with bracing (TLSO/CASH brace 12 weeks) — selective; **ligamentous Chance** does not heal → always operative; (5) MRI essential to assess posterior ligamentous complex (PLC); (6) thoracolumbar injury classification (TLICS) score guides — Chance scores 4-6+ → surgery; (7) DVT prophylaxis; (8) post-op early mobilization in TLSO; (9) screen aortic injury upper thoracic; pancreatic with elevated lipase

---

Chance fracture: flexion-distraction (seatbelt). 3-column disruption typically. ALWAYS screen abdominal injury (50% hollow viscus). Ligamentous → operative (does not heal). Bony Chance — bracing selective. Posterior instrumented fusion. TLICS score guides. PLC assessed by MRI.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 35 ปี seatbelt-wearing passenger รถยนต์ชน หลังหัวซน head-on ปวดหลังกลาง + bruise belt-mark across abdomen + lap

V/S: BP 110/72, HR 105, abdomen mildly tender
PE: midline back tenderness L2, no neurologic deficit, palpable gap posterior elements L2, ecchymosis abdomen seatbelt distribution

CT spine: transverse fracture through L2 vertebral body + pedicles + posterior elements (flexion-distraction Chance fracture)
CT abdomen: small bowel mesenteric injury + free fluid — concurrent hollow viscus injury

MRI: posterior ligamentous complex disruption';

update public.mcq_questions
set choices = '[{"label":"A","text":"Conservative cervical collar 12 weeks"},{"label":"B","text":"Subaxial Cervical Burst Fracture C5 with Incomplete SCI (ASIA C — sacral sparing)"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Bedrest indefinitely"},{"label":"E","text":"Methylprednisolone NASCIS only no surgery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Subaxial Cervical Burst Fracture C5 with Incomplete SCI (ASIA C — sacral sparing): (1) **ATLS + cervical immobilization** + MAP 85-90 × 5-7 days (cord perfusion); (2) **early surgical decompression + stabilization < 24 hours** (STASCIS — improved recovery especially incomplete injuries); (3) **anterior cervical corpectomy + reconstruction + plate** typically (removes retropulsed fragment + reconstructs anterior column); ± posterior instrumentation for additional stability if 3-column instability, posterior element fractures, facet dislocation, severe kyphosis ("360° approach"); (4) closed reduction with traction (Gardner-Wells tongs, Crutchfield) considered for facet dislocation BEFORE MRI in awake cooperative patient with neurologic exam; controversial — many institutions get MRI first to rule out disc herniation; (5) SLIC score (subaxial cervical injury classification) guides surgery (score ≥ 5); (6) **avoid steroids routinely**; (7) rehab + SCI center transfer; sacral sparing favorable for some recovery; (8) DVT prophylaxis; (9) screen vertebral artery injury (CTA — present in 30% cervical fractures, especially facet/foramen transversarium)

---

Subaxial cervical burst + incomplete SCI: ATLS + immobilization + early decompression < 24h. Anterior corpectomy + reconstruction typical; combined 360° for instability. MAP 85-90 cord perfusion. SLIC score guides. Sacral sparing = incomplete injury = better prognosis. Vertebral artery injury screen with CTA. Steroids no longer routine.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 24 ปี กระโดดน้ำตื้น ปวดคอ + แขน-ขาทั้ง 4 อ่อนแรง partial

PE: motor C5 grade 3/5, C6 2/5, C7 2/5, C8/T1 1/5, lower extremity 2/5; sacral sparing — perianal sensation + voluntary anal contraction preserved — ASIA C; sensation diminished below C5

CT C-spine: C5 burst fracture + 50% retropulsion + posterior element fractures + facet subluxation
MRI: cord compression + edema C5 level, no transection';

update public.mcq_questions
set choices = '[{"label":"A","text":"Conservative bedrest 12 weeks only"},{"label":"B","text":"Thoracolumbar Burst Fracture with Incomplete Neurologic Injury + PLC Disruption — TLICS High Score → Surgical"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Cervical fusion same day"},{"label":"E","text":"Steroid injection"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Thoracolumbar Burst Fracture with Incomplete Neurologic Injury + PLC Disruption — TLICS High Score → Surgical: (1) **TLICS score**: burst (2) + incomplete neuro (3) + PLC disruption (3) = 8 → surgical; (2) **AO Spine TL classification**: A4 (complete burst) + neurology + PLC = surgery; (3) **posterior instrumented fusion + decompression** typical approach (pedicle screws 1-2 levels above + below, with indirect reduction by ligamentotaxis); (4) anterior approach (corpectomy + cage + plate) for severe anterior column comminution + retropulsion not addressable posteriorly; (5) combined approach for severe injury; (6) post-op TLSO 8-12 weeks selective; (7) **stable burst** (no PLC, no neurologic) — controversial — non-operative bracing (TLSO 8-12 weeks) acceptable per multiple RCTs (Wood, Bailey); (8) DVT prophylaxis; (9) rehabilitation; (10) bowel/bladder monitoring (conus medullaris — micturition concern); (11) urology consult; (12) screen associated injuries (calcaneus 10%, contralateral fractures, head/abdomen)

---

Thoracolumbar burst: TLICS score guides (≥ 5 surgical). Burst + neurology + PLC disruption → surgery. Posterior instrumented fusion typical; anterior for severe anterior column. Stable burst without neuro/PLC → TLSO acceptable. Screen calcaneal + associated injuries. Conus injury → bowel/bladder concern.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 28 ปี ตกจากที่สูง 5 เมตร ปวดหลัง + ขา 2 ข้าง weakness บางส่วน

PE: midline tenderness L1, motor L2 4/5, L3 4/5, L4 4/5, L5 3/5 (incomplete neurologic injury), preserved sacral sensation + voluntary anal contraction, no saddle anesthesia

CT spine: L1 burst fracture with 50% retropulsion + 50% canal compromise + 30% vertebral body height loss + 20° kyphosis
MRI L-spine: cord/conus compression + edema, posterior ligamentous complex (PLC) — disrupted (high T2 signal)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Immediate fusion all patients"},{"label":"B","text":"Adolescent Isthmic Spondylolisthesis L5-S1 Meyerding II (25-50% slip) — Pars Defect from Repetitive Hyperextension"},{"label":"C","text":"Discharge no treatment"},{"label":"D","text":"Long-term opioid"},{"label":"E","text":"Bedrest 6 months"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adolescent Isthmic Spondylolisthesis L5-S1 Meyerding II (25-50% slip) — Pars Defect from Repetitive Hyperextension: (1) **non-operative trial 6-12 weeks first** ส่วนใหญ่ — most cases respond: activity modification (avoid hyperextension sports temporarily — gymnastics, diving, football lineman), PT — core stabilization + hamstring flexibility + Williams flexion exercises (avoid extension), NSAIDs, TLSO bracing controversial; (2) **stress reaction (early — bone marrow edema on MRI/SPECT)** treated aggressively — bracing 3-6 months + activity restriction may heal pars; chronic established defect → no healing expected; (3) **surgery indicated**: failure of 6-12 months conservative + persistent significant pain + progression of slip + neurologic deficit + significant slip > 50% (high-grade Meyerding III-V) + slip progression; (4) options: (a) **pars repair** (Buck''s screw, Scott wiring, pedicle screw + hook) for young patient + isolated pars defect + no disc degeneration + low slip; (b) **L5-S1 fusion** (instrumented PLIF/TLIF or in situ) for higher-grade or chronic; reduction of high-grade controversial (L5 nerve root injury risk); (5) avoid contact sports until healed/recovered

---

Isthmic spondylolisthesis: pars defect from repetitive hyperextension (gymnasts, divers, football). Adolescent — most respond conservative (PT, activity modification, bracing). Pars repair for young + isolated defect. L5-S1 fusion for high-grade or failed conservative. Reduction of high-grade controversial (L5 root injury).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 17 ปี นักกีฬายิมนาสติก ปวดหลังเรื้อรัง 6 เดือน ปวดมากขึ้นเมื่อ extension + ปวดร้าวลงขาทั้ง 2 ข้าง

PE: palpable step-off L5-S1 spinous process, hyperlordosis, hamstring tightness, no motor deficit, normal reflexes

X-ray L-spine lateral + standing: pars defect L5 + L5-S1 forward slip 35% (Meyerding II — "Scotty dog with collar" — pars defect at neck)
MRI: L5 pars defect bilateral + L5-S1 disc degeneration mild, no significant root compression';

update public.mcq_questions
set choices = '[{"label":"A","text":"Oral antibiotics outpatient"},{"label":"B","text":"Spinal Epidural Abscess + Vertebral Osteomyelitis with Cord Compression — Surgical Emergency"},{"label":"C","text":"Bedrest no antibiotics"},{"label":"D","text":"Discharge with NSAIDs"},{"label":"E","text":"Steroid injection epidural"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Spinal Epidural Abscess + Vertebral Osteomyelitis with Cord Compression — Surgical Emergency: (1) **emergent surgical decompression** (laminectomy + abscess drainage ± instrumented fusion if instability) — especially with neurologic deficit: better neurologic outcomes with early surgery + drainage vs medical alone; (2) **empirical IV broad-spectrum antibiotics** after blood culture + intra-op culture obtained: vancomycin (MRSA in IV drug user) + ceftriaxone/cefepime (gram-negative) — tailor to culture; S. aureus most common pathogen; (3) IV antibiotic duration **6-8 weeks minimum** (extending to 3 months in some); (4) blood culture × 2-3 before antibiotic; CT-guided biopsy/aspiration if no surgery; (5) screen sepsis source + endocarditis (echocardiogram — S. aureus bacteremia mandates), other foci; (6) supportive ICU care, hemodynamic; (7) ID consult; (8) consider HIV/HCV testing IV drug user; (9) addiction medicine; (10) non-operative selective: no neurologic deficit, small abscess without cord compression, multiple medical comorbidities + good response to antibiotic — close monitoring + repeat MRI; (11) complications: residual neurologic deficit, recurrence, sepsis, death (5-20%)

---

Spinal epidural abscess: emergency. Triad — fever, back pain, neurologic deficit. Risk factors: IV drugs, DM, immunocompromise, recent procedure. MRI + Gd diagnostic. Emergent decompression + drainage for neurologic compromise + IV antibiotics 6-8 weeks. S. aureus most common. Screen endocarditis. Mortality 5-20%.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 55 ปี IV drug user ไข้ + ปวดหลังกลาง 5 วัน + วันนี้เริ่มอ่อนแรงขาทั้ง 2 ข้าง + ปัสสาวะลำบาก

V/S: BP 110/70, HR 110, Temp 39.0°C
PE: midline tenderness T8-T9 percussion, motor LE 3/5 bilateral, hyperreflexia LE, +Babinski, decreased perianal sensation

Lab: WBC 18,500 (PMN 88%), CRP 280, ESR 110, blood culture × 2 — pending
MRI T-spine + Gd: epidural abscess T8-T9 + cord compression + osteomyelitis vertebral body + adjacent discitis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Emergent fusion same day no workup"},{"label":"B","text":"Symptomatic Adult Degenerative Scoliosis with Sagittal Imbalance + Radiculopathy"},{"label":"C","text":"Discharge no treatment"},{"label":"D","text":"Bedrest 6 months"},{"label":"E","text":"Long-term opioid"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Symptomatic Adult Degenerative Scoliosis with Sagittal Imbalance + Radiculopathy: (1) **conservative trial first**: PT (core strengthening, postural training, aerobic), NSAIDs, weight management, bracing limited (selective); ESI for radicular pain selective; (2) **counseling realistic expectations** — back pain may not fully resolve even with surgery; (3) **surgical indications**: failure of 6-12 months conservative + significant functional limitation + neurologic deficit + progressive deformity + intractable pain; (4) **goals**: decompression of symptomatic levels + correction of sagittal + coronal balance + stable fusion; (5) **complex surgery — long instrumented posterior fusion** ± osteotomies (Smith-Petersen osteotomy, pedicle subtraction osteotomy — PSO, vertebral column resection — VCR) ± interbody fusion (TLIF/LLIF/ALIF) to restore lumbar lordosis + correct PI-LL mismatch; (6) high complication rate (30-50% — wound, infection, hardware failure, PJK proximal junctional kyphosis, dural tear, neurologic, medical), high revision rate; (7) careful patient selection — comorbidity optimization (cardiac, DEXA → osteoporosis Rx, nutrition, smoking cessation); (8) restoration of sagittal balance (SVA < 5 cm, PI-LL < 10°, PT < 25°) most important predictor of outcome (Schwab/Lafage); (9) minimally invasive options selective

---

Adult degenerative scoliosis: conservative first. Surgery for failed conservative + functional limitation. Goals: decompression + sagittal/coronal balance + fusion. Long posterior fusion + osteotomies (PSO, VCR). Restoration of sagittal balance (SVA, PI-LL) critical predictor. High complication + revision rate — careful patient selection.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 68 ปี ปวดหลัง + ขาขวา 1 ปี ปวดมากขึ้นเรื่อย ๆ + รู้สึกเอียงตัว + เดินไกลไม่ได้ + ไม่สามารถยืนตรงได้

PE: lumbar coronal imbalance (truncal shift), hyperkyphosis, sagittal imbalance (positive sagittal vertical axis), right L4 radiculopathy (weakness EHL 4/5)

X-ray standing scoliosis: degenerative lumbar scoliosis Cobb 35° (L1-L4), sagittal vertical axis +9 cm (normal < 5 cm), pelvic incidence-lumbar lordosis mismatch (PI-LL) 25° (normal < 10°)
MRI: L3-L4, L4-L5 stenosis + lateral recess compression, multilevel disc degeneration';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation only no intervention"},{"label":"B","text":"Adolescent Idiopathic Scoliosis (AIS) Right Thoracic Curve 32° + Skeletally Immature (Risser 1) — High Progression Risk"},{"label":"C","text":"Surgery immediately at 32°"},{"label":"D","text":"Long-term opioid"},{"label":"E","text":"Bedrest until maturity"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adolescent Idiopathic Scoliosis (AIS) Right Thoracic Curve 32° + Skeletally Immature (Risser 1) — High Progression Risk: (1) **bracing indicated** — Cobb 25-45° + skeletally immature (Risser 0-2, premenarchal/early): underarm thoracolumbosacral orthosis (TLSO — Boston brace, Wilmington, Charleston nighttime); (2) **brace 16-23 hours/day** — wear time correlates with success (BrAIST trial NEJM 2013 — bracing significantly reduces progression to surgical threshold from 48% → 28%); (3) PT exercise (Schroth method) adjunct; (4) follow up X-ray every 4-6 months until skeletal maturity (Risser 5 + 2 years post-menarchal); (5) **surgical posterior spinal fusion** indicated when: Cobb > 45-50° + skeletally immature, OR > 50° at skeletal maturity (continues to progress in adulthood 1°/year) — pedicle screw construct + selective fusion based on Lenke classification, restore alignment + balance; (6) screen secondary causes: full neurologic exam, MRI if atypical (left thoracic, rapid progression, neurologic findings, pain — all atypical for AIS) — congenital, neuromuscular, syrinx, Chiari; (7) genetic counseling — familial component but no clear inheritance; (8) reassurance — AIS does not generally affect pulmonary function unless curve > 80-90° thoracic

---

AIS: most common scoliosis. Bracing for 25-45° skeletally immature (BrAIST trial — effective, 16-23h/day). Posterior spinal fusion for > 45-50° immature or > 50° at maturity. Screen atypical features (left thoracic, neurologic, pain) → MRI. Skeletal maturity tracked by Risser sign + menarche. Lenke classification guides fusion levels.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'เด็กหญิงอายุ 12 ปี mother สังเกตเห็นหลังคด ไม่ปวดหลัง ไม่มี neurologic symptoms ประจำเดือนยังไม่มา (Risser stage 1) Tanner stage III

PE: positive Adams forward bend test — right thoracic prominence (scoliometer 9°), shoulder asymmetry, normal motor/sensory, no café-au-lait, no midline cutaneous lesion

X-ray standing scoliosis: right thoracic curve Cobb 32° T6-T11, left lumbar 18° T11-L3, no neurologic asymmetry, no congenital anomaly, Risser 1, open triradiate cartilage';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Acute Cervical Unilateral Facet Dislocation + Incomplete SCI"},{"label":"C","text":"Conservative cervical collar 12 weeks without imaging"},{"label":"D","text":"Methylprednisolone NASCIS only"},{"label":"E","text":"Lumbar laminectomy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Cervical Unilateral Facet Dislocation + Incomplete SCI: (1) **ATLS + cervical immobilization** + MAP 85-90 × 5-7 days; (2) **MRI first** to rule out concomitant disc herniation (some institutions reduce first in awake cooperative patient with serial neurologic exam — controversial; modern protocol typically MRI first if available promptly); (3) **closed reduction with cervical traction** (Gardner-Wells tongs, sequential weight addition with neuro check) in awake cooperative patient with monitoring — if no traumatic disc herniation; (4) **open reduction + posterior cervical fusion** if closed fails, or if traumatic disc herniation present (anterior discectomy + fusion first then posterior); (5) **circumferential 360° fusion** for highly unstable injury or bilateral facet dislocation; (6) SLIC score (≥ 5 = surgery — unilateral dislocation typically scores high); (7) vertebral artery injury screen with CTA (high incidence in facet dislocation through foramen transversarium); (8) early surgical decompression < 24 hours for SCI (STASCIS); (9) avoid steroids routinely; (10) DVT prophylaxis; (11) rehab

---

Cervical facet dislocation: ATLS + immobilization. MRI before reduction if available (disc herniation 50% bilateral, 30% unilateral). Closed reduction with traction in awake patient possible. Open reduction + posterior fusion + ADCF if disc. Vertebral artery injury common → CTA. Early decompression < 24h for SCI.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 28 ปี รถมอเตอร์ไซค์ชนตกศีรษะกระแทกพื้น ปวดคอ + แขนซ้ายอ่อนแรง + ขา 2 ข้างอ่อนแรง partial

PE: head tilt + rotation away from side of dislocation; motor — left C6 root 3/5, LE 4/5 bilateral, +sacral sparing

CT C-spine: unilateral C5-C6 facet dislocation (left) — "perched facet" with anterior subluxation 25% of vertebral body width
MRI C-spine: cord compression + edema C5-C6, no significant disc herniation seen anteriorly';

commit;
