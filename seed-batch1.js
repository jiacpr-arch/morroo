const { createClient } = require("@supabase/supabase-js");

const supabase = createClient(
  "https://knxidnzexqehusndquqg.supabase.co",
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtueGlkbnpleHFlaHVzbmRxdXFnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NDM2OTA3NiwiZXhwIjoyMDg5OTQ1MDc2fQ.t47-1W_kcZL9215ZA9vFEf51sptFWMyUsdHrOCkzPCQ"
);

// ============================================================
// 5 Medical Exams - Batch 1
// ============================================================

const examsData = [
  {
    title: "กล้ามเนื้อหัวใจตายเฉียบพลัน (Acute ST-Elevation Myocardial Infarction)",
    category: "อายุรศาสตร์",
    difficulty: "hard",
    status: "published",
    is_free: false,
    publish_date: "2026-03-27",
  },
  {
    title: "ลำไส้อุดตัน (Small Bowel Obstruction)",
    category: "ศัลยศาสตร์",
    difficulty: "medium",
    status: "published",
    is_free: true,
    publish_date: "2026-03-29",
  },
  {
    title: "ตัวเหลืองในทารกแรกเกิด (Neonatal Jaundice)",
    category: "กุมารเวชศาสตร์",
    difficulty: "easy",
    status: "published",
    is_free: true,
    publish_date: "2026-03-31",
  },
  {
    title: "รกเกาะต่ำ (Placenta Previa)",
    category: "สูติศาสตร์-นรีเวชวิทยา",
    difficulty: "hard",
    status: "published",
    is_free: false,
    publish_date: "2026-04-02",
  },
  {
    title: "กระดูกหน้าแข้งหักแบบเปิด (Open Fracture Tibia)",
    category: "ออร์โธปิดิกส์",
    difficulty: "hard",
    status: "published",
    is_free: false,
    publish_date: "2026-04-04",
  },
];

// ============================================================
// Exam Parts Data
// ============================================================

