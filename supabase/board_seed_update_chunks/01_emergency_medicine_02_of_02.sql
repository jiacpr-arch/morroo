-- ===============================================================
-- UPDATE chunk 2/2: emergency_medicine (5 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"Anion gap = 30, expected PaCO2 = 1.5×6 + 8 = 17 ± 2, delta-delta = (30-12)/(24-6) = 1.0 → pure HAGMA (high anion gap metabolic acidosis), respiratory compensation appropriate"},{"label":"B","text":"Anion gap = 18, expected PaCO2 = 30, delta-delta = 0.3 → mixed HAGMA + NAGMA"},{"label":"C","text":"Anion gap = 30, expected PaCO2 = 30, delta-delta = 2.0 → mixed HAGMA + metabolic alkalosis"},{"label":"D","text":"Anion gap = 12 (normal), respiratory compensation inappropriate"},{"label":"E","text":"Anion gap = 50, ไม่สามารถคำนวณ compensation ได้"}]'::jsonb,
    explanation = 'การวิเคราะห์ acid-base ใน DKA ตามขั้นตอน standard (Henderson-Hasselbalch + Winter''s): Step 1: ระบุ primary disorder — pH 7.06 (low) + HCO3 6 (low) = metabolic acidosis Step 2: คำนวณ anion gap = Na - (Cl + HCO3) = 132 - (96 + 6) = 30 (สูง normal 12 ± 2) Step 3: Winter''s formula (expected respiratory compensation ของ metabolic acidosis): expected PaCO2 = (1.5 × HCO3) + 8 ± 2 = (1.5 × 6) + 8 = 17 ± 2 → actual PaCO2 = 18 → respiratory compensation appropriate Step 4: Delta-delta ratio = ΔAG / ΔHCO3 = (30-12) / (24-6) = 18/18 = 1.0 → pure HAGMA (ถ้า > 2 = HAGMA + metabolic alkalosis; < 1 = HAGMA + NAGMA) สรุป: pure high anion gap metabolic acidosis with appropriate respiratory compensation — ตัวเลือก A ถูก. B ผิดที่ AG. C ผิดที่ delta-delta ratio. D ผิดที่ AG. E ผิดที่ AG'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'ผู้ป่วยเป็น diabetic ketoacidosis (DKA) มา ED ตรวจ ABG (room air): pH 7.06, PaCO2 18, PaO2 102, HCO3 6 mEq/L
Electrolytes: Na 132, Cl 96, K 5.4

คำถาม: ระบุชนิดของ acid-base disorder และการคำนวณ compensation ตาม Winter''s formula — anion gap = ? และ delta-delta ratio = ?';

update public.mcq_questions
set choices = '[{"label":"A","text":"ใช้ lead shielding ที่ thyroid และ gonad"},{"label":"B","text":"ลด tube current (mA) และ kVp + ใช้ pediatric protocols + เพิ่ม pitch + ใช้ iterative reconstruction — เพราะลด \"dose\" ที่ source โดยตรง"},{"label":"C","text":"ใช้ contrast media น้อยลง"},{"label":"D","text":"ทำ CT รวดเร็วกว่าเดิม"},{"label":"E","text":"ให้ผู้ป่วยอั้นหายใจ"}]'::jsonb,
    explanation = 'ALARA ใน CT scan เด็ก — radiation dose reduction techniques ลำดับความสำคัญ (Image Gently campaign, ACR appropriateness criteria): (1) Justification: ใช้ CT เมื่อจำเป็นจริง ๆ (2) Optimization (ลด dose ที่ source): - ลด tube current (mA) — proportional to dose - ลด tube voltage (kVp) — exponential to dose (ลด 120 → 100 kVp = ลด dose ~33%) - Pediatric weight-based protocols — body habitus ต่างจากผู้ใหญ่ - เพิ่ม pitch (table feed/rotation) - Iterative reconstruction algorithms (50-70% dose reduction) - Tube current modulation (auto-mA) (3) Limit scan range (4) Shielding (limited benefit จาก scatter) ตัวเลือก B ครอบคลุม source-level reduction ซึ่งมี impact สูงสุด. A — shielding ช่วย < 5% ของ dose. C ไม่เกี่ยวกับ radiation dose. D — speed ไม่ลด dose. E ลด motion artifact ไม่ใช่ dose'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'Resident ED ถามอาจารย์เรื่อง radiation safety: "ถ้าจะลด radiation exposure ของผู้ป่วยจาก CT scan โดยใช้หลัก ALARA (As Low As Reasonably Achievable) ขั้นตอนใดต่อไปนี้ลด exposure ได้มากที่สุดในผู้ป่วยเด็ก?"';

