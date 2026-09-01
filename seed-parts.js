const { createClient } = require("@supabase/supabase-js");

const supabase = createClient(
  "https://knxidnzexqehusndquqg.supabase.co",
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtueGlkbnpleHFlaHVzbmRxdXFnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NDM2OTA3NiwiZXhwIjoyMDg5OTQ1MDc2fQ.t47-1W_kcZL9215ZA9vFEf51sptFWMyUsdHrOCkzPCQ"
);

// ============================================================
// MEQ Part Data for 4 Exams
// ============================================================

const examPartsData = {
  "ไส้ติ่งอักเสบเฉียบพลัน (Acute Appendicitis)": [
    {
      part_number: 1,
      title: "ส่วนที่ 1: การซักประวัติและตรวจร่างกาย",
      scenario:
        "ชายไทย อายุ 25 ปี มาห้องฉุกเฉินด้วยอาการปวดท้องมา 12 ชั่วโมง เริ่มปวดบริเวณรอบสะดือ (periumbilical pain) ก่อน แล้วย้ายมาปวดที่ท้องน้อยขวา (right lower quadrant) คลื่นไส้อาเจียน 2 ครั้ง เบื่ออาหาร ไม่มีท้องเสีย ไม่มีประวัติผ่าตัดช่องท้อง\n\nสัญญาณชีพ: BT 38.2°C, HR 92/min, BP 128/76 mmHg, RR 20/min\n\nตรวจร่างกาย: ท้องน้อยขวากดเจ็บ (RLQ tenderness) มี rebound tenderness, McBurney's point tenderness (+), Rovsing's sign (+), Psoas sign (+)",
      question:
        "จงให้ differential diagnosis 3 อันดับแรก และบอกการตรวจทางห้องปฏิบัติการเบื้องต้นที่ควรส่ง",
      answer:
        "Differential diagnosis:\n1. Acute appendicitis - จากลักษณะ migratory pain จาก periumbilical ไปที่ RLQ, มี classic signs (McBurney's, Rovsing's, Psoas sign positive)\n2. Mesenteric lymphadenitis - พบได้ในผู้ป่วยอายุน้อย อาจมีอาการคล้าย appendicitis\n3. Right ureteral colic - ปวดท้องน้อยขวาได้ แต่มักมี colicky pain และ CVA tenderness\n\nการตรวจทางห้องปฏิบัติการ:\n- CBC: ดู WBC count และ neutrophil predominance\n- Urinalysis: แยก UTI และ ureteral stone\n- CRP: ดูระดับ inflammatory marker\n- Pregnancy test (ถ้าเป็นหญิง): แยก ectopic pregnancy",
      key_points: [
        "Classic migratory pain จาก periumbilical ไป RLQ เป็น hallmark ของ acute appendicitis",
        "Alvarado score ช่วยประเมินความน่าจะเป็นของ appendicitis",
        "ต้องแยก surgical abdomen อื่นๆ เสมอ",
        "Low-grade fever (< 38.5°C) พบบ่อยใน uncomplicated appendicitis",
      ],
      time_minutes: 10,
    },
    {
      part_number: 2,
      title: "ส่วนที่ 2: การแปลผลตรวจทางห้องปฏิบัติการ",
      scenario:
        "ผลตรวจทางห้องปฏิบัติการกลับมา:\n- CBC: WBC 14,500/mm³ (Neutrophil 82%, Lymphocyte 12%)\n- Hb 14.2 g/dL, Hct 42%, Platelet 285,000/mm³\n- CRP 45 mg/L (ปกติ < 5)\n- Urinalysis: ปกติ ไม่พบ RBC, WBC, bacteria\n- BUN 12 mg/dL, Cr 0.9 mg/dL\n- Electrolytes: ปกติ\n\nAlvarado Score ของผู้ป่วย = 8/10",
      question:
        "จงแปลผล lab และบอกว่าควรส่งตรวจ imaging อะไรเพิ่มเติม พร้อมให้เหตุผล",
      answer:
        "การแปลผล lab:\n- Leukocytosis with neutrophil predominance (WBC 14,500 + Neutrophil 82%) บ่งชี้ acute bacterial inflammation\n- CRP สูง (45 mg/L) สนับสนุน acute inflammatory process\n- Urinalysis ปกติ ช่วยแยก UTI และ ureteral stone ออก\n- Alvarado score 8/10 = high probability of appendicitis\n\nImaging ที่ควรส่ง:\n- Ultrasound abdomen (US): เป็น first-line imaging สำหรับ appendicitis\n  - ดู non-compressible appendix diameter > 6 mm\n  - ดู appendicolith, periappendiceal fluid\n  - ข้อดี: ไม่มี radiation, ราคาถูก, ทำได้เร็ว\n- หาก US ไม่ชัดเจน (inconclusive) ควรส่ง CT abdomen with contrast\n  - Sensitivity 94%, Specificity 95% สำหรับ appendicitis\n  - ดู appendix diameter, periappendiceal fat stranding, abscess",
      key_points: [
        "Alvarado score >= 7 มี high probability ของ appendicitis",
        "Ultrasound เป็น first-line imaging (โดยเฉพาะในเด็กและหญิงตั้งครรภ์)",
        "CT abdomen มี sensitivity/specificity สูงกว่า US แต่มี radiation exposure",
        "WBC > 10,000 ร่วมกับ left shift สนับสนุน diagnosis",
      ],
      time_minutes: 10,
    },
    {
      part_number: 3,
      title: "ส่วนที่ 3: การแปลผล Imaging และวางแผนการรักษา",
      scenario:
        'ผล Ultrasound abdomen:\n- พบ non-compressible tubular structure ที่ RLQ ขนาด outer diameter 9 mm (ปกติ < 6 mm)\n- พบ appendicolith ขนาด 5 mm\n- มี periappendiceal fluid collection เล็กน้อย\n- ไม่พบ free fluid ใน pelvis\n- สรุป: "Findings consistent with acute appendicitis"\n\nผู้ป่วยมีอาการปวดมากขึ้น pain score 7/10 ตอนนี้เวลา 22.00 น.',
      question:
        "จงวางแผนการรักษา (preoperative management) และอธิบายเทคนิคการผ่าตัดที่เหมาะสม",
      answer:
        "Preoperative management:\n1. NPO (nothing per oral)\n2. IV fluid resuscitation: NSS หรือ Ringer's lactate เริ่ม 1,000 mL bolus\n3. IV antibiotics:\n   - Ceftriaxone 2 g IV + Metronidazole 500 mg IV (หรือ Piperacillin-Tazobactam 4.5 g IV)\n   - ให้ก่อนผ่าตัดอย่างน้อย 30-60 นาที\n4. Pain management: Morphine 2-4 mg IV PRN หรือ Paracetamol 1 g IV\n5. Informed consent อธิบายผู้ป่วยและญาติ\n6. จองห้องผ่าตัด: semi-emergency (ควรผ่าตัดภายใน 12-24 ชั่วโมง)\n\nเทคนิคการผ่าตัด:\n- Laparoscopic appendectomy เป็น gold standard\n  - ข้อดี: แผลเล็ก, ฟื้นตัวเร็ว, ปวดน้อยกว่า, สามารถสำรวจช่องท้องได้\n  - ใช้ 3-port technique (umbilical 10mm, suprapubic 5mm, LLQ 5mm)\n  - Mesoappendix แบ่งด้วย bipolar/harmonic scalpel\n  - Appendix base ผูกด้วย endoloop หรือ stapler\n- Open appendectomy (McBurney's incision) เป็นทางเลือกถ้าไม่มี laparoscopic equipment",
      key_points: [
        "Appendix diameter > 6 mm บน US ถือว่าผิดปกติ",
        "Preoperative antibiotics ลด surgical site infection",
        "Laparoscopic appendectomy เป็น standard of care ในปัจจุบัน",
        "ควรผ่าตัดภายใน 24 ชั่วโมงหลัง diagnosis เพื่อลดภาวะแทรกซ้อน",
      ],
      time_minutes: 10,
    },
    {
      part_number: 4,
      title: "ส่วนที่ 4: การดูแลระหว่างผ่าตัดและพยาธิวิทยา",
      scenario:
        "ทำ laparoscopic appendectomy สำเร็จ ใช้เวลาผ่าตัด 45 นาที\n\nOperative findings:\n- Appendix บวมแดง (erythematous and edematous) มี fibrinous exudate บนผิว\n- พบ appendicolith ที่ base ของ appendix\n- มี purulent fluid เล็กน้อยรอบ appendix ประมาณ 10 mL\n- ไม่พบ perforation\n- Cecum และ terminal ileum ปกติ\n- ส่ง appendix specimen ไป pathology\n\nPathology report (วันรุ่งขึ้น):\n- Gross: Appendix ยาว 7 cm, ผิวนอก congested, มี fibrinopurulent exudate\n- Microscopy: Transmural neutrophilic infiltration, mucosal ulceration, serosal inflammation\n- Diagnosis: Acute suppurative appendicitis, no perforation, no malignancy",
      question:
        "จงแปลผล pathology และอธิบาย staging ของ appendicitis พร้อมบอกแผนการให้ยาปฏิชีวนะหลังผ่าตัด",
      answer:
        "การแปลผล pathology:\n- Acute suppurative appendicitis = การอักเสบแบบเป็นหนอง ลุกลามทะลุผนังทุกชั้น (transmural)\n- Neutrophilic infiltration ทุกชั้นบ่งชี้ acute inflammation ที่รุนแรง\n- ยังไม่ perforate ถือเป็น uncomplicated appendicitis\n\nStaging ของ appendicitis:\n1. Acute simple (catarrhal): อักเสบเฉพาะ mucosa\n2. Acute suppurative (phlegmonous): อักเสบ transmural มีหนอง - ผู้ป่วยรายนี้\n3. Gangrenous: มี necrosis ของผนัง appendix\n4. Perforated: ผนังทะลุ อาจเกิด peritonitis หรือ abscess\n\nแผนยาปฏิชีวนะหลังผ่าตัด:\n- เนื่องจากเป็น uncomplicated appendicitis (ไม่ perforate, ไม่มี abscess)\n- สามารถหยุด IV antibiotics ภายใน 24 ชั่วโมงหลังผ่าตัด\n- ไม่จำเป็นต้องให้ oral antibiotics ต่อ\n- ถ้าเป็น complicated (perforation/abscess) ต้องให้ IV antibiotics 3-5 วัน แล้วต่อ oral อีก 7-10 วัน",
      key_points: [
        "Transmural inflammation เป็นลักษณะของ suppurative appendicitis",
        "Uncomplicated appendicitis ให้ antibiotics สั้น (24 ชม. หลังผ่าตัด)",
        "Complicated appendicitis ต้องให้ antibiotics นานขึ้น (3-5 วัน IV + oral)",
        "ต้องตรวจ pathology ทุกรายเพื่อแยก carcinoid tumor หรือ malignancy",
      ],
      time_minutes: 10,
    },
    {
      part_number: 5,
      title: "ส่วนที่ 5: ภาวะแทรกซ้อนหลังผ่าตัด",
      scenario:
        "หลังผ่าตัด 3 วัน ผู้ป่วยมีไข้สูงขึ้น BT 38.8°C, HR 100/min\nปวดท้องน้อยขวามากขึ้น มี guarding\nแผลผ่าตัดบริเวณ umbilical port มีบวมแดง มี discharge เล็กน้อย\n\nผลตรวจเพิ่มเติม:\n- CBC: WBC 18,200/mm³ (Neutrophil 85%)\n- CRP 120 mg/L\n- CT abdomen with contrast: พบ fluid collection ขนาด 4 x 3 cm ที่ RLQ with rim enhancement สงสัย postoperative abscess\n- Wound swab culture: pending",
      question:
        "จงวินิจฉัยภาวะแทรกซ้อนที่เกิดขึ้น วางแผนการรักษา และอธิบายวิธีป้องกัน",
      answer:
        "การวินิจฉัย:\n1. Intra-abdominal abscess (postoperative pelvic/RLQ abscess)\n   - CT พบ rim-enhancing fluid collection ที่ RLQ\n2. Surgical site infection (SSI) - port site infection\n   - แผลบวมแดง มี discharge\n\nแผนการรักษา:\n1. Intra-abdominal abscess:\n   - CT-guided percutaneous drainage (ถ้า abscess accessible และ > 3 cm)\n   - ส่ง fluid culture and sensitivity\n   - IV antibiotics: Piperacillin-Tazobactam 4.5 g IV q 6 hrs (หรือ Meropenem ถ้า severe)\n   - ติดตาม drain output, ถ้า < 10 mL/day สามารถ remove drain ได้\n   - Repeat imaging ใน 5-7 วัน\n\n2. Surgical site infection:\n   - เปิดแผล (wound opening) ระบาย discharge\n   - Wound swab culture\n   - Daily wound care with wet-to-dry dressing\n   - อาจต้อง delayed primary closure หรือ secondary intention healing\n\nการป้องกัน:\n- Preoperative antibiotics ให้ถูกเวลา (ภายใน 60 นาทีก่อน incision)\n- Thorough peritoneal lavage ถ้ามี purulent fluid\n- Proper specimen retrieval bag ป้องกัน port site contamination\n- Strict aseptic technique",
      key_points: [
        "Postoperative abscess เป็นภาวะแทรกซ้อนที่พบบ่อยหลัง appendectomy",
        "CT-guided percutaneous drainage เป็น first-line treatment สำหรับ accessible abscess",
        "SSI prevention ด้วย proper antibiotic timing และ aseptic technique",
        "Re-laparoscopy อาจจำเป็นถ้า percutaneous drainage ไม่สำเร็จ",
      ],
      time_minutes: 10,
    },
    {
      part_number: 6,
      title: "ส่วนที่ 6: การวางแผนจำหน่ายและติดตาม",
      scenario:
        "หลังได้รับ CT-guided drainage และ IV antibiotics 5 วัน ผู้ป่วยอาการดีขึ้น\n- ไข้ลง BT 37.0°C มา 48 ชั่วโมง\n- ปวดท้องลดลง pain score 2/10\n- ทานอาหารได้ ถ่ายอุจจาระปกติ\n- Drain output < 5 mL/day (serous fluid)\n- CBC: WBC 8,500/mm³, CRP 15 mg/L (ลดลงจาก 120)\n- แผลที่ umbilical port granulation tissue ดี\n\nWound culture: Escherichia coli sensitive to Amoxicillin-Clavulanate",
      question:
        "จงวางแผนจำหน่ายผู้ป่วย (discharge plan) รวมถึงยาที่ให้กลับบ้าน คำแนะนำ และนัดติดตาม",
      answer:
        "Discharge plan:\n\n1. Drain removal:\n   - Remove drain ก่อนกลับบ้าน (output < 5 mL/day, serous)\n\n2. ยาที่ให้กลับบ้าน:\n   - Amoxicillin-Clavulanate 625 mg PO tid x 7 วัน (ตาม culture sensitivity)\n   - Paracetamol 500 mg PO PRN สำหรับปวด q 6 hrs\n   - ไม่จำเป็นต้องให้ NSAIDs เนื่องจาก pain score ต่ำ\n\n3. คำแนะนำแผลผ่าตัด:\n   - ทำแผลวันเว้นวันด้วย normal saline\n   - แผล laparoscopic ports อาจอาบน้ำได้หลัง 48 ชม. ถ้าไม่มี discharge\n   - แผล umbilical port ที่ยังเปิดอยู่ ทำ wet-to-dry dressing จนปิดเอง\n\n4. การปฏิบัติตัว:\n   - งดยกของหนัก > 5 kg เป็นเวลา 2-4 สัปดาห์\n   - สามารถทำกิจวัตรประจำวันเบาๆ ได้\n   - กลับไปทำงาน (office work) ได้ใน 1-2 สัปดาห์\n   - กลับไปออกกำลังกายหนักได้ใน 4-6 สัปดาห์\n\n5. อาการที่ต้องกลับมาพบแพทย์ทันที:\n   - ไข้สูง > 38.5°C\n   - ปวดท้องรุนแรง\n   - แผลบวมแดง มีหนอง\n   - คลื่นไส้อาเจียนไม่หยุด\n\n6. นัดติดตาม:\n   - 1 สัปดาห์: ตรวจแผล, ดูผล wound healing\n   - 4 สัปดาห์: ประเมิน recovery, ตรวจร่างกาย\n   - ดู final pathology report (ยืนยันไม่มี malignancy)",
      key_points: [
        "Drain removal เมื่อ output < 10 mL/day และเป็น serous fluid",
        "เปลี่ยน IV เป็น oral antibiotics ตาม culture sensitivity",
        "ให้คำแนะนำ warning signs ที่ต้องกลับมาพบแพทย์",
        "Follow-up pathology report สำคัญเพื่อแยก incidental malignancy",
      ],
      time_minutes: 10,
    },
  ],

  "กระดูกต้นขาหัก (Femoral Shaft Fracture)": [
    {
      part_number: 1,
      title: "ส่วนที่ 1: การประเมินเบื้องต้นและ Primary Survey",
      scenario:
        "ชายไทย อายุ 30 ปี ถูกรถจักรยานยนต์ชนขณะข้ามถนน ถูกนำส่งห้องฉุกเฉินโดยรถพยาบาล มีการใส่ splint ขาขวาเบื้องต้นมาจากที่เกิดเหตุ\n\nPrimary survey:\n- Airway: patent, พูดได้ชัดเจน, c-spine protected\n- Breathing: RR 24/min, SpO2 98% room air, lung clear bilateral\n- Circulation: HR 110/min, BP 100/68 mmHg, skin pale and cool, capillary refill 3 seconds\n- Disability: GCS 15 (E4V5M6), pupils equal and reactive\n- Exposure: ขาขวาบวมผิดรูป (deformity) ที่ต้นขา, มี shortening ประมาณ 3 cm, มีรอยฟกช้ำบริเวณต้นขาด้านนอก ไม่มี open wound\n\nSecondary survey: คลำ pedal pulse ข้างขวาได้ แต่อ่อนกว่าข้างซ้าย, sensation intact distally, สามารถขยับนิ้วเท้าได้",
      question:
        "ผู้ป่วยรายนี้มี hemodynamic instability จากสาเหตุอะไร จงอธิบายการดูแลเบื้องต้นตาม ATLS protocol",
      answer:
        "สาเหตุของ hemodynamic instability:\n- Femoral shaft fracture สามารถทำให้เสียเลือดได้ 1,000-1,500 mL ใน closed fracture\n- ผู้ป่วยมี Class II-III hemorrhagic shock (HR 110, BP 100/68, pale cool skin, capillary refill 3 sec)\n- ต้อง rule out internal hemorrhage จาก chest, abdomen, pelvis ร่วมด้วย\n\nการดูแลเบื้องต้นตาม ATLS:\n1. Airway: มี patent airway, keep c-spine precaution จนกว่าจะ clear\n2. Breathing: SpO2 ดี ให้ supplemental O2 via nasal cannula 3-4 L/min\n3. Circulation (สำคัญที่สุด):\n   - Large bore IV access 2 เส้น (16-18G) ทั้ง 2 แขน\n   - Aggressive fluid resuscitation: Ringer's lactate 1-2 L bolus\n   - Crossmatch blood 4 units packed RBC\n   - ให้ Tranexamic acid 1 g IV ภายใน 3 ชั่วโมงหลัง injury\n   - Monitor: Foley catheter, urine output > 0.5 mL/kg/hr\n4. Disability: GCS 15, neuro intact - monitor\n5. Exposure: Maintain temperature, prevent hypothermia\n\n6. Splinting:\n   - Thomas splint หรือ traction splint สำหรับ femoral shaft fracture\n   - ช่วยลด pain, ลด bleeding, ป้องกัน further injury\n\n7. Investigations:\n   - Portable CXR, Pelvic X-ray\n   - FAST ultrasound (Focused Assessment with Sonography for Trauma)\n   - X-ray femur AP + Lateral ทั้ง hip และ knee joint",
      key_points: [
        "Femoral shaft fracture เสียเลือดได้ 1,000-1,500 mL ใน closed fracture",
        "ต้อง rule out occult bleeding จาก chest, abdomen, pelvis เสมอในผู้ป่วย trauma",
        "Traction splint เป็น definitive prehospital splinting สำหรับ femoral fracture",
        "Tranexamic acid ควรให้ภายใน 3 ชั่วโมงหลัง injury ใน trauma patients",
      ],
      time_minutes: 10,
    },
    {
      part_number: 2,
      title: "ส่วนที่ 2: การแปลผล Imaging และจำแนกกระดูกหัก",
      scenario:
        "หลังให้ IV fluid 2 L และ pRBC 1 unit:\n- HR 95/min, BP 118/74 mmHg, urine output 45 mL/hr\n\nผลตรวจ:\n- FAST: negative (ไม่มี free fluid ในช่องท้อง)\n- CXR: ปกติ, ไม่มี pneumothorax/hemothorax\n- Pelvic X-ray: ปกติ\n- X-ray right femur AP + Lateral:\n  - Comminuted fracture ที่ mid-shaft ของ femur\n  - Butterfly fragment ขนาดประมาณ 3 cm\n  - Shortening ประมาณ 2.5 cm\n  - ไม่มี fracture extension ไปถึง hip หรือ knee joint\n- X-ray right knee: ปกติ\n- X-ray right hip: ปกติ\n\nLab: Hb 10.2 g/dL (ก่อนหน้า 14.0), Hct 30%, Platelet 280,000",
      question:
        "จงจำแนก fracture pattern ตาม AO/OTA classification และอธิบายแผนการรักษาด้วยวิธีผ่าตัด (definitive fixation)",
      answer:
        "AO/OTA Classification:\n- Bone: Femur = 32 (3 = femur, 2 = diaphysis)\n- Type: B (wedge/butterfly fragment)\n- Group: 32-B2 (bending wedge, comminuted)\n- ลักษณะ: comminuted fracture with butterfly fragment ที่ mid-shaft\n\nWinquist-Hansen Classification: Type II (butterfly fragment < 50% of cortical diameter)\n\nแผนการรักษาด้วยวิธีผ่าตัด:\n\nGold standard: Intramedullary nailing (IMN) - Antegrade femoral nail\n- เป็น treatment of choice สำหรับ femoral shaft fracture ในผู้ใหญ่\n- Timing: ควรทำภายใน 24 ชั่วโมง (early fixation) ถ้า hemodynamically stable\n- Entry point: Piriformis fossa หรือ Greater trochanter tip (lateral entry nail)\n- Technique: Reamed intramedullary nailing\n  - Reaming ช่วยเพิ่ม nail diameter, better fit, เพิ่ม union rate\n  - ใส่ proximal และ distal interlocking screws\n  - Static locking สำหรับ comminuted fracture (ป้องกัน shortening/rotation)\n\nทางเลือกอื่น:\n- Plate fixation (submuscular plating): สำหรับ fracture ที่ใกล้ proximal/distal metaphysis\n- External fixation: สำหรับ damage control ใน polytrauma หรือ open fracture\n\nPreoperative preparation:\n- Continue resuscitation, optimize hemoglobin > 8 g/dL\n- Maintain traction splint จนกว่าจะผ่าตัด\n- DVT prophylaxis: Enoxaparin 40 mg SC OD\n- Preoperative antibiotics: Cefazolin 2 g IV",
      key_points: [
        "Intramedullary nailing เป็น gold standard สำหรับ femoral shaft fracture",
        "Early fixation (< 24 ชม.) ลด complications: fat embolism, ARDS, mortality",
        "Static locking จำเป็นใน comminuted fracture เพื่อป้องกัน shortening",
        "ต้อง image hip และ knee joint เสมอเพื่อแยก associated fracture (ipsilateral femoral neck fracture)",
      ],
      time_minutes: 10,
    },
    {
      part_number: 3,
      title: "ส่วนที่ 3: การผ่าตัดและดูแลหลังผ่าตัด",
      scenario:
        "ผ่าตัด Antegrade reamed intramedullary nailing สำเร็จ\n\nOperative details:\n- Position: Supine on fracture table, traction applied\n- Entry point: Greater trochanter tip\n- Reaming ถึง 13 mm, ใส่ nail ขนาด 11 x 380 mm\n- Proximal locking: 2 screws, Distal locking: 2 screws (static mode)\n- Reduction ได้ alignment ดี, rotation ปกติเทียบกับขาข้างตรงข้าม\n- EBL: 200 mL, ไม่ต้องเติมเลือดเพิ่ม\n\nPostoperative X-ray: Good alignment, nail position satisfactory\n\nPost-op Day 1:\n- BT 37.5°C, HR 85/min, BP 125/78 mmHg\n- Pain score 5/10 with PCA morphine\n- Hb 9.5 g/dL\n- ขาขวาบวมเล็กน้อย, pedal pulse palpable, sensation intact\n- สามารถขยับข้อเท้าและนิ้วเท้าได้",
      question:
        "จงวางแผน postoperative rehabilitation protocol และ weight-bearing status รวมถึงการป้องกันภาวะแทรกซ้อน",
      answer:
        "Postoperative rehabilitation protocol:\n\nDay 0-1 (Immediate post-op):\n- Limb elevation บน pillow\n- Ankle pump exercises ทุก 1 ชั่วโมง (ป้องกัน DVT)\n- Active ROM ข้อเท้าและนิ้วเท้า\n- Quadriceps isometric exercises\n- Pain management: PCA morphine → เปลี่ยนเป็น oral opioids\n\nDay 1-3:\n- นั่งบนเตียง, ห้อยขาข้างเตียง\n- Active-assisted ROM ข้อเข่า (0-90 degrees)\n- Straight leg raise exercises\n- Transfer training (เตียง → เก้าอี้)\n\nWeight-bearing status:\n- Touch-down weight bearing (TDWB) หรือ Toe-touch weight bearing\n- เนื่องจาก comminuted fracture with butterfly fragment\n- ใช้ walker หรือ crutches\n- Progressive weight bearing ตาม fracture healing (ดูจาก follow-up X-ray)\n- Full weight bearing เมื่อมี radiographic callus formation (ปกติ 6-12 สัปดาห์)\n\nWeek 2-6:\n- Active ROM knee 0-120 degrees\n- Hip ROM exercises (avoid extreme hip flexion ถ้า piriformis entry)\n- Progressive resistance exercises\n- Gait training with assistive device\n\nการป้องกันภาวะแทรกซ้อน:\n1. DVT prophylaxis: Enoxaparin 40 mg SC OD x 2-4 สัปดาห์\n2. Fat embolism syndrome: monitor respiratory status, petechiae, confusion\n3. Compartment syndrome: monitor 5 P's (Pain, Pallor, Pulselessness, Paresthesia, Paralysis)\n4. Infection: wound care, monitor for signs of infection\n5. Pressure sore prevention: frequent repositioning",
      key_points: [
        "Early mobilization ลด complications: DVT, pneumonia, pressure sores",
        "Weight bearing status ขึ้นกับ fracture pattern และ fixation stability",
        "DVT prophylaxis จำเป็นในผู้ป่วย femoral fracture",
        "Fat embolism syndrome มักเกิดใน 24-72 ชม. หลัง fracture/surgery",
      ],
      time_minutes: 10,
    },
    {
      part_number: 4,
      title: "ส่วนที่ 4: ภาวะแทรกซ้อนระยะแรก - Fat Embolism Syndrome",
      scenario:
        "Post-op Day 2 (48 ชั่วโมงหลังผ่าตัด):\nผู้ป่วยมีอาการเปลี่ยนแปลงกะทันหัน:\n- หอบเหนื่อย RR 28/min, SpO2 88% room air\n- สับสน confusion, GCS ลดลงเป็น 13 (E3V4M6)\n- HR 120/min, BP 105/65 mmHg, BT 38.5°C\n- ตรวจพบ petechial rash ที่หน้าอก, คอ, และ axillae\n- ตรวจ fundoscopy: พบ cotton wool spots\n\nLab:\n- ABG: pH 7.38, PaO2 55 mmHg, PaCO2 32 mmHg, HCO3 22\n- Hb 8.8 g/dL, Platelet 95,000/mm³\n- CXR: bilateral diffuse infiltrates (snowstorm appearance)",
      question:
        "จงวินิจฉัย ให้เกณฑ์การวินิจฉัย (Gurd's criteria) และวางแผนการรักษา",
      answer:
        "การวินิจฉัย: Fat Embolism Syndrome (FES)\n\nGurd's Criteria สำหรับ Fat Embolism Syndrome:\n\nMajor criteria (ผู้ป่วยรายนี้มี 3 ข้อ):\n1. Petechial rash ✓ (ที่หน้าอก, คอ, axillae)\n2. Respiratory insufficiency ✓ (PaO2 < 60 mmHg, bilateral infiltrates)\n3. Cerebral signs ✓ (confusion, GCS 13)\n\nMinor criteria:\n1. Tachycardia > 110/min ✓ (HR 120)\n2. Pyrexia > 38.5°C ✓ (BT 38.5°C)\n3. Retinal changes ✓ (cotton wool spots)\n4. Thrombocytopenia ✓ (Plt 95,000)\n5. Anemia (Hb drop > 20%) ✓\n6. High ESR\n7. Fat macroglobulinemia\n\nDiagnosis: ต้องมี major criteria >= 1 + minor criteria >= 2 + fat macroglobulinemia\nผู้ป่วยรายนี้มี 3 major + 5 minor = definite FES\n\nแผนการรักษา (Supportive treatment เป็นหลัก):\n1. Respiratory support:\n   - O2 supplement เริ่มด้วย high-flow nasal cannula หรือ non-rebreather mask\n   - Target SpO2 > 94%, PaO2 > 60 mmHg\n   - เตรียม intubation + mechanical ventilation ถ้า deteriorate\n   - Lung-protective ventilation: Tidal volume 6 mL/kg, PEEP 5-10 cmH2O\n\n2. Hemodynamic support:\n   - IV fluid resuscitation cautiously (avoid fluid overload ใน lung injury)\n   - Vasopressors ถ้า hypotension ไม่ตอบสนองต่อ fluid\n\n3. Neurological monitoring:\n   - Serial GCS assessment ทุก 1-2 ชั่วโมง\n   - CT brain ถ้า GCS ไม่ดีขึ้นใน 24-48 ชม.\n\n4. Supportive care:\n   - Maintain Hb > 7-8 g/dL (transfuse pRBC ถ้าจำเป็น)\n   - Platelet transfusion ถ้า < 50,000 + active bleeding\n   - Methylprednisolone อาจพิจารณาในรายที่รุนแรง (evidence ยังไม่ชัด)\n\n5. ICU admission สำหรับ close monitoring",
      key_points: [
        "FES classic triad: respiratory distress, neurological changes, petechial rash",
        "มักเกิด 24-72 ชั่วโมงหลัง long bone fracture",
        "Petechial rash เป็น pathognomonic แต่อาจเกิดช้าหรือไม่เกิดเลย",
        "การรักษาเป็น supportive care เป็นหลัก ไม่มี specific treatment",
      ],
      time_minutes: 10,
    },
    {
      part_number: 5,
      title: "ส่วนที่ 5: การติดตามการหายของกระดูกและภาวะ Delayed Union",
      scenario:
        "FES อาการดีขึ้นหลังรักษา 5 วันใน ICU สามารถ extubate ได้ GCS กลับเป็น 15 ผู้ป่วยฟื้นตัวดี จำหน่ายจากโรงพยาบาลหลังนอน 14 วัน\n\nFollow-up 3 เดือนหลังผ่าตัด:\n- ผู้ป่วยยังปวดต้นขาขวาเวลาลงน้ำหนัก pain score 4/10\n- เดินได้ด้วย crutches, partial weight bearing\n- ROM knee: 0-110 degrees (ปกติ 0-140)\n\nX-ray femur 3 เดือน:\n- Minimal callus formation บริเวณ fracture site\n- Fracture line ยังมองเห็นชัดเจน\n- Nail position ยังดี ไม่มี hardware failure\n- ไม่มี signs ของ infection (no lysis, no periosteal reaction ผิดปกติ)",
      question:
        "จงวินิจฉัยปัญหาการหายของกระดูก อธิบาย timeline ปกติของ fracture healing และวางแผนการรักษาเพิ่มเติม",
      answer:
        "การวินิจฉัย: Delayed union ของ femoral shaft fracture\n- ปกติ femoral shaft fracture ควรมี radiographic union ภายใน 3-6 เดือน\n- ที่ 3 เดือนควรมี callus formation ชัดเจน แต่ผู้ป่วยรายนี้มี minimal callus\n- ยังไม่ถือว่า nonunion (ซึ่งนิยามที่ > 6-9 เดือนโดยไม่มี progression of healing)\n\nTimeline ปกติของ fracture healing:\n1. Inflammatory phase (Day 0-7): Hematoma formation, inflammatory cells\n2. Soft callus phase (Week 2-6): Fibrocartilage formation\n3. Hard callus phase (Week 6-12): Woven bone formation, visible callus on X-ray\n4. Remodeling phase (Month 3-24): Lamellar bone replaces woven bone\n\nปัจจัยเสี่ยง delayed union ในผู้ป่วยรายนี้:\n- Comminuted fracture pattern (butterfly fragment)\n- Extensive soft tissue injury\n- History of fat embolism syndrome (compromised blood supply)\n- Possible inadequate weight bearing/mechanical stimulation\n\nแผนการรักษาเพิ่มเติม:\n1. Conservative measures (ลองก่อน 3 เดือน):\n   - Progressive weight bearing: เพิ่มเป็น weight bearing as tolerated\n   - Dynamization: ถอด distal locking screws เพื่อให้ axial compression ที่ fracture site\n   - ช่วยกระตุ้น bone healing ผ่าน mechanical stimulation\n   - Optimize nutrition: Calcium 1,000-1,200 mg/day, Vitamin D 800-1,000 IU/day\n   - หยุดสูบบุหรี่ (ถ้าสูบ)\n\n2. Adjunct therapies:\n   - Low-intensity pulsed ultrasound (LIPUS) - อาจช่วยกระตุ้น bone healing\n   - Bone stimulator\n\n3. ถ้ายังไม่ดีขึ้นใน 6 เดือน (nonunion):\n   - Exchange nailing: ถอด nail เดิม, ream ใหม่ขนาดใหญ่ขึ้น, ใส่ nail ใหม่ที่ใหญ่ขึ้น\n   - เพิ่ม autologous bone graft จาก iliac crest\n\n4. Follow-up: X-ray ทุก 6-8 สัปดาห์ เพื่อประเมิน progression",
      key_points: [
        "Delayed union = ไม่หายตาม expected timeline แต่ยังมี potential to heal",
        "Dynamization ช่วยกระตุ้น bone healing โดยให้ axial compression",
        "Exchange nailing เป็น treatment of choice สำหรับ femoral shaft nonunion",
        "Risk factors: comminuted fracture, smoking, poor nutrition, infection",
      ],
      time_minutes: 10,
    },
    {
      part_number: 6,
      title: "ส่วนที่ 6: ผลลัพธ์สุดท้ายและการฟื้นฟูสมรรถภาพ",
      scenario:
        "หลังทำ dynamization ที่ 3 เดือน + progressive weight bearing:\n\nFollow-up 6 เดือนหลังผ่าตัด:\n- ผู้ป่วยเดินได้โดยไม่ต้องใช้อุปกรณ์ช่วย\n- ปวดเล็กน้อยหลังเดินนานๆ pain score 1-2/10\n- ROM knee: 0-130 degrees\n- ต้นขาขวาเล็กกว่าข้างซ้าย 2 cm (quadriceps atrophy)\n\nX-ray femur 6 เดือน:\n- Progressive callus formation, bridging callus ≥ 3 cortices\n- Fracture line blurring\n- สรุป: Radiographic union progressing well\n\nผู้ป่วยเป็นพนักงานออฟฟิศ อยากกลับไปเล่นฟุตบอลเหมือนเดิม",
      question:
        "จงประเมินผลการรักษาและวางแผน return to sport protocol รวมถึงบอก long-term complications ที่ต้องติดตาม",
      answer:
        "การประเมินผลการรักษา:\n- Clinical union: เดินลงน้ำหนักเต็มได้ ปวดน้อยมาก\n- Radiographic union: bridging callus ≥ 3 cortices, fracture line blurring - progressing well\n- ROM: knee 0-130° (ใกล้เคียงปกติ 0-140°)\n- ปัญหาที่เหลือ: quadriceps atrophy 2 cm\n\nReturn to sport protocol:\n\nPhase 1 (เดือนที่ 6-8) - Strengthening:\n- Progressive resistance exercises: leg press, squats, lunges\n- Quadriceps strengthening: ตั้งเป้า symmetry (< 10% difference กับขาข้างตรงข้าม)\n- Hamstring, hip abductor/adductor strengthening\n- Stationary cycling, swimming\n- Proprioception training: balance board, single-leg stance\n\nPhase 2 (เดือนที่ 8-10) - Sport-specific training:\n- Jogging on flat surface เริ่มจาก interval training\n- Agility drills: ladder drills, cone drills\n- Ball control exercises (non-contact)\n- Plyometric exercises: progressive jumping, hopping\n\nPhase 3 (เดือนที่ 10-12) - Return to play:\n- Non-contact team practice\n- Progressive contact training\n- Match simulation\n- Full return to competitive sport เมื่อผ่านเกณฑ์:\n  - Quadriceps strength > 90% ของขาข้างตรงข้าม\n  - Hop test > 90% ของขาข้างตรงข้าม\n  - No pain with sport-specific activities\n  - X-ray: complete union\n\nLong-term complications ที่ต้องติดตาม:\n1. Hardware prominence/irritation: อาจต้องถอด nail หลัง union สมบูรณ์ (1-2 ปี)\n2. Knee stiffness: ถ้า ROM ไม่ดีขึ้นอาจต้อง physiotherapy เข้มข้น\n3. Leg length discrepancy: ตรวจ scanogram ถ้ามีอาการ\n4. Rotational malalignment: อาจมี external/internal rotation deformity\n5. Heterotopic ossification: บริเวณ entry point\n6. Re-fracture: risk สูงขึ้นหลังถอด nail ใน 6 เดือนแรก\n7. Chronic pain: anterior knee pain จาก nail entry point",
      key_points: [
        "Return to sport ใช้เวลาอย่างน้อย 9-12 เดือนหลัง femoral shaft fracture",
        "Quadriceps strength > 90% ของขาตรงข้ามเป็น criteria สำคัญสำหรับ return to sport",
        "Implant removal พิจารณาเมื่อ union สมบูรณ์ และมี hardware-related symptoms",
        "Long-term follow-up สำคัญสำหรับ malalignment และ leg length discrepancy",
      ],
      time_minutes: 10,
    },
  ],

  "ครรภ์เป็นพิษ (Preeclampsia)": [
    {
      part_number: 1,
      title: "ส่วนที่ 1: การวินิจฉัยและประเมินความรุนแรง",
      scenario:
        "หญิงไทย อายุ 28 ปี ตั้งครรภ์แรก (primigravida) GA 34 สัปดาห์ มาตรวจตามนัดที่คลินิกฝากครรภ์ ไม่มีโรคประจำตัว BMI 26 kg/m²\n\nอาการ: บวมที่หน้าและมือมากขึ้น 1 สัปดาห์ ปวดศีรษะเป็นพักๆ มา 2 วัน\n\nตรวจร่างกาย:\n- BP 158/102 mmHg (วัดซ้ำ 15 นาทีต่อมา: 162/105 mmHg)\n- HR 88/min, RR 18/min, BT 36.8°C\n- Pitting edema 2+ ที่ขาทั้ง 2 ข้าง, มือ, และหน้า\n- น้ำหนักเพิ่มขึ้น 3 kg ใน 1 สัปดาห์ (จากครั้งก่อน 68 → 71 kg)\n- Deep tendon reflexes: brisk (3+), no clonus\n- Fundal height: 33 cm\n\nUrinalysis: Protein 3+ (dipstick)",
      question:
        "จงให้การวินิจฉัยพร้อมเกณฑ์ และจำแนกความรุนแรง (with/without severe features) พร้อมระบุ laboratory workup ที่ควรส่ง",
      answer:
        "การวินิจฉัย: Preeclampsia with severe features\n\nเกณฑ์การวินิจฉัย Preeclampsia (ACOG 2020):\n1. BP ≥ 140/90 mmHg หลัง GA 20 สัปดาห์ (ผู้ป่วย BP 162/105) ✓\n2. Proteinuria ≥ 300 mg/24 hrs หรือ protein/creatinine ratio ≥ 0.3 หรือ dipstick ≥ 2+ ✓\n\nSevere features (ผู้ป่วยรายนี้มี):\n- Severe hypertension: SBP ≥ 160 หรือ DBP ≥ 110 mmHg ✓ (BP 162/105)\n- Headache: อาจบ่งชี้ cerebral involvement ✓\n- (ต้องรอผล lab เพิ่มเติมเพื่อดู features อื่น)\n\nSevere features อื่นที่ต้อง evaluate:\n- Platelet < 100,000/mm³\n- Liver transaminases ≥ 2 เท่าของ upper normal\n- Serum creatinine > 1.1 mg/dL\n- Pulmonary edema\n- Visual disturbances\n- Epigastric/RUQ pain\n\nLaboratory workup:\n1. CBC with platelet count\n2. Liver function tests: AST, ALT, LDH\n3. Renal function: BUN, Creatinine, Uric acid\n4. Coagulation profile: PT, aPTT, Fibrinogen\n5. 24-hour urine protein collection หรือ Spot urine protein/creatinine ratio\n6. Peripheral blood smear: ดู schistocytes (แยก HELLP syndrome)\n7. Serum electrolytes\n\nFetal assessment:\n- Non-stress test (NST)\n- Biophysical profile (BPP)\n- Ultrasound: estimated fetal weight, amniotic fluid index, umbilical artery Doppler",
      key_points: [
        "SBP ≥ 160 หรือ DBP ≥ 110 ถือเป็น severe feature ต้อง treatment urgently",
        "Preeclampsia with severe features ก่อน 34 สัปดาห์ ต้อง admit และ stabilize",
        "HELLP syndrome (Hemolysis, Elevated Liver enzymes, Low Platelets) เป็น severe variant",
        "Headache, visual changes, epigastric pain เป็น warning signs ของ severe disease",
      ],
      time_minutes: 10,
    },
    {
      part_number: 2,
      title: "ส่วนที่ 2: ผล Lab และการรักษาเบื้องต้น",
      scenario:
        "Admit ผู้ป่วยเข้า labor room\n\nผล lab:\n- CBC: Hb 11.8 g/dL, Hct 35%, WBC 9,800, Platelet 135,000/mm³\n- AST 68 U/L (ปกติ < 35), ALT 72 U/L (ปกติ < 35), LDH 380 U/L (ปกติ < 250)\n- BUN 14 mg/dL, Creatinine 1.0 mg/dL, Uric acid 7.2 mg/dL\n- PT 12 sec, aPTT 28 sec, Fibrinogen 350 mg/dL\n- Spot urine protein/creatinine ratio: 0.8\n- Peripheral blood smear: พบ schistocytes เล็กน้อย\n\nFetal assessment:\n- NST: reactive pattern\n- Ultrasound: EFW 2,100 g (25th percentile), AFI 8 cm (ปกติ), Umbilical artery Doppler: normal\n\nขณะรอผล lab BP สูงขึ้นเป็น 170/112 mmHg",
      question:
        "จงแปลผล lab ระบุว่ามี HELLP syndrome หรือไม่ และวางแผนการรักษาเฉียบพลัน (acute management)",
      answer:
        "การแปลผล lab:\n- Thrombocytopenia: Platelet 135,000 (ยังไม่ < 100,000)\n- Elevated liver enzymes: AST 68, ALT 72 (≥ 2x normal) ✓\n- LDH 380 (> 250) ✓\n- Schistocytes on PBS: hemolysis ✓\n- Uric acid 7.2 สูง (บ่งชี้ renal involvement)\n- Creatinine 1.0 ยังปกติ\n\nHELLP Syndrome assessment (Tennessee Classification):\n- Hemolysis: LDH > 600 หรือ schistocytes → LDH 380 + schistocytes = partial\n- Elevated Liver enzymes: AST ≥ 70 → AST 68 (borderline) ✓\n- Low Platelets: < 100,000 → Platelet 135,000 ✗\n\nสรุป: ยังไม่ครบเกณฑ์ complete HELLP syndrome แต่เป็น partial HELLP / evolving HELLP ต้องติดตามใกล้ชิด\n\nAcute management:\n\n1. Antihypertensive (BP > 160/110 = hypertensive emergency):\n   - First-line: IV Labetalol 20 mg IV push → repeat 40 mg, 80 mg ทุก 10-20 นาที\n   - หรือ IV Hydralazine 5-10 mg IV ทุก 20 นาที\n   - หรือ Oral Nifedipine 10-20 mg PO (ถ้า IV ไม่พร้อม)\n   - เป้าหมาย: BP 140-150/90-100 mmHg (ไม่ลดเร็วเกินไป)\n\n2. Seizure prophylaxis:\n   - MgSO4 loading dose: 4-6 g IV ใน 20-30 นาที\n   - Maintenance: 1-2 g/hr IV infusion\n   - Monitor: deep tendon reflexes, respiratory rate, urine output\n   - Therapeutic level: 4-7 mEq/L\n   - Antidote: Calcium gluconate 1 g IV (เตรียมไว้ข้างเตียง)\n\n3. Corticosteroids for fetal lung maturity:\n   - Betamethasone 12 mg IM x 2 doses (ห่างกัน 24 ชั่วโมง)\n   - หรือ Dexamethasone 6 mg IM x 4 doses (ห่างกัน 12 ชั่วโมง)\n   - GA 34 สัปดาห์ ยังได้ประโยชน์จาก late preterm corticosteroids\n\n4. Monitoring:\n   - Continuous fetal monitoring\n   - BP ทุก 15 นาที จนคงที่ แล้วทุก 30 นาที-1 ชั่วโมง\n   - Strict I/O, urine output > 30 mL/hr\n   - Repeat labs ทุก 6-12 ชั่วโมง (CBC, LFT, Cr)",
      key_points: [
        "BP > 160/110 ใน preeclampsia ถือเป็น hypertensive emergency ต้องลดทันที",
        "MgSO4 เป็น first-line สำหรับ seizure prophylaxis ใน preeclampsia",
        "Betamethasone ให้เพื่อ fetal lung maturity ก่อน 37 สัปดาห์",
        "Partial HELLP สามารถ evolve เป็น complete HELLP ได้ ต้อง monitor lab ใกล้ชิด",
      ],
      time_minutes: 10,
    },
    {
      part_number: 3,
      title: "ส่วนที่ 3: การตัดสินใจเรื่องเวลาในการคลอด",
      scenario:
        "หลังได้ IV Labetalol และ MgSO4:\n- BP ลดลงเป็น 148/95 mmHg\n- ผู้ป่วยหายปวดศีรษะ ไม่มี visual symptoms\n\nLab ซ้ำ 12 ชั่วโมงต่อมา:\n- Platelet 118,000/mm³ (ลดจาก 135,000)\n- AST 85 U/L (เพิ่มจาก 68), ALT 90 U/L (เพิ่มจาก 72)\n- LDH 450 U/L (เพิ่มจาก 380)\n- Creatinine 1.1 mg/dL (เพิ่มจาก 1.0)\n- Uric acid 7.8 mg/dL\n\nFetal status: NST reactive, Biophysical Profile 8/8\n\nGA 34+1 สัปดาห์ ได้ Betamethasone dose แรกไปแล้ว 12 ชั่วโมง",
      question:
        "Lab มีแนวโน้ม worsen จง discuss เรื่อง timing of delivery ว่าควร expectant management หรือ deliver now พร้อมเหตุผล",
      answer:
        "Analysis ของสถานการณ์:\n- Lab trend: worsening - platelet ลดลง, liver enzymes เพิ่มขึ้น, LDH เพิ่มขึ้น, Cr เพิ่มขึ้น\n- กำลัง evolve ไปเป็น HELLP syndrome (Platelet trending down, LDH rising, Liver enzymes rising)\n- ได้ Betamethasone dose แรกไป 12 ชั่วโมง (ยังไม่ครบ course)\n\nDecision: ควร deliver ภายใน 24-48 ชั่วโมง (หลังได้ Betamethasone dose ที่ 2)\n\nเหตุผลที่ไม่ควร expectant management นาน:\n1. Lab deterioration trend ชัดเจน - evolving HELLP\n2. Preeclampsia with severe features ที่ GA ≥ 34 สัปดาห์ แนะนำ delivery (ACOG)\n3. Risk ของ maternal complications สูงขึ้น: eclampsia, HELLP, placental abruption, DIC\n4. Definitive treatment ของ preeclampsia คือ delivery\n\nเหตุผลที่รอ 24-48 ชั่วโมง (ไม่ deliver ทันที):\n1. ให้เวลาครบ course Betamethasone (optimal 48 ชม. หลัง dose แรก)\n2. ถ้ารอได้ ให้ Betamethasone dose ที่ 2 ที่ 24 ชม.\n3. Fetal status ยังดี (NST reactive, BPP 8/8)\n4. BP ควบคุมได้ด้วย antihypertensive\n\nเงื่อนไขที่ต้อง deliver ทันที (ไม่รอ steroid):\n- Uncontrolled severe hypertension despite maximum medications\n- Eclampsia (seizure)\n- HELLP syndrome with platelet < 100,000 + progressive\n- Placental abruption\n- Abnormal fetal status (non-reassuring NST)\n- Pulmonary edema\n- Renal failure (Cr > 1.5)\n\nRoute of delivery:\n- Induction of labor ด้วย cervical ripening (Misoprostol หรือ Foley balloon)\n- ถ้า cervix unfavorable (Bishop score < 6) อาจพิจารณา cesarean section\n- ไม่มี absolute contraindication สำหรับ vaginal delivery ใน preeclampsia\n\nPlan:\n- ให้ Betamethasone dose ที่ 2 ที่ 24 ชม.\n- Check labs ทุก 6 ชม.\n- Deliver หลังได้ Betamethasone dose 2 แล้ว 12-24 ชม. (ideally 48 ชม. หลัง dose แรก)\n- ถ้า lab deteriorate เร็ว → deliver ก่อนโดยไม่ต้องรอ",
      key_points: [
        "Preeclampsia with severe features ที่ GA ≥ 34 สัปดาห์ ควร deliver",
        "Betamethasone optimal effect ที่ 48 ชั่วโมง แต่ partial effect ได้ตั้งแต่ 24 ชม.",
        "Definitive treatment ของ preeclampsia คือ delivery",
        "ต้อง balance ระหว่าง maternal risk กับ fetal maturity",
      ],
      time_minutes: 10,
    },
    {
      part_number: 4,
      title: "ส่วนที่ 4: การคลอดและ Intrapartum Management",
      scenario:
        "ตัดสินใจ induce labor หลังได้ Betamethasone ครบ 2 doses (GA 34+3 สัปดาห์)\n\nBishop score: 4 (cervix 1 cm dilated, 50% effaced, -2 station, medium consistency, posterior)\n\nเริ่ม induction ด้วย Misoprostol 25 mcg PV ทุก 4 ชั่วโมง\n\nระหว่าง labor (6 ชั่วโมงหลังเริ่ม induction):\n- Cervix 4 cm dilated, 80% effaced, -1 station\n- เปลี่ยนเป็น Oxytocin drip\n- BP 155/100 mmHg → เพิ่ม Labetalol\n- MgSO4 infusion running\n\n10 ชั่วโมงหลังเริ่ม induction:\n- ทันใดนั้นผู้ป่วยมี tonic-clonic seizure นาน 90 วินาที\n- Fetal heart rate: prolonged deceleration ลงเหลือ 80 bpm\n- BP 180/120 mmHg ขณะ seizure",
      question:
        "จงวินิจฉัยและจัดการกับภาวะฉุกเฉินนี้อย่างเป็นระบบ",
      answer:
        "การวินิจฉัย: Eclampsia (seizure ใน preeclampsia)\n\nBreakthrough eclampsia ขณะได้ MgSO4 อยู่ - ต้อง check Mg level\n\nImmediate management (ABCs):\n\n1. Protect airway:\n   - Left lateral decubitus position (ป้องกัน aspiration + เพิ่ม uterine blood flow)\n   - Suction oropharynx ถ้ามี secretions\n   - ไม่ใส่ oral airway ขณะ seizure (กัด tongue)\n   - ให้ O2 10 L/min via non-rebreather mask\n   - เตรียม intubation equipment\n\n2. Stop seizure:\n   - MgSO4 bolus 2-4 g IV ใน 5 นาที (additional dose)\n   - ถ้า seizure ไม่หยุด: Lorazepam 4 mg IV หรือ Diazepam 5-10 mg IV\n   - Check serum Magnesium level (ถ้า < 4 mEq/L = subtherapeutic)\n   - เพิ่ม MgSO4 maintenance rate\n\n3. Blood pressure control:\n   - IV Labetalol 20-40 mg bolus\n   - หรือ IV Hydralazine 5-10 mg\n   - เป้าหมาย: ลด BP ลงภายใน 15-20 นาที\n\n4. Fetal assessment:\n   - Prolonged deceleration: เกิดจาก uterine hypoperfusion ขณะ seizure\n   - Intrauterine resuscitation:\n     - Left lateral position ✓\n     - IV fluid bolus 500 mL\n     - Stop oxytocin ทันที\n     - O2 supplement ✓\n   - Monitor FHR: ถ้า deceleration resolve ภายใน 10 นาที สามารถ continue labor ได้\n   - ถ้า persistent bradycardia > 10 นาที → emergency cesarean section\n\n5. Assess for complications:\n   - Placental abruption: ดู vaginal bleeding, uterine tenderness, wooden-hard uterus\n   - Pulmonary edema: ดู SpO2, lung auscultation\n   - Repeat labs: CBC, LFT, Cr, coagulation\n\n6. Decision after stabilization:\n   - ถ้า cervix fully dilated → expedite vaginal delivery (vacuum/forceps)\n   - ถ้า cervix not fully dilated + maternal/fetal compromise → cesarean section\n   - ไม่ควร delay delivery หลัง eclampsia",
      key_points: [
        "Eclampsia เป็น life-threatening emergency ต้องจัดการ ABCs ก่อน",
        "MgSO4 additional bolus 2-4 g IV สำหรับ breakthrough seizure",
        "Prolonged fetal deceleration หลัง seizure มักกลับมาปกติหลัง maternal stabilization",
        "ต้อง deliver หลัง eclamptic seizure ไม่ว่า gestational age เท่าไร",
      ],
      time_minutes: 10,
    },
    {
      part_number: 5,
      title: "ส่วนที่ 5: Postpartum Management",
      scenario:
        "หลังจัดการ eclamptic seizure:\n- Seizure หยุดหลังได้ MgSO4 bolus เพิ่ม, Serum Mg level เดิม = 3.2 mEq/L (subtherapeutic)\n- Fetal heart rate กลับมา normal baseline หลัง 5 นาที\n- Cervix 6 cm, ตัดสินใจทำ emergency cesarean section เนื่องจาก eclampsia + evolving HELLP\n\nCesarean section สำเร็จ:\n- ทารกเพศหญิง น้ำหนัก 2,050 g, Apgar 7 (1 min), 9 (5 min)\n- ทารกหายใจเอง ย้ายไป NICU สำหรับ observation\n- EBL 600 mL\n\nPostpartum 6 ชั่วโมง:\n- BP 155/98 mmHg\n- Urine output 25 mL/hr (ลดลง)\n- Lab: Platelet 85,000, AST 120, ALT 115, LDH 580, Cr 1.3\n- MgSO4 infusion ยังคงให้อยู่",
      question:
        "Lab หลังคลอดแย่ลง จงวินิจฉัยและวางแผน postpartum management",
      answer:
        "การวินิจฉัย: Postpartum HELLP Syndrome\n- Hemolysis: LDH 580 (> 600 borderline), schistocytes (จากก่อนหน้า)\n- Elevated Liver enzymes: AST 120, ALT 115 (> 2x normal) ✓\n- Low Platelets: 85,000 (< 100,000) ✓\n- HELLP syndrome สามารถ develop หรือ worsen ได้ใน 48-72 ชั่วโมงหลังคลอด\n\nPostpartum management:\n\n1. Continued MgSO4:\n   - ให้ต่ออีก 24-48 ชั่วโมงหลังคลอด (หรือ 24 ชม. หลัง seizure ครั้งสุดท้าย)\n   - Monitor: Mg level ทุก 6 ชม. (target 4-7 mEq/L)\n   - Watch for toxicity: ลด/หยุดถ้า RR < 12, DTR absent, urine output < 25 mL/hr\n\n2. Blood pressure management:\n   - Continue IV Labetalol PRN + oral antihypertensive\n   - Oral Nifedipine 30 mg SR OD-BID หรือ Oral Labetalol 200 mg BID-TID\n   - เป้าหมาย: BP < 150/100 mmHg\n   - อาจต้อง antihypertensive หลายสัปดาห์-เดือนหลังคลอด\n\n3. HELLP syndrome management:\n   - Supportive care: ไม่มี specific treatment นอกจาก delivery (ทำแล้ว)\n   - ติดตาม labs ทุก 6-12 ชม.\n   - HELLP มักจะ peak ที่ 24-48 ชม. หลังคลอด แล้ว improve\n   - Dexamethasone 10 mg IV q 12 hrs x 2 doses แล้ว 5 mg IV q 12 hrs x 2 doses\n     (อาจช่วย accelerate platelet recovery แต่ evidence ยังเป็น controversial)\n\n4. Monitor for complications:\n   - DIC: ส่ง coagulation profile ทุก 6-12 ชม.\n   - Renal failure: strict I/O, urine output ≥ 0.5 mL/kg/hr\n   - Liver hematoma/rupture: ถ้ามี severe RUQ pain + hemodynamic instability → CT abdomen\n   - Pulmonary edema: restrict fluid, furosemide ถ้าจำเป็น\n\n5. Platelet transfusion:\n   - Transfuse ถ้า platelet < 20,000 (spontaneous bleeding risk)\n   - หรือ < 50,000 ถ้ามี active bleeding หรือ before invasive procedure\n\n6. Pain management:\n   - Paracetamol 1 g IV/PO q 6 hrs (หลีกเลี่ยง NSAIDs เนื่องจาก renal compromise + platelet low)\n   - Opioids PRN สำหรับ post-cesarean pain",
      key_points: [
        "HELLP syndrome สามารถ develop หรือ worsen ได้ 48-72 ชม. หลังคลอด",
        "MgSO4 ให้ต่ออย่างน้อย 24 ชั่วโมงหลังคลอดหรือหลัง seizure ครั้งสุดท้าย",
        "Platelet nadir มักอยู่ที่ 24-48 ชม. หลังคลอด แล้วจะ improve",
        "หลีกเลี่ยง NSAIDs ใน HELLP เนื่องจาก platelet ต่ำและ renal compromise",
      ],
      time_minutes: 10,
    },
    {
      part_number: 6,
      title: "ส่วนที่ 6: การวางแผนจำหน่ายและ Long-term Follow-up",
      scenario:
        "Postpartum Day 5:\n- BP 138/88 mmHg (on Nifedipine 30 mg SR BID)\n- ไม่มีอาการปวดศีรษะ, ไม่มี visual symptoms\n- Urine output ปกติ\n- แผลผ่าตัด clean and dry\n- น้ำนมเริ่มมา สามารถให้นมลูกได้\n\nLab:\n- Platelet 165,000 (improving จาก 85,000)\n- AST 45, ALT 50 (improving)\n- LDH 280 (improving)\n- Creatinine 0.8 (improving)\n- MgSO4 หยุดแล้ว 48 ชม.\n\nทารก: น้ำหนัก 2,020 g, stable ใน NICU, on room air, feeding well\n\nผู้ป่วยถามว่า:\n1. ต้องทานยาลดความดันไปนานแค่ไหน?\n2. ครรภ์ต่อไปจะเป็นซ้ำไหม?\n3. มีความเสี่ยงต่อโรคหัวใจในอนาคตไหม?",
      question:
        "จงวางแผน discharge plan และตอบคำถามผู้ป่วยทั้ง 3 ข้อโดยอิงหลักฐานทางการแพทย์",
      answer:
        "Discharge plan:\n\n1. ยาที่ให้กลับบ้าน:\n   - Nifedipine 30 mg SR BID (ปรับตามBP)\n   - Paracetamol 500 mg PRN สำหรับปวดแผล\n   - Ferrous fumarate 200 mg OD (จาก blood loss)\n   - Calcium 600 mg + Vitamin D 400 IU OD\n\n2. การเลี้ยงลูกด้วยนมแม่:\n   - สามารถให้นมแม่ได้ ยา Nifedipine, Labetalol ปลอดภัยขณะให้นมบุตร\n   - หลีกเลี่ยง: ACE inhibitors, ARBs (ห้ามใช้ขณะให้นม)\n\n3. BP monitoring:\n   - วัด BP ที่บ้านวันละ 2 ครั้ง บันทึกค่า\n   - เป้าหมาย: < 140/90 mmHg\n\n4. นัดติดตาม:\n   - 3-5 วันหลังจำหน่าย: ตรวจ BP, อาการ\n   - 2 สัปดาห์: ตรวจแผล, BP, labs (CBC, LFT, Cr)\n   - 6 สัปดาห์: postpartum visit ครบถ้วน\n\n5. Warning signs กลับมาทันที:\n   - ปวดศีรษะรุนแรง, ตามัว\n   - ปวดใต้ชายโครงขวา\n   - BP > 160/110\n   - ชักเกร็ง\n   - หายใจลำบาก\n\nตอบคำถามผู้ป่วย:\n\n1. ยาลดความดัน:\n   - Postpartum hypertension มักจะ resolve ภายใน 6-12 สัปดาห์\n   - Taper ยาลดความดันลงเมื่อ BP คงที่ < 130/80 ตลอด\n   - ผู้ป่วยบางรายอาจต้องทานยาต่อถ้า BP ไม่ลง (ประมาณ 10-15%)\n   - ถ้า BP ยังสูงหลัง 12 สัปดาห์ ต้อง investigate chronic hypertension\n\n2. ความเสี่ยงเป็นซ้ำในครรภ์ต่อไป:\n   - Recurrence rate: 25-40% สำหรับ preeclampsia ในครรภ์ถัดไป\n   - สูงขึ้นถ้าเคยมี severe preeclampsia/eclampsia/HELLP\n   - Prevention: Low-dose aspirin 150 mg HS เริ่มก่อน 16 สัปดาห์ในครรภ์ถัดไป\n   - Calcium supplement 1,000-1,500 mg/day\n   - ฝากครรภ์ high-risk ตั้งแต่เริ่ม\n\n3. ความเสี่ยงโรคหัวใจในอนาคต:\n   - Preeclampsia เป็น independent risk factor สำหรับ cardiovascular disease\n   - เพิ่มความเสี่ยง: chronic hypertension (2-4 เท่า), ischemic heart disease (2 เท่า), stroke (1.5 เท่า)\n   - แนะนำ:\n     - ตรวจ BP ประจำปี\n     - Screen metabolic syndrome ทุก 1-3 ปี (lipid, glucose, BMI)\n     - ออกกำลังกายสม่ำเสมอ 150 นาที/สัปดาห์\n     - ควบคุมน้ำหนัก, BMI < 25\n     - แจ้งประวัติ preeclampsia ให้แพทย์ทุกครั้ง",
      key_points: [
        "Postpartum hypertension มักจะ resolve ภายใน 6-12 สัปดาห์",
        "Low-dose aspirin ก่อน 16 สัปดาห์ช่วยป้องกัน preeclampsia ในครรภ์ถัดไป",
        "Preeclampsia เป็น risk factor สำหรับ cardiovascular disease ในอนาคต",
        "Nifedipine และ Labetalol ปลอดภัยสำหรับ breastfeeding mothers",
      ],
      time_minutes: 10,
    },
  ],

  "ไข้ชัก (Febrile Seizure) ในเด็ก": [
    {
      part_number: 1,
      title: "ส่วนที่ 1: การประเมินเบื้องต้นและ First Aid",
      scenario:
        "เด็กชายไทย อายุ 2 ปี ถูกนำส่งห้องฉุกเฉินโดยพ่อแม่ ขณะอยู่ที่บ้านเด็กมีไข้สูง แล้วเกิดชักเกร็งกระตุกทั้งตัว (generalized tonic-clonic seizure) นาน 3 นาที หยุดชักเอง พ่อแม่ตกใจมากอุ้มมาโรงพยาบาลทันที\n\nประวัติ: มีน้ำมูก ไอ 2 วัน ไข้สูงวันนี้เป็นวันแรก ไม่เคยชักมาก่อน ไม่มีประวัติชักในครอบครัว ไม่มีประวัติ head trauma พัฒนาการปกติตามวัย ฉีดวัคซีนครบตามเกณฑ์\n\nเมื่อมาถึง ER:\n- BT 39.8°C (ทาง tympanic), HR 140/min, RR 32/min, BP 90/55 mmHg, SpO2 98%\n- น้ำหนัก 12 kg\n- เด็กร้องไห้งอแง แต่รู้สึกตัวดี, GCS 15 (E4V5M6)\n- ไม่มี neck stiffness, Kernig's sign negative, Brudzinski's sign negative\n- Anterior fontanelle ปิดแล้ว\n- ENT: pharynx erythematous, TM bilateral ปกติ, mild clear rhinorrhea\n- Chest: clear bilateral, no rales/rhonchi\n- Skin: no rash, no petechiae",
      question:
        "จงให้การวินิจฉัยเบื้องต้น จำแนกว่าเป็น simple หรือ complex febrile seizure และอธิบายการดูแลเบื้องต้น (first aid) ที่ถูกต้องเมื่อเด็กชัก",
      answer:
        "การวินิจฉัย: Simple febrile seizure จาก acute upper respiratory tract infection\n\nเกณฑ์ Simple febrile seizure (ครบทุกข้อ):\n1. อายุ 6 เดือน - 5 ปี ✓ (อายุ 2 ปี)\n2. Generalized seizure ✓ (tonic-clonic ทั้งตัว)\n3. ระยะเวลา < 15 นาที ✓ (3 นาที)\n4. ไม่ชักซ้ำภายใน 24 ชั่วโมง (ต้องติดตาม)\n5. ไม่มี neurological deficit หลังชัก ✓ (GCS 15)\n6. ไม่มี CNS infection ✓ (no meningeal signs)\n\nComplex febrile seizure (ไม่ใช่กรณีนี้) ถ้ามีข้อใดข้อหนึ่ง:\n- Focal seizure\n- ระยะเวลา > 15 นาที\n- ชักซ้ำ > 1 ครั้งใน 24 ชั่วโมง\n- มี postictal neurological deficit (Todd's paralysis)\n\nFirst Aid สำหรับเด็กชัก (ที่ควรแนะนำพ่อแม่):\n\n1. สิ่งที่ควรทำ:\n   - วางเด็กนอนตะแคง (recovery position) เพื่อป้องกัน aspiration\n   - เอาสิ่งของอันตรายออกจากบริเวณรอบตัว\n   - จับเวลาการชัก\n   - คลายเสื้อผ้าที่รัด\n   - สังเกตลักษณะการชัก (ชักแบบไหน, กระตุกที่ไหน)\n   - โทรเรียกรถพยาบาลถ้าชักนาน > 5 นาที\n\n2. สิ่งที่ห้ามทำ:\n   - ห้ามงัดปากหรือใส่สิ่งของในปาก (เสี่ยง injury + aspiration)\n   - ห้ามจับเด็กกดลง หรือพยายามหยุดการชัก\n   - ห้ามให้น้ำหรือยาทางปากขณะชัก\n   - ห้ามประคบน้ำเย็นขณะชัก\n\nการดูแลเบื้องต้นใน ER:\n1. ABCs assessment: Airway patent, Breathing adequate, Circulation stable\n2. ลดไข้: Paracetamol 15 mg/kg/dose = 180 mg PO/PR\n3. IV access: สำหรับ IV fluid และเตรียมยากันชักถ้าชักซ้ำ\n4. Tepid sponge (ไม่ใช้น้ำเย็นจัด)",
      key_points: [
        "Simple febrile seizure: generalized, < 15 นาที, ไม่ชักซ้ำใน 24 ชม., ไม่มี neuro deficit",
        "ห้ามงัดปากหรือใส่สิ่งของในปากเด็กขณะชัก",
        "Recovery position (นอนตะแคง) ป้องกัน aspiration",
        "Febrile seizure พบบ่อยที่สุดในเด็กอายุ 12-18 เดือน",
      ],
      time_minutes: 10,
    },
    {
      part_number: 2,
      title: "ส่วนที่ 2: การตรวจเพิ่มเติมและ Differential Diagnosis",
      scenario:
        "หลังให้ Paracetamol ไข้ลดเหลือ 38.5°C เด็กดูดีขึ้น เล่นได้\n\nพ่อแม่ถามว่า:\n- ต้องเจาะเลือดหรือทำ lumbar puncture ไหม?\n- ต้อง CT scan สมองไหม?\n\nแพทย์ประจำบ้านเขียน order:\n- CBC, Blood culture, CRP\n- Serum electrolytes, Glucose\n- Urinalysis\n- Lumbar puncture\n- CT brain",
      question:
        "จง evaluate ว่า investigations ที่แพทย์ประจำบ้านสั่งเหมาะสมหรือไม่ ตาม AAP guideline สำหรับ simple febrile seizure",
      answer:
        "Evaluation ตาม AAP Clinical Practice Guideline (2011):\n\n1. CBC, CRP, Blood culture:\n   - ไม่จำเป็นเป็น routine สำหรับ simple febrile seizure\n   - ส่งเมื่อต้องการ evaluate สาเหตุของไข้ (ในกรณีนี้มี URI symptoms ชัดเจน)\n   - อาจส่ง CBC + CRP ได้ เพื่อช่วย assess severity ของ infection\n   - Blood culture: ส่งถ้าสงสัย bacteremia หรือ toxic-appearing child\n   - ในกรณีนี้: CBC + CRP พอรับได้, blood culture อาจไม่จำเป็น\n\n2. Serum electrolytes, Glucose:\n   - ไม่แนะนำเป็น routine ใน simple febrile seizure\n   - ส่งเมื่อมี prolonged seizure, poor intake, dehydration\n   - ผู้ป่วยรายนี้: อาจไม่จำเป็นถ้า intake ดี\n\n3. Urinalysis:\n   - อาจส่งได้เพื่อ evaluate สาเหตุของไข้ (แยก UTI)\n   - โดยเฉพาะในเด็กที่ไม่มี obvious source of fever\n   - กรณีนี้มี URI ชัดเจน แต่ส่ง UA ก็ไม่ผิด\n\n4. Lumbar puncture (LP): ไม่จำเป็น\n   - AAP guideline: LP ไม่แนะนำเป็น routine ใน simple febrile seizure ในเด็ก 6-60 เดือน\n   - พิจารณา LP เมื่อ:\n     - มี meningeal signs (neck stiffness, Kernig's, Brudzinski's positive)\n     - Toxic-appearing child\n     - Complex febrile seizure\n     - อายุ < 12 เดือนที่ยังไม่ได้ Hib/PCV vaccine\n     - ได้ antibiotics ก่อนหน้า (อาจ mask meningitis)\n   - ผู้ป่วยรายนี้: ไม่มี meningeal signs, GCS 15, vaccinated → LP ไม่จำเป็น\n\n5. CT brain: ไม่จำเป็น\n   - ไม่แนะนำใน simple febrile seizure\n   - Neuroimaging พิจารณาเมื่อ:\n     - Focal seizure / focal neurological deficit\n     - Prolonged postictal state\n     - Signs of increased ICP (bulging fontanelle, papilledema)\n     - History of head trauma\n     - Abnormal head circumference\n   - ผู้ป่วยรายนี้: ไม่มี indication → CT ไม่จำเป็น\n\nRevised investigation plan:\n- ส่ง: CBC, CRP (evaluate infection severity)\n- พิจารณา: UA (ถ้าต้องการแยก UTI)\n- ไม่ส่ง: LP, CT brain, blood culture (ไม่มี indication)\n- ไม่จำเป็น: EEG ใน simple febrile seizure",
      key_points: [
        "Simple febrile seizure ไม่จำเป็นต้องทำ LP, CT brain, หรือ EEG เป็น routine",
        "LP พิจารณาเมื่อมี meningeal signs หรือ toxic-appearing child",
        "Unnecessary investigations เพิ่ม cost, pain, และ radiation exposure ในเด็ก",
        "AAP guideline ช่วยลด over-investigation ในเด็กที่มี simple febrile seizure",
      ],
      time_minutes: 10,
    },
    {
      part_number: 3,
      title: "ส่วนที่ 3: การจัดการ Recurrent Seizure ใน ER",
      scenario:
        "ขณะรอผล lab (2 ชั่วโมงหลังมาถึง ER) เด็กเกิดชักเกร็งกระตุกทั้งตัวอีกครั้ง\n- ชักเป็น generalized tonic-clonic\n- BT 39.2°C (ไข้ขึ้นอีก)\n- เริ่มชัก 14.25 น.\n- 14.28 น. (3 นาที): ยังชักอยู่\n- 14.30 น. (5 นาที): ยังชักอยู่ ไม่หยุดเอง\n\nผล lab ที่กลับมา:\n- CBC: WBC 12,500 (Neutrophil 55%, Lymphocyte 38%), Hb 12.0, Plt 320,000\n- CRP 15 mg/L\n- UA: ปกติ",
      question:
        "จงจัดการการชักอย่างเป็นระบบตาม protocol (status epilepticus management) และจำแนกว่าตอนนี้เป็น simple หรือ complex febrile seizure",
      answer:
        "การจำแนก: เปลี่ยนเป็น Complex febrile seizure\n- เหตุผล: ชักซ้ำ > 1 ครั้งภายใน 24 ชั่วโมง (recurrent seizure within same febrile illness)\n\nStatus epilepticus management protocol:\n\n0-5 นาที (Stabilization phase):\n- ABCs: Airway suction, O2 via face mask, left lateral position\n- Check glucose: ถ้า < 60 mg/dL → Dextrose 10% 2-5 mL/kg IV\n- Establish IV access (ถ้ายังไม่มี)\n- Monitor: SpO2, HR, BP\n- จับเวลาการชัก\n\n5 นาที - First-line (Benzodiazepine):\n- IV Diazepam 0.2-0.3 mg/kg IV (= 2.4-3.6 mg สำหรับ 12 kg) ให้ช้าๆ ใน 2-3 นาที\n  หรือ\n- IV Lorazepam 0.1 mg/kg IV (= 1.2 mg สำหรับ 12 kg)\n  หรือ\n- ถ้าไม่มี IV access: Diazepam rectal 0.5 mg/kg (= 6 mg) หรือ Midazolam buccal/intranasal 0.2 mg/kg (= 2.4 mg)\n\n- รอ 5 นาที ดู response\n\n10 นาที - ถ้ายังชักอยู่ (Repeat benzodiazepine):\n- ให้ Diazepam IV ซ้ำอีก 1 dose (เท่าเดิม)\n- Maximum 2 doses ของ benzodiazepine\n- เตรียม second-line agent\n\n15-20 นาที - Second-line (ถ้า benzodiazepine ไม่ได้ผล):\n- IV Phenytoin (Fosphenytoin) 20 mg PE/kg IV infusion ใน 20 นาที\n  หรือ\n- IV Phenobarbital 20 mg/kg IV infusion ใน 20 นาที\n  หรือ\n- IV Levetiracetam 40-60 mg/kg IV infusion ใน 15 นาที\n- Monitor: cardiac rhythm, BP, respiratory status\n\n30-60 นาที - Refractory status epilepticus:\n- Intubation + ICU admission\n- Midazolam continuous infusion 0.1-0.4 mg/kg/hr\n- หรือ Pentobarbital/Thiopental infusion\n- Continuous EEG monitoring\n\nหลังชักหยุด:\n- Monitor closely x 4-6 ชั่วโมง\n- Reassess neurological status\n- ลดไข้: Paracetamol 15 mg/kg PR + tepid sponge\n- พิจารณา LP เนื่องจากเปลี่ยนเป็น complex febrile seizure\n  (โดยเฉพาะถ้า prolonged postictal state หรือ clinical concern)",
      key_points: [
        "ชักซ้ำใน 24 ชั่วโมง เปลี่ยน classification เป็น complex febrile seizure",
        "First-line: IV Diazepam 0.2-0.3 mg/kg หรือ Lorazepam 0.1 mg/kg",
        "ถ้าไม่มี IV access: rectal Diazepam หรือ buccal/intranasal Midazolam",
        "ชักนาน > 5 นาทีต้องให้ยากันชัก ไม่ควรรอให้หยุดเอง",
      ],
      time_minutes: 10,
    },
    {
      part_number: 4,
      title: "ส่วนที่ 4: การให้คำปรึกษาพ่อแม่ (Parent Counseling)",
      scenario:
        "หลังให้ IV Diazepam 1 dose ชักหยุดภายใน 1 นาที เด็กง่วงซึม (postictal state) ประมาณ 30 นาที แล้วฟื้นตัวดี GCS 15 ไม่มี neurological deficit\n\nตัดสินใจ admit สังเกตอาการ 24 ชั่วโมง เนื่องจากเป็น complex febrile seizure (recurrent)\n\nวันรุ่งขึ้น: ไข้ลดลง BT 37.5°C เด็กเล่นได้ปกติ ทานอาหารได้ดี ไม่ชักซ้ำ\n\nพ่อแม่กังวลมาก ถามคำถาม:\n1. \"ลูกจะเป็นโรคลมชักไหม?\"\n2. \"ต้องกินยากันชักไหม?\"\n3. \"ครั้งหน้าไข้สูงจะชักอีกไหม? จะป้องกันได้ยังไง?\"\n4. \"ลูกจะพัฒนาการช้าหรือสมองเสียหายไหม?\"",
      question:
        "จงตอบคำถามพ่อแม่ทั้ง 4 ข้อ โดยอ้างอิงหลักฐานทางการแพทย์ ให้เข้าใจง่าย",
      answer:
        "1. \"ลูกจะเป็นโรคลมชัก (epilepsy) ไหม?\"\n- ความเสี่ยงในการเกิด epilepsy ในเด็กที่มี simple febrile seizure = 1-2% (ใกล้เคียงประชากรทั่วไป 1%)\n- Complex febrile seizure: เพิ่มเป็น 2-5%\n- Risk factors ที่เพิ่มโอกาส epilepsy:\n  - Complex febrile seizure\n  - ประวัติ epilepsy ในครอบครัว\n  - Developmental delay ก่อนหน้า\n  - Febrile seizure ครั้งแรกก่อนอายุ 1 ปี\n- ลูกของคุณ: complex febrile seizure (recurrent) มีความเสี่ยงเพิ่มขึ้นเล็กน้อย แต่โอกาสส่วนใหญ่จะไม่เป็น epilepsy\n\n2. \"ต้องกินยากันชักไหม?\"\n- AAP ไม่แนะนำยากันชัก (ทั้ง continuous และ intermittent) สำหรับ simple febrile seizure\n- สำหรับ complex febrile seizure: ยังไม่แนะนำ continuous antiepileptic เป็น routine\n- ทางเลือก:\n  - Intermittent Diazepam rectal (0.5 mg/kg) หรือ oral (0.3 mg/kg) เมื่อเริ่มมีไข้\n  - พิจารณาในรายที่ชักซ้ำบ่อย, พ่อแม่วิตกกังวลมาก, หรืออยู่ไกลโรงพยาบาล\n  - ผลข้างเคียง: ง่วงซึม อาจ mask signs ของ serious illness\n- กรณีนี้: แนะนำ observation ก่อน ไม่จำเป็นต้องเริ่ม daily antiepileptic\n  - ให้ Diazepam rectal เตรียมไว้ที่บ้านสำหรับกรณีฉุกเฉิน\n\n3. \"ชักอีกไหม? ป้องกันอย่างไร?\"\n- โอกาสชักซ้ำ:\n  - หลัง first febrile seizure: 30% จะชักซ้ำ\n  - หลัง second febrile seizure: 50% จะชักซ้ำ (ผู้ป่วยรายนี้)\n  - มักหยุดเมื่ออายุ > 5-6 ปี\n- การป้องกัน:\n  - ลดไข้เมื่อเริ่มมีไข้: Paracetamol 10-15 mg/kg ทุก 4-6 ชม. หรือ Ibuprofen 5-10 mg/kg ทุก 6-8 ชม.\n  - แต่: Antipyretics ไม่ได้พิสูจน์ว่าป้องกันการชักได้ (เพราะ seizure มักเกิดตอนไข้ขึ้นเร็ว)\n  - เตรียม Diazepam rectal ไว้ที่บ้าน สอนพ่อแม่วิธีใช้\n\n4. \"สมองเสียหายไหม?\"\n- Simple febrile seizure ไม่ทำให้สมองเสียหาย หรือพัฒนาการช้า\n- การศึกษา long-term outcome: ไม่มีความแตกต่างใน IQ, academic performance, behavior\n- Complex febrile seizure: ไม่มีหลักฐานชัดเจนว่าทำให้เกิด brain damage\n- ข้อยกเว้น: Febrile status epilepticus (ชักนาน > 30 นาที) อาจมีผลต่อ hippocampus\n- สรุป: ลูกของคุณพัฒนาการปกติ และ febrile seizure ไม่ทำให้สมองเสียหาย",
      key_points: [
        "Simple febrile seizure ไม่เพิ่มความเสี่ยง epilepsy อย่างมีนัยสำคัญ (1-2%)",
        "AAP ไม่แนะนำ daily antiepileptic drug สำหรับ febrile seizure",
        "Antipyretics ไม่ได้พิสูจน์ว่าป้องกัน febrile seizure ได้",
        "Febrile seizure ไม่ทำให้เกิด brain damage หรือ developmental delay",
      ],
      time_minutes: 10,
    },
    {
      part_number: 5,
      title: "ส่วนที่ 5: Febrile Status Epilepticus",
      scenario:
        "3 เดือนต่อมา เด็กรายเดิมถูกนำส่ง ER อีกครั้ง\n\nประวัติ: มีไข้สูง ไอมาก มีเสมหะ 3 วัน วันนี้เกิดชักเกร็งกระตุกทั้งตัวที่บ้าน พ่อแม่ให้ Diazepam rectal 6 mg (ตามที่แพทย์สั่ง) ชักหยุดชั่วคราว 5 นาที แล้วชักอีก\n\nมาถึง ER เด็กยังชักอยู่ รวมเวลาชักทั้งหมดประมาณ 20 นาที\n\nสัญญาณชีพ: BT 40.1°C, HR 165/min, SpO2 92% room air, RR 36/min\nGCS ไม่สามารถประเมินได้ขณะชัก\n\nPhysical exam (ระหว่างชัก):\n- Generalized tonic-clonic seizure\n- Bilateral ronchi, decreased breath sounds ที่ right lower lobe\n- No rash, no petechiae, no neck stiffness (ประเมินยากขณะชัก)",
      question:
        "จงจัดการ febrile status epilepticus และวางแผนการตรวจเพิ่มเติมหลังชักหยุด",
      answer:
        "Febrile Status Epilepticus (FSE): ชักต่อเนื่อง > 5 นาที (บาง definition > 30 นาที)\nผู้ป่วยชัก 20 นาที = FSE ชัดเจน\n\nImmediate management:\n\n1. ABCs:\n   - Airway: suction, jaw thrust ถ้าจำเป็น, NPO\n   - Breathing: O2 100% via non-rebreather mask → target SpO2 > 94%\n   - Circulation: IV access (ถ้ายังไม่มี → IO access), NS 20 mL/kg bolus\n   - เตรียม bag-valve-mask และ intubation equipment\n\n2. เนื่องจากได้ Diazepam rectal มาแล้ว 1 dose:\n   - ให้ IV Lorazepam 0.1 mg/kg (= 1.2 mg) หรือ IV Diazepam 0.2 mg/kg\n   - ถ้าชักไม่หยุดใน 5 นาที → second dose benzodiazepine\n\n3. ถ้ายังชักหลัง benzodiazepine 2 doses (Established SE):\n   - IV Levetiracetam 40 mg/kg (= 480 mg) infusion ใน 15 นาที\n   - หรือ IV Fosphenytoin 20 mg PE/kg infusion ใน 20 นาที\n   - หรือ IV Phenobarbital 20 mg/kg infusion ใน 20 นาที\n   - Cardiac monitoring ระหว่างให้ phenytoin\n\n4. ลดไข้ aggressive:\n   - Paracetamol 20 mg/kg PR (loading dose)\n   - Tepid sponge (ไม่ใช้ ice water)\n   - IV fluid ที่อุณหภูมิห้อง\n\n5. Check glucose: ถ้า < 60 mg/dL → D10W 2-5 mL/kg IV\n\n6. Refractory SE (ถ้ายังชักหลัง second-line):\n   - Intubation + ICU\n   - Midazolam infusion 0.1-0.4 mg/kg/hr\n   - Continuous EEG monitoring\n\nInvestigation หลังชักหยุด:\n\n1. จำเป็น:\n   - CBC, CRP, Blood culture (BT 40.1°C + respiratory symptoms)\n   - Electrolytes, Glucose, Ca, Mg\n   - Blood gas (assess respiratory status)\n   - CXR: สงสัย pneumonia (ronchi, decreased breath sounds R lower lobe)\n\n2. ควรทำ:\n   - Lumbar puncture: จำเป็นในกรณีนี้เนื่องจาก\n     - Febrile status epilepticus\n     - Prolonged seizure ต้องแยก meningitis/encephalitis\n     - ไม่สามารถ assess meningeal signs ได้ดีขณะ postictal\n   - (ทำหลัง patient stabilize และไม่มี signs of raised ICP)\n\n3. พิจารณา:\n   - CT brain ก่อน LP ถ้ามี signs of raised ICP\n   - EEG: หลังจาก status epilepticus ควรทำเพื่อ rule out subclinical seizures",
      key_points: [
        "Febrile status epilepticus ต้องจัดการเหมือน status epilepticus ทุกราย",
        "เด็กที่ได้ rectal Diazepam มาแล้ว ยังสามารถให้ IV benzodiazepine ได้",
        "LP ควรทำในกรณี febrile status epilepticus เพื่อแยก CNS infection",
        "Aggressive fever control ช่วย แต่ prioritize seizure termination ก่อน",
      ],
      time_minutes: 10,
    },
    {
      part_number: 6,
      title: "ส่วนที่ 6: การจำหน่ายและ Long-term Follow-up",
      scenario:
        'ชักหยุดหลังได้ IV Lorazepam + IV Levetiracetam\nAdmit PICU 2 วัน แล้วย้าย ward\n\nผลตรวจ:\n- LP: CSF WBC 2, Protein 25, Glucose 65 (blood glucose 100) → ปกติ\n- CXR: Right lower lobe consolidation → Community-acquired pneumonia\n- Blood culture: no growth\n- EEG (ทำวันที่ 3): No epileptiform discharges, normal background\n\nรักษา pneumonia ด้วย IV Ampicillin 5 วัน ไข้หายลง อาการดีขึ้น\n\nวันที่ 6: เด็กหายดี ทานอาหารได้ ไม่มีไข้ 48 ชม. ไม่ชักซ้ำ\nพัฒนาการปกติ ตรวจ neurological exam ปกติ\n\nPlan discharge\n\nพ่อแม่ถามว่า:\n- ต้องกินยากันชักต่อไหม?\n- เมื่อไรต้องพากลับมาพบแพทย์?\n- ต้องฉีดวัคซีนครบ หรือควรเลี่ยงวัคซีน "ที่ทำให้ไข้"?',
      question:
        "จงวางแผน discharge plan ตอบคำถามพ่อแม่ และให้ home seizure action plan",
      answer:
        "Discharge plan:\n\n1. ยาที่กลับบ้าน:\n   - Amoxicillin syrup 40 mg/kg/day divided TID x 5 วัน (complete antibiotics for pneumonia)\n   - Paracetamol syrup 15 mg/kg/dose PRN ทุก 4-6 ชม. เมื่อไข้ > 38°C\n   - Diazepam rectal 5 mg เตรียมไว้ที่บ้าน (สำหรับกรณีฉุกเฉิน)\n   - ไม่ต้องให้ daily antiepileptic drug\n\n2. ตอบคำถาม:\n\n   a) ยากันชัก:\n   - ไม่จำเป็นต้องกินยากันชักต่อเนื่อง\n   - EEG ปกติ สนับสนุนว่าไม่ใช่ epilepsy\n   - Febrile seizure เป็น age-dependent condition ที่จะหายไปเมื่อโตขึ้น\n   - มี Diazepam rectal เตรียมไว้สำหรับ rescue ถ้าชักนาน > 5 นาที\n   - พิจารณา intermittent oral Diazepam เมื่อมีไข้ (discuss risk/benefit กับพ่อแม่)\n\n   b) กลับมาพบแพทย์:\n   - นัดตรวจ 1 สัปดาห์: ตรวจ follow-up pneumonia, ประเมินทั่วไป\n   - นัด 1 เดือน: ประเมินพัฒนาการ, ตอบคำถามเพิ่มเติม\n   - มาทันทีถ้า: ชักอีก, ไข้สูงไม่ลง, ซึม ไม่กินนม/อาหาร, ผื่นจ้ำเลือด, หายใจลำบาก\n\n   c) วัคซีน:\n   - ฉีดวัคซีนครบตามเกณฑ์ได้ตามปกติ\n   - Febrile seizure ไม่ใช่ข้อห้ามในการฉีดวัคซีน (AAP/ACIP)\n   - วัคซีนที่อาจทำให้ไข้: DTP, MMR, Varicella → ไม่ต้องเลี่ยง\n   - อาจให้ Paracetamol prophylaxis 15 mg/kg ก่อนหรือหลังฉีดวัคซีน เพื่อลดไข้\n   - DTaP preferred over DTPw (less febrile reactions)\n\n3. Home seizure action plan (ให้เป็นเอกสาร):\n\n   เมื่อลูกชัก:\n   - วางลูกนอนตะแคง บนพื้นที่ปลอดภัย\n   - จับเวลา\n   - ห้ามงัดปาก ห้ามให้น้ำ/ยาทางปาก\n   - ถ้าชักไม่หยุดใน 5 นาที → ให้ Diazepam rectal 5 mg\n   - โทร 1669 หรือพาส่ง ER ถ้า:\n     - ชักนาน > 5 นาที\n     - ชักไม่หยุดหลังให้ Diazepam rectal\n     - ชักซ้ำหลายครั้ง\n     - หลังชักซึมมากผิดปกติ > 30 นาที\n     - ชักครั้งแรกในชีวิต\n\n   การดูแลเมื่อมีไข้:\n   - ให้ Paracetamol ทันทีเมื่อเริ่มมีไข้ > 38°C\n   - เช็ดตัวลดไข้ด้วยน้ำอุ่น\n   - ดื่มน้ำมากๆ\n   - สวมเสื้อผ้าบาง ไม่ห่มหนา\n   - ถ้ากังวลมาก อาจให้ Diazepam oral 0.3 mg/kg เมื่อเริ่มมีไข้ (ตาม order แพทย์)\n\n4. Follow-up plan:\n   - Pediatrician follow-up 1 สัปดาห์ + 1 เดือน\n   - Pediatric neurologist referral ถ้ามี: ชักซ้ำบ่อย, พัฒนาการผิดปกติ, หรือ focal features\n   - Febrile seizure มักหยุดเมื่ออายุ > 5-6 ปี",
      key_points: [
        "Febrile seizure ไม่ใช่ข้อห้ามในการฉีดวัคซีน",
        "Home seizure action plan ช่วยให้พ่อแม่มั่นใจและจัดการได้ถูกต้อง",
        "Rectal Diazepam เตรียมไว้ที่บ้านสำหรับ rescue เมื่อชัก > 5 นาที",
        "Febrile seizure เป็น age-dependent condition มักหายไปเมื่ออายุ > 5-6 ปี",
      ],
      time_minutes: 10,
    },
  ],
};