const examPartsData = {
  "กล้ามเนื้อหัวใจตายเฉียบพลัน (Acute ST-Elevation Myocardial Infarction)": [
    {
      part_number: 1,
      title: "ส่วนที่ 1: Initial Assessment และ ECG",
      scenario:
        "ชายไทย อายุ 58 ปี มาห้องฉุกเฉินด้วยอาการเจ็บหน้าอกรุนแรงแบบแน่นๆ บีบๆ (crushing chest pain) ร้าวไปแขนซ้ายและกราม เริ่มเจ็บขณะออกกำลังกาย 2 ชั่วโมงก่อนมา อมยา nitroglycerin ใต้ลิ้นไม่ดีขึ้น มีเหงื่อแตก คลื่นไส้ หายใจเหนื่อย\n\nประวัติเดิม: DM type 2 (10 ปี), Hypertension (15 ปี), สูบบุหรี่ 30 pack-years, Dyslipidemia ไม่เคยรักษา\nยาประจำ: Metformin 1000 mg BID, Amlodipine 5 mg OD\n\nสัญญาณชีพ: BP 95/60 mmHg, HR 110/min, RR 24/min, SpO2 94% on room air, BT 36.8°C\nตรวจร่างกาย: ซีด เหงื่อแตก ฟังปอดมี fine crepitation ที่ฐานปอดทั้งสองข้าง หัวใจ S3 gallop (+) ไม่มี murmur\n\nECG 12-lead: ST elevation ใน lead II, III, aVF > 2 mm, reciprocal ST depression ใน lead I, aVL, ST elevation ใน V5-V6",
      question:
        "จงแปลผล ECG วินิจฉัย และบอกการรักษาเบื้องต้นทันทีที่ควรทำ (door-to-balloon time concept)",
      answer:
        "การแปลผล ECG และวินิจฉัย:\n- ST elevation ใน lead II, III, aVF บ่งชี้ Inferior STEMI (right coronary artery territory)\n- ST elevation ใน V5-V6 บ่งชี้ lateral extension → Inferolateral STEMI\n- Reciprocal changes ใน I, aVL สนับสนุน diagnosis\n- ควรทำ right-sided ECG (V4R) เพื่อ evaluate right ventricular involvement\n\nการรักษาเบื้องต้นทันที (MONA + activation):\n1. Activate cardiac catheterization lab ทันที → เป้าหมาย door-to-balloon time < 90 นาที\n2. Morphine 2-4 mg IV สำหรับ pain relief (ระวังใน hypotension)\n3. Oxygen via nasal cannula 3-4 L/min (SpO2 < 95%)\n4. Aspirin 325 mg chewable ทันที\n5. P2Y12 inhibitor: Ticagrelor 180 mg loading dose หรือ Clopidogrel 600 mg\n6. Heparin: Unfractionated heparin 60 U/kg IV bolus (max 4,000 U)\n7. IV fluid: ระวังเพราะมี signs of heart failure (S3, crepitation) → ให้ทีละน้อย\n8. Stat labs: Troponin-I/T, CK-MB, CBC, BMP, coagulation profile, lipid panel",
      key_points: [
        "ST elevation ใน II, III, aVF = Inferior STEMI จาก RCA occlusion",
        "Door-to-balloon time < 90 นาที เป็น quality indicator สำคัญ",
        "ต้องทำ right-sided ECG เสมอใน inferior STEMI เพื่อดู RV infarction",
        "MONA protocol (Morphine, Oxygen, Nitroglycerin, Aspirin) เป็น initial management แต่ระวัง nitrate ใน RV infarct",
      ],
      time_minutes: 10,
    },
    {
      part_number: 2,
      title: "ส่วนที่ 2: Cardiac Enzymes และ Risk Stratification",
      scenario:
        "ผลตรวจเลือดเร่งด่วน:\n- Troponin-I: 15.8 ng/mL (ปกติ < 0.04)\n- CK-MB: 85 U/L (ปกติ < 25)\n- BNP: 580 pg/mL (ปกติ < 100)\n- CBC: WBC 12,500, Hb 13.2, Plt 245,000\n- BUN 22, Cr 1.1, Na 138, K 4.2, Glucose 285 mg/dL\n- Total cholesterol 268, LDL 185, HDL 32, TG 255\n- PT/INR ปกติ\n\nRight-sided ECG: ST elevation ใน V4R > 1 mm → RV involvement\nKillip classification: Class II (มี pulmonary congestion)\nTIMI risk score: 8/14 (high risk)\nGRACE score: 185 (high risk, in-hospital mortality > 3%)",
      question:
        "จงแปลผล cardiac biomarkers, ประเมิน risk stratification, และอธิบายความสำคัญของ RV involvement ต่อแผนการรักษา",
      answer:
        "การแปลผล cardiac biomarkers:\n- Troponin-I สูงมาก (15.8 ng/mL) → ยืนยัน extensive myocardial necrosis\n- CK-MB สูง → สนับสนุน acute injury (peak ที่ 12-24 ชม.)\n- BNP สูง (580) → มี ventricular dysfunction/heart failure\n\nRisk stratification:\n- Killip Class II: มี pulmonary congestion แต่ยังไม่ frank pulmonary edema → mortality ~17%\n- TIMI score 8/14: high risk → 30-day mortality สูง\n- GRACE score 185: high risk → ต้อง aggressive intervention\n- Risk factors สะสม: DM, HT, smoking, dyslipidemia → extensive atherosclerosis\n\nความสำคัญของ RV involvement:\n- ST elevation V4R > 1 mm ยืนยัน RV infarction\n- RV infarction ต้องระวังเรื่อง preload dependency:\n  1. ห้ามให้ nitrate (nitroglycerin) → ลด preload ทำให้ hypotension รุนแรง\n  2. ห้ามให้ diuretics → ลด preload\n  3. ถ้า hypotensive → ให้ IV fluid bolus (NSS 250-500 mL) เพื่อเพิ่ม RV preload\n  4. Avoid morphine excess → ลด preload\n- ถ้า refractory hypotension → consider inotrope (dobutamine)\n- ควร monitor ด้วย invasive hemodynamics (Swan-Ganz catheter) ในรายที่ซับซ้อน",
      key_points: [
        "Troponin เป็น gold standard biomarker สำหรับ myocardial necrosis",
        "RV infarction เป็น preload-dependent → ห้ามให้ nitrate และ diuretics",
        "Killip classification ช่วยประเมิน severity ของ heart failure ใน acute MI",
        "Uncontrolled DM (glucose 285) เพิ่ม mortality ใน STEMI ต้อง control ด้วย insulin",
      ],
      time_minutes: 10,
    },
    {
      part_number: 3,
      title: "ส่วนที่ 3: Primary PCI และ Antiplatelet Therapy",
      scenario:
        "ผู้ป่วยถูกนำเข้าห้อง cardiac catheterization lab ภายใน 45 นาทีหลังมาถึง ER\n\nCoronary angiography findings:\n- Left main: ปกติ\n- LAD: 70% stenosis ที่ proximal segment\n- LCx: 50% stenosis ที่ mid segment\n- RCA: 100% occlusion ที่ proximal segment (culprit lesion) พบ large thrombus burden\n- TIMI flow grade 0 (total occlusion)\n\nProcedure:\n- Aspiration thrombectomy ดูดลิ่มเลือดออก\n- Pre-dilation ด้วย balloon 2.5 x 15 mm\n- Drug-eluting stent (DES) 3.5 x 28 mm deployed ที่ proximal RCA\n- Post-dilation ด้วย non-compliant balloon 3.75 x 12 mm\n- Final result: TIMI flow grade 3 (normal flow), residual stenosis < 10%\n\nระหว่างทำ PCI: มี transient complete heart block ต้องใส่ temporary pacemaker",
      question:
        "จงอธิบายหลักการ primary PCI, ความสำคัญของ TIMI flow grading, และ antiplatelet/antithrombotic regimen หลัง PCI",
      answer:
        "หลักการ Primary PCI:\n- Primary PCI เป็น gold standard treatment สำหรับ STEMI\n- เป้าหมาย: door-to-balloon time < 90 นาที (ผู้ป่วยรายนี้ทำได้ 45 นาที = ดีมาก)\n- Aspiration thrombectomy ช่วยลด distal embolization ในรายที่มี large thrombus\n- Drug-eluting stent ลด restenosis rate เทียบกับ bare-metal stent\n- Post-dilation ด้วย non-compliant balloon ช่วยให้ stent expansion เต็มที่\n\nTIMI Flow Grading:\n- Grade 0: Complete occlusion ไม่มี flow ผ่าน (ก่อนทำ PCI)\n- Grade 1: Minimal flow ผ่าน แต่ไม่เต็ม vessel\n- Grade 2: Partial flow ผ่านได้ แต่ช้ากว่าปกติ\n- Grade 3: Normal flow (เป้าหมายหลัง PCI) → ผู้ป่วยรายนี้ได้ Grade 3 = สำเร็จ\n\nAntiplatelet/Antithrombotic Regimen หลัง PCI:\n1. Dual antiplatelet therapy (DAPT) อย่างน้อย 12 เดือน:\n   - Aspirin 81 mg OD ตลอดชีวิต\n   - Ticagrelor 90 mg BID x 12 เดือน (หรือ Clopidogrel 75 mg OD ถ้าสู้ค่ายาไม่ไหว)\n2. Anticoagulation: Heparin ต่อ 24-48 ชม. หลัง PCI แล้วหยุด\n3. GP IIb/IIIa inhibitor: พิจารณาในรายที่มี high thrombus burden\n4. Proton pump inhibitor: Pantoprazole 40 mg OD ป้องกัน GI bleeding จาก DAPT\n\nTransient complete heart block:\n- พบได้ใน inferior STEMI เพราะ AV node ได้เลือดจาก RCA\n- มักหายเองหลัง revascularization สำเร็จ\n- Temporary pacemaker ถอดได้เมื่อ stable 24-48 ชม.",
      key_points: [
        "Primary PCI ดีกว่า fibrinolysis ใน STEMI ถ้าทำได้ภายใน 120 นาทีหลัง first medical contact",
        "TIMI flow grade 3 หลัง PCI เป็นเป้าหมายที่บ่งชี้ successful reperfusion",
        "DAPT (Aspirin + P2Y12 inhibitor) ต้องให้อย่างน้อย 12 เดือนหลังใส่ DES",
        "Complete heart block ใน inferior STEMI มักเป็น transient และหายหลัง revascularize",
      ],
      time_minutes: 10,
    },
    {
      part_number: 4,
      title: "ส่วนที่ 4: Post-PCI Complications - Cardiogenic Shock",
      scenario:
        "12 ชั่วโมงหลัง PCI ผู้ป่วยอาการแย่ลง:\n\nสัญญาณชีพ: BP 75/50 mmHg, HR 125/min (sinus tachycardia), RR 30/min, SpO2 88% on O2 mask 10 L/min\nตรวจร่างกาย: หมดสติ GCS E2V2M4 = 8, ตัวเย็นซีด ปลายมือปลายเท้าเขียว, JVP สูง, ฟังปอดมี coarse crepitation ทั่วทั้งสองข้าง, urine output 10 mL/hr (ปกติ > 30)\n\nLaboratory:\n- Lactate 6.5 mmol/L (ปกติ < 2)\n- ABG: pH 7.28, PaCO2 32, PaO2 55, HCO3 15 → metabolic acidosis with respiratory compensation\n- Troponin-I: 45.2 ng/mL (สูงขึ้นจากเดิม)\n- Cr 1.8 (เพิ่มจาก 1.1)\n\nBedside echocardiography:\n- EF 25% (ปกติ > 55%)\n- Severe hypokinesis ของ inferior wall และ lateral wall\n- Moderate mitral regurgitation จาก papillary muscle dysfunction\n- No pericardial effusion, no ventricular septal rupture",
      question:
        "จงวินิจฉัยภาวะแทรกซ้อน ให้การรักษาตาม protocol cardiogenic shock, และอธิบาย mechanical circulatory support ที่อาจจำเป็น",
      answer:
        "วินิจฉัย: Cardiogenic shock complicating acute STEMI\nCriteria ครบ:\n- Hypotension: SBP < 90 mmHg sustained\n- Signs of end-organ hypoperfusion: altered mental status, cold extremities, oliguria (10 mL/hr)\n- Elevated lactate (6.5) = tissue hypoxia\n- Low EF (25%) = pump failure\n\nMechanical complication: Moderate MR จาก papillary muscle dysfunction (ไม่ใช่ rupture เพราะยังเป็น moderate)\n\nการรักษาตาม Cardiogenic Shock Protocol:\n1. Airway: เตรียม endotracheal intubation (GCS 8 = indication) → mechanical ventilation\n2. Vasopressor: Norepinephrine 0.1-0.5 mcg/kg/min เป็น first-line vasopressor\n3. Inotrope: Dobutamine 2.5-10 mcg/kg/min เพิ่ม cardiac output\n4. IV fluid: ระมัดระวัง (มี pulmonary edema แล้ว) → ไม่ควรให้ aggressive fluid\n5. Diuretics: Furosemide 40-80 mg IV ลด pulmonary congestion หลัง BP stable\n6. Monitor: Insert arterial line + Swan-Ganz catheter สำหรับ hemodynamic monitoring\n   - เป้าหมาย: CI > 2.2 L/min/m², PCWP 15-18 mmHg, MAP > 65 mmHg\n7. Recheck coronary angiography: ดูว่า stent thrombosis หรือ new lesion หรือไม่\n\nMechanical Circulatory Support (MCS):\n- Intra-aortic balloon pump (IABP): เพิ่ม coronary perfusion, ลด afterload\n  - พิจารณาเป็น first-line MCS\n- Impella device: percutaneous LVAD ให้ flow 2.5-5 L/min\n  - ดีกว่า IABP ในการเพิ่ม cardiac output\n- VA-ECMO: สำหรับ refractory cardiogenic shock ที่ไม่ตอบสนองต่อ IABP/Impella\n- ถ้าไม่ตอบสนองต่อทุกอย่าง → evaluate สำหรับ heart transplantation หรือ durable LVAD",
      key_points: [
        "Cardiogenic shock เกิดใน 5-8% ของ STEMI มี mortality สูง 40-50%",
        "Norepinephrine เป็น first-line vasopressor ใน cardiogenic shock (ดีกว่า dopamine)",
        "ต้อง rule out mechanical complications: VSD, papillary muscle rupture, free wall rupture",
        "Mechanical circulatory support (IABP, Impella, ECMO) พิจารณาในรายที่ไม่ตอบสนองต่อยา",
      ],
      time_minutes: 10,
    },
    {
      part_number: 5,
      title: "ส่วนที่ 5: Heart Failure Management ใน ICU",
      scenario:
        "หลังใส่ IABP และปรับยา vasopressor/inotrope 48 ชั่วโมง ผู้ป่วยดีขึ้น:\n\nสัญญาณชีพ: BP 105/65 mmHg (on Norepinephrine 0.05 mcg/kg/min + Dobutamine 5 mcg/kg/min), HR 88/min, RR 18/min on mechanical ventilator (FiO2 40%), SpO2 96%, urine output 40 mL/hr\n\nSwan-Ganz catheter:\n- CVP 12 mmHg, PCWP 18 mmHg, CI 2.4 L/min/m², SVR 1,100 dyne·s/cm⁵\n\nLaboratory:\n- Lactate 1.8 mmol/L (ลดลง)\n- Cr 1.4 (ลดลง)\n- BNP 1,250 pg/mL\n- Troponin-I trending down\n\nEchocardiography: EF 30%, MR ลดลงเป็น mild-moderate\n\nแพทย์เริ่มวางแผน wean vasopressors และ transition ไป oral medications",
      question:
        "จงวางแผนการ wean vasopressor/inotrope, เริ่ม guideline-directed medical therapy (GDMT) สำหรับ heart failure with reduced EF, และ criteria สำหรับ IABP removal",
      answer:
        "แผนการ Wean Vasopressor/Inotrope:\n1. Wean Norepinephrine ก่อน (ทีละ 0.01-0.02 mcg/kg/min ทุก 1-2 ชม.)\n   - เป้าหมาย: MAP > 65 mmHg, urine output > 0.5 mL/kg/hr\n2. Wean Dobutamine ช้าๆ (ทีละ 1-2 mcg/kg/min ทุก 4-6 ชม.)\n   - Monitor CI > 2.0, ไม่มี signs of hypoperfusion\n3. ไม่ควร wean ทั้งสองตัวพร้อมกัน\n\nGuideline-Directed Medical Therapy (GDMT) สำหรับ HFrEF:\n- เริ่มเมื่อ hemodynamically stable (off vasopressors)\n\n1. ACEi/ARB/ARNI: เริ่ม Sacubitril/Valsartan 24/26 mg BID (low dose)\n   - หรือ Enalapril 2.5 mg BID แล้ว switch ไป ARNI ทีหลัง\n   - ระวัง: Cr, K+ ก่อนเริ่มและหลังเริ่ม 1-2 สัปดาห์\n\n2. Beta-blocker: เริ่ม Carvedilol 3.125 mg BID หรือ Bisoprolol 1.25 mg OD\n   - เริ่มหลัง stable off inotropes อย่างน้อย 24-48 ชม.\n   - Titrate up ทุก 2 สัปดาห์\n\n3. Mineralocorticoid receptor antagonist (MRA): Spironolactone 25 mg OD\n   - เริ่มเมื่อ K < 5.0 และ eGFR > 30\n\n4. SGLT2 inhibitor: Dapagliflozin 10 mg OD หรือ Empagliflozin 10 mg OD\n   - ให้ได้ทั้ง HFrEF ที่มีและไม่มี DM\n   - ผู้ป่วยรายนี้มี DM → ได้ประโยชน์สองทาง\n\nCriteria สำหรับ IABP Removal:\n- Hemodynamically stable off vasopressors อย่างน้อย 6-12 ชม.\n- CI > 2.2 L/min/m² without IABP augmentation\n- MAP > 65 mmHg\n- Lactate ปกติ\n- Urine output adequate\n- ลด IABP ratio จาก 1:1 → 1:2 → 1:3 แล้ว assess → ถ้า stable ก็ถอด",
      key_points: [
        "GDMT สำหรับ HFrEF ประกอบด้วย 4 pillars: ARNI/ACEi, Beta-blocker, MRA, SGLT2i",
        "เริ่ม GDMT ด้วย low dose แล้ว titrate up ทีละน้อย เป้าหมาย maximum tolerated dose",
        "Wean vasopressor ก่อน inotrope และทำทีละตัว monitor hemodynamics ใกล้ชิด",
        "IABP wean โดย ลด augmentation ratio เป็นขั้นบันได ถ้า stable 6-12 ชม. จึงถอด",
      ],
      time_minutes: 10,
    },
    {
      part_number: 6,
      title: "ส่วนที่ 6: Discharge Planning และ Secondary Prevention",
      scenario:
        "ผู้ป่วย stable ดีขึ้นตามลำดับ พร้อมจำหน่ายหลังนอน ICU 5 วัน ward 5 วัน รวม 10 วัน:\n\nสถานะปัจจุบัน:\n- BP 118/72 mmHg, HR 72/min\n- Off all IV medications\n- Echocardiography ก่อน discharge: EF 35%, mild MR\n- เดินได้ 200 เมตรโดยไม่เหนื่อยมาก (NYHA class II)\n- HbA1c 8.5% (DM ยังคุมไม่ดี)\n- LDL 185 mg/dL (ยังไม่ได้รักษา)\n- eGFR 65 mL/min\n\nยาปัจจุบัน: Aspirin 81 mg, Ticagrelor 90 mg BID, Carvedilol 6.25 mg BID, Sacubitril/Valsartan 49/51 mg BID, Spironolactone 25 mg, Dapagliflozin 10 mg, Furosemide 20 mg OD, Pantoprazole 40 mg",
      question:
        "จงวางแผน discharge medications ทั้งหมด, cardiac rehabilitation program, และ secondary prevention strategy ระยะยาว",
      answer:
        "Discharge Medications (ยากลับบ้าน):\n1. Antiplatelet: Aspirin 81 mg OD (ตลอดชีวิต) + Ticagrelor 90 mg BID (12 เดือน)\n2. Heart failure GDMT:\n   - Carvedilol 6.25 mg BID → titrate to 25 mg BID\n   - Sacubitril/Valsartan 49/51 mg BID → titrate to 97/103 mg BID\n   - Spironolactone 25 mg OD\n   - Dapagliflozin 10 mg OD\n   - Furosemide 20 mg OD (titrate ตาม volume status)\n3. Statin: Atorvastatin 80 mg OD (high-intensity statin) → เป้าหมาย LDL < 55 mg/dL\n4. DM: Metformin 1000 mg BID + Dapagliflozin (dual benefit) + พิจารณา Insulin ถ้า HbA1c ยังสูง → เป้าหมาย HbA1c < 7%\n5. GI protection: Pantoprazole 40 mg OD (ตลอดที่กิน DAPT)\n6. ยาอื่น: Amlodipine หยุดได้ (มี Carvedilol + ARNI คุม BP แล้ว)\n\nCardiac Rehabilitation Program:\n- Phase I (ในโรงพยาบาล): เดินระยะสั้น, physiotherapy → ทำแล้ว\n- Phase II (หลัง discharge 2-12 สัปดาห์): supervised exercise program\n  - Aerobic exercise 30 นาที 3-5 ครั้ง/สัปดาห์\n  - เริ่มจาก low intensity (40-60% max HR) แล้ว progressive\n  - Monitor ECG, BP, HR ระหว่างออกกำลังกาย\n- Phase III (3-6 เดือน): community-based exercise, independent program\n- Phase IV (ตลอดชีวิต): maintain active lifestyle\n\nSecondary Prevention Strategy:\n1. Smoking cessation: เป็นสิ่งสำคัญที่สุด → ให้ counseling + Varenicline/NRT\n2. Blood pressure: เป้าหมาย < 130/80 mmHg\n3. Lipid: เป้าหมาย LDL < 55 mg/dL (very high risk)\n4. DM control: เป้าหมาย HbA1c < 7%\n5. Diet: low salt (< 2 g/day), Mediterranean diet\n6. Weight: BMI 18.5-24.9\n7. Follow-up: พบแพทย์ 2 สัปดาห์, 1 เดือน, 3 เดือน, 6 เดือน, 1 ปี\n8. Echocardiography ซ้ำ 3 เดือน ดู EF recovery\n9. ICD evaluation: ถ้า EF ยังคง <= 35% หลัง optimal GDMT 3 เดือน → พิจารณา ICD",
      key_points: [
        "High-intensity statin (Atorvastatin 80 mg) จำเป็นสำหรับทุกราย post-STEMI เป้าหมาย LDL < 55",
        "Cardiac rehabilitation ลด mortality 20-25% และเพิ่มคุณภาพชีวิต",
        "Smoking cessation เป็น single most effective secondary prevention measure",
        "ถ้า EF <= 35% หลัง optimal GDMT 3 เดือน ต้อง evaluate สำหรับ ICD implantation",
      ],
      time_minutes: 10,
    },
  ],

  "ลำไส้อุดตัน (Small Bowel Obstruction)": [
    {
      part_number: 1,
      title: "ส่วนที่ 1: การซักประวัติ ตรวจร่างกาย และ Abdominal X-ray",
      scenario:
        "หญิงไทย อายุ 45 ปี มาห้องฉุกเฉินด้วยอาการปวดท้องบิดเป็นพักๆ (colicky abdominal pain) 2 วัน อาเจียนเป็นน้ำสีเขียว (bilious vomiting) 5-6 ครั้ง ท้องอืดมากขึ้นเรื่อยๆ ไม่ถ่ายอุจจาระและผายลม 2 วัน (obstipation)\n\nประวัติเดิม: เคยผ่าตัดไส้ติ่ง (open appendectomy) 10 ปีก่อน ไม่มีโรคประจำตัวอื่น\n\nสัญญาณชีพ: BP 100/68 mmHg, HR 105/min, RR 20/min, BT 37.4°C, SpO2 98%\nตรวจร่างกาย: ท้องอืดมาก (distended abdomen), มีแผลเป็นผ่าตัดเก่า RLQ, bowel sounds เสียงสูง (high-pitched tinkling), กดเจ็บทั่วท้องแบบไม่เฉพาะที่ ไม่มี peritoneal signs, DRE: empty rectum\n\nAbdominal X-ray (supine + erect):\n- Multiple dilated small bowel loops (> 3 cm) with air-fluid levels\n- Step-ladder pattern\n- ไม่พบ gas ใน colon หรือ rectum\n- ไม่มี free air under diaphragm",
      question:
        "จงให้ diagnosis พร้อมสาเหตุที่น่าจะเป็นมากที่สุด แปลผล abdominal X-ray และวางแผนการ investigation เพิ่มเติม",
      answer:
        "Diagnosis: Small bowel obstruction (SBO)\nสาเหตุที่น่าจะเป็นมากที่สุด: Adhesive small bowel obstruction จากประวัติ previous open appendectomy\n- Adhesion เป็นสาเหตุอันดับ 1 ของ SBO (60-75%) โดยเฉพาะหลัง abdominal surgery\n\nการแปลผล Abdominal X-ray:\n- Dilated small bowel > 3 cm (ปกติ < 3 cm) → บ่งชี้ small bowel obstruction\n- Air-fluid levels ใน erect film → บ่งชี้มี fluid accumulation จาก obstruction\n- Step-ladder pattern = multiple air-fluid levels ที่ระดับต่างกัน → classic SBO\n- ไม่มี colonic gas → complete obstruction\n- ไม่มี free air → ยังไม่ perforate\n\nInvestigation เพิ่มเติม:\n1. CT abdomen with IV contrast (สำคัญที่สุด):\n   - ดู transition zone (จุดที่ลำไส้เปลี่ยนจากโตเป็นแฟบ)\n   - ดู cause of obstruction (adhesion, hernia, tumor)\n   - ดู signs of strangulation (mesenteric haziness, bowel wall thickening, poor enhancement)\n2. Laboratory:\n   - CBC: ดู WBC (elevated ใน strangulation)\n   - BMP: ดู electrolytes (จาก vomiting → hypokalemia, metabolic alkalosis)\n   - Lactate: elevated ใน bowel ischemia/strangulation\n   - BUN/Cr: ดู dehydration\n3. Blood gas: ดู acid-base status",
      key_points: [
        "Adhesion จาก previous surgery เป็นสาเหตุอันดับ 1 ของ SBO (60-75%)",
        "Classic triad ของ SBO: colicky pain, vomiting, obstipation",
        "Abdominal X-ray sensitivity ประมาณ 70% CT abdomen เป็น gold standard",
        "ต้อง rule out strangulation เสมอเพราะเป็น surgical emergency",
      ],
      time_minutes: 10,
    },
    {
      part_number: 2,
      title: "ส่วนที่ 2: CT Abdomen Findings",
      scenario:
        "ผลตรวจเลือด:\n- CBC: WBC 11,200, Hb 13.5, Plt 310,000\n- Na 136, K 3.2, Cl 95, HCO3 30 (metabolic alkalosis จาก vomiting)\n- BUN 28, Cr 1.2 (mild dehydration)\n- Lactate 1.5 mmol/L (ปกติ < 2)\n- Amylase/Lipase ปกติ\n\nCT abdomen with IV contrast:\n- Dilated small bowel loops up to 4.5 cm ตั้งแต่ jejunum ถึง distal ileum\n- Transition zone ที่ distal ileum ห่างจาก ileocecal valve ประมาณ 30 cm\n- พบ adhesive band เป็นเหตุของ obstruction\n- Small bowel wall enhances ปกติ ไม่มี wall thickening\n- ไม่มี mesenteric haziness หรือ mesenteric vessel engorgement\n- Moderate free fluid ใน pelvis\n- ไม่มี hernia, ไม่มี mass\n- Collapsed colon\n- สรุป: Complete adhesive SBO at distal ileum, no signs of strangulation",
      question:
        "จงแปลผล CT abdomen โดยละเอียด อธิบาย signs of strangulation ที่ต้องมองหา และ differentiate ระหว่าง simple vs complicated SBO",
      answer:
        "การแปลผล CT Abdomen:\n- Complete SBO: dilated proximal bowel + collapsed distal bowel + transition zone ชัดเจน\n- Transition zone ที่ distal ileum: จุดที่ลำไส้เปลี่ยนจากโป่งเป็นแฟบ → ตำแหน่ง obstruction\n- Adhesive band: สาเหตุยืนยันว่าเป็น adhesion (สอดคล้องกับประวัติผ่าตัด)\n- Normal bowel wall enhancement: ลำไส้ยังมีเลือดเลี้ยงดี → ยังไม่ ischemia\n- ไม่มี mesenteric haziness: ไม่มี venous congestion\n- Free fluid ใน pelvis: พบได้ใน SBO (transudation) ไม่จำเป็นต้องเป็น strangulation\n\nSigns of Strangulation บน CT (ไม่พบในผู้ป่วยรายนี้):\n1. Bowel wall thickening > 3 mm\n2. Decreased or absent bowel wall enhancement\n3. Mesenteric haziness (fat stranding)\n4. Mesenteric vessel engorgement (เส้นเลือด mesentery โป่ง)\n5. Closed-loop obstruction (C-shaped or U-shaped dilated loop)\n6. Whirl sign (mesentery บิด)\n7. Pneumatosis intestinalis (gas ในผนังลำไส้)\n8. Portomesenteric venous gas\n9. Free peritoneal air (perforation)\n\nSimple vs Complicated SBO:\n- Simple SBO (ผู้ป่วยรายนี้): obstruction โดยไม่มี ischemia/strangulation\n  → ลอง conservative management ก่อนได้\n- Complicated SBO: มี strangulation, closed-loop, ischemia, หรือ perforation\n  → ต้องผ่าตัดฉุกเฉิน\n\nFactors ที่บ่งชี้ว่ายังเป็น simple SBO:\n- Lactate ปกติ (1.5)\n- WBC ไม่สูงมาก\n- Bowel wall enhances ปกติ\n- ไม่มี peritoneal signs\n- ไม่มี fever",
      key_points: [
        "CT abdomen with IV contrast เป็น gold standard สำหรับ evaluate SBO (sensitivity > 90%)",
        "Transition zone บน CT บอกตำแหน่งและสาเหตุของ obstruction",
        "Signs of strangulation บน CT ที่สำคัญ: decreased wall enhancement, mesenteric haziness, closed-loop",
        "Simple SBO สามารถลอง conservative management ก่อนได้ แต่ complicated SBO ต้องผ่าตัดทันที",
      ],
      time_minutes: 10,
    },
    {
      part_number: 3,
      title: "ส่วนที่ 3: Conservative Management (NPO, NG Tube, IV Fluid)",
      scenario:
        "ตัดสินใจทำ conservative management เนื่องจากเป็น simple adhesive SBO ไม่มี signs of strangulation:\n\nManagement ที่เริ่ม:\n- NPO (nothing per oral)\n- Nasogastric (NG) tube: ใส่ได้ 16 Fr, ดูดออกได้ bilious content 800 mL ทันที\n- IV fluid: Ringer's Lactate 150 mL/hr + KCl 40 mEq/L correction\n- Foley catheter: urine output monitoring\n- Pain: Paracetamol 1 g IV q 6 hr + Morphine 2 mg IV PRN\n- DVT prophylaxis: Enoxaparin 40 mg SC OD\n\n24 ชั่วโมงต่อมา:\n- NG output: 1,200 mL/24 hr (สีเขียว)\n- Urine output: 45 mL/hr (ดีขึ้น)\n- ปวดท้องลดลง pain score 4/10 (จาก 8/10)\n- ท้องยังอืด แต่ลดลงเล็กน้อย\n- ยังไม่ผายลม ไม่ถ่ายอุจจาระ\n- Vital signs stable\n- Lab: K 3.8 (ดีขึ้น), Lactate 1.2",
      question:
        "จงอธิบายหลักการ conservative management ของ SBO, role ของ water-soluble contrast (Gastrografin), และ criteria ที่บ่งชี้ว่า conservative management สำเร็จหรือล้มเหลว",
      answer:
        "หลักการ Conservative Management ของ SBO (Drip and Suck):\n1. NPO: ลดการกระตุ้น GI tract ให้ bowel พัก\n2. NG tube decompression:\n   - ลด gastric distension ลด vomiting\n   - ลด pressure ใน proximal bowel\n   - Monitor output: สี ปริมาณ (ถ้าลดลง = ดีขึ้น)\n3. IV fluid resuscitation:\n   - ทดแทน fluid loss จาก vomiting + third-spacing\n   - Correct electrolytes: K+, Na+, Cl-\n   - Monitor urine output > 0.5 mL/kg/hr\n4. Pain management: หลีกเลี่ยง opioid ถ้าเป็นไปได้ (ลด motility)\n5. DVT prophylaxis: เพราะ immobilization + surgery risk\n\nRole ของ Water-Soluble Contrast (Gastrografin):\n- ให้ทาง NG tube หรือ oral 100 mL Gastrografin\n- Therapeutic effect: osmotic effect ดึง fluid เข้า lumen ลด bowel wall edema\n- Diagnostic value: ถ่าย abdominal X-ray 8-24 ชม. หลังให้\n  - ถ้า contrast ถึง colon ภายใน 24 ชม. → obstruction resolved → conservative สำเร็จ\n  - ถ้า contrast ไม่ถึง colon ภายใน 24-36 ชม. → operative intervention\n- ลด need for surgery ได้ประมาณ 74% ในรายที่ contrast ผ่านถึง colon\n- ลด hospital stay\n\nCriteria บ่งชี้ Conservative Management สำเร็จ:\n- ผายลม หรือ ถ่ายอุจจาระได้\n- NG output ลดลง (< 500 mL/24 hr) และเปลี่ยนสีจากเขียวเป็นใส\n- ปวดท้องหายหรือลดลงมาก\n- ท้องยุบลง ไม่อืด\n- Bowel sounds กลับมาปกติ\n- Gastrografin ถึง colon ภายใน 24 ชม.\n\nCriteria บ่งชี้ Conservative Management ล้มเหลว (ต้องผ่าตัด):\n- ไม่ดีขึ้นใน 48-72 ชม.\n- อาการแย่ลง: ปวดมากขึ้น fever WBC สูงขึ้น peritoneal signs\n- Lactate สูงขึ้น\n- Gastrografin ไม่ถึง colon ใน 24-36 ชม.\n- NG output ไม่ลด",
      key_points: [
        "Conservative management สำเร็จใน 65-80% ของ adhesive SBO",
        "Gastrografin challenge มีทั้ง therapeutic และ diagnostic value ช่วยตัดสินใจผ่าตัด",
        "ผายลมได้ เป็น best clinical indicator ว่า obstruction resolved",
        "ถ้า conservative ไม่ดีขึ้นใน 48-72 ชม. ต้องพิจารณาผ่าตัด",
      ],
      time_minutes: 10,
    },
    {
      part_number: 4,
      title: "ส่วนที่ 4: Failure of Conservative Management และ Surgical Decision",
      scenario:
        "ให้ Gastrografin 100 mL ทาง NG tube แล้ว clamp 2 ชม.\nAbdominal X-ray ที่ 24 ชม. หลังให้ Gastrografin: contrast อยู่ที่ dilated small bowel ไม่ถึง colon\n\n48 ชั่วโมงหลัง admit (รวมเป็น 72 ชม. หลังเริ่มมีอาการ):\n- ปวดท้องมากขึ้น pain score 7/10 ปวดต่อเนื่อง (จาก colicky เปลี่ยนเป็น constant pain)\n- BT 38.5°C\n- HR 115/min, BP 95/62 mmHg\n- ท้องอืดมากขึ้น มี localized tenderness ที่ lower abdomen\n- Involuntary guarding (+)\n- NG output 1,500 mL/24 hr (เพิ่มขึ้น)\n\nLaboratory:\n- WBC 18,500 (เพิ่มจาก 11,200)\n- Lactate 3.8 mmol/L (เพิ่มจาก 1.5)\n- CRP 120 mg/L\n\nRepeat CT abdomen: พบ closed-loop obstruction ที่ distal ileum, bowel wall thickening, decreased wall enhancement, mesenteric haziness → concerning for strangulation",
      question:
        "จงวิเคราะห์ว่าทำไม conservative management ล้มเหลว ให้ plan สำหรับ surgical intervention รวมถึง preoperative preparation",
      answer:
        "วิเคราะห์สาเหตุ Conservative Management ล้มเหลว:\n1. Gastrografin ไม่ถึง colon ใน 24 ชม. → complete obstruction ที่ไม่ resolve ด้วย conservative\n2. Pain เปลี่ยนจาก colicky เป็น constant → อาจมี bowel wall ischemia\n3. Signs of strangulation ปรากฏ:\n   - Fever, tachycardia, hypotension\n   - Rising WBC (18,500) และ lactate (3.8) → tissue ischemia\n   - CT: closed-loop, wall thickening, decreased enhancement, mesenteric haziness\n4. Peritoneal signs ปรากฏ: involuntary guarding → peritoneal irritation\n\nSurgical Plan: Emergency Exploratory Laparotomy\n- Laparoscopic approach อาจเริ่มก่อน แต่มี high conversion rate ในรายที่มี strangulation\n- เปลี่ยนเป็น open (midline laparotomy) ถ้า:\n  - Dense adhesions ไม่สามารถ lyse ได้ safely\n  - Bowel ischemia/necrosis ต้อง resection\n  - Inadequate visualization\n\nPreoperative Preparation:\n1. Resuscitation:\n   - IV fluid bolus: Ringer's Lactate 1-2 L stat\n   - Correct electrolytes: K+, Mg2+\n   - Blood group and crossmatch 2 units pRBC\n2. Antibiotics (broad-spectrum สำหรับ possible contamination):\n   - Piperacillin-Tazobactam 4.5 g IV หรือ\n   - Ceftriaxone 2 g + Metronidazole 500 mg IV\n3. NG tube: keep on suction\n4. Foley catheter: ต่อ urine bag\n5. Informed consent: อธิบาย possible bowel resection, stoma creation\n6. DVT prophylaxis: sequential compression device\n7. Anesthesia consultation: ASA assessment\n8. Blood products ready: 2 units pRBC, FFP available",
      key_points: [
        "Constant pain แทน colicky pain เป็น warning sign ของ strangulation",
        "Rising lactate + WBC + fever + peritoneal signs = surgical emergency",
        "Gastrografin ไม่ถึง colon ใน 24 ชม. ร่วมกับอาการแย่ลง → definite indication สำหรับ surgery",
        "Preoperative resuscitation สำคัญมาก ต้องทำก่อนเข้าห้องผ่าตัด",
      ],
      time_minutes: 10,
    },
    {
      part_number: 5,
      title: "ส่วนที่ 5: Operative Findings (Adhesion Band)",
      scenario:
        "ทำ midline exploratory laparotomy:\n\nOperative findings:\n- Dense adhesion band จาก previous appendectomy scar ไป mesentery ของ distal ileum\n- Adhesive band รัดลำไส้ ileum ห่างจาก ileocecal valve 25 cm → closed-loop obstruction\n- Segment ที่ถูกรัด ยาวประมาณ 15 cm มี signs of strangulation:\n  - สีม่วงคล้ำ (dusky, purple discoloration)\n  - ไม่มี peristalsis ใน affected segment\n  - Mesentery บวมน้ำ\n- หลังตัด adhesive band และ release obstruction: รอ 15 นาที ดู bowel viability:\n  - สีเปลี่ยนจากม่วงเป็นชมพู (pink color returned)\n  - Peristalsis กลับมา\n  - Mesenteric vessel มี pulsation\n  - Doppler: มี blood flow ใน affected segment\n- Proximal bowel dilated 4-5 cm, distal bowel collapsed\n- ไม่มี perforation, ไม่มี free pus\n- ไม่มี other pathology (tumor, Meckel's diverticulum)",
      question:
        "จงอธิบายวิธี assess bowel viability intraoperatively, criteria ที่ตัดสินใจว่าต้อง resect bowel หรือไม่, และ operative techniques สำหรับ adhesiolysis",
      answer:
        "วิธี Assess Bowel Viability Intraoperatively:\n1. Visual inspection (สำคัญที่สุด):\n   - สี: ชมพู (viable) vs ม่วง/ดำ (non-viable)\n   - ผู้ป่วยรายนี้: สีกลับเป็นชมพูหลัง release → viable\n2. Peristalsis:\n   - กลับมามี peristalsis → viable\n   - ไม่มี peristalsis หลัง warm saline irrigation → non-viable\n3. Mesenteric vessel pulsation:\n   - คลำ pulse ได้ที่ mesenteric arcade → blood supply intact\n4. Intraoperative Doppler:\n   - ตรวจ blood flow ใน mesenteric vessels และ bowel wall\n   - มี flow → viable\n5. Fluorescein test (ถ้ามี):\n   - IV fluorescein แล้วดูด้วย Wood's lamp\n   - Fluorescence = perfusion ดี\n6. ICG (Indocyanine green) angiography:\n   - IV ICG แล้วดูด้วย near-infrared camera\n   - Real-time perfusion assessment → เป็นวิธี modern ที่ accurate ที่สุด\n\nCriteria ตัดสินใจ Resect vs Preserve:\n- Preserve (ไม่ resect) → ผู้ป่วยรายนี้:\n  - สีกลับปกติหลัง release ภายใน 15-20 นาที\n  - Peristalsis กลับมา\n  - Mesenteric pulse ดี\n  - Doppler มี flow\n\n- Resect (ต้องตัดลำไส้):\n  - สียังคงดำหรือม่วงหลัง 15-20 นาที\n  - ไม่มี peristalsis กลับมา\n  - ไม่มี mesenteric pulse\n  - Frank gangrene หรือ perforation\n  - หลัง resection → primary anastomosis ถ้า bowel condition ดี\n  - ถ้า severe contamination → stoma (ileostomy) แล้วกลับมาต่อทีหลัง\n\nOperative Techniques สำหรับ Adhesiolysis:\n1. Sharp dissection ด้วยกรรไกร (Metzenbaum scissors) → ปลอดภัยที่สุด\n2. หลีกเลี่ยง electrocautery ใกล้ bowel wall → ป้องกัน thermal injury\n3. ตัด adhesion ให้ชิด abdominal wall ไม่ใช่ชิด bowel → ลด serosal injury\n4. Handle bowel อย่าง gentle → ลด serosal tear\n5. Run entire small bowel จาก Treitz ถึง ileocecal valve → ตรวจหา pathology อื่น",
      key_points: [
        "Bowel viability assessment: สี + peristalsis + mesenteric pulse + Doppler เป็น key indicators",
        "รอ 15-20 นาทีหลัง release obstruction ก่อนตัดสินใจ resect",
        "ICG angiography เป็น modern technique ที่ accurate ที่สุดในการ assess perfusion",
        "Sharp dissection เป็น safest technique สำหรับ adhesiolysis หลีกเลี่ยง cautery ใกล้ bowel",
      ],
      time_minutes: 10,
    },
    {
      part_number: 6,
      title: "ส่วนที่ 6: Post-operative Care และ Prevention of Recurrence",
      scenario:
        "Operative procedure: Adhesiolysis, release of adhesive band, no bowel resection needed\nOperative time: 90 นาที, EBL 100 mL\n\nPost-op day 1:\n- BP 120/75, HR 82, BT 37.2°C\n- Pain score 5/10 with PCA morphine\n- NG output 300 mL (ลดลงมาก)\n- Abdomen: soft, mild distension, bowel sounds present\n- Urine output 50 mL/hr\n\nPost-op day 2:\n- เริ่มผายลมได้\n- NG output 100 mL → ถอด NG tube\n- เริ่มดื่มน้ำใสได้\n\nPost-op day 3:\n- ถ่ายอุจจาระได้\n- กินอาหารอ่อนได้ ไม่อาเจียน\n- Pain score 3/10 with oral paracetamol\n- Lab: WBC 8,500, Lactate 0.8",
      question:
        "จงวางแผน post-operative care, criteria สำหรับ discharge, และ strategies ป้องกัน recurrent adhesive SBO",
      answer:
        "Post-operative Care:\n1. Pain management:\n   - Multimodal analgesia: Paracetamol 1 g IV/oral q 6 hr + NSAIDs (ถ้าไม่มี contraindication)\n   - PCA morphine → transition to oral tramadol → paracetamol alone\n   - Enhanced Recovery After Surgery (ERAS) protocol\n2. NG tube management:\n   - ถอดเมื่อ output < 200 mL/24 hr + มี bowel function\n   - ผู้ป่วยรายนี้ถอดได้ post-op day 2 ✓\n3. Diet advancement:\n   - Clear liquid → soft diet → regular diet\n   - เริ่มเมื่อมี bowel function (flatus/BM)\n   - ผู้ป่วยรายนี้ progress ดี\n4. Early mobilization:\n   - นั่งข้างเตียง post-op day 1\n   - เดินได้ post-op day 1-2\n   - ลด DVT, pneumonia, ileus risk\n5. DVT prophylaxis: Enoxaparin 40 mg SC OD จนเดินได้ดี\n6. Wound care: ดูแลแผล ดู signs of infection\n7. Monitoring: vital signs, urine output, wound, bowel function\n\nDischarge Criteria:\n- กินอาหารปกติได้ ไม่อาเจียน\n- ถ่ายอุจจาระหรือผายลมได้\n- Pain control ด้วยยากิน\n- ไม่มี fever\n- WBC ปกติ\n- Wound ดี ไม่มี signs of infection\n- เดินได้ด้วยตัวเอง\n→ คาดว่า discharge ได้ post-op day 4-5\n\nStrategies ป้องกัน Recurrent Adhesive SBO:\n1. Intraoperative prevention:\n   - Anti-adhesion barriers: Seprafilm (hyaluronic acid-carboxymethylcellulose) วางบน bowel surface\n   - Gentle tissue handling ลด serosal injury\n   - Minimize foreign body (ลด glove powder, suture material)\n   - Adequate hemostasis ลด hematoma formation\n   - Minimize peritoneal contamination\n2. Surgical approach:\n   - Laparoscopic surgery ลด adhesion formation มากกว่า open surgery\n   - พิจารณา laparoscopic approach ในครั้งถัดไปถ้าต้องผ่าตัดอีก\n3. Patient education:\n   - อธิบาย warning signs ของ SBO: ปวดท้องบิด อาเจียน ท้องอืด ไม่ผายลม\n   - มาพบแพทย์ทันทีถ้ามีอาการ\n   - Recurrence rate ของ adhesive SBO ประมาณ 20-30%\n4. Follow-up: นัดตรวจ 2 สัปดาห์ + 1 เดือนหลัง discharge",
      key_points: [
        "ERAS protocol ช่วยลด hospital stay และ complications หลังผ่าตัด",
        "Early mobilization เป็นสิ่งสำคัญที่สุดในการป้องกัน post-op ileus",
        "Anti-adhesion barriers เช่น Seprafilm ช่วยลด adhesion formation",
        "Recurrence rate ของ adhesive SBO ประมาณ 20-30% ต้อง educate ผู้ป่วย",
      ],
      time_minutes: 10,
    },
  ],

  "ตัวเหลืองในทารกแรกเกิด (Neonatal Jaundice)": [
    {
      part_number: 1,
      title: "ส่วนที่ 1: Initial Assessment และ Kramer Zone",
      scenario:
        "ทารกแรกเกิดเพศชาย อายุ 3 วัน น้ำหนักแรกเกิด 3.2 kg (น้ำหนักปัจจุบัน 2.95 kg, ลดลง 7.8%) เกิดครบกำหนด 38+4 สัปดาห์ คลอดปกติทางช่องคลอด Apgar score 9, 10 กินนมแม่อย่างเดียว มารดาสังเกตว่าทารกตัวเหลืองตั้งแต่วันที่ 2\n\nมารดา: อายุ 28 ปี ครรภ์ที่ 1 blood group O Rh positive, ไม่มีโรคประจำตัว\n\nตรวจร่างกายทารก:\n- Active, ร้องดี ดูดนมได้\n- ตัวเหลืองตั้งแต่หน้า ลำตัว แขนขา จนถึงฝ่ามือฝ่าเท้า\n- Kramer zone V (ตัวเหลืองถึงฝ่ามือฝ่าเท้า)\n- ไม่มี hepatosplenomegaly\n- ไม่มี cephalohematoma\n- สัญญาณชีพ: HR 145, RR 42, BT 36.8°C\n- Anterior fontanelle ปกติ\n- ดูดนมแม่วันละ 8-10 ครั้ง แต่มารดารู้สึกว่าน้ำนมยังมาไม่ดี",
      question:
        "จงอธิบาย Kramer zone classification, ให้ differential diagnosis ของ neonatal jaundice ในทารกอายุ 3 วัน, และบอก investigation ที่ต้องส่ง",
      answer:
        "Kramer Zone Classification:\n- Zone I: เหลืองที่หน้าและคอ → estimated TSB 5-6 mg/dL\n- Zone II: เหลืองถึงท้องส่วนบน (above umbilicus) → TSB 6-8 mg/dL\n- Zone III: เหลืองถึงท้องส่วนล่าง + ต้นขา → TSB 8-12 mg/dL\n- Zone IV: เหลืองถึงแขนและขา (below knees) → TSB 12-16 mg/dL\n- Zone V: เหลืองถึงฝ่ามือฝ่าเท้า → TSB > 15-18 mg/dL ← ผู้ป่วยรายนี้\n- Kramer zone V = significant jaundice ต้อง investigate ทันที\n\nDifferential Diagnosis (อายุ 3 วัน):\n1. Physiological jaundice: พบบ่อยที่สุด peak วันที่ 3-5 ใน term baby\n2. Breastfeeding jaundice (early): จากการกินนมไม่เพียงพอ → น้ำหนักลด 7.8% สนับสนุน\n3. ABO incompatibility: มารดา O + ทารกอาจเป็น A หรือ B → hemolysis\n4. G6PD deficiency: ชายไทย มี prevalence สูง → hemolysis\n5. Cephalohematoma/bruising: ไม่พบในรายนี้\n6. Sepsis: ต้อง rule out เสมอ\n7. Rh incompatibility: มารดา Rh positive → unlikely\n\nInvestigation ที่ต้องส่ง:\n1. Total serum bilirubin (TSB): วัดค่าจริงเพื่อ plot บน Bhutani nomogram\n2. Direct bilirubin: แยก conjugated vs unconjugated\n3. Blood group ทารก + Rh typing\n4. Direct Coombs test (DAT): ตรวจ immune-mediated hemolysis\n5. CBC + reticulocyte count: ดู anemia, hemolysis\n6. Peripheral blood smear: ดู spherocytes, fragmented cells\n7. G6PD screening: ในเด็กชายไทยทุกราย\n8. Albumin level: สำหรับ calculate bilirubin/albumin ratio\n9. TSH/Free T4: ถ้าสงสัย hypothyroidism (prolonged jaundice)",
      key_points: [
        "Kramer zone V (ฝ่ามือฝ่าเท้า) บ่งชี้ TSB > 15 mg/dL ต้อง investigate ทันที",
        "Breastfeeding jaundice เกิดจากกินนมไม่พอ ต่างจาก breast milk jaundice ที่เกิดหลัง 1 สัปดาห์",
        "ABO incompatibility (มารดา O ทารก A/B) เป็นสาเหตุ hemolytic jaundice ที่พบบ่อยที่สุดใน Thai neonates",
        "น้ำหนักลด > 7% ใน 3 วัน ในทารกกินนมแม่ บ่งชี้ inadequate intake",
      ],
      time_minutes: 10,
    },
    {
      part_number: 2,
      title: "ส่วนที่ 2: TSB Interpretation และ Bhutani Nomogram",
      scenario:
        "ผลตรวจเลือด:\n- TSB: 18.5 mg/dL (316 µmol/L) ที่อายุ 68 ชั่วโมง\n- Direct bilirubin: 0.8 mg/dL (< 20% ของ total → unconjugated hyperbilirubinemia)\n- Blood group ทารก: A Rh positive (มารดา O Rh positive)\n- Direct Coombs test (DAT): Weakly positive\n- CBC: Hb 14.8 g/dL (ปกติ), Reticulocyte 5.2% (สูง), WBC 12,000 (ปกติ)\n- Peripheral smear: Spherocytes present\n- G6PD: ปกติ (normal enzyme activity)\n- Albumin: 3.2 g/dL\n\nPlot บน Bhutani Nomogram:\n- TSB 18.5 mg/dL ที่อายุ 68 ชม. → อยู่ใน HIGH RISK ZONE (> 95th percentile)\n\nAAP Phototherapy Threshold (term baby, 35+ weeks, risk factors present):\n- Risk factors: ABO incompatibility + DAT positive\n- Threshold สำหรับ phototherapy ที่ 68 ชม.: 15 mg/dL (lower threshold เพราะมี risk factors)\n- ผู้ป่วยมี TSB 18.5 → สูงกว่า threshold มาก",
      question:
        "จงแปลผลตรวจเลือดทั้งหมด อธิบายการใช้ Bhutani nomogram, และตัดสินใจว่าต้องรักษาอย่างไร",
      answer:
        "การแปลผลตรวจเลือด:\n- TSB 18.5 mg/dL → significant hyperbilirubinemia\n- Direct bilirubin 0.8 (4.3% ของ total) → unconjugated → hemolysis หรือ physiological\n- ABO incompatibility: มารดา O + ทารก A → anti-A antibody ข้ามรกมา destroy ทารก RBC\n- DAT weakly positive: ยืนยัน immune-mediated hemolysis\n- Reticulocyte 5.2% (สูง): bone marrow ผลิต RBC เพิ่มชดเชย hemolysis\n- Spherocytes: เกิดจาก antibody-coated RBC ถูก splenic macrophage กัด\n- G6PD ปกติ: ตัด G6PD deficiency ออก\n- สรุป: ABO hemolytic disease of newborn\n\nBhutani Nomogram:\n- เป็น hour-specific TSB nomogram สำหรับทารก >= 35 สัปดาห์\n- Plot TSB ตาม postnatal age (ชั่วโมง)\n- แบ่งเป็น zones: Low, Low-intermediate, High-intermediate, High risk\n- ผู้ป่วย: TSB 18.5 ที่ 68 ชม. = High risk zone (> 95th percentile)\n- ใช้ทำนาย risk ของ subsequent significant hyperbilirubinemia\n- ใช้ร่วมกับ AAP guideline ในการตัดสินใจ treatment\n\nการตัดสินใจรักษา:\n- ทารกรายนี้มี risk factors (ABO incompatibility + DAT positive)\n- AAP phototherapy threshold สำหรับ medium risk (>= 38 wk + risk factors) ที่ 68 ชม. ≈ 15 mg/dL\n- TSB 18.5 >> 15 mg/dL → ต้องเริ่ม intensive phototherapy ทันที\n- ตรวจ exchange transfusion threshold: ประมาณ 20-22 mg/dL สำหรับ medium risk ที่ 68 ชม.\n- TSB 18.5 ยังไม่ถึง exchange threshold แต่ใกล้ → ต้อง monitor ใกล้ชิด\n- Bilirubin/Albumin ratio = 18.5/3.2 = 5.78 (ยังไม่ถึง exchange criteria ที่ 7.0 สำหรับ >= 38 wk)",
      key_points: [
        "Bhutani nomogram ใช้ hour-specific TSB ในการ assess risk และตัดสินใจ treatment",
        "ABO incompatibility ยืนยันโดย maternal O + baby A/B + DAT positive + spherocytes",
        "Unconjugated hyperbilirubinemia + reticulocytosis = hemolytic process",
        "AAP threshold สำหรับ phototherapy ลดลงเมื่อมี risk factors (hemolysis, prematurity, DAT+)",
      ],
      time_minutes: 10,
    },
    {
      part_number: 3,
      title: "ส่วนที่ 3: Phototherapy Indication และ Setup",
      scenario:
        "ตัดสินใจเริ่ม intensive phototherapy ทันที:\n\nSetup ที่ใช้:\n- Overhead phototherapy unit (blue LED, wavelength 460-490 nm) irradiance > 30 µW/cm²/nm\n- Biliblanket (fiber-optic pad) วางใต้ทารก\n- รวมเป็น double phototherapy (overhead + underneath)\n\nNursing orders:\n- ถอดเสื้อผ้าทารก เหลือผ้าอ้อมอย่างเดียว\n- ปิดตาด้วย eye shield\n- วัด TSB ซ้ำทุก 4-6 ชั่วโมง\n- Monitor BT ทุก 3 ชม.\n- I/O charting: บันทึกน้ำนม urine stool\n- กินนมแม่ได้ต่อ เพิ่มความถี่เป็นทุก 2-3 ชม.\n- ชั่งน้ำหนักวันละครั้ง\n\nTSB follow-up:\n- 0 ชม. (baseline): 18.5 mg/dL\n- 4 ชม.: 17.2 mg/dL (ลด 1.3)\n- 8 ชม.: 16.0 mg/dL (ลด 1.2)\n- 12 ชม.: 15.1 mg/dL (ลด 0.9)",
      question:
        "จงอธิบายกลไกการทำงานของ phototherapy, optimal setup, และ expected rate of decline ของ TSB",
      answer:
        "กลไกการทำงานของ Phototherapy:\n1. Photoisomerization (สำคัญที่สุด):\n   - แสงเปลี่ยน bilirubin (4Z,15Z) → lumirubin (configurational isomer)\n   - Lumirubin เป็น water-soluble ขับออกทาง bile และ urine ได้โดยไม่ต้อง conjugation\n   - เป็น irreversible reaction → ขับออกได้เร็ว\n2. Structural isomerization:\n   - เปลี่ยนโครงสร้าง bilirubin เป็น lumirubin\n   - Lumirubin ขับทางไตได้\n3. Photo-oxidation:\n   - แสงทำให้ bilirubin เกิด oxidation เป็น colorless products\n   - เป็นกลไกรอง (minor pathway)\n\nOptimal Phototherapy Setup:\n- Wavelength: 460-490 nm (blue-green spectrum) → optimal absorption ของ bilirubin\n- Irradiance: > 30 µW/cm²/nm = intensive phototherapy\n- Distance: overhead unit ห่างจากทารก 10-15 cm (ยิ่งใกล้ยิ่ง irradiance สูง)\n- Surface area exposure: maximize ถอดเสื้อผ้า เหลือผ้าอ้อม + eye shield\n- Double phototherapy (overhead + biliblanket): เพิ่ม surface area ที่ได้รับแสง → ลด bilirubin เร็วขึ้น 30-50%\n- Eye protection: ใส่ eye shield ป้องกัน retinal damage ตรวจทุก shift ว่าไม่เลื่อน\n- Continuous phototherapy: หยุดเฉพาะตอนให้นมและเปลี่ยนผ้าอ้อม (ไม่เกิน 30 นาที/ครั้ง)\n\nExpected Rate of TSB Decline:\n- Intensive phototherapy ควรลด TSB 1-2 mg/dL ทุก 4-6 ชม. ในช่วงแรก\n- ผู้ป่วยรายนี้: ลด 1.3 → 1.2 → 0.9 mg/dL ทุก 4 ชม. = ตอบสนองดี\n- ถ้า TSB ลด < 0.5 mg/dL ใน 4-6 ชม. = poor response → ต้อง evaluate\n  - ตรวจ irradiance ของเครื่อง\n  - ดูว่า ongoing hemolysis สูง\n  - พิจารณา exchange transfusion\n- เป้าหมาย: TSB ลดลงต่ำกว่า phototherapy threshold 2-3 mg/dL → สามารถหยุด phototherapy",
      key_points: [
        "Photoisomerization เป็นกลไกหลักของ phototherapy เปลี่ยน bilirubin เป็น water-soluble form",
        "Intensive phototherapy ต้องมี irradiance > 30 µW/cm²/nm ที่ wavelength 460-490 nm",
        "Expected decline 1-2 mg/dL ทุก 4-6 ชม. ถ้าน้อยกว่านี้ต้อง evaluate",
        "Double phototherapy (overhead + biliblanket) เพิ่มประสิทธิภาพ 30-50%",
      ],
      time_minutes: 10,
    },
    {
      part_number: 4,
      title: "ส่วนที่ 4: Monitoring During Phototherapy",
      scenario:
        "TSB monitoring ต่อเนื่อง:\n- 24 ชม. หลังเริ่ม phototherapy: TSB 13.8 mg/dL (ลดจาก 18.5)\n- 36 ชม.: TSB 12.5 mg/dL\n- 48 ชม.: TSB 11.2 mg/dL\n\nObservations ระหว่าง phototherapy:\n- น้ำหนัก: 2.92 kg (ลดลงเล็กน้อยจาก 2.95 → 2.92) → total weight loss 8.75% จากแรกเกิด\n- Urine output: 6-8 ครั้ง/วัน สีเหลืองเข้ม\n- Stool: 3-4 ครั้ง/วัน สีเขียวเหลว (phototherapy stool)\n- BT: 37.0-37.3°C (เล็กน้อยสูง)\n- ดูดนมแม่ได้ดีขึ้น มารดาน้ำนมเริ่มมามากขึ้น\n- Skin: มี bronze discoloration เล็กน้อยบริเวณลำตัว\n- ทารก active ดูดนมดี ไม่ซึม\n\nRepeat labs:\n- Hb 13.5 g/dL (ลดจาก 14.8)\n- Reticulocyte 4.5%\n- Direct bilirubin 1.2 mg/dL (เพิ่มเล็กน้อย)",
      question:
        "จงอธิบาย complications ของ phototherapy, สิ่งที่ต้อง monitor, และ significance ของ findings ที่พบ",
      answer:
        "Complications ของ Phototherapy:\n1. Insensible water loss เพิ่มขึ้น 20-40%:\n   - จาก radiant heat + skin exposure\n   - ต้อง increase fluid intake (เพิ่มนมแม่ หรือ supplement formula/IV fluid)\n   - ผู้ป่วย: น้ำหนักลดเพิ่ม (8.75%) → ต้องเพิ่ม feeding\n2. Temperature instability:\n   - Hyperthermia หรือ hypothermia\n   - ผู้ป่วย: BT 37.0-37.3 → borderline → ปรับระยะห่างเครื่อง monitor ต่อ\n3. Bronze baby syndrome:\n   - เกิดเมื่อ direct bilirubin สูง + phototherapy → สร้าง bronze-colored photoproducts\n   - ผู้ป่วย: direct bilirubin เพิ่มเป็น 1.2 + bronze discoloration → mild bronze baby\n   - ไม่เป็นอันตราย หายได้เองเมื่อหยุด phototherapy\n   - แต่ถ้า direct bilirubin สูงมาก → ต้องหาสาเหตุ (biliary atresia, TORCH)\n4. Skin rash (maculopapular): พบได้ ไม่อันตราย\n5. Retinal damage: ป้องกันด้วย eye shield\n6. Loose greenish stools: เป็น photoisomer ที่ขับทาง bile → ปกติ\n7. Interference with mother-infant bonding: encourage kangaroo care ระหว่างให้นม\n\nสิ่งที่ต้อง Monitor:\n1. TSB ทุก 4-6 ชม. (intensive) หรือ 8-12 ชม. (standard)\n2. Weight วันละครั้ง: น้ำหนักลด > 10% → concern\n3. I/O: feeding volume, urine output (>= 6 wet diapers/day), stool frequency\n4. Temperature ทุก 3-4 ชม.\n5. Hydration status: mucous membranes, skin turgor, fontanelle\n6. Eye shield: ตรวจทุก shift ว่าอยู่ในตำแหน่งดี\n7. Hb/Hct: ดู ongoing hemolysis → ผู้ป่วย Hb ลดจาก 14.8 เป็น 13.5 → mild ongoing hemolysis\n8. Direct bilirubin: ถ้าสูงขึ้น > 20% ของ total → evaluate สำหรับ cholestasis\n\nSignificance ของ Findings:\n- น้ำหนักลด 8.75%: ใกล้ 10% threshold → เพิ่ม feeding + consider supplement\n- Bronze discoloration + direct bilirubin เพิ่ม: mild bronze baby syndrome → ไม่ต้องหยุด phototherapy แต่ monitor direct bilirubin\n- Hb ลดจาก 14.8 → 13.5: ongoing hemolysis จาก ABO incompatibility → ยังไม่ต้อง transfuse (Hb > 10)\n- TSB trending down อย่างต่อเนื่อง → phototherapy effective",
      key_points: [
        "Insensible water loss เพิ่ม 20-40% ระหว่าง phototherapy ต้องเพิ่ม fluid intake",
        "Bronze baby syndrome เกิดจาก direct bilirubin + phototherapy ไม่อันตราย หายเอง",
        "น้ำหนักลด > 10% จากแรกเกิด ต้อง supplement feeding",
        "Hb ที่ลดลงระหว่าง phototherapy อาจบ่งชี้ ongoing hemolysis ต้อง monitor",
      ],
      time_minutes: 10,
    },
    {
      part_number: 5,
      title: "ส่วนที่ 5: Exchange Transfusion Criteria",
      scenario:
        "สมมุติกรณี: ทารกอีกรายที่มีอาการรุนแรงกว่า (ใช้สำหรับการเรียนรู้ exchange transfusion)\n\nทารกชายอายุ 2 วัน (42 ชม.) กินนมแม่ น้ำหนัก 3.0 kg, GA 37 สัปดาห์\nมารดา O Rh negative, ทารก B Rh positive\nDAT: Strongly positive\nTSB: 25.2 mg/dL (สูงมาก) ที่อายุ 42 ชม.\nDirect bilirubin: 0.5 mg/dL\nHb: 10.5 g/dL (ต่ำ → severe hemolysis)\nReticulocyte: 9.8%\nAlbumin: 2.8 g/dL\n\nAAP Exchange Transfusion Threshold:\n- สำหรับ medium risk (>= 38 wk + risk factors) ที่ 42 ชม. ≈ 20 mg/dL\n- ผู้ป่วย TSB 25.2 >> 20 mg/dL → เกิน exchange threshold\n- Bilirubin/Albumin ratio = 25.2/2.8 = 9.0 (เกิน criteria ที่ 7.0)\n\nทารกมีอาการ: ซึม ดูดนมไม่ค่อยได้ high-pitched cry เป็นครั้งคราว",
      question:
        "จงอธิบาย indication สำหรับ exchange transfusion, ขั้นตอนการทำ, และ complications ที่อาจเกิด",
      answer:
        "Indications สำหรับ Exchange Transfusion:\n1. TSB เกิน AAP exchange threshold ตาม hour-specific nomogram:\n   - ผู้ป่วย: TSB 25.2 ที่ 42 ชม. >> threshold 20 mg/dL ✓\n2. TSB ไม่ลดลงหลัง intensive phototherapy 4-6 ชม. (TSB ลด < 1-2 mg/dL)\n3. TSB ยังคงสูงขึ้นแม้ให้ intensive phototherapy\n4. Signs of acute bilirubin encephalopathy (ABE):\n   - ผู้ป่วย: ซึม ดูดนมไม่ได้ high-pitched cry ✓ = intermediate ABE\n5. Bilirubin/Albumin ratio เกิน threshold:\n   - ผู้ป่วย: B/A ratio 9.0 > 7.0 ✓\n6. Severe anemia (Hb < 10-12 ใน symptomatic neonate):\n   - ผู้ป่วย: Hb 10.5 + severe hemolysis ✓\n\nขั้นตอนการทำ Exchange Transfusion:\n1. Preparation:\n   - ย้ายเข้า NICU, inform neonatologist + blood bank\n   - Blood: O Rh negative pRBC mixed กับ AB plasma (double volume = 160-170 mL/kg)\n   - ทารก 3.0 kg → ปริมาณ 480-510 mL\n   - Warm blood to 37°C\n   - Cross-match กับทั้งมารดาและทารก\n2. Vascular access:\n   - Umbilical venous catheter (UVC) เป็น standard → tip อยู่ที่ IVC/RA junction\n   - หรือ peripheral arterial + venous lines (isovolumetric method)\n3. Procedure (push-pull technique ผ่าน UVC):\n   - ดูด out 10-20 mL ทิ้ง\n   - Push in 10-20 mL donor blood\n   - สลับไปเรื่อยๆ จนครบ double volume\n   - ใช้เวลา 60-90 นาที\n   - ทุก 100 mL ตรวจ: glucose, calcium, electrolytes\n4. Post-procedure:\n   - ตรวจ TSB 1-2 ชม. หลัง exchange\n   - ให้ phototherapy ต่อ (rebound effect)\n   - Monitor glucose, calcium (hypoglycemia, hypocalcemia)\n   - CBC, electrolytes, coagulation profile\n\nComplications ของ Exchange Transfusion:\n1. Cardiovascular: arrhythmia, volume overload, cardiac arrest (1-3%)\n2. Metabolic: hypocalcemia (citrate in stored blood binds Ca2+), hypoglycemia, hyperkalemia\n3. Hematologic: thrombocytopenia, coagulopathy, hemolysis จาก donor blood\n4. Infectious: blood-borne infections (rare with screening)\n5. Mechanical: UVC complications (perforation, thrombosis, air embolism)\n6. Rebound hyperbilirubinemia: TSB เพิ่มกลับหลัง exchange → ต้อง phototherapy ต่อ\n7. Mortality rate: 0.3-0.5% ในศูนย์ที่มีประสบการณ์",
      key_points: [
        "Exchange transfusion ทำเมื่อ TSB เกิน AAP exchange threshold หรือมี signs of ABE",
        "Double volume exchange (160-170 mL/kg) สามารถลด TSB ได้ประมาณ 50%",
        "Hypocalcemia เป็น complication ที่พบบ่อยที่สุด จาก citrate ใน stored blood",
        "Signs of acute bilirubin encephalopathy: ซึม ดูดนมไม่ได้ high-pitched cry opisthotonus",
      ],
      time_minutes: 10,
    },
    {
      part_number: 6,
      title: "ส่วนที่ 6: Discharge Planning, Follow-up และ Breastfeeding Support",
      scenario:
        "กลับมาที่ผู้ป่วยรายเดิม (ทารกชายอายุ 3 วัน ABO incompatibility):\n\nหลัง intensive phototherapy 60 ชม. (รวม 5 วัน):\n- TSB: 10.2 mg/dL (ลดจาก 18.5)\n- หยุด phototherapy แล้ว\n- TSB rebound check 12 ชม. หลังหยุด: 11.5 mg/dL (เพิ่ม 1.3 แต่ยังต่ำกว่า phototherapy threshold)\n- TSB 24 ชม. หลังหยุด: 11.8 mg/dL (stable → ไม่ต้อง restart phototherapy)\n\nBreastfeeding assessment:\n- มารดาน้ำนมมาดีขึ้นมาก\n- ทารกดูดนมได้ดี latch ดี\n- น้ำหนักเริ่มขึ้น: 3.02 kg (จาก nadir 2.92 kg)\n- Urine 8 ครั้ง/วัน, stool 5 ครั้ง/วัน (สีเหลือง)\n\nLab ก่อน discharge:\n- Hb: 12.8 g/dL\n- Reticulocyte: 3.5% (ลดลง → hemolysis ลดลง)\n- TSB: 11.8 mg/dL\n- G6PD: confirmed normal",
      question:
        "จงวางแผน discharge ทั้ง criteria, medications, follow-up schedule, และ breastfeeding support plan",
      answer:
        "Discharge Criteria:\n1. TSB stable หรือ trending down หลังหยุด phototherapy 12-24 ชม.\n   - ผู้ป่วย: TSB 10.2 → 11.5 → 11.8 (stable, ไม่ถึง restart threshold) ✓\n2. Rebound TSB ไม่เกิน phototherapy threshold\n   - ผู้ป่วย: TSB 11.8 << threshold (~15 mg/dL) ✓\n3. ทารก active ดูดนมได้ดี\n4. น้ำหนักเริ่มเพิ่มขึ้น\n5. Adequate urine output (>= 6 ครั้ง/วัน) + stool output\n6. มารดาเข้าใจ warning signs\n\nMedications:\n- ไม่มียาเฉพาะที่ต้องให้\n- แนะนำ Vitamin D supplementation 400 IU/day (สำหรับ breastfed infants)\n\nFollow-up Schedule:\n1. Day 1-2 หลัง discharge:\n   - ตรวจ TSB (ดู rebound จาก ABO hemolysis ที่อาจ ongoing)\n   - ชั่งน้ำหนัก\n   - Assess breastfeeding\n2. Day 5-7 หลัง discharge:\n   - TSB ถ้ายังเหลือง\n   - CBC + reticulocyte (ดู late anemia จาก ongoing hemolysis)\n3. อายุ 2 สัปดาห์:\n   - Well baby visit\n   - น้ำหนัก (ควรกลับถึงน้ำหนักแรกเกิดภายใน 10-14 วัน)\n   - ตรวจตัวเหลือง (prolonged jaundice > 2 สัปดาห์ ต้อง investigate)\n4. อายุ 1 เดือน:\n   - CBC: ดู late anemia of ABO hemolytic disease (Hb อาจลดอีกที่อายุ 4-6 สัปดาห์)\n   - Reticulocyte count\n   - ถ้า Hb < 7-8 g/dL → อาจต้อง top-up transfusion\n5. อายุ 2-3 เดือน:\n   - CBC follow-up จน Hb stable\n\nBreastfeeding Support Plan:\n1. Lactation consultant assessment ก่อน discharge\n2. สอนมารดา proper latch technique, positioning\n3. กินนมแม่อย่างน้อย 8-12 ครั้ง/วัน\n4. Signs of adequate intake: >= 6 wet diapers, 3-4 stools/day, น้ำหนักขึ้น\n5. Supplement formula เฉพาะเมื่อจำเป็น (น้ำหนักลด > 10%)\n6. Breast pump ถ้ามารดาต้องเก็บน้ำนม\n7. Hotline number สำหรับปรึกษาปัญหาให้นม\n8. Follow-up ที่ breastfeeding clinic ภายใน 3-5 วัน\n\nParent Education (สิ่งที่ต้องสอนก่อนกลับบ้าน):\n- สังเกตตัวเหลือง: ดูที่แสงธรรมชาติ กดผิวหนังดูสีเหลือง\n- Warning signs ที่ต้องมาทันที: ซึม ไม่ดูดนม ร้องเสียงแหลม ตัวเหลืองมากขึ้น ตัวแข็ง\n- จดบันทึก feeding, urine, stool",
      key_points: [
        "TSB rebound check 12-24 ชม. หลังหยุด phototherapy จำเป็นเสมอ โดยเฉพาะใน hemolytic disease",
        "ABO hemolytic disease อาจทำให้เกิด late anemia ที่อายุ 4-6 สัปดาห์ ต้อง follow-up CBC",
        "Breastfeeding support เป็นหัวใจสำคัญของการดูแล neonatal jaundice",
        "Parent education เรื่อง warning signs ของ bilirubin encephalopathy สำคัญมากก่อน discharge",
      ],
      time_minutes: 10,
    },
  ],

  "รกเกาะต่ำ (Placenta Previa)": [
    {
      part_number: 1,
      title: "ส่วนที่ 1: Initial Assessment และ Ultrasound",
      scenario:
        "หญิงไทย อายุ 32 ปี G2P1 (เคยผ่าคลอด 1 ครั้ง เมื่อ 3 ปีก่อน) อายุครรภ์ 32 สัปดาห์ มาห้องฉุกเฉินด้วยเลือดออกทางช่องคลอดสดๆ ปริมาณปานกลาง ไม่เจ็บปวด (painless vaginal bleeding) เริ่มมีเลือดออกขณะนอนพัก 1 ชั่วโมงก่อนมา\n\nประวัติ: ANC ปกติ ผล anomaly scan 20 สัปดาห์ พบ low-lying placenta, อยู่ห่าง internal os 1.5 cm ยังไม่ได้ repeat scan\n\nสัญญาณชีพ: BP 105/68 mmHg, HR 98/min, RR 20/min, BT 36.9°C, SpO2 98%\nตรวจร่างกาย: Uterus soft, non-tender, fundal height 32 cm, fetal heart rate 148 bpm reactive, ไม่มี uterine contraction\nSpeculum exam: เลือดออกจาก cervical os ปริมาณปานกลาง cervix closed\n\n*** ห้ามทำ digital vaginal examination จนกว่าจะ rule out placenta previa ***\n\nTransabdominal ultrasound:\n- Singleton live fetus, cephalic presentation\n- Placenta: posterior, lower edge covering internal cervical os completely\n- Diagnosis: Complete (total) placenta previa\n- Amniotic fluid index: 14 cm (ปกติ)\n- Estimated fetal weight: 1,850 g (appropriate for gestational age)",
      question:
        "จงอธิบาย classification ของ placenta previa, risk factors, และวางแผน initial management",
      answer:
        "Classification ของ Placenta Previa (FIGO):\n1. Complete (Total) placenta previa: รกปิด internal os ทั้งหมด ← ผู้ป่วยรายนี้\n2. Partial placenta previa: รกปิด internal os บางส่วน\n3. Marginal placenta previa: ขอบรกอยู่ที่ขอบ internal os\n4. Low-lying placenta: ขอบรกอยู่ภายใน 2 cm จาก internal os แต่ไม่ถึง os\n\nRisk Factors ที่พบในผู้ป่วย:\n1. Previous cesarean section ✓ (เพิ่ม risk 2-3 เท่า)\n2. Multiparity (G2) ✓\n3. Risk factors อื่นที่ควรถาม: อายุมาก, previous uterine surgery, IVF, smoking, multiple pregnancy\n\nInitial Management:\n1. ABCs + IV access:\n   - Large bore IV x 2 (18G หรือใหญ่กว่า)\n   - IV fluid: Ringer's Lactate 1,000 mL stat\n   - Blood group + crossmatch 2-4 units pRBC\n2. Labs: CBC, coagulation profile (PT/PTT/fibrinogen), blood type + crossmatch, BUN/Cr\n3. Monitoring:\n   - Continuous fetal heart rate monitoring (CTG)\n   - Vital signs ทุก 15 นาที\n   - Pad count: บันทึกปริมาณเลือดออก\n   - Urine output via Foley catheter\n4. Absolute bed rest\n5. NPO (เผื่อต้องผ่าตัดฉุกเฉิน)\n6. ห้ามทำ digital vaginal examination: เพราะอาจ provoke massive hemorrhage จากการ disturb placenta\n7. Notify: senior obstetrician, anesthesiologist, neonatologist, blood bank\n8. Steroid for fetal lung maturity: Dexamethasone 6 mg IM ทุก 12 ชม. x 4 doses (เพราะ GA 32 wk < 34 wk)\n9. Tocolysis: ไม่แนะนำเป็น routine ใน active bleeding แต่ถ้า contractions มากอาจพิจารณา\n10. Anti-D: ถ้ามารดา Rh negative → ให้ Anti-D immunoglobulin",
      key_points: [
        "Painless vaginal bleeding ใน 2nd-3rd trimester ต้องนึกถึง placenta previa เป็นอันดับแรก",
        "ห้ามทำ digital vaginal exam จนกว่าจะ rule out placenta previa ด้วย ultrasound",
        "Previous cesarean section เป็น risk factor สำคัญ และเพิ่มความเสี่ยง placenta accreta spectrum",
        "Antenatal corticosteroid ให้เมื่อ GA < 34 สัปดาห์ เพื่อ promote fetal lung maturity",
      ],
      time_minutes: 10,
    },
    {
      part_number: 2,
      title: "ส่วนที่ 2: Classification และ Maternal Stabilization",
      scenario:
        "ผลตรวจเลือด:\n- CBC: Hb 10.2 g/dL (baseline ก่อนตั้งครรภ์ 12.5), Hct 30.5%, WBC 11,500, Plt 225,000\n- Blood group: B Rh positive\n- Coagulation: PT 12 sec (ปกติ), PTT 28 sec (ปกติ), Fibrinogen 380 mg/dL (ปกติ)\n- BUN 10, Cr 0.6\n\nCTG: Reactive tracing, baseline 148 bpm, variability ดี, no decelerations, no contractions\n\nเลือดออกลดลงเองหลัง bed rest 2 ชั่วโมง → spotting เท่านั้น\nPad count: ประมาณ 250 mL total\n\nTransvaginal ultrasound (ทำอย่างระวัง ไม่สอดเข้า cervical canal):\n- Complete placenta previa ยืนยัน\n- Placental edge overlaps internal os 3.2 cm\n- Placental thickness ที่ lower segment: 2.5 cm\n- No evidence of placenta accreta (no lacunae, intact myometrial-bladder interface)\n- Cervical length: 3.5 cm (ปกติ)",
      question:
        "จงอธิบายบทบาทของ transvaginal ultrasound ใน placenta previa, ประเมิน risk ของ placenta accreta spectrum, และ stabilize มารดา",
      answer:
        "บทบาทของ Transvaginal Ultrasound ใน Placenta Previa:\n- Transvaginal US ปลอดภัยและ accurate กว่า transabdominal US\n- Probe ไม่สอดเข้า cervical canal → ไม่ disturb placenta\n- ข้อดี:\n  1. วัดระยะห่างระหว่าง placental edge กับ internal os ได้แม่นยำ\n  2. Classify ชนิดของ previa ได้ถูกต้อง\n  3. วัด cervical length ได้ (สั้น = เสี่ยงคลอดก่อนกำหนด)\n  4. Evaluate placenta accreta spectrum (PAS)\n- ผู้ป่วย: complete previa, overlap os 3.2 cm → ไม่น่าจะ resolve เอง\n  - Overlap > 2 cm ที่ GA > 26 สัปดาห์ → unlikely to resolve → จะต้อง cesarean delivery\n\nRisk Assessment สำหรับ Placenta Accreta Spectrum (PAS):\nRisk factors ในผู้ป่วย:\n- Previous cesarean section ✓ (major risk factor)\n- Placenta previa ✓ (previa + previous CS = risk PAS 11-25%)\n\nUltrasound signs ของ PAS (ไม่พบในรายนี้):\n- Placental lacunae (Swiss cheese appearance)\n- Loss of retroplacental clear zone\n- Myometrial thinning < 1 mm\n- Bladder wall irregularity/interruption\n- Bridging vessels\n- ผู้ป่วยรายนี้: intact interface, no lacunae → low suspicion for PAS\n- แต่ negative US ไม่ได้ rule out PAS 100% → ต้อง prepare\n\nMaternal Stabilization:\n1. IV fluid: Ringer's Lactate maintain hydration\n2. Blood products: crossmatched 2 units pRBC available (Hb 10.2 → borderline)\n3. Transfuse ถ้า Hb < 7-8 g/dL หรือ hemodynamically unstable\n4. Corticosteroid: Dexamethasone เริ่มให้แล้ว (complete course 4 doses)\n5. Iron supplementation: Ferrous sulfate 325 mg TID + Vitamin C\n6. Bed rest: ปรับเป็น modified bed rest (bathroom privileges)\n7. Monitor: daily Hb ถ้ายังมี bleeding, fetal kick count\n8. Rhogam: ไม่จำเป็น (มารดา Rh positive)\n9. Anesthesia consultation: plan regional vs general สำหรับ cesarean",
      key_points: [
        "Transvaginal US ปลอดภัยและ accurate กว่า transabdominal US สำหรับ diagnose placenta previa",
        "Placenta previa + previous cesarean เพิ่ม risk ของ placenta accreta spectrum 11-25%",
        "Complete previa ที่ overlap os > 2 cm หลัง 26 สัปดาห์ unlikely to resolve",
        "ต้อง evaluate สำหรับ PAS ด้วย ultrasound ทุกรายที่มี previa + previous CS",
      ],
      time_minutes: 10,
    },
    {
      part_number: 3,
      title: "ส่วนที่ 3: Expectant Management และ Steroid",
      scenario:
        "เลือดหยุดออกแล้ว มารดาและทารกอาการ stable:\n\nPlan: Expectant management (เฝ้าระวังรอให้ทารกโตขึ้น)\n\nManagement ระหว่าง admit:\n- Bed rest with bathroom privileges\n- Dexamethasone 6 mg IM q 12 hr x 4 doses → ครบ course แล้ว\n- Magnesium sulfate for neuroprotection: ยังไม่ให้ (GA 32 wk, ยังไม่คลอด)\n- Daily fetal kick count\n- CTG twice daily\n- Weekly ultrasound: fetal growth + amniotic fluid\n- CBC ทุก 2 วัน (ดู Hb trend)\n- Iron supplementation\n- Blood products: maintain 2 units crossmatched pRBC available ตลอดเวลา\n\nDay 3 ใน ward: เลือดออกอีกเล็กน้อย (spotting) → observe → หยุดเอง\nDay 5: stable ไม่มีเลือดออก\nDay 7: CBC Hb 10.8 g/dL (ดีขึ้นจาก iron)\n\nPlan สำหรับ delivery:\n- Scheduled cesarean section ที่ GA 36-37 สัปดาห์ (ถ้า stable)\n- ถ้ามี significant rebleeding ก่อนถึง 36 สัปดาห์ → emergency cesarean\n- Neonatology standby\n- Anesthesia plan: spinal anesthesia (ถ้าไม่มี contraindication)",
      question:
        "จงอธิบาย rationale ของ expectant management, timing ของ delivery, และ role ของ antenatal corticosteroid และ magnesium sulfate",
      answer:
        "Rationale ของ Expectant Management:\n- เป้าหมาย: ให้ทารกอยู่ในครรภ์นานที่สุดเท่าที่ปลอดภัย เพื่อลด prematurity complications\n- GA 32 สัปดาห์ → ทารกยังเล็ก (1,850 g) ถ้าคลอดตอนนี้จะมี significant morbidity\n- ได้เมื่อ: bleeding หยุดเอง, มารดา hemodynamically stable, ทารก stable\n- ไม่ได้เมื่อ: massive hemorrhage, maternal instability, fetal distress, labor\n\nConditions สำหรับ Expectant Management:\n1. Inpatient admission จนคลอด (ห้ามให้กลับบ้าน ในกรณี complete previa ที่เคย bleed)\n2. IV access maintained ตลอด\n3. Blood products available 24/7\n4. Operating room available ทำ emergency cesarean ได้ภายใน 30 นาที\n5. Neonatal ICU available\n6. Patient education: แจ้งเรื่อง risk of recurrent bleeding\n\nTiming of Delivery:\n- ACOG/SMFM Recommendation:\n  - Asymptomatic complete previa: planned cesarean ที่ 36+0 ถึง 37+6 สัปดาห์\n  - หลัง bleeding episode ที่ stabilized: 34-36 สัปดาห์\n  - ผู้ป่วยรายนี้: หลัง single moderate bleed, stable → plan delivery ที่ 36-37 สัปดาห์\n- ถ้ามี recurrent significant bleed → deliver เมื่อไหร่ก็ตาม\n\nAntenatal Corticosteroid:\n- Indication: GA 24-34 สัปดาห์ ที่มี risk of preterm delivery ภายใน 7 วัน\n- ผู้ป่วย GA 32 สัปดาห์ → ให้ Dexamethasone 6 mg IM q 12 hr x 4 doses (ครบแล้ว ✓)\n- ผลดี:\n  1. ลด RDS (respiratory distress syndrome) 50%\n  2. ลด IVH (intraventricular hemorrhage)\n  3. ลด NEC (necrotizing enterocolitis)\n  4. ลด neonatal mortality\n- Rescue course: พิจารณาถ้า delivery หลังจาก first course > 14 วัน และ GA < 34 สัปดาห์\n\nMagnesium Sulfate for Neuroprotection:\n- Indication: GA < 32 สัปดาห์ ที่ anticipated delivery ภายใน 24 ชม.\n- ลด risk of cerebral palsy ในทารก\n- ผู้ป่วย GA 32 สัปดาห์ และยังไม่คลอด → ยังไม่ให้ตอนนี้\n- ให้เมื่อ: ถ้า preterm delivery anticipated < 32 สัปดาห์\n- Dose: 4 g IV loading over 20-30 min, then 1 g/hr infusion จนคลอดหรือ 24 ชม.",
      key_points: [
        "Expectant management ใน placenta previa เพื่อ prolong pregnancy ลด prematurity",
        "Complete previa ที่เคย bleed ต้อง admit จนคลอด ห้ามให้กลับบ้าน",
        "Planned cesarean ที่ 36-37 สัปดาห์ สำหรับ stable complete previa",
        "Antenatal corticosteroid ลด RDS, IVH, NEC, mortality ในทารกคลอดก่อนกำหนด",
      ],
      time_minutes: 10,
    },
    {
      part_number: 4,
      title: "ส่วนที่ 4: Massive Hemorrhage ที่ 35 สัปดาห์",
      scenario:
        "อายุครรภ์ 35+2 สัปดาห์ (3 สัปดาห์หลัง admit) ขณะนอนพัก:\n\nทันใดนั้น เลือดออกทางช่องคลอดปริมาณมาก สดๆ ไหลไม่หยุด ประมาณ 500 mL ใน 15 นาทีแรก\n\nสัญญาณชีพ: BP 85/55 mmHg, HR 128/min, RR 28/min, SpO2 95%\nGCS 15 แต่หน้าซีด เหงื่อแตก กระสับกระส่าย\n\nCTG: FHR baseline 170 bpm (tachycardia), variability ลดลง, variable decelerations\n\nEstimated blood loss: 800 mL ใน 30 นาที (ongoing)\n\nClass III hemorrhagic shock: สูญเสียเลือด 30-40% ของ blood volume",
      question:
        "จงจัดการ massive hemorrhage ตาม obstetric hemorrhage protocol, ตัดสินใจเรื่อง delivery, และอธิบาย massive transfusion protocol",
      answer:
        "Obstetric Hemorrhage Protocol:\n\n1. Call for help ทันที:\n   - Code Red / Massive hemorrhage alert\n   - Senior obstetrician, anesthesiologist, neonatologist, blood bank\n   - เพิ่ม nursing staff\n\n2. ABC Resuscitation:\n   A: Assess airway (patent, GCS 15)\n   B: High-flow O2 15 L/min via non-rebreather mask\n   C: Circulation:\n   - 2 large bore IV (14-16G) → ถ้ายังไม่มี\n   - Rapid fluid bolus: warm crystalloid 2 L stat\n   - Activate massive transfusion protocol (MTP)\n   - Left lateral tilt position (ลด aortocaval compression)\n\n3. Laboratory (stat):\n   - CBC, coagulation (PT/PTT/fibrinogen), crossmatch\n   - ABG + lactate\n   - Fibrinogen < 200 mg/dL → ให้ cryoprecipitate\n\n4. Tranexamic acid: 1 g IV over 10 min (ถ้าให้ภายใน 3 ชม. หลัง onset bleeding)\n\n5. Decision สำหรับ Delivery:\n   - ต้องทำ Emergency cesarean section ทันที (Category 1)\n   - Indications:\n     a. Massive uncontrolled hemorrhage → maternal life-threatening\n     b. Fetal distress (tachycardia 170, reduced variability, decelerations)\n     c. GA 35+2 → viable fetus\n   - Decision-to-delivery interval: < 30 นาที (ideally < 15 นาที)\n   - Anesthesia: General anesthesia (เร็วกว่า, hemodynamically unstable)\n\nMassive Transfusion Protocol (MTP):\n- Definition: > 10 units pRBC ใน 24 ชม. หรือ > 4 units ใน 1 ชม.\n- Ratio: pRBC : FFP : Platelet = 1:1:1 (balanced resuscitation)\n- เริ่มด้วย:\n  1. O-negative pRBC 2-4 units (uncrossmatched emergency blood)\n  2. FFP 2-4 units\n  3. Platelet 1 apheresis unit (ถ้า Plt < 75,000)\n  4. Cryoprecipitate 10 units (ถ้า fibrinogen < 200)\n- Monitor ทุก 30-60 นาที: Hb, coagulation, fibrinogen, calcium, pH\n- เป้าหมาย: Hb > 7-8 g/dL, Plt > 50,000, fibrinogen > 200, INR < 1.5\n- ให้ calcium gluconate: แก้ hypocalcemia จาก citrate ใน blood products\n- Warm blood products: ป้องกัน hypothermia",
      key_points: [
        "Class III hemorrhagic shock (30-40% blood loss) ต้อง massive transfusion ทันที",
        "Emergency cesarean (Category 1) ทำเมื่อมี maternal life-threatening hemorrhage หรือ fetal distress",
        "Massive transfusion protocol ใช้ ratio pRBC:FFP:Platelet = 1:1:1",
        "Tranexamic acid 1 g IV ภายใน 3 ชม. ลด mortality จาก postpartum hemorrhage",
      ],
      time_minutes: 10,
    },
    {
      part_number: 5,
      title: "ส่วนที่ 5: Emergency Cesarean Section",
      scenario:
        "ทำ Emergency cesarean section ภายใน 20 นาทีหลังตัดสินใจ ภายใต้ general anesthesia:\n\nOperative findings:\n- Midline vertical incision (เข้าท้องเร็ว)\n- Classical uterine incision (upper segment) เพราะ placenta อยู่ที่ lower segment\n- ทารกชาย น้ำหนัก 2,450 g, Apgar 6 (1 min) และ 8 (5 min)\n- Placenta: complete previa, posterior wall, ยึดติดแน่นที่ lower segment\n- ลอกรกออกยาก → สงสัย focal placenta accreta\n- เลือดออกมากจาก placental bed ที่ lower segment\n\nIntraoperative management:\n- Total EBL: 2,500 mL\n- Transfusion: pRBC 4 units, FFP 4 units, Platelet 1 unit, Cryoprecipitate 5 units\n- Uterotonics: Oxytocin 40 U/L IV + Ergometrine 0.2 mg IM + Carboprost (Hemabate) 250 mcg IM\n- Uterine compression sutures (B-Lynch) applied\n- Bilateral uterine artery ligation performed\n- Bleeding controlled หลัง artery ligation + compression sutures\n- ไม่จำเป็นต้อง hysterectomy\n- Estimated total blood loss: 2,500 mL",
      question:
        "จงอธิบาย surgical considerations ในการทำ cesarean สำหรับ placenta previa, stepwise approach ในการ control hemorrhage, และ management ของ focal placenta accreta",
      answer:
        "Surgical Considerations สำหรับ Cesarean ใน Placenta Previa:\n1. Incision:\n   - Abdominal: midline vertical preferred (เข้าถึงเร็ว, ดู field ได้กว้าง)\n   - Uterine: classical (upper segment) ถ้ารกอยู่ anterior lower segment\n   - หรือ transverse lower segment ถ้ารก posterior (ไม่ตัดผ่านรก)\n   - ผู้ป่วย: รก posterior → classical incision เลือกเพื่อ avoid cutting through placenta\n\n2. Delivery:\n   - ทำ amniotomy ก่อน deliver ทารก\n   - ถ้า placenta ขวาง → อาจต้อง incise through placenta edge → deliver ทารกเร็ว → clamp cord ทันที\n   - Neonatal team standby\n\n3. Placental removal:\n   - Attempt controlled cord traction + manual removal\n   - ถ้ารกไม่ลอก → สงสัย placenta accreta spectrum\n   - ผู้ป่วย: รกลอกยาก focal area → focal accreta\n\nStepwise Approach to Control Hemorrhage (จาก conservative → aggressive):\nStep 1: Uterotonics\n- Oxytocin 20-40 U ใน 1 L IV infusion\n- Ergometrine 0.2 mg IM (ห้ามใน hypertension)\n- Carboprost (15-methyl PGF2α) 250 mcg IM ทุก 15-90 นาที (max 8 doses)\n- Misoprostol 800-1,000 mcg rectal\n\nStep 2: Uterine massage + bimanual compression\n\nStep 3: Uterine tamponade\n- Bakri balloon: ใส่ใน uterus inflate 300-500 mL\n\nStep 4: Surgical interventions\n- Compression sutures (B-Lynch, Hayman, Cho) ✓ ทำแล้ว\n- Uterine artery ligation (bilateral) ✓ ทำแล้ว\n- Internal iliac artery ligation\n\nStep 5: Interventional radiology\n- Uterine artery embolization (UAE) ถ้า available\n\nStep 6: Hysterectomy (last resort)\n- Peripartum hysterectomy เมื่อ conservative measures ล้มเหลว\n\nManagement ของ Focal Placenta Accreta:\n- Focal accreta: รกฝังลึกเฉพาะบางส่วน (ไม่ใช่ทั้งหมด)\n- Management options:\n  1. ลอกรก focal area ด้วย sharp dissection + oversewing ของ bleeding bed\n  2. Compression sutures over the accreta site\n  3. ถ้า extensive → consider leaving placenta in situ (conservative) → methotrexate\n  4. ถ้า uncontrollable → hysterectomy\n- ผู้ป่วยรายนี้: ควบคุมได้ด้วย uterine artery ligation + B-Lynch → preserve uterus ได้",
      key_points: [
        "Classical uterine incision ใช้เมื่อ placenta อยู่ anterior lower segment เพื่อหลีกเลี่ยงการตัดผ่านรก",
        "Stepwise approach: uterotonics → tamponade → surgical (B-Lynch/artery ligation) → hysterectomy",
        "B-Lynch suture + uterine artery ligation สามารถ preserve uterus ได้ใน most cases",
        "Focal accreta อาจ manage conservatively ได้ด้วย surgical hemostasis โดยไม่ต้อง hysterectomy",
      ],
      time_minutes: 10,
    },
    {
      part_number: 6,
      title: "ส่วนที่ 6: Postpartum Hemorrhage และ Placenta Accreta Consideration",
      scenario:
        "Post-operative (ICU day 1):\n- BP 108/65 mmHg, HR 88/min, BT 37.2°C\n- Urine output 45 mL/hr\n- Post-op Hb 8.5 g/dL (หลัง transfuse 4 units pRBC)\n- Lochia: moderate, ไม่มี active bleeding\n- Uterus firm, well-contracted\n\nPost-op day 2:\n- Hb 9.2 g/dL (stable)\n- เริ่มกินอาหารเหลวได้\n- Pain controlled ด้วย PCA morphine\n- Foley catheter ยังคาอยู่ → urine clear\n\nทารก: NICU, weight 2,450 g, mild RDS ได้ CPAP, stable\n\nPost-op day 3:\n- ย้ายออกจาก ICU\n- เดินได้\n- เริ่มให้นมแม่ (ปั๊มนมไป NICU)\n\nPathology report ของ placenta:\n- Placenta previa totalis\n- Focal area ของ placenta accreta (villi attached directly to myometrium without intervening decidua) ขนาด 3 x 2 cm\n- ไม่มี increta หรือ percreta",
      question:
        "จงวางแผน post-operative care, counseling สำหรับ future pregnancy (risk of recurrence), และ long-term follow-up",
      answer:
        "Post-operative Care:\n1. ICU monitoring 24-48 ชม.:\n   - Vital signs ทุก 1-2 ชม. แล้วค่อยๆ ห่างออก\n   - Urine output > 0.5 mL/kg/hr\n   - Serial Hb ทุก 6-12 ชม. ใน 24 ชม. แรก\n   - Lochia assessment: ปริมาณ สี กลิ่น\n   - Uterine tone: ต้อง firm → massage ถ้า boggy\n2. Pain management:\n   - PCA morphine → transition to oral paracetamol + NSAIDs\n   - Avoid excessive opioids (ถ้า breastfeeding)\n3. VTE prophylaxis:\n   - Enoxaparin 40 mg SC OD (เริ่ม 6-12 ชม. หลังผ่าตัดถ้า hemostasis ดี)\n   - Sequential compression devices\n   - Early mobilization\n4. Antibiotics: Cefazolin 1 g IV q 8 hr x 24 ชม. (surgical prophylaxis)\n5. Iron supplementation: Ferrous sulfate 325 mg TID (Hb 9.2 → ต้องเพิ่ม)\n6. Breastfeeding support: ปั๊มนมทุก 2-3 ชม. ส่ง NICU\n7. Wound care: ดูแผล midline ดู signs of infection\n8. Bladder care: ถอด Foley post-op day 1-2 ถ้า urine clear\n\nCounseling สำหรับ Future Pregnancy:\n1. Risk of recurrence:\n   - Placenta previa recurrence: 4-8% ในครรภ์ถัดไป\n   - Placenta accreta spectrum: risk เพิ่มขึ้นมากกับจำนวน cesarean sections\n     - 1 previous CS + previa → accreta risk 3-11%\n     - 2 previous CS + previa → accreta risk 23-40%\n     - 3 previous CS + previa → accreta risk 35-61%\n   - ผู้ป่วยรายนี้ มี 2 CS scars แล้ว (1 previous + ครั้งนี้) → ถ้า previa อีก risk accreta สูงมาก\n2. Classical uterine incision:\n   - เพิ่ม risk ของ uterine rupture ในครรภ์ถัดไป (4-9%)\n   - ต้อง elective cesarean ที่ 36-37 สัปดาห์ ในครรภ์ถัดไป\n   - ห้ามลอง vaginal birth after cesarean (VBAC)\n3. Interpregnancy interval: แนะนำ >= 18-24 เดือน\n4. Contraception counseling:\n   - แนะนำ long-acting reversible contraception (LARC)\n   - IUD หรือ implant\n   - หรือ permanent sterilization ถ้าไม่ต้องการมีบุตรเพิ่ม\n\nLong-term Follow-up:\n1. 2 สัปดาห์: ดูแผล, Hb, ประเมิน recovery\n2. 6 สัปดาห์: postpartum visit complete, contraception, Pap smear ถ้า due\n3. 3 เดือน: Hb (ควรปกติ), breastfeeding assessment\n4. ถ้าตั้งครรภ์อีก: early US ที่ 12-16 สัปดาห์ดูตำแหน่งรก + plan CS ที่ tertiary center\n5. Psychological support: debrief traumatic birth experience, screen for PTSD/PPD",
      key_points: [
        "Risk ของ placenta accreta เพิ่มขึ้นอย่างมากตามจำนวน previous cesarean sections",
        "Classical uterine incision ห้าม VBAC ในครรภ์ถัดไป เพราะ risk uterine rupture สูง",
        "Contraception counseling สำคัญมาก โดยเฉพาะ LARC ใน high-risk patient",
        "ต้อง screen สำหรับ PTSD และ postpartum depression หลัง traumatic birth experience",
      ],
      time_minutes: 10,
    },
  ],

  "กระดูกหน้าแข้งหักแบบเปิด (Open Fracture Tibia)": [
    {
      part_number: 1,
      title: "ส่วนที่ 1: ATLS, Wound Assessment และ Gustilo Classification",
      scenario:
        "ชายไทย อายุ 28 ปี ถูกนำส่งห้องฉุกเฉินหลังอุบัติเหตุมอเตอร์ไซค์ชนรถบรรทุกเมื่อ 1 ชั่วโมงก่อน สวมหมวกกันน็อก ไม่หมดสติ บ่นปวดขาขวามาก\n\nPrimary survey (ATLS):\n- A (Airway): patent, C-spine clear clinically\n- B (Breathing): clear lung sounds bilateral, RR 22, SpO2 98% on RA\n- C (Circulation): BP 118/75, HR 105, skin warm, capillary refill 2 sec, มีเลือดออกจากแผลขาขวา ประเมิน 300 mL → ทำ direct pressure hemostasis\n- D (Disability): GCS 15, pupils equal reactive\n- E (Exposure): แผลเปิดที่ขาขวาบริเวณ anterior mid-shin ขนาด 6 x 3 cm กระดูก tibia ทิ่มออกนอกผิวหนัง ประมาณ 2 cm, มี moderate soft tissue contamination (ดิน กรวด), ขา deformed angulation, ไม่มีบาดแผลอื่น\n\nSecondary survey:\n- ขาขวา: swelling, deformity ที่ mid-tibia, open wound 6 x 3 cm with bone protruding\n- Distal pulse: dorsalis pedis pulse palpable แต่ weak, posterior tibial pulse palpable\n- Sensation: ปกติทั้ง superficial และ deep\n- Motor: สามารถขยับนิ้วเท้าได้ แต่ปวดมาก\n- Compartments: soft ยังไม่ตึง\n- ข้อเข่าและข้อเท้า: ไม่มี obvious injury\n\nX-ray right leg (AP + lateral):\n- Comminuted fracture mid-shaft tibia with butterfly fragment\n- Associated fibula fracture at same level\n- Bone fragment protruding through skin anteriorly",
      question:
        "จง classify open fracture ตาม Gustilo-Anderson classification, อธิบาย initial wound management, และ primary survey pearls",
      answer:
        "Gustilo-Anderson Classification:\n- Type I: แผล < 1 cm, clean, minimal soft tissue damage, simple fracture pattern\n- Type II: แผล 1-10 cm, moderate soft tissue damage, no flap/avulsion\n- Type IIIA: แผล > 10 cm หรือ high-energy injury, adequate soft tissue coverage\n- Type IIIB: แผล > 10 cm + extensive soft tissue loss, periosteal stripping, ต้อง flap coverage\n- Type IIIC: มี vascular injury ที่ต้อง repair\n\nผู้ป่วยรายนี้: Gustilo Type IIIA\n- แผล 6 x 3 cm (moderate size)\n- High-energy mechanism (motorcycle accident)\n- Comminuted fracture with butterfly fragment\n- Bone protruding through skin\n- Moderate contamination\n- แต่ soft tissue coverage ยังพอ (ไม่ต้อง flap)\n- Vascular intact (pulses present)\n\nInitial Wound Management:\n1. Photograph wound (ถ่ายรูปบันทึก → ลดจำนวนครั้งที่เปิดดูแผล)\n2. Remove gross contamination: เอาดิน กรวด ออกอย่างนุ่มนวล\n3. Irrigate wound: NSS 1-2 L low-pressure irrigation เบื้องต้น\n4. Moist sterile dressing: ปิดด้วย gauze ชุบ NSS + sterile wrap\n5. ห้าม push กระดูกกลับเข้าไป ในห้องฉุกเฉิน\n6. Splint: apply well-padded posterior splint ใน position of comfort\n7. Elevate extremity\n8. Reduce fracture ถ้า neurovascular compromise (ดัด gross alignment)\n9. Tetanus prophylaxis: Td vaccine + TIG (tetanus immunoglobulin) ถ้า incomplete vaccination\n10. IV antibiotics ทันที (ภายใน 1 ชม. จาก injury)\n\nPrimary Survey Pearls ใน Open Fracture:\n- C-spine protection จนกว่าจะ clear\n- Hemorrhage control ด้วย direct pressure (ห้าม clamp blindly)\n- Assess distal neurovascular status ก่อนและหลัง splint ทุกครั้ง\n- Document time of injury (สำคัญสำหรับ timing ของ debridement)\n- ตรวจหา associated injuries: head, chest, abdomen, pelvis, spine\n- Assume contaminated wound จนกว่าจะ debride ใน OR",
      key_points: [
        "Gustilo IIIA: high-energy injury + comminuted fracture + adequate soft tissue coverage",
        "IV antibiotics ต้องให้ภายใน 1 ชั่วโมงจาก injury เพื่อลด infection rate",
        "ห้ามดันกระดูกกลับเข้าไปในห้องฉุกเฉิน → debridement ในห้องผ่าตัด",
        "ถ่ายรูปแผลเพื่อลดจำนวนครั้งที่เปิดดู ลด contamination",
      ],
      time_minutes: 10,
    },
    {
      part_number: 2,
      title: "ส่วนที่ 2: Tetanus Prophylaxis, Antibiotics และ Irrigation",
      scenario:
        "ให้การรักษาเบื้องต้น:\n\nTetanus status: ได้รับ Td vaccine ครบชุดตอนเด็ก แต่ไม่เคยฉีด booster (> 10 ปี)\n→ ให้ Td vaccine 0.5 mL IM + Tetanus Immunoglobulin (TIG) 250 IU IM\n\nAntibiotics (ตาม Gustilo type IIIA):\n- Cefazolin 2 g IV stat แล้วต่อ 1 g IV q 8 hr\n- Gentamicin 5 mg/kg IV OD (สำหรับ Gram-negative coverage ใน Type III)\n- High-dose Penicillin 4 MU IV q 4 hr (สำหรับ Clostridium coverage ในแผลปนเปื้อนดิน)\n\nPain management:\n- Morphine 4 mg IV + Paracetamol 1 g IV\n- Femoral nerve block โดย anesthesiologist\n\nPre-operative assessment:\n- Labs: CBC (Hb 12.5, WBC 14,200, Plt 310,000), BMP ปกติ, coag ปกติ, blood group B Rh+\n- CXR: ปกติ\n- ECG: sinus tachycardia (HR 105)\n\nPlanned: Emergent surgical debridement + external fixation ภายใน 6 ชั่วโมงจาก injury",
      question:
        "จงอธิบาย antibiotic protocol ตาม Gustilo classification, หลักการของ wound irrigation, และ timing of surgical debridement",
      answer:
        "Antibiotic Protocol ตาม Gustilo Classification:\nType I:\n- Cefazolin 2 g IV then 1 g q 8 hr (Gram-positive coverage)\n- Duration: 24 ชม. หลัง wound closure\n\nType II:\n- Cefazolin 2 g IV then 1 g q 8 hr\n- Duration: 24 ชม. หลัง wound closure\n\nType III (ผู้ป่วยรายนี้ = IIIA):\n- Cefazolin 2 g IV then 1 g q 8 hr (Gram-positive)\n- + Gentamicin 5 mg/kg IV OD (Gram-negative)\n- Duration: 72 ชม. หลัง injury หรือ 24 ชม. หลัง wound closure (แล้วแต่อะไรนานกว่า)\n- + High-dose Penicillin ถ้ามี soil contamination → Clostridium coverage\n\nTiming ของ Antibiotic:\n- ให้ภายใน 1 ชั่วโมงจาก injury → ลด infection rate อย่างมีนัยสำคัญ\n- ผู้ป่วยรายนี้: injury 1 ชม. ก่อนมา → ต้องให้ทันทีที่ ER\n\nหลักการ Wound Irrigation:\n1. Volume: ขึ้นกับ Gustilo type\n   - Type I: 3 L\n   - Type II: 6 L\n   - Type III: 9-12 L\n   - ผู้ป่วย (IIIA): อย่างน้อย 9 L\n2. Solution: Normal saline เป็น standard\n   - ไม่แนะนำ antiseptic solutions (chlorhexidine, betadine) → toxic to tissues\n   - FLOW trial: soap (castile soap) อาจดีกว่า saline ใน contaminated wounds\n3. Pressure:\n   - Low-pressure irrigation (gravity หรือ bulb syringe) ดีกว่า high-pressure\n   - High-pressure pulsatile lavage อาจ push bacteria deeper\n   - FLOW trial สนับสนุน low-pressure irrigation\n4. Technique:\n   - Systematic irrigation ทุก tissue plane\n   - Remove all visible foreign material\n   - Irrigate ก่อนและหลัง debridement\n\nTiming of Surgical Debridement:\n- เดิม: 6-hour rule (debridement ภายใน 6 ชม.)\n- ปัจจุบัน: ไม่มี strict 6-hour cutoff แต่ยิ่งเร็วยิ่งดี\n- Recommendation:\n  - Type I-II: ภายใน 24 ชม. (ถ้า antibiotics ให้แล้ว)\n  - Type III: ภายใน 6-12 ชม. (เร็วที่สุดเท่าที่ทำได้)\n  - ผู้ป่วย (IIIA): plan ภายใน 6 ชม. → เหมาะสม\n- สิ่งสำคัญกว่า timing: quality ของ debridement และ early antibiotics",
      key_points: [
        "Gustilo III ต้องได้ Cefazolin + Gentamicin + Penicillin (ถ้ามี soil contamination)",
        "Low-pressure irrigation ด้วย NSS 9-12 L สำหรับ Gustilo III เป็น standard",
        "Early antibiotics (ภายใน 1 ชม.) สำคัญกว่า timing ของ debridement",
        "FLOW trial: low-pressure + normal saline (หรือ soap) เป็น evidence-based irrigation",
      ],
      time_minutes: 10,
    },
    {
      part_number: 3,
      title: "ส่วนที่ 3: Surgical Debridement และ External Fixation",
      scenario:
        "เข้าห้องผ่าตัดที่ 4 ชั่วโมงหลัง injury:\n\nSurgical debridement:\n- General anesthesia\n- Tourniquet ไม่ใช้ (ต้องดู tissue viability)\n- ขยายแผลตาม longitudinal axis ของ leg (wound extension)\n- Irrigate 9 L NSS low-pressure\n- Debride:\n  - ผิวหนัง: ตัดขอบแผลที่ devitalized ออก minimal (ไม่ตัดมากเพราะ anterior tibia มี limited soft tissue)\n  - Subcutaneous fat: ตัด non-viable tissue\n  - กล้ามเนื้อ: ตัดกล้ามเนื้อที่ไม่ viable (ใช้ 4C criteria: Color, Consistency, Contractility, Capacity to bleed)\n  - กระดูก: ล้าง bone fragments ที่ completely detached (no periosteal attachment) ทิ้ง, เก็บ butterfly fragment ที่ยังมี soft tissue attachment\n- ล้างซ้ำ 3 L หลัง debridement\n\nExternal fixation:\n- Delta frame external fixator applied:\n  - 2 half-pins ที่ proximal tibia (medial surface)\n  - 2 half-pins ที่ distal tibia (medial surface)\n  - 1 half-pin ที่ calcaneus (spanning ankle ถ้า unstable)\n- Fracture reduced under fluoroscopy → acceptable alignment\n- Wound left open ปิดด้วย wet-to-dry dressing + VAC (negative pressure wound therapy) -125 mmHg\n\nPost-op:\n- ขา alignment ดี, distal pulse present, sensation intact\n- Plan: second-look debridement ใน 48-72 ชม.",
      question:
        "จงอธิบาย principles ของ surgical debridement ใน open fracture, indications สำหรับ external fixation vs IM nail, และ role ของ negative pressure wound therapy (NPWT)",
      answer:
        "Principles ของ Surgical Debridement:\n1. Wound extension:\n   - ขยายแผลตาม longitudinal axis ให้เห็นทุก zone of injury\n   - ไม่ขยายตั้งฉาก (ลดปัญหา wound closure ทีหลัง)\n\n2. Systematic debridement (outside-in):\n   - Skin: ตัด devitalized edges อย่างประหยัด (โดยเฉพาะ anterior tibia ที่มี limited soft tissue)\n   - Subcutaneous tissue: ตัด necrotic fat\n   - Fascia: เปิด fasciotomy ถ้าสงสัย compartment syndrome\n   - Muscle: ใช้ 4C criteria\n     - Color: สีแดงดี vs สีเทา/น้ำตาล\n     - Consistency: elastic vs mushy\n     - Contractility: หดตัวเมื่อกระตุ้น vs ไม่หดตัว\n     - Capacity to bleed: มีเลือดออกเมื่อตัด vs ไม่มี\n   - Bone: ล้าง free fragments (no periosteal attachment), เก็บ fragments ที่มี attachment\n\n3. Serial debridement (ผู้ป่วยรายนี้):\n   - แผล Gustilo III ไม่ปิดแผลทันที\n   - Second-look ที่ 48-72 ชม. เพื่อ re-assess viability และ debride เพิ่ม\n   - อาจต้อง debride 2-3 ครั้ง\n\nExternal Fixation vs IM Nail:\nExternal fixation (เลือกในกรณีนี้ ✓):\n- Indications:\n  1. Severely contaminated wound\n  2. Gustilo IIIB/IIIC\n  3. Damage control orthopedics (polytrauma)\n  4. Need for repeated wound access (ผู้ป่วยรายนี้: planned serial debridement)\n  5. Extensive soft tissue injury\n- เป็น temporary fixation ก่อน definitive fixation\n\nIM nail (Intramedullary nail):\n- สามารถทำเป็น primary definitive fixation ใน:\n  1. Gustilo I-II\n  2. Gustilo IIIA (selected cases, clean after debridement)\n  3. Centers ที่มีประสบการณ์\n- ข้อดี: load-sharing, early weight bearing, ไม่มี pin tract infection\n- Timing: primary (วันแรก) หรือ delayed (5-14 วัน) หลัง soft tissue stable\n\nRole ของ NPWT (VAC Therapy):\n- Mechanism: constant negative pressure (-75 to -125 mmHg) ดูดผ่าน foam dressing\n- ประโยชน์:\n  1. ลด bacterial load ที่ wound surface\n  2. ลด wound edema, ดึง interstitial fluid ออก\n  3. เพิ่ม blood flow ที่ wound bed → promote granulation\n  4. ช่วย approximate wound edges\n  5. ป้องกัน desiccation ของ exposed tissues\n- ใช้ temporary coverage ระหว่างรอ definitive wound closure หรือ flap\n- เปลี่ยนทุก 48-72 ชม. พร้อม serial debridement",
      key_points: [
        "4C criteria สำหรับ assess muscle viability: Color, Consistency, Contractility, Capacity to bleed",
        "External fixation เหมาะสำหรับ damage control ใน severe open fracture ก่อน definitive fixation",
        "Serial debridement ทุก 48-72 ชม. จนแผลสะอาดเป็น standard สำหรับ Gustilo III",
        "NPWT (VAC) ลด infection rate และ promote wound healing ระหว่างรอ definitive closure",
      ],
      time_minutes: 10,
    },
    {
      part_number: 4,
      title: "ส่วนที่ 4: Definitive Fixation (IM Nail) Planning",
      scenario:
        "Second-look debridement ที่ 48 ชม.:\n- แผลสะอาดขึ้น ไม่มี necrotic tissue เหลือ\n- Granulation tissue เริ่มขึ้น\n- Wound culture: no growth (ดี)\n- Irrigate เพิ่มอีก 6 L\n- เปลี่ยน VAC dressing ใหม่\n\nPost-op day 5 (third look):\n- แผลสะอาดดี healthy granulation tissue\n- No signs of infection\n- Lab: WBC 9,800, CRP 35 (ลดลง)\n- Soft tissue swelling ลดลงมาก\n\nOrthopedic team plan:\n- แผลพร้อมสำหรับ definitive fixation\n- Convert external fixator → Reamed intramedullary nail\n- Timing: post-injury day 7-10 (หลัง soft tissue settle)\n\nPre-op planning:\n- Fracture pattern: comminuted mid-shaft tibia + fibula (ไม่ extend เข้าข้อ)\n- Canal diameter (CT): 10 mm → plan IM nail 9 mm\n- Nail length: วัดจาก contralateral leg + CT measurement\n- Locking: static locking (both proximal and distal) เพราะ comminuted",
      question:
        "จงอธิบาย principles ของ IM nailing สำหรับ tibial shaft fracture, ข้อดีข้อเสียของ reamed vs unreamed nail, และ post-operative weight bearing protocol",
      answer:
        "Principles ของ IM Nailing สำหรับ Tibial Shaft Fracture:\n1. Gold standard สำหรับ diaphyseal tibia fracture ในผู้ใหญ่\n2. Biological fixation: ไม่เปิดตรง fracture site → preserve blood supply\n3. Load-sharing device: nail รับ load ร่วมกับกระดูก\n4. Entry point: transpatellar approach (medial parapatellar หรือ suprapatellar)\n   - Suprapatellar approach: ทำในท่า semi-extended → ลด anterior knee pain\n5. Reaming: ใช้ flexible reamer ขยาย medullary canal ก่อนใส่ nail\n6. Nail insertion: สอด nail จาก proximal เข้า canal ลงไป distal\n7. Locking screws:\n   - Static locking: ใส่ทั้ง proximal และ distal → ป้องกัน shortening, rotation\n   - Dynamic locking: ใส่ screw เฉพาะด้านเดียว → allow axial compression\n   - ผู้ป่วย comminuted → static locking (ป้องกัน shortening)\n8. Reduction: อาจใช้ blocking screws (Poller screws) ช่วย guide nail ใน metaphyseal fracture\n\nReamed vs Unreamed Nail:\nReamed nail (เลือกในกรณีนี้ ✓):\n- ข้อดี:\n  1. ใส่ nail ขนาดใหญ่ได้ → stronger, less likely to break\n  2. Reaming debris (bone graft autograft) กระจายที่ fracture site → promote healing\n  3. Lower rate of implant failure\n  4. Higher union rate\n- ข้อเสีย:\n  1. Reaming ทำลาย endosteal blood supply\n  2. เพิ่ม fat embolism risk (minimal clinical significance)\n  3. เพิ่ม intramedullary pressure\n\nUnreamed nail:\n- ข้อดี: preserve endosteal blood supply, less thermal damage\n- ข้อเสีย: nail เล็กกว่า, higher failure rate, higher non-union rate\n- Indication: ใช้ใน Gustilo IIIB/IIIC ที่มี vascular injury (ลด further insult ต่อ blood supply)\n\nEvidence (SPRINT trial): Reamed nail ดีกว่า unreamed nail ใน closed fracture + Gustilo I-III (ลด reoperation rate)\n\nPost-operative Weight Bearing Protocol:\n1. Post-op day 1-2:\n   - Knee/ankle range of motion exercises\n   - Quadriceps/ankle pump exercises\n   - Elevate leg\n2. Week 1-2:\n   - Touch-down weight bearing (TDWB) 10-20% body weight ด้วยไม้ค้ำ\n3. Week 4-6:\n   - Partial weight bearing (PWB) 50% ด้วยไม้ค้ำ\n   - ขึ้นกับ fracture pattern + fixation stability\n4. Week 8-12:\n   - Full weight bearing (FWB) ถ้า X-ray แสดง callus formation\n   - Comminuted fracture อาจต้อง delay FWB\n5. Follow-up X-ray ทุก 4-6 สัปดาห์ดู fracture healing\n6. Expected union time: 16-24 สัปดาห์ สำหรับ open comminuted fracture",
      key_points: [
        "Reamed IM nail เป็น gold standard สำหรับ tibial shaft fracture ลด reoperation rate",
        "Static locking ใช้ใน comminuted fracture เพื่อป้องกัน shortening และ malrotation",
        "Convert external fixator เป็น IM nail ที่ day 7-14 หลัง soft tissue stable",
        "Weight bearing progression: TDWB → PWB → FWB ตาม fracture healing บน X-ray",
      ],
      time_minutes: 10,
    },
    {
      part_number: 5,
      title: "ส่วนที่ 5: Compartment Syndrome Complication",
      scenario:
        "Post-IM nailing 8 ชั่วโมง (post-injury day 8) ผู้ป่วยบ่นปวดขาขวามากขึ้นเรื่อยๆ:\n\nอาการ:\n- Pain score 9/10 ไม่ดีขึ้นด้วย morphine PCA\n- Pain on passive stretch of toes (ยืดนิ้วเท้า → ปวดมากที่น่อง)\n- ขา swelling เพิ่มขึ้น anterior compartment ตึงมาก\n- Paresthesia ที่ first web space (dorsal foot)\n\nตรวจร่างกาย:\n- Anterior compartment: tense, tender\n- Deep posterior compartment: firm\n- Lateral compartment: tense\n- Dorsalis pedis pulse: ยังคลำได้ (NOTE: pulse อาจ present ได้แม้มี compartment syndrome)\n- Active dorsiflexion of great toe: weak (ปกติ EHL ทำ dorsiflexion)\n\nCompartment pressure measurement (Stryker STIC device):\n- Anterior compartment: 45 mmHg\n- Lateral compartment: 38 mmHg\n- Deep posterior compartment: 42 mmHg\n- Superficial posterior compartment: 25 mmHg\n- Diastolic BP: 70 mmHg → Delta pressure (diastolic - compartment) = 70-45 = 25 mmHg\n\nDelta pressure < 30 mmHg → diagnostic for compartment syndrome",
      question:
        "จงอธิบาย pathophysiology, diagnosis criteria, และ emergency management (fasciotomy technique) ของ compartment syndrome",
      answer:
        "Pathophysiology ของ Compartment Syndrome:\n1. Injury → tissue edema, bleeding ใน fascial compartment\n2. Compartment pressure เพิ่มขึ้น (ภายในเปลือกหุ้มที่ไม่ยืด)\n3. Pressure > capillary perfusion pressure → ลด blood flow\n4. Ischemia → cell death → more edema → pressure สูงขึ้น (vicious cycle)\n5. ถ้าไม่รักษาภายใน 6-8 ชม. → irreversible muscle necrosis (Volkmann's contracture)\n6. Severe cases → rhabdomyolysis → myoglobinuria → acute kidney injury\n\n4 Compartments ของ Lower Leg:\n1. Anterior: tibialis anterior, EHL, EDL, deep peroneal nerve\n2. Lateral: peroneus longus/brevis, superficial peroneal nerve\n3. Deep posterior: tibialis posterior, FHL, FDL, posterior tibial nerve/artery\n4. Superficial posterior: gastrocnemius, soleus, sural nerve\n\nDiagnostic Criteria:\nClinical (6 P's - but late signs except pain):\n1. Pain: out of proportion, pain on passive stretch (เร็วที่สุด + sensitive ที่สุด)\n2. Pressure: compartment ตึง\n3. Paresthesia: altered sensation (deep peroneal → 1st web space)\n4. Paralysis: weakness (late sign)\n5. Pulselessness: very late sign → pulse อาจ present จนกว่าจะ severe\n6. Pallor: very late sign\n\nObjective measurement:\n- Compartment pressure > 30 mmHg: suspicious\n- Delta pressure (diastolic BP - compartment pressure) < 30 mmHg: DIAGNOSTIC ✓\n- ผู้ป่วย: delta = 70-45 = 25 mmHg < 30 → confirmed compartment syndrome\n\nEmergency Management - Four-Compartment Fasciotomy:\n- ต้องทำทันที (ภายใน 6 ชม. จาก onset)\n- Technique: Two-incision four-compartment fasciotomy\n\nLateral incision (anterolateral):\n- วางแนว 2 cm anterior to fibula, จาก fibular head ถึง lateral malleolus\n- เปิด anterior compartment\n- เปิด lateral compartment (ผ่าน intermuscular septum)\n\nMedial incision (posteromedial):\n- วางแนว 2 cm posterior to medial tibial border\n- เปิด superficial posterior compartment\n- เปิด deep posterior compartment (ถอด soleus attachment จาก tibia)\n\nPost-fasciotomy:\n- แผลเปิดทิ้งไว้ (ห้ามปิด)\n- ปิดด้วย vessel loops (shoelace technique) หรือ VAC\n- Delayed primary closure หรือ skin graft ที่ 48-72 ชม. เมื่อ swelling ลด\n- Monitor: CK, myoglobin, renal function (rhabdomyolysis risk)\n- IV fluid: aggressive hydration 150-200 mL/hr เพื่อ prevent AKI",
      key_points: [
        "Pain out of proportion + pain on passive stretch เป็น earliest signs ของ compartment syndrome",
        "Delta pressure (diastolic BP - compartment pressure) < 30 mmHg เป็น diagnostic criteria",
        "Pulse ยัง present ได้ใน compartment syndrome ห้ามใช้ pulse เป็น criterion เดียว",
        "Four-compartment fasciotomy ผ่าน 2 incisions เป็น definitive treatment ต้องทำภายใน 6 ชม.",
      ],
      time_minutes: 10,
    },
    {
      part_number: 6,
      title: "ส่วนที่ 6: Wound Coverage และ Rehabilitation",
      scenario:
        "หลัง four-compartment fasciotomy:\n- Compartment pressures ลดลง < 20 mmHg ทุก compartment\n- Muscle viable ทั้งหมด (สีชมพู หดตัวได้)\n- CK peak 8,500 U/L (สูง) → rhabdomyolysis ระดับ mild-moderate\n- Cr คงที่ 1.0 (no AKI)\n- Aggressive IV fluid 150 mL/hr x 48 ชม.\n\nDay 3 หลัง fasciotomy:\n- Swelling ลดลงมาก\n- Fasciotomy wounds: gradual closure ด้วย vessel loop technique\n- Open fracture wound: VAC therapy ต่อ\n\nDay 7 หลัง fasciotomy (post-injury day 15):\n- Fasciotomy wounds: ปิดได้ด้วย delayed primary closure\n- Open fracture wound (6 x 3 cm): healthy granulation tissue แต่ไม่สามารถ close ด้วย primary closure (skin deficit)\n- Plan: Split-thickness skin graft (STSG) จาก thigh\n\nDay 10 หลัง fasciotomy:\n- STSG applied → take ดี 100%\n- IM nail อยู่ในตำแหน่งดี, alignment maintained\n\nDay 14 (post-injury day 22):\n- ผู้ป่วย stable, wounds healing\n- เริ่ม rehabilitation program",
      question:
        "จงอธิบาย wound coverage options สำหรับ open fracture, rehabilitation program ระยะสั้นและระยะยาว, และ expected outcomes",
      answer:
        "Wound Coverage Options สำหรับ Open Fracture:\n1. Primary closure: ทำได้ใน Gustilo I-II ที่แผลสะอาด (ห้ามใน Gustilo III)\n2. Delayed primary closure (DPC):\n   - ปิดแผลหลัง serial debridement 3-5 วัน เมื่อแผลสะอาด\n   - ใช้ได้เมื่อ skin edges เข้าถึงกันได้\n3. Split-thickness skin graft (STSG) ← ผู้ป่วยรายนี้:\n   - ใช้เมื่อมี skin deficit แต่ wound bed มี healthy granulation\n   - ห้ามวางบน exposed bone/tendon ที่ไม่มี periosteum/paratenon\n   - Donor site: thigh เป็น common site\n   - ข้อดี: simple, quick coverage\n   - ข้อจำกัด: ไม่ทนทานเท่า flap, ไม่ cover exposed bone\n4. Local flaps:\n   - Gastrocnemius flap: สำหรับ proximal 1/3 tibia defect\n   - Soleus flap: สำหรับ middle 1/3 tibia defect\n5. Free flap (microsurgery):\n   - สำหรับ distal 1/3 tibia defect หรือ large defects ที่ local flap ไม่พอ\n   - Free latissimus dorsi flap, ALT (anterolateral thigh) flap\n   - ต้อง plastic/microsurgeon\n6. Timing: soft tissue coverage ควรทำภายใน 7 วัน (Godina principle) เพื่อ ลด infection\n\nRehabilitation Program:\nPhase 1: Acute (Week 1-4 post-op):\n- Ankle pump exercises, quadriceps sets, SLR\n- Knee ROM exercises (0-90 degrees)\n- Ankle ROM exercises\n- TDWB ด้วย crutches\n- Wound care\n- Edema control: elevation, ice\n\nPhase 2: Intermediate (Week 4-12):\n- Progressive weight bearing: TDWB → PWB (50%) → FWB\n- Advance ตาม X-ray callus formation\n- Strengthening: progressive resistance exercises\n- Balance training\n- Aquatic therapy (หลังแผลหายดี)\n- Gait training progression: crutches → cane → independent\n\nPhase 3: Advanced (Month 3-6):\n- Full weight bearing activities\n- Sport-specific training (ถ้าต้องการ)\n- Running progression (เมื่อ X-ray union + painless FWB)\n- Return to work planning\n- Psychological support: accident-related anxiety, PTSD screening\n\nExpected Outcomes:\n- Fracture union: 16-24 สัปดาห์ (comminuted open fracture อาจนานกว่า)\n- Non-union rate: 5-10% สำหรับ open tibia fracture\n- Infection rate: Gustilo IIIA = 5-10%\n- Return to work (sedentary): 3-4 เดือน\n- Return to physical work: 6-9 เดือน\n- Return to sport: 9-12 เดือน\n- Long-term issues: chronic pain (20-30%), knee pain จาก nail entry point, hardware removal (ถ้า symptomatic)",
      key_points: [
        "Soft tissue coverage ควรทำภายใน 7 วัน (Godina principle) เพื่อลด infection rate",
        "STSG เหมาะสำหรับ wound ที่มี granulation tissue แต่ไม่มี exposed bone",
        "Rehabilitation เป็นขั้นบันได: ROM → strengthening → weight bearing → function",
        "Open tibial fracture union ใช้เวลา 16-24 สัปดาห์ ต้อง monitor สำหรับ non-union",
      ],
      time_minutes: 10,
    },
  ],
};

