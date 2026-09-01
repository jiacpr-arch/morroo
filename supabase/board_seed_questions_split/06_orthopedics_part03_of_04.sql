-- ===============================================================
-- หมอรู้ — Board seed: ออร์โธปิดิกส์ (orthopedics) — part 3/4 (50 MCQs)
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
  s.id, 'board', NULL, 'หญิงไทยอายุ 50 ปี พิมพ์งานมาก ปวด + ชาฝ่ามือ + นิ้วโป้ง + ชี้ + กลาง โดยเฉพาะตอนกลางคืน 6 เดือน ตื่นมาสะบัดมือดีขึ้น

PE: positive Tinel + Phalen + carpal compression test, normal pinch, no significant thenar atrophy yet, normal sensation 5th finger

NCS: median nerve conduction slowed at carpal tunnel — distal motor latency > 4.5 ms + sensory latency abnormal — moderate CTS', '[{"label":"A","text":"Long-term oral steroid"},{"label":"B","text":"Moderate Carpal Tunnel Syndrome (CTS) Without Severe Atrophy"},{"label":"C","text":"Discharge no treatment"},{"label":"D","text":"Wrist arthrodesis"},{"label":"E","text":"B6 supplementation high dose as primary treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Moderate Carpal Tunnel Syndrome (CTS) Without Severe Atrophy: (1) **conservative first-line trial** for mild-moderate CTS without thenar atrophy or severe NCS findings: (a) **night splinting** in neutral wrist (most effective conservative — moderate evidence — 12-week trial), (b) activity modification + ergonomic adjustments, (c) **corticosteroid injection** (short-term relief 6-12 weeks — useful diagnostic-therapeutic), (d) NSAIDs (limited evidence), (e) PT — nerve gliding exercises, tendon gliding (limited evidence), (f) hand therapy; (2) **avoid prolonged oral steroids** + ineffective treatments (B6, ultrasound, laser — weak/no evidence per AAOS); (3) **surgical carpal tunnel release** indicated: (a) failure of 6-12 weeks conservative + significant symptoms affecting QoL, (b) thenar atrophy + weakness (urgent — irreversible if delayed), (c) severe CTS on NCS (axonal loss), (d) acute CTS (trauma, burns, pregnancy) — urgent release; (4) **surgical options**: open carpal tunnel release (gold standard, longer scar, equivalent outcomes), **endoscopic CTR** (faster early recovery, slightly higher transient nerve injury, equivalent long-term outcomes), mini-incision; (5) post-op: early ROM, return to light activity 1-2 weeks, heavy 4-6 weeks; (6) outcomes excellent > 90% symptomatic relief; (7) screen comorbidities (DM, hypothyroid, RA, amyloidosis, pregnancy, obesity)

---

CTS: most common upper extremity compression neuropathy. Conservative — night splinting most effective, steroid injection short-term, activity modification. Surgery (CTR) for failed conservative, thenar atrophy (urgent), severe NCS, acute. Open vs endoscopic similar long-term. Screen comorbidities (DM, hypothyroid, RA, amyloid). Outcomes > 90%.', NULL,
  'easy', 'neurology', 'review',
  'orthopedics', 'clinical_decision', 'neurology', 'adult',
  'AAOS CTS CPG 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'หญิงไทยอายุ 50 ปี พิมพ์งานมาก ปวด + ชาฝ่ามือ + นิ้วโป้ง + ชี้ + กลาง โดยเฉพาะตอนกลางคืน 6 เดือน ตื่นมาสะบัดมือดีขึ้น

PE: positive Tinel + Phalen + carpal compression test, normal pinch, no significant thenar atrophy yet, normal sensation 5th finger

NCS: median nerve conduction slowed at carpal tunnel — distal motor latency > 4.5 ms + sensory latency abnormal — moderate CTS'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 55 ปี DM2 underlying ปวดนิ้วกลางขวา + ติดขัด 4 เดือน เริ่มมี locking + popping ตอนงอ + เหยียดนิ้ว ตอนนี้บางครั้งต้องใช้มืออีกข้างช่วยเหยียด

PE: palpable nodule volar A1 pulley level metacarpal head 3rd finger, painful triggering on flexion-extension, mild flexion contracture beginning

Dx: stenosing flexor tenosynovitis (trigger finger) right middle finger — Quinnell grade III (locked, requires passive extension)', '[{"label":"A","text":"Always surgical release first line"},{"label":"B","text":"Trigger Finger Quinnell Grade III in Diabetic"},{"label":"C","text":"Discharge no treatment"},{"label":"D","text":"Long-term oral steroid"},{"label":"E","text":"Cast immobilization 12 weeks"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Trigger Finger Quinnell Grade III in Diabetic: (1) **corticosteroid injection** into flexor tendon sheath (A1 pulley level) — first-line for most trigger fingers (60-90% resolution; less effective in diabetics — 50-60%; consider up to 2-3 injections); (2) **splinting** — MCP extension splint (PIP/DIP free) for 6-8 weeks effective for mild cases — moderate evidence; (3) NSAIDs + activity modification; (4) **surgical A1 pulley release** indicated: failure of 2-3 steroid injections + splinting, severe locking, persistent symptoms, multiple fingers, diabetic (lower steroid response): (a) **open A1 pulley release** (gold standard, small incision, excellent outcomes > 95%), (b) percutaneous needle release (faster, alternative — less common in Thailand); (5) **diabetic considerations**: lower steroid injection response, higher recurrence, may need earlier surgery; control HbA1c; (6) **screen other tendinopathies** common in DM (CTS, Dupuytren, frozen shoulder, stiff hand syndrome — "cheiroarthropathy"); (7) post-op: immediate motion + scar management; (8) **pediatric trigger thumb** (Notta''s nodule, flexion contracture IP joint) — many resolve spontaneously by age 1-3; surgical release at age 1-3 if persistent

---

Trigger finger (stenosing flexor tenosynovitis): A1 pulley constriction. Steroid injection first-line (60-90% — lower in diabetics 50-60%, up to 2-3 injections). Splinting moderate evidence. Surgery (open A1 release) for failed injection — > 95% success. Diabetics need earlier surgery + screen other diabetic tendinopathies. Pediatric trigger thumb — observe to age 1-3.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAOS; Quinnell Grading', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'หญิงไทยอายุ 55 ปี DM2 underlying ปวดนิ้วกลางขวา + ติดขัด 4 เดือน เริ่มมี locking + popping ตอนงอ + เหยียดนิ้ว ตอนนี้บางครั้งต้องใช้มืออีกข้างช่วยเหยียด

PE: palpable nodule volar A1 pulley level metacarpal head 3rd finger, painful triggering on flexion-extension, mild flexion contracture beginning

Dx: stenosing flexor tenosynovitis (trigger finger) right middle finger — Quinnell grade III (locked, requires passive extension)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 32 ปี postpartum 3 เดือน ปวดด้านนอกข้อมือซ้ายโคนนิ้วโป้ง 6 สัปดาห์ ปวดมากขึ้นเมื่ออุ้มลูก + บีบ + ยกของ

PE: tender + swelling first dorsal compartment (over radial styloid), positive Finkelstein test (passive ulnar deviation of wrist with thumb in fist reproduces pain), no neurologic deficit

Dx: De Quervain tenosynovitis ("new mother thumb") — APL + EPB tenosynovitis', '[{"label":"A","text":"Surgical release first line for all"},{"label":"B","text":"De Quervain Tenosynovitis Postpartum (\"Mother Thumb\")"},{"label":"C","text":"Long-term oral steroid"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Cast immobilization 12 weeks long-arm"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** De Quervain Tenosynovitis Postpartum ("Mother Thumb"): (1) **conservative first-line**: (a) **thumb spica splint** (radial gutter spica including IP free) 4-6 weeks — moderate evidence; (b) activity modification (avoid repetitive thumb abduction + ulnar wrist deviation, reposition baby holding), (c) NSAIDs (caution if breastfeeding — ibuprofen safest), (d) ice; (2) **corticosteroid injection** into first dorsal compartment — highly effective (60-90% resolution); cautions: skin atrophy, depigmentation, fat necrosis (postpartum patients more sensitive); subsheath of EPB may need separate injection (anatomical variant — septum between APL + EPB in 30-60%); (3) **surgical release of first dorsal compartment** for failure of 2 injections + splinting: open release, identify + protect superficial radial nerve, release ALL subcompartments including any EPB subsheath (failure to release subsheath = surgical failure); (4) **postpartum cases** often resolve when stop nursing (hormonal contribution); (5) **bilateral involvement common** postpartum; (6) screen RA + inflammatory arthritis if atypical; (7) outcomes excellent > 90% with adequate treatment

---

De Quervain: APL + EPB tenosynovitis. Postpartum/mothers common ("mother thumb"). Conservative: thumb spica splint + NSAIDs (caution breastfeeding). Steroid injection highly effective (60-90%) — beware EPB subsheath separate compartment in 30-60%. Surgery for failed conservative — release ALL subcompartments, protect superficial radial nerve. Often resolves spontaneously postpartum.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAOS; Green''s Hand Surgery', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'หญิงไทยอายุ 32 ปี postpartum 3 เดือน ปวดด้านนอกข้อมือซ้ายโคนนิ้วโป้ง 6 สัปดาห์ ปวดมากขึ้นเมื่ออุ้มลูก + บีบ + ยกของ

PE: tender + swelling first dorsal compartment (over radial styloid), positive Finkelstein test (passive ulnar deviation of wrist with thumb in fist reproduces pain), no neurologic deficit

Dx: De Quervain tenosynovitis ("new mother thumb") — APL + EPB tenosynovitis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 65 ปี Nordic descent ค่อย ๆ เกิดก้อนแข็งฝ่ามือ + นิ้วงอเข้าหาฝ่ามือ 2 ปี ตอนนี้ไม่สามารถวางมือราบบนโต๊ะได้

PE: palpable longitudinal cords ฝ่ามือ → 4th + 5th finger MCP + PIP flexion contracture: 4th MCP 30°, 5th MCP 40° + PIP 30°, positive **Hueston tabletop test**, no skin breakdown

Dx: Dupuytren contracture (palmar fibromatosis) — MCP > 30° + PIP contracture', '[{"label":"A","text":"Always observation regardless of severity"},{"label":"B","text":"Dupuytren Contracture with Positive Hueston Tabletop Test — Intervention Indicated"},{"label":"C","text":"Total hand arthrodesis"},{"label":"D","text":"Long-term steroid injection palm"},{"label":"E","text":"Above-elbow amputation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Dupuytren Contracture with Positive Hueston Tabletop Test — Intervention Indicated: (1) **observation acceptable** for early/mild without functional impairment (nodules only, no significant cord, no contracture, contracture < 30°); (2) **intervention indicated** when: (a) positive tabletop test (cannot lay hand flat), (b) MCP contracture > 30°, (c) any PIP contracture > 15-20° (PIP harder to correct, residual deformity common — earlier intervention), (d) functional impairment + patient desire; (3) **treatment options**: (a) **needle aponeurotomy/fasciotomy (NA — percutaneous)** — minimally invasive, lower morbidity, faster return, higher recurrence (50-65% at 5 years); good for MCP > PIP, cords > nodules, single cord; outpatient procedure; (b) **collagenase Clostridium histolyticum (CCH) injection** — Xiaflex — injection of collagenase into cord + manipulation 24-48h later; equivalent results to NA; not available in all settings; (c) **open limited fasciectomy** — gold standard — better long-term outcomes, lower recurrence (20-30% at 5 yr), more morbidity, longer recovery; (d) **dermofasciectomy + skin graft** — recurrent disease or aggressive Dupuytren diathesis; (e) **PIP arthroplasty/amputation** — end-stage with non-functional finger; (4) **Dupuytren diathesis** (younger onset, bilateral, ectopic — Ledderhose plantar, Peyronie''s, knuckle pads, family history, ethnic — Nordic) → higher recurrence; (5) post-op: splinting, hand therapy, ROM; (6) recurrence universal — counsel patients; (7) avoid surgery if not significantly limiting function

---

Dupuytren contracture: palmar fibromatosis. Intervention for positive tabletop test, MCP > 30°, PIP > 15-20°. Options: NA (minimally invasive, higher recurrence), collagenase, open fasciectomy (gold standard, lower recurrence). PIP harder to correct — earlier intervention. Dupuytren diathesis (Nordic, young, bilateral, ectopic) → higher recurrence. Splint + hand therapy post-op.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'ASSH; Hueston', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 65 ปี Nordic descent ค่อย ๆ เกิดก้อนแข็งฝ่ามือ + นิ้วงอเข้าหาฝ่ามือ 2 ปี ตอนนี้ไม่สามารถวางมือราบบนโต๊ะได้

PE: palpable longitudinal cords ฝ่ามือ → 4th + 5th finger MCP + PIP flexion contracture: 4th MCP 30°, 5th MCP 40° + PIP 30°, positive **Hueston tabletop test**, no skin breakdown

Dx: Dupuytren contracture (palmar fibromatosis) — MCP > 30° + PIP contracture'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 28 ปี โดนคมมีดบาดฝ่ามือซ้าย 4 ชั่วโมงก่อน volar surface นิ้วชี้ — wound 1.5 cm มี active bleeding

PE: wound volar PIP joint level (Zone II — "no man''s land" — between A1 pulley + FDS insertion), inability to flex DIP (FDP cut) + inability to flex PIP with adjacent fingers held (FDS cut), normal sensation digital nerves both sides, capillary refill 2 s

Dx: complete flexor tendon laceration (both FDS + FDP) Zone II + intact digital nerves + adequate vascular supply', '[{"label":"A","text":"Suture skin only no tendon repair"},{"label":"B","text":"Flexor Tendon Laceration Zone II (Both FDS + FDP) — Operative Repair"},{"label":"C","text":"Discharge no surgery"},{"label":"D","text":"Cast immobilization 12 weeks no motion protocol"},{"label":"E","text":"Amputation finger"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Flexor Tendon Laceration Zone II (Both FDS + FDP) — Operative Repair: (1) **operative primary repair within 24-72 hours preferred** (acute) or delayed primary 1-2 weeks (subacute) — better outcomes; > 4-6 weeks requires staged reconstruction (silicone Hunter rod → tendon graft); (2) **surgical technique**: bring proximal cut end down (often retracted to palm — must retrieve carefully), repair with core suture (modified Kessler, Strickland, 4-strand or 6-strand cruciate/Tang) + epitendinous running suture, preserve pulleys A2 + A4 (functional — sliding fulcrum); repair FDS + FDP both (preserves intrinsic strength of FDS); (3) **digital nerve repair** if cut concurrently (microsurgical 8-0 or 9-0 nylon epineural); (4) **post-op rehabilitation critical** — early protected motion (Duran passive, Kleinert active extension with passive flexion via rubber band traction, or **modern early active motion protocols**) under expert hand therapy → reduces adhesions + improves tendon glide; (5) **avoid total immobilization** > 3 weeks (causes adhesions); (6) **avoid full active grasp** × 6 weeks (rupture risk); (7) **antibiotic prophylaxis** (single dose cefazolin); (8) **tetanus update**; (9) **fight bite/animal bite** specific (amoxicillin-clavulanate, debridement); (10) **complications**: tendon rupture (5-10%), adhesions requiring tenolysis, stiffness, neuroma; (11) outcomes Strickland classification post-op; (12) Zone II historically poor outcomes — "no man''s land" — modern early motion + suture techniques improved

---

Flexor tendon Zone II laceration: "no man''s land". Primary repair < 24-72h optimal. Core suture (Kessler/Strickland 4-strand or modern 6-strand) + epitendinous + preserve A2/A4 pulleys + repair both FDS + FDP. Early protected motion (modern early active) prevents adhesions. Antibiotic + tetanus. Outcomes improving. Hand therapy critical post-op.', NULL,
  'hard', 'trauma', 'review',
  'orthopedics', 'clinical_decision', 'trauma', 'adult',
  'ASSH; Tang Hand Surgery', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 28 ปี โดนคมมีดบาดฝ่ามือซ้าย 4 ชั่วโมงก่อน volar surface นิ้วชี้ — wound 1.5 cm มี active bleeding

PE: wound volar PIP joint level (Zone II — "no man''s land" — between A1 pulley + FDS insertion), inability to flex DIP (FDP cut) + inability to flex PIP with adjacent fingers held (FDS cut), normal sensation digital nerves both sides, capillary refill 2 s

Dx: complete flexor tendon laceration (both FDS + FDP) Zone II + intact digital nerves + adequate vascular supply'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 24 ปี ประตูปิดทับปลายนิ้วกลางขวา ปวด + บวม + เลือดออกใต้เล็บ + เล็บแยกออก partial 50% lacerated nail + visible subungual hematoma 70%

PE: nail plate avulsed partial, nail bed laceration visible, tuft fracture distal phalanx on X-ray, intact NV, no flexor tendon injury

X-ray: small tuft fracture distal phalanx (open — communicates with nail bed laceration)', '[{"label":"A","text":"Discharge no treatment hematoma"},{"label":"B","text":"Nail Bed Laceration + Subungual Hematoma + Tuft Fracture (Open Distal Phalanx)"},{"label":"C","text":"Long-term antibiotic 2 weeks oral"},{"label":"D","text":"Amputation finger"},{"label":"E","text":"Cast forearm 12 weeks long-arm"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Nail Bed Laceration + Subungual Hematoma + Tuft Fracture (Open Distal Phalanx): (1) **digital block anesthesia**; (2) **remove nail plate** (carefully with Freer elevator) ถ้า nail bed laceration apparent + > 50% subungual hematoma — historically advised, modern evidence challenges nail removal for intact nail with isolated hematoma; (3) **trephination** of small (< 50%) hematoma with intact nail using heated paper clip or electrocautery for analgesia (no advantage to drainage with intact nail per recent evidence); (4) **nail bed laceration repair** using **6-0 absorbable suture (chromic gut, Vicryl Rapide)** under loupe magnification — meticulous approximation; alternative — dermabond (skin glue) for simple lacerations (comparable outcomes — faster, less painful); (5) **replace nail or substitute** (foil, Reston foam, silicone) into nail fold as **eponychial stent** to prevent synechiae + maintain eponychial fold; (6) **tuft fracture management**: open fracture (communicating with nail bed) → antibiotic prophylaxis cefazolin/cephalexin 24 hours; usually stable + nail bed repair sufficient; pinning rarely needed; (7) **tetanus update**; (8) splint distal IP × 2 weeks; (9) follow-up 7-14 days; (10) counseling: nail regrowth 3-6 months, may grow abnormally (ridges, deformity, hooked); (11) avoid prolonged antibiotics + extensive debridement; (12) **Seymour fracture** (pediatric — Salter-Harris I/II of distal phalanx with nail bed injury, mistaken for mallet) — emergent reduction + nail bed repair + pin (high infection risk if missed)

---

Nail bed injury: digital block → remove nail → repair laceration with 6-0 absorbable (or dermabond) → eponychial stent (nail or substitute) → splint. Open tuft fracture (communicating) — short course antibiotics. Modern evidence — intact nail with subungual hematoma trephination alone sufficient. Pediatric Seymour fracture: emergent reduction + nail bed repair + pin. Nail regrowth 3-6 months.', NULL,
  'medium', 'trauma', 'review',
  'orthopedics', 'clinical_decision', 'trauma', 'adult',
  'ASSH', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 24 ปี ประตูปิดทับปลายนิ้วกลางขวา ปวด + บวม + เลือดออกใต้เล็บ + เล็บแยกออก partial 50% lacerated nail + visible subungual hematoma 70%

PE: nail plate avulsed partial, nail bed laceration visible, tuft fracture distal phalanx on X-ray, intact NV, no flexor tendon injury

X-ray: small tuft fracture distal phalanx (open — communicates with nail bed laceration)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 35 ปี s/p ORIF both-bone forearm fracture 24 ชั่วโมงก่อน เริ่มปวดมากขึ้นใน cast + ชาปลายนิ้ว + ปวดมากเมื่อ passive extension นิ้ว

PE: cast tight + opens → forearm tense + extremely tender, severe pain with passive finger extension (stretch of compartment), paresthesia median + ulnar distribution, finger pulses palpable, capillary refill 3 s
Compartment pressure forearm: 50 mmHg, BP 110/70 (DBP 70 — perfusion pressure = 70-50 = 20 mmHg — critical)

Dx: forearm acute compartment syndrome post-ORIF', '[{"label":"A","text":"Discharge with cast looser"},{"label":"B","text":"Acute Forearm Compartment Syndrome — Emergent Fasciotomy"},{"label":"C","text":"Elevate limb high above heart"},{"label":"D","text":"Diuretics IV"},{"label":"E","text":"Above-elbow amputation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Forearm Compartment Syndrome — Emergent Fasciotomy: (1) **immediate cast/dressing removal** + bandage release; (2) limb at heart level (NOT elevated — reduces perfusion); (3) IV fluid + maintain BP; (4) pain control; (5) **emergent forearm fasciotomy** within hours (irreversible after 6-8 hours): (a) **volar fasciotomy** (Henry approach) — curvilinear incision from medial epicondyle across antecubital fossa (S-shape lacertus + bicipital aponeurosis release) extending to wrist → carpal tunnel release; release superficial + deep flexor compartments + mobile wad (brachioradialis, ECRL/ECRB); (b) **dorsal fasciotomy** — straight incision dorsal forearm releasing extensor compartment (often required); (c) consider mobile wad release; (6) **leave wounds open + VAC dressing** — secondary closure or skin grafting 5-7 days later; (7) **treat underlying cause** (fracture stabilization, hematoma evacuation); (8) **monitor rhabdomyolysis** (CK, myoglobinuria) → IV fluid + bicarbonate + mannitol; AKI risk; (9) **tetanus** prophylaxis; (10) **long-term complications**: Volkmann''s ischemic contracture (claw hand from FDP + FPL fibrosis), nerve injury (median > ulnar), CRPS, chronic pain; (11) **Volkmann''s contracture treatment** chronic: tendon lengthening, infarct excision, free functional muscle transfer (gracilis); (12) multidisciplinary: ortho + hand + plastic + ICU

---

Forearm compartment syndrome: clinical diagnosis. Pain out of proportion + passive stretch pain key. Pressure > 30 mmHg or ΔP < 30 mmHg → emergent fasciotomy. Volar + dorsal release + mobile wad + carpal tunnel. Open wounds + VAC + delayed closure. Volkmann''s contracture sequel if missed (claw hand). Rhabdo + AKI screen. Multidisciplinary.', NULL,
  'medium', 'trauma', 'review',
  'orthopedics', 'clinical_decision', 'trauma', 'adult',
  'ASSH; AAOS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 35 ปี s/p ORIF both-bone forearm fracture 24 ชั่วโมงก่อน เริ่มปวดมากขึ้นใน cast + ชาปลายนิ้ว + ปวดมากเมื่อ passive extension นิ้ว

PE: cast tight + opens → forearm tense + extremely tender, severe pain with passive finger extension (stretch of compartment), paresthesia median + ulnar distribution, finger pulses palpable, capillary refill 3 s
Compartment pressure forearm: 50 mmHg, BP 110/70 (DBP 70 — perfusion pressure = 70-50 = 20 mmHg — critical)

Dx: forearm acute compartment syndrome post-ORIF'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 30 ปี โรงงาน เครื่องตัดนิ้วโป้งซ้ายขาดที่ระดับ proximal phalanx (clean cut) นำส่งรพ. ภายใน 2 ชั่วโมง พร้อม amputated thumb เก็บถูกต้อง (gauze ชุ่มน้ำเกลือ + ถุงพลาสติก + แช่น้ำแข็ง — ไม่แตะน้ำแข็งโดยตรง)

PE: clean amputation thumb proximal phalanx level, bleeding controlled with pressure + tourniquet, no other injuries, distal hand viable, healthy patient no comorbidity, non-smoker

Ischemia time: warm 2h, then cold preservation 2h', '[{"label":"A","text":"Discharge with revision amputation always"},{"label":"B","text":"Acute Traumatic Thumb Amputation — Replantation Strongly Indicated"},{"label":"C","text":"Replant after 24 hours warm ischemia"},{"label":"D","text":"Discard amputated part"},{"label":"E","text":"Above-elbow amputation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Traumatic Thumb Amputation — Replantation Strongly Indicated: (1) **thumb replantation indication very strong** เพราะ thumb essential for hand function (40% of hand function) — replant for nearly all thumb amputations even with marginal candidacy; (2) **other strong indications**: multiple digit, pediatric (any level), forearm/wrist/palm-level amputation, sharp/clean amputation, motivated patient; (3) **relative contraindications**: single finger distal to FDS insertion (poor functional gain — except thumb), severe crush/avulsion, prolonged warm ischemia (> 6h digit, > 12h hand), severe systemic illness, mental health prohibiting compliance, smokers (relative — counsel cessation), self-inflicted; (4) **transport**: amputated part — wrap in saline-moistened gauze → seal in plastic bag → place on ice (NOT direct ice — cold injury); cold ischemia tolerance: digit 12-24 hours, hand/forearm 6-12 hours; (5) **operative**: bone shortening + fixation (K-wire, screw), tendon repair (flexor + extensor), arterial anastomosis (1-2 arteries — vein graft if needed), 2 dorsal vein anastomoses, nerve repair, skin closure (loose, may need graft); microsurgical anastomosis with operating microscope; (6) post-op: anticoagulation (aspirin, heparin, dextran), warming, no caffeine/nicotine, leech therapy for venous congestion, monitoring (color, capillary refill, temperature, doppler); (7) survival rates: thumb 70-90%, multiple digit 65-85%, single non-thumb 50-80%; (8) revision amputation alternative if not replantable (preserve length, optimal stump, prosthesis); (9) hand therapy 3-12 months

---

Thumb amputation: strong indication for replantation (40% of hand function). Transport amputated part: saline gauze → plastic bag → on ice (not direct). Cold ischemia 12-24h digit, 6-12h hand. Replantation: bone fixation → tendon → 1-2 artery → 2 veins → nerve. Post-op anticoagulation + leech + monitoring. Survival 70-90% thumb. Hand therapy 3-12 months.', NULL,
  'medium', 'trauma', 'review',
  'orthopedics', 'clinical_decision', 'trauma', 'adult',
  'ASSH; Replantation', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 30 ปี โรงงาน เครื่องตัดนิ้วโป้งซ้ายขาดที่ระดับ proximal phalanx (clean cut) นำส่งรพ. ภายใน 2 ชั่วโมง พร้อม amputated thumb เก็บถูกต้อง (gauze ชุ่มน้ำเกลือ + ถุงพลาสติก + แช่น้ำแข็ง — ไม่แตะน้ำแข็งโดยตรง)

PE: clean amputation thumb proximal phalanx level, bleeding controlled with pressure + tourniquet, no other injuries, distal hand viable, healthy patient no comorbidity, non-smoker

Ischemia time: warm 2h, then cold preservation 2h'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 28 ปี ก้อนที่หลังข้อมือขวา 6 เดือน ค่อย ๆ โตขึ้น ไม่ค่อยปวด แต่กังวล cosmesis + ปวดเล็กน้อยเมื่อทำงาน

PE: 2 cm soft mobile mass over dorsal wrist (scapholunate region), well-defined, transilluminate + (light passes through), not pulsatile, no neurologic deficit, no overlying skin changes

US: anechoic cystic structure 2 cm with no internal vascular flow communicating with dorsal scapholunate joint — dorsal ganglion cyst', '[{"label":"A","text":"Immediate excision all ganglion cysts"},{"label":"B","text":"Dorsal Wrist Ganglion Cyst — Mostly Conservative"},{"label":"C","text":"Strike with book (Bible therapy)"},{"label":"D","text":"Long-term oral steroid"},{"label":"E","text":"Amputation finger"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Dorsal Wrist Ganglion Cyst — Mostly Conservative: (1) **reassurance + observation** — most common: ganglion cysts may resolve spontaneously (50% in adults, even higher in children); benign, no malignant potential, may fluctuate in size; counsel; (2) **aspiration with large-bore needle + steroid injection** — moderate success (cure 30-50%, recurrence common 50-70%); useful for symptomatic relief temporarily, diagnostic; cellular components reveal clear gelatinous fluid (mucopolysaccharide); (3) **avoid "home remedies"** — striking with book (Bible therapy) — outdated, can cause iatrogenic injury; (4) **surgical excision** indicated for: (a) persistent symptomatic ganglion (pain, weakness, limitation of activities), (b) cosmetic concern after counseling, (c) failed aspiration with recurrence + symptoms, (d) atypical features suggesting other diagnosis; (5) **surgical technique**: complete excision including capsular attachment (often scapholunate ligament — dorsal — or palmar carpal ligaments); arthroscopic excision modern alternative (smaller scar, similar recurrence ~10-20%); open ~5-15% recurrence; (6) **occult dorsal ganglion** — small intraosseous or intra-articular — may cause wrist pain without palpable mass; MRI diagnosis; (7) ulnar-side wrist pain workup if atypical — TFCC, ECU; (8) **mucous cyst** (DIP joint, associated with Heberden node OA) — surgical excision + osteophyte removal; (9) counsel — recurrence even after surgery 5-20%

---

Ganglion cyst: most common hand mass. Benign. 50% spontaneous resolution in adults. Observation primary management. Aspiration + steroid for symptomatic (high recurrence). Avoid Bible therapy. Surgery for persistent symptomatic or cosmesis — excise capsular attachment. Recurrence 5-20% surgery. Mucous cyst (DIP OA) different. Atypical → other workup.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'ASSH', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'หญิงไทยอายุ 28 ปี ก้อนที่หลังข้อมือขวา 6 เดือน ค่อย ๆ โตขึ้น ไม่ค่อยปวด แต่กังวล cosmesis + ปวดเล็กน้อยเมื่อทำงาน

PE: 2 cm soft mobile mass over dorsal wrist (scapholunate region), well-defined, transilluminate + (light passes through), not pulsatile, no neurologic deficit, no overlying skin changes

US: anechoic cystic structure 2 cm with no internal vascular flow communicating with dorsal scapholunate joint — dorsal ganglion cyst'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 50 ปี ปวด + ชาด้านในข้อศอกขวา + นิ้วก้อย + ครึ่ง 4th finger ulnar side 6 เดือน อาการแย่ลง เริ่มมีความอ่อนแรง grip + hand intrinsics

PE: positive Tinel at cubital tunnel, positive elbow flexion test, decreased sensation small finger + ulnar 4th finger, weakness FDI + DI + adductor pollicis (positive Froment sign), beginning hypothenar atrophy, no claw hand yet

NCS: ulnar nerve conduction velocity slowed at elbow < 50 m/s (normal > 60), motor latency prolonged, evidence axonal loss', '[{"label":"A","text":"Long-term steroid injection cubital tunnel"},{"label":"B","text":"Cubital Tunnel Syndrome (Ulnar Neuropathy at Elbow) Moderate-Severe with Weakness + Atrophy"},{"label":"C","text":"Immediate transposition all patients"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Cast immobilization extension 12 weeks"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cubital Tunnel Syndrome (Ulnar Neuropathy at Elbow) Moderate-Severe with Weakness + Atrophy: (1) **conservative trial 3-6 months** for mild without significant motor deficit: (a) activity modification (avoid prolonged elbow flexion + leaning on elbow), (b) **night splinting** in extension (block elbow flexion > 45°), (c) padding ulnar nerve, (d) NSAIDs; (2) **avoid corticosteroid injection at cubital tunnel** — high risk nerve injury, limited efficacy; (3) **surgical decompression** indicated: (a) failure of 3-6 months conservative + persistent symptoms, (b) **motor weakness, atrophy, severe NCS findings** — earlier surgery (irreversible damage if delayed > 6-12 months with axonal loss), (c) severe pain affecting QoL; (4) **surgical options**: (a) **in situ decompression (simple decompression)** — open or endoscopic — modern preferred for most cases (similar outcomes vs transposition with less morbidity per multiple RCTs and meta-analyses), (b) **anterior transposition** (subcutaneous, intramuscular, submuscular) — historic gold standard, reserved for: subluxating ulnar nerve, prior surgery with kinking, Cubitus valgus deformity, post-traumatic deformity, (c) **medial epicondylectomy** — alternative, less common; (5) post-op: early ROM, return to activity progressively; (6) **outcomes** — better with mild-moderate; advanced with atrophy may not recover fully despite surgery — counsel realistic expectations; (7) screen DM + thyroid + nerve disorders (CMT)

---

Cubital tunnel: 2nd most common compression neuropathy. Conservative (splinting, activity mod) for mild. Surgery for failed conservative + severe (weakness, atrophy). Avoid steroid injection (nerve risk). In situ decompression preferred over transposition (similar outcomes, less morbidity). Transposition for subluxating nerve, deformity. Severe + atrophy → may not fully recover.', NULL,
  'medium', 'neurology', 'review',
  'orthopedics', 'clinical_decision', 'neurology', 'adult',
  'AAOS Ulnar Neuropathy Elbow', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 50 ปี ปวด + ชาด้านในข้อศอกขวา + นิ้วก้อย + ครึ่ง 4th finger ulnar side 6 เดือน อาการแย่ลง เริ่มมีความอ่อนแรง grip + hand intrinsics

PE: positive Tinel at cubital tunnel, positive elbow flexion test, decreased sensation small finger + ulnar 4th finger, weakness FDI + DI + adductor pollicis (positive Froment sign), beginning hypothenar atrophy, no claw hand yet

NCS: ulnar nerve conduction velocity slowed at elbow < 50 m/s (normal > 60), motor latency prolonged, evidence axonal loss'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงแรกเกิด 2 สัปดาห์ คลอด breech, มี family history DDH (mother) ตรวจในคลินิกเด็ก

PE: positive Ortolani test (relocation "clunk" of dislocated hip into acetabulum on abduction) + positive Barlow test (provokes posterior dislocation with adduction + posterior pressure) ของ left hip, asymmetric thigh skin folds, no leg length discrepancy obvious yet

US hip (preferred imaging < 4-6 months, before ossification): left hip with alpha angle 50° (normal > 60°), beta angle 65° (normal < 55°), femoral head coverage < 50% — DDH (Graf type IIIa)', '[{"label":"A","text":"Observation no treatment"},{"label":"B","text":"Newborn DDH Graf Type IIIa with Positive Ortolani"},{"label":"C","text":"Triple-diaper technique only"},{"label":"D","text":"Spica cast in extension"},{"label":"E","text":"Total hip arthroplasty in newborn"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Newborn DDH Graf Type IIIa with Positive Ortolani: (1) **immediate Pavlik harness** (dynamic abduction-flexion orthosis) — gold standard for newborns + infants < 6 months with dislocated/dislocatable hip: (a) maintains hip in flexion 100-110° + abduction 50-70° (allows physiologic motion within "safe zone" of Ramsey to encourage acetabular development), (b) prevents extension/adduction; (2) **wear 23-24 hours/day** initially → gradual weaning when reduced + acetabulum developing; (3) **monitor with US** every 1-2 weeks; (4) **success rate Pavlik 85-95% for Graf II-III, lower for type IV (irreducible — 50-60%)**; (5) **avoid Pavlik in older infants** (> 6 months — femoral nerve palsy, AVN with rigid fixation), severe dislocations with high femoral head (IV), neuromuscular conditions; (6) **complications of Pavlik**: AVN of femoral head (1-5%), femoral nerve palsy (if too much flexion > 110°), Pavlik disease (residual acetabular dysplasia if used too long > 3-4 weeks without progress); (7) **risk factors** for DDH (mnemonic — "6 F''s"): Female, First-born, Family history, Frank breech, fluid (oligohydramnios), Foot (calcaneovalgus, metatarsus adductus); (8) **screening**: US for risk factors at 6 weeks; AAP — clinical exam at every visit; (9) **if Pavlik fails** (> 3-4 weeks no reduction): closed reduction + spica cast under GA, or open reduction; (10) older infants 6-18 months: closed reduction + spica; > 18 months: open reduction + femoral/pelvic osteotomy; (11) educate parents

---

Newborn DDH: Pavlik harness gold standard < 6 months. 23-24h/day initially. US monitoring. Success 85-95% for Graf II-III. Risk factors (6 F''s): Female, First-born, Family, Frank breech, Fluid, Foot. Complications: AVN, femoral nerve palsy. Beyond 6 months: closed/open reduction + spica/osteotomy. Don''t continue Pavlik > 3-4 weeks if no progress (Pavlik disease).', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'peds',
  'AAOS DDH; AAP Screening', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'เด็กหญิงแรกเกิด 2 สัปดาห์ คลอด breech, มี family history DDH (mother) ตรวจในคลินิกเด็ก

PE: positive Ortolani test (relocation "clunk" of dislocated hip into acetabulum on abduction) + positive Barlow test (provokes posterior dislocation with adduction + posterior pressure) ของ left hip, asymmetric thigh skin folds, no leg length discrepancy obvious yet

US hip (preferred imaging < 4-6 months, before ossification): left hip with alpha angle 50° (normal > 60°), beta angle 65° (normal < 55°), femoral head coverage < 50% — DDH (Graf type IIIa)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 7 ปี ปวด groin + thigh ขวา + เดินกระเผลก 6 สัปดาห์, no trauma, ไม่มี fever

PE: limited internal rotation + abduction right hip, Trendelenburg gait, no swelling/effusion, leg length difference < 1 cm

Lab: WBC + ESR + CRP normal (rules out septic arthritis)
X-ray hip: small dense fragmented right femoral epiphysis with crescent sign + lateral pillar lateral height < 50% — Catterall III, Herring (lateral pillar) B → Legg-Calvé-Perthes disease', '[{"label":"A","text":"Total hip arthroplasty in child"},{"label":"B","text":"Legg-Calvé-Perthes Disease Lateral Pillar B in 7-year-old"},{"label":"C","text":"Bedrest indefinitely"},{"label":"D","text":"Long-term oral steroid"},{"label":"E","text":"Discharge no treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Legg-Calvé-Perthes Disease Lateral Pillar B in 7-year-old: (1) **idiopathic AVN of femoral head** in children 4-10 years — self-limited but residual deformity affects long-term outcome; (2) **principles** — "containment" — keep femoral head contained within acetabulum during fragmentation/reossification → preserves spherical shape + congruency; (3) **treatment based on age + Herring lateral pillar classification + sphericity**: (a) **observation + symptomatic** — age < 6 ปี OR Herring A (lateral pillar height > 50%): expected good outcome with non-op; PT, NSAIDs, activity modification, avoid impact; (b) **containment treatment** — age 6-8 ปี + Herring B/B-C border + femoral head at risk: options bracing (Atlanta, Toronto, Scottish-Rite) — limited evidence; **femoral varus osteotomy** OR **innominate (Salter) osteotomy** — restores containment + sphericity; (c) **older children > 8 ปี + Herring B/C** — surgical containment (femoral or pelvic osteotomy) — improved outcomes (Herring multicenter RCT); (d) **Herring C** (lateral pillar < 50%) — poor prognosis regardless of treatment; salvage procedures (valgus extension osteotomy) for residual deformity; (4) ROM maintenance + abduction key — physical therapy; (5) avoid weight-bearing if severe pain; (6) follow long-term — early hip OA risk → eventual THA in 4th-6th decade for severe; (7) Stulberg classification at maturity predicts outcome (I-II good, III-V hip OA); (8) screen secondary causes if bilateral simultaneous (rule out skeletal dysplasia, hypothyroid)

---

Perthes: idiopathic pediatric AVN. Self-limited but residual deformity → adult hip OA. Containment principle. Treatment: age + Herring lateral pillar guide. < 6 yr or Herring A → observation. 6-8 yr + Herring B/border → containment (osteotomy or brace). > 8 yr + B/C → surgical containment (better outcomes Herring trial). Stulberg outcome at maturity. Eventual THA possible.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'peds',
  'Herring Perthes Multicenter Study', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'เด็กชายอายุ 7 ปี ปวด groin + thigh ขวา + เดินกระเผลก 6 สัปดาห์, no trauma, ไม่มี fever

PE: limited internal rotation + abduction right hip, Trendelenburg gait, no swelling/effusion, leg length difference < 1 cm

Lab: WBC + ESR + CRP normal (rules out septic arthritis)
X-ray hip: small dense fragmented right femoral epiphysis with crescent sign + lateral pillar lateral height < 50% — Catterall III, Herring (lateral pillar) B → Legg-Calvé-Perthes disease'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 5 ปี ปวด hip ซ้าย + ไม่ยอม weight bear 2 วัน + ไข้ 38.5°C; เคยมี URI 2 สัปดาห์ก่อน

V/S: BP 100/60, HR 130, Temp 38.7°C
PE: hip held flexed-abducted-externally rotated, severe pain ROM especially internal rotation, refuses to bear weight

Lab: WBC 14,500 (PMN 80%), CRP 65, ESR 50, blood culture pending
US hip: joint effusion left hip 6 mm
Kocher criteria: fever > 38.5 (+), non-weight bearing (+), ESR > 40 (+), WBC > 12,000 (+) = 4/4 criteria → 99% probability septic arthritis

Hip aspiration: WBC 110,000 (PMN 92%) — septic arthritis', '[{"label":"A","text":"Oral antibiotics outpatient"},{"label":"B","text":"Pediatric Septic Arthritis of Hip (Kocher 4/4 + Aspiration Confirmatory)"},{"label":"C","text":"Discharge with NSAIDs"},{"label":"D","text":"No aspiration just CT scan"},{"label":"E","text":"Bedrest only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Septic Arthritis of Hip (Kocher 4/4 + Aspiration Confirmatory): (1) **Kocher criteria** for septic vs transient synovitis: fever > 38.5°C, non-weight bearing, ESR > 40, WBC > 12,000; 0 = 0.2%, 1 = 3%, 2 = 40%, 3 = 93%, 4 = 99% probability septic arthritis; modified add CRP > 2 mg/dL; (2) **emergent hip aspiration** under fluoroscopy/US — diagnostic + therapeutic decompression; cell count > 50,000 PMN > 75% suggestive; (3) **emergent arthrotomy + irrigation + debridement** of hip joint within 24 hours — surgical emergency (vs arthroscopy which is acceptable in select centers); (4) **empirical IV antibiotic** after aspiration cultures: (a) **age 3 months - 5 years**: cefazolin or clindamycin (S. aureus most common; consider MRSA empirically if local prevalence); add ceftriaxone if Kingella suspected ("hip pain less ill child"); (b) age < 3 months: vancomycin + cefotaxime (cover GBS, gram-negative, S. aureus); (c) **adolescent + sexually active**: add ceftriaxone (N. gonorrhoeae); (d) sickle cell: cover Salmonella; (5) **IV antibiotic 2-4 weeks then transition oral** with normalized CRP + clinical improvement; total 4-6 weeks; (6) **screen concurrent osteomyelitis** (femoral proximal — common adjacent in hip septic arthritis) — MRI if persistent symptoms; (7) repeat I&D if persistent fever, WBC, CRP; (8) physical therapy; (9) long-term: AVN, growth disturbance, joint damage — counsel; (10) **Kingella kingae** increasingly recognized (PCR diagnostic) in 6-36 months — "less ill" presentation

---

Pediatric septic arthritis hip: emergency. Kocher criteria differentiate from transient synovitis (4/4 = 99% septic). Aspiration + arthrotomy + IV antibiotic. S. aureus most common; consider MRSA, Kingella (PCR, 6-36 mo), Salmonella (SCD), gonococcus (adolescent). 4-6 wk antibiotic. Screen concurrent osteomyelitis (MRI). Long-term AVN/growth risk.', NULL,
  'medium', 'id', 'review',
  'orthopedics', 'clinical_decision', 'id', 'peds',
  'Kocher Criteria; AAOS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'เด็กชายอายุ 5 ปี ปวด hip ซ้าย + ไม่ยอม weight bear 2 วัน + ไข้ 38.5°C; เคยมี URI 2 สัปดาห์ก่อน

V/S: BP 100/60, HR 130, Temp 38.7°C
PE: hip held flexed-abducted-externally rotated, severe pain ROM especially internal rotation, refuses to bear weight

Lab: WBC 14,500 (PMN 80%), CRP 65, ESR 50, blood culture pending
US hip: joint effusion left hip 6 mm
Kocher criteria: fever > 38.5 (+), non-weight bearing (+), ESR > 40 (+), WBC > 12,000 (+) = 4/4 criteria → 99% probability septic arthritis

Hip aspiration: WBC 110,000 (PMN 92%) — septic arthritis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 8 ปี ตกจักรยานเอามือยันพื้น ปวดข้อมือซ้าย 1 วัน, mild swelling

PE: tenderness distal radius, mild swelling, no obvious deformity, NV intact, no open wound

X-ray wrist: cortical buckle/wrinkle distal radius metaphysis dorsal cortex (no displacement, no angulation) — buckle (torus) fracture pediatric', '[{"label":"A","text":"Long-arm cast 12 weeks"},{"label":"B","text":"Pediatric Buckle (Torus) Fracture of Distal Radius — Low-Risk Stable Fracture"},{"label":"C","text":"Surgery same day"},{"label":"D","text":"Discharge no immobilization"},{"label":"E","text":"Steroid injection"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Buckle (Torus) Fracture of Distal Radius — Low-Risk Stable Fracture: (1) **simple removable splint** for 3-4 weeks — modern evidence (FORCE trial Lancet 2022, multiple meta-analyses) — buckle fractures are inherently stable + heal reliably: **removable splint or soft cast non-inferior to rigid casting**; reduces clinic visits + improves QoL + parent satisfaction; (2) **no reduction needed** (no displacement); (3) **WB allowed**; (4) educate parents — wear splint for activities, can remove for bathing/sleeping after first week; symptoms resolve over weeks; (5) **no routine follow-up X-ray** required (low risk displacement); discharge to PCP follow-up; (6) avoid prolonged casting (deconditioning, costs); (7) NSAIDs for pain (controversial bone healing — limited concern in buckle); (8) **green-stick fracture** (incomplete fracture with cortical disruption of one side + bend of other side) — more unstable than buckle, may need closed reduction + cast 4-6 weeks; (9) **complete fracture** with displacement — reduction + cast 4-6 weeks; (10) **Salter-Harris classification** if physis involved (SH I-V): SH I-II typically closed reduction + cast 4-6 weeks; SH III-IV intra-articular often need anatomic reduction (closed or open) + fixation; SH V poor prognosis growth arrest; (11) growth arrest screening f/u

---

Pediatric buckle (torus) fracture distal radius: inherently stable. Modern evidence: removable splint or soft cast equivalent to rigid cast (FORCE trial). 3-4 weeks. No reduction. WB allowed. No routine follow-up X-ray. Parent education. Differentiate from greenstick (incomplete with displacement — more unstable, needs cast). Salter-Harris classification for physeal injury.', NULL,
  'easy', 'trauma', 'review',
  'orthopedics', 'clinical_decision', 'trauma', 'peds',
  'AAOS; FORCE Trial Lancet 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'เด็กหญิงอายุ 8 ปี ตกจักรยานเอามือยันพื้น ปวดข้อมือซ้าย 1 วัน, mild swelling

PE: tenderness distal radius, mild swelling, no obvious deformity, NV intact, no open wound

X-ray wrist: cortical buckle/wrinkle distal radius metaphysis dorsal cortex (no displacement, no angulation) — buckle (torus) fracture pediatric'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 14 ปี นักฟุตบอล ปวดเข่าซ้าย + บวมเป็น ๆ หาย ๆ 4 เดือน บางครั้งรู้สึก locking + catching, ไม่มี trauma ชัดเจน

PE: mild effusion, positive Wilson test (pain on internal rotation tibia with knee flexion 90° → 30°, relief with external rotation — classic for medial femoral condyle OCD), no significant ligamentous laxity

MRI knee: osteochondral lesion lateral aspect of medial femoral condyle (classic location), subchondral edema, intact overlying cartilage, no displaced fragment, no fluid behind fragment (stable lesion) — juvenile OCD stage I', '[{"label":"A","text":"Total knee arthroplasty in child"},{"label":"B","text":"Juvenile Osteochondritis Dissecans (OCD) of Medial Femoral Condyle — Skeletally Immature with Stable Lesion"},{"label":"C","text":"Continue contact sports immediately"},{"label":"D","text":"Long-term opioid"},{"label":"E","text":"Cast in extension 12 weeks then return to sport"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Juvenile Osteochondritis Dissecans (OCD) of Medial Femoral Condyle — Skeletally Immature with Stable Lesion: (1) **non-operative trial 3-6 months** preferred for juvenile OCD with **open physes + stable lesion** (no fluid behind, intact cartilage): (a) activity modification — restrict impact, running, jumping, contact sports for 3-6 months, (b) non-weight bearing with crutches initially, advance to WB in unloader brace selective, (c) PT — maintain ROM, avoid impact, (d) repeat MRI 3-6 months — healing common in skeletally immature (60-90% heal non-op); (2) **prognosis better in skeletally immature** (open physes) vs adolescent/adult — "adult OCD" (closed physes) has poor non-op outcomes; (3) **surgical treatment** indicated: (a) failure of 3-6 months conservative, (b) unstable lesion (fluid behind fragment on MRI, separation), (c) loose body causing locking, (d) skeletally mature with adult OCD, (e) displaced fragment; (4) **surgical options**: (a) **retrograde drilling** (transarticular or extra-articular) — stable in situ lesion + intact cartilage + skeletally immature; promotes healing; (b) **fixation** (bioabsorbable screws/anchors, Herbert screws) — unstable but salvageable hinged fragment; (c) **removal + cartilage restoration** (microfracture, OATS — osteochondral autograft transfer, ACI/MACI) — irreparable fragment or chronic; (5) post-op: protected WB 6-8 weeks, gradual return to sport 4-6 months; (6) prevention of long-term sequelae (early OA); (7) workup bilateral (15-30%) + screen for OCD elsewhere (capitellum — gymnasts, talus — basketball)

---

Juvenile OCD knee: medial femoral condyle classic (lateral aspect). Wilson test sensitive. Skeletally immature + stable lesion → non-op 3-6 months (60-90% heal). Surgery for unstable, failed conservative, adult OCD. Retrograde drilling, fixation, cartilage restoration. Better prognosis in open physes vs adult. Bilateral 15-30% — screen. Late OA risk.', NULL,
  'hard', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'peds',
  'ROCK Study Group; AAOS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 14 ปี นักฟุตบอล ปวดเข่าซ้าย + บวมเป็น ๆ หาย ๆ 4 เดือน บางครั้งรู้สึก locking + catching, ไม่มี trauma ชัดเจน

PE: mild effusion, positive Wilson test (pain on internal rotation tibia with knee flexion 90° → 30°, relief with external rotation — classic for medial femoral condyle OCD), no significant ligamentous laxity

MRI knee: osteochondral lesion lateral aspect of medial femoral condyle (classic location), subchondral edema, intact overlying cartilage, no displaced fragment, no fluid behind fragment (stable lesion) — juvenile OCD stage I'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 13 ปี Tanner stage III นักฟุตบอล ปวด anterior knee + tender tibial tubercle 3 เดือน ปวดมากขึ้นเวลาวิ่ง + กระโดด + climb stairs ดีขึ้นเมื่อพัก

PE: prominent tender tibial tubercle bilateral, pain on resisted knee extension, no effusion, full ROM, hamstring tightness

X-ray knee lateral: irregularity + fragmentation tibial tubercle apophysis (Osgood-Schlatter changes), no avulsion fragment displacement', '[{"label":"A","text":"Long-term oral steroid"},{"label":"B","text":"Osgood-Schlatter Disease (Apophysitis of Tibial Tubercle) in Adolescent Athlete"},{"label":"C","text":"Cast extension 12 weeks total immobilization"},{"label":"D","text":"Surgical excision tubercle all patients"},{"label":"E","text":"Discharge sports prohibition until 18 years"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Osgood-Schlatter Disease (Apophysitis of Tibial Tubercle) in Adolescent Athlete: (1) **conservative management always — self-limited** condition resolves with skeletal maturity (closure of tibial tubercle apophysis): (a) activity modification (reduce impact activity, modify training during symptomatic period — total rest NOT required), (b) **PT** — hamstring + quadriceps stretching + eccentric strengthening, hip flexor flexibility, biomechanics, (c) ice after activity, (d) NSAIDs short course for pain, (e) infrapatellar strap/sleeve (counterforce — limited evidence), (f) reassurance + education on natural history; (2) **avoid immobilization** (atrophy + deconditioning) except in severe acute exacerbation; (3) **avoid corticosteroid injection** (risk of patellar tendon damage, fat pad atrophy); (4) **uncommon need for surgery** — reserved for: (a) symptomatic ossicle that persists beyond skeletal maturity (10-15%) — excision of ossicle, (b) tibial tubercle avulsion fracture (Ogden classification — separate entity, surgical reduction + fixation); (5) educate patient + family — symptoms intermittent for 12-24 months typically, resolve with maturity; participation in sport modified but allowed; (6) **return to sport** when pain tolerable; (7) **related apophysitis**: Sinding-Larsen-Johansson (inferior pole of patella — apophysitis), Sever''s disease (calcaneal apophysitis), Iselin disease (5th metatarsal base), Little league elbow (medial epicondyle apophysitis) — all similar principles

---

Osgood-Schlatter: tibial tubercle apophysitis in adolescent athletes. Self-limited — resolves with skeletal maturity. Conservative: activity modification + PT (hamstring/quadriceps) + ice + NSAIDs. AVOID steroid injection. Surgery rare — only for persistent symptomatic ossicle post-maturity or tubercle avulsion fracture. Education on natural history. Similar to other apophyses (Sinding-Larsen, Sever, Iselin).', NULL,
  'easy', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'peds',
  'AAOS Pediatric', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'เด็กชายอายุ 13 ปี Tanner stage III นักฟุตบอล ปวด anterior knee + tender tibial tubercle 3 เดือน ปวดมากขึ้นเวลาวิ่ง + กระโดด + climb stairs ดีขึ้นเมื่อพัก

PE: prominent tender tibial tubercle bilateral, pain on resisted knee extension, no effusion, full ROM, hamstring tightness

X-ray knee lateral: irregularity + fragmentation tibial tubercle apophysis (Osgood-Schlatter changes), no avulsion fragment displacement'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกแรกเกิด อายุ 3 วัน ตรวจพบ bilateral clubfoot (talipes equinovarus — CTEV): foot in equinus + cavus + adduction + varus, rigid, idiopathic, no syndromic features, full-term, healthy

Pirani score 5.5 (severe rigid deformity)
No neurological deficit, normal hip exam (rule out concurrent DDH)
No other anomalies', '[{"label":"A","text":"Extensive posteromedial release first"},{"label":"B","text":"Idiopathic Bilateral Clubfoot (CTEV) — Ponseti Method First-Line Treatment"},{"label":"C","text":"No treatment self-resolves"},{"label":"D","text":"Bilateral amputation"},{"label":"E","text":"Cast in equinus first to align"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Idiopathic Bilateral Clubfoot (CTEV) — Ponseti Method First-Line Treatment: (1) **Ponseti method gold standard worldwide** — non-operative serial manipulation + casting + percutaneous tenotomy + bracing — > 95% success: (a) **weekly serial long-leg casting** (above-knee, knee 90° flexion) correcting deformities in order — cavus first → adduction → varus → equinus last (using CAVE mnemonic — Cavus, Adductus, Varus, Equinus); each cast incrementally improves position over 4-8 weeks (5-7 casts typical), (b) **percutaneous Achilles tenotomy** at end of casting (in ~80% of cases to correct residual equinus) — done in clinic or minor procedure, (c) post-tenotomy cast 3 weeks in maximum dorsiflexion + abduction; (2) **Denis Browne / Mitchell foot abduction brace** — **23 hours/day × 3 months** → **night + nap brace until age 4-5** — critical for preventing relapse (most common cause of treatment failure = brace non-compliance, family education essential); (3) **relapse rate 20-40%** — manage with re-casting + repeat tenotomy + bracing; **tibialis anterior tendon transfer (TATT)** for dynamic supination (recurrent dynamic deformity in ambulating child > 2 ปี); (4) **avoid extensive soft tissue release** (historic — PMR posteromedial release) — worse long-term outcomes (stiffness, pain, OA); only for severe atypical/syndromic cases that fail Ponseti; (5) **screen DDH + spinal dysraphism** (associated); (6) syndromic clubfoot (arthrogryposis, myelomeningocele) — modified Ponseti, more difficult, higher relapse

---

Clubfoot (CTEV): Ponseti method gold standard, > 95% success. Weekly serial casting (correct CAVE order) + percutaneous Achilles tenotomy (80%) + Denis Browne abduction brace (23h × 3 mo then nights until 4-5 yr). Relapse 20-40% — recasting, repeat tenotomy, TATT (dynamic deformity > 2 yr). AVOID extensive soft tissue release. Screen DDH + spinal dysraphism. Syndromic harder.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'peds',
  'Ponseti Method', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ทารกแรกเกิด อายุ 3 วัน ตรวจพบ bilateral clubfoot (talipes equinovarus — CTEV): foot in equinus + cavus + adduction + varus, rigid, idiopathic, no syndromic features, full-term, healthy

Pirani score 5.5 (severe rigid deformity)
No neurological deficit, normal hip exam (rule out concurrent DDH)
No other anomalies'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 11 ปี นักฟุตบอล ปวดส้นเท้าทั้ง 2 ข้าง 6 สัปดาห์ ปวดมากเวลาวิ่ง + กระโดด ดีขึ้นเมื่อพัก ไม่มีปวดตอนกลางคืน

PE: tender medial + lateral aspect calcaneal apophysis bilateral, positive Sever sign (pain on medio-lateral compression of calcaneus), tight Achilles, normal ROM, no swelling, no erythema

X-ray heel: irregular fragmentation calcaneal apophysis (normal variant — NOT diagnostic; clinical diagnosis)', '[{"label":"A","text":"Long-term oral steroid"},{"label":"B","text":"Sever''s Disease (Calcaneal Apophysitis) in Adolescent Athlete — Self-Limited"},{"label":"C","text":"Cast immobilization 12 weeks long-leg"},{"label":"D","text":"Surgical excision apophysis"},{"label":"E","text":"Sports prohibition until 18 years"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Sever''s Disease (Calcaneal Apophysitis) in Adolescent Athlete — Self-Limited: (1) **conservative management** — Sever''s resolves with closure of calcaneal apophysis (typically age 14-16): (a) activity modification (reduce running/jumping during symptomatic phase; total rest unnecessary), (b) **Achilles + calf stretching** + hamstring flexibility, (c) **heel cushion** (gel cup) or heel lift bilateral — reduces strain on apophysis, (d) appropriate supportive footwear, (e) ice after activity, (f) NSAIDs short course; (2) **PT** — eccentric strengthening when acute pain settled, biomechanics, gait; (3) **reassurance + education** — benign self-limited condition, no long-term sequelae; (4) **screen overtraining + training error** (rapid increase in volume/intensity); (5) **avoid immobilization** (cast) except severe — causes deconditioning; (6) **avoid corticosteroid injection** (apophyseal injection risk); (7) **differential**: stress fracture calcaneus (older + persistent pain — MRI), plantar fasciitis (less common in children), Achilles tendinopathy, infection (rare); (8) related apophyseal injuries: Osgood-Schlatter, Sinding-Larsen-Johansson, Iselin, Little league elbow — similar principles; (9) **return to sport** when pain tolerable

---

Sever''s disease: calcaneal apophysitis in adolescent athletes. Self-limited — resolves with apophyseal closure (age 14-16). Conservative: activity modification + Achilles stretching + heel cushion + supportive shoes + NSAIDs. AVOID steroid injection + prolonged immobilization. Reassurance — no long-term sequelae. Rule out stress fracture if persistent. Similar to other apophysitis.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'peds',
  'AAOS Pediatric', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'เด็กชายอายุ 11 ปี นักฟุตบอล ปวดส้นเท้าทั้ง 2 ข้าง 6 สัปดาห์ ปวดมากเวลาวิ่ง + กระโดด ดีขึ้นเมื่อพัก ไม่มีปวดตอนกลางคืน

PE: tender medial + lateral aspect calcaneal apophysis bilateral, positive Sever sign (pain on medio-lateral compression of calcaneus), tight Achilles, normal ROM, no swelling, no erythema

X-ray heel: irregular fragmentation calcaneal apophysis (normal variant — NOT diagnostic; clinical diagnosis)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 18 เดือน เริ่มไม่ยอมเดิน + กระเผลก 2 วัน parents ไม่เห็น clear trauma history ไม่มี fever, ไม่มี erythema

PE: refuses to bear weight on right leg, mild tenderness mid-tibial shaft + holds leg slightly externally rotated, no overt swelling/deformity, normal hip exam + knee exam, no skin signs

X-ray tibia: subtle oblique non-displaced fracture distal third tibia (spiral) — toddler fracture (childhood accidental fracture from minor twisting)
No metaphyseal corner fractures or other suspicious signs', '[{"label":"A","text":"Discharge no follow-up"},{"label":"B","text":"Toddler Fracture (CAST — Childhood Accidental Spiral Tibial Fracture) — Benign Isolated Injury"},{"label":"C","text":"Surgery same day"},{"label":"D","text":"Above-knee amputation"},{"label":"E","text":"Long-term opioid"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Toddler Fracture (CAST — Childhood Accidental Spiral Tibial Fracture) — Benign Isolated Injury: (1) **brief diagnostic + therapeutic immobilization** — long-leg cast or **above-knee posterior splint** 3-4 weeks (some advocate short-leg cast or even no immobilization in select cases — boot/CAM walker emerging evidence — but long-leg cast remains standard); (2) **non-weight bearing initially**, gradual return as comfortable; (3) **child will heal completely** — toddler fractures uncomplicated; (4) **important — rule out non-accidental trauma (NAT/child abuse)** especially: (a) history doesn''t match injury, (b) delayed presentation, (c) multiple fractures different ages on skeletal survey, (d) metaphyseal corner fractures ("bucket handle" — pathognomonic for NAT), (e) rib fractures (especially posterior), (f) bilateral, (g) child < 12 months (very rare cause of fracture from accidental walking), (h) other suspicious signs (bruising, scalds, withdrawal); (5) **mandatory reporting** if NAT suspicion to child protective services + social work; (6) **skeletal survey** if suspicion (multiple fractures, child < 2 ปี with suspicious fracture); (7) **classic isolated toddler tibial fracture in walking child (12-36 months) with appropriate history** — benign; (8) follow-up X-ray 2-3 weeks to confirm healing; (9) **differential**: occult infection (osteomyelitis), transient synovitis hip (referred pain), septic arthritis, leukemia (atypical limp without fracture)

---

Toddler fracture: spiral tibia in toddler 12-36 mo. Long-leg cast 3-4 weeks. Excellent healing. CRITICAL — rule out NAT especially atypical history, multiple fractures, metaphyseal corner, posterior rib, < 12 mo, bilateral. Mandatory reporting + skeletal survey if suspicious. Classic isolated case with witnessed/typical mechanism — benign. Always think of child abuse in pediatric fractures.', NULL,
  'medium', 'trauma', 'review',
  'orthopedics', 'clinical_decision', 'trauma', 'peds',
  'AAOS Pediatric', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'เด็กชายอายุ 18 เดือน เริ่มไม่ยอมเดิน + กระเผลก 2 วัน parents ไม่เห็น clear trauma history ไม่มี fever, ไม่มี erythema

PE: refuses to bear weight on right leg, mild tenderness mid-tibial shaft + holds leg slightly externally rotated, no overt swelling/deformity, normal hip exam + knee exam, no skin signs

X-ray tibia: subtle oblique non-displaced fracture distal third tibia (spiral) — toddler fracture (childhood accidental fracture from minor twisting)
No metaphyseal corner fractures or other suspicious signs'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกแรกเกิด ตรวจพบ extra digit (postaxial polydactyly) นิ้วก้อยข้างขวา + นิ้วเสริมเชื่อมต่อบาง ๆ ผ่าน skin pedicle เท่านั้น (no bony connection, no functional structures)
Polydactyly type B (pedunculated)

Family history: father had similar finding removed
No other anomalies, no syndromic features', '[{"label":"A","text":"Wait until age 18 to decide"},{"label":"B","text":"Postaxial Polydactyly Type B (Pedunculated) — Newborn"},{"label":"C","text":"Amputation entire hand"},{"label":"D","text":"Long-term steroid"},{"label":"E","text":"Discharge no treatment ever"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Postaxial Polydactyly Type B (Pedunculated) — Newborn: (1) **simple ligation/clip** at base of pedicle in newborn (vascular clip applied to pedicle) — historical method — concern with bleb stump + neuroma; (2) **modern preferred — surgical excision at base in clinic OR** — better cosmetic outcome with elimination of stump/neuroma + sutured closure; can be done in clinic with local anesthesia in newborns (no need for GA); (3) **timing** — early excision (within first weeks or months) reduces psychological + cosmetic issues; (4) **Type A postaxial polydactyly** (with bone + nail + functional digit) — formal surgical removal under GA — typically 12-24 months old, more complex (skin, bone, joint, ligament, tendon, neurovascular reconstruction); (5) **preaxial (radial-sided, thumb)** polydactyly — Wassel classification, more complex reconstructive (preserve dominant thumb or combine — Bilhaut-Cloquet, on-top plasty) at 12-24 months; (6) **screen syndromic** if multiple anomalies, atypical, family history — Bardet-Biedl, trisomy 13, Down syndrome — refer genetics; (7) **isolated postaxial polydactyly** — often familial (AD with variable penetrance), more common in African populations, otherwise unremarkable; (8) parental counseling + reassurance

---

Polydactyly: postaxial type B (pedunculated) → simple excision at base (modern preferred over ligation/clip — better cosmetic). Done in clinic with local. Type A (functional digit) and preaxial (thumb) — formal surgical reconstruction at 12-24 months (Wassel classification, Bilhaut-Cloquet). Screen syndromic if atypical/multiple anomalies. Common AD familial isolated case — reassurance.', NULL,
  'easy', 'procedures', 'review',
  'orthopedics', 'clinical_decision', 'procedures', 'peds',
  'ASSH; Wassel Classification', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ทารกแรกเกิด ตรวจพบ extra digit (postaxial polydactyly) นิ้วก้อยข้างขวา + นิ้วเสริมเชื่อมต่อบาง ๆ ผ่าน skin pedicle เท่านั้น (no bony connection, no functional structures)
Polydactyly type B (pedunculated)

Family history: father had similar finding removed
No other anomalies, no syndromic features'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 14 ปี ปวด distal thigh ขวา 3 เดือน + ปวดมากตอนกลางคืน + บวมเริ่มเห็นชัด 1 เดือน, ไม่มี trauma

PE: tender + warm mass distal thigh anterolateral, palpable firm mass 8 cm, no joint effusion knee, no neurologic deficit, no constitutional symptoms
Lab: ALP elevated 850 (normal < 350), LDH elevated

X-ray femur: aggressive lytic + sclerotic lesion distal femoral metaphysis with sunburst periosteal reaction + Codman triangle + soft tissue mass
MRI femur: intramedullary mass + extension into soft tissue, no skip lesions
CT chest: no pulmonary metastases
Bone scan: increased uptake distal femur, no other lesions

Biopsy (through future incision line for resection): high-grade conventional osteosarcoma', '[{"label":"A","text":"Excisional biopsy in community hospital first"},{"label":"B","text":"Conventional High-Grade Osteosarcoma Distal Femur in Adolescent"},{"label":"C","text":"Amputation always (no limb salvage)"},{"label":"D","text":"Radiation only no chemotherapy"},{"label":"E","text":"Discharge no treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Conventional High-Grade Osteosarcoma Distal Femur in Adolescent: (1) **multidisciplinary care at sarcoma center** essential — orthopedic oncology, medical oncology, radiation oncology, pediatric oncology, pathology; (2) **neoadjuvant chemotherapy** (typically MAP — methotrexate, doxorubicin/Adriamycin, cisplatin) × 10 weeks → reassess response → wide surgical resection → adjuvant chemotherapy based on histologic response (Huvos grading — > 90% necrosis = good response); (3) **wide surgical resection** with negative margins — limb salvage preferred over amputation when feasible (oncologic equivalence proven): (a) endoprosthetic reconstruction (megaprosthesis), (b) allograft reconstruction, (c) allograft-prosthesis composite, (d) expandable prosthesis in skeletally immature, (e) **rotationplasty** alternative (especially in young children — durable, functional); (4) **amputation** for: extensive neurovascular involvement, poor chemotherapy response with extensive disease, infection, recurrent; (5) **biopsy planning critical** — must be through planned resection incision (longitudinal, single tract) — avoid contamination of compartments + neurovascular structures; biopsy by treating surgeon ideally; (6) **staging**: bone scan, CT chest (pulmonary mets most common), MRI primary; (7) **5-year survival**: localized 60-70%, metastatic 20-30%; pulmonary metastasectomy improves survival; (8) post-treatment surveillance long-term (recurrence + secondary malignancy from chemo/radiation)

---

Osteosarcoma: aggressive primary bone malignancy of adolescents/young adults. Metaphysis of long bones (distal femur > proximal tibia > proximal humerus). Sunburst + Codman triangle. Treatment: neoadjuvant chemo (MAP) → wide resection (limb salvage preferred) → adjuvant chemo. Biopsy through planned resection incision. Staging — pulmonary mets common. Multidisciplinary sarcoma center. 5-yr 60-70%.', NULL,
  'medium', 'hemato_onco', 'review',
  'orthopedics', 'clinical_decision', 'hemato_onco', 'peds',
  'COG; MAP Protocol; Huvos', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'เด็กชายอายุ 14 ปี ปวด distal thigh ขวา 3 เดือน + ปวดมากตอนกลางคืน + บวมเริ่มเห็นชัด 1 เดือน, ไม่มี trauma

PE: tender + warm mass distal thigh anterolateral, palpable firm mass 8 cm, no joint effusion knee, no neurologic deficit, no constitutional symptoms
Lab: ALP elevated 850 (normal < 350), LDH elevated

X-ray femur: aggressive lytic + sclerotic lesion distal femoral metaphysis with sunburst periosteal reaction + Codman triangle + soft tissue mass
MRI femur: intramedullary mass + extension into soft tissue, no skip lesions
CT chest: no pulmonary metastases
Bone scan: increased uptake distal femur, no other lesions

Biopsy (through future incision line for resection): high-grade conventional osteosarcoma'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 12 ปี ปวด pelvis ซ้าย + บวม + ไข้ intermittent 2 เดือน + น้ำหนักลด 3 kg

PE: palpable mass left iliac wing + tender, low-grade fever, limp
Lab: WBC 13,000, ESR 80, CRP 90 (can mimic infection — "sheep in wolf''s clothing")

X-ray pelvis: permeative lytic lesion left ilium + onion-skin periosteal reaction + large soft tissue mass
MRI: extensive marrow involvement + soft tissue extension
CT chest: small bilateral pulmonary nodules suspicious
Bone scan + PET: increased uptake left iliac + pulmonary nodules + spine

Biopsy: Ewing sarcoma — small round blue cell tumor, EWS-FLI1 fusion confirmed by FISH/PCR', '[{"label":"A","text":"Radiation alone no chemotherapy"},{"label":"B","text":"Ewing Sarcoma Pelvis with Pulmonary Metastases in Adolescent"},{"label":"C","text":"Discharge as infection treat antibiotics only"},{"label":"D","text":"Surgery only without chemo"},{"label":"E","text":"Above-elbow amputation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ewing Sarcoma Pelvis with Pulmonary Metastases in Adolescent: (1) **multidisciplinary care at sarcoma center**; (2) **neoadjuvant chemotherapy** (VAIA, VIDE, or **VDC/IE** regimens — vincristine, doxorubicin, cyclophosphamide alternating with ifosfamide, etoposide; modern intensified protocols with interval compression) — Ewing is chemo + radiation sensitive (unlike osteosarcoma which is radiation resistant); (3) **local control after neoadjuvant chemo**: (a) **wide surgical resection** preferred when feasible + functional reconstruction; (b) **definitive radiation therapy** alternative when surgery would cause significant morbidity (axial skeleton, pelvis, spine — common in Ewing) or unresectable; (c) **combined surgery + radiation** for marginal resection; (4) **adjuvant chemotherapy** post-local control; (5) **pulmonary metastases** — whole-lung radiation + metastasectomy considered for limited disease — improves survival; (6) **biopsy** through future resection line; molecular confirmation EWS-FLI1 fusion gene (90-95%) or EWS-ERG (5-10%); (7) **staging**: bone scan, PET-CT, CT chest, MRI primary; (8) **5-year survival**: localized 70-80%, metastatic 20-30% (pelvic + axial worse than appendicular); (9) sometimes confused with infection initially (constitutional symptoms, elevated inflammatory markers) — biopsy if atypical; (10) long-term: secondary malignancies, cardiotoxicity (doxorubicin), infertility, growth disturbance — counsel

---

Ewing sarcoma: 2nd most common pediatric bone tumor. Small round blue cell — EWS-FLI1 fusion (90%). Diaphysis or flat bones (pelvis, scapula, ribs). Permeative + onion-skin periosteum. Can mimic infection (fever, ESR). Chemotherapy + radiation sensitive (unlike osteosarcoma). Treatment: neoadjuvant chemo → local control (resection or radiation or both) → adjuvant chemo. Multidisciplinary.', NULL,
  'hard', 'hemato_onco', 'review',
  'orthopedics', 'clinical_decision', 'hemato_onco', 'peds',
  'COG Ewing Protocols', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'เด็กชายอายุ 12 ปี ปวด pelvis ซ้าย + บวม + ไข้ intermittent 2 เดือน + น้ำหนักลด 3 kg

PE: palpable mass left iliac wing + tender, low-grade fever, limp
Lab: WBC 13,000, ESR 80, CRP 90 (can mimic infection — "sheep in wolf''s clothing")

X-ray pelvis: permeative lytic lesion left ilium + onion-skin periosteal reaction + large soft tissue mass
MRI: extensive marrow involvement + soft tissue extension
CT chest: small bilateral pulmonary nodules suspicious
Bone scan + PET: increased uptake left iliac + pulmonary nodules + spine

Biopsy: Ewing sarcoma — small round blue cell tumor, EWS-FLI1 fusion confirmed by FISH/PCR'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 62 ปี s/p left nephrectomy for RCC 3 ปี ตอนนี้ปวด left femur 6 สัปดาห์ ปวดมากขึ้นเรื่อย ๆ ตอนนี้ขาเริ่มอ่อนแรงเมื่อ weight bear + พร้อมจะหัก

PE: tender thigh proximal, no obvious deformity (impending fracture)
Lab: anemia, hypercalcemia 11.5 (suggests bone destruction)

X-ray femur: lytic destructive lesion proximal femur, > 50% cortical involvement, peri-trochanteric region, axial length > 2.5 cm — Mirels score 11 (likely pathologic fracture)
CT: pulmonary nodules + multiple bony lesions consistent with metastatic disease
MRI: extensive marrow replacement', '[{"label":"A","text":"Bedrest until natural fracture"},{"label":"B","text":"Impending Pathologic Fracture Proximal Femur from RCC Metastasis (Mirels Score 11)"},{"label":"C","text":"No surgery palliative care only without embolization"},{"label":"D","text":"Above-knee amputation"},{"label":"E","text":"Discharge no follow-up"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Impending Pathologic Fracture Proximal Femur from RCC Metastasis (Mirels Score 11): (1) **Mirels scoring** for impending pathologic fracture risk (location, pain, lesion type, size): score ≥ 9 → prophylactic fixation strongly recommended (fracture risk > 33%); RCC mets score: proximal femur (3) + functional pain (3) + lytic (3) + > 2/3 width (3) = 12; (2) **prophylactic fixation BEFORE fracture** preferred — better outcomes vs after fracture (less pain, shorter hospitalization, faster recovery): (a) **intramedullary nail (cephalomedullary)** for diaphyseal + peri-trochanteric lesions — gold standard, protects entire bone; (b) **hemiarthroplasty or THA** for femoral head/neck lesions (subcapital, intracapsular); (c) **endoprosthetic reconstruction (megaprosthesis)** for extensive proximal femur destruction; (3) **preoperative considerations**: (a) **RCC mets — hypervascular** → **preoperative arterial embolization 24-48 hours before surgery** to reduce blood loss (can be massive without embolization), (b) cross-match adequate blood products, (c) medical optimization; (4) **postoperative radiation therapy** to surgical site to prevent further local progression + improve durability of fixation (8 Gy × 1 or 20-30 Gy in 5-10 fractions); (5) **systemic therapy** — RCC: tyrosine kinase inhibitors (sunitinib, sorafenib), immunotherapy (nivolumab, pembrolizumab); (6) bisphosphonate or denosumab for bone health, hypercalcemia treatment; (7) **multidisciplinary palliative + oncology team**; (8) functional rehabilitation; (9) survivorship + symptom management

---

Impending pathologic fracture: Mirels score guides (≥ 9 = surgery). Prophylactic fixation > after fracture. IM nail for diaphyseal/peri-trochanteric; arthroplasty for head/neck. RCC mets — HYPERVASCULAR → preoperative embolization essential. Post-op radiation to surgical site. Systemic therapy (TKI, IO). Bisphosphonate/denosumab. Multidisciplinary palliative.', NULL,
  'hard', 'hemato_onco', 'review',
  'orthopedics', 'clinical_decision', 'hemato_onco', 'adult',
  'Mirels Score; AAOS Metastatic Bone Disease', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 62 ปี s/p left nephrectomy for RCC 3 ปี ตอนนี้ปวด left femur 6 สัปดาห์ ปวดมากขึ้นเรื่อย ๆ ตอนนี้ขาเริ่มอ่อนแรงเมื่อ weight bear + พร้อมจะหัก

PE: tender thigh proximal, no obvious deformity (impending fracture)
Lab: anemia, hypercalcemia 11.5 (suggests bone destruction)

X-ray femur: lytic destructive lesion proximal femur, > 50% cortical involvement, peri-trochanteric region, axial length > 2.5 cm — Mirels score 11 (likely pathologic fracture)
CT: pulmonary nodules + multiple bony lesions consistent with metastatic disease
MRI: extensive marrow replacement'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 68 ปี ปวดหลัง T-spine + lumbar 4 เดือน ค่อย ๆ แย่ลง + อ่อนเพลีย + น้ำหนักลด 8 kg + recurrent infection 2 episodes pneumonia

PE: midline T-spine tenderness, no neurologic deficit, no obvious deformity
Lab: Hb 8.5 (anemia), Cr 2.1 (renal impairment), Ca 11.8 (hypercalcemia), total protein 9.5 (elevated), albumin 3.0 — high gap

SPEP: M-spike IgG kappa monoclonal protein
24-hour urine: Bence-Jones protein +
Serum free light chain: kappa elevated, ratio abnormal
Bone marrow biopsy: 35% plasma cells (clonal)
Skeletal survey + low-dose whole-body CT: multiple lytic "punched-out" lesions skull + vertebra + ribs + pelvis + bilateral pathologic compression fractures T8 + T10

Dx: multiple myeloma (CRAB criteria — hyperCalcemia, Renal, Anemia, Bone)', '[{"label":"A","text":"Surgical fusion all vertebrae empirically"},{"label":"B","text":"Multiple Myeloma with Pathologic Vertebral Compression Fractures (No Neurologic Compromise)"},{"label":"C","text":"Discharge no treatment"},{"label":"D","text":"Wait for pathologic fracture before any treatment"},{"label":"E","text":"High-dose radiation 60 Gy palliative"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multiple Myeloma with Pathologic Vertebral Compression Fractures (No Neurologic Compromise): (1) **multidisciplinary care** — hematology/oncology, orthopedic, radiation oncology, palliative; (2) **systemic chemotherapy** — backbone (induction + maintenance): triplet regimens — bortezomib + lenalidomide + dexamethasone (VRd) or carfilzomib-based; **autologous stem cell transplant** for eligible patients < 70 ปี; CAR-T + bispecific antibodies emerging; (3) **bisphosphonate (zoledronate IV) or denosumab** monthly — reduces skeletal-related events, hypercalcemia, pain (standard of care); long-term — monitor osteonecrosis of jaw, atypical femur fracture; (4) **bracing (TLSO)** for symptomatic vertebral compression fracture pain + support; (5) **vertebroplasty/kyphoplasty** for: persistent severe pain failing conservative > 4-6 weeks, acute fracture with bone marrow edema MRI; selective use; (6) **radiation therapy** for painful bone lesions (low dose 8 Gy × 1 effective for myeloma — highly radiosensitive) — palliative, prevents progression; (7) **surgical decompression + stabilization** indicated for: neurologic compromise, spinal instability, refractory pain after radiation/conservative — usually instrumented fusion; (8) **hypercalcemia management**: IV fluids, bisphosphonate, calcitonin acute, denosumab; (9) **renal preservation** — adequate hydration, avoid nephrotoxins, manage paraprotein; (10) infection prophylaxis (PCP, varicella), VTE prophylaxis (lenalidomide/dex regimen → high VTE risk); (11) **prognosis** — median OS 5-10 years modern; (12) screen for solitary plasmacytoma vs MM

---

Multiple myeloma: clonal plasma cell malignancy. CRAB criteria. M-spike SPEP, Bence-Jones, plasma cells > 10% bone marrow, lytic lesions. Treatment: triplet chemo + ASCT + bisphosphonate/denosumab + radiation for painful lesions (highly radiosensitive). Vertebroplasty for refractory VCF. Surgery for neuro compromise/instability. Multidisciplinary. Mortality from disease + complications (renal, infection).', NULL,
  'medium', 'hemato_onco', 'review',
  'orthopedics', 'clinical_decision', 'hemato_onco', 'adult',
  'IMWG; mSMART', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 68 ปี ปวดหลัง T-spine + lumbar 4 เดือน ค่อย ๆ แย่ลง + อ่อนเพลีย + น้ำหนักลด 8 kg + recurrent infection 2 episodes pneumonia

PE: midline T-spine tenderness, no neurologic deficit, no obvious deformity
Lab: Hb 8.5 (anemia), Cr 2.1 (renal impairment), Ca 11.8 (hypercalcemia), total protein 9.5 (elevated), albumin 3.0 — high gap

SPEP: M-spike IgG kappa monoclonal protein
24-hour urine: Bence-Jones protein +
Serum free light chain: kappa elevated, ratio abnormal
Bone marrow biopsy: 35% plasma cells (clonal)
Skeletal survey + low-dose whole-body CT: multiple lytic "punched-out" lesions skull + vertebra + ribs + pelvis + bilateral pathologic compression fractures T8 + T10

Dx: multiple myeloma (CRAB criteria — hyperCalcemia, Renal, Anemia, Bone)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 28 ปี ปวด + บวมข้อมือซ้าย 6 เดือน ค่อย ๆ โตขึ้น ไม่มี trauma

PE: firm mass distal radius, mild tenderness, no neurovascular deficit

X-ray wrist: eccentric subchondral lytic lesion in distal radius epiphysis extending to subchondral bone + cortical thinning + no significant matrix mineralization + "soap bubble" appearance — typical for GCT
MRI: lesion with no cortical breakthrough, no soft tissue mass, no fluid-fluid level (rules out ABC), heterogeneous signal
CT chest: clear (rule out pulmonary mets — GCT can have benign pulmonary mets ~ 2-5%)

Core needle biopsy: giant cell tumor of bone (benign aggressive, Campanacci grade II)', '[{"label":"A","text":"Amputation hand"},{"label":"B","text":"Giant Cell Tumor of Bone (GCT) — Distal Radius, Campanacci II, Benign Aggressive"},{"label":"C","text":"Radiation primary therapy"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Excisional biopsy in community hospital first"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Giant Cell Tumor of Bone (GCT) — Distal Radius, Campanacci II, Benign Aggressive: (1) **multidisciplinary orthopedic oncology** — GCT is benign but locally aggressive + can metastasize to lung (2-5%, "benign pulmonary metastases") + rare malignant transformation; (2) **intralesional curettage + adjuvant** — gold standard for most: (a) extensive curettage + high-speed burr, (b) **adjuvant** — phenol, liquid nitrogen, hydrogen peroxide, polymethylmethacrylate (PMMA) cement, argon beam — reduces local recurrence (10-30% with curettage alone → 5-15% with adjuvant); (3) **denosumab** (RANKL inhibitor, monoclonal antibody) — neoadjuvant for downstaging unresectable/large GCT or for pulmonary metastases or for primary treatment if surgery unsuitable; ongoing therapy with discontinuation issues (recurrence); (4) **en bloc wide resection** for Campanacci III with extensive cortical breakthrough or recurrence — distal radius is one of preferred sites for en bloc resection + reconstruction (vascularized fibula autograft, allograft, wrist arthrodesis); (5) **lung CT for staging** + surveillance (asymptomatic pulmonary mets often observed or excised); (6) **post-curettage**: PMMA cement provides immediate stability + heat reduces local recurrence; subchondral lesions — bone graft beneath subchondral bone + cement for support; (7) follow-up surveillance long-term (recurrence + lung CT); (8) **don''t confuse with**: ABC (aneurysmal bone cyst — fluid-fluid level on MRI), brown tumor of hyperparathyroidism (check PTH, calcium), chondroblastoma (different location, age)

---

GCT: benign but locally aggressive bone tumor. Young adults 20-40 yr. Epiphyseal/subchondral location (distal femur > proximal tibia > distal radius > sacrum). Treatment: intralesional curettage + adjuvant (PMMA cement, phenol). Denosumab for unresectable/large/mets. En bloc resection for Campanacci III/recurrent. Benign pulmonary mets (2-5%) — CT screening. DDx: ABC (fluid-fluid), brown tumor (HPT), chondroblastoma.', NULL,
  'hard', 'hemato_onco', 'review',
  'orthopedics', 'clinical_decision', 'hemato_onco', 'adult',
  'Campanacci; AAOS Sarcoma', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'หญิงไทยอายุ 28 ปี ปวด + บวมข้อมือซ้าย 6 เดือน ค่อย ๆ โตขึ้น ไม่มี trauma

PE: firm mass distal radius, mild tenderness, no neurovascular deficit

X-ray wrist: eccentric subchondral lytic lesion in distal radius epiphysis extending to subchondral bone + cortical thinning + no significant matrix mineralization + "soap bubble" appearance — typical for GCT
MRI: lesion with no cortical breakthrough, no soft tissue mass, no fluid-fluid level (rules out ABC), heterogeneous signal
CT chest: clear (rule out pulmonary mets — GCT can have benign pulmonary mets ~ 2-5%)

Core needle biopsy: giant cell tumor of bone (benign aggressive, Campanacci grade II)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 8 ปี ปวด distal femur ขวา 5 วัน + ไข้สูง 39.2°C + ไม่ยอม weight bear + ค่อย ๆ บวม

V/S: BP 105/65, HR 130, Temp 39.2°C
PE: tender + warm distal femur, refuse weight bear, knee effusion mild (sympathetic), no overlying skin lesion (rules out cellulitis)
Lab: WBC 18,500 (PMN 88%), CRP 220, ESR 95, blood culture × 2 pending
MRI femur + Gd: bone marrow edema + subperiosteal abscess distal femur metaphysis + surrounding soft tissue edema — acute hematogenous osteomyelitis', '[{"label":"A","text":"Oral antibiotic outpatient only without admission"},{"label":"B","text":"Acute Hematogenous Osteomyelitis Distal Femur Pediatric"},{"label":"C","text":"No antibiotic just observation"},{"label":"D","text":"6-month IV antibiotic mandatory"},{"label":"E","text":"Amputation femur"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Hematogenous Osteomyelitis Distal Femur Pediatric: (1) **blood culture × 2 + tissue/bone aspirate culture** before starting antibiotic; identify organism (Kingella PCR for 6-36 months, MRSA screening); (2) **empirical IV antibiotic** within hours based on age + local epidemiology: (a) age > 3 months: cefazolin or clindamycin (cover MSSA/Streptococcus); consider vancomycin if MRSA prevalence high (> 10-15%); add ceftriaxone if Kingella suspected ("less ill" child 6-36 mo); (b) age < 3 months: vancomycin + cefotaxime (GBS, gram-negative, S. aureus); (c) sickle cell: add coverage for Salmonella (ceftriaxone); (3) **modern protocol — early transition to oral antibiotic** when clinical + lab improvement (afebrile, CRP downtrending) at 3-7 days IV → oral antibiotic to complete 3-4 weeks total (oral as effective as IV per recent RCTs — no need for prolonged IV/PICC) — major paradigm shift; (4) **surgical drainage + debridement** indicated: (a) **subperiosteal abscess** (as in this case), (b) intraosseous abscess, (c) failure of conservative response 48-72 hours, (d) adjacent septic arthritis, (e) sequestrum (chronic); (5) **antibiotic duration 3-4 weeks** acute (longer 4-6 weeks if complex/inadequate source control); monitor with CRP normalization; (6) **MRI** definitive imaging — early changes (vs X-ray which shows changes only after 10-14 days); (7) **multidisciplinary**: pediatric ortho + ID + pediatric medicine; (8) **complications**: chronic osteomyelitis, growth arrest (if physis involved), sequestrum, sepsis, septic arthritis; (9) long-term follow-up

---

Pediatric hematogenous osteomyelitis: metaphyseal long bones (slow-flow vessels). S. aureus most common. Kingella (6-36 mo, PCR), Salmonella (SCD). MRI early diagnosis. Empirical IV antibiotic by age + local MRSA prevalence + clinical (Kingella). Surgical drainage for abscess + adjacent septic arthritis + failed conservative. Modern: early IV-to-oral transition, 3-4 wk total. Complications: chronic OM, growth arrest.', NULL,
  'easy', 'id', 'review',
  'orthopedics', 'clinical_decision', 'id', 'peds',
  'IDSA Pediatric Osteomyelitis 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'เด็กชายอายุ 8 ปี ปวด distal femur ขวา 5 วัน + ไข้สูง 39.2°C + ไม่ยอม weight bear + ค่อย ๆ บวม

V/S: BP 105/65, HR 130, Temp 39.2°C
PE: tender + warm distal femur, refuse weight bear, knee effusion mild (sympathetic), no overlying skin lesion (rules out cellulitis)
Lab: WBC 18,500 (PMN 88%), CRP 220, ESR 95, blood culture × 2 pending
MRI femur + Gd: bone marrow edema + subperiosteal abscess distal femur metaphysis + surrounding soft tissue edema — acute hematogenous osteomyelitis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 60 ปี DM2 (HbA1c 9.5%) มี chronic foot ulcer plantar 1st MTP 6 เดือน + ขนาด 3 cm × probe to bone +, ขอบ undermined + slough
No cellulitis ascending; foot warmth normal, no systemic symptoms

V/S: stable, no fever
PE: 1st MTP ulcer probe-to-bone positive (highly suggestive osteomyelitis), peripheral pulses palpable (ABI 0.85), neuropathy + (insensate)
Lab: WBC 9,500, CRP 35, ESR 65, glucose 220

X-ray foot: cortical destruction + lucency 1st metatarsal head + periosteal reaction — chronic osteomyelitis
MRI foot: bone marrow edema + cortical destruction + subcutaneous abscess 1st MT — osteomyelitis confirmed
Bone biopsy + culture: MSSA', '[{"label":"A","text":"Above-knee amputation always"},{"label":"B","text":"Diabetic Foot Osteomyelitis Chronic + Probe-to-Bone Positive"},{"label":"C","text":"Oral antibiotics 5 days only"},{"label":"D","text":"No antibiotics observation"},{"label":"E","text":"Long-term IV antibiotics > 1 year"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Diabetic Foot Osteomyelitis Chronic + Probe-to-Bone Positive: (1) **multidisciplinary diabetic foot care** — endocrine, vascular, infectious disease, podiatry/orthopedic, wound care, nutrition; (2) **probe-to-bone test** sensitive + specific for OM in diabetic foot; X-ray + MRI confirms; **bone biopsy + culture** preferred over wound swab (deep tissue/bone — gold standard for organism + sensitivities); (3) **vascular assessment** — ABI, toe-brachial index, TcPO2 — if vascular insufficiency → vascular surgery for revascularization before/with limb salvage; (4) **glycemic control** — HbA1c target individualized (< 8 reasonable balance); (5) **antibiotic therapy** organism-targeted: (a) **6 weeks** if surgical resection achieves clear margin or no surgery (medical only — selective); (b) **2-4 weeks** if surgical resection achieves complete removal of infected bone with clean margins; (c) empirical broad spectrum if culture pending — cover S. aureus (vancomycin if MRSA risk) + gram-negative + anaerobes for limb-threatening; (6) **surgical resection of infected bone** indicated: (a) failure of medical management, (b) extensive bony destruction, (c) sepsis, (d) gangrene/necrosis, (e) deep abscess; partial calcanectomy, metatarsal head/ray resection, transmetatarsal amputation, midfoot/below-knee amputation depending on extent; (7) **wound care + offloading** — total contact casting, removable boot, specialized footwear; (8) **negative pressure wound therapy (VAC)** + adjuncts; (9) **screen + treat comorbidities** (renal, retinopathy, autonomic); (10) **smoking cessation**, foot care education, regular podiatry follow-up; (11) prevention — most important

---

Diabetic foot osteomyelitis: probe-to-bone + MRI + bone biopsy. Multidisciplinary (endo + vascular + ID + podiatry + wound care). Vascular optimization first. Targeted antibiotic 6 wk (medical) or 2-4 wk (post-surgical clear margin) per bone biopsy + culture. Surgical resection for failed medical, extensive destruction, sepsis. Wound care + offloading + glycemic control. Prevention through foot care education.', NULL,
  'medium', 'id', 'review',
  'orthopedics', 'clinical_decision', 'id', 'adult',
  'IDSA Diabetic Foot 2012; IWGDF', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 60 ปี DM2 (HbA1c 9.5%) มี chronic foot ulcer plantar 1st MTP 6 เดือน + ขนาด 3 cm × probe to bone +, ขอบ undermined + slough
No cellulitis ascending; foot warmth normal, no systemic symptoms

V/S: stable, no fever
PE: 1st MTP ulcer probe-to-bone positive (highly suggestive osteomyelitis), peripheral pulses palpable (ABI 0.85), neuropathy + (insensate)
Lab: WBC 9,500, CRP 35, ESR 65, glucose 220

X-ray foot: cortical destruction + lucency 1st metatarsal head + periosteal reaction — chronic osteomyelitis
MRI foot: bone marrow edema + cortical destruction + subcutaneous abscess 1st MT — osteomyelitis confirmed
Bone biopsy + culture: MSSA'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 38 ปี HIV-negative อาการปวดหลัง T-spine ไข้ low-grade 39°C + เหงื่อกลางคืน + น้ำหนักลด 5 kg 3 เดือน + เริ่มอ่อนแรงขา 2 ข้าง 1 สัปดาห์

V/S: Temp 38.0°C
PE: thoracic kyphosis เพิ่ม + tender T8 + paraspinal mass palpable, motor LE 4/5 with hyperreflexia + +Babinski
Lab: WBC 9,000, CRP 80, ESR 90, HIV negative

MRI T-spine + Gd: T8-T9 vertebral body destruction + intervertebral disc relatively preserved ("disc-sparing" — characteristic of TB) + large bilateral paraspinal abscess (psoas extension) + epidural component with cord compression

CBC + ECG + cxr: miliary TB pattern in chest
AFB smear sputum + + bronchoscopy → MTB culture positive', '[{"label":"A","text":"Antibiotics broad spectrum 2 weeks only"},{"label":"B","text":"Spinal Tuberculosis (Pott''s Disease) with Cord Compression"},{"label":"C","text":"Surgical fusion without ATT"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Single antitubercular drug rifampin alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Spinal Tuberculosis (Pott''s Disease) with Cord Compression: (1) **multidisciplinary care** — TB specialist (pulmonology/ID), orthopedic spine surgeon, neurosurgeon, public health; (2) **anti-TB therapy (ATT)** — backbone, started immediately after workup: HRZE (isoniazid + rifampin + pyrazinamide + ethambutol) × 2 months → HR × 7-10 months (total 9-12 months for spinal TB, longer than pulmonary); modify based on drug sensitivity (MDR/XDR); (3) monitor liver function, vision (ethambutol), pyridoxine supplementation; (4) **surgical decompression + stabilization** indicated for: (a) **neurologic deficit** (as in this case) — emergent decompression to preserve neurology, (b) significant kyphosis > 30° or progressive deformity, (c) instability, (d) large abscess + cold abscess > 5 cm, (e) failure of medical management, (f) doubt of diagnosis (need biopsy); (5) **surgical approach** typically anterior debridement + reconstruction (cage, strut graft) + posterior instrumentation (combined approach) — Hong Kong operation classic; (6) **CT-guided drainage** + biopsy for abscess + organism confirmation + AFB + GeneXpert (rapid PCR) + culture + drug sensitivity; (7) **non-operative**: medical only for early Pott''s without neurologic compromise + small abscess + no significant deformity — bracing (TLSO) + ATT + monitor with MRI; (8) **multidrug-resistant TB** (MDR/XDR) — longer treatment (18-24 months), 2nd-line drugs, modified surgery; (9) screen HIV + immunocompromised; (10) public health notification + contact tracing; (11) nutritional optimization

---

Pott''s disease: spinal TB. Disc-sparing + paraspinal abscess + adjacent vertebral involvement. ATT 9-12 months (HRZE → HR). Surgical decompression + stabilization for neurologic deficit, deformity, abscess, instability, dx confirmation. CT-guided biopsy + GeneXpert + culture. Multidrug-resistant requires modified. HIV screen. Notification. Multidisciplinary.', NULL,
  'hard', 'id', 'review',
  'orthopedics', 'clinical_decision', 'id', 'adult',
  'WHO TB; Hong Kong Operation', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 38 ปี HIV-negative อาการปวดหลัง T-spine ไข้ low-grade 39°C + เหงื่อกลางคืน + น้ำหนักลด 5 kg 3 เดือน + เริ่มอ่อนแรงขา 2 ข้าง 1 สัปดาห์

V/S: Temp 38.0°C
PE: thoracic kyphosis เพิ่ม + tender T8 + paraspinal mass palpable, motor LE 4/5 with hyperreflexia + +Babinski
Lab: WBC 9,000, CRP 80, ESR 90, HIV negative

MRI T-spine + Gd: T8-T9 vertebral body destruction + intervertebral disc relatively preserved ("disc-sparing" — characteristic of TB) + large bilateral paraspinal abscess (psoas extension) + epidural component with cord compression

CBC + ECG + cxr: miliary TB pattern in chest
AFB smear sputum + + bronchoscopy → MTB culture positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 50 ปี DM ปวด + บวม ขาขวาตั้งแต่ ankle ขึ้นมา calf 2 วัน หลัง trauma เล็กน้อยกระแทกประตู เริ่มมี erythema → bullae → skin necrosis เปลี่ยนสีเทาดำ ปวดมากเกินกว่า skin findings (pain out of proportion)

V/S: BP 88/55, HR 130, RR 26, Temp 39.5°C, SpO2 92%, septic shock
PE: extensive erythema + hemorrhagic bullae + dishwater drainage + crepitus + tense edema + decreased sensation overlying skin ("woody" induration extending beyond visible erythema)
Lab: WBC 24,000 (PMN 92% + bands), Cr 2.5, lactate 4.5, BUN 45, Na 128, glucose 380, CRP 480, LRINEC score 9 (high risk)

X-ray + CT leg: subcutaneous gas + extensive soft tissue edema along fascial planes — necrotizing soft tissue infection', '[{"label":"A","text":"Oral antibiotics outpatient"},{"label":"B","text":"Necrotizing Fasciitis with Septic Shock — Surgical Emergency"},{"label":"C","text":"Wait for cultures before antibiotics"},{"label":"D","text":"Conservative no surgery initial"},{"label":"E","text":"Long-term IV antibiotic only 6 months no surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Necrotizing Fasciitis with Septic Shock — Surgical Emergency: (1) **immediate aggressive resuscitation** in parallel with surgery: ABCs + airway, IV access × 2 large bore, crystalloid + vasopressor (norepinephrine) for MAP > 65, blood culture × 2, lactate; (2) **broad-spectrum empirical antibiotics within 1 hour**: triple coverage — **vancomycin + piperacillin-tazobactam (or meropenem) + clindamycin** (clindamycin essential — anti-toxin/Eagle effect against streptococcal/clostridial exotoxin + reduces super-antigen production); add IVIG for streptococcal toxic shock; (3) **EMERGENT surgical debridement within hours** — single most important determinant of survival; mortality increases each hour of delay; aggressive wide debridement to bleeding healthy tissue + remove ALL necrotic fascia/tissue + obtain tissue cultures + Gram stain; repeat debridement at 24-48 hours until clean ("second look"); (4) **multidisciplinary surgical team** — general/trauma surgery + orthopedic + plastic + ICU + ID; (5) **adjunct hyperbaric oxygen** controversial — should not delay surgery; (6) **fasciotomy** if compartment syndrome features; (7) **wound management** post-debridement: VAC + delayed reconstruction (flaps, skin grafts) after clean; (8) **amputation** if extensive necrosis + uncontrollable sepsis; (9) **fluid + electrolyte + glycemic management**; (10) **classify type**: I (polymicrobial — DM, abdomen), II (monomicrobial Group A Strep — limbs, healthy), III (Vibrio — seawater exposure, fish), IV (fungal — immunocompromised); (11) **LRINEC score** > 6 suspicion, > 8 high; (12) high mortality 20-40% even with prompt treatment

---

Necrotizing fasciitis: surgical emergency. Mortality increases each hour delay. Triad: pain out of proportion + woody induration extending past erythema + systemic toxicity. Resuscitation + IV abx (vanc + pip-tazo + CLINDAMYCIN — anti-toxin) within 1h + emergent aggressive debridement. Repeat debridement 24-48h. Multidisciplinary. Types I-IV. LRINEC score. Mortality 20-40%.', NULL,
  'medium', 'id', 'review',
  'orthopedics', 'clinical_decision', 'id', 'adult',
  'IDSA SSTI; LRINEC Score', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 50 ปี DM ปวด + บวม ขาขวาตั้งแต่ ankle ขึ้นมา calf 2 วัน หลัง trauma เล็กน้อยกระแทกประตู เริ่มมี erythema → bullae → skin necrosis เปลี่ยนสีเทาดำ ปวดมากเกินกว่า skin findings (pain out of proportion)

V/S: BP 88/55, HR 130, RR 26, Temp 39.5°C, SpO2 92%, septic shock
PE: extensive erythema + hemorrhagic bullae + dishwater drainage + crepitus + tense edema + decreased sensation overlying skin ("woody" induration extending beyond visible erythema)
Lab: WBC 24,000 (PMN 92% + bands), Cr 2.5, lactate 4.5, BUN 45, Na 128, glucose 380, CRP 480, LRINEC score 9 (high risk)

X-ray + CT leg: subcutaneous gas + extensive soft tissue edema along fascial planes — necrotizing soft tissue infection'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 45 ปี s/p open tibia fracture + ORIF 2 ปีก่อน เริ่มมี draining sinus ขาส่วนล่าง 8 เดือน + ปวด intermittent + bone fragment ออกมาจาก sinus เป็นครั้งคราว

PE: chronic draining sinus tibia, surrounding skin atrophic + discolored, no acute cellulitis, soft tissue thin/fibrotic, palpable hardware deep, NV intact
Lab: WBC 8,500, CRP 25, ESR 50

X-ray tibia: sequestrum (necrotic bone fragment) within involucrum (new bone formation), cortical thickening, lucency around hardware suggesting hardware loosening
MRI tibia: marrow + soft tissue involvement, abscess pocket
Deep tissue + bone biopsy + culture: MRSA + Enterobacter (polymicrobial chronic OM)

Dx: chronic osteomyelitis (Cierny-Mader IIIB — localized + B host)', '[{"label":"A","text":"Oral antibiotics 5 days"},{"label":"B","text":"Chronic Osteomyelitis Post-Trauma — Cierny-Mader IIIB"},{"label":"C","text":"Cast immobilization no surgery"},{"label":"D","text":"Long-term IV antibiotic only no debridement"},{"label":"E","text":"Discharge home no treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic Osteomyelitis Post-Trauma — Cierny-Mader IIIB: (1) **multidisciplinary care** — orthopedic + plastic surgery + ID + wound care + medical optimization; (2) **principles**: (a) thorough debridement of all necrotic bone (sequestrectomy) + soft tissue, (b) hardware removal (typically — biofilm), (c) culture-targeted antibiotics, (d) dead space management, (e) soft tissue coverage, (f) skeletal stabilization, (g) restore function; (3) **staged surgical approach**: (a) **first stage** — wide debridement + sequestrectomy + remove hardware + obtain deep cultures + thorough irrigation + place **antibiotic-loaded cement beads or spacer** (PMMA with vancomycin/tobramycin/gentamicin) — Masquelet technique uses induced membrane for staged bone reconstruction, (b) **second stage** 6-8 weeks later — remove cement + bone graft (autograft iliac crest, allograft, distraction osteogenesis with external fixator/Ilizarov) + definitive fixation; (4) **antibiotic therapy** — culture-targeted IV 4-6 weeks (or oral with high bioavailability — modern transitioning to oral early), guided by sensitivities; chronic suppression possible for non-surgical candidates; (5) **soft tissue coverage** for IIIB defect — local rotational flap (gastrocnemius proximal, soleus middle, distally based sural artery), free flap (latissimus dorsi, ALT — anterolateral thigh) — plastic surgery; (6) **bone reconstruction options**: bone graft (cancellous, structural), bone transport (Ilizarov), vascularized fibula autograft; (7) **B-host optimization** — DM control, smoking cessation, nutrition, MRSA decolonization; (8) **amputation** for: extensive bone loss + soft tissue + functional limitation + recurrent failures + non-compliant host; (9) **long-term follow-up** — relapse high (10-30%)

---

Chronic osteomyelitis: Cierny-Mader staging (anatomic + host). Multidisciplinary. Aggressive debridement + sequestrectomy + hardware removal + antibiotic spacer (1st stage) → bone graft + definitive fixation (2nd stage). Culture-targeted antibiotics 4-6 wk. Soft tissue coverage (local/free flap). Host optimization (DM, smoking, nutrition). Bone reconstruction. Amputation for unreconstructable. Relapse 10-30%.', NULL,
  'hard', 'id', 'review',
  'orthopedics', 'clinical_decision', 'id', 'adult',
  'Cierny-Mader; Masquelet Technique', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 45 ปี s/p open tibia fracture + ORIF 2 ปีก่อน เริ่มมี draining sinus ขาส่วนล่าง 8 เดือน + ปวด intermittent + bone fragment ออกมาจาก sinus เป็นครั้งคราว

PE: chronic draining sinus tibia, surrounding skin atrophic + discolored, no acute cellulitis, soft tissue thin/fibrotic, palpable hardware deep, NV intact
Lab: WBC 8,500, CRP 25, ESR 50

X-ray tibia: sequestrum (necrotic bone fragment) within involucrum (new bone formation), cortical thickening, lucency around hardware suggesting hardware loosening
MRI tibia: marrow + soft tissue involvement, abscess pocket
Deep tissue + bone biopsy + culture: MRSA + Enterobacter (polymicrobial chronic OM)

Dx: chronic osteomyelitis (Cierny-Mader IIIB — localized + B host)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 24 ปี เล่นบาสล้มข้อเท้าซ้ายบิดเข้าใน (inversion) ปวด + บวมข้อเท้า lateral 2 วัน เดินกระเผลกแต่ weight bear ได้บางส่วน

PE: tender ATFL + CFL (anterior + below lateral malleolus), mild swelling, no tenderness medial malleolus, no proximal fibula tenderness, no syndesmotic tenderness, no inability to weight-bear in ED, no bone tenderness 6 cm distal posterior edge of fibula/tibia
Ottawa Ankle Rules: negative — no X-ray indicated

Anterior drawer + + talar tilt + (mild instability) → Grade II lateral ankle sprain (partial ATFL ± CFL tear)', '[{"label":"A","text":"Cast immobilization 6 weeks rigid"},{"label":"B","text":"Acute Lateral Ankle Sprain Grade II — Functional Rehabilitation"},{"label":"C","text":"Surgical repair all acute Grade II sprains"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Long-term opioid"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Lateral Ankle Sprain Grade II — Functional Rehabilitation: (1) **Ottawa Ankle Rules** — clinical decision rule to avoid unnecessary X-ray (high sensitivity > 95%): X-ray if bone tenderness at distal 6 cm posterior edge of medial or lateral malleolus, navicular tenderness, 5th MT base tenderness, OR inability to weight bear 4 steps both in ED + immediately after injury; (2) **PRICE → POLICE protocol** (modern — Protection, Optimal Loading, Ice, Compression, Elevation) initial 48-72 hours; (3) **functional rehabilitation > prolonged immobilization** — better outcomes: brief functional support (compression brace, lace-up brace) 1-2 weeks + early weight-bearing as tolerated; (4) **early mobilization + PT** — most important: ROM exercises, proprioception (wobble board, single-leg balance), peroneal strengthening, sport-specific training, gradual return to play; (5) NSAIDs short course (limited concern about ligament healing in low-grade sprain); (6) **avoid prolonged cast immobilization** > 1 week (causes stiffness, deconditioning, prolongs recovery); (7) **avoid surgical repair** for acute ATFL — equivalent to functional rehab in most patients (recent RCTs); (8) **return to sport** when full ROM + strength + functional tests + no pain ~ 2-6 weeks Grade II; (9) **chronic ankle instability** (recurrent sprains, > 6 months) → consider operative reconstruction — **Brostrom-Gould** procedure (anatomic repair) or anatomic reconstruction with allograft/autograft for poor tissue; (10) **screen for high ankle sprain (syndesmotic)** — squeeze test, external rotation test, dorsiflexion compression test (DRL) — different rehab + may need surgical fixation if unstable

---

Lateral ankle sprain: Ottawa Ankle Rules to avoid X-ray. PRICE → POLICE. Functional rehab > immobilization. Brief brace + early WB + PT (proprioception + peroneal strengthening). Surgery for acute ATFL no better than functional rehab. Chronic instability — Brostrom-Gould. ALWAYS screen syndesmotic (high ankle) — different management.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'Ottawa Ankle Rules; AOFAS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 24 ปี เล่นบาสล้มข้อเท้าซ้ายบิดเข้าใน (inversion) ปวด + บวมข้อเท้า lateral 2 วัน เดินกระเผลกแต่ weight bear ได้บางส่วน

PE: tender ATFL + CFL (anterior + below lateral malleolus), mild swelling, no tenderness medial malleolus, no proximal fibula tenderness, no syndesmotic tenderness, no inability to weight-bear in ED, no bone tenderness 6 cm distal posterior edge of fibula/tibia
Ottawa Ankle Rules: negative — no X-ray indicated

Anterior drawer + + talar tilt + (mild instability) → Grade II lateral ankle sprain (partial ATFL ± CFL tear)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 50 ปี ปวดโคนนิ้วโป้งเท้าซ้าย 3 ปี + bunion โต ใส่รองเท้าลำบาก ค่อย ๆ แย่ลง FAILED 12 เดือน conservative (wide shoes, orthotics, NSAIDs, padding)

PE: hallux valgus angle (HVA) clinically 35°, painful 1st MTP, lateral deviation great toe, dorsiflexion painful, no significant 1st MTP arthritis, second toe overlap mild

Weight-bearing X-ray foot: HVA 35° (normal < 15), IMA (intermetatarsal angle) 14° (normal < 9), distal metatarsal articular angle (DMAA) 10°, congruent joint — moderate hallux valgus', '[{"label":"A","text":"Always Keller resection arthroplasty"},{"label":"B","text":"Moderate Hallux Valgus Failed Conservative — Surgical Correction"},{"label":"C","text":"Steroid injection only long-term"},{"label":"D","text":"Above-ankle amputation"},{"label":"E","text":"Cast immobilization 12 weeks"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Moderate Hallux Valgus Failed Conservative — Surgical Correction: (1) **conservative first-line** for 6-12 months (already failed in this case): (a) **wide toe-box footwear** (most important — most pain from shoe pressure), (b) bunion pads + spacers, (c) orthotics for forefoot pain, (d) NSAIDs for symptoms, (e) night splints (limited evidence), (f) PT for foot intrinsic strengthening; (2) **surgical correction tailored to deformity severity** (HVA + IMA + joint congruency + 1st MTP arthritis): (a) **mild (HVA < 25°, IMA < 13°)**: distal metatarsal osteotomy — Chevron, Mitchell, Akin (proximal phalanx osteotomy as adjunct); (b) **moderate (HVA 25-40°, IMA 13-18°)**: **scarf osteotomy** OR proximal/diaphyseal metatarsal osteotomy + soft tissue procedure (lateral release + medial capsulorrhaphy); (c) **severe (HVA > 40°, IMA > 18°)**: proximal metatarsal osteotomy (Lapidus — 1st TMT arthrodesis — for hypermobile 1st ray) OR double osteotomy; (d) **1st MTP arthritis** present: arthrodesis 1st MTP (definitive, eliminates motion, durable); (3) **minimally invasive (MICA — percutaneous bunionectomy)** emerging — comparable outcomes, shorter recovery — but learning curve; (4) **avoid Keller resection arthroplasty** (transfer metatarsalgia, weakness — outdated except very low demand elderly); (5) **avoid surgery for cosmesis alone**; (6) post-op: post-op shoe 4-6 weeks, gradual return to regular shoe 6-12 weeks, full activity 3-6 months; (7) **rheumatoid foot** specific — different procedures; (8) recurrence 10-20% — counsel; (9) **Lapidus** for hypermobile 1st TMT joint

---

Hallux valgus: conservative first (wide shoes, padding, NSAIDs) — most pain from shoe pressure. Surgery for failed conservative + functional limitation. Procedure tailored to severity (HVA, IMA, congruency, arthritis): distal osteotomy mild, proximal/scarf moderate, Lapidus severe/hypermobile, arthrodesis with 1st MTP arthritis. Modern MICA emerging. Avoid Keller. NOT for cosmesis alone. Recurrence 10-20%.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AOFAS Hallux Valgus', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'หญิงไทยอายุ 50 ปี ปวดโคนนิ้วโป้งเท้าซ้าย 3 ปี + bunion โต ใส่รองเท้าลำบาก ค่อย ๆ แย่ลง FAILED 12 เดือน conservative (wide shoes, orthotics, NSAIDs, padding)

PE: hallux valgus angle (HVA) clinically 35°, painful 1st MTP, lateral deviation great toe, dorsiflexion painful, no significant 1st MTP arthritis, second toe overlap mild

Weight-bearing X-ray foot: HVA 35° (normal < 15), IMA (intermetatarsal angle) 14° (normal < 9), distal metatarsal articular angle (DMAA) 10°, congruent joint — moderate hallux valgus'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 58 ปี DM2 x 20 ปี with diabetic neuropathy + foot deformity, ปวด + บวม + แดง + warm midfoot ขวา 3 สัปดาห์ ไม่มี trauma ชัดเจน, ไม่มี wound

V/S: stable, no fever
PE: warm + erythema + edema midfoot, no draining wound, palpable pedal pulses, severe sensory loss (insensate — neuropathic), rocker-bottom deformity beginning, no ascending cellulitis, no purulence
Lab: WBC 8,000, CRP 25, ESR 45 (mild inflammation but not septic-level), glucose 280

X-ray foot: fragmentation + subluxation + joint destruction Lisfranc (TMT) region, no obvious sequestrum, no soft tissue gas
MRI foot: bone marrow edema + multiple TMT fractures + subluxation without ring-enhancing collection (vs OM which would have abscess + sinus tract)

Dx: Acute Charcot Neuroarthropathy (Eichenholtz stage I — fragmentation) midfoot', '[{"label":"A","text":"Continue normal weight-bearing"},{"label":"B","text":"Acute Charcot Neuroarthropathy (Eichenholtz Stage I — Active Fragmentation)"},{"label":"C","text":"Immediate amputation"},{"label":"D","text":"IV antibiotics presuming osteomyelitis without evidence"},{"label":"E","text":"Long-term oral steroid"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Charcot Neuroarthropathy (Eichenholtz Stage I — Active Fragmentation): (1) **differentiate from osteomyelitis** crucial — clinical (no wound, no sinus tract), MRI (no abscess/ring enhancement), low-level inflammation, history (insensate diabetic without break in skin); biopsy if uncertainty + concurrent ulcer; (2) **immediate immobilization + offloading** — most important intervention: (a) **total contact cast (TCC)** — gold standard — full contact cast that immobilizes + redistributes pressure away from involved area + reduces edema, change weekly, (b) alternative — irremovable CROW boot (Charcot Restraint Orthotic Walker), (c) **strict non-weight bearing or protected WB** for 3-6 months until acute phase resolves; (3) **Eichenholtz staging**: I — fragmentation/destructive (acute, hot, swollen — months); II — coalescence (subacute — resolution of edema, callus formation); III — consolidation (chronic — stable deformity); (4) **monitor**: skin temperature comparison to contralateral (cool down 2°C difference = resolution), X-ray progression, edema reduction; (5) **bisphosphonate** controversial — no clear benefit; calcitonin sometimes used; (6) **glycemic control** + multidisciplinary diabetes care; (7) **surgical reconstruction** (after acute phase resolved into consolidation phase) for: severe deformity preventing braceability, ulceration over bony prominence, instability, recurrent ulcers, infection — options: exostectomy, arthrodesis (midfoot Lapidus, hindfoot triple), Ilizarov correction; (8) **prevent recurrence**: lifetime custom shoes/orthotics + regular podiatry follow-up + patient education; (9) **avoid weight-bearing during acute phase** at all costs — leads to progressive deformity

---

Charcot neuroarthropathy: diabetic neuropathy + autonomic. Differentiate from osteomyelitis (no wound, no abscess on MRI). Eichenholtz I (acute) → II → III. Acute: total contact cast + offloading + protected WB 3-6 mo (until temperature normalizes). Surgery later for severe deformity, ulcer over prominence. Lifetime custom shoes + podiatry. Glycemic control. WB during acute → catastrophic deformity progression.', NULL,
  'hard', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AOFAS Charcot; ADA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 58 ปี DM2 x 20 ปี with diabetic neuropathy + foot deformity, ปวด + บวม + แดง + warm midfoot ขวา 3 สัปดาห์ ไม่มี trauma ชัดเจน, ไม่มี wound

V/S: stable, no fever
PE: warm + erythema + edema midfoot, no draining wound, palpable pedal pulses, severe sensory loss (insensate — neuropathic), rocker-bottom deformity beginning, no ascending cellulitis, no purulence
Lab: WBC 8,000, CRP 25, ESR 45 (mild inflammation but not septic-level), glucose 280

X-ray foot: fragmentation + subluxation + joint destruction Lisfranc (TMT) region, no obvious sequestrum, no soft tissue gas
MRI foot: bone marrow edema + multiple TMT fractures + subluxation without ring-enhancing collection (vs OM which would have abscess + sinus tract)

Dx: Acute Charcot Neuroarthropathy (Eichenholtz stage I — fragmentation) midfoot'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 55 ปี ปวด medial ankle + arch ขวา + ค่อย ๆ มี progressive flatfoot 2 ปี ไม่สามารถยืน single-leg heel raise ได้

PE: visible flatfoot deformity with valgus hindfoot + abducted forefoot + arch collapse, "too many toes sign" lateral (excessive abduction), tender posterior tibial tendon path, unable to perform single heel raise on affected side (cannot invert hindfoot), supple deformity (correctable with manipulation — stage IIA-B vs rigid in advanced)

MRI ankle: posterior tibial tendon tear + tenosynovitis + degeneration, no significant arthritis

Dx: Adult Acquired Flatfoot Deformity (AAFD) — Posterior Tibial Tendon Dysfunction (PTTD), Johnson-Strom stage IIB (flexible + valgus hindfoot + abducted forefoot)', '[{"label":"A","text":"Steroid injection PTT first line"},{"label":"B","text":"Stage IIB Adult Acquired Flatfoot (Flexible Deformity) Failed Conservative — Surgical Reconstruction"},{"label":"C","text":"Always triple arthrodesis regardless of stage"},{"label":"D","text":"Above-knee amputation"},{"label":"E","text":"Discharge no treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Stage IIB Adult Acquired Flatfoot (Flexible Deformity) Failed Conservative — Surgical Reconstruction: (1) **conservative first-line 3-6 months** (already failed in this case): (a) custom-molded orthotic with medial arch + heel posting (UCBL, AFO), (b) **PT** — eccentric posterior tibial tendon strengthening (Alfredson protocol), Achilles stretching, intrinsic foot strengthening, (c) NSAIDs, (d) supportive footwear, (e) brief immobilization (cast/boot) for acute exacerbation, (f) **avoid corticosteroid injection** (risk of tendon rupture); (2) **Johnson-Strom (Myerson modification) staging**: I — tenosynovitis without deformity; II — flexible flatfoot (IIA — forefoot abduction < 30%; IIB — > 30%); III — rigid deformity; IV — talar tilt + ankle valgus; (3) **surgical treatment** stage-specific: (a) Stage I — tenosynovectomy ± tendon debridement; (b) **Stage II (flexible) — joint-sparing reconstruction**: medial slide calcaneal osteotomy + lateral column lengthening (Evans) + FDL (flexor digitorum longus) transfer to navicular + spring ligament repair + Achilles/gastrocnemius lengthening if equinus; (c) Stage III (rigid) — **triple arthrodesis** (subtalar + talonavicular + calcaneocuboid) for rigid hindfoot deformity; (d) Stage IV — modified triple + medial deltoid ligament reconstruction or ankle arthrodesis; (4) post-op: non-WB 6-8 weeks, gradual WB in boot, full WB 3-4 months; (5) modern minimally invasive osteotomies emerging; (6) patient counseling — return to full activity 6-12 months; (7) addressing all components: bony (osteotomy) + soft tissue (FDL transfer, spring ligament) + Achilles (lengthening) — "reconstruction" rather than single procedure

---

PTTD/Adult flatfoot: Johnson-Strom staging guides. Conservative first (orthotic, eccentric exercise — Alfredson). AVOID steroid injection (rupture risk). Surgery for failed conservative: Stage II flexible → joint-sparing (medial slide calc osteotomy + lateral column lengthening + FDL transfer + spring ligament repair); Stage III rigid → triple arthrodesis; Stage IV → modified triple + deltoid reconstruction or ankle fusion.', NULL,
  'hard', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AOFAS; Johnson-Strom; Myerson', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'หญิงไทยอายุ 55 ปี ปวด medial ankle + arch ขวา + ค่อย ๆ มี progressive flatfoot 2 ปี ไม่สามารถยืน single-leg heel raise ได้

PE: visible flatfoot deformity with valgus hindfoot + abducted forefoot + arch collapse, "too many toes sign" lateral (excessive abduction), tender posterior tibial tendon path, unable to perform single heel raise on affected side (cannot invert hindfoot), supple deformity (correctable with manipulation — stage IIA-B vs rigid in advanced)

MRI ankle: posterior tibial tendon tear + tenosynovitis + degeneration, no significant arthritis

Dx: Adult Acquired Flatfoot Deformity (AAFD) — Posterior Tibial Tendon Dysfunction (PTTD), Johnson-Strom stage IIB (flexible + valgus hindfoot + abducted forefoot)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 55 ปี underlying HT + CKD stage 3 + กิน thiazide + alcohol heavy ตื่นมาเช้านี้ปวด + บวม + แดง + ร้อน 1st MTP ขวา (podagra) อย่างรุนแรง 12 ชั่วโมง pain 10/10

V/S: T 37.8°C
PE: erythema + warmth + extreme tenderness 1st MTP ขวา, no other joints, no fever significant, no skin source
Lab: WBC 12,000, CRP 80, uric acid 9.2 (elevated; but acute attack uric acid can be normal), Cr 1.8 (CKD)

Joint aspiration 1st MTP: WBC 28,000 (PMN 80%), polarized light — **negatively birefringent needle-shaped urate crystals** intracellular within neutrophils — gout confirmed
Gram stain negative + culture pending (rules out concurrent septic arthritis)', '[{"label":"A","text":"Start allopurinol immediately during acute attack"},{"label":"B","text":"Acute Gouty Arthritis Attack (First MTP — Podagra) with CKD"},{"label":"C","text":"Continue thiazide diuretic"},{"label":"D","text":"IV antibiotics presumed septic without aspiration"},{"label":"E","text":"No treatment self-limited"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Gouty Arthritis Attack (First MTP — Podagra) with CKD: (1) **joint aspiration mandatory** to confirm dx + rule out septic arthritis (concurrent septic in gouty joint not rare); polarized light microscopy — negatively birefringent needle-shaped urate crystals diagnostic; (2) **acute attack treatment** (start within 24h for best response; continue until resolution + 1-2 days): (a) **NSAIDs** first-line in patients without contraindication (indomethacin, naproxen, etoricoxib) — avoid in this patient with CKD; (b) **colchicine** 1.2 mg → 0.6 mg 1h later → 0.6 mg BID — effective if started early (< 24h); reduce dose in CKD; many GI side effects; (c) **corticosteroid** — oral prednisolone 30-40 mg × 5-7 days OR intra-articular steroid (joint injection — excellent for monoarthritis, after septic ruled out) — **preferred in this patient with CKD**; (d) **IL-1 antagonist (anakinra, canakinumab)** for refractory or NSAID/steroid/colchicine intolerant — expensive; (3) **do NOT start urate-lowering therapy during acute attack** (worsens) — wait 2-4 weeks after resolution; (4) **urate-lowering therapy (ULT)** indications: ≥ 2 attacks/year, tophi, urate nephrolithiasis, CKD: (a) **first-line allopurinol** (titrate to target uric acid < 6, or < 5 if tophi); start 100 mg + slowly uptitrate (rapid escalation may trigger attack); check HLA-B*58:01 in high-risk populations (Asian — SJS/TEN); (b) febuxostat alternative (avoid in CV disease — CARES trial); (c) probenecid (uricosuric) — avoid in CKD; (d) pegloticase for refractory; (5) **flare prophylaxis** during ULT initiation — low-dose colchicine 0.6 mg daily OR low-dose NSAID × 6 months to prevent flares; (6) **lifestyle**: reduce alcohol (especially beer), purine-rich foods (red meat, organ meat, shellfish, high-fructose corn syrup), weight loss, hydration; switch thiazide (worsens hyperuricemia) to alternative (losartan — uricosuric); (7) screen comorbidities (HT, DM, MetS, CV, renal); (8) educate; (9) follow-up

---

Acute gout: joint aspiration confirms (negatively birefringent crystals) + rules out septic. Acute Rx: NSAID, colchicine (early), steroid (preferred in CKD). Do NOT start ULT in acute attack. Indications for ULT: ≥ 2/yr, tophi, nephrolithiasis, CKD. Allopurinol first (target < 6) — check HLA-B*58:01 in Asians (SJS). Flare prophylaxis × 6 mo. Lifestyle. Switch thiazide (worsens). Modify CV/renal/metabolic comorbidities.', NULL,
  'medium', 'rheumatology', 'review',
  'orthopedics', 'clinical_decision', 'rheumatology', 'adult',
  'ACR Gout 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 55 ปี underlying HT + CKD stage 3 + กิน thiazide + alcohol heavy ตื่นมาเช้านี้ปวด + บวม + แดง + ร้อน 1st MTP ขวา (podagra) อย่างรุนแรง 12 ชั่วโมง pain 10/10

V/S: T 37.8°C
PE: erythema + warmth + extreme tenderness 1st MTP ขวา, no other joints, no fever significant, no skin source
Lab: WBC 12,000, CRP 80, uric acid 9.2 (elevated; but acute attack uric acid can be normal), Cr 1.8 (CKD)

Joint aspiration 1st MTP: WBC 28,000 (PMN 80%), polarized light — **negatively birefringent needle-shaped urate crystals** intracellular within neutrophils — gout confirmed
Gram stain negative + culture pending (rules out concurrent septic arthritis)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 55 ปี RA seropositive (RF + anti-CCP +) 15 ปี ปวด + บวมข้อมือ + นิ้วมือ + ผิดรูปทั้ง 2 ข้าง อาการ stable on stable DMARD (MTX + adalimumab) แต่ลำบาก ADL — ติดกระดุม เปิดขวด พิมพ์ ใช้ช้อน

PE: bilateral wrist + MCP + PIP synovitis with classic deformities — ulnar drift MCP, swan neck + boutonnière deformities multiple fingers, wrist subluxation + radial deviation, intrinsic plus deformity, trigger fingers multiple
DAS28 well-controlled 2.8 (low activity)

X-ray hand + wrist: severe RA — joint destruction MCP + PIP + wrist, periarticular osteopenia, subluxation, erosion, no fusion yet', '[{"label":"A","text":"Stop all RA medication before surgery"},{"label":"B","text":"Severe Rheumatoid Hand Deformity Despite Optimized DMARD — Reconstruction"},{"label":"C","text":"Total hand arthrodesis"},{"label":"D","text":"Discharge no surgery ever"},{"label":"E","text":"Above-elbow amputation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Rheumatoid Hand Deformity Despite Optimized DMARD — Reconstruction: (1) **medical management optimization first** with rheumatologist — modern bDMARD/tsDMARD has reduced surgical need: methotrexate, anti-TNF (adalimumab, etanercept), JAK inhibitors (tofacitinib, baricitinib), anti-IL-6 (tocilizumab), B-cell (rituximab) — ensure controlled disease activity DAS28 < 3.2 minimum, ideally remission; (2) **surgery** for functional impairment + pain despite medical optimization, deformity progression, tendon rupture imminent or actual; (3) **principles**: address proximal joints (wrist) before distal (MCP, PIP, DIP) — pyramid; address tendon rupture acutely (e.g., extensor tendon rupture at Lister tubercle — Mannerfelt syndrome — needs tendon transfer); (4) **specific procedures** (tailored): (a) **wrist** — synovectomy + Darrach (distal ulna excision) or Sauvé-Kapandji (DRUJ fusion) for caput ulnae syndrome; wrist arthrodesis (Mannerfelt nail) for end-stage; total wrist arthroplasty alternative; (b) **MCP joints** — silicone implant arthroplasty (Swanson) — pain relief + correction of ulnar drift + improved cosmesis (function modest improvement); modern pyrocarbon implants; tendon rebalancing; (c) **PIP** — silicone arthroplasty (index/middle for pinch — preserve motion) OR arthrodesis (ring/small for stability — preserve grip); (d) **DIP** — usually arthrodesis (stability over motion); (e) **swan neck deformity** — silicone arthroplasty PIP, central slip reattachment, or DIP arthrodesis; (f) **boutonnière** — Fowler central slip reconstruction or arthroplasty if PIP destroyed; (g) **extensor tendon ruptures** — end-to-side transfer (EIP, FDS-3, FDS-4); (5) post-op: hand therapy critical with custom splinting + ROM; (6) patient expectations — pain relief + cosmesis better than function gains; (7) staged procedures common

---

RA hand: medical first (DMARD optimization). Surgery for functional impairment despite optimization. Address proximal → distal. Wrist: synovectomy + Darrach/Sauvé-Kapandji, arthrodesis. MCP: silicone arthroplasty (Swanson). PIP: arthroplasty (index/middle) or arthrodesis (ring/small). DIP: arthrodesis. Extensor rupture: tendon transfer. Hand therapy essential. Pain + cosmesis > function gains. Modern bDMARD reduced surgical need.', NULL,
  'medium', 'rheumatology', 'review',
  'orthopedics', 'clinical_decision', 'rheumatology', 'adult',
  'ACR; ASSH; Mannerfelt', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'หญิงไทยอายุ 55 ปี RA seropositive (RF + anti-CCP +) 15 ปี ปวด + บวมข้อมือ + นิ้วมือ + ผิดรูปทั้ง 2 ข้าง อาการ stable on stable DMARD (MTX + adalimumab) แต่ลำบาก ADL — ติดกระดุม เปิดขวด พิมพ์ ใช้ช้อน

PE: bilateral wrist + MCP + PIP synovitis with classic deformities — ulnar drift MCP, swan neck + boutonnière deformities multiple fingers, wrist subluxation + radial deviation, intrinsic plus deformity, trigger fingers multiple
DAS28 well-controlled 2.8 (low activity)

X-ray hand + wrist: severe RA — joint destruction MCP + PIP + wrist, periarticular osteopenia, subluxation, erosion, no fusion yet'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 65 ปี Ankylosing Spondylitis (HLA-B27 +) duration 30 ปี complete cervical fusion ankylosis + thoracic kyphosis 50° (chin-on-chest deformity) ตกหกล้มเตี้ย ๆ ในห้องน้ำ ปวดคอเล็กน้อย
ไม่มี neurologic deficit

PE: severe kyphotic deformity (cannot extend neck), neck pain new-onset, motor + sensory intact bilateral, normal reflexes, no spinal cord level findings

X-ray + CT C-spine: AS classic "bamboo spine", complete autofusion + ossification of anterior + posterior longitudinal ligaments + ligamentum flavum + facet joint fusion; **C5-C6 transverse fracture through ankylosed segment crossing all 3 columns** (highly unstable despite minor trauma)
MRI C-spine: subtle cord edema at fracture level, no cord compression yet', '[{"label":"A","text":"Cervical collar only no imaging"},{"label":"B","text":"Cervical Fracture in Ankylosing Spondylitis — \"3-Column Fracture Despite Minor Trauma\" — Highly Unstable"},{"label":"C","text":"Force neck into neutral position"},{"label":"D","text":"Aggressive traction immediately"},{"label":"E","text":"Discharge with cervical collar without imaging"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cervical Fracture in Ankylosing Spondylitis — "3-Column Fracture Despite Minor Trauma" — Highly Unstable: (1) **MRI mandatory** in any AS patient with new neck pain after even trivial trauma — fractures highly unstable + frequently missed initially (50%); (2) **immediate strict immobilization** — collar in pre-injury chin-on-chest position (DO NOT force into neutral — can cause neurologic injury — splint in deformed position with sandbags/towels); (3) **DO NOT use traction except in carefully controlled OR setting** — fractures in AS span all 3 columns + traction can lead to distraction + neurologic injury; (4) **emergent surgical stabilization** — long-segment posterior instrumentation 2-3 levels above + 2-3 levels below fracture (3+ levels each side for adequate purchase in osteoporotic AS bone) — long construct + good fixation; biomechanically — AS bone is osteoporotic + long lever arms above/below fracture; (5) MRI to assess cord edema + epidural hematoma (much higher risk in AS — bleeding into rigid spine) — surgical decompression if needed; (6) **screen for additional fractures** — full neuroaxis CT/MRI (multiple fractures common — particularly thoracolumbar); (7) **avoid extension force** during transport + intubation (awake fiberoptic intubation preferred); (8) AS patient — predispose to high mortality (30%) post-trauma — careful management; complications: epidural hematoma, neurologic deterioration, pseudarthrosis, fixation failure; (9) DVT prophylaxis; (10) long-term — TNF inhibitors for AS optimization; bone health (vitamin D, bisphosphonate); fall prevention; (11) **chin-on-chest deformity correction** considered separately later in elective settings (pedicle subtraction osteotomy — PSO)

---

AS cervical fracture: highly unstable 3-column injury from minor trauma. MRI mandatory (50% initially missed). Immobilize in PRE-INJURY position (don''t force neutral — can cause neuro injury). AVOID traction. Long-segment posterior instrumentation (3+ levels each side). MRI for epidural hematoma (common). Full neuroaxis imaging (multiple fractures). Awake fiberoptic intubation. High mortality (30%). Long-term: TNF, bone health, fall prevention.', NULL,
  'hard', 'trauma', 'review',
  'orthopedics', 'clinical_decision', 'trauma', 'adult',
  'AOSpine; AS Spine Fracture', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 65 ปี Ankylosing Spondylitis (HLA-B27 +) duration 30 ปี complete cervical fusion ankylosis + thoracic kyphosis 50° (chin-on-chest deformity) ตกหกล้มเตี้ย ๆ ในห้องน้ำ ปวดคอเล็กน้อย
ไม่มี neurologic deficit

PE: severe kyphotic deformity (cannot extend neck), neck pain new-onset, motor + sensory intact bilateral, normal reflexes, no spinal cord level findings

X-ray + CT C-spine: AS classic "bamboo spine", complete autofusion + ossification of anterior + posterior longitudinal ligaments + ligamentum flavum + facet joint fusion; **C5-C6 transverse fracture through ankylosed segment crossing all 3 columns** (highly unstable despite minor trauma)
MRI C-spine: subtle cord edema at fracture level, no cord compression yet'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 75 ปี ปวด + บวม + warm ข้อเข่าซ้าย acute 1 วัน, ไม่มี trauma, no fever
PMHx: hyperparathyroidism, recent UTI

V/S: T 37.6°C
PE: knee effusion + tender + warm, no other joints, no skin source

Lab: WBC 11,000, CRP 60, uric acid 6.5 (within normal), Ca 11.0 (mildly elevated)

Knee aspiration: WBC 18,000 (PMN 75%), polarized light — **positively birefringent rhomboid-shaped crystals** (CPPD/calcium pyrophosphate dihydrate) — pseudogout confirmed
Gram stain + culture negative

X-ray knee: chondrocalcinosis (linear calcification meniscus + hyaline cartilage) bilateral', '[{"label":"A","text":"Allopurinol urate-lowering therapy"},{"label":"B","text":"Acute CPPD (Pseudogout) Arthritis Elderly"},{"label":"C","text":"Antibiotic IV without aspiration"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Long-term opioid"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute CPPD (Pseudogout) Arthritis Elderly: (1) **joint aspiration mandatory** to confirm CPPD (positively birefringent rhomboid crystals) + rule out septic; concurrent septic arthritis common in elderly; (2) **acute attack treatment**: (a) **NSAIDs** if no contraindication; (b) **colchicine** (acute + prophylaxis); (c) **intra-articular corticosteroid** — excellent for monoarthritis after septic ruled out — first-line in elderly with comorbidities; (d) oral steroid alternative for polyarticular; (e) IL-1 antagonist (anakinra) for refractory; (3) **no urate-lowering therapy** (CPPD not urate); (4) **prophylaxis for recurrent attacks**: low-dose colchicine 0.5-0.6 mg daily; (5) **screen secondary causes** — "H''s" — Hyperparathyroidism, Hemochromatosis, Hypomagnesemia, Hypophosphatasia, Hypothyroidism, Wilson disease (rare); workup: Ca, Mg, Phosphate, TSH, ferritin, parathyroid hormone, alkaline phosphatase; (6) **address comorbidity** — primary hyperparathyroidism in this patient → endocrinology workup + parathyroidectomy if indicated (improves CPPD); (7) **chronic CPPD arthropathy** (pseudo-OA, pseudo-RA pattern) — managed as OA + symptomatic + intra-articular treatment; (8) **X-ray chondrocalcinosis** characteristic finding (linear calcification cartilage); (9) **education** patient + family + multidisciplinary geriatric care

---

CPPD (pseudogout): positively birefringent rhomboid crystals. Aspiration confirms + rules out septic (concurrent common). Acute Rx: NSAID, colchicine, INTRA-ARTICULAR STEROID (preferred in elderly comorbidity), IL-1 antag for refractory. Screen secondary causes ("H''s" — HPT, hemochromatosis, hypoMg, hypothyroid). Parathyroidectomy may help. Chondrocalcinosis on X-ray. Multidisciplinary geriatric care.', NULL,
  'medium', 'rheumatology', 'review',
  'orthopedics', 'clinical_decision', 'rheumatology', 'adult',
  'EULAR CPPD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'หญิงไทยอายุ 75 ปี ปวด + บวม + warm ข้อเข่าซ้าย acute 1 วัน, ไม่มี trauma, no fever
PMHx: hyperparathyroidism, recent UTI

V/S: T 37.6°C
PE: knee effusion + tender + warm, no other joints, no skin source

Lab: WBC 11,000, CRP 60, uric acid 6.5 (within normal), Ca 11.0 (mildly elevated)

Knee aspiration: WBC 18,000 (PMN 75%), polarized light — **positively birefringent rhomboid-shaped crystals** (CPPD/calcium pyrophosphate dihydrate) — pseudogout confirmed
Gram stain + culture negative

X-ray knee: chondrocalcinosis (linear calcification meniscus + hyaline cartilage) bilateral'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 52 ปี DM2 (HbA1c 8.5%) ปวด + ขยับไหล่ขวาลำบาก 6 เดือน ปวดมากตอนกลางคืน + ค่อย ๆ stiff ขึ้นเรื่อย ๆ, ไม่มี trauma

PE: global limitation ROM both active + passive (active = passive — characteristic of capsular pattern frozen shoulder); external rotation < 30°, abduction < 90°, internal rotation to L1 only; mild tenderness; no clear weakness when isolated

MRI shoulder: thickened glenohumeral joint capsule + axillary recess obliteration + coracohumeral ligament thickening — adhesive capsulitis, no rotator cuff tear', '[{"label":"A","text":"Aggressive PT in painful phase"},{"label":"B","text":"Adhesive Capsulitis (Frozen Shoulder) in DM — Phase-Specific Management"},{"label":"C","text":"Total shoulder arthroplasty"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Long-term opioid"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adhesive Capsulitis (Frozen Shoulder) in DM — Phase-Specific Management: (1) **natural history** — 3 phases: (a) painful/freezing (6 wk - 9 mo) — pain dominant, ROM declining; (b) frozen/adhesive (4-12 mo) — stiff with less pain; (c) thawing (5-26 mo) — gradual recovery of ROM; total course 1-3 years; (2) **patient education + reassurance** about natural history; (3) **conservative management** first-line: (a) **NSAIDs** for pain; (b) **physiotherapy** — gentle ROM + stretching within pain tolerance; aggressive PT during painful phase may worsen — counterintuitive; (c) **intra-articular corticosteroid injection** (glenohumeral, US-guided) — evidence supports moderate short-medium term benefit + may accelerate recovery especially in painful phase; (d) **hydrodilatation** (capsular distension with saline + steroid under fluoroscopy) — moderate evidence in frozen phase; (e) home exercise (Codman pendulum, wall walking, towel stretches); (4) **diabetes optimization** — DM is major risk factor + worse outcomes (HbA1c control); (5) **interventional treatment** for severe refractory: (a) **manipulation under anesthesia (MUA)** — useful but capsular rupture risk + complications; (b) **arthroscopic capsular release** — modern preferred, releases rotator interval + anterior capsule + axillary recess + posterior capsule selectively, immediate ROM gain — for refractory > 6-12 months; (6) **avoid prolonged immobilization** (worsens stiffness); (7) **screen comorbidities** — DM, thyroid (hypo + hyper), Dupuytren, CV disease; (8) **counseling** — long course, function generally returns over 1-3 years even without surgery

---

Adhesive capsulitis (frozen shoulder): self-limited natural history 1-3 years (3 phases — painful, frozen, thawing). DM major risk + worse outcomes. Conservative: NSAIDs + gentle PT + glenohumeral steroid injection + hydrodilatation. AVOID aggressive PT in painful phase. MUA + arthroscopic capsular release for severe refractory. Optimize DM + screen thyroid + Dupuytren. Educate on natural history.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'orthopedics', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAOS Adhesive Capsulitis', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'หญิงไทยอายุ 52 ปี DM2 (HbA1c 8.5%) ปวด + ขยับไหล่ขวาลำบาก 6 เดือน ปวดมากตอนกลางคืน + ค่อย ๆ stiff ขึ้นเรื่อย ๆ, ไม่มี trauma

PE: global limitation ROM both active + passive (active = passive — characteristic of capsular pattern frozen shoulder); external rotation < 30°, abduction < 90°, internal rotation to L1 only; mild tenderness; no clear weakness when isolated

MRI shoulder: thickened glenohumeral joint capsule + axillary recess obliteration + coracohumeral ligament thickening — adhesive capsulitis, no rotator cuff tear'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 62 ปี ปวดคอ + ค่อย ๆ มี gait imbalance + clumsy hands 1 ปี + numbness ปลายมือ
ไม่มี trauma

PE: hyperreflexia + Hoffmann''s + Babinski + wide-based gait + decreased fine motor — myelopathy signs

X-ray + CT C-spine: **ossification of posterior longitudinal ligament (OPLL)** — dense ossified band along posterior vertebral body C3 to C6, severe canal stenosis 50%, no instability; continuous type (vs segmental, mixed, localized)
MRI: cord compression + signal change C4-C5

Dx: OPLL — cervical myelopathy (more common in Asian — ~ 2-3% Japan/Korea/Thailand)', '[{"label":"A","text":"Conservative observation always"},{"label":"B","text":"OPLL with Cervical Myelopathy — Surgical Decompression"},{"label":"C","text":"Cervical traction long term home"},{"label":"D","text":"Discharge no follow-up"},{"label":"E","text":"Lumbar laminectomy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** OPLL with Cervical Myelopathy — Surgical Decompression: (1) **OPLL** more common in East Asian populations (2-3% — Japanese, Korean, Thai, Chinese); types: continuous, segmental, mixed, localized; associated with DISH (diffuse idiopathic skeletal hyperostosis), ankylosing spondylitis, hypoparathyroidism; (2) **AOSpine CSM guidelines** — moderate-severe myelopathy → surgical decompression preferred to prevent progression; (3) **surgical approach** depends on: extent of OPLL, K-line (line from anterior C2 to anterior C7 — if OPLL crosses K-line → anterior decompression preferred), cervical alignment (lordosis vs kyphosis), number of levels: (a) **anterior cervical corpectomy + reconstruction (ACCF) + fusion** — for OPLL crossing K-line, kyphotic alignment, focal compression; technically demanding (dural tear risk — OPLL may be adherent to dura), CSF leak; (b) **posterior approach (laminectomy + fusion or laminoplasty)** — preferred for: multilevel (≥ 3), preserved lordosis, OPLL not crossing K-line, lower complication rate vs anterior; (c) **combined approach** for severe; (4) **laminoplasty** — motion-preserving open-door laminoplasty popular in Asia for multilevel OPLL with preserved lordosis — comparable outcomes vs fusion with less morbidity; (5) **complications**: C5 nerve palsy (post-op, 5-10%), CSF leak (anterior), dural tear, recurrence/progression of OPLL after posterior surgery; (6) **OPLL is progressive disease** — continues to ossify; follow long-term; (7) **screen DISH + endocrinopathy** if extensive; (8) post-op: rehab, gradual return; (9) outcomes — modest improvement (don''t promise return to normal)

---

OPLL: Asian-prevalent ossified PLL → cervical myelopathy. Surgical decompression for moderate-severe (AOSpine). K-line guides approach (OPLL crossing K-line → anterior corpectomy preferred). Posterior (laminoplasty or laminectomy + fusion) for multilevel + preserved lordosis. Anterior risk of dural tear (OPLL adherent). C5 palsy post-op risk. Progressive disease — long-term follow-up. Screen DISH, endocrinopathy.', NULL,
  'hard', 'neurology', 'review',
  'orthopedics', 'clinical_decision', 'neurology', 'adult',
  'AOSpine; Japan OPLL Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = 'ชายไทยอายุ 62 ปี ปวดคอ + ค่อย ๆ มี gait imbalance + clumsy hands 1 ปี + numbness ปลายมือ
ไม่มี trauma

PE: hyperreflexia + Hoffmann''s + Babinski + wide-based gait + decreased fine motor — myelopathy signs

X-ray + CT C-spine: **ossification of posterior longitudinal ligament (OPLL)** — dense ossified band along posterior vertebral body C3 to C6, severe canal stenosis 50%, no instability; continuous type (vs segmental, mixed, localized)
MRI: cord compression + signal change C4-C5

Dx: OPLL — cervical myelopathy (more common in Asian — ~ 2-3% Japan/Korea/Thailand)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

คำถามเกี่ยวกับ bone biology + Wolff''s Law:

**Wolff''s law (formulated by Julius Wolff 1892)** อธิบายปรากฏการณ์อะไรในกระดูก?

สภาพแวดล้อม: เด็กชายอายุ 14 ปี แขนซ้าย immobilized ใน cast 8 weeks หลัง forearm fracture
หลัง remove cast: forearm bone density ลดลง + cortical thickness ลดลง compared to contralateral', '[{"label":"A","text":"Bone grows in length only via physis"},{"label":"B","text":"remodels in response to mechanical stress"},{"label":"C","text":"Bone never remodels after maturity"},{"label":"D","text":"All bone is dead tissue"},{"label":"E","text":"Bone density only genetic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Wolff''s Law: "Bone in a healthy person or animal will adapt to the loads under which it is placed." Bone is dynamic tissue that **remodels in response to mechanical stress** — increased stress → increased bone density + cortical thickness (hypertrophy); decreased stress (immobilization, microgravity, paralysis) → decreased bone density + cortical thinning (atrophy/osteopenia); (1) **mechanotransduction** — osteocytes (terminally differentiated osteoblasts buried in lacunae + canalicular network) act as primary mechanosensors detecting fluid flow + strain → signaling via Wnt/β-catenin (sclerostin downregulation → bone formation), RANKL/OPG axis, nitric oxide, prostaglandins; (2) **clinical applications**: (a) disuse osteopenia post-immobilization (this patient), (b) astronauts in microgravity lose 1-2%/month BMD, (c) athletes — tennis player dominant arm has higher BMD, (d) **mechanical loading therapy** for osteoporosis (weight-bearing exercise, resistance training, vibration therapy), (e) implant design (stress shielding under rigid prosthesis → bone resorption — common around femoral stems), (f) bone remodeling around osteotomies + fractures (callus formation under stress), (g) **distraction osteogenesis** (Ilizarov — gradual distraction stimulates new bone formation along tension), (h) **bone tunnel widening** post-ACL reconstruction (mechanical stress), (i) Sigmund Frost''s law (related) — chronic damaging strain causes maladaptive change; (3) **Davis'' Law** parallel for soft tissue — "soft tissue remodels along lines of stress" (tendon, ligament, fascia)

---

Wolff''s Law: bone remodels per mechanical stress. Osteocytes are mechanosensors (Wnt/β-catenin, RANKL, NO, PGE). Clinical applications: disuse osteopenia, astronaut bone loss, athlete sport-side hypertrophy, stress shielding around implants, distraction osteogenesis (Ilizarov), exercise for osteoporosis. Davis'' law analogous for soft tissue. Foundation principle in orthopedics.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'orthopedics', 'basic_science', 'msk_nontrauma', 'adult',
  'Wolff 1892; Modern Bone Biology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

คำถามเกี่ยวกับ bone biology + Wolff''s Law:

**Wolff''s law (formulated by Julius Wolff 1892)** อธิบายปรากฏการณ์อะไรในกระดูก?

สภาพแวดล้อม: เด็กชายอายุ 14 ปี แขนซ้าย immobilized ใน cast 8 weeks หลัง forearm fracture
หลัง remove cast: forearm bone density ลดลง + cortical thickness ลดลง compared to contralateral'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

Fracture healing: รูปแบบ healing แตกต่างกันใน scenarios ต่อไปนี้:

A) Lag screw fixation of oblique tibial fracture with anatomic reduction + interfragmentary compression (gap < 100 μm)
B) Intramedullary nailing of midshaft femoral fracture with motion at fracture site (gap 1-3 mm)

จงอธิบายความแตกต่างของ fracture healing mechanism + biology', '[{"label":"A","text":"All fractures heal the same way"},{"label":"B","text":"Fracture Healing Mechanisms — Primary vs Secondary Bone Healing"},{"label":"C","text":"Primary healing has more callus than secondary"},{"label":"D","text":"Secondary healing is faster than primary"},{"label":"E","text":"Cartilage callus does not exist"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Fracture Healing Mechanisms — Primary vs Secondary Bone Healing: (1) **Primary (direct) bone healing** — occurs only with **anatomic reduction + rigid fixation + minimal gap (< 100-300 μm) + minimal interfragmentary motion**: (a) **contact healing** — direct cortical reconstruction via cutting cones (osteoclasts at front + osteoblasts behind laying down osteons in haversian remodeling); requires gap < 0.01 mm; (b) **gap healing** — gap 100-300 μm — fills with lamellar bone perpendicular to long axis → secondary remodeling into normal cortical bone; (c) **no visible callus** on X-ray; (d) **slow process** (months-years for complete remodeling); (e) examples: lag screw fixation, plate fixation with compression, ORIF; (2) **Secondary (indirect/endochondral) bone healing** — physiologic healing with some motion + larger gap: 4 stages: (a) **hematoma + inflammation** (days 1-7): fracture hematoma rich in growth factors (BMP, TGF-β, PDGF, FGF), inflammatory response; (b) **soft callus** (days 7-21): chondroblasts → cartilaginous callus (endochondral pathway recapitulating embryonic bone formation) + intramembranous formation peripherally; (c) **hard callus** (3-12 weeks): cartilaginous callus mineralizes + replaces with woven bone via endochondral ossification; (d) **remodeling** (months-years): woven bone → lamellar bone, Wolff''s law re-shapes; (e) **visible callus** on X-ray; (f) **examples**: cast, IM nail, external fixator, bridging plate; (3) **clinical correlation**: AO principles — absolute stability for primary healing (articular surfaces) vs relative stability for secondary healing (diaphyseal — bridging callus = strong stable construct); (4) **BMP-2, BMP-7** clinical use in non-unions; (5) **factors** affecting healing: blood supply, mechanical stability, gap size, age, nutrition, smoking, NSAIDs (controversial), diabetes, infection

---

Fracture healing: primary (direct) — anatomic reduction + rigid fixation + minimal gap/motion → cutting cones, no callus (lag screw, plate compression). Secondary (indirect, endochondral) — some motion + gap → 4 stages: hematoma → soft callus → hard callus → remodeling, with visible callus (cast, IM nail, ex-fix, bridging plate). AO principles: absolute stability for articular, relative stability for diaphysis. BMP-2/7 for non-unions.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'basic_science', 'msk_nontrauma', 'adult',
  'AO Foundation; Perren''s Strain Theory', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

Fracture healing: รูปแบบ healing แตกต่างกันใน scenarios ต่อไปนี้:

A) Lag screw fixation of oblique tibial fracture with anatomic reduction + interfragmentary compression (gap < 100 μm)
B) Intramedullary nailing of midshaft femoral fracture with motion at fracture site (gap 1-3 mm)

จงอธิบายความแตกต่างของ fracture healing mechanism + biology'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

คำถามเกี่ยวกับ **articular cartilage** anatomy + function + healing:

Articular cartilage มีโครงสร้างพิเศษ + ทำไม cartilage damage ถึง heal ยากเป็นพิเศษ + อะไรคือ implications สำหรับ cartilage restoration?', '[{"label":"A","text":"Articular cartilage heals well after injury"},{"label":"B","text":"Articular Cartilage Anatomy + Physiology + Healing Limitations"},{"label":"C","text":"Cartilage has rich vascular supply"},{"label":"D","text":"Fibrocartilage is superior to hyaline cartilage"},{"label":"E","text":"Chondrocytes have unlimited reproductive capacity"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Articular Cartilage Anatomy + Physiology + Healing Limitations: (1) **Hyaline articular cartilage** — covers synovial joint surfaces; aneural + alymphatic + avascular (nutrition from synovial fluid via diffusion + cyclic loading — "sponge effect"); (2) **composition**: ~ 70% water, 20% type II collagen (provides tensile strength), 5% proteoglycans (mainly aggrecan with GAG side chains — chondroitin + keratan sulfate — provide compressive strength via hydration), chondrocytes (~ 1-5% by volume, only cell type — produces + maintains ECM); (3) **zonal architecture**: (a) **superficial (tangential) zone** — flat chondrocytes parallel to surface, collagen parallel — wear resistance; (b) **middle (transitional) zone** — rounded chondrocytes, oblique collagen — compression resistance; (c) **deep (radial) zone** — perpendicular columns of chondrocytes + collagen — load transfer to bone; (d) **calcified cartilage** — between cartilage + subchondral bone, separated by **tidemark**; (e) **subchondral bone** — provides nutrition + mechanical support; (4) **healing limitations** — major problem in cartilage injury: (a) **avascular** — no blood supply → no inflammatory response → no influx of progenitor cells, (b) **chondrocyte limited reproductive capacity** + cannot migrate to defects, (c) **isolated lacunae** — cells cannot communicate or migrate; (5) **partial-thickness defects** (chondral only — superficial to tidemark) — DO NOT heal; (6) **full-thickness defects** (chondral + subchondral) — partial healing via marrow-derived mesenchymal stem cells but forms **fibrocartilage** (type I collagen, biomechanically inferior to hyaline) — degrades over time; (7) **clinical correlations + cartilage restoration techniques** (size + location + age dependent): (a) **microfracture/abrasion arthroplasty** — small defects < 2 cm² — bone marrow stimulation → fibrocartilage fill; (b) **OATS (osteochondral autograft transfer)** / mosaicplasty — moderate defects 2-4 cm² from less weight-bearing area; (c) **OCA (osteochondral allograft)** — large defects > 4 cm²; (d) **ACI/MACI (autologous chondrocyte implantation/matrix-assisted)** — moderate-large defects; (e) **PRP, BMAC** adjuncts; (f) **scaffolds** emerging; (g) **gene therapy** + cell therapy investigational; (8) cartilage damage often progresses to OA — early intervention key

---

Articular cartilage: avascular, aneural, alymphatic. Type II collagen + proteoglycans + chondrocytes + 70% water. Zonal architecture (superficial → middle → deep → calcified → subchondral). Partial-thickness defects DO NOT heal. Full-thickness — fibrocartilage (inferior). Restoration: microfracture (small), OATS (mod), OCA (large), ACI/MACI (mod-large). Cartilage damage → OA progression. Early intervention.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'basic_science', 'msk_nontrauma', 'adult',
  'Modern Cartilage Biology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

คำถามเกี่ยวกับ **articular cartilage** anatomy + function + healing:

Articular cartilage มีโครงสร้างพิเศษ + ทำไม cartilage damage ถึง heal ยากเป็นพิเศษ + อะไรคือ implications สำหรับ cartilage restoration?'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

**Meniscus** ของเข่า มี **blood supply zones** ต่างกัน which directly affects healing potential + surgical decision-making

จงอธิบาย meniscus blood supply zones + clinical implications สำหรับ tears + repair', '[{"label":"A","text":"All meniscus tears heal equally"},{"label":"B","text":"Meniscus Anatomy + Vascular Zones + Healing"},{"label":"C","text":"Inner meniscus has best blood supply"},{"label":"D","text":"Meniscus is purely structural with no function"},{"label":"E","text":"Meniscectomy improves joint biomechanics"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Meniscus Anatomy + Vascular Zones + Healing: (1) **Meniscus structure**: semilunar fibrocartilaginous discs between femoral condyles + tibial plateau (medial — C-shape; lateral — O-shape with discoid variant), composed of type I collagen + small amount type II + proteoglycans + meniscal cells (fibrochondrocytes); (2) **Functions**: (a) load distribution (50-70% of axial load transmitted in extension, up to 85% in flexion through menisci), (b) shock absorption, (c) joint stability (secondary to ligaments, especially medial meniscus posterior horn for AP knee stability), (d) joint lubrication, (e) proprioception; (3) **Vascular supply** — peripheral 20-30% of meniscus only — via geniculate arteries (medial + lateral superior + inferior, middle geniculate posterior); divided into **Arnoczky zones**: (a) **red-red zone** (outer 1/3, peripheral) — vascularized — excellent healing potential; (b) **red-white zone** (middle 1/3) — limited vascularity — moderate healing; (c) **white-white zone** (inner 1/3, central — avascular) — no vascularity — minimal healing; (4) **Clinical implications**: (a) **repairable tears**: vertical/longitudinal, peripheral red-red or red-white zone, acute (< 4-8 weeks), < 4 cm length, with reasonable tissue quality → arthroscopic meniscal repair (inside-out, outside-in, all-inside) to preserve meniscus + prevent PTOA; (b) **partial meniscectomy** for irreparable tears: complex degenerative, white-white zone, severely macerated, > 8 weeks old; (c) **augmentation** for borderline zones: fibrin clot, PRP, marrow venting, synovial rasping → improves healing; (5) **meniscal allograft transplantation** for prior subtotal/total meniscectomy with painful knee + relatively preserved cartilage in younger patient; (6) **meniscectomy associated with early PTOA** (Fairbank changes, increased contact pressure) — preserve meniscus when possible; (7) **bucket-handle tears, root tears, ramp lesions** — specific subtypes with surgical implications (root tear repair restores meniscal function)

---

Meniscus: fibrocartilage shock absorber + load distributor. Vascular zones (Arnoczky): red-red (peripheral, healing OK), red-white (middle, moderate), white-white (central, avascular — no healing). Repairable: peripheral, vertical, acute, < 4 cm. Meniscectomy → early OA → preserve when possible. Meniscal allograft for prior meniscectomy + painful knee. Root tear repair restores function. Augmentation for borderline zones.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'orthopedics', 'basic_science', 'msk_nontrauma', 'adult',
  'Arnoczky Vascular Zones', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

**Meniscus** ของเข่า มี **blood supply zones** ต่างกัน which directly affects healing potential + surgical decision-making

จงอธิบาย meniscus blood supply zones + clinical implications สำหรับ tears + repair'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

**Rotator cuff** anatomy + function — ส่วน core musculoskeletal

จงอธิบาย rotator cuff anatomy (4 muscles, origin/insertion, action, innervation) + functional importance + clinical correlations', '[{"label":"A","text":"Rotator cuff has only 2 muscles"},{"label":"B","text":"Rotator Cuff Anatomy + Function"},{"label":"C","text":"Deltoid is part of rotator cuff"},{"label":"D","text":"Rotator cuff is not innervated"},{"label":"E","text":"All rotator cuff muscles attach to lesser tuberosity"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Rotator Cuff Anatomy + Function: (1) **4 muscles forming dynamic stabilizers + active movers of glenohumeral joint** — mnemonic **"SITS"**: (2) **Supraspinatus**: origin — supraspinous fossa scapula; insertion — superior facet of greater tuberosity humerus; action — initiation of abduction (0-15°), assists overhead elevation; innervation — **suprascapular nerve** (C5, C6); clinical — most commonly injured (rotator cuff tear classic location), Jobe''s empty can test; (3) **Infraspinatus**: origin — infraspinous fossa; insertion — middle facet of greater tuberosity; action — external rotation (primary) + extension; innervation — **suprascapular nerve** (C5, C6); clinical — external rotation lag sign + Hornblower''s; spinoglenoid notch cyst → isolated infraspinatus weakness; (4) **Teres minor**: origin — lateral border scapula; insertion — inferior facet of greater tuberosity; action — external rotation + adduction; innervation — **axillary nerve** (C5, C6); clinical — Hornblower''s sign if isolated weakness; quadrilateral space syndrome; (5) **Subscapularis**: origin — subscapular fossa anterior scapula; insertion — lesser tuberosity humerus; action — internal rotation + adduction; innervation — **upper + lower subscapular nerves** (C5, C6, C7); clinical — belly press, lift-off test, bear hug test for subscapularis pathology; commonly torn in anterior shoulder dislocation; (6) **Function**: (a) **dynamic stabilization** — compresses humeral head into glenoid ("concavity-compression" — provides 60% of glenohumeral stability), (b) coordinate with deltoid for elevation (force couple), (c) initiate abduction (deltoid alone causes superior humeral migration without cuff), (d) rotational movements; (7) **Force couples**: anterior (subscapularis) + posterior (infraspinatus + teres minor) cuff balance; superior (cuff) + inferior (deltoid) balance; (8) **Clinical pearls**: (a) supraspinatus — most commonly injured, JOBE test; (b) **rotator cuff tear pattern progression** — typically begins at "crescent" of supraspinatus near insertion + progresses anteriorly + posteriorly; (c) **rotator interval** — between supraspinatus + subscapularis — contains coracohumeral + superior glenohumeral ligaments + biceps tendon; (d) blood supply tenuous in critical zone ("watershed" hypovascular zone 1 cm proximal to insertion) → degenerative tears origin

---

Rotator cuff: SITS (Supraspinatus, Infraspinatus, Teres minor, Subscapularis). Supra+Infra — suprascapular n; Teres minor — axillary; Subscap — upper/lower subscapular. Functions: dynamic stabilizer (concavity-compression — 60% stability), initiate abduction, rotation, force couples. Critical zone (watershed hypovascular) → degenerative tears. Specific tests for each (Jobe, ER lag, Hornblower, belly press, lift-off, bear hug).', NULL,
  'easy', 'msk_nontrauma', 'review',
  'orthopedics', 'basic_science', 'msk_nontrauma', 'adult',
  'Standard Anatomy; Burkhart Force Couples', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

**Rotator cuff** anatomy + function — ส่วน core musculoskeletal

จงอธิบาย rotator cuff anatomy (4 muscles, origin/insertion, action, innervation) + functional importance + clinical correlations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

**Physis (growth plate)** anatomy + injury classification (Salter-Harris) — สำคัญใน pediatric orthopedics

อธิบาย physis structure + Salter-Harris classification + prognostic implications + growth disturbance', '[{"label":"A","text":"Salter-Harris II has worst prognosis"},{"label":"B","text":"Physis (Growth Plate) Anatomy + Salter-Harris Classification"},{"label":"C","text":"Physis fractures all heal without growth disturbance"},{"label":"D","text":"Type V is the most common"},{"label":"E","text":"Reserve zone is the weakest zone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Physis (Growth Plate) Anatomy + Salter-Harris Classification: (1) **Physis structure** — cartilaginous growth plate between epiphysis + metaphysis in growing bone; responsible for **endochondral ossification** + longitudinal growth; (2) **Zones** (epiphysis → metaphysis): (a) **reserve/resting zone** — stem-cell-like chondrocytes, low metabolic activity, contains BMP-rich matrix; (b) **proliferative zone** — chondrocytes divide + form columns parallel to longitudinal axis; (c) **hypertrophic zone** (3 subzones — maturation, degeneration, calcification) — chondrocytes enlarge + matrix calcifies + chondrocytes apoptose; **weakest zone — fractures typically occur here**; (d) **metaphyseal zone (zone of provisional calcification)** — vascular invasion + osteoblast deposition of woven bone; (3) **Blood supply** — perichondrial ring (Lacroix) + epiphyseal vessels (nourish proliferative + reserve zone — INJURY threatens growth); metaphyseal vessels nourish metaphyseal side; (4) **Salter-Harris Classification of physeal fractures (1963)** — based on fracture pattern + prognostic implications: (a) **Type I** — fracture through physis only (separation) — typically excellent prognosis, usually closed reduction + cast, may be radiologically subtle; (b) **Type II** — fracture through physis + metaphysis (Thurston-Holland fragment) — most common (75%), usually good prognosis with closed reduction; (c) **Type III** — fracture through physis + epiphysis (intra-articular) — requires anatomic reduction (open if needed) to restore articular congruity + prevent growth arrest at fracture site; (d) **Type IV** — fracture through metaphysis + physis + epiphysis (vertical, intra-articular) — anatomic reduction essential (often ORIF) to prevent partial growth arrest ("bone bar" formation); (e) **Type V** — crush injury to physis (rare, often diagnosed retrospectively after growth arrest); WORST prognosis — universal growth arrest; (f) **Type VI** (Rang) — perichondrial ring injury — peripheral growth arrest; (5) **Growth arrest mechanism** — bone bar formation between epiphysis + metaphysis blocking physis → angular deformity or limb-length discrepancy; (6) **Treatment of growth arrest** — physeal bar excision + interposition (fat, methyl methacrylate) for small bars in young children; epiphysiodesis (intentional growth plate closure) of unaffected side to balance length; corrective osteotomy; limb lengthening (Ilizarov); contralateral epiphysiodesis to equalize at maturity; (7) **clinical correlations**: SCFE (slip through hypertrophic zone), DDH late presentation, leg length discrepancy assessment (Multiplier method, Moseley straight-line graph, Paley methods), Greulich-Pyle bone age

---

Physis: cartilaginous growth plate. Zones: reserve → proliferative → hypertrophic (weakest, fractures here) → metaphyseal. Salter-Harris: I (through physis), II (+ metaphysis — most common, good prognosis), III (+ epiphysis, intra-articular — ORIF), IV (metaphysis + physis + epiphysis — ORIF, bar risk), V (crush — worst, growth arrest). Growth arrest → bone bar → angular deformity/LLD. Treatment: bar excision, epiphysiodesis, osteotomy, lengthening.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'basic_science', 'msk_nontrauma', 'peds',
  'Salter-Harris 1963', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

**Physis (growth plate)** anatomy + injury classification (Salter-Harris) — สำคัญใน pediatric orthopedics

อธิบาย physis structure + Salter-Harris classification + prognostic implications + growth disturbance'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

**Bone biology** — cellular components + signaling — สำคัญต่อ osteoporosis treatment

อธิบาย osteoblast + osteoclast + osteocyte function + **RANKL/OPG pathway** + clinical applications (denosumab, bisphosphonates, romosozumab)', '[{"label":"A","text":"Osteoclasts form bone"},{"label":"B","text":"Bone Cellular Biology + RANKL/OPG Pathway"},{"label":"C","text":"Osteocytes do not communicate"},{"label":"D","text":"OPG promotes osteoclast formation"},{"label":"E","text":"Estrogen has no effect on bone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bone Cellular Biology + RANKL/OPG Pathway: (1) **3 main bone cell types**: (a) **osteoblasts** — bone-forming cells, derived from mesenchymal stem cells, produce type I collagen + non-collagenous matrix proteins (osteocalcin, osteopontin, BSP) → osteoid → mineralized; secrete alkaline phosphatase (clinical marker bone formation); regulated by Wnt/β-catenin pathway, BMP, PTH (intermittent — anabolic; continuous — catabolic), Vit D; (b) **osteoclasts** — bone-resorbing multinucleated giant cells, derived from monocyte/macrophage lineage; attach to bone via integrin αvβ3 (sealing zone) + secrete H+ (vacuolar ATPase → dissolves mineral) + cathepsin K (degrades collagen) → resorption pit (Howship''s lacuna); mark of activity — serum CTX, NTX (clinical markers bone resorption); (c) **osteocytes** — terminally differentiated osteoblasts buried in bone lacunae + canalicular network — most abundant bone cell (90-95%) — mechanosensors + secrete sclerostin (inhibitor of bone formation — Wnt/β-catenin antagonist) + FGF-23 (phosphate metabolism); (2) **RANKL/OPG/RANK pathway** — master regulator of osteoclast formation + activity: (a) **RANKL** (Receptor Activator of NF-κB Ligand) — produced by osteoblasts, osteocytes, T-cells; binds RANK receptor on osteoclast precursors → osteoclast differentiation + maturation + survival; (b) **OPG (osteoprotegerin)** — decoy receptor, also produced by osteoblasts, binds RANKL → prevents RANK activation → inhibits osteoclast formation; (c) **RANKL : OPG ratio** determines bone resorption (high ratio → more resorption); (d) **regulators of RANKL/OPG ratio**: PTH (continuous — increases RANKL → resorption); estrogen (increases OPG → protects bone — explains postmenopausal bone loss); glucocorticoid (increases RANKL → bone loss); (3) **Clinical applications — osteoporosis treatments**: (a) **bisphosphonates** (alendronate, zoledronate, risedronate, ibandronate) — inhibit osteoclast activity (interfere with farnesyl pyrophosphate synthase → apoptosis of osteoclasts); anti-resorptive; (b) **denosumab** — monoclonal antibody against RANKL — directly inhibits osteoclast formation; subQ q 6 months; (c) **teriparatide, abaloparatide** — PTH analogs given intermittent — anabolic (bone formation); (d) **romosozumab** — monoclonal antibody against sclerostin → activates Wnt/β-catenin → both anabolic + anti-resorptive; (e) **SERMs** (raloxifene) — estrogen receptor modulator; (f) **calcitonin** — limited use; (4) **adverse effects**: bisphosphonate — osteonecrosis of jaw (ONJ), atypical femur fracture (AFF); denosumab — same + rebound vertebral fractures if stopped without transition; romosozumab — CV concern

---

Bone biology: osteoblasts (form bone, Wnt/BMP), osteoclasts (resorb bone — H+ + cathepsin K), osteocytes (mechanosensors, sclerostin, FGF-23). RANKL/OPG/RANK axis = master regulator of osteoclasts. Osteoporosis Rx: anti-resorptive (bisphosphonate, denosumab — anti-RANKL), anabolic (teriparatide PTH analog, romosozumab — anti-sclerostin/Wnt activator), SERM. ONJ + AFF complications. Denosumab rebound fractures.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'basic_science', 'msk_nontrauma', 'adult',
  'Modern Bone Biology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

**Bone biology** — cellular components + signaling — สำคัญต่อ osteoporosis treatment

อธิบาย osteoblast + osteoclast + osteocyte function + **RANKL/OPG pathway** + clinical applications (denosumab, bisphosphonates, romosozumab)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

**Tendon healing biology** — สำคัญสำหรับ rehabilitation protocols after tendon repair (e.g., Achilles, rotator cuff, flexor tendon)

อธิบาย tendon healing phases + intrinsic vs extrinsic healing + implications สำหรับ early motion vs immobilization', '[{"label":"A","text":"Complete immobilization always best for tendon healing"},{"label":"B","text":"Tendon Healing Biology + Phases"},{"label":"C","text":"Tendons heal within 1 week"},{"label":"D","text":"Type II collagen is dominant in tendons"},{"label":"E","text":"Corticosteroids enhance tendon healing"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Tendon Healing Biology + Phases: (1) **Tendon structure**: highly organized type I collagen (90-95%) in parallel arrangement (tertiary structure — fibril → fibers → fascicles → tendon) + small amount type III + elastin + proteoglycans (decorin) + ground substance + tenocytes (sparse fibroblast-like cells) + endotenon + epitenon + paratenon (vascular layer); (2) **Vascular supply** — tendons are hypovascular relative to other tissues; blood supply from: (a) paratenon (most), (b) mesotendon, (c) bone-tendon junction, (d) musculotendinous junction; some tendons have "watershed" zones — Achilles (2-6 cm above insertion), supraspinatus (1 cm proximal to insertion) — prone to degeneration; (3) **Tendon healing phases** (3 phases, ~ 6+ months total): (a) **inflammatory phase** (days 1-7) — hemorrhage + clot, inflammatory cells (neutrophils → macrophages), growth factors (PDGF, TGF-β, IGF, VEGF); (b) **proliferative phase** (days 5 - 4 weeks) — fibroblast proliferation, type III collagen production (initially), high water content, disorganized; (c) **remodeling phase** (4 weeks - 1+ year) — type III → type I collagen, longitudinal alignment along stress, increased tensile strength, **continues for 6-12 months**; (4) **Intrinsic vs extrinsic healing**: (a) **intrinsic healing** — tenocytes within tendon proliferate + produce collagen → primary tendon healing; preferred mechanism, maintains tendon glide; (b) **extrinsic healing** — fibroblasts from peritendon migrate in → forms scar/adhesions → impairs tendon glide (e.g., flexor tendon zone II adhesions); both occur; balance important; (5) **Mechanical stimulation effects**: (a) **early controlled motion stimulates intrinsic healing** + promotes collagen alignment along stress + reduces adhesions; (b) **complete immobilization** → atrophy + extrinsic healing → adhesions + stiffness; (c) **excessive motion** → rupture + scarring; (6) **Clinical applications**: (a) **flexor tendon repair zone II** — early protected motion (Duran, Kleinert, early active) reduces adhesions; (b) **rotator cuff repair** — protected rehab — sling 4-6 weeks, then progressive ROM, full activity 4-6 months; (c) **Achilles repair** — progressive weight-bearing in boot, accelerated rehab; (d) **patellar tendon** repair — protected early ROM; (7) **factors affecting healing**: blood supply, nutrition (vitamin C, protein, zinc), age, smoking, NSAIDs (debated), corticosteroid (impairs healing — limit injections), DM, hypercholesterolemia (associated with tendinopathy)

---

Tendon healing: type I collagen + hypovascular (watershed zones). 3 phases: inflammatory (1-7 d) → proliferative (5 d - 4 wk) → remodeling (4 wk - 1+ yr). Intrinsic healing (tenocytes — maintains glide) vs extrinsic (peritendon — adhesions). Early controlled motion → intrinsic healing + collagen alignment → BETTER outcomes than complete immobilization. Steroid impairs. Continues 6-12 months. Clinical applications: flexor tendon, rotator cuff, Achilles rehab.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'orthopedics', 'basic_science', 'msk_nontrauma', 'adult',
  'Modern Tendon Healing Biology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

**Tendon healing biology** — สำคัญสำหรับ rehabilitation protocols after tendon repair (e.g., Achilles, rotator cuff, flexor tendon)

อธิบาย tendon healing phases + intrinsic vs extrinsic healing + implications สำหรับ early motion vs immobilization'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

**Spinal cord anatomy + tracts** — สำคัญสำหรับ neurologic exam + SCI assessment

อธิบาย spinal cord tracts (ascending + descending) + lateralization + clinical correlations (incomplete SCI syndromes)', '[{"label":"A","text":"Spinothalamic tract carries vibration sense"},{"label":"B","text":"Spinal Cord Tracts + Clinical Correlations"},{"label":"C","text":"Corticospinal tract crosses in lumbar cord"},{"label":"D","text":"Brown-Sequard has worst prognosis"},{"label":"E","text":"Posterior cord syndrome affects motor function"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Spinal Cord Tracts + Clinical Correlations: (1) **Descending tracts** (motor): (a) **lateral corticospinal tract** — primary voluntary motor — UMN cell bodies in motor cortex → decussate at medullary pyramids → descend in lateral spinal cord → synapse on LMN in anterior horn ipsilateral; controls **ipsilateral** muscles below decussation; injury → ipsilateral UMN signs below level; (b) **anterior corticospinal tract** — minor, axial musculature; (c) extrapyramidal — rubrospinal, vestibulospinal, reticulospinal, tectospinal (modulate posture, tone); (2) **Ascending tracts** (sensory): (a) **dorsal column-medial lemniscus (DCML)** — fine touch + vibration + proprioception + 2-point discrimination; ascends ipsilaterally → decussates in medulla → sensation from **contralateral** side perceived; (b) **lateral spinothalamic tract** — pain + temperature; sensory neurons enter spinal cord → ascend 1-2 levels → cross immediately to opposite side via anterior commissure → ascend in lateral spinothalamic tract → sensation from **contralateral** side; (c) **anterior spinothalamic tract** — crude touch + pressure (less clinically important); (d) **spinocerebellar tracts** — unconscious proprioception to cerebellum; (3) **Incomplete spinal cord syndromes**: (a) **Central cord syndrome** — most common, hyperextension injury in older with cervical stenosis — central gray matter + medial corticospinal damage → **upper extremity weakness > lower extremity weakness** (cervical fibers central, lumbar fibers lateral in corticospinal) + variable sensory; usually good prognosis; (b) **Brown-Sequard syndrome** — cord hemisection (penetrating, lateral disc, tumor) → **ipsilateral motor** (corticospinal) + ipsilateral proprioception/vibration (DCML) + **contralateral pain/temperature** (spinothalamic crossed) — best prognosis of incomplete; (c) **Anterior cord syndrome** — anterior 2/3 cord (vascular — anterior spinal artery, hyperflexion) — bilateral motor + bilateral pain/temperature loss + preserved proprioception/vibration (DCML — posterior); poor prognosis; (d) **Posterior cord syndrome** — rare, dorsal column injury (vitamin B12, syphilis, MS) — loss of proprioception + vibration + fine touch, preserved motor + pain/temp; (e) **Conus medullaris syndrome** (T12-L1 level) — mixed UMN + LMN, perianal/saddle anesthesia, bladder/bowel dysfunction, variable LE weakness; (f) **Cauda equina syndrome** — below L2 — pure LMN (peripheral nerve), saddle anesthesia, bladder/bowel — surgical emergency; (4) **ASIA assessment** — standardized neurologic exam for SCI

---

Spinal cord tracts: lateral corticospinal (descending motor — ipsilateral below decussation), DCML (ascending — fine touch/vibration/proprio — ipsilateral until medulla, then contralateral perception), spinothalamic (pain/temperature — crosses immediately, contralateral perception). Incomplete SCI syndromes: central (UE > LE, elderly hyperextension), Brown-Sequard (hemisection — best prognosis), anterior (motor + pain — worst), posterior cord, conus medullaris, cauda equina (surgical). ASIA assessment.', NULL,
  'hard', 'neurology', 'review',
  'orthopedics', 'basic_science', 'neurology', 'adult',
  'ASIA; Modern Spinal Cord Anatomy', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

**Spinal cord anatomy + tracts** — สำคัญสำหรับ neurologic exam + SCI assessment

อธิบาย spinal cord tracts (ascending + descending) + lateralization + clinical correlations (incomplete SCI syndromes)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, '**Basic Science**

**Synovial joint anatomy + physiology** + synovial fluid analysis (foundation for joint pathology including arthritis, infection, crystal disease)

อธิบาย synovial joint structure + synovial fluid normal vs pathologic analysis', '[{"label":"A","text":"Synovium lines articular cartilage"},{"label":"B","text":"Synovial Joint Anatomy + Synovial Fluid"},{"label":"C","text":"Cartilage has rich blood supply via synovium"},{"label":"D","text":"Synovial fluid does not participate in cartilage nutrition"},{"label":"E","text":"Septic arthritis has WBC < 200"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Synovial Joint Anatomy + Synovial Fluid: (1) **Synovial joint components**: (a) **articular cartilage** — hyaline cartilage covering bony ends (avascular, aneural, alymphatic; type II collagen + proteoglycans); (b) **subchondral bone** — provides nutrition + support; (c) **joint capsule** — fibrous outer + synovial inner; (d) **synovium (synovial membrane)** — lines joint capsule (NOT cartilage), composed of: (i) synoviocytes type A (macrophage-like — phagocytosis) + type B (fibroblast-like — produce hyaluronic acid + lubricin); (e) **synovial fluid** — viscous filtrate of plasma + locally produced HA + lubricin; (f) **ligaments** (extrinsic + intrinsic — intra-capsular vs extra-capsular); (g) **tendons** crossing joint; (h) **menisci/labra/discs** (in specific joints — knee, shoulder, hip, TMJ); (i) **bursae** — reduce friction; (j) **neurovascular supply** — vascular ring (capsule + synovium — NOT cartilage), sensory innervation (Hilton''s law — innervated by nerves crossing joint); (2) **Synovial fluid functions**: lubrication (boundary by lubricin + hydrodynamic by HA), nutrition (delivers nutrients to cartilage via diffusion + cyclic loading), shock absorption, clearance of waste products; (3) **Joint nutrition** — "sponge effect" — cyclic loading + unloading drives fluid in + out of cartilage matrix → delivers nutrients (glucose, O2) + removes waste; immobilization → impaired cartilage nutrition → degeneration; (4) **Synovial fluid analysis** — diagnostic for joint pathology: (a) **normal** — clear, viscous ("string sign"), WBC < 200/μL (< 25% PMN), normal glucose, no crystals, sterile; (b) **non-inflammatory (OA, trauma)** — straw-colored, viscous, WBC 200-2,000 (< 25% PMN), no crystals; (c) **inflammatory (RA, SLE, gout, pseudogout)** — yellow-cloudy, less viscous, WBC 2,000-50,000 (often > 50% PMN), crystals positive for gout/pseudogout, sterile; (d) **septic** — purulent, opaque, low viscosity, **WBC > 50,000 (often > 75% PMN)** (> 100,000 highly suggestive but not absolute), low glucose (consumed by bacteria), Gram stain + culture positive, may have crystals (concurrent); (e) **hemorrhagic (fracture, hemophilia, PVNS, anticoagulant, tumor)** — bloody; (f) **crystals**: monosodium urate (gout — negatively birefringent, needle-shaped), CPPD (pseudogout — positively birefringent, rhomboid), hydroxyapatite (Milwaukee shoulder), cholesterol; (5) **Aspiration technique** — sterile technique, identify landmarks, avoid neurovascular structures; (6) **clinical caveat** — synovial fluid analysis not perfect — concurrent infection + crystal disease possible; always Gram stain + culture if any suspicion of infection

---

Synovial joint: cartilage + subchondral bone + capsule + synovium (type A + B synoviocytes) + synovial fluid (HA + lubricin) + ligaments + tendons + menisci + bursae. Functions: lubrication, cartilage nutrition ("sponge effect" — cyclic loading), shock absorption. Synovial fluid analysis: normal (<200) → non-inflammatory OA (<2K) → inflammatory (2K-50K) → SEPTIC (>50K, often >75% PMN). Crystals (gout negative birefringent needles, CPPD positive rhomboid). Always Gram + culture if infection suspected.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'orthopedics', 'basic_science', 'msk_nontrauma', 'adult',
  'Modern Joint Biology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'ortho_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'orthopedics'
      and q.scenario = '**Basic Science**

**Synovial joint anatomy + physiology** + synovial fluid analysis (foundation for joint pathology including arthritis, infection, crystal disease)

อธิบาย synovial joint structure + synovial fluid normal vs pathologic analysis'
  );

commit;

