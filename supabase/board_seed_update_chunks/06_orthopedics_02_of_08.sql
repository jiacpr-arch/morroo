-- ===============================================================
-- UPDATE chunk 2/8: orthopedics (25 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"No interventions needed"},{"label":"B","text":"Fracture Prevention Program — multilevel approach"},{"label":"C","text":"Bed rest"},{"label":"D","text":"Aspirin only"},{"label":"E","text":"Avoid screening"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Fracture Prevention Program — multilevel approach: (1) **Universal screening**: DXA at age 65 (women) + 70 (men), earlier if risk factors; FRAX score (10-year fracture risk); (2) **Fall prevention** (CDC STEADI): screen all elderly annually (3 Key Questions, Timed Up and Go), gait/balance, medication review (Beers), home safety, vision/hearing, vitamin D, exercise (Tai Chi, Otago); (3) **Treatment when indicated**: bisphosphonate (alendronate 70 mg/wk, risedronate, zoledronate 5 mg IV/year), denosumab (60 mg SC q6 mo — careful — discontinuation rebound fracture risk if not transitioned), teriparatide (20 mcg SC daily × 2 yr, anabolic for high-risk), romosozumab (anabolic 1 yr then anti-resorptive); Ca + vitamin D foundation; (4) **Secondary fracture prevention**: fragility fracture clinic — initiate Rx after any fragility fracture (50% reduction subsequent fractures with treatment); coordinator-based programs (Fracture Liaison Service) effective; (5) **Drug holiday** consideration with long-term bisphosphonate (5-10 yr — assess); (6) **Multidisciplinary**: PCP, orthopedic, endocrine, geriatric, PT, pharmacy; (7) **Patient education**: nutrition, exercise, fall prevention, medication adherence; (8) **Long-term**: regular DXA, adherence monitoring, side effect management (jaw osteonecrosis rare, atypical femur fracture rare with bisphosphonates); (9) **Quality metrics**: screening rate, treatment rate, fracture rate, mortality post-hip fracture (20-30% first year)

---

Fracture prevention = multilevel + system approach. Universal screening (DXA, FRAX). Fall prevention (CDC STEADI). Anti-osteoporosis treatment when indicated. Secondary fracture prevention (FLS) — most underutilized opportunity. Multidisciplinary care. Modern: anabolic agents for very high risk + sequential therapy. Patient education + adherence. Mortality post-hip fracture significant.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'Hospital implements fall prevention program for elderly + osteoporosis screening + treatment';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single specialty manages"},{"label":"B","text":"Ortho-Geriatric Co-Management for Hip Fracture"},{"label":"C","text":"Avoid surgery"},{"label":"D","text":"Geriatric alone"},{"label":"E","text":"Bedrest"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ortho-Geriatric Co-Management for Hip Fracture: (1) **Co-management model**: ortho + geriatrics jointly manage, daily ward rounds; (2) **Evidence**: reduces mortality (10-15% relative), LOS, complications, delirium per Cochrane + systematic reviews; (3) **Care pathway**: standardized + multidisciplinary — admission within hours, surgical assessment + repair within 24-48h, post-op early mobilization day 1; (4) **Pre-op optimization**: anesthesia evaluation, anti-coagulation reversal, cardiac risk assessment + optimization (echo, beta-blocker, statin), nutrition, anemia treatment, delirium assessment + prevention; (5) **Pain control**: multimodal — fascia iliaca compartment block or femoral nerve block effective + opioid-sparing; (6) **VTE prophylaxis**: low molecular weight heparin or DOAC; (7) **Delirium**: CAM screening, prevention (reorient, hydrate, mobilize, sleep), treatment of underlying causes; (8) **Pressure injury prevention**: turning, special mattress, nutrition, skin care; (9) **Nutrition**: oral supplement (Cochrane evidence reduces complications), early diet, PEG if needed; (10) **Mobilization day 1**: weight-bearing as tolerated (essential — Cochrane), PT/OT, fall prevention; (11) **Discharge planning early**: home vs rehab vs SNF, family support, services; (12) **Secondary prevention**: osteoporosis treatment, fall prevention, FLS; (13) **Quality metrics**: 30-day mortality, time to surgery, delirium incidence, mobilization day, LOS, readmission, secondary prevention rates; (14) **NSQIP, Australia + UK National Hip Fracture Database, AAOS — best practice models

---

Ortho-geriatric co-management for hip fracture: evidence-based — reduces mortality + complications. Joint care, standardized pathway, early surgery, multimodal pain, delirium prevention, early mobilization, secondary prevention. UK National Hip Fracture Database transformed UK practice. AAOS standards. Quality metrics drive improvement.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'Hospital implements ortho-geriatric co-management for hip fracture patients — reduce mortality + complications';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Complex Elderly Post-Surgical Integrative Care"},{"label":"C","text":"Discharge home"},{"label":"D","text":"ICU only"},{"label":"E","text":"Refuse care"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Complex Elderly Post-Surgical Integrative Care: (1) **Multidisciplinary team**: orthopedics + geriatrics + cardiology + endocrinology + nephrology + neurology + PT/OT + nutrition + pharmacy + social work + psychiatry + case management; (2) **New AF post-op**: cardiology consult — rate control (metoprolol cautious in HF, diltiazem alternative), anticoagulation decision (CHA2DS2-VASc) — high stroke risk vs surgical bleeding (consult orthopedics, plan timing); (3) **Delirium**: identify cause (medications, infection, pain, dehydration, hypoxia, withdrawal, etc.); treat underlying; non-pharmacologic measures (re-orient, family presence, sleep hygiene, mobility, sensory aids); low-dose antipsychotic only for severe agitation/safety (haloperidol, quetiapine — avoid in elderly per Beers); avoid benzodiazepines (worsen); (4) **CKD**: adjust medications, monitor Cr + electrolytes, avoid nephrotoxins (NSAIDs, contrast, gentamicin); (5) **DM**: glycemic control, post-op insulin transition; (6) **Multimodal pain**: avoid opioid-heavy in elderly (delirium risk); regional block + scheduled non-opioid; (7) **VTE prophylaxis**: balance bleeding risk; (8) **Nutrition**: oral supplement, monitor weight; (9) **Mobility + PT**: every day; (10) **Discharge planning**: home with services vs SNF vs LTC — family support assessment, environmental safety; (11) **Polypharmacy review**: deprescribing where possible (Beers Criteria + STOPP/START); (12) **Family engagement** + caregiver support + advance care planning + goals of care discussion; (13) **Follow-up**: orthopedic, primary care, cardiology, comprehensive geriatric assessment; (14) **Long-term**: secondary prevention (osteoporosis, falls, CV)

---

Complex elderly post-surgical care = quintessentially integrative. Multidisciplinary management. New AF + delirium + multi-organ disease — common, complex. CHA2DS2-VASc anticoagulation decision balanced with surgical bleeding. Delirium common, multifactorial — treat underlying. Polypharmacy review (Beers, STOPP/START). Family engagement + goals of care. Comprehensive geriatric assessment. Modern: ortho-geriatric co-management standard.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ผู้ป่วยอายุ 78 ปี post-THA day 7 underlying T2DM, CKD3, CAD, mild dementia + delirium + new arrhythmia (AF) postoperatively

คำถาม: complex elderly post-surgical management integrative care';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single specialty"},{"label":"B","text":"SCI Lifelong Integrative Care"},{"label":"C","text":"Bedridden"},{"label":"D","text":"Hospice"},{"label":"E","text":"Single specialist"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** SCI Lifelong Integrative Care: (1) **Acute rehabilitation** (post-acute care 4-12 wk): comprehensive in SCI specialty unit; (2) **Multidisciplinary team**: physiatry/PM&R, neurology, urology, orthopedics, plastics, GI, psychiatry, pulmonology, social work, vocational rehab, peer support, sexual health; (3) **PT/OT**: strength, transfers, wheelchair skills, ADLs, gait training (if applicable), assistive devices, home modifications; (4) **Bladder management**: intermittent catheterization preferred (lower UTI than indwelling); UTI surveillance + treatment; urodynamics; (5) **Bowel program**: scheduled, manual stimulation, diet, medications (suppositories, mini-enemas); (6) **Skin/pressure injury prevention**: pressure relief q15-30 min, special cushions/mattress, daily skin checks, nutrition; (7) **Autonomic dysreflexia** (above T6 SCI): elevated BP from noxious stimulus below — life-threatening; remove stimulus + sit upright + treat HT (nitroglycerin, nifedipine), education to patient + family; (8) **Spasticity**: PT/OT, oral baclofen, tizanidine, intrathecal baclofen pump, botulinum toxin injection; (9) **Cardiovascular**: orthostatic hypotension, decreased fitness — exercise + monitoring; (10) **Pulmonary**: respiratory PT (high SCI especially), vaccination, vigilance for infection; (11) **Sexual + reproductive health**: counseling, medication (PDE5i), assisted reproduction if needed, partner support; (12) **Mental health**: depression high prevalence (50%), suicide risk, peer support groups, counseling, medication; (13) **Vocational**: return to school/work, education, disability services; (14) **Long-term**: pressure injuries, UTIs, secondary medical conditions, neurogenic bone changes (HO), accelerated aging, chronic pain (50% — neuropathic); (15) **Emerging therapies**: neuromodulation, exoskeletons, regenerative medicine — research; (16) **Family + caregiver support**: training, respite, financial; (17) **Equity + access** challenges

---

SCI lifelong integrative care = paradigm of multidisciplinary medicine. Acute rehab in specialty unit. Multiple body systems involved. Autonomic dysreflexia emergency. Mental health critical. Long-term complications. Family + caregiver support. Vocational rehabilitation. Emerging technologies promising. Equity + access issues. Modern outcomes: many individuals lead fulfilling lives with appropriate support.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ผู้ป่วยอายุ 35 ปี traumatic spinal cord injury post-MVC 3 months ago — paraplegia level T6 ASIA A — undergoing rehabilitation

คำถาม: lifelong integrative care + multidisciplinary management';

update public.mcq_questions
set choices = '[{"label":"A","text":"NSAIDs only"},{"label":"B","text":"Vertebral Compression Fracture (VCF) + Osteoporosis + Chronic Pain Integrative Care"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Spinal fusion all"},{"label":"E","text":"Hospice"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Vertebral Compression Fracture (VCF) + Osteoporosis + Chronic Pain Integrative Care: (1) **Acute fracture management**: pain control multimodal (acetaminophen, NSAIDs cautious, calcitonin nasal spray short-term, tramadol or low-dose opioid PRN — Beers caution in elderly), bracing (TLSO short-term selected), rest then mobilize; (2) **Procedural options**: vertebroplasty or kyphoplasty — controversial (Cochrane mixed; recent trials show benefit in selected acute persistent severe pain); patient selection important; (3) **Imaging**: MRI to distinguish acute (edema) vs old fractures, rule out malignancy (10% can be neoplastic); (4) **Osteoporosis management**: workup secondary causes (Ca, vitamin D, PTH, TSH, etc.); start anabolic agent (teriparatide, romosozumab) for very high-risk (multiple recent fractures, T-score very low) — superior to anti-resorptive in this setting (VERO, ARCH trials); transition to anti-resorptive after; Ca + vitamin D foundation; (5) **Fall prevention** (CDC STEADI) + osteoporosis prevention; (6) **Multidisciplinary**: PCP, ortho, endocrine, geriatric, PM&R, pain management, mental health, PT, social work; (7) **PT**: posture, balance, core strengthening, gait training, assistive devices; (8) **Mental health**: depression high prevalence in chronic pain + functional decline — screening + treatment (SSRI, CBT, multidisciplinary pain program); (9) **Nutrition**: protein, Ca, vitamin D, weight; (10) **Social support**: family, peer support groups, caregiver; (11) **Survivorship + secondary prevention**: lifelong osteoporosis care + bone health; (12) **Quality of life focus**: functional improvement, return to meaningful activities; (13) **Long-term**: continued surveillance + treatment + adherence + adjustment

---

VCF + osteoporosis + chronic pain = integrative multidisciplinary care. Acute pain management + procedural (kyphoplasty selected). Aggressive osteoporosis Rx — anabolic preferred for very high-risk recent fractures (VERO, ARCH). Fall prevention + PT. Mental health screening + treatment. Multidisciplinary. Quality of life focus. Modern: anabolic-first then anti-resorptive sequential therapy for very high-risk.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ผู้ป่วยอายุ 65 ปี newly diagnosed osteoporotic vertebral compression fractures × 3 in past 6 months + chronic pain + functional decline + depression — multidisciplinary integrative management needed';

update public.mcq_questions
set choices = '[{"label":"A","text":"Long-arm cast in neutral 12 weeks"},{"label":"B","text":"Displaced Colles Fracture (distal radius extra-articular, dorsal angulation)"},{"label":"C","text":"Amputation"},{"label":"D","text":"Steroid injection"},{"label":"E","text":"Discharge with NSAIDs only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Displaced Colles Fracture (distal radius extra-articular, dorsal angulation): (1) closed reduction under hematoma block หรือ sedation — traction, volar pressure, ulnar deviation; (2) below-elbow cast (sugar tong หรือ short-arm) 6 weeks; (3) post-reduction X-ray + check criteria: dorsal angulation < 10°, radial inclination > 15°, radial shortening < 5 mm, intra-articular step < 2 mm; (4) ถ้า reduction ไม่ acceptable หรือ unstable → ORIF volar locking plate; (5) DEXA + osteoporosis Rx (FRAX, calcium/vit D, bisphosphonate); (6) PT for stiffness + CRPS prevention; (7) f/u 1-2 weeks check displacement

---

Colles fracture: most common fracture in elderly female with osteoporosis (fragility fracture). Closed reduction + cast acceptable if stable + radiographic criteria met. Surgical (volar locking plate) ถ้า unstable, intra-articular, comminuted, หรือ unable to maintain reduction. Always screen + treat osteoporosis (secondary prevention).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 68 ปี postmenopause หกล้มเอามือยันพื้น มาด้วยปวด + บวมข้อมือขวา

V/S: ปกติ
PE: dinner fork deformity ข้อมือขวา, tender distal radius, neurovascular intact

X-ray wrist: extra-articular distal radius fracture, dorsal angulation 25°, dorsal displacement, radial shortening 6 mm — Colles fracture';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge no immobilization"},{"label":"B","text":"Suspected Scaphoid Fracture (clinical signs positive แต่ X-ray negative"},{"label":"C","text":"Wrist arthrodesis"},{"label":"D","text":"Steroid injection"},{"label":"E","text":"Casting only without follow-up X-ray"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspected Scaphoid Fracture (clinical signs positive แต่ X-ray negative — occult fracture): (1) immobilize thumb spica splint/cast (เพราะ scaphoid fracture missed → AVN proximal pole + nonunion); (2) repeat X-ray 10-14 วันต่อมาเมื่อ resorption ทำให้เห็น fracture line; (3) advanced imaging แนะนำเร็วถ้า high suspicion — MRI (most sensitive + specific, 99%) หรือ CT; (4) ถ้า confirmed non-displaced waist → thumb spica cast 6-12 weeks; (5) displaced (> 1mm) หรือ proximal pole → ORIF percutaneous Herbert/Acutrak screw; (6) AVN risk: proximal pole 100%, waist 30%, distal pole rare (blood supply retrograde จาก dorsal carpal branch radial artery)

---

Scaphoid: most commonly fractured carpal bone. Snuffbox tenderness highly sensitive แต่ X-ray miss 25% initially. Cast + repeat X-ray 10-14d หรือ early MRI standard. Proximal pole fractures high AVN risk → early ORIF. Missed scaphoid → nonunion → SNAC wrist arthritis.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 22 ปี ตกจักรยานเอามือยันพื้น มาด้วยปวดข้อมือ 2 วัน

PE: tenderness anatomical snuffbox + scaphoid tubercle + axial thumb compression
Neurovascular intact

X-ray wrist 4 views (PA, lateral, scaphoid view, oblique): ไม่เห็น fracture ชัดเจน';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge with splint only"},{"label":"B","text":"definitive open reduction + ligament repair (scapholunate + lunotriquetral) + K-wire fixation"},{"label":"C","text":"Aspiration"},{"label":"D","text":"Wrist arthrodesis immediately"},{"label":"E","text":"NSAIDs alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Perilunate Dislocation (Mayfield stage IV — lunate volar dislocation with capitate dorsal): (1) emergent closed reduction under sedation/regional block (Tavernier maneuver — traction + wrist extension แล้ว flexion with dorsal lunate pressure) เพื่อ relieve median nerve compression; (2) post-reduction splint + admit; (3) **definitive open reduction + ligament repair (scapholunate + lunotriquetral) + K-wire fixation** ภายใน 24-72 hours (delayed surgery → poor outcome); (4) carpal tunnel release ถ้า persistent median symptoms; (5) cast 8-12 weeks; (6) complications: median nerve injury, AVN lunate (Kienböck), SLAC wrist, chronic stiffness; (7) PT after K-wire removal

---

Perilunate/lunate dislocation: high-energy wrist injury, often missed (25%). Lateral X-ray key — "spilled teacup". Median nerve compression common. Emergent reduction → ORIF + ligament repair. Delayed treatment → carpal collapse + arthritis. Mayfield progression: SL → capitolunate → LT → lunate dislocation.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 28 ปี motorcycle accident ปวดข้อมือซ้ายอย่างรุนแรง + ชาปลายนิ้วกลาง

PE: swelling + deformity ข้อมือ, paresthesia median nerve distribution, capillary refill 2 s

X-ray wrist lateral: spilled tea cup sign (lunate tipped volarly, capitate dorsally dislocated)
PA view: disrupted Gilula arcs, triangular lunate ("piece of pie")';

update public.mcq_questions
set choices = '[{"label":"A","text":"Long-arm cast for 12 weeks"},{"label":"B","text":"Boxer''s Fracture (5th MC neck, no rotation, angulation 35°)"},{"label":"C","text":"Amputation"},{"label":"D","text":"Discharge without immobilization"},{"label":"E","text":"Steroid injection"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Boxer''s Fracture (5th MC neck, no rotation, angulation 35°): (1) acceptable angulation = up to 40° at 5th MC neck (more mobile CMC compensates); rotational deformity NOT acceptable — check scissoring on flexion; (2) closed reduction (Jahss maneuver — MCP/PIP flexion 90°, dorsal pressure on flexed PIP) ถ้า angulation > 40°; (3) immobilization ulnar gutter splint with MCP at 70-90° flexion, IP free, 3-4 weeks; (4) ORIF (K-wire, plate) ถ้า rotation, > 40° angulation refractory, open, multiple MC; (5) screen "fight bite" — small wound over MCP from human tooth — high infection risk (Eikenella) → I&D + IV antibiotics (amoxicillin-clavulanate); (6) early ROM after splint

---

Boxer''s fracture: very common, 5th MC neck. Angulation tolerated up to 40° (CMC mobility compensates). Rotation NEVER acceptable — check scissoring. Closed reduction + ulnar gutter. ORIF for failure/rotation. Always inspect for fight bite (high infection risk — Eikenella, anaerobes).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 19 ปี ชกกำแพงด้วยมือขวา มาด้วยปวด + บวมหลังมือ

PE: swelling dorsum hand, tender 5th MC neck, depressed knuckle MCP-5, no rotational deformity, no scissoring on flexion, no open wound

X-ray hand: 5th metacarpal neck fracture, volar angulation 35°, no rotation';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cast forearm + wrist 12 weeks"},{"label":"B","text":"Mallet Finger (extensor tendon avulsion จาก distal phalanx — bony mallet < 30% articular, no subluxation)"},{"label":"C","text":"Steroid injection"},{"label":"D","text":"Tendon transfer immediately"},{"label":"E","text":"Amputation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mallet Finger (extensor tendon avulsion จาก distal phalanx — bony mallet < 30% articular, no subluxation): (1) **continuous extension splinting of DIP** (Stack splint, aluminum, custom thermoplastic) — DIP in full extension to slight hyperextension 6-8 weeks continuous + 4-6 weeks night-only; (2) **PIP joint free to move** (avoid stiffness); (3) ห้าม flex DIP ระหว่าง treatment แม้นาทีเดียว (resets timer); (4) skin care under splint — avoid pressure necrosis; (5) operative (CRPP, ORIF) reserved for: > 30-50% articular involvement + volar subluxation distal phalanx, open injuries; (6) chronic mallet (> 4 weeks) ยัง responds to splinting; (7) f/u 2 wk for skin + compliance; (8) residual extensor lag 5-10° common but functional

---

Mallet finger: distal extensor tendon disruption. Closed bony or tendinous: splint DIP in full extension 6-8 wk continuous + 4-6 wk night, PIP free. NEVER flex during Rx. Surgery only for large fragment + subluxation. Chronic mallet still responds to splinting. Stiffness uncommon if PIP free.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 35 ปี โดนลูกบาสกระแทกปลายนิ้วชี้ขวา 1 สัปดาห์ก่อน ปลายนิ้วงอตลอด เหยียดเองไม่ได้

PE: DIP joint flexed ~40°, unable to actively extend at DIP, passive extension intact, no swelling much

X-ray finger: small avulsion fragment from dorsal base of distal phalanx < 30% articular surface, no subluxation';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cast only thumb spica 12 weeks"},{"label":"B","text":"operative — CRPP"},{"label":"C","text":"Conservative + NSAIDs"},{"label":"D","text":"CMC arthrodesis immediately"},{"label":"E","text":"Amputation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bennett Fracture (intra-articular fracture-dislocation 1st CMC, oblique fracture base 1st MC — volar-ulnar fragment held by anterior oblique/beak ligament, shaft displaced by APL): (1) closed reduction + thumb spica ไม่เพียงพอเพราะ deforming force ของ APL ทำให้ unstable; (2) **operative — CRPP** (closed reduction + percutaneous K-wire fixation across CMC + 1st-2nd MC) สำหรับ minimally displaced (< 2 mm); ORIF + screws/plate ถ้า > 2 mm displacement, comminuted, large fragment; (3) thumb spica cast 4-6 weeks; (4) K-wire removal 4-6 weeks; (5) early thumb mobilization to prevent stiffness; (6) long-term: CMC arthritis common — counsel; (7) Rolando = Y/T-shaped comminuted variant — worse prognosis; (8) hand therapy

---

Bennett fracture: intra-articular fracture-dislocation base 1st MC. Anterior oblique ligament holds volar-ulnar fragment; APL pulls shaft proximally → inherently unstable. Always operative (CRPP or ORIF). Anatomic reduction critical → CMC arthritis if missed. Rolando = comminuted variant.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 30 ปี ชกต่อย โดนนิ้วโป้งกระแทก ปวดโคนนิ้วโป้งขวา

PE: swelling + tender thumb CMC joint, painful + weak pinch grip

X-ray thumb: intra-articular fracture base of 1st metacarpal, small volar-ulnar fragment retains, shaft displaced proximally + radially + dorsally by APL pull';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cast in pronation 4 weeks"},{"label":"B","text":"Galeazzi Fracture-Dislocation (distal third radius fracture + DRUJ disruption — \"fracture of necessity\" in adult)"},{"label":"C","text":"Above-elbow cast alone"},{"label":"D","text":"Discharge with sling"},{"label":"E","text":"Amputation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Galeazzi Fracture-Dislocation (distal third radius fracture + DRUJ disruption — "fracture of necessity" in adult): (1) **ORIF radius with anatomic plate** (3.5 mm DCP/LCP volar approach) — restore radial length + alignment essential to reduce DRUJ; (2) assess DRUJ stability intra-op after radius fixation — ถ้า reduced + stable → above-elbow splint/cast in supination 4-6 weeks; (3) ถ้า DRUJ unstable after radius fix → reduce DRUJ + percutaneous K-wire across DRUJ + cast in supination; ถ้า irreducible (interposition ECU/EDM tendons) → open repair; (4) check for ulnar styloid fracture (TFCC injury surrogate); (5) early hand/elbow ROM; (6) complications: malunion, DRUJ instability, ulnar neuropathy, refractures

---

Galeazzi = distal radius fracture + DRUJ dislocation. "Fracture of necessity" in adults — always ORIF. Restore radial length first → reduces DRUJ. Assess DRUJ stability intra-op. Cast in supination (relaxes brachioradialis, reduces DRUJ). Mnemonic: MUGR (Monteggia Ulna, Galeazzi Radius).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 32 ปี ตกบันไดเอาแขนยัน ปวดข้อมือ + ปลายแขนขวา

PE: deformity distal forearm, tender distal radius + DRUJ, prominent ulnar head, neurovascular intact

X-ray forearm AP/lateral: displaced distal third radius fracture + dorsal dislocation of distal radioulnar joint (DRUJ) — Galeazzi fracture';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge with sling"},{"label":"B","text":"Monteggia Fracture-Dislocation (proximal ulna fracture + radial head dislocation — Bado I = anterior, most common)"},{"label":"C","text":"Above-elbow cast in extension"},{"label":"D","text":"Amputation"},{"label":"E","text":"Aspiration"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Monteggia Fracture-Dislocation (proximal ulna fracture + radial head dislocation — Bado I = anterior, most common): (1) **child < 12 ปี** → closed reduction + long-arm cast in elbow flexion 90-110° + supination (Bado I) 4-6 weeks; (2) X-ray check radio-capitellar line restored (line through radial head should pass through capitellum in ANY view); (3) failed closed reduction หรือ unstable → ORIF ulna (plate, IM nail) + open reduction radial head ถ้า needed; (4) **adult always ORIF ulna** with anatomic plate; (5) check PIN (posterior interosseous nerve) — neuropraxia common with anterior radial head dislocation → usually recovers 2-3 months; (6) missed Monteggia = chronic radial head dislocation → late reconstruction difficult; (7) annular ligament repair

---

Monteggia: ulna fracture + radial head dislocation. ALWAYS check radio-capitellar line in ANY suspected forearm/elbow fracture. Child — closed reduction OK. Adult — ORIF ulna. PIN palsy common (transient). Missed → chronic dislocation = disabling. Bado I (anterior) most common. MUGR mnemonic.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'เด็กชายอายุ 7 ปี ตกจากต้นไม้ ปวดข้อศอกซ้าย เหยียดข้อศอกไม่ได้

PE: swelling + deformity proximal forearm, tender ulna, prominent radial head anteriorly, NV intact (check PIN — extensor finger function)

X-ray forearm + elbow: proximal ulna fracture angulated anteriorly + anterior dislocation of radial head (radio-capitellar line broken) — Monteggia type I (Bado)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Short-arm cast 2 weeks"},{"label":"B","text":"Pediatric Both-bone Forearm Fracture: child has high remodeling potential —"},{"label":"C","text":"Surgery always required"},{"label":"D","text":"Discharge with sling no immobilization"},{"label":"E","text":"Steroid injection"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Both-bone Forearm Fracture: child has high remodeling potential — (1) **closed reduction under sedation** (Bier block, ketamine, hematoma block) — restore length + alignment + rotation; (2) **long-arm cast** with good 3-point mold + interosseous mold + cast index < 0.8 — position depends on fracture level (proximal third: full supination; middle: neutral; distal: pronation); (3) acceptable angulation by age — < 10 ปี tolerates 15-20° angulation + complete displacement (bayonet) ถ้า length maintained; > 10 ปี stricter (< 10° angulation, no rotation, < 50% translation); (4) NO rotational malalignment tolerated; (5) weekly X-ray × 3 wk to monitor displacement; (6) cast 6 weeks; (7) ORIF (flexible IM nailing — ESIN/TEN, plating) ถ้า unstable, failure of closed reduction, open, adolescent, > 10 ปี with significant displacement

---

Pediatric forearm fracture: high remodeling potential. Closed reduction + long-arm cast standard. Acceptable angulation depends on age + location. Rotation never accepted. Cast index < 0.8 critical. Weekly X-ray. ORIF (flexible IM nail) for failure + adolescent. Plate fixation for older children/teens.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'เด็กหญิงอายุ 8 ปี ตกจากชิงช้าเอาแขนยัน ปวด + บวมปลายแขนซ้าย

PE: deformity midshaft forearm, tender ทั้ง radius + ulna, NV intact

X-ray forearm: both-bone forearm fracture midshaft, complete displacement + angulation 20°, no comminution';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cast in full flexion 90° + discharge"},{"label":"B","text":"emergent CRPP within hours"},{"label":"C","text":"Discharge with sling"},{"label":"D","text":"Above-elbow cast in extension"},{"label":"E","text":"Amputation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Gartland Type III Supracondylar Fracture + AIN Palsy + Diminished Pulse — surgical emergency: (1) admit + NPO + IV access; (2) gentle splint in 30° flexion (avoid > 90° = pulse occlusion); (3) **emergent CRPP within hours** (closed reduction + percutaneous pinning) — 2-3 lateral pins ± medial pin (medial pin risk ulnar nerve injury — use only if needed + place with mini-incision); (4) check pulse + perfusion after reduction — ถ้า hand pink + perfused + warm with diminished pulse → observe (pulseless pink hand often vasospasm, recovers); ถ้า white pulseless hand → emergent vascular exploration brachial artery (entrapment, transection); (5) AIN palsy (cannot OK sign — FPL + FDP index) → spontaneous recovery 2-4 months expected; (6) post-op cast 3-4 weeks; pin removal in clinic; (7) monitor for compartment syndrome (forearm — Volkmann''s); (8) ROM after pin removal

---

Supracondylar humerus #1 pediatric elbow fracture. Anterior humeral line key. Gartland III = completely displaced → CRPP emergent. AIN neuropraxia common (recovers). White pulseless hand = vascular emergency (exploration). Pink pulseless hand = observe. Watch compartment syndrome (Volkmann''s contracture). Medial pin risk ulnar nerve.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'เด็กชายอายุ 6 ปี ตกจากเครื่องเล่นเอามือยัน ปวดข้อศอกขวา + เริ่มชาปลายนิ้วชี้

V/S: ปกติ
PE: marked swelling + deformity elbow, S-shape, decreased radial pulse (palpable but diminished), capillary refill 3 s, unable to OK sign (AIN palsy), no open wound

X-ray elbow: completely displaced extension-type supracondylar humerus fracture, posterior + medial displacement, anterior humeral line ไม่ผ่าน middle third capitellum — Gartland type III';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cast in extension 6 weeks"},{"label":"B","text":"tension band wiring"},{"label":"C","text":"Discharge with sling"},{"label":"D","text":"Steroid injection"},{"label":"E","text":"Amputation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Displaced Olecranon Fracture (transverse, 5 mm displacement, intra-articular — loss of extensor mechanism): (1) operative ORIF เพราะ triceps pull → displacement, loss of active extension, intra-articular incongruity; (2) **tension band wiring** (TBW) สำหรับ simple transverse, non-comminuted (2 parallel K-wires + figure-of-8 wire converts tensile to compression on articular side) — biomechanically excellent, แต่ symptomatic hardware 80% → removal common; (3) **plate fixation** (anatomic precontoured posterior plate) สำหรับ comminuted, oblique, distal/proximal extension, osteoporotic bone; (4) early active ROM at 1-2 weeks (gentle); (5) ผู้ป่วยสูงอายุ low-demand → consider **fragment excision + triceps advancement** ถ้า bone quality poor (up to 50-80% olecranon can be excised + triceps reattached); (6) physical therapy

---

Olecranon fracture: triceps pull → distraction. Inability to extend elbow against gravity diagnostic. ORIF for any displacement (extensor mechanism + intra-articular). TBW for simple transverse (high hardware removal rate). Plate for complex/comminuted. Excision + triceps advancement option for elderly low-demand.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 55 ปี ตกหกล้มลงข้อศอกขวา ปวด + บวม ข้อศอก เหยียดข้อศอกเองไม่ได้

PE: palpable gap olecranon, tender, unable to actively extend elbow against gravity, NV intact

X-ray elbow lateral: transverse displaced olecranon fracture, displacement 5 mm, intra-articular';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cast in extension 8 weeks"},{"label":"B","text":"Distal Humerus Intra-articular Fracture AO C3 in Elderly"},{"label":"C","text":"Discharge with sling"},{"label":"D","text":"Hemiarthroplasty distal humerus"},{"label":"E","text":"Amputation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Distal Humerus Intra-articular Fracture AO C3 in Elderly: (1) **operative ORIF with bicolumnar fixation** (parallel หรือ orthogonal/perpendicular plate construct — both columns 90-90 หรือ both posterior) via olecranon osteotomy approach (best articular exposure); restore articular congruity + columns + ulnohumeral alignment; (2) **total elbow arthroplasty (TEA)** alternative in elderly (> 65-70) low-demand + osteoporotic + non-reconstructable comminution + RA — better short-term outcomes vs ORIF in elderly (less stiffness); life-long restriction ยกของ < 5-10 lb; high revision rate long-term; (3) early ROM 1-2 weeks (rigid fixation allows); (4) ulnar nerve transposition consideration; (5) PT essential; (6) high complication rate: stiffness, ulnar neuropathy, nonunion, infection; (7) heterotopic ossification prophylaxis (indomethacin) selective

---

Distal humerus intra-articular: technically demanding. Goal — anatomic articular reduction + stable bicolumnar fixation → early ROM. Olecranon osteotomy for exposure. Elderly osteoporotic non-reconstructable → TEA alternative (better short-term but lifelong weight restriction). Ulnar neuropathy common — transpose. High stiffness rate.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 72 ปี postmenopause หกล้มลงข้อศอกซ้าย ปวด + บวมข้อศอกอย่างรุนแรง

PE: gross deformity elbow, severe swelling, NV intact

X-ray + CT elbow: intra-articular distal humerus fracture, comminuted, both medial + lateral columns + intra-articular fragmentation — AO type C3';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge no reduction"},{"label":"B","text":"recurrence high in young"},{"label":"C","text":"Open reduction immediately"},{"label":"D","text":"Amputation"},{"label":"E","text":"Steroid injection"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anterior Glenohumeral Dislocation: (1) check axillary nerve before + after reduction (sensation lateral deltoid; deltoid contraction); (2) **closed reduction** under sedation/intra-articular lidocaine — multiple techniques: scapular manipulation, traction-countertraction, Stimson (prone with weight), Milch, FARES, external rotation — gentle, avoid forceful; (3) post-reduction X-ray to confirm + identify Hill-Sachs lesion (humeral head impaction) + bony Bankart (glenoid rim fracture); (4) immobilize sling 1-3 weeks (recent evidence — external rotation brace may reduce recurrence แต่ no consensus); (5) early gentle ROM after 1-3 weeks; (6) PT — rotator cuff + scapular stabilizers; (7) **recurrence high in young** (< 25 ปี — up to 80-90%) → consider early surgical stabilization (arthroscopic Bankart repair) in young active patients especially overhead athletes; (8) MRI arthrogram for Bankart/Hill-Sachs/SLAP; (9) elderly first-time → screen rotator cuff tear (high incidence)

---

Anterior shoulder dislocation: most common. Check axillary nerve. Closed reduction many techniques. Hill-Sachs + Bankart lesions common. Young first-time dislocators — 80-90% recurrence → early arthroscopic Bankart stabilization. Elderly — screen rotator cuff tear. Sling 1-3 weeks then PT.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 23 ปี เล่นรักบี้ ล้มเอาไหล่กระแทกพื้น มาห้องฉุกเฉินปวดไหล่ซ้าย ขยับไม่ได้

PE: arm held slightly abducted + externally rotated, loss of normal shoulder contour, prominent acromion, palpable humeral head anteriorly, axillary nerve sensation (lateral deltoid) intact, distal NV intact

X-ray shoulder AP + scapular Y + axillary: anteroinferior glenohumeral dislocation, humeral head displaced anteriorly + inferiorly relative to glenoid';

update public.mcq_questions
set choices = '[{"label":"A","text":"Immobilize in internal rotation sling"},{"label":"B","text":"external rotation brace"},{"label":"C","text":"Discharge no reduction"},{"label":"D","text":"Total shoulder arthroplasty always"},{"label":"E","text":"NSAIDs alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Posterior Shoulder Dislocation (after seizure, electrocution, posterior trauma — often missed 50%): (1) axillary view essential (AP can look normal); CT to assess reverse Hill-Sachs size; (2) **closed reduction** under sedation — traction + adduction + gentle anterior pressure on humeral head; (3) post-reduction shoulder in **external rotation brace** 4-6 weeks (vs internal rotation which redislocates); (4) reverse Hill-Sachs lesion < 25% → closed reduction + immobilization; 25-50% → modified McLaughlin (subscapularis transfer into defect) หรือ allograft fill; > 50% หรือ chronic → hemi/total shoulder arthroplasty; (5) screen seizure cause + electrolytes; (6) PT external rotators; (7) chronic missed posterior dislocation common in seizure patients — high suspicion

---

Posterior shoulder dislocation: rare (2-4%) but commonly missed. Causes: seizure, electric shock, posterior trauma (3 E''s). AP view deceiving — axillary mandatory. Reverse Hill-Sachs size guides treatment. Immobilize in external rotation. Surgical options: McLaughlin, allograft, arthroplasty.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 35 ปี post-seizure (epilepsy) ปวด + ยกแขนซ้ายไม่ได้ มาห้องฉุกเฉิน

PE: arm held in adduction + internal rotation, inability to externally rotate (locked IR), squared-off shoulder less obvious, posterior fullness, anterior void

X-ray AP shoulder: "light bulb sign" (humeral head internally rotated — symmetric appearance), normal AP appears "normal" — easily missed
Axillary view: posterior dislocation confirmed; reverse Hill-Sachs (anteromedial humeral head impaction) visible';

update public.mcq_questions
set choices = '[{"label":"A","text":"ORIF emergency immediately"},{"label":"B","text":"Rockwood Type III AC Joint Separation (CC + AC ligaments disrupted, CC distance increased 25-100%, clavicle not below acromion or buttonholed)"},{"label":"C","text":"Sling 12 weeks + no ROM"},{"label":"D","text":"Distal clavicle excision first"},{"label":"E","text":"Amputation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Rockwood Type III AC Joint Separation (CC + AC ligaments disrupted, CC distance increased 25-100%, clavicle not below acromion or buttonholed): (1) **initial nonoperative trial** in most patients (recent evidence — comparable outcomes ส่วนใหญ่) — sling 2-6 weeks for comfort, ice, NSAIDs, early ROM; (2) PT — scapular stabilizers + rotator cuff; (3) return to sport 6-12 weeks; (4) **surgical consideration** ในกรณี: failed conservative 3-6 months, manual laborer/overhead athlete, cosmetic concern, type III with concomitant injury, persistent symptoms; (5) surgical options: anatomic CC reconstruction (CC ligament reconstruction with graft + augmentation), hook plate; (6) types IV (posterior), V (severe superior > 100% CC distance), VI (inferior) → surgical; type I/II → conservative; (7) chronic painful AC arthritis → distal clavicle excision

---

AC separation: Rockwood I-VI. I/II conservative. III controversial — current evidence supports nonoperative trial first. IV/V/VI surgical. Surgery for III in select cases (laborer, athlete, failed conservative). Anatomic CC reconstruction preferred. Late painful AC arthritis → distal clavicle excision.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 28 ปี เล่นจักรยานเสือภูเขา ล้มลงไหล่ขวา ปวดบริเวณ AC joint

PE: prominent distal clavicle ("piano key" sign — reducible with pressure), tender AC joint, normal shoulder ROM but painful

X-ray shoulder + Zanca view: complete AC joint dislocation, coracoclavicular distance 14 mm (normal < 11-13 mm หรือ < 25% > contralateral), no clavicle inferior to acromion — Rockwood type III';

update public.mcq_questions
set choices = '[{"label":"A","text":"Figure-of-8 brace 12 weeks always"},{"label":"B","text":"Displaced Midshaft Clavicle Fracture (shortening > 2 cm, complete displacement, comminuted with butterfly/vertical fragment, young active patient)"},{"label":"C","text":"Discharge no immobilization"},{"label":"D","text":"Steroid injection"},{"label":"E","text":"Amputation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Displaced Midshaft Clavicle Fracture (shortening > 2 cm, complete displacement, comminuted with butterfly/vertical fragment, young active patient): (1) **operative ORIF** indicated เพราะ displaced > 2 cm + active patient → reduces nonunion (10-15% vs 1-3% surgical) + malunion + improves functional outcome (COTS trial); (2) options: superior plate (more biomechanical strength), anteroinferior plate (lower hardware prominence + neurovascular safer), intramedullary device (less invasive); (3) sling 2-4 weeks post-op + early ROM; (4) **conservative (sling/figure-of-8)** acceptable สำหรับ minimally displaced (< 2 cm shortening), no comminution, lower demand patients — 4-6 weeks; (5) absolute surgical indications: open, skin compromise (tenting), neurovascular injury, floating shoulder, polytrauma, symptomatic nonunion/malunion; (6) screen pneumothorax (CXR), brachial plexus, subclavian vessels

---

Midshaft clavicle fracture: traditionally conservative. Modern evidence — displaced (> 2cm shortening, comminuted) in young active → ORIF reduces nonunion 10-15% → 1-3% and improves function. Sling for minimally displaced. Absolute surgical: open, skin tenting, NV injury, floating shoulder.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 26 ปี นักจักรยานล้มไหล่กระแทกพื้น ปวด clavicle ขวา 1 วัน

PE: deformity midshaft clavicle, palpable step + tenderness, no skin tenting, NV intact, no respiratory compromise

X-ray clavicle: midshaft clavicle fracture, complete displacement, shortening 22 mm, comminuted with vertical fragment';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cast immobilization 8 weeks"},{"label":"B","text":"Neer 4-part Proximal Humerus Fracture in Elderly Osteoporotic"},{"label":"C","text":"Hemiarthroplasty always"},{"label":"D","text":"Discharge home no follow-up"},{"label":"E","text":"Amputation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neer 4-part Proximal Humerus Fracture in Elderly Osteoporotic: (1) **reverse total shoulder arthroplasty (rTSA)** preferred over hemiarthroplasty in elderly เพราะ: predictable pain relief + function, doesn''t depend on tuberosity healing (which is unreliable in elderly), better functional outcomes vs hemi (recent RCTs); (2) hemiarthroplasty alternative — but tuberosity malunion + cuff insufficiency lead to poor function; (3) ORIF (locking plate, IM nail) consideration ในผู้ป่วยที่ younger, valgus impacted with intact medial calcar (4-part valgus impacted has lower AVN risk — 11% vs 45%), good bone quality; (4) non-operative (sling 2-3 weeks then early ROM) สำหรับ low-demand, medically unfit elderly, even displaced — many functional outcomes comparable in elderly cohorts (PROFHER trial UK); (5) physical therapy intensive 6-12 months; (6) DEXA + osteoporosis treatment; (7) fall prevention

---

Proximal humerus fractures: most fragility fracture in elderly. Neer 4-part — high AVN risk (except valgus impacted 11%). Modern evidence — rTSA superior to hemi in elderly (doesn''t depend on tuberosity healing). ORIF for young with good bone. Non-op acceptable in many elderly (PROFHER). Always treat osteoporosis.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 78 ปี postmenopause หกล้มลงไหล่ซ้าย ปวด + บวมไหล่อย่างรุนแรง

PE: marked ecchymosis chest + arm, swelling, gross deformity, NV intact (axillary nerve checked)

X-ray shoulder AP/scapular Y + CT: 4-part proximal humerus fracture (head, lesser tuberosity, greater tuberosity, shaft) — Neer 4-part, valgus impacted';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge no reduction"},{"label":"B","text":"Posterior Sternoclavicular Dislocation (medial clavicle behind sternum — vascular/airway emergency)"},{"label":"C","text":"Closed reduction in ED without cardiothoracic backup"},{"label":"D","text":"K-wire fixation in ED"},{"label":"E","text":"Amputation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Posterior Sternoclavicular Dislocation (medial clavicle behind sternum — vascular/airway emergency): (1) **emergent reduction in OR with cardiothoracic surgery on standby** เพราะ risk: tracheal/esophageal compression, great vessel injury (brachiocephalic vein/artery, subclavian, aortic arch), pneumothorax, brachial plexus; (2) reduction technique: GA + shoulder roll, traction on abducted/extended arm + percutaneous towel clip on medial clavicle for anterior pull; (3) post-reduction usually stable — figure-of-8 brace 4-6 weeks; (4) ถ้า unstable → open reduction + reconstruction (figure-of-8 graft of clavicle to manubrium, semi-tendinosus autograft); (5) avoid K-wire/Steinmann pin fixation (catastrophic migration into mediastinum reported); (6) post-op CXR + observation 24 hours; (7) physical therapy after immobilization; (8) high index suspicion — anterior SC more common (less dangerous) but posterior must be confirmed by CT chest with contrast

---

Posterior SC dislocation: rare but vascular/airway emergency. CT chest + contrast diagnostic. Reduce in OR with CT surgery available. Posterior often stable after reduction. AVOID K-wires (migration into mediastinum fatal). Anterior SC dislocation much more common, less dangerous, often left reduced/conservative.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 24 ปี เล่นรักบี้ ถูกชนด้านหน้าไหล่ ปวด + กลืนลำบาก + เสียงแหบ + หายใจไม่สะดวก

V/S: BP 118/76, HR 96, SpO2 95%
PE: medial clavicle ไม่ palpable + retrosternal depression, tender SC joint, mild dyspnea, weak voice

CT chest with contrast: posterior dislocation right sternoclavicular joint, medial clavicle behind sternum compressing trachea + brachiocephalic vein';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation IV fluids only"},{"label":"B","text":"APC II Open-Book Pelvic Fracture with Hemodynamic Instability"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Immediate amputation"},{"label":"E","text":"Conservative bedrest 6 weeks"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** APC II Open-Book Pelvic Fracture with Hemodynamic Instability: (1) **immediate pelvic binder** (T-POD, sheet) at level of greater trochanters → reduces pelvic volume + tamponades venous bleeding (primary source 85%); (2) ATLS resuscitation — massive transfusion protocol (1:1:1 PRBC:FFP:platelets), TXA within 3 hours; (3) FAST/CT to identify other bleeding sources (abdominal, thoracic); (4) **persistent hemodynamic instability after binder + resuscitation** → multidisciplinary algorithm: (a) preperitoneal pelvic packing + external fixation in OR, (b) angioembolization (arterial source — 15%, presence of contrast blush on CT), (c) REBOA zone III considered in select centers; (5) urethral injury workup (blood at meatus, high-riding prostate) → retrograde urethrogram before Foley; suprapubic catheter ถ้า disrupted; (6) once stable → definitive fixation (anterior plate symphysis + posterior SI screws); (7) DVT prophylaxis (mechanical + chemical when bleeding controlled)

---

Open-book pelvic fracture (APC) + hemodynamic instability — life-threatening. Algorithm: binder → resuscitation (MTP, TXA) → preperitoneal packing + ex-fix OR angioembolization. Venous bleeding 85%, arterial 15%. Always RU before Foley if blood at meatus. Definitive fixation when stable (plate + SI screws).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 32 ปี ขับมอเตอร์ไซค์ชน head-on มาห้องฉุกเฉิน hemodynamically unstable

V/S: BP 78/42, HR 138, RR 28, GCS 14
PE: pelvic instability AP compression, perineal hematoma, blood at urethral meatus, no obvious external bleeding

X-ray + CT pelvis: open-book pelvic fracture — symphysis pubis diastasis 4.5 cm + bilateral SI joint widening, no acetabular fracture — APC type II (Young-Burgess), Tile B1';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait 24 hours before reduction"},{"label":"B","text":"Posterior Hip Dislocation + Posterior Wall Acetabular Fracture + Sciatic Nerve Injury"},{"label":"C","text":"Discharge home with crutches"},{"label":"D","text":"Amputation"},{"label":"E","text":"Cast in extension"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Posterior Hip Dislocation + Posterior Wall Acetabular Fracture + Sciatic Nerve Injury: (1) **emergent closed reduction of hip within 6 hours** (Allis or Stimson) under sedation to reduce AVN risk (AVN risk increases dramatically > 6h delay — 4.8% < 6h vs 52% > 6h); (2) post-reduction CT — confirm congruent reduction + assess posterior wall size + intra-articular fragments + femoral head fracture; (3) **ORIF posterior wall** ถ้า > 20-25% of wall, instability, intra-articular fragments, marginal impaction — Kocher-Langenbeck approach + reconstruction plate; (4) wall < 20% + stable concentric reduction + no fragments → non-operative + protected weight-bearing 6-8 weeks; (5) sciatic nerve injury: 10-20% — peroneal division most commonly; observe (most neuropraxia recover); AFO for foot drop; (6) DVT prophylaxis; (7) long-term AVN risk + post-traumatic OA — counsel; THA in 5-10 years not uncommon

---

Posterior hip dislocation = orthopedic emergency. Reduce within 6 hours to minimize AVN (4.8% vs 52%). Posterior wall acetabular fracture often associated. CT post-reduction for sizing + fragments. ORIF if > 20-25% wall, unstable, fragments. Sciatic nerve injury 10-20% (peroneal division). Late AVN + PTOA common.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 28 ปี ขับรถยนต์ชน dashboard ปวด hip ขวา + ไม่สามารถ weight bear

V/S: stable
PE: leg shortened + adducted + internally rotated, no obvious open wound, sciatic nerve check: foot drop + numb lateral leg (peroneal division — most commonly injured)

X-ray pelvis + Judet views + CT pelvis: posterior wall acetabular fracture + posterior hip dislocation, no femoral head fracture, posterior wall fragment 35% of articular surface';

commit;