// ============================================================
// Main seeding function
// ============================================================

async function main() {
  // Step 1: Query existing exams
  console.log("Querying existing exams...");
  const { data: exams, error: examsError } = await supabase
    .from("exams")
    .select("id, title, category, status");

  if (examsError) {
    console.error("Error fetching exams:", examsError);
    process.exit(1);
  }

  console.log(`Found ${exams.length} exams:`);
  exams.forEach((e) => console.log(`  - [${e.id}] ${e.title} (${e.category}, ${e.status})`));

  // Step 2: Match exams to part data
  const examTitleMap = {
    "ไส้ติ่งอักเสบเฉียบพลัน (Acute Appendicitis)": null,
    "กระดูกต้นขาหัก (Femoral Shaft Fracture)": null,
    "ครรภ์เป็นพิษ (Preeclampsia)": null,
    "ไข้ชัก (Febrile Seizure) ในเด็ก": null,
  };

  for (const exam of exams) {
    for (const key of Object.keys(examTitleMap)) {
      if (exam.title.includes(key) || key.includes(exam.title) || exam.title === key) {
        examTitleMap[key] = exam.id;
      }
    }
  }

  // Try partial matching if exact match fails
  const keywords = {
    "ไส้ติ่งอักเสบเฉียบพลัน (Acute Appendicitis)": ["ไส้ติ่ง", "Appendicitis"],
    "กระดูกต้นขาหัก (Femoral Shaft Fracture)": ["กระดูกต้นขา", "Femoral"],
    "ครรภ์เป็นพิษ (Preeclampsia)": ["ครรภ์เป็นพิษ", "Preeclampsia"],
    "ไข้ชัก (Febrile Seizure) ในเด็ก": ["ไข้ชัก", "Febrile Seizure"],
  };

  for (const [key, kws] of Object.entries(keywords)) {
    if (!examTitleMap[key]) {
      for (const exam of exams) {
        if (kws.some((kw) => exam.title.includes(kw))) {
          examTitleMap[key] = exam.id;
          break;
        }
      }
    }
  }

  console.log("\nMatched exams:");
  for (const [title, id] of Object.entries(examTitleMap)) {
    console.log(`  ${id ? "✓" : "✗"} ${title} → ${id || "NOT FOUND"}`);
  }

  const unmatchedExams = Object.entries(examTitleMap).filter(([, id]) => !id);
  if (unmatchedExams.length > 0) {
    console.error(`\nERROR: Could not match ${unmatchedExams.length} exam(s). Aborting.`);
    process.exit(1);
  }

  // Step 3: Delete existing parts for these exams (if any)
  const examIds = Object.values(examTitleMap);
  console.log("\nDeleting existing exam_parts for these exams...");
  const { error: deleteError } = await supabase
    .from("exam_parts")
    .delete()
    .in("exam_id", examIds);

  if (deleteError) {
    console.error("Error deleting existing parts:", deleteError);
    process.exit(1);
  }
  console.log("Existing parts deleted.");

  // Step 4: Insert new parts
  let totalInserted = 0;
  for (const [examTitle, parts] of Object.entries(examPartsData)) {
    const examId = examTitleMap[examTitle];
    console.log(`\nInserting 6 parts for: ${examTitle}`);

    const rows = parts.map((part) => ({
      exam_id: examId,
      part_number: part.part_number,
      title: part.title,
      scenario: part.scenario,
      question: part.question,
      answer: part.answer,
      key_points: part.key_points,
      time_minutes: part.time_minutes,
    }));

    const { data: inserted, error: insertError } = await supabase
      .from("exam_parts")
      .insert(rows)
      .select("id, part_number");

    if (insertError) {
      console.error(`  Error inserting parts for ${examTitle}:`, insertError);
      process.exit(1);
    }

    console.log(`  Inserted ${inserted.length} parts`);
    totalInserted += inserted.length;
  }

  console.log(`\n=== Done! Inserted ${totalInserted} exam parts total ===`);
}

main().catch((err) => {
  console.error("Fatal error:", err);
  process.exit(1);
});