// ============================================================
// Main seeding function
// ============================================================

async function main() {
  console.log("=== Seed Batch 1: 5 Exams with 6 Parts Each ===\n");

  // Step 1: Insert exams
  console.log("Step 1: Inserting 5 exams...");
  const { data: insertedExams, error: examError } = await supabase
    .from("exams")
    .insert(examsData)
    .select("id, title");

  if (examError) {
    console.error("Error inserting exams:", examError);
    process.exit(1);
  }

  console.log(`Inserted ${insertedExams.length} exams:`);
  insertedExams.forEach((e) => console.log(`  ✓ [${e.id}] ${e.title}`));

  // Step 2: Build exam title → id map
  const examTitleToId = {};
  for (const exam of insertedExams) {
    examTitleToId[exam.title] = exam.id;
  }

  // Step 3: Insert parts for each exam
  console.log("\nStep 2: Inserting exam parts...");
  let totalInserted = 0;

  for (const [examTitle, parts] of Object.entries(examPartsData)) {
    const examId = examTitleToId[examTitle];
    if (!examId) {
      console.error(`  ✗ Could not find exam ID for: ${examTitle}`);
      process.exit(1);
    }

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
      console.error(`  ✗ Error inserting parts for ${examTitle}:`, insertError);
      process.exit(1);
    }

    console.log(`  ✓ ${examTitle}: ${inserted.length} parts inserted`);
    totalInserted += inserted.length;
  }

  console.log(`\n=== Done! Inserted ${insertedExams.length} exams + ${totalInserted} parts ===`);
}

main().catch((err) => {
  console.error("Fatal error:", err);
  process.exit(1);
});
