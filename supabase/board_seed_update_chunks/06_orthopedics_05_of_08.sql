-- ===============================================================
-- UPDATE chunk 5/8: orthopedics (25 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"Long-term oral steroid"},{"label":"B","text":"Moderate Carpal Tunnel Syndrome (CTS) Without Severe Atrophy"},{"label":"C","text":"Discharge no treatment"},{"label":"D","text":"Wrist arthrodesis"},{"label":"E","text":"B6 supplementation high dose as primary treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Moderate Carpal Tunnel Syndrome (CTS) Without Severe Atrophy: (1) **conservative first-line trial** for mild-moderate CTS without thenar atrophy or severe NCS findings: (a) **night splinting** in neutral wrist (most effective conservative — moderate evidence — 12-week trial), (b) activity modification + ergonomic adjustments, (c) **corticosteroid injection** (short-term relief 6-12 weeks — useful diagnostic-therapeutic), (d) NSAIDs (limited evidence), (e) PT — nerve gliding exercises, tendon gliding (limited evidence), (f) hand therapy; (2) **avoid prolonged oral steroids** + ineffective treatments (B6, ultrasound, laser — weak/no evidence per AAOS); (3) **surgical carpal tunnel release** indicated: (a) failure of 6-12 weeks conservative + significant symptoms affecting QoL, (b) thenar atrophy + weakness (urgent — irreversible if delayed), (c) severe CTS on NCS (axonal loss), (d) acute CTS (trauma, burns, pregnancy) — urgent release; (4) **surgical options**: open carpal tunnel release (gold standard, longer scar, equivalent outcomes), **endoscopic CTR** (faster early recovery, slightly higher transient nerve injury, equivalent long-term outcomes), mini-incision; (5) post-op: early ROM, return to light activity 1-2 weeks, heavy 4-6 weeks; (6) outcomes excellent > 90% symptomatic relief; (7) screen comorbidities (DM, hypothyroid, RA, amyloidosis, pregnancy, obesity)

---

CTS: most common upper extremity compression neuropathy. Conservative — night splinting most effective, steroid injection short-term, activity modification. Surgery (CTR) for failed conservative, thenar atrophy (urgent), severe NCS, acute. Open vs endoscopic similar long-term. Screen comorbidities (DM, hypothyroid, RA, amyloid). Outcomes > 90%.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 50 ปี พิมพ์งานมาก ปวด + ชาฝ่ามือ + นิ้วโป้ง + ชี้ + กลาง โดยเฉพาะตอนกลางคืน 6 เดือน ตื่นมาสะบัดมือดีขึ้น

PE: positive Tinel + Phalen + carpal compression test, normal pinch, no significant thenar atrophy yet, normal sensation 5th finger

NCS: median nerve conduction slowed at carpal tunnel — distal motor latency > 4.5 ms + sensory latency abnormal — moderate CTS';

update public.mcq_questions
set choices = '[{"label":"A","text":"Always surgical release first line"},{"label":"B","text":"Trigger Finger Quinnell Grade III in Diabetic"},{"label":"C","text":"Discharge no treatment"},{"label":"D","text":"Long-term oral steroid"},{"label":"E","text":"Cast immobilization 12 weeks"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Trigger Finger Quinnell Grade III in Diabetic: (1) **corticosteroid injection** into flexor tendon sheath (A1 pulley level) — first-line for most trigger fingers (60-90% resolution; less effective in diabetics — 50-60%; consider up to 2-3 injections); (2) **splinting** — MCP extension splint (PIP/DIP free) for 6-8 weeks effective for mild cases — moderate evidence; (3) NSAIDs + activity modification; (4) **surgical A1 pulley release** indicated: failure of 2-3 steroid injections + splinting, severe locking, persistent symptoms, multiple fingers, diabetic (lower steroid response): (a) **open A1 pulley release** (gold standard, small incision, excellent outcomes > 95%), (b) percutaneous needle release (faster, alternative — less common in Thailand); (5) **diabetic considerations**: lower steroid injection response, higher recurrence, may need earlier surgery; control HbA1c; (6) **screen other tendinopathies** common in DM (CTS, Dupuytren, frozen shoulder, stiff hand syndrome — "cheiroarthropathy"); (7) post-op: immediate motion + scar management; (8) **pediatric trigger thumb** (Notta''s nodule, flexion contracture IP joint) — many resolve spontaneously by age 1-3; surgical release at age 1-3 if persistent

---

Trigger finger (stenosing flexor tenosynovitis): A1 pulley constriction. Steroid injection first-line (60-90% — lower in diabetics 50-60%, up to 2-3 injections). Splinting moderate evidence. Surgery (open A1 release) for failed injection — > 95% success. Diabetics need earlier surgery + screen other diabetic tendinopathies. Pediatric trigger thumb — observe to age 1-3.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 55 ปี DM2 underlying ปวดนิ้วกลางขวา + ติดขัด 4 เดือน เริ่มมี locking + popping ตอนงอ + เหยียดนิ้ว ตอนนี้บางครั้งต้องใช้มืออีกข้างช่วยเหยียด

PE: palpable nodule volar A1 pulley level metacarpal head 3rd finger, painful triggering on flexion-extension, mild flexion contracture beginning

Dx: stenosing flexor tenosynovitis (trigger finger) right middle finger — Quinnell grade III (locked, requires passive extension)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Surgical release first line for all"},{"label":"B","text":"De Quervain Tenosynovitis Postpartum (\"Mother Thumb\")"},{"label":"C","text":"Long-term oral steroid"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Cast immobilization 12 weeks long-arm"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** De Quervain Tenosynovitis Postpartum ("Mother Thumb"): (1) **conservative first-line**: (a) **thumb spica splint** (radial gutter spica including IP free) 4-6 weeks — moderate evidence; (b) activity modification (avoid repetitive thumb abduction + ulnar wrist deviation, reposition baby holding), (c) NSAIDs (caution if breastfeeding — ibuprofen safest), (d) ice; (2) **corticosteroid injection** into first dorsal compartment — highly effective (60-90% resolution); cautions: skin atrophy, depigmentation, fat necrosis (postpartum patients more sensitive); subsheath of EPB may need separate injection (anatomical variant — septum between APL + EPB in 30-60%); (3) **surgical release of first dorsal compartment** for failure of 2 injections + splinting: open release, identify + protect superficial radial nerve, release ALL subcompartments including any EPB subsheath (failure to release subsheath = surgical failure); (4) **postpartum cases** often resolve when stop nursing (hormonal contribution); (5) **bilateral involvement common** postpartum; (6) screen RA + inflammatory arthritis if atypical; (7) outcomes excellent > 90% with adequate treatment

---

De Quervain: APL + EPB tenosynovitis. Postpartum/mothers common ("mother thumb"). Conservative: thumb spica splint + NSAIDs (caution breastfeeding). Steroid injection highly effective (60-90%) — beware EPB subsheath separate compartment in 30-60%. Surgery for failed conservative — release ALL subcompartments, protect superficial radial nerve. Often resolves spontaneously postpartum.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 32 ปี postpartum 3 เดือน ปวดด้านนอกข้อมือซ้ายโคนนิ้วโป้ง 6 สัปดาห์ ปวดมากขึ้นเมื่ออุ้มลูก + บีบ + ยกของ

PE: tender + swelling first dorsal compartment (over radial styloid), positive Finkelstein test (passive ulnar deviation of wrist with thumb in fist reproduces pain), no neurologic deficit

Dx: De Quervain tenosynovitis ("new mother thumb") — APL + EPB tenosynovitis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Always observation regardless of severity"},{"label":"B","text":"Dupuytren Contracture with Positive Hueston Tabletop Test — Intervention Indicated"},{"label":"C","text":"Total hand arthrodesis"},{"label":"D","text":"Long-term steroid injection palm"},{"label":"E","text":"Above-elbow amputation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Dupuytren Contracture with Positive Hueston Tabletop Test — Intervention Indicated: (1) **observation acceptable** for early/mild without functional impairment (nodules only, no significant cord, no contracture, contracture < 30°); (2) **intervention indicated** when: (a) positive tabletop test (cannot lay hand flat), (b) MCP contracture > 30°, (c) any PIP contracture > 15-20° (PIP harder to correct, residual deformity common — earlier intervention), (d) functional impairment + patient desire; (3) **treatment options**: (a) **needle aponeurotomy/fasciotomy (NA — percutaneous)** — minimally invasive, lower morbidity, faster return, higher recurrence (50-65% at 5 years); good for MCP > PIP, cords > nodules, single cord; outpatient procedure; (b) **collagenase Clostridium histolyticum (CCH) injection** — Xiaflex — injection of collagenase into cord + manipulation 24-48h later; equivalent results to NA; not available in all settings; (c) **open limited fasciectomy** — gold standard — better long-term outcomes, lower recurrence (20-30% at 5 yr), more morbidity, longer recovery; (d) **dermofasciectomy + skin graft** — recurrent disease or aggressive Dupuytren diathesis; (e) **PIP arthroplasty/amputation** — end-stage with non-functional finger; (4) **Dupuytren diathesis** (younger onset, bilateral, ectopic — Ledderhose plantar, Peyronie''s, knuckle pads, family history, ethnic — Nordic) → higher recurrence; (5) post-op: splinting, hand therapy, ROM; (6) recurrence universal — counsel patients; (7) avoid surgery if not significantly limiting function

---

Dupuytren contracture: palmar fibromatosis. Intervention for positive tabletop test, MCP > 30°, PIP > 15-20°. Options: NA (minimally invasive, higher recurrence), collagenase, open fasciectomy (gold standard, lower recurrence). PIP harder to correct — earlier intervention. Dupuytren diathesis (Nordic, young, bilateral, ectopic) → higher recurrence. Splint + hand therapy post-op.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 65 ปี Nordic descent ค่อย ๆ เกิดก้อนแข็งฝ่ามือ + นิ้วงอเข้าหาฝ่ามือ 2 ปี ตอนนี้ไม่สามารถวางมือราบบนโต๊ะได้

PE: palpable longitudinal cords ฝ่ามือ → 4th + 5th finger MCP + PIP flexion contracture: 4th MCP 30°, 5th MCP 40° + PIP 30°, positive **Hueston tabletop test**, no skin breakdown

Dx: Dupuytren contracture (palmar fibromatosis) — MCP > 30° + PIP contracture';

update public.mcq_questions
set choices = '[{"label":"A","text":"Suture skin only no tendon repair"},{"label":"B","text":"Flexor Tendon Laceration Zone II (Both FDS + FDP) — Operative Repair"},{"label":"C","text":"Discharge no surgery"},{"label":"D","text":"Cast immobilization 12 weeks no motion protocol"},{"label":"E","text":"Amputation finger"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Flexor Tendon Laceration Zone II (Both FDS + FDP) — Operative Repair: (1) **operative primary repair within 24-72 hours preferred** (acute) or delayed primary 1-2 weeks (subacute) — better outcomes; > 4-6 weeks requires staged reconstruction (silicone Hunter rod → tendon graft); (2) **surgical technique**: bring proximal cut end down (often retracted to palm — must retrieve carefully), repair with core suture (modified Kessler, Strickland, 4-strand or 6-strand cruciate/Tang) + epitendinous running suture, preserve pulleys A2 + A4 (functional — sliding fulcrum); repair FDS + FDP both (preserves intrinsic strength of FDS); (3) **digital nerve repair** if cut concurrently (microsurgical 8-0 or 9-0 nylon epineural); (4) **post-op rehabilitation critical** — early protected motion (Duran passive, Kleinert active extension with passive flexion via rubber band traction, or **modern early active motion protocols**) under expert hand therapy → reduces adhesions + improves tendon glide; (5) **avoid total immobilization** > 3 weeks (causes adhesions); (6) **avoid full active grasp** × 6 weeks (rupture risk); (7) **antibiotic prophylaxis** (single dose cefazolin); (8) **tetanus update**; (9) **fight bite/animal bite** specific (amoxicillin-clavulanate, debridement); (10) **complications**: tendon rupture (5-10%), adhesions requiring tenolysis, stiffness, neuroma; (11) outcomes Strickland classification post-op; (12) Zone II historically poor outcomes — "no man''s land" — modern early motion + suture techniques improved

---

Flexor tendon Zone II laceration: "no man''s land". Primary repair < 24-72h optimal. Core suture (Kessler/Strickland 4-strand or modern 6-strand) + epitendinous + preserve A2/A4 pulleys + repair both FDS + FDP. Early protected motion (modern early active) prevents adhesions. Antibiotic + tetanus. Outcomes improving. Hand therapy critical post-op.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 28 ปี โดนคมมีดบาดฝ่ามือซ้าย 4 ชั่วโมงก่อน volar surface นิ้วชี้ — wound 1.5 cm มี active bleeding

PE: wound volar PIP joint level (Zone II — "no man''s land" — between A1 pulley + FDS insertion), inability to flex DIP (FDP cut) + inability to flex PIP with adjacent fingers held (FDS cut), normal sensation digital nerves both sides, capillary refill 2 s

Dx: complete flexor tendon laceration (both FDS + FDP) Zone II + intact digital nerves + adequate vascular supply';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge no treatment hematoma"},{"label":"B","text":"Nail Bed Laceration + Subungual Hematoma + Tuft Fracture (Open Distal Phalanx)"},{"label":"C","text":"Long-term antibiotic 2 weeks oral"},{"label":"D","text":"Amputation finger"},{"label":"E","text":"Cast forearm 12 weeks long-arm"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Nail Bed Laceration + Subungual Hematoma + Tuft Fracture (Open Distal Phalanx): (1) **digital block anesthesia**; (2) **remove nail plate** (carefully with Freer elevator) ถ้า nail bed laceration apparent + > 50% subungual hematoma — historically advised, modern evidence challenges nail removal for intact nail with isolated hematoma; (3) **trephination** of small (< 50%) hematoma with intact nail using heated paper clip or electrocautery for analgesia (no advantage to drainage with intact nail per recent evidence); (4) **nail bed laceration repair** using **6-0 absorbable suture (chromic gut, Vicryl Rapide)** under loupe magnification — meticulous approximation; alternative — dermabond (skin glue) for simple lacerations (comparable outcomes — faster, less painful); (5) **replace nail or substitute** (foil, Reston foam, silicone) into nail fold as **eponychial stent** to prevent synechiae + maintain eponychial fold; (6) **tuft fracture management**: open fracture (communicating with nail bed) → antibiotic prophylaxis cefazolin/cephalexin 24 hours; usually stable + nail bed repair sufficient; pinning rarely needed; (7) **tetanus update**; (8) splint distal IP × 2 weeks; (9) follow-up 7-14 days; (10) counseling: nail regrowth 3-6 months, may grow abnormally (ridges, deformity, hooked); (11) avoid prolonged antibiotics + extensive debridement; (12) **Seymour fracture** (pediatric — Salter-Harris I/II of distal phalanx with nail bed injury, mistaken for mallet) — emergent reduction + nail bed repair + pin (high infection risk if missed)

---

Nail bed injury: digital block → remove nail → repair laceration with 6-0 absorbable (or dermabond) → eponychial stent (nail or substitute) → splint. Open tuft fracture (communicating) — short course antibiotics. Modern evidence — intact nail with subungual hematoma trephination alone sufficient. Pediatric Seymour fracture: emergent reduction + nail bed repair + pin. Nail regrowth 3-6 months.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 24 ปี ประตูปิดทับปลายนิ้วกลางขวา ปวด + บวม + เลือดออกใต้เล็บ + เล็บแยกออก partial 50% lacerated nail + visible subungual hematoma 70%

PE: nail plate avulsed partial, nail bed laceration visible, tuft fracture distal phalanx on X-ray, intact NV, no flexor tendon injury

X-ray: small tuft fracture distal phalanx (open — communicates with nail bed laceration)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge with cast looser"},{"label":"B","text":"Acute Forearm Compartment Syndrome — Emergent Fasciotomy"},{"label":"C","text":"Elevate limb high above heart"},{"label":"D","text":"Diuretics IV"},{"label":"E","text":"Above-elbow amputation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Forearm Compartment Syndrome — Emergent Fasciotomy: (1) **immediate cast/dressing removal** + bandage release; (2) limb at heart level (NOT elevated — reduces perfusion); (3) IV fluid + maintain BP; (4) pain control; (5) **emergent forearm fasciotomy** within hours (irreversible after 6-8 hours): (a) **volar fasciotomy** (Henry approach) — curvilinear incision from medial epicondyle across antecubital fossa (S-shape lacertus + bicipital aponeurosis release) extending to wrist → carpal tunnel release; release superficial + deep flexor compartments + mobile wad (brachioradialis, ECRL/ECRB); (b) **dorsal fasciotomy** — straight incision dorsal forearm releasing extensor compartment (often required); (c) consider mobile wad release; (6) **leave wounds open + VAC dressing** — secondary closure or skin grafting 5-7 days later; (7) **treat underlying cause** (fracture stabilization, hematoma evacuation); (8) **monitor rhabdomyolysis** (CK, myoglobinuria) → IV fluid + bicarbonate + mannitol; AKI risk; (9) **tetanus** prophylaxis; (10) **long-term complications**: Volkmann''s ischemic contracture (claw hand from FDP + FPL fibrosis), nerve injury (median > ulnar), CRPS, chronic pain; (11) **Volkmann''s contracture treatment** chronic: tendon lengthening, infarct excision, free functional muscle transfer (gracilis); (12) multidisciplinary: ortho + hand + plastic + ICU

---

Forearm compartment syndrome: clinical diagnosis. Pain out of proportion + passive stretch pain key. Pressure > 30 mmHg or ΔP < 30 mmHg → emergent fasciotomy. Volar + dorsal release + mobile wad + carpal tunnel. Open wounds + VAC + delayed closure. Volkmann''s contracture sequel if missed (claw hand). Rhabdo + AKI screen. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 35 ปี s/p ORIF both-bone forearm fracture 24 ชั่วโมงก่อน เริ่มปวดมากขึ้นใน cast + ชาปลายนิ้ว + ปวดมากเมื่อ passive extension นิ้ว

PE: cast tight + opens → forearm tense + extremely tender, severe pain with passive finger extension (stretch of compartment), paresthesia median + ulnar distribution, finger pulses palpable, capillary refill 3 s
Compartment pressure forearm: 50 mmHg, BP 110/70 (DBP 70 — perfusion pressure = 70-50 = 20 mmHg — critical)

Dx: forearm acute compartment syndrome post-ORIF';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge with revision amputation always"},{"label":"B","text":"Acute Traumatic Thumb Amputation — Replantation Strongly Indicated"},{"label":"C","text":"Replant after 24 hours warm ischemia"},{"label":"D","text":"Discard amputated part"},{"label":"E","text":"Above-elbow amputation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Traumatic Thumb Amputation — Replantation Strongly Indicated: (1) **thumb replantation indication very strong** เพราะ thumb essential for hand function (40% of hand function) — replant for nearly all thumb amputations even with marginal candidacy; (2) **other strong indications**: multiple digit, pediatric (any level), forearm/wrist/palm-level amputation, sharp/clean amputation, motivated patient; (3) **relative contraindications**: single finger distal to FDS insertion (poor functional gain — except thumb), severe crush/avulsion, prolonged warm ischemia (> 6h digit, > 12h hand), severe systemic illness, mental health prohibiting compliance, smokers (relative — counsel cessation), self-inflicted; (4) **transport**: amputated part — wrap in saline-moistened gauze → seal in plastic bag → place on ice (NOT direct ice — cold injury); cold ischemia tolerance: digit 12-24 hours, hand/forearm 6-12 hours; (5) **operative**: bone shortening + fixation (K-wire, screw), tendon repair (flexor + extensor), arterial anastomosis (1-2 arteries — vein graft if needed), 2 dorsal vein anastomoses, nerve repair, skin closure (loose, may need graft); microsurgical anastomosis with operating microscope; (6) post-op: anticoagulation (aspirin, heparin, dextran), warming, no caffeine/nicotine, leech therapy for venous congestion, monitoring (color, capillary refill, temperature, doppler); (7) survival rates: thumb 70-90%, multiple digit 65-85%, single non-thumb 50-80%; (8) revision amputation alternative if not replantable (preserve length, optimal stump, prosthesis); (9) hand therapy 3-12 months

---

Thumb amputation: strong indication for replantation (40% of hand function). Transport amputated part: saline gauze → plastic bag → on ice (not direct). Cold ischemia 12-24h digit, 6-12h hand. Replantation: bone fixation → tendon → 1-2 artery → 2 veins → nerve. Post-op anticoagulation + leech + monitoring. Survival 70-90% thumb. Hand therapy 3-12 months.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 30 ปี โรงงาน เครื่องตัดนิ้วโป้งซ้ายขาดที่ระดับ proximal phalanx (clean cut) นำส่งรพ. ภายใน 2 ชั่วโมง พร้อม amputated thumb เก็บถูกต้อง (gauze ชุ่มน้ำเกลือ + ถุงพลาสติก + แช่น้ำแข็ง — ไม่แตะน้ำแข็งโดยตรง)

PE: clean amputation thumb proximal phalanx level, bleeding controlled with pressure + tourniquet, no other injuries, distal hand viable, healthy patient no comorbidity, non-smoker

Ischemia time: warm 2h, then cold preservation 2h';

update public.mcq_questions
set choices = '[{"label":"A","text":"Immediate excision all ganglion cysts"},{"label":"B","text":"Dorsal Wrist Ganglion Cyst — Mostly Conservative"},{"label":"C","text":"Strike with book (Bible therapy)"},{"label":"D","text":"Long-term oral steroid"},{"label":"E","text":"Amputation finger"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Dorsal Wrist Ganglion Cyst — Mostly Conservative: (1) **reassurance + observation** — most common: ganglion cysts may resolve spontaneously (50% in adults, even higher in children); benign, no malignant potential, may fluctuate in size; counsel; (2) **aspiration with large-bore needle + steroid injection** — moderate success (cure 30-50%, recurrence common 50-70%); useful for symptomatic relief temporarily, diagnostic; cellular components reveal clear gelatinous fluid (mucopolysaccharide); (3) **avoid "home remedies"** — striking with book (Bible therapy) — outdated, can cause iatrogenic injury; (4) **surgical excision** indicated for: (a) persistent symptomatic ganglion (pain, weakness, limitation of activities), (b) cosmetic concern after counseling, (c) failed aspiration with recurrence + symptoms, (d) atypical features suggesting other diagnosis; (5) **surgical technique**: complete excision including capsular attachment (often scapholunate ligament — dorsal — or palmar carpal ligaments); arthroscopic excision modern alternative (smaller scar, similar recurrence ~10-20%); open ~5-15% recurrence; (6) **occult dorsal ganglion** — small intraosseous or intra-articular — may cause wrist pain without palpable mass; MRI diagnosis; (7) ulnar-side wrist pain workup if atypical — TFCC, ECU; (8) **mucous cyst** (DIP joint, associated with Heberden node OA) — surgical excision + osteophyte removal; (9) counsel — recurrence even after surgery 5-20%

---

Ganglion cyst: most common hand mass. Benign. 50% spontaneous resolution in adults. Observation primary management. Aspiration + steroid for symptomatic (high recurrence). Avoid Bible therapy. Surgery for persistent symptomatic or cosmesis — excise capsular attachment. Recurrence 5-20% surgery. Mucous cyst (DIP OA) different. Atypical → other workup.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 28 ปี ก้อนที่หลังข้อมือขวา 6 เดือน ค่อย ๆ โตขึ้น ไม่ค่อยปวด แต่กังวล cosmesis + ปวดเล็กน้อยเมื่อทำงาน

PE: 2 cm soft mobile mass over dorsal wrist (scapholunate region), well-defined, transilluminate + (light passes through), not pulsatile, no neurologic deficit, no overlying skin changes

US: anechoic cystic structure 2 cm with no internal vascular flow communicating with dorsal scapholunate joint — dorsal ganglion cyst';

update public.mcq_questions
set choices = '[{"label":"A","text":"Long-term steroid injection cubital tunnel"},{"label":"B","text":"Cubital Tunnel Syndrome (Ulnar Neuropathy at Elbow) Moderate-Severe with Weakness + Atrophy"},{"label":"C","text":"Immediate transposition all patients"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Cast immobilization extension 12 weeks"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cubital Tunnel Syndrome (Ulnar Neuropathy at Elbow) Moderate-Severe with Weakness + Atrophy: (1) **conservative trial 3-6 months** for mild without significant motor deficit: (a) activity modification (avoid prolonged elbow flexion + leaning on elbow), (b) **night splinting** in extension (block elbow flexion > 45°), (c) padding ulnar nerve, (d) NSAIDs; (2) **avoid corticosteroid injection at cubital tunnel** — high risk nerve injury, limited efficacy; (3) **surgical decompression** indicated: (a) failure of 3-6 months conservative + persistent symptoms, (b) **motor weakness, atrophy, severe NCS findings** — earlier surgery (irreversible damage if delayed > 6-12 months with axonal loss), (c) severe pain affecting QoL; (4) **surgical options**: (a) **in situ decompression (simple decompression)** — open or endoscopic — modern preferred for most cases (similar outcomes vs transposition with less morbidity per multiple RCTs and meta-analyses), (b) **anterior transposition** (subcutaneous, intramuscular, submuscular) — historic gold standard, reserved for: subluxating ulnar nerve, prior surgery with kinking, Cubitus valgus deformity, post-traumatic deformity, (c) **medial epicondylectomy** — alternative, less common; (5) post-op: early ROM, return to activity progressively; (6) **outcomes** — better with mild-moderate; advanced with atrophy may not recover fully despite surgery — counsel realistic expectations; (7) screen DM + thyroid + nerve disorders (CMT)

---

Cubital tunnel: 2nd most common compression neuropathy. Conservative (splinting, activity mod) for mild. Surgery for failed conservative + severe (weakness, atrophy). Avoid steroid injection (nerve risk). In situ decompression preferred over transposition (similar outcomes, less morbidity). Transposition for subluxating nerve, deformity. Severe + atrophy → may not fully recover.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 50 ปี ปวด + ชาด้านในข้อศอกขวา + นิ้วก้อย + ครึ่ง 4th finger ulnar side 6 เดือน อาการแย่ลง เริ่มมีความอ่อนแรง grip + hand intrinsics

PE: positive Tinel at cubital tunnel, positive elbow flexion test, decreased sensation small finger + ulnar 4th finger, weakness FDI + DI + adductor pollicis (positive Froment sign), beginning hypothenar atrophy, no claw hand yet

NCS: ulnar nerve conduction velocity slowed at elbow < 50 m/s (normal > 60), motor latency prolonged, evidence axonal loss';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation no treatment"},{"label":"B","text":"Newborn DDH Graf Type IIIa with Positive Ortolani"},{"label":"C","text":"Triple-diaper technique only"},{"label":"D","text":"Spica cast in extension"},{"label":"E","text":"Total hip arthroplasty in newborn"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Newborn DDH Graf Type IIIa with Positive Ortolani: (1) **immediate Pavlik harness** (dynamic abduction-flexion orthosis) — gold standard for newborns + infants < 6 months with dislocated/dislocatable hip: (a) maintains hip in flexion 100-110° + abduction 50-70° (allows physiologic motion within "safe zone" of Ramsey to encourage acetabular development), (b) prevents extension/adduction; (2) **wear 23-24 hours/day** initially → gradual weaning when reduced + acetabulum developing; (3) **monitor with US** every 1-2 weeks; (4) **success rate Pavlik 85-95% for Graf II-III, lower for type IV (irreducible — 50-60%)**; (5) **avoid Pavlik in older infants** (> 6 months — femoral nerve palsy, AVN with rigid fixation), severe dislocations with high femoral head (IV), neuromuscular conditions; (6) **complications of Pavlik**: AVN of femoral head (1-5%), femoral nerve palsy (if too much flexion > 110°), Pavlik disease (residual acetabular dysplasia if used too long > 3-4 weeks without progress); (7) **risk factors** for DDH (mnemonic — "6 F''s"): Female, First-born, Family history, Frank breech, fluid (oligohydramnios), Foot (calcaneovalgus, metatarsus adductus); (8) **screening**: US for risk factors at 6 weeks; AAP — clinical exam at every visit; (9) **if Pavlik fails** (> 3-4 weeks no reduction): closed reduction + spica cast under GA, or open reduction; (10) older infants 6-18 months: closed reduction + spica; > 18 months: open reduction + femoral/pelvic osteotomy; (11) educate parents

---

Newborn DDH: Pavlik harness gold standard < 6 months. 23-24h/day initially. US monitoring. Success 85-95% for Graf II-III. Risk factors (6 F''s): Female, First-born, Family, Frank breech, Fluid, Foot. Complications: AVN, femoral nerve palsy. Beyond 6 months: closed/open reduction + spica/osteotomy. Don''t continue Pavlik > 3-4 weeks if no progress (Pavlik disease).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'เด็กหญิงแรกเกิด 2 สัปดาห์ คลอด breech, มี family history DDH (mother) ตรวจในคลินิกเด็ก

PE: positive Ortolani test (relocation "clunk" of dislocated hip into acetabulum on abduction) + positive Barlow test (provokes posterior dislocation with adduction + posterior pressure) ของ left hip, asymmetric thigh skin folds, no leg length discrepancy obvious yet

US hip (preferred imaging < 4-6 months, before ossification): left hip with alpha angle 50° (normal > 60°), beta angle 65° (normal < 55°), femoral head coverage < 50% — DDH (Graf type IIIa)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Total hip arthroplasty in child"},{"label":"B","text":"Legg-Calvé-Perthes Disease Lateral Pillar B in 7-year-old"},{"label":"C","text":"Bedrest indefinitely"},{"label":"D","text":"Long-term oral steroid"},{"label":"E","text":"Discharge no treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Legg-Calvé-Perthes Disease Lateral Pillar B in 7-year-old: (1) **idiopathic AVN of femoral head** in children 4-10 years — self-limited but residual deformity affects long-term outcome; (2) **principles** — "containment" — keep femoral head contained within acetabulum during fragmentation/reossification → preserves spherical shape + congruency; (3) **treatment based on age + Herring lateral pillar classification + sphericity**: (a) **observation + symptomatic** — age < 6 ปี OR Herring A (lateral pillar height > 50%): expected good outcome with non-op; PT, NSAIDs, activity modification, avoid impact; (b) **containment treatment** — age 6-8 ปี + Herring B/B-C border + femoral head at risk: options bracing (Atlanta, Toronto, Scottish-Rite) — limited evidence; **femoral varus osteotomy** OR **innominate (Salter) osteotomy** — restores containment + sphericity; (c) **older children > 8 ปี + Herring B/C** — surgical containment (femoral or pelvic osteotomy) — improved outcomes (Herring multicenter RCT); (d) **Herring C** (lateral pillar < 50%) — poor prognosis regardless of treatment; salvage procedures (valgus extension osteotomy) for residual deformity; (4) ROM maintenance + abduction key — physical therapy; (5) avoid weight-bearing if severe pain; (6) follow long-term — early hip OA risk → eventual THA in 4th-6th decade for severe; (7) Stulberg classification at maturity predicts outcome (I-II good, III-V hip OA); (8) screen secondary causes if bilateral simultaneous (rule out skeletal dysplasia, hypothyroid)

---

Perthes: idiopathic pediatric AVN. Self-limited but residual deformity → adult hip OA. Containment principle. Treatment: age + Herring lateral pillar guide. < 6 yr or Herring A → observation. 6-8 yr + Herring B/border → containment (osteotomy or brace). > 8 yr + B/C → surgical containment (better outcomes Herring trial). Stulberg outcome at maturity. Eventual THA possible.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'เด็กชายอายุ 7 ปี ปวด groin + thigh ขวา + เดินกระเผลก 6 สัปดาห์, no trauma, ไม่มี fever

PE: limited internal rotation + abduction right hip, Trendelenburg gait, no swelling/effusion, leg length difference < 1 cm

Lab: WBC + ESR + CRP normal (rules out septic arthritis)
X-ray hip: small dense fragmented right femoral epiphysis with crescent sign + lateral pillar lateral height < 50% — Catterall III, Herring (lateral pillar) B → Legg-Calvé-Perthes disease';

update public.mcq_questions
set choices = '[{"label":"A","text":"Oral antibiotics outpatient"},{"label":"B","text":"Pediatric Septic Arthritis of Hip (Kocher 4/4 + Aspiration Confirmatory)"},{"label":"C","text":"Discharge with NSAIDs"},{"label":"D","text":"No aspiration just CT scan"},{"label":"E","text":"Bedrest only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Septic Arthritis of Hip (Kocher 4/4 + Aspiration Confirmatory): (1) **Kocher criteria** for septic vs transient synovitis: fever > 38.5°C, non-weight bearing, ESR > 40, WBC > 12,000; 0 = 0.2%, 1 = 3%, 2 = 40%, 3 = 93%, 4 = 99% probability septic arthritis; modified add CRP > 2 mg/dL; (2) **emergent hip aspiration** under fluoroscopy/US — diagnostic + therapeutic decompression; cell count > 50,000 PMN > 75% suggestive; (3) **emergent arthrotomy + irrigation + debridement** of hip joint within 24 hours — surgical emergency (vs arthroscopy which is acceptable in select centers); (4) **empirical IV antibiotic** after aspiration cultures: (a) **age 3 months - 5 years**: cefazolin or clindamycin (S. aureus most common; consider MRSA empirically if local prevalence); add ceftriaxone if Kingella suspected ("hip pain less ill child"); (b) age < 3 months: vancomycin + cefotaxime (cover GBS, gram-negative, S. aureus); (c) **adolescent + sexually active**: add ceftriaxone (N. gonorrhoeae); (d) sickle cell: cover Salmonella; (5) **IV antibiotic 2-4 weeks then transition oral** with normalized CRP + clinical improvement; total 4-6 weeks; (6) **screen concurrent osteomyelitis** (femoral proximal — common adjacent in hip septic arthritis) — MRI if persistent symptoms; (7) repeat I&D if persistent fever, WBC, CRP; (8) physical therapy; (9) long-term: AVN, growth disturbance, joint damage — counsel; (10) **Kingella kingae** increasingly recognized (PCR diagnostic) in 6-36 months — "less ill" presentation

---

Pediatric septic arthritis hip: emergency. Kocher criteria differentiate from transient synovitis (4/4 = 99% septic). Aspiration + arthrotomy + IV antibiotic. S. aureus most common; consider MRSA, Kingella (PCR, 6-36 mo), Salmonella (SCD), gonococcus (adolescent). 4-6 wk antibiotic. Screen concurrent osteomyelitis (MRI). Long-term AVN/growth risk.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'เด็กชายอายุ 5 ปี ปวด hip ซ้าย + ไม่ยอม weight bear 2 วัน + ไข้ 38.5°C; เคยมี URI 2 สัปดาห์ก่อน

V/S: BP 100/60, HR 130, Temp 38.7°C
PE: hip held flexed-abducted-externally rotated, severe pain ROM especially internal rotation, refuses to bear weight

Lab: WBC 14,500 (PMN 80%), CRP 65, ESR 50, blood culture pending
US hip: joint effusion left hip 6 mm
Kocher criteria: fever > 38.5 (+), non-weight bearing (+), ESR > 40 (+), WBC > 12,000 (+) = 4/4 criteria → 99% probability septic arthritis

Hip aspiration: WBC 110,000 (PMN 92%) — septic arthritis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Long-arm cast 12 weeks"},{"label":"B","text":"Pediatric Buckle (Torus) Fracture of Distal Radius — Low-Risk Stable Fracture"},{"label":"C","text":"Surgery same day"},{"label":"D","text":"Discharge no immobilization"},{"label":"E","text":"Steroid injection"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Buckle (Torus) Fracture of Distal Radius — Low-Risk Stable Fracture: (1) **simple removable splint** for 3-4 weeks — modern evidence (FORCE trial Lancet 2022, multiple meta-analyses) — buckle fractures are inherently stable + heal reliably: **removable splint or soft cast non-inferior to rigid casting**; reduces clinic visits + improves QoL + parent satisfaction; (2) **no reduction needed** (no displacement); (3) **WB allowed**; (4) educate parents — wear splint for activities, can remove for bathing/sleeping after first week; symptoms resolve over weeks; (5) **no routine follow-up X-ray** required (low risk displacement); discharge to PCP follow-up; (6) avoid prolonged casting (deconditioning, costs); (7) NSAIDs for pain (controversial bone healing — limited concern in buckle); (8) **green-stick fracture** (incomplete fracture with cortical disruption of one side + bend of other side) — more unstable than buckle, may need closed reduction + cast 4-6 weeks; (9) **complete fracture** with displacement — reduction + cast 4-6 weeks; (10) **Salter-Harris classification** if physis involved (SH I-V): SH I-II typically closed reduction + cast 4-6 weeks; SH III-IV intra-articular often need anatomic reduction (closed or open) + fixation; SH V poor prognosis growth arrest; (11) growth arrest screening f/u

---

Pediatric buckle (torus) fracture distal radius: inherently stable. Modern evidence: removable splint or soft cast equivalent to rigid cast (FORCE trial). 3-4 weeks. No reduction. WB allowed. No routine follow-up X-ray. Parent education. Differentiate from greenstick (incomplete with displacement — more unstable, needs cast). Salter-Harris classification for physeal injury.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'เด็กหญิงอายุ 8 ปี ตกจักรยานเอามือยันพื้น ปวดข้อมือซ้าย 1 วัน, mild swelling

PE: tenderness distal radius, mild swelling, no obvious deformity, NV intact, no open wound

X-ray wrist: cortical buckle/wrinkle distal radius metaphysis dorsal cortex (no displacement, no angulation) — buckle (torus) fracture pediatric';

update public.mcq_questions
set choices = '[{"label":"A","text":"Total knee arthroplasty in child"},{"label":"B","text":"Juvenile Osteochondritis Dissecans (OCD) of Medial Femoral Condyle — Skeletally Immature with Stable Lesion"},{"label":"C","text":"Continue contact sports immediately"},{"label":"D","text":"Long-term opioid"},{"label":"E","text":"Cast in extension 12 weeks then return to sport"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Juvenile Osteochondritis Dissecans (OCD) of Medial Femoral Condyle — Skeletally Immature with Stable Lesion: (1) **non-operative trial 3-6 months** preferred for juvenile OCD with **open physes + stable lesion** (no fluid behind, intact cartilage): (a) activity modification — restrict impact, running, jumping, contact sports for 3-6 months, (b) non-weight bearing with crutches initially, advance to WB in unloader brace selective, (c) PT — maintain ROM, avoid impact, (d) repeat MRI 3-6 months — healing common in skeletally immature (60-90% heal non-op); (2) **prognosis better in skeletally immature** (open physes) vs adolescent/adult — "adult OCD" (closed physes) has poor non-op outcomes; (3) **surgical treatment** indicated: (a) failure of 3-6 months conservative, (b) unstable lesion (fluid behind fragment on MRI, separation), (c) loose body causing locking, (d) skeletally mature with adult OCD, (e) displaced fragment; (4) **surgical options**: (a) **retrograde drilling** (transarticular or extra-articular) — stable in situ lesion + intact cartilage + skeletally immature; promotes healing; (b) **fixation** (bioabsorbable screws/anchors, Herbert screws) — unstable but salvageable hinged fragment; (c) **removal + cartilage restoration** (microfracture, OATS — osteochondral autograft transfer, ACI/MACI) — irreparable fragment or chronic; (5) post-op: protected WB 6-8 weeks, gradual return to sport 4-6 months; (6) prevention of long-term sequelae (early OA); (7) workup bilateral (15-30%) + screen for OCD elsewhere (capitellum — gymnasts, talus — basketball)

---

Juvenile OCD knee: medial femoral condyle classic (lateral aspect). Wilson test sensitive. Skeletally immature + stable lesion → non-op 3-6 months (60-90% heal). Surgery for unstable, failed conservative, adult OCD. Retrograde drilling, fixation, cartilage restoration. Better prognosis in open physes vs adult. Bilateral 15-30% — screen. Late OA risk.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 14 ปี นักฟุตบอล ปวดเข่าซ้าย + บวมเป็น ๆ หาย ๆ 4 เดือน บางครั้งรู้สึก locking + catching, ไม่มี trauma ชัดเจน

PE: mild effusion, positive Wilson test (pain on internal rotation tibia with knee flexion 90° → 30°, relief with external rotation — classic for medial femoral condyle OCD), no significant ligamentous laxity

MRI knee: osteochondral lesion lateral aspect of medial femoral condyle (classic location), subchondral edema, intact overlying cartilage, no displaced fragment, no fluid behind fragment (stable lesion) — juvenile OCD stage I';

update public.mcq_questions
set choices = '[{"label":"A","text":"Long-term oral steroid"},{"label":"B","text":"Osgood-Schlatter Disease (Apophysitis of Tibial Tubercle) in Adolescent Athlete"},{"label":"C","text":"Cast extension 12 weeks total immobilization"},{"label":"D","text":"Surgical excision tubercle all patients"},{"label":"E","text":"Discharge sports prohibition until 18 years"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Osgood-Schlatter Disease (Apophysitis of Tibial Tubercle) in Adolescent Athlete: (1) **conservative management always — self-limited** condition resolves with skeletal maturity (closure of tibial tubercle apophysis): (a) activity modification (reduce impact activity, modify training during symptomatic period — total rest NOT required), (b) **PT** — hamstring + quadriceps stretching + eccentric strengthening, hip flexor flexibility, biomechanics, (c) ice after activity, (d) NSAIDs short course for pain, (e) infrapatellar strap/sleeve (counterforce — limited evidence), (f) reassurance + education on natural history; (2) **avoid immobilization** (atrophy + deconditioning) except in severe acute exacerbation; (3) **avoid corticosteroid injection** (risk of patellar tendon damage, fat pad atrophy); (4) **uncommon need for surgery** — reserved for: (a) symptomatic ossicle that persists beyond skeletal maturity (10-15%) — excision of ossicle, (b) tibial tubercle avulsion fracture (Ogden classification — separate entity, surgical reduction + fixation); (5) educate patient + family — symptoms intermittent for 12-24 months typically, resolve with maturity; participation in sport modified but allowed; (6) **return to sport** when pain tolerable; (7) **related apophysitis**: Sinding-Larsen-Johansson (inferior pole of patella — apophysitis), Sever''s disease (calcaneal apophysitis), Iselin disease (5th metatarsal base), Little league elbow (medial epicondyle apophysitis) — all similar principles

---

Osgood-Schlatter: tibial tubercle apophysitis in adolescent athletes. Self-limited — resolves with skeletal maturity. Conservative: activity modification + PT (hamstring/quadriceps) + ice + NSAIDs. AVOID steroid injection. Surgery rare — only for persistent symptomatic ossicle post-maturity or tubercle avulsion fracture. Education on natural history. Similar to other apophyses (Sinding-Larsen, Sever, Iselin).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'เด็กชายอายุ 13 ปี Tanner stage III นักฟุตบอล ปวด anterior knee + tender tibial tubercle 3 เดือน ปวดมากขึ้นเวลาวิ่ง + กระโดด + climb stairs ดีขึ้นเมื่อพัก

PE: prominent tender tibial tubercle bilateral, pain on resisted knee extension, no effusion, full ROM, hamstring tightness

X-ray knee lateral: irregularity + fragmentation tibial tubercle apophysis (Osgood-Schlatter changes), no avulsion fragment displacement';

update public.mcq_questions
set choices = '[{"label":"A","text":"Extensive posteromedial release first"},{"label":"B","text":"Idiopathic Bilateral Clubfoot (CTEV) — Ponseti Method First-Line Treatment"},{"label":"C","text":"No treatment self-resolves"},{"label":"D","text":"Bilateral amputation"},{"label":"E","text":"Cast in equinus first to align"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Idiopathic Bilateral Clubfoot (CTEV) — Ponseti Method First-Line Treatment: (1) **Ponseti method gold standard worldwide** — non-operative serial manipulation + casting + percutaneous tenotomy + bracing — > 95% success: (a) **weekly serial long-leg casting** (above-knee, knee 90° flexion) correcting deformities in order — cavus first → adduction → varus → equinus last (using CAVE mnemonic — Cavus, Adductus, Varus, Equinus); each cast incrementally improves position over 4-8 weeks (5-7 casts typical), (b) **percutaneous Achilles tenotomy** at end of casting (in ~80% of cases to correct residual equinus) — done in clinic or minor procedure, (c) post-tenotomy cast 3 weeks in maximum dorsiflexion + abduction; (2) **Denis Browne / Mitchell foot abduction brace** — **23 hours/day × 3 months** → **night + nap brace until age 4-5** — critical for preventing relapse (most common cause of treatment failure = brace non-compliance, family education essential); (3) **relapse rate 20-40%** — manage with re-casting + repeat tenotomy + bracing; **tibialis anterior tendon transfer (TATT)** for dynamic supination (recurrent dynamic deformity in ambulating child > 2 ปี); (4) **avoid extensive soft tissue release** (historic — PMR posteromedial release) — worse long-term outcomes (stiffness, pain, OA); only for severe atypical/syndromic cases that fail Ponseti; (5) **screen DDH + spinal dysraphism** (associated); (6) syndromic clubfoot (arthrogryposis, myelomeningocele) — modified Ponseti, more difficult, higher relapse

---

Clubfoot (CTEV): Ponseti method gold standard, > 95% success. Weekly serial casting (correct CAVE order) + percutaneous Achilles tenotomy (80%) + Denis Browne abduction brace (23h × 3 mo then nights until 4-5 yr). Relapse 20-40% — recasting, repeat tenotomy, TATT (dynamic deformity > 2 yr). AVOID extensive soft tissue release. Screen DDH + spinal dysraphism. Syndromic harder.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ทารกแรกเกิด อายุ 3 วัน ตรวจพบ bilateral clubfoot (talipes equinovarus — CTEV): foot in equinus + cavus + adduction + varus, rigid, idiopathic, no syndromic features, full-term, healthy

Pirani score 5.5 (severe rigid deformity)
No neurological deficit, normal hip exam (rule out concurrent DDH)
No other anomalies';

update public.mcq_questions
set choices = '[{"label":"A","text":"Long-term oral steroid"},{"label":"B","text":"Sever''s Disease (Calcaneal Apophysitis) in Adolescent Athlete — Self-Limited"},{"label":"C","text":"Cast immobilization 12 weeks long-leg"},{"label":"D","text":"Surgical excision apophysis"},{"label":"E","text":"Sports prohibition until 18 years"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Sever''s Disease (Calcaneal Apophysitis) in Adolescent Athlete — Self-Limited: (1) **conservative management** — Sever''s resolves with closure of calcaneal apophysis (typically age 14-16): (a) activity modification (reduce running/jumping during symptomatic phase; total rest unnecessary), (b) **Achilles + calf stretching** + hamstring flexibility, (c) **heel cushion** (gel cup) or heel lift bilateral — reduces strain on apophysis, (d) appropriate supportive footwear, (e) ice after activity, (f) NSAIDs short course; (2) **PT** — eccentric strengthening when acute pain settled, biomechanics, gait; (3) **reassurance + education** — benign self-limited condition, no long-term sequelae; (4) **screen overtraining + training error** (rapid increase in volume/intensity); (5) **avoid immobilization** (cast) except severe — causes deconditioning; (6) **avoid corticosteroid injection** (apophyseal injection risk); (7) **differential**: stress fracture calcaneus (older + persistent pain — MRI), plantar fasciitis (less common in children), Achilles tendinopathy, infection (rare); (8) related apophyseal injuries: Osgood-Schlatter, Sinding-Larsen-Johansson, Iselin, Little league elbow — similar principles; (9) **return to sport** when pain tolerable

---

Sever''s disease: calcaneal apophysitis in adolescent athletes. Self-limited — resolves with apophyseal closure (age 14-16). Conservative: activity modification + Achilles stretching + heel cushion + supportive shoes + NSAIDs. AVOID steroid injection + prolonged immobilization. Reassurance — no long-term sequelae. Rule out stress fracture if persistent. Similar to other apophysitis.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'เด็กชายอายุ 11 ปี นักฟุตบอล ปวดส้นเท้าทั้ง 2 ข้าง 6 สัปดาห์ ปวดมากเวลาวิ่ง + กระโดด ดีขึ้นเมื่อพัก ไม่มีปวดตอนกลางคืน

PE: tender medial + lateral aspect calcaneal apophysis bilateral, positive Sever sign (pain on medio-lateral compression of calcaneus), tight Achilles, normal ROM, no swelling, no erythema

X-ray heel: irregular fragmentation calcaneal apophysis (normal variant — NOT diagnostic; clinical diagnosis)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge no follow-up"},{"label":"B","text":"Toddler Fracture (CAST — Childhood Accidental Spiral Tibial Fracture) — Benign Isolated Injury"},{"label":"C","text":"Surgery same day"},{"label":"D","text":"Above-knee amputation"},{"label":"E","text":"Long-term opioid"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Toddler Fracture (CAST — Childhood Accidental Spiral Tibial Fracture) — Benign Isolated Injury: (1) **brief diagnostic + therapeutic immobilization** — long-leg cast or **above-knee posterior splint** 3-4 weeks (some advocate short-leg cast or even no immobilization in select cases — boot/CAM walker emerging evidence — but long-leg cast remains standard); (2) **non-weight bearing initially**, gradual return as comfortable; (3) **child will heal completely** — toddler fractures uncomplicated; (4) **important — rule out non-accidental trauma (NAT/child abuse)** especially: (a) history doesn''t match injury, (b) delayed presentation, (c) multiple fractures different ages on skeletal survey, (d) metaphyseal corner fractures ("bucket handle" — pathognomonic for NAT), (e) rib fractures (especially posterior), (f) bilateral, (g) child < 12 months (very rare cause of fracture from accidental walking), (h) other suspicious signs (bruising, scalds, withdrawal); (5) **mandatory reporting** if NAT suspicion to child protective services + social work; (6) **skeletal survey** if suspicion (multiple fractures, child < 2 ปี with suspicious fracture); (7) **classic isolated toddler tibial fracture in walking child (12-36 months) with appropriate history** — benign; (8) follow-up X-ray 2-3 weeks to confirm healing; (9) **differential**: occult infection (osteomyelitis), transient synovitis hip (referred pain), septic arthritis, leukemia (atypical limp without fracture)

---

Toddler fracture: spiral tibia in toddler 12-36 mo. Long-leg cast 3-4 weeks. Excellent healing. CRITICAL — rule out NAT especially atypical history, multiple fractures, metaphyseal corner, posterior rib, < 12 mo, bilateral. Mandatory reporting + skeletal survey if suspicious. Classic isolated case with witnessed/typical mechanism — benign. Always think of child abuse in pediatric fractures.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'เด็กชายอายุ 18 เดือน เริ่มไม่ยอมเดิน + กระเผลก 2 วัน parents ไม่เห็น clear trauma history ไม่มี fever, ไม่มี erythema

PE: refuses to bear weight on right leg, mild tenderness mid-tibial shaft + holds leg slightly externally rotated, no overt swelling/deformity, normal hip exam + knee exam, no skin signs

X-ray tibia: subtle oblique non-displaced fracture distal third tibia (spiral) — toddler fracture (childhood accidental fracture from minor twisting)
No metaphyseal corner fractures or other suspicious signs';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait until age 18 to decide"},{"label":"B","text":"Postaxial Polydactyly Type B (Pedunculated) — Newborn"},{"label":"C","text":"Amputation entire hand"},{"label":"D","text":"Long-term steroid"},{"label":"E","text":"Discharge no treatment ever"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Postaxial Polydactyly Type B (Pedunculated) — Newborn: (1) **simple ligation/clip** at base of pedicle in newborn (vascular clip applied to pedicle) — historical method — concern with bleb stump + neuroma; (2) **modern preferred — surgical excision at base in clinic OR** — better cosmetic outcome with elimination of stump/neuroma + sutured closure; can be done in clinic with local anesthesia in newborns (no need for GA); (3) **timing** — early excision (within first weeks or months) reduces psychological + cosmetic issues; (4) **Type A postaxial polydactyly** (with bone + nail + functional digit) — formal surgical removal under GA — typically 12-24 months old, more complex (skin, bone, joint, ligament, tendon, neurovascular reconstruction); (5) **preaxial (radial-sided, thumb)** polydactyly — Wassel classification, more complex reconstructive (preserve dominant thumb or combine — Bilhaut-Cloquet, on-top plasty) at 12-24 months; (6) **screen syndromic** if multiple anomalies, atypical, family history — Bardet-Biedl, trisomy 13, Down syndrome — refer genetics; (7) **isolated postaxial polydactyly** — often familial (AD with variable penetrance), more common in African populations, otherwise unremarkable; (8) parental counseling + reassurance

---

Polydactyly: postaxial type B (pedunculated) → simple excision at base (modern preferred over ligation/clip — better cosmetic). Done in clinic with local. Type A (functional digit) and preaxial (thumb) — formal surgical reconstruction at 12-24 months (Wassel classification, Bilhaut-Cloquet). Screen syndromic if atypical/multiple anomalies. Common AD familial isolated case — reassurance.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ทารกแรกเกิด ตรวจพบ extra digit (postaxial polydactyly) นิ้วก้อยข้างขวา + นิ้วเสริมเชื่อมต่อบาง ๆ ผ่าน skin pedicle เท่านั้น (no bony connection, no functional structures)
Polydactyly type B (pedunculated)

Family history: father had similar finding removed
No other anomalies, no syndromic features';

update public.mcq_questions
set choices = '[{"label":"A","text":"Excisional biopsy in community hospital first"},{"label":"B","text":"Conventional High-Grade Osteosarcoma Distal Femur in Adolescent"},{"label":"C","text":"Amputation always (no limb salvage)"},{"label":"D","text":"Radiation only no chemotherapy"},{"label":"E","text":"Discharge no treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Conventional High-Grade Osteosarcoma Distal Femur in Adolescent: (1) **multidisciplinary care at sarcoma center** essential — orthopedic oncology, medical oncology, radiation oncology, pediatric oncology, pathology; (2) **neoadjuvant chemotherapy** (typically MAP — methotrexate, doxorubicin/Adriamycin, cisplatin) × 10 weeks → reassess response → wide surgical resection → adjuvant chemotherapy based on histologic response (Huvos grading — > 90% necrosis = good response); (3) **wide surgical resection** with negative margins — limb salvage preferred over amputation when feasible (oncologic equivalence proven): (a) endoprosthetic reconstruction (megaprosthesis), (b) allograft reconstruction, (c) allograft-prosthesis composite, (d) expandable prosthesis in skeletally immature, (e) **rotationplasty** alternative (especially in young children — durable, functional); (4) **amputation** for: extensive neurovascular involvement, poor chemotherapy response with extensive disease, infection, recurrent; (5) **biopsy planning critical** — must be through planned resection incision (longitudinal, single tract) — avoid contamination of compartments + neurovascular structures; biopsy by treating surgeon ideally; (6) **staging**: bone scan, CT chest (pulmonary mets most common), MRI primary; (7) **5-year survival**: localized 60-70%, metastatic 20-30%; pulmonary metastasectomy improves survival; (8) post-treatment surveillance long-term (recurrence + secondary malignancy from chemo/radiation)

---

Osteosarcoma: aggressive primary bone malignancy of adolescents/young adults. Metaphysis of long bones (distal femur > proximal tibia > proximal humerus). Sunburst + Codman triangle. Treatment: neoadjuvant chemo (MAP) → wide resection (limb salvage preferred) → adjuvant chemo. Biopsy through planned resection incision. Staging — pulmonary mets common. Multidisciplinary sarcoma center. 5-yr 60-70%.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'เด็กชายอายุ 14 ปี ปวด distal thigh ขวา 3 เดือน + ปวดมากตอนกลางคืน + บวมเริ่มเห็นชัด 1 เดือน, ไม่มี trauma

PE: tender + warm mass distal thigh anterolateral, palpable firm mass 8 cm, no joint effusion knee, no neurologic deficit, no constitutional symptoms
Lab: ALP elevated 850 (normal < 350), LDH elevated

X-ray femur: aggressive lytic + sclerotic lesion distal femoral metaphysis with sunburst periosteal reaction + Codman triangle + soft tissue mass
MRI femur: intramedullary mass + extension into soft tissue, no skip lesions
CT chest: no pulmonary metastases
Bone scan: increased uptake distal femur, no other lesions

Biopsy (through future incision line for resection): high-grade conventional osteosarcoma';

update public.mcq_questions
set choices = '[{"label":"A","text":"Radiation alone no chemotherapy"},{"label":"B","text":"Ewing Sarcoma Pelvis with Pulmonary Metastases in Adolescent"},{"label":"C","text":"Discharge as infection treat antibiotics only"},{"label":"D","text":"Surgery only without chemo"},{"label":"E","text":"Above-elbow amputation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ewing Sarcoma Pelvis with Pulmonary Metastases in Adolescent: (1) **multidisciplinary care at sarcoma center**; (2) **neoadjuvant chemotherapy** (VAIA, VIDE, or **VDC/IE** regimens — vincristine, doxorubicin, cyclophosphamide alternating with ifosfamide, etoposide; modern intensified protocols with interval compression) — Ewing is chemo + radiation sensitive (unlike osteosarcoma which is radiation resistant); (3) **local control after neoadjuvant chemo**: (a) **wide surgical resection** preferred when feasible + functional reconstruction; (b) **definitive radiation therapy** alternative when surgery would cause significant morbidity (axial skeleton, pelvis, spine — common in Ewing) or unresectable; (c) **combined surgery + radiation** for marginal resection; (4) **adjuvant chemotherapy** post-local control; (5) **pulmonary metastases** — whole-lung radiation + metastasectomy considered for limited disease — improves survival; (6) **biopsy** through future resection line; molecular confirmation EWS-FLI1 fusion gene (90-95%) or EWS-ERG (5-10%); (7) **staging**: bone scan, PET-CT, CT chest, MRI primary; (8) **5-year survival**: localized 70-80%, metastatic 20-30% (pelvic + axial worse than appendicular); (9) sometimes confused with infection initially (constitutional symptoms, elevated inflammatory markers) — biopsy if atypical; (10) long-term: secondary malignancies, cardiotoxicity (doxorubicin), infertility, growth disturbance — counsel

---

Ewing sarcoma: 2nd most common pediatric bone tumor. Small round blue cell — EWS-FLI1 fusion (90%). Diaphysis or flat bones (pelvis, scapula, ribs). Permeative + onion-skin periosteum. Can mimic infection (fever, ESR). Chemotherapy + radiation sensitive (unlike osteosarcoma). Treatment: neoadjuvant chemo → local control (resection or radiation or both) → adjuvant chemo. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'เด็กชายอายุ 12 ปี ปวด pelvis ซ้าย + บวม + ไข้ intermittent 2 เดือน + น้ำหนักลด 3 kg

PE: palpable mass left iliac wing + tender, low-grade fever, limp
Lab: WBC 13,000, ESR 80, CRP 90 (can mimic infection — "sheep in wolf''s clothing")

X-ray pelvis: permeative lytic lesion left ilium + onion-skin periosteal reaction + large soft tissue mass
MRI: extensive marrow involvement + soft tissue extension
CT chest: small bilateral pulmonary nodules suspicious
Bone scan + PET: increased uptake left iliac + pulmonary nodules + spine

Biopsy: Ewing sarcoma — small round blue cell tumor, EWS-FLI1 fusion confirmed by FISH/PCR';

update public.mcq_questions
set choices = '[{"label":"A","text":"Bedrest until natural fracture"},{"label":"B","text":"Impending Pathologic Fracture Proximal Femur from RCC Metastasis (Mirels Score 11)"},{"label":"C","text":"No surgery palliative care only without embolization"},{"label":"D","text":"Above-knee amputation"},{"label":"E","text":"Discharge no follow-up"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Impending Pathologic Fracture Proximal Femur from RCC Metastasis (Mirels Score 11): (1) **Mirels scoring** for impending pathologic fracture risk (location, pain, lesion type, size): score ≥ 9 → prophylactic fixation strongly recommended (fracture risk > 33%); RCC mets score: proximal femur (3) + functional pain (3) + lytic (3) + > 2/3 width (3) = 12; (2) **prophylactic fixation BEFORE fracture** preferred — better outcomes vs after fracture (less pain, shorter hospitalization, faster recovery): (a) **intramedullary nail (cephalomedullary)** for diaphyseal + peri-trochanteric lesions — gold standard, protects entire bone; (b) **hemiarthroplasty or THA** for femoral head/neck lesions (subcapital, intracapsular); (c) **endoprosthetic reconstruction (megaprosthesis)** for extensive proximal femur destruction; (3) **preoperative considerations**: (a) **RCC mets — hypervascular** → **preoperative arterial embolization 24-48 hours before surgery** to reduce blood loss (can be massive without embolization), (b) cross-match adequate blood products, (c) medical optimization; (4) **postoperative radiation therapy** to surgical site to prevent further local progression + improve durability of fixation (8 Gy × 1 or 20-30 Gy in 5-10 fractions); (5) **systemic therapy** — RCC: tyrosine kinase inhibitors (sunitinib, sorafenib), immunotherapy (nivolumab, pembrolizumab); (6) bisphosphonate or denosumab for bone health, hypercalcemia treatment; (7) **multidisciplinary palliative + oncology team**; (8) functional rehabilitation; (9) survivorship + symptom management

---

Impending pathologic fracture: Mirels score guides (≥ 9 = surgery). Prophylactic fixation > after fracture. IM nail for diaphyseal/peri-trochanteric; arthroplasty for head/neck. RCC mets — HYPERVASCULAR → preoperative embolization essential. Post-op radiation to surgical site. Systemic therapy (TKI, IO). Bisphosphonate/denosumab. Multidisciplinary palliative.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 62 ปี s/p left nephrectomy for RCC 3 ปี ตอนนี้ปวด left femur 6 สัปดาห์ ปวดมากขึ้นเรื่อย ๆ ตอนนี้ขาเริ่มอ่อนแรงเมื่อ weight bear + พร้อมจะหัก

PE: tender thigh proximal, no obvious deformity (impending fracture)
Lab: anemia, hypercalcemia 11.5 (suggests bone destruction)

X-ray femur: lytic destructive lesion proximal femur, > 50% cortical involvement, peri-trochanteric region, axial length > 2.5 cm — Mirels score 11 (likely pathologic fracture)
CT: pulmonary nodules + multiple bony lesions consistent with metastatic disease
MRI: extensive marrow replacement';

update public.mcq_questions
set choices = '[{"label":"A","text":"Surgical fusion all vertebrae empirically"},{"label":"B","text":"Multiple Myeloma with Pathologic Vertebral Compression Fractures (No Neurologic Compromise)"},{"label":"C","text":"Discharge no treatment"},{"label":"D","text":"Wait for pathologic fracture before any treatment"},{"label":"E","text":"High-dose radiation 60 Gy palliative"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multiple Myeloma with Pathologic Vertebral Compression Fractures (No Neurologic Compromise): (1) **multidisciplinary care** — hematology/oncology, orthopedic, radiation oncology, palliative; (2) **systemic chemotherapy** — backbone (induction + maintenance): triplet regimens — bortezomib + lenalidomide + dexamethasone (VRd) or carfilzomib-based; **autologous stem cell transplant** for eligible patients < 70 ปี; CAR-T + bispecific antibodies emerging; (3) **bisphosphonate (zoledronate IV) or denosumab** monthly — reduces skeletal-related events, hypercalcemia, pain (standard of care); long-term — monitor osteonecrosis of jaw, atypical femur fracture; (4) **bracing (TLSO)** for symptomatic vertebral compression fracture pain + support; (5) **vertebroplasty/kyphoplasty** for: persistent severe pain failing conservative > 4-6 weeks, acute fracture with bone marrow edema MRI; selective use; (6) **radiation therapy** for painful bone lesions (low dose 8 Gy × 1 effective for myeloma — highly radiosensitive) — palliative, prevents progression; (7) **surgical decompression + stabilization** indicated for: neurologic compromise, spinal instability, refractory pain after radiation/conservative — usually instrumented fusion; (8) **hypercalcemia management**: IV fluids, bisphosphonate, calcitonin acute, denosumab; (9) **renal preservation** — adequate hydration, avoid nephrotoxins, manage paraprotein; (10) infection prophylaxis (PCP, varicella), VTE prophylaxis (lenalidomide/dex regimen → high VTE risk); (11) **prognosis** — median OS 5-10 years modern; (12) screen for solitary plasmacytoma vs MM

---

Multiple myeloma: clonal plasma cell malignancy. CRAB criteria. M-spike SPEP, Bence-Jones, plasma cells > 10% bone marrow, lytic lesions. Treatment: triplet chemo + ASCT + bisphosphonate/denosumab + radiation for painful lesions (highly radiosensitive). Vertebroplasty for refractory VCF. Surgery for neuro compromise/instability. Multidisciplinary. Mortality from disease + complications (renal, infection).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 68 ปี ปวดหลัง T-spine + lumbar 4 เดือน ค่อย ๆ แย่ลง + อ่อนเพลีย + น้ำหนักลด 8 kg + recurrent infection 2 episodes pneumonia

PE: midline T-spine tenderness, no neurologic deficit, no obvious deformity
Lab: Hb 8.5 (anemia), Cr 2.1 (renal impairment), Ca 11.8 (hypercalcemia), total protein 9.5 (elevated), albumin 3.0 — high gap

SPEP: M-spike IgG kappa monoclonal protein
24-hour urine: Bence-Jones protein +
Serum free light chain: kappa elevated, ratio abnormal
Bone marrow biopsy: 35% plasma cells (clonal)
Skeletal survey + low-dose whole-body CT: multiple lytic "punched-out" lesions skull + vertebra + ribs + pelvis + bilateral pathologic compression fractures T8 + T10

Dx: multiple myeloma (CRAB criteria — hyperCalcemia, Renal, Anemia, Bone)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Amputation hand"},{"label":"B","text":"Giant Cell Tumor of Bone (GCT) — Distal Radius, Campanacci II, Benign Aggressive"},{"label":"C","text":"Radiation primary therapy"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Excisional biopsy in community hospital first"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Giant Cell Tumor of Bone (GCT) — Distal Radius, Campanacci II, Benign Aggressive: (1) **multidisciplinary orthopedic oncology** — GCT is benign but locally aggressive + can metastasize to lung (2-5%, "benign pulmonary metastases") + rare malignant transformation; (2) **intralesional curettage + adjuvant** — gold standard for most: (a) extensive curettage + high-speed burr, (b) **adjuvant** — phenol, liquid nitrogen, hydrogen peroxide, polymethylmethacrylate (PMMA) cement, argon beam — reduces local recurrence (10-30% with curettage alone → 5-15% with adjuvant); (3) **denosumab** (RANKL inhibitor, monoclonal antibody) — neoadjuvant for downstaging unresectable/large GCT or for pulmonary metastases or for primary treatment if surgery unsuitable; ongoing therapy with discontinuation issues (recurrence); (4) **en bloc wide resection** for Campanacci III with extensive cortical breakthrough or recurrence — distal radius is one of preferred sites for en bloc resection + reconstruction (vascularized fibula autograft, allograft, wrist arthrodesis); (5) **lung CT for staging** + surveillance (asymptomatic pulmonary mets often observed or excised); (6) **post-curettage**: PMMA cement provides immediate stability + heat reduces local recurrence; subchondral lesions — bone graft beneath subchondral bone + cement for support; (7) follow-up surveillance long-term (recurrence + lung CT); (8) **don''t confuse with**: ABC (aneurysmal bone cyst — fluid-fluid level on MRI), brown tumor of hyperparathyroidism (check PTH, calcium), chondroblastoma (different location, age)

---

GCT: benign but locally aggressive bone tumor. Young adults 20-40 yr. Epiphyseal/subchondral location (distal femur > proximal tibia > distal radius > sacrum). Treatment: intralesional curettage + adjuvant (PMMA cement, phenol). Denosumab for unresectable/large/mets. En bloc resection for Campanacci III/recurrent. Benign pulmonary mets (2-5%) — CT screening. DDx: ABC (fluid-fluid), brown tumor (HPT), chondroblastoma.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 28 ปี ปวด + บวมข้อมือซ้าย 6 เดือน ค่อย ๆ โตขึ้น ไม่มี trauma

PE: firm mass distal radius, mild tenderness, no neurovascular deficit

X-ray wrist: eccentric subchondral lytic lesion in distal radius epiphysis extending to subchondral bone + cortical thinning + no significant matrix mineralization + "soap bubble" appearance — typical for GCT
MRI: lesion with no cortical breakthrough, no soft tissue mass, no fluid-fluid level (rules out ABC), heterogeneous signal
CT chest: clear (rule out pulmonary mets — GCT can have benign pulmonary mets ~ 2-5%)

Core needle biopsy: giant cell tumor of bone (benign aggressive, Campanacci grade II)';

commit;