update public.mcq_questions
set choices = '[{"label":"A","text":"Incident Commander เพียงผู้เดียว"},{"label":"B","text":"Logistics Section Chief — ภายใต้ Incident Commander ใน ICS organization และในเหตุการณ์ multi-jurisdiction ใช้ Unified Command (multiple agencies cooperate as one IC team)"},{"label":"C","text":"Public Information Officer"},{"label":"D","text":"Safety Officer"},{"label":"E","text":"Operations Section Chief"}]'::jsonb,
    explanation = 'Incident Command System (ICS) ตาม NIMS (National Incident Management System) มีโครงสร้าง: 1. Incident Commander (IC) — ผู้บัญชาการสูงสุด รับผิดชอบทุก aspect 2. Command Staff (รายงานตรงต่อ IC): - Public Information Officer (PIO): สื่อสารกับสื่อ - Safety Officer: ความปลอดภัยของทีม - Liaison Officer: ประสานงานหน่วยอื่น 3. General Staff (Section Chiefs): - Operations: ดำเนินการจริง (rescue, triage, treatment) - Planning: รวบรวมข้อมูล วางแผน - **Logistics**: จัดหาทรัพยากร (supplies, food, communications, transport, medical) - Finance/Administration: ค่าใช้จ่าย Unified Command (UC): ใน multi-jurisdictional incident — multiple ICs (representative ของแต่ละ agency) ทำงานร่วมกันเป็นทีม IC เดียว แต่ละคนมี authority ของ agency ตน — ตัวเลือก B ครอบคลุม role + concept. A ผิดเพราะ IC ไม่ได้ทำเองทั้งหมด. C ผิด — PIO ทำ communication. D ผิด — Safety เป็น safety เท่านั้น. E ผิด — Operations ทำ action ไม่ใช่ logistics'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'ในเหตุอุบัติเหตุรถบัสตกจากสะพานมีผู้บาดเจ็บ 23 คน ผู้บัญชาการเหตุการณ์ของหน่วย EMS ตัดสินใจตั้ง Incident Command System (ICS) ตามมาตรฐาน NIMS

คำถาม: ในระบบ ICS ใครเป็นผู้รับผิดชอบในการประสานงานทรัพยากร (logistics, supplies, transport) และทำงานภายใต้ "unified command" ในเหตุการณ์ multi-jurisdiction?';

update public.mcq_questions
set choices = '[{"label":"A","text":"Operative hip fixation ภายใน 24 ชม. โดยไม่สนใจ SDH"},{"label":"B","text":"Multidisciplinary approach"},{"label":"C","text":"Reverse apixaban ด้วย andexanet alfa + immediate surgery"},{"label":"D","text":"Conservative management ทั้ง hip และ SDH — ผู้ป่วยอายุมาก"},{"label":"E","text":"Long-term care facility โดยไม่ผ่าตัด"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multidisciplinary approach: หยุด apixaban + neurosurgery consult สำหรับ SDH (likely conservative monitoring เพราะ thin + asymptomatic) + ortho สำหรับ hip surgery ภายใน 24-48 ชม. + ประเมิน delirium (CAM) + assess polypharmacy + รับ geriatric consult + ป้องกัน complications (DVT prophylaxis, pressure injury, nutrition) + identify cause of fall

---

