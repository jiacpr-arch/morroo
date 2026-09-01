import type { Exam, ExamPart } from "./types";

// Mock data for development without Supabase
export const MOCK_EXAMS: Exam[] = [
  {
    id: "exam-001",
    title: "ภาวะเลือดออกในทางเดินอาหารส่วนบน (Upper GI Bleeding)",
    category: "อายุรศาสตร์",
    difficulty: "hard",
    status: "published",
    is_free: true,
    publish_date: "2026-03-25",
    created_by: "admin",
    created_at: "2026-03-20T00:00:00Z",
  },
  {
    id: "exam-002",
    title: "โรคปอดอักเสบรุนแรง (Severe Community-Acquired Pneumonia)",
    category: "อายุรศาสตร์",
    difficulty: "hard",
    status: "published",
    is_free: false,
    publish_date: "2026-03-24",
    created_by: "admin",
    created_at: "2026-03-19T00:00:00Z",
  },
  {
    id: "exam-003",
    title: "ไส้ติ่งอักเสบเฉียบพลัน (Acute Appendicitis)",
    category: "ศัลยศาสตร์",
    difficulty: "medium",
    status: "published",
    is_free: true,
    publish_date: "2026-03-23",
    created_by: "admin",
    created_at: "2026-03-18T00:00:00Z",
  },
  {
    id: "exam-004",
    title: "ไข้ชัก (Febrile Seizure) ในเด็ก",
    category: "กุมารเวชศาสตร์",
    difficulty: "medium",
    status: "published",
    is_free: false,
    publish_date: "2026-03-22",
    created_by: "admin",
    created_at: "2026-03-17T00:00:00Z",
  },
  {
    id: "exam-005",
    title: "ครรภ์เป็นพิษ (Preeclampsia)",
    category: "สูติศาสตร์-นรีเวชวิทยา",
    difficulty: "hard",
    status: "published",
    is_free: false,
    publish_date: "2026-03-21",
    created_by: "admin",
    created_at: "2026-03-16T00:00:00Z",
  },
  {
    id: "exam-006",
    title: "กระดูกต้นขาหัก (Femoral Shaft Fracture)",
    category: "ออร์โธปิดิกส์",
    difficulty: "easy",
    status: "published",
    is_free: true,
    publish_date: "2026-03-20",
    created_by: "admin",
    created_at: "2026-03-15T00:00:00Z",
  },
];