Geriatric polytrauma + delirium + anticoagulation + functional decline — ต้อง multidisciplinary integrative approach ตาม AGS Beers Criteria + ACS Geriatric Surgery + AAOS Hip Fracture Guidelines: (1) Hip fracture: AAOS 2014 + NICE — operative within 24-48 ชม. ลด mortality (delay > 48 ชม. มี mortality 1.5x) (2) SDH: thin + stable + asymptomatic = conservative + serial CT (NICE neurosurgery referral criteria) (3) Anticoagulation: หยุด apixaban; reversal ด้วย andexanet alfa เฉพาะ active bleeding หรือ urgent surgery (4) Delirium: CAM screen, treat reversible (5) Geriatric consult (co-management lower mortality, length of stay) (6) ป้องกัน complications: VTE prophylaxis (mechanical + chemical after surgery), pressure injury, nutrition (7) Identify fall cause: orthostatic, medication review, vision, environment — ตัวเลือก B ครอบคลุมทุกองค์ประกอบ. A ผิดเพราะละเลย SDH. C ผิด — reversal ไม่ใช่ standard ใน asymptomatic. D ผิด — hip surgery ลด mortality. E ผิดอย่างยิ่ง'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'หญิงไทยอายุ 78 ปี underlying HT, AF on apixaban, mild dementia ถูกพบล้มในห้องน้ำ ไม่ทราบประวัติชัดเจน นำส่งโรงพยาบาล

V/S: BP 102/64, HR 88 (irregular), RR 18, SpO2 96%, Temp 36.4°C, DTX 88
GCS 13 (E3V4M6), pupils 3 mm reactive
Left hip: shortened, externally rotated, painful
ไม่มีบาดแผลที่ศีรษะ

CT brain non-contrast: subtle subdural hematoma 4 mm thick along right frontal convexity, no midline shift
Hip X-ray: displaced intracapsular femoral neck fracture

Lab: Hb 11.2, Plt 165,000, INR 1.1, Cr 1.4, Troponin negative';

update public.mcq_questions
set choices = '[{"label":"A","text":"ให้ orthosis และ refer physiotherapy"},{"label":"B","text":"Screen with 3 Key Questions (fall in past year? feel unsteady? worry about falling?) + assess gait/balance (TUG test) + medication review (Beers criteria) + vitamin D supplementation + vision check + home safety asses..."},{"label":"C","text":"Order DEXA scan ทุกราย"},{"label":"D","text":"Prescribe bisphosphonate"},{"label":"E","text":"Bed rest 2 weeks"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Screen with 3 Key Questions (fall in past year? feel unsteady? worry about falling?) + assess gait/balance (TUG test) + medication review (Beers criteria) + vitamin D supplementation + vision check + home safety assessment + referral pathway to community fall prevention program — ทั้ง medical + functional + environmental

---

CDC STEADI initiative + USPSTF + AGS/BGS fall prevention guidelines: ED-based fall prevention bundle ครอบคลุม 3 domains — biomedical, functional, environmental: 1. **Screen**: 3 Key Questions — (1) fall in past year, (2) unsteady, (3) worry about falling → positive = full assessment 2. **Assess**: - Gait/balance: Timed Up and Go (TUG > 12 sec abnormal) - Strength: chair stand test - Vision: Snellen chart - Cognition: Mini-Cog - Postural hypotension: orthostatic BP 3. **Medication review**: Beers Criteria + STOPP — discontinue/reduce psychotropics, benzodiazepines, anticholinergics 4. **Treat reversible causes**: vitamin D > 30 ng/mL (lower fall rate), cataracts, hearing 5. **Refer**: community exercise program (Tai Chi, Otago — Cochrane evidence), home safety eval (OT), specialty consult ตัวเลือก B ครบครอบคลุม biopsychosocial. A เพียงบางส่วน. C ผิดเป้าหมาย (osteoporosis ≠ fall prevention). D ผิด — bisphosphonate ลด fracture ไม่ลด fall. E ผิดอย่างยิ่ง — bed rest เพิ่ม deconditioning'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'ED physician สนใจปรับปรุงคุณภาพการดูแล elderly fall ที่มาห้องฉุกเฉิน จากข้อมูลพบว่า 30% ของผู้ป่วย ≥ 65 ปี ที่มาด้วย mechanical fall ถูก discharge โดยไม่มีการประเมิน fall risk เพิ่มเติม

คำถาม: ตามแนวทาง CDC STEADI (Stopping Elderly Accidents, Deaths & Injuries) initiative สิ่งใดควรเป็นส่วนของ ED discharge bundle สำหรับ elderly fall?';

commit;