export const MOCK_EXAM_PARTS: Record<string, ExamPart[]> = {
  "exam-001": [
    {
      id: "part-001-1",
      exam_id: "exam-001",
      part_number: 1,
      title: "ตอนที่ 1: ประวัติและการตรวจเบื้องต้น",
      scenario:
        "ชายไทยอายุ 55 ปี มาห้องฉุกเฉินด้วยอาการอาเจียนเป็นเลือดสดประมาณ 2 แก้ว เมื่อ 3 ชั่วโมงก่อนมาโรงพยาบาล มีประวัติปวดข้อเข่าเรื้อรัง ซื้อยา NSAIDs (Ibuprofen) กินเองมานาน 6 เดือน ดื่มเหล้าเป็นประจำ 1-2 แก้ว/วัน\n\nตรวจร่างกาย: BP 90/60 mmHg, HR 120 bpm, RR 24, Temp 37.2°C\nลักษณะทั่วไป: ซีด เหงื่อออก กระสับกระส่าย\nท้อง: กดเจ็บบริเวณ epigastrium ไม่มี guarding",
      question: "จงระบุปัญหาเร่งด่วนที่สุดของผู้ป่วยรายนี้ และแนวทางการ resuscitate เบื้องต้น",
      answer:
        "ปัญหาเร่งด่วนที่สุด: Hypovolemic shock จาก Upper GI bleeding\n\nแนวทาง Resuscitation:\n1. Airway: ประเมินทางเดินหายใจ วางท่าศีรษะสูง ป้องกัน aspiration\n2. Breathing: ให้ O2 supplement\n3. Circulation:\n   - เปิดเส้นเลือด IV 2 เส้น (large bore 16-18G)\n   - ให้ NSS หรือ Ringer's lactate bolus 1-2 L\n   - ส่ง CBC, BUN, Cr, Coagulation, Cross-match blood 4 units\n   - เตรียม Packed Red Cell สำหรับ transfusion\n4. ใส่ NG tube เพื่อ confirm upper GI source และ lavage\n5. ใส่ Foley catheter วัด urine output\n6. NPO\n7. เริ่ม IV PPI: Omeprazole 80 mg IV bolus แล้วตามด้วย 8 mg/hr drip",
      key_points: [
        "Hematemesis + Hypotension + Tachycardia = Hypovolemic shock",
        "ABC approach ต้องทำทันที",
        "IV PPI high dose ลด rebleeding rate",
        "Cross-match blood เตรียมไว้เสมอ",
      ],
      time_minutes: 10,
      created_at: "2026-03-20T00:00:00Z",
    },
    {
      id: "part-001-2",
      exam_id: "exam-001",
      part_number: 2,
      title: "ตอนที่ 2: การส่งตรวจและผลการตรวจ",
      scenario:
        "หลังให้สารน้ำ 2,000 mL: BP 100/70 mmHg, HR 100 bpm\n\nผล Lab:\n- Hb 7.2 g/dL (baseline ไม่ทราบ)\n- Hct 22%\n- Platelet 180,000\n- BUN 45 mg/dL, Cr 1.1 mg/dL\n- PT/INR ปกติ\n\nNG tube aspiration: ได้เลือดสดและ coffee-ground material ประมาณ 500 mL",
      question: "จงวิเคราะห์ผลการตรวจและวางแผนการรักษาต่อไป รวมถึงระบุ timing สำหรับ endoscopy",
      answer:
        "วิเคราะห์ผล:\n- Hb 7.2: severe anemia ต้อง transfuse PRC\n- BUN/Cr ratio สูง (>20:1): สนับสนุน upper GI bleeding\n- Coagulation ปกติ: ไม่มี coagulopathy\n- NG aspirate เป็นเลือดสด: active bleeding\n\nแผนการรักษา:\n1. Transfuse PRC เป้า Hb > 7-8 g/dL (อย่างน้อย 2 units)\n2. ต่อ IV PPI drip\n3. ปรึกษา GI สำหรับ Emergency EGD\n4. Timing: EGD ควรทำภายใน 12-24 ชั่วโมง (urgent endoscopy)\n   - หากยังมี hemodynamic instability หลัง resuscitation → ทำภายใน 12 ชม.\n5. แจ้ง ICU เตรียม admit\n6. งด NSAIDs ทันที",
      key_points: [
        "BUN/Cr ratio >20:1 ชี้นำ upper GI source",
        "Transfusion threshold: Hb < 7 g/dL ในคนปกติ",
        "Urgent EGD ภายใน 12-24 ชม.",
        "หยุด NSAIDs ทันที — เป็นสาเหตุสำคัญ",
      ],
      time_minutes: 10,
      created_at: "2026-03-20T00:00:00Z",
    },
    {
      id: "part-001-3",
      exam_id: "exam-001",
      part_number: 3,
      title: "ตอนที่ 3: ผลการส่องกล้อง (EGD)",
      scenario:
        "ผล EGD พบ:\n- Gastric ulcer ขนาด 2 cm ที่ lesser curvature ของ stomach\n- Forrest classification IIa (visible vessel without active bleeding)\n- ไม่พบ esophageal varices\n- Duodenum ปกติ",
      question: "จง interpret ผล EGD และระบุแนวทางการรักษาผ่านการส่องกล้อง (endoscopic treatment) ที่เหมาะสม",
      answer:
        "Interpretation:\n- Gastric ulcer Forrest IIa: มี visible vessel = high risk for rebleeding (43%)\n- ไม่มี varices → ตัด portal hypertension ออก\n- สาเหตุน่าจะมาจาก NSAID-induced gastropathy\n\nEndoscopic Treatment:\n1. Dual therapy แนะนำ:\n   - Epinephrine injection (1:10,000) รอบแผล\n   - ตามด้วย Thermal coagulation (heater probe) หรือ Hemoclip\n2. Forrest IIa จำเป็นต้องได้รับ endoscopic hemostasis\n3. หลังทำ: ต่อ IV PPI high dose drip 72 ชม.\n4. ส่ง biopsy ขอบแผลเพื่อ:\n   - ตรวจ H. pylori (CLO test)\n   - R/O malignancy (gastric ulcer ต้อง biopsy เสมอ)",
      key_points: [
        "Forrest IIa = visible vessel = high rebleed risk",
        "Dual endoscopic therapy ดีกว่า monotherapy",
        "Gastric ulcer ต้อง biopsy ทุกครั้ง R/O malignancy",
        "IV PPI drip ต่อ 72 ชม. หลัง endoscopic hemostasis",
      ],
      time_minutes: 10,
      created_at: "2026-03-20T00:00:00Z",
    },
    {
      id: "part-001-4",
      exam_id: "exam-001",
      part_number: 4,
      title: "ตอนที่ 4: การรักษาหลัง Endoscopy",
      scenario:
        "หลัง endoscopic treatment สำเร็จ ผู้ป่วย admit ICU\n\nวันที่ 2: Vital signs stable, ไม่มี rebleeding\nผล CLO test: Positive for H. pylori\nPathology: Chronic gastritis with no malignancy",
      question: "วางแผนการรักษาต่อเนื่อง ทั้ง short-term และ long-term",
      answer:
        "Short-term (ในโรงพยาบาล):\n1. ต่อ IV PPI drip ครบ 72 ชม. แล้วเปลี่ยนเป็น oral PPI\n2. เริ่มจิบน้ำ → liquid diet → soft diet ตามลำดับ\n3. Monitor: vital signs, Hb ทุก 12-24 ชม., สังเกตถ่ายดำ\n4. ย้ายออกจาก ICU เมื่อ stable 24-48 ชม.\n\nLong-term:\n1. H. pylori eradication: Triple therapy 14 วัน\n   - PPI (Omeprazole 20 mg bid)\n   - Amoxicillin 1 g bid\n   - Clarithromycin 500 mg bid\n2. ต่อ PPI อีก 8 สัปดาห์ (total) เพื่อ ulcer healing\n3. Follow-up EGD ที่ 8-12 สัปดาห์: confirm ulcer healing + repeat biopsy\n4. Confirm H. pylori eradication: UBT หรือ Stool Ag หลัง Rx 4 สัปดาห์\n5. หยุด NSAIDs ถาวร → เปลี่ยนเป็น Paracetamol หรือ COX-2 inhibitor + PPI",
      key_points: [
        "H. pylori eradication: Triple therapy 14 วัน",
        "PPI ต้องกินต่อ 8 สัปดาห์ healing ulcer",
        "Follow-up EGD + biopsy จำเป็นสำหรับ gastric ulcer",
        "หยุด NSAIDs และหา alternative",
      ],
      time_minutes: 10,
      created_at: "2026-03-20T00:00:00Z",
    },
    {
      id: "part-001-5",
      exam_id: "exam-001",
      part_number: 5,
      title: "ตอนที่ 5: ภาวะแทรกซ้อน",
      scenario:
        'วันที่ 3 ขณะ ward: ผู้ป่วยอาเจียนเป็นเลือดสดอีกครั้งประมาณ 300 mL\nBP ลดลงเป็น 85/55 mmHg, HR 125 bpm\nHb ลดจาก 9.2 เป็น 7.5 g/dL',
      question: "วินิจฉัยภาวะแทรกซ้อนและวางแผนการจัดการ",
      answer:
        "วินิจฉัย: Rebleeding จาก gastric ulcer\n\nการจัดการ:\n1. Resuscitate ใหม่:\n   - IV fluid bolus\n   - Transfuse PRC\n   - ย้าย ICU\n2. ปรึกษา GI สำหรับ Repeat (Second-look) endoscopy\n3. Repeat EGD:\n   - ลอง endoscopic hemostasis อีกครั้ง\n   - ถ้าสำเร็จ → continue medical management\n4. หาก endoscopic treatment ล้มเหลว:\n   - Interventional radiology: Angiographic embolization\n   - หรือ Surgery: Partial gastrectomy / Oversewing of ulcer\n5. พิจารณา risk factors:\n   - Large ulcer (>2 cm)\n   - Forrest IIa\n   - Hemodynamic instability at presentation\n   → เป็น high risk for rebleeding อยู่แล้ว",
      key_points: [
        "Rebleeding rate หลัง endoscopic Rx ~10-20%",
        "Repeat endoscopy ก่อน surgery",
        "Angiographic embolization เป็น alternative ก่อน surgery",
        "Risk factors: ulcer size >2cm, Forrest Ia/Ib/IIa, hemodynamic instability",
      ],
      time_minutes: 10,
      created_at: "2026-03-20T00:00:00Z",
    },
    {
      id: "part-001-6",
      exam_id: "exam-001",
      part_number: 6,
      title: "ตอนที่ 6: การดูแลก่อนจำหน่าย",
      scenario:
        "หลัง repeat endoscopy สำเร็จ ผู้ป่วย stable ไม่มี rebleeding อีก 5 วัน\nรับประทานอาหารได้ดี เตรียมจำหน่ายกลับบ้าน",
      question: "วางแผน discharge plan และ patient education",
      answer:
        "Discharge Plan:\n1. ยากลับบ้าน:\n   - Omeprazole 20 mg bid (ครบ 8 สัปดาห์)\n   - H. pylori triple therapy 14 วัน\n   - Paracetamol 500 mg prn สำหรับปวดข้อ\n2. นัดตรวจ:\n   - 2 สัปดาห์: ดูผล triple therapy, ตรวจ CBC\n   - 4 สัปดาห์หลังจบ Rx: UBT ตรวจ H. pylori eradication\n   - 8-12 สัปดาห์: Follow-up EGD + biopsy\n\nPatient Education:\n1. หยุด NSAIDs ถาวร — อธิบายอันตราย\n2. ลด/หยุดแอลกอฮอล์\n3. หยุดสูบบุหรี่ (ถ้ามี)\n4. อาการที่ต้องมาพบแพทย์ทันที:\n   - อาเจียนเป็นเลือด\n   - ถ่ายดำ (melena)\n   - เวียนศีรษะ หน้ามืด\n5. กินยาครบตามแพทย์สั่ง โดยเฉพาะ antibiotic\n6. อาหาร: ไม่จำเป็นต้อง restrict แต่หลีกเลี่ยงอาหารรสจัด ระยะแรก",
      key_points: [
        "Discharge medications ต้องครบ: PPI + H. pylori Rx",
        "Follow-up EGD จำเป็นสำหรับ gastric ulcer",
        "Patient education เรื่องหยุด NSAIDs สำคัญมาก",
        "Red flags ที่ต้องมาพบแพทย์ทันที",
      ],
      time_minutes: 10,
      created_at: "2026-03-20T00:00:00Z",
    },
  ],
  "exam-002": [
    {
      id: "part-002-1",
      exam_id: "exam-002",
      part_number: 1,
      title: "ตอนที่ 1: การซักประวัติและตรวจร่างกาย",
      scenario:
        "ชายไทยอายุ 68 ปี โรคประจำตัว: เบาหวานชนิดที่ 2 (15 ปี) และ COPD (สูบบุหรี่ 40 pack-years) มาห้องฉุกเฉินด้วยไข้สูง 39.5°C หนาวสั่น 2 วัน ไอมีเสมหะเหลืองเขียวข้น หายใจหอบเหนื่อย\n\nตรวจร่างกาย: BP 85/50 mmHg, HR 130 bpm, RR 32, SpO2 85% RA\nปอด: Crackles Lt lower lobe, bronchial breath sound\nExtremities: Capillary refill > 3 sec",
      question: "จงวิเคราะห์ปัญหาของผู้ป่วย ประเมินความรุนแรง และวางแผน initial management",
      answer:
        "วิเคราะห์ปัญหา:\n- Community-Acquired Pneumonia (CAP) with Septic Shock\n- Underlying: DM, COPD → immunocompromised host\n\nประเมินความรุนแรง (CURB-65):\n- Confusion: ต้อง assess เพิ่ม\n- Urea: ต้องรอ lab\n- RR ≥ 30: +1\n- BP systolic < 90: +1\n- Age ≥ 65: +1\n→ อย่างน้อย CURB-65 = 3 → Severe, ICU admission\n\nInitial Management:\n1. Airway & Breathing:\n   - O2 high flow, target SpO2 ≥ 92%\n   - เตรียม Non-invasive ventilation หรือ intubation\n2. Circulation (Sepsis bundle - Hour-1):\n   - IV fluid bolus 30 mL/kg crystalloid\n   - เก็บ Blood culture 2 sets ก่อนให้ ATB\n   - ให้ IV antibiotics ภายใน 1 ชั่วโมง\n   - วัด Lactate\n   - ถ้า MAP < 65 หลังให้ fluid → start Norepinephrine\n3. Lab: CBC, BUN, Cr, Electrolytes, LFT, Lactate, ABG, Procalcitonin\n4. CXR portable",
      key_points: [
        "CAP + Septic shock = medical emergency",
        "CURB-65 ≥ 3 → ICU admission",
        "Hour-1 Sepsis Bundle: culture → ATB → fluid → lactate → vasopressor",
        "DM + COPD = risk factors for severe CAP",
      ],
      time_minutes: 10,
      created_at: "2026-03-19T00:00:00Z",
    },
    {
      id: "part-002-2",
      exam_id: "exam-002",
      part_number: 2,
      title: "ตอนที่ 2: ผลการตรวจทางห้องปฏิบัติการ",
      scenario:
        "ผล Lab:\n- WBC 22,000 (Neutrophil 90%)\n- Hb 11.5, Plt 145,000\n- BUN 38, Cr 2.1 (baseline 1.0)\n- Lactate 4.5 mmol/L\n- Procalcitonin 15.2 ng/mL\n- ABG: pH 7.28, PaO2 55, PaCO2 50, HCO3 18\n- CXR: Dense consolidation left lower lobe with air bronchogram\n- Blood glucose: 385 mg/dL",
      question: "วิเคราะห์ผล lab ทั้งหมดและเลือก empirical antibiotics ที่เหมาะสม",
      answer:
        "วิเคราะห์ผล Lab:\n1. Leukocytosis + Left shift: bacterial infection\n2. AKI (Cr 2.1 จาก 1.0): sepsis-related AKI\n3. Lactate 4.5: tissue hypoperfusion → septic shock\n4. Procalcitonin 15.2: สูงมาก สนับสนุน bacterial infection\n5. ABG: Mixed respiratory + metabolic acidosis\n   - Type 2 respiratory failure (PaCO2 สูง จาก COPD decompensation)\n6. CXR: Lobar consolidation → typical bacterial pneumonia\n7. Hyperglycemia: DM ที่ decompensate จาก sepsis\n\nEmpirical Antibiotics สำหรับ Severe CAP (ICU):\n- Beta-lactam: Ceftriaxone 2 g IV OD หรือ Ampicillin-Sulbactam\n- PLUS Macrolide: Azithromycin 500 mg IV OD\n- หรือ Beta-lactam + Respiratory fluoroquinolone (Levofloxacin 750 mg IV OD)\n\nพิจารณาเพิ่ม:\n- ถ้ามี risk factor MRSA → เพิ่ม Vancomycin\n- ถ้ามี risk factor Pseudomonas → เปลี่ยนเป็น Piperacillin-Tazobactam\n\nอื่นๆ:\n- Insulin drip สำหรับ hyperglycemia\n- Monitor renal function closely\n- Consider BiPAP หรือ intubation (PaCO2 สูง + acidosis)",
      key_points: [
        "Lactate >4 = severe sepsis/septic shock",
        "Severe CAP: Beta-lactam + Macrolide หรือ Respiratory FQ",
        "ABG mixed acidosis = poor prognosis",
        "ต้อง control blood sugar ใน sepsis + DM",
      ],
      time_minutes: 10,
      created_at: "2026-03-19T00:00:00Z",
    },
    {
      id: "part-002-3",
      exam_id: "exam-002",
      part_number: 3,
      title: "ตอนที่ 3: การจัดการใน ICU",
      scenario:
        "หลังให้ IV fluid 2L + Norepinephrine: MAP 68 mmHg\nหลังใส่ BiPAP: SpO2 92%, PaCO2 ลดเป็น 42\nให้ Ceftriaxone + Azithromycin IV แล้ว\nInsulin drip กำลัง titrate\n\n6 ชม.ต่อมา: ผู้ป่วยสับสน GCS ลดจาก 14 เป็น 10 (E3V3M4)\nSpO2 ลดเป็น 86% แม้อยู่บน BiPAP",
      question: "ประเมินสถานการณ์ที่เปลี่ยนแปลงและวางแผนการจัดการ",
      answer:
        "ประเมินสถานการณ์:\n- Clinical deterioration: GCS ลดลง + SpO2 ลดลง\n- สาเหตุที่เป็นไปได้:\n  1. Worsening pneumonia / ARDS\n  2. Septic encephalopathy\n  3. Hypoglycemia จาก insulin drip\n  4. New complication: empyema, PE\n\nการจัดการ:\n1. Immediate:\n   - Intubation + Mechanical ventilation (GCS ≤ 10 + respiratory failure)\n   - เช็ค blood sugar STAT (R/O hypoglycemia)\n   - ABG หลัง intubation\n2. Ventilator setting:\n   - Lung protective ventilation: TV 6-8 mL/kg IBW\n   - PEEP 5-10 cmH2O titrate ตาม SpO2\n   - Target: SpO2 ≥ 92%, Pplat < 30\n3. Reassess:\n   - Repeat CXR: ดู progression, effusion, ARDS\n   - พิจารณา CT chest ถ้า stable พอ\n   - Sputum culture + sensitivity\n   - ถ้า P/F ratio < 200 → moderate-severe ARDS\n4. เพิ่ม vasopressor ถ้า MAP ลดลง\n5. Reassess antibiotic coverage → พิจารณา broaden",
      key_points: [
        "GCS ≤ 10 + Respiratory failure → intubate",
        "Lung protective ventilation: TV 6-8 mL/kg IBW",
        "ต้อง R/O hypoglycemia ใน DM on insulin drip",
        "P/F ratio < 200 = moderate-severe ARDS",
      ],
      time_minutes: 10,
      created_at: "2026-03-19T00:00:00Z",
    },
    {
      id: "part-002-4",
      exam_id: "exam-002",
      part_number: 4,
      title: "ตอนที่ 4: ผลเพาะเชื้อและปรับยา",
      scenario:
        "วันที่ 3 ใน ICU:\n- Blood culture (2/2 ขวด): Streptococcus pneumoniae — Penicillin sensitive\n- Sputum culture: S. pneumoniae (consistent)\n- CXR: ลุกลามเป็น bilateral infiltrates\n- P/F ratio: 180 → Moderate ARDS\n- Cr คงที่ที่ 1.8 (ดีขึ้นจาก 2.1)\n- ไข้ลดลง Tmax 38.2°C",
      question: "ปรับแผนการรักษาตามผลเพาะเชื้อ และจัดการ ARDS",
      answer:
        "ปรับ Antibiotics (De-escalation):\n1. เนื่องจากเป็น Penicillin-sensitive S. pneumoniae:\n   - เปลี่ยนเป็น Penicillin G IV 2 ล้านยูนิต q4h\n   - หรือ Ampicillin IV 2 g q6h\n   - หรือ ต่อ Ceftriaxone ก็ได้ (ไม่จำเป็นต้อง de-escalate ถ้า clinical ดีขึ้น)\n2. หยุด Azithromycin ได้ (เนื่องจากรู้เชื้อแล้วและ sensitive to beta-lactam)\n3. ระยะเวลา: Minimum 5-7 วัน หรือจน clinical stable 48-72 ชม.\n\nจัดการ ARDS (Moderate: P/F 100-200):\n1. Lung protective ventilation (ต่อ):\n   - TV 6 mL/kg IBW\n   - Titrate PEEP ตาม FiO2-PEEP table\n   - Pplat target < 30 cmH2O\n2. Conservative fluid strategy (เป้า CVP ต่ำ)\n3. พิจารณา Prone positioning 12-16 ชม./วัน\n   (Evidence ดีสำหรับ moderate-severe ARDS)\n4. Sedation vacation daily\n5. DVT prophylaxis\n6. Stress ulcer prophylaxis\n7. Nutrition: เริ่ม enteral feeding",
      key_points: [
        "De-escalation เมื่อรู้เชื้อ = antibiotic stewardship",
        "S. pneumoniae = common cause of severe CAP",
        "Moderate ARDS: prone positioning มี evidence",
        "ICU bundle: DVT prophylaxis, stress ulcer prophylaxis, early nutrition",
      ],
      time_minutes: 10,
      created_at: "2026-03-19T00:00:00Z",
    },
    {
      id: "part-002-5",
      exam_id: "exam-002",
      part_number: 5,
      title: "ตอนที่ 5: การหย่าเครื่องช่วยหายใจ",
      scenario:
        "วันที่ 7: ผู้ป่วยดีขึ้นมาก\n- ไข้หาย 48 ชม.\n- P/F ratio 280\n- FiO2 0.4, PEEP 5\n- สามารถทำ Spontaneous Breathing Trial (SBT) ได้\n- GCS 15, hemodynamically stable\n- หยุด vasopressor แล้ว 24 ชม.",
      question: "อธิบาย criteria และขั้นตอนการ weaning จากเครื่องช่วยหายใจ",
      answer:
        "Criteria สำหรับ SBT (Readiness to wean):\n✓ สาเหตุที่ใส่ท่อดีขึ้น/หายแล้ว\n✓ สามารถหายใจเองได้: P/F > 200, FiO2 ≤ 0.4, PEEP ≤ 5-8\n✓ Hemodynamically stable: ไม่ได้ vasopressor\n✓ GCS ≥ 8, สามารถ protect airway ได้\n✓ ไม่มีไข้สูง\n→ ผู้ป่วยรายนี้ผ่าน criteria ทุกข้อ\n\nขั้นตอน SBT:\n1. วิธี: T-piece trial หรือ PSV 5-7 cmH2O + PEEP 0-5 for 30-120 นาที\n2. ระหว่าง SBT สังเกต:\n   - RR < 35/min\n   - SpO2 ≥ 90%\n   - HR ไม่เปลี่ยนเกิน 20%\n   - ไม่มี accessory muscle use\n   - RSBI (RR/TV) < 105\n3. ถ้าผ่าน SBT → Extubation\n4. Pre-extubation:\n   - Cuff leak test (ถ้าใส่ท่อนาน > 48 ชม.)\n   - Elevate HOB 30-45°\n   - Suction secretions\n   - NPO 4-6 ชม.\n5. Post-extubation:\n   - O2 supplement\n   - Monitor closely 24-48 ชม.\n   - พิจารณา High-flow nasal cannula ใน high-risk patient (COPD + age)\n   - Reintubation rate ~10-15%\n\nข้อควรระวังในผู้ป่วยรายนี้:\n- COPD: risk of post-extubation failure สูง → เตรียม NIV standby\n- DM: ต้อง control sugar ต่อ",
      key_points: [
        "SBT criteria: cause resolved, oxygenation OK, hemodynamic stable, neurologic OK",
        "RSBI < 105 = favorable for extubation",
        "COPD patients: เตรียม NIV standby หลัง extubation",
        "Monitor 24-48 ชม. หลัง extubation",
      ],
      time_minutes: 10,
      created_at: "2026-03-19T00:00:00Z",
    },
    {
      id: "part-002-6",
      exam_id: "exam-002",
      part_number: 6,
      title: "ตอนที่ 6: การวางแผนจำหน่ายและป้องกัน",
      scenario:
        "วันที่ 12: Extubation สำเร็จ ย้ายจาก ICU ไป ward\nวันที่ 15: เดินได้ ไม่มีไข้ รับประทานอาหารได้ดี\nSpO2 95% room air\nCXR: infiltrate ลดลงมาก\nCr กลับมา 1.1",
      question: "วางแผน discharge plan, follow-up, และมาตรการป้องกัน",
      answer:
        "Discharge Plan:\n1. ยากลับบ้าน:\n   - ATB oral (Amoxicillin) ครบ course รวม 7-10 วัน\n   - DM medications: ปรับ dose insulin/OHA ตามระดับน้ำตาล\n   - COPD medications: ทบทวน inhaler technique\n   - Paracetamol prn\n2. Follow-up appointments:\n   - 1-2 สัปดาห์: ตรวจทั่วไป, CBC, BUN/Cr\n   - 4-6 สัปดาห์: CXR เพื่อ confirm resolution\n   - Endocrinologist: ปรับ DM management\n   - Pulmonologist: COPD management + PFT\n\nมาตรการป้องกัน:\n1. Vaccination (สำคัญมาก):\n   - Pneumococcal vaccine: PCV20 หรือ PCV15 + PPSV23\n   - Influenza vaccine ทุกปี\n   - COVID-19 vaccine ตาม schedule\n2. Smoking cessation:\n   - Counseling + Nicotine replacement therapy\n   - Varenicline พิจารณาถ้า highly motivated\n3. DM optimization:\n   - Target HbA1c < 7-8% (ในผู้สูงอายุ)\n   - เน้น self-monitoring blood glucose\n4. COPD optimization:\n   - LABA/LAMA +/- ICS ตาม GOLD guidelines\n   - Pulmonary rehabilitation\n5. Nutrition counseling\n6. แนะนำให้มาพบแพทย์ทันทีถ้ามีไข้สูง ไอ หายใจหอบ",
      key_points: [
        "Pneumococcal + Influenza vaccine ป้องกัน recurrent CAP",
        "Smoking cessation = single most important intervention for COPD",
        "Follow-up CXR confirm resolution สำคัญ",
        "DM + COPD optimization ลด risk of recurrence",
      ],
      time_minutes: 10,
      created_at: "2026-03-19T00:00:00Z",
    },
  ],
};

export function getExams(): Exam[] {
  return MOCK_EXAMS;
}

export function getExam(id: string): Exam | undefined {
  return MOCK_EXAMS.find((e) => e.id === id);
}

export function getExamParts(examId: string): ExamPart[] {
  return MOCK_EXAM_PARTS[examId] || [];
}

export function getExamPartCount(examId: string): number {
  return MOCK_EXAM_PARTS[examId]?.length || 0;
}
