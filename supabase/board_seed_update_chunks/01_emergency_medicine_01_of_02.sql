-- ===============================================================
-- UPDATE chunk 1/2: emergency_medicine (25 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"ให้ Aspirin 162 mg เคี้ยว + Sublingual nitroglycerin + ส่งไป cath lab ภายใน 90 นาที"},{"label":"B","text":"ให้ Aspirin 162 mg เคี้ยว + Clopidogrel 600 mg + IV NTG drip + ส่งไป cath lab ภายใน 90 นาที โดยระวัง RV infarction"},{"label":"C","text":"Thrombolysis ด้วย Streptokinase ทันที เนื่องจากเป็น STEMI"},{"label":"D","text":"ให้ IV heparin + รอผล cTnI ซ้ำใน 3 ชั่วโมง"},{"label":"E","text":"ทำ stress test เพื่อยืนยันการวินิจฉัยก่อนพิจารณา reperfusion"}]'::jsonb,
    explanation = 'EKG ผู้ป่วยรายนี้เข้าได้กับ Inferior STEMI (ST elevation II, III, aVF) ร่วมกับ reciprocal change ที่ I, aVL และ depression V1-V3 ซึ่งอาจบ่งชี้ posterior หรือ RV involvement การจัดการที่ถูกต้องตาม AHA/ACC 2013 STEMI guideline คือ dual antiplatelet (ASA + P2Y12 inhibitor) ก่อน primary PCI โดย door-to-balloon ≤ 90 นาที — ตัวเลือก B ครบถ้วน ส่วน A ขาด clopidogrel loading ซึ่งจำเป็นก่อน PCI. C ผิดเพราะ primary PCI ดีกว่า thrombolysis เมื่อ available ใน 90 นาที. D ผิดเพราะ STEMI ต้อง reperfuse ทันที ไม่รอ troponin. E ผิดอย่างยิ่งเพราะ stress test ห้ามใน acute STEMI'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'ชายไทยอายุ 62 ปี underlying HT, DM type 2 มาห้องฉุกเฉินด้วยอาการแน่นหน้าอกร้าวไปกรามซ้าย ปวดหนัก-ๆ นาน 45 นาที ร่วมกับเหงื่อแตกและคลื่นไส้ ตรวจร่างกาย: BP 152/94 mmHg, HR 102 bpm, RR 22, SpO2 96% room air ฟัง heart sound: S1S2 ปกติ ไม่ได้ยิน murmur หรือ gallop

EKG 12-lead พบ: ST elevation 3 mm ใน lead II, III, aVF + reciprocal ST depression ใน lead I, aVL และ V1-V3

Lab cTnI = 0.04 ng/mL (URL 0.04), CBC ปกติ, Cr 1.1 mg/dL';

update public.mcq_questions
set choices = '[{"label":"A","text":"ให้ IV labetalol + IV magnesium sulfate loading 4-6 g แล้ว 1-2 g/hr พร้อมเตรียม urgent delivery"},{"label":"B","text":"ให้ IV hydralazine 5 mg และ admit ICU เพื่อ observe ปล่อยให้ครรภ์ดำเนินต่อจนครบกำหนด"},{"label":"C","text":"ให้ oral methyldopa 250 mg และ discharge home พร้อมนัด ANC สัปดาห์หน้า"},{"label":"D","text":"ให้ IV nitroprusside drip และ refer แพทย์เฉพาะทาง"},{"label":"E","text":"ให้ IV dexamethasone และ tocolysis ด้วย MgSO4 เพื่อยืดอายุครรภ์อีก 48 ชั่วโมง"}]'::jsonb,
    explanation = 'ผู้ป่วยเข้าได้กับ HELLP syndrome (Hemolysis, Elevated Liver enzymes, Low Platelets) ซ้อนทับ severe preeclampsia (BP ≥ 160/110, protein 3+, neurologic symptoms, epigastric pain) การรักษามาตรฐานคือ control BP ด้วย IV labetalol (หรือ hydralazine) + seizure prophylaxis ด้วย MgSO4 + delivery เป็นการรักษาที่ definitive — ตัวเลือก A ถูกต้องครบ. B ผิดเพราะ HELLP severe ต้อง deliver ไม่ใช่ observe. C ผิดเพราะ severe range BP ต้อง IV และห้าม discharge. D ผิดเพราะ nitroprusside มี cyanide toxicity ในทารก. E ผิดเพราะ MgSO4 ใน HELLP เป็น seizure prophylaxis ไม่ใช่ tocolytic'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'หญิงไทยอายุ 28 ปี G2P1 GA 32 weeks มาห้องฉุกเฉินด้วยอาการปวดศีรษะรุนแรงและเห็นภาพมัวมา 6 ชั่วโมง ร่วมกับปวดท้องบริเวณ epigastrium ตรวจร่างกาย: BP 178/112 mmHg (วัดซ้ำห่าง 15 นาที 174/108), HR 92, RR 20 ตรวจ urine dipstick: protein 3+

Lab: Hb 10.8 g/dL, Plt 92,000/μL, AST 145 U/L, ALT 138 U/L, LDH 720 U/L, Cr 1.0 mg/dL, Uric acid 7.2 mg/dL';

update public.mcq_questions
set choices = '[{"label":"A","text":"ส่ง X-ray humerus + chest + pelvis เป็น trauma series + รอผลก่อนรักษา"},{"label":"B","text":"ทำ closed reduction และ long arm cast ที่ ED แล้ว discharge home"},{"label":"C","text":"ประเมิน NAI (non-accidental injury) เป็น mandatory ในการบาดเจ็บแบบนี้ของเด็กก่อนวัยเรียน + skeletal survey + แจ้งสหวิชาชีพถ้าสงสัย"},{"label":"D","text":"ส่ง CT brain เพราะ mechanism เป็น fall จากที่สูง"},{"label":"E","text":"Refer ortho เพื่อ operative fixation ทันที"}]'::jsonb,
    explanation = 'Humerus fracture ใน toddler/preschool โดยเฉพาะ spiral หรือ transverse mid-shaft เป็น "red flag" สำคัญสำหรับ non-accidental injury (NAI) — Royal College of Paediatrics และ AAP แนะนำให้ทำ skeletal survey และประเมิน NAI ในทุกกรณีของเด็กอายุ < 5 ปี ที่มี long bone fracture โดยเฉพาะถ้า mechanism ไม่สอดคล้องกับอาการ — ตัวเลือก C ถูกต้อง การไม่คัดกรอง NAI ในเด็กเล็กถือเป็นข้อผิดพลาดสำคัญ. A อาจทำเพิ่ม แต่ไม่ตอบ NAI question. B ผิดเพราะต้อง orthopedic consult สำหรับ humerus fracture ในเด็ก. D ผิดเพราะไม่มี neurologic symptom — CT brain ไม่จำเป็นเชิง routine. E ผิดเพราะ humerus shaft ในเด็กส่วนใหญ่รักษา conservative ได้'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'เด็กชายไทยอายุ 4 ปี น้ำหนัก 16 kg มาห้องฉุกเฉินหลังตกจากที่สูง 1.5 เมตร เด็กรู้สึกตัวดี แต่ร้องไห้และปวดที่แขนขวา ตรวจร่างกาย: HR 130, RR 28, BP 95/60 mmHg, SpO2 99% room air
GCS 15, pupils 3 mm reactive both eyes
Midshaft right humerus: deformed, swollen, ไม่มีบาดแผลเปิด, radial pulse ปกติ, capillary refill < 2 sec ที่นิ้วมือ, motor และ sensory ปกติ

ไม่มีบาดเจ็บอื่นในการตรวจ primary และ secondary survey';

update public.mcq_questions
set choices = '[{"label":"A","text":"ให้ Lorazepam IV ซ้ำ 4 mg อีก 1 dose แล้ว observe"},{"label":"B","text":"ใส่ท่อช่วยหายใจ + Phenytoin IV loading 20 mg/kg (หรือ Fosphenytoin 20 mg PE/kg) + เตรียม ICU"},{"label":"C","text":"ให้ IV diazepam 10 mg และส่ง CT brain ทันที"},{"label":"D","text":"ให้ IV magnesium sulfate เพราะอาจเป็น eclampsia"},{"label":"E","text":"Anesthetic induction ด้วย propofol drip ก่อน load anti-epileptic"}]'::jsonb,
    explanation = 'ผู้ป่วยเข้านิยาม status epilepticus (ชัก > 5 นาที หรือไม่ฟื้นระหว่างชัก) — Established status (ชักต่อหลังให้ benzodiazepine ครบ dose) ตาม NCS guideline 2016 และ Tintinalli ขั้นต่อไปคือ second-line anti-epileptic เช่น Phenytoin/Fosphenytoin 20 mg/kg, Valproate 40 mg/kg หรือ Levetiracetam 60 mg/kg ร่วมกับ airway protection (intubation) เพราะ RR irregular และ SpO2 ต่ำ — ตัวเลือก B ถูกต้องที่สุด. A ผิดเพราะ benzo dose ครบแล้ว ขั้นต่อไปคือ second-line. C ผิดเพราะ diazepam ไม่ใช่ second-line และ CT ไม่ใช่ priority ในขณะ active seizure. D ผิดเพราะไม่ใช่ pregnant — eclampsia ไม่ใช่ DDx. E เป็น third-line สำหรับ refractory status ยังไม่ใช่ขั้นนี้'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'หญิงไทยอายุ 35 ปี ไม่มีโรคประจำตัว มาห้องฉุกเฉินด้วยอาการชักเกร็งกระตุกทั้งตัวต่อเนื่อง 12 นาทีก่อนถึงโรงพยาบาล ที่ ED ยังชักอยู่ ไม่รู้สึกตัวระหว่างชัก ไม่มีประวัติ epilepsy หรือใช้ยา

V/S: BP 145/88 mmHg, HR 128, RR 28 (irregular), SpO2 88% room air, Temp 38.2°C, DTX 110 mg/dL

ให้ Lorazepam IV 4 mg ผ่านไป 5 นาที — ยังชักอยู่';

update public.mcq_questions
set choices = '[{"label":"A","text":"ไม่ต้องรักษา เพราะ paracetamol level ต่ำกว่า toxicity line ใน Rumack-Matthew nomogram"},{"label":"B","text":"ทำ activated charcoal 50 g PO แล้ว observe 24 ชั่วโมง"},{"label":"C","text":"ให้ N-acetylcysteine IV regimen 21 ชั่วโมง (150 mg/kg → 50 mg/kg → 100 mg/kg) เพราะ level อยู่เหนือ treatment line"},{"label":"D","text":"ทำ hemodialysis ทันที"},{"label":"E","text":"ส่ง psychiatry consult และ discharge หลังประเมินจิตเวช"}]'::jsonb,
    explanation = 'Paracetamol level 175 μg/mL ที่ 6 ชั่วโมง อยู่ "เหนือ" treatment line ของ Rumack-Matthew nomogram (treatment line = 150 μg/mL ที่ 4 ชม., ~75 μg/mL ที่ 12 ชม., extrapolate ที่ 6 ชม. ~118 μg/mL) — ต้องให้ NAC ตาม 21-hour IV regimen (150 mg/kg/loading ใน 60 นาที → 50 mg/kg ใน 4 ชม. → 100 mg/kg ใน 16 ชม.) ต่อเนื่อง โดยให้ทันทีโดยไม่รอ AST ขึ้น — ตัวเลือก C ถูกต้อง. A ผิดเพราะ level อยู่เหนือเส้น. B ผิดเพราะกิน > 4 ชม. แล้ว charcoal ไม่มีประโยชน์. D ผิดเพราะ HD ใช้สำหรับ massive ingestion + coma หรือ paracetamol level > 1000 μg/mL. E ผิดเพราะ medical clearance ต้องทำก่อน'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'ชายไทยอายุ 19 ปี ถูกนำส่งโรงพยาบาลหลังเพื่อนพบกินยา paracetamol จำนวน 30 เม็ด (เม็ดละ 500 mg) เมื่อ 6 ชั่วโมงก่อนเพื่อพยายามฆ่าตัวตาย ผู้ป่วยรู้สึกตัวดี ปฏิเสธอาการปวดท้องหรือคลื่นไส้

น้ำหนัก 60 kg
V/S: ปกติ
Lab: AST 28, ALT 32, INR 1.0, Cr 0.9, paracetamol level 175 μg/mL (เก็บที่ 6 ชั่วโมงหลังกิน)';

update public.mcq_questions
set choices = '[{"label":"A","text":"ให้ O2 100% via NRB + IV NSS + ส่ง hyperbaric oxygen therapy (recompression chamber) ด่วน + นอนราบ"},{"label":"B","text":"ส่ง MRI spine ก่อน เพื่อหา cord injury ที่อาจเกิดจากอุบัติเหตุดำน้ำ"},{"label":"C","text":"ให้ IV methylprednisolone high dose สำหรับ spinal cord injury"},{"label":"D","text":"ให้ analgesic และ NSAIDs + observe 6 ชั่วโมง"},{"label":"E","text":"Intubate และ ventilate ที่ FiO2 100% โดยไม่ต้องส่ง hyperbaric"}]'::jsonb,
    explanation = 'ผู้ป่วยเป็น Decompression Sickness (DCS) Type II — มี neurological symptoms (paraparesis, sensory level, sphincter dysfunction) จาก nitrogen bubbles ใน spinal cord การรักษามาตรฐานคือ: (1) 100% O2 via NRB ทันที เพื่อ wash out nitrogen และเพิ่ม oxygen delivery (2) IV fluid เพื่อ optimize perfusion (3) นอนราบ (supine) — ไม่ใช่ Trendelenburg เพราะอาจเพิ่ม cerebral edema (4) ส่ง hyperbaric oxygen therapy (HBOT) ด่วนภายใน 6 ชม. — Treatment Table 6 (USN) เป็นมาตรฐาน — ตัวเลือก A ถูกต้องครบทุกองค์ประกอบ. B ผิดเพราะ MRI ไม่ใช่ priority และทำให้ recompression ล่าช้า. C ผิดเพราะ steroid ไม่ได้ระบุใน DCS. D ผิด — DCS Type II ต้อง HBOT ไม่ใช่ observe. E ผิดเพราะ HBOT จำเป็น'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'ชายไทยอายุ 45 ปี ดำน้ำลึก SCUBA ที่ระดับ 25 เมตร ขึ้นสู่ผิวน้ำเร็วเนื่องจากแรงดันอากาศหมด หลังขึ้นมา 30 นาที มีอาการปวดข้อไหล่ทั้งสองข้างรุนแรง คลื่นไส้ ปวดศีรษะ ตามด้วยอาการชาและอ่อนแรงขาทั้งสองข้าง ปัสสาวะลำบาก

V/S: BP 130/82, HR 96, RR 20, SpO2 95% room air, Temp 36.8°C
Neuro: motor power ขาทั้งสองข้าง grade 3/5, sensory level T10, anal tone ลดลง';

update public.mcq_questions
set choices = '[{"label":"A","text":"ใส่ท่อช่วยหายใจทันทีเพราะ severe respiratory failure"},{"label":"B","text":"เริ่ม Non-Invasive Ventilation (BiPAP) + nebulized bronchodilators + IV steroid + IV antibiotics"},{"label":"C","text":"ให้ O2 100% via NRB และให้ doxapram IV เพื่อกระตุ้นการหายใจ"},{"label":"D","text":"Heliox therapy เป็น first-line สำหรับ COPD exacerbation"},{"label":"E","text":"Continuous nebulization salbutamol อย่างเดียวก่อน แล้วประเมินซ้ำใน 30 นาที"}]'::jsonb,
    explanation = 'ผู้ป่วยเป็น severe COPD exacerbation มี acute on chronic respiratory failure (pH 7.28, PaCO2 68 — acute respiratory acidosis on chronic compensation) ตาม GOLD 2023 และ ERS/ATS Guideline: NIV (BiPAP) เป็น first-line สำหรับ COPD exacerbation ที่มี acidosis (pH < 7.35, PaCO2 > 45) โดยไม่ต้อง intubate ก่อน — ลด mortality, intubation rate, และ LOS ร่วมกับ bronchodilators, IV/oral corticosteroid, และ antibiotics (เพราะมีไข้, sputum purulent) — ตัวเลือก B ถูกต้อง. A ผิดเพราะ NIV ลด intubation rate และมีข้อบ่งชี้ชัด. C ผิด — doxapram ล้าสมัย ห้ามใช้. D ผิด — heliox ไม่ใช่ standard first-line ใน COPD. E ผิดเพราะ severe exacerbation ต้องรักษาครบ ไม่ใช่ bronchodilator อย่างเดียว'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'หญิงไทยอายุ 72 ปี underlying COPD GOLD stage III, ใช้ tiotropium และ salbutamol MDI prn มาห้องฉุกเฉินด้วยอาการเหนื่อยมาก พูดเป็นคำ ตัวเขียว มา 2 ชั่วโมง ก่อนมามีไข้ ไอเสมหะข้นเหลือง 3 วัน

V/S: BP 142/88, HR 122 (irregular), RR 32, SpO2 84% room air, Temp 38.5°C
ฟังปอด: wheezing ทั้งสองข้าง, expiratory phase prolonged, breath sound ลดลงทั้งสองข้าง

ABG (room air): pH 7.28, PaCO2 68 mmHg, PaO2 52 mmHg, HCO3 28 mEq/L';

update public.mcq_questions
set choices = '[{"label":"A","text":"IV diphenhydramine 50 mg + IV hydrocortisone 200 mg + observe"},{"label":"B","text":"IM Epinephrine 0.5 mg (1:1000) ที่ vastus lateralis ทันที + IV NSS bolus + เตรียม airway + ให้ซ้ำได้ทุก 5-15 นาที"},{"label":"C","text":"Subcutaneous epinephrine 0.3 mg + nebulized albuterol"},{"label":"D","text":"IV epinephrine 1 mg push (1:10,000) ทันที"},{"label":"E","text":"ใส่ท่อช่วยหายใจก่อนให้ epinephrine เพื่อ secure airway"}]'::jsonb,
    explanation = 'ผู้ป่วยเป็น Anaphylaxis grade 3-4 (severe) ตาม WAO 2020 criteria — มี airway involvement (stridor, lip swelling) + hypotension + cutaneous symptoms การรักษามาตรฐาน first-line คือ IM epinephrine 0.01 mg/kg (max 0.5 mg) ใน vastus lateralis (ดูดซึมเร็วกว่า deltoid) — ไม่ใช่ SC หรือ IV push (ยกเว้น cardiac arrest) IV push 1 mg เป็น cardiac arrest dose ทำให้เกิด arrhythmia ใน conscious patient — ตัวเลือก B ถูก. A ผิดเพราะ antihistamine + steroid เป็น second-line ไม่ทดแทน epinephrine. C ผิดเพราะ SC ดูดซึมไม่แน่นอนใน shock — IM ดีกว่า. D ผิดเพราะ IV push 1 mg อันตราย ใช้เฉพาะ cardiac arrest. E ผิดเพราะต้องให้ epinephrine ก่อนเพื่อแก้ shock และ swelling — การ intubate อาจล้มเหลวถ้าไม่ลด edema ก่อน'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'หญิงไทยอายุ 24 ปี ไม่มีโรคประจำตัว เป็น nurse OR มาห้องฉุกเฉินด้วยอาการ angioedema ที่ใบหน้าและริมฝีปาก หายใจมีเสียง stridor หลังสัมผัส latex glove ที่ทำงาน 20 นาทีก่อน

V/S: BP 78/42 mmHg, HR 138, RR 28, SpO2 91% room air
Lip swelling, peri-orbital edema, urticaria ทั่วลำตัว, fine wheezing ทั้งสองข้าง';

update public.mcq_questions
set choices = '[{"label":"A","text":"ยา A เพราะ Vd สูง"},{"label":"B","text":"ยา B เพราะ Vd ต่ำ + protein binding สูง"},{"label":"C","text":"ยา B เพราะ Vd ต่ำ — drug อยู่ใน plasma มาก dialyzer เข้าถึงได้ง่าย ส่วน protein binding สูงเป็นข้อจำกัด แต่ Vd มี impact มากกว่า"},{"label":"D","text":"ทั้งสองตัวขจัดได้พอ ๆ กัน เพราะ HD ไม่ขึ้นกับ pharmacokinetics"},{"label":"E","text":"ยา A เพราะ protein binding ต่ำ ทำให้ free drug ขจัดได้ง่ายแม้ Vd สูง"}]'::jsonb,
    explanation = 'หลักการขจัดยาด้วย hemodialysis (EXTRIP criteria): (1) Molecular weight ต่ำ (< 500 Da เก่า, < 25,000 Da hi-flux) (2) Vd ต่ำ (< 1 L/kg) — เพราะถ้า Vd สูง drug กระจายไป tissue ส่วน plasma มีน้อย dialyzer เข้าถึงไม่ได้ (3) Protein binding ต่ำ (< 80%) — เพราะ HD ขจัดเฉพาะ free drug ยา B มี Vd = 0.2 L/kg (ต่ำมาก, drug ส่วนใหญ่อยู่ใน plasma) แต่ protein binding 95% (สูงมาก) — overall ยังถือว่า dialyzable ดีกว่ายา A ที่ Vd 12 L/kg (drug กระจายไป tissue เป็นหลัก ไม่ว่า protein binding เท่าใด HD ก็เอาออกได้น้อย) — ตัวเลือก C อธิบายครบถ้วน. A ผิดเพราะ Vd สูง = ไม่ dialyzable. B ขาดเหตุผล (correct call แต่ no rationale). D ผิดเชิงพื้นฐาน. E ผิดเพราะ Vd สูงเอาชนะ protein binding ต่ำ'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'อาจารย์แพทย์อธิบายเรื่อง pharmacokinetics ของยาในงานวิจัย ED ให้ resident ฟัง: ยา A มี volume of distribution (Vd) สูงมาก = 12 L/kg และ protein binding 30% ในขณะที่ยา B มี Vd = 0.2 L/kg และ protein binding 95%

คำถาม: หากผู้ป่วยได้รับ overdose ทั้งสองตัว ตัวใดจะถูกขจัดด้วย hemodialysis ได้ดีกว่า และเพราะอะไร';

update public.mcq_questions
set choices = '[{"label":"A","text":"ซื้อรถพยาบาลใหม่เพิ่ม 5 คัน และเพิ่มจำนวน paramedic ในรถแต่ละคัน"},{"label":"B","text":"พัฒนา Dispatcher-Assisted CPR (T-CPR) + เครือข่าย AED ในชุมชน + bystander CPR training ครอบคลุม — เพราะ chain of survival ที่ต้นทาง (early CPR + early defibrillation) ส่งผลต่อ survival มากที่สุด"},{"label":"C","text":"เพิ่ม ICU bed ในโรงพยาบาลปลายทาง"},{"label":"D","text":"ฝึกอบรม advanced airway สำหรับ EMT-basic"},{"label":"E","text":"ใช้รถพยาบาลเปิดไซเรนทุกครั้งเพื่อลดเวลาเดินทาง"}]'::jsonb,
    explanation = 'จาก AHA Chain of Survival และ Utstein-style OHCA registries: ปัจจัยที่ส่งผลต่อ survival ของ OHCA มากที่สุดเรียงลำดับคือ (1) early recognition + activation, (2) early bystander CPR, (3) early defibrillation (AED ในชุมชน), (4) early advanced life support, (5) post-resuscitation care การปรับปรุงในระดับ "upstream" (ก่อน EMS arrival) โดย Dispatcher-Assisted CPR + AED network + community CPR training ได้รับการยืนยันจากการศึกษาในญี่ปุ่น (Iwami T, NEJM 2010) และเดนมาร์ก (Wissenberg M, JAMA 2013) ว่าเพิ่ม survival อย่างมีนัยสำคัญ (HR 1.5-2.5) — ตัวเลือก B ถูกต้องและสะท้อน system-level intervention. A ลด response time แต่ไม่ได้แก้ root cause. C เป็น downstream — ไม่ช่วย ROSC. D advanced airway ใน OHCA ไม่ได้เพิ่ม survival (PART trial 2018). E ไม่ใช่ system-level improvement'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'ในระบบ EMS ของจังหวัดหนึ่ง มีรายงานว่าเวลา response time เฉลี่ยจากเมื่อรับแจ้งเหตุจนถึงจุดเกิดเหตุ (call-to-scene) สำหรับเคส cardiac arrest = 14 นาที (เป้าหมาย AHA = ≤ 8 นาที) ผู้อำนวยการศูนย์ EMS ต้องการปรับปรุงคุณภาพการให้บริการ

สมาชิกในทีมเสนอแนวทาง 5 ข้อ — ข้อใดเป็นมาตรการ "system-level" ที่ส่งผลสูงสุดต่อ survival rate ของ out-of-hospital cardiac arrest (OHCA)';

update public.mcq_questions
set choices = '[{"label":"A","text":"IV NSS bolus + transfuse PRC เป้า Hb ≥ 10 + early EGD ภายใน 12 ชม."},{"label":"B","text":"Restrictive transfusion strategy (เป้า Hb 7-8) + IV octreotide + IV ceftriaxone + early EGD ภายใน 12 ชม."},{"label":"C","text":"Massive transfusion protocol ทันที + emergent surgery consult"},{"label":"D","text":"Sengstaken-Blakemore tube ก่อนทำ EGD"},{"label":"E","text":"IV pantoprazole bolus + observe และทำ EGD elective ใน 48 ชม."}]'::jsonb,
    explanation = 'ผู้ป่วยมี variceal bleeding จาก cirrhosis (Child-Pugh B/C) Baveno VII guideline แนะนำ: (1) restrictive transfusion เป้า Hb 7-8 g/dL (Villanueva NEJM 2013 แสดงว่า restrictive strategy ลด mortality เทียบกับ liberal) (2) vasoactive drug (octreotide หรือ terlipressin) เพื่อลด portal pressure (3) prophylactic antibiotic (ceftriaxone) ลด SBP และเพิ่ม survival (4) early EGD ภายใน 12 ชม. — ตัวเลือก B ถูกต้องครบ. A ผิดเพราะ target Hb 10 เป็น liberal strategy → mortality เพิ่ม. C ผิดเพราะยังไม่ใช่ MTP — แค่ massive ไม่ใช่ refractory. D ผิด — balloon tamponade ใช้เป็น bridge เมื่อ EGD ล้มเหลว ไม่ใช่ first-line. E ผิดเพราะ pantoprazole สำหรับ peptic ulcer ไม่ใช่ varices'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'ชายไทยอายุ 55 ปี ดื่มสุราเป็นประจำมา 20 ปี มาห้องฉุกเฉินด้วยอาเจียนเป็นเลือดสด ~ 500 mL ก่อนมา 1 ชม. ตรวจร่างกาย: BP 86/52 mmHg, HR 124, RR 24, SpO2 96% room air, ตัวเหลืองตาเหลือง, มี spider nevi, ascites moderate, splenomegaly

Lab: Hb 6.8 g/dL, Plt 78,000, INR 1.8, Cr 1.1, AST 145, ALT 88, Albumin 2.4, Total bilirubin 4.2';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wells score ต่ำ — ไม่ต้องตรวจเพิ่ม discharge home"},{"label":"B","text":"ส่ง D-dimer ถ้าผลต่ำกว่า 500 ng/mL ถือว่า exclude PE ได้"},{"label":"C","text":"Wells score สูง + hemodynamically stable → ส่ง CT pulmonary angiogram (CTPA) ทันที + เริ่ม empirical anticoagulation ถ้าไม่มีข้อห้าม"},{"label":"D","text":"Echocardiogram bedside ก่อน เพื่อหา RV strain แล้วค่อยตัดสินใจ"},{"label":"E","text":"Systemic thrombolysis ทันทีเพราะมี S1Q3T3 + SpO2 ต่ำ"}]'::jsonb,
    explanation = 'Wells score: clinical PE most likely (+3), tachycardia >100 (+1.5), immobilization/surgery (+1.5), DVT signs (+3), hemoptysis 0, malignancy 0 = ≥ 7 → high probability ใน high pre-test probability D-dimer ไม่มีประโยชน์ (high false-positive) — ต้องไป CTPA ทันที ตาม ESC 2019 และ ACEP 2018 guidelines + เริ่ม empirical anticoagulation ระหว่างรอ imaging (LMWH หรือ heparin) เพราะ pre-test สูง — ตัวเลือก C ถูก. A ผิดเพราะ Wells สูง. B ผิดเพราะ D-dimer ใช้ exclude เฉพาะ low/intermediate pre-test probability. D ผิดเพราะ echo ใช้ใน hemodynamically unstable PE เพื่อ guide reperfusion. E ผิดเพราะ stable PE ไม่ใช่ massive — ใช้ anticoagulation'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'หญิงไทยอายุ 38 ปี ไม่มีโรคประจำตัว มาห้องฉุกเฉินด้วยอาการเจ็บหน้าอกแบบแหลม-คม หายใจลึกเจ็บมากขึ้น เป็นมา 4 ชม. ก่อนหน้านี้ 1 สัปดาห์ เดินทางไกลโดยรถยนต์ 12 ชม. และเริ่มกินยาคุมกำเนิดมา 6 เดือน

V/S: BP 118/72, HR 116, RR 26, SpO2 91% room air, Temp 37.6°C
Left calf: tender, swollen, 3 cm > right calf
EKG: sinus tachycardia, S1Q3T3 pattern
CXR: ไม่พบ infiltrate';

update public.mcq_questions
set choices = '[{"label":"A","text":"Salbutamol nebulization × 1 dose แล้วประเมิน 20 นาที"},{"label":"B","text":"Continuous salbutamol nebulization + ipratropium nebulization + IV systemic corticosteroid + IV magnesium sulfate 50 mg/kg + เตรียม PICU"},{"label":"C","text":"Subcutaneous epinephrine 0.01 mg/kg และให้ heliox"},{"label":"D","text":"ใส่ท่อช่วยหายใจทันทีเพราะ severe distress"},{"label":"E","text":"ICS (inhaled corticosteroid) เพิ่ม dose + observe 1 ชม."}]'::jsonb,
    explanation = 'เด็กเป็น severe acute asthma exacerbation (PRAM score สูง: SpO2 < 92%, RR สูง, retraction, unable to speak in sentences) GINA 2023 และ AAP แนะนำ: (1) continuous nebulized SABA + ipratropium (synergistic) (2) systemic corticosteroid (oral prednisolone 1-2 mg/kg หรือ IV methylprednisolone 1 mg/kg) (3) IV MgSO4 50 mg/kg ใน severe ที่ไม่ตอบสนอง SABA dose แรก (Cochrane evidence ลด admission) (4) prepare ICU/PICU monitoring — ตัวเลือก B ครบถ้วน. A ผิดเพราะ failed ที่บ้านแล้ว ต้อง escalate. C ผิด — epinephrine ใช้ใน anaphylaxis ไม่ใช่ first-line asthma. D ผิด — intubation เป็น last resort เพราะมี risk barotrauma สูง ลอง maximal medical therapy ก่อน. E ผิด — ICS เพิ่ม dose ไม่ใช่ acute treatment'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'เด็กชายไทยอายุ 8 ปี น้ำหนัก 25 kg มาห้องฉุกเฉินด้วยอาการหายใจเหนื่อยและไอ มีเสียงหวีดเป็นมา 6 ชม. ไม่ดีขึ้นหลังพ่นยา salbutamol ที่บ้าน ประวัติ asthma เป็นมา 3 ปี ใช้ ICS regular

V/S: HR 152, RR 38, SpO2 88% room air, Temp 36.8°C
Unable to speak in full sentences
Use accessory muscles, intercostal retraction prominent
Wheezing both lungs, expiratory phase markedly prolonged';

update public.mcq_questions
set choices = '[{"label":"A","text":"IV NSS bolus 30 mL/kg + IV opioid analgesic + NPO + ATB ทันที (piperacillin-tazobactam)"},{"label":"B","text":"Aggressive crystalloid resuscitation (Lactated Ringer 5-10 mL/kg/hr) + IV opioid + NPO 24-48 ชม. + ไม่ให้ ATB เพราะไม่มี evidence ของ infected necrosis"},{"label":"C","text":"ERCP ฉุกเฉินภายใน 6 ชม. เพราะ AST/ALT สูง"},{"label":"D","text":"Surgical consult ทันทีเพื่อ pancreatic debridement"},{"label":"E","text":"Octreotide drip + IV antibiotics + Total parenteral nutrition"}]'::jsonb,
    explanation = 'ผู้ป่วยเป็น acute alcoholic pancreatitis (Atlanta classification: lipase > 3× ULN + clinical + imaging) BISAP score = WBC > 16 (1) + age < 60 (0) + impaired consciousness (0) + pleural effusion (0) + SIRS (1 — HR > 90, RR > 22) = 2 → moderate severity ATCG/AGA/Banks 2013 guideline: (1) aggressive crystalloid resuscitation ด้วย Lactated Ringer (preferred over NSS — ลด SIRS) 5-10 mL/kg/hr ใน 24-48 ชม.แรก (2) analgesic (3) early enteral feeding ภายใน 24-72 ชม. ถ้าทนได้ (4) ห้าม prophylactic antibiotic ใน sterile pancreatitis (5) ERCP เฉพาะใน gallstone pancreatitis + cholangitis เท่านั้น — ตัวเลือก B ถูก. A ผิดเพราะ prophylactic ATB ใน sterile pancreatitis ไม่ลด mortality (Cochrane meta-analysis) และเพิ่ม resistant infection. C ผิดเพราะ alcoholic ไม่ใช่ gallstone. D ผิด — surgery ใช้ใน infected necrosis only. E ผิด — octreotide ไม่ลด mortality'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'ชายไทยอายุ 24 ปี ไม่มีโรคประจำตัว ดื่มสุรากับเพื่อน 8 ชั่วโมง ปวดท้องบริเวณ epigastrium รุนแรงเป็นมา 4 ชม. ร่วมกับอาเจียน 5 ครั้ง ตรวจร่างกาย: BP 92/58 mmHg, HR 124, RR 22, SpO2 97%, Temp 38.3°C
Abdomen: epigastric tenderness, guarding, ไม่มี rebound, bowel sound ลดลง

Lab: WBC 18,500 (PMN 88%), Lipase 1,850 U/L (URL 60), Amylase 420, Glucose 198, Ca 7.8, ALT 42, AST 88, ALP 110, Total bilirubin 1.0

CT abdomen: peripancreatic fat stranding, ไม่มี necrosis, ไม่มี collection';

update public.mcq_questions
set choices = '[{"label":"A","text":"IV insulin + glucose, IV sodium bicarbonate, IV calcium gluconate, kayexalate, และเตรียม emergency hemodialysis"},{"label":"B","text":"เริ่มด้วย IV calcium gluconate 1 g IV slow push (membrane stabilization) ทันที — ก่อน insulin/glucose, bicarbonate และ HD เพราะ EKG เปลี่ยนแปลงรุนแรงและ K สูงมาก"},{"label":"C","text":"IV furosemide high dose เพื่อขับ K ทาง urine"},{"label":"D","text":"Oral kayexalate 30 g + observe EKG"},{"label":"E","text":"Atropine สำหรับ bradycardia ก่อน แล้วจัดการ K"}]'::jsonb,
    explanation = 'Severe hyperkalemia (K > 6.5) + EKG changes (peaked T, wide QRS, absent P) เป็น medical emergency ลำดับการรักษาตาม AHA/ACEP 2020: ขั้นที่ 1 (เร่งด่วนสุด) — IV calcium gluconate 10 mL 10% slow push 2-3 นาที เพื่อ membrane stabilization (effect ใน 1-3 นาที) ป้องกัน lethal arrhythmia ขั้นที่ 2 — shift K เข้าเซลล์ (insulin/glucose, beta-2 agonist, bicarbonate) ขั้นที่ 3 — eliminate K (kayexalate slow, HD definitive) ตัวเลือก B ถูกเพราะระบุ "calcium ก่อน" — A รวมทั้งหมดถูก แต่ลำดับสำคัญ — calcium ต้องเป็นอันแรก. C ผิด — furosemide ใน CKD severe ไม่ค่อย work. D ผิด — onset ช้า. E ผิด — atropine ไม่แก้ root cause'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'หญิงไทยอายุ 68 ปี underlying CKD stage 4 (baseline Cr 2.5) มาห้องฉุกเฉินด้วยอาการอ่อนเพลีย คลื่นไส้ ใจสั่น เป็นมา 1 วัน ทานยา enalapril, spironolactone, และ NSAIDs สำหรับปวดเข่า

V/S: BP 138/82, HR 38 (regular), RR 18, SpO2 98%
EKG: peaked T waves, widened QRS (140 ms), absent P waves

Lab: K 7.2 mEq/L, Cr 4.8, BUN 78, Na 134, HCO3 18, ABG pH 7.28';

update public.mcq_questions
set choices = '[{"label":"A","text":"IV NSS bolus 1 L ใน 1 ชั่วโมง + IV regular insulin bolus 0.1 U/kg + drip 0.1 U/kg/hr + K replacement ถ้า K < 5.3 + ติดตาม electrolytes ทุก 2 ชั่วโมง"},{"label":"B","text":"IV sodium bicarbonate bolus เพื่อแก้ acidosis ก่อน insulin"},{"label":"C","text":"IV insulin drip 0.1 U/kg/hr โดยไม่ต้อง bolus + IV NSS + K replacement"},{"label":"D","text":"SC long-acting insulin (glargine) + IV fluid resuscitation"},{"label":"E","text":"Restrict fluid เพราะกลัว cerebral edema + start insulin drip ช้า ๆ"}]'::jsonb,
    explanation = 'ผู้ป่วยเป็น Diabetic Ketoacidosis (DKA): pH < 7.3, HCO3 < 18, ketones +, anion gap สูง (= 30) ADA 2009 และ JBDS 2021 DKA guideline: (1) IV fluid resuscitation: NSS 1 L ใน 1 ชม. แรก (2) Insulin: regular insulin 0.1 U/kg IV bolus → 0.1 U/kg/hr drip (titrate glucose ลด 50-75 mg/dL/hr) (3) K monitoring: ถ้า K < 3.3 hold insulin, ถ้า 3.3-5.3 replace, ถ้า > 5.3 monitor (4) ไม่ใช้ bicarbonate ถ้า pH > 6.9 — ตัวเลือก A ถูก. B ผิดเพราะ bicarbonate ไม่มี mortality benefit ที่ pH > 6.9 และเสี่ยง cerebral edema. C ผิดบางส่วน — JBDS guideline ใหม่ไม่ระบุ insulin bolus แต่ ADA classic ยังแนะนำ — A ใกล้เคียงมาตรฐานสุด ปลอดภัยกว่า. D ผิด — long-acting insulin ใช้ post-resolution ไม่ใช่ acute. E ผิด — เด็กเสี่ยง cerebral edema แต่ผู้ใหญ่ต้อง aggressive fluid'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'ชายไทยอายุ 52 ปี underlying DM type 2 ขาดยา insulin มา 3 วัน มาห้องฉุกเฉินด้วยอาการคลื่นไส้ อาเจียน หายใจหอบลึกแบบ Kussmaul ปวดท้อง ผู้ป่วยซึมลงเล็กน้อย

V/S: BP 108/70 mmHg, HR 124, RR 32 deep, SpO2 99% room air, Temp 36.8°C, DTX HI (> 600)

ABG: pH 7.06, PaCO2 18, PaO2 102, HCO3 6 mEq/L
Lab: Na 132 (corrected 138), K 5.4, Cl 96, Glucose 685 mg/dL, BUN 32, Cr 1.5, Ketone urine 4+, Anion gap 30';

update public.mcq_questions
set choices = '[{"label":"A","text":"ส่ง psychiatry consult เพราะอาจเป็น dissociative disorder"},{"label":"B","text":"ดูแล supportive (airway monitoring, IV fluid, observe ในที่ปลอดภัย จนกว่าจะ alert เต็มที่) + ทำ forensic evidence collection (ปัสสาวะ + เลือดในช่วง window) + แจ้งตำรวจตามความยินยอม + ตรวจ sexual assault evaluation + offer post-exposure prophylaxis + social work consult"},{"label":"C","text":"ให้ flumazenil เพื่อ reverse GHB toxicity"},{"label":"D","text":"Activated charcoal ผ่าน NG tube"},{"label":"E","text":"Discharge home ถ้า GCS 15 + ฝากให้เพื่อนดูแล"}]'::jsonb,
    explanation = 'ผู้ป่วยมี clinical pattern ของ drug-facilitated sexual assault (DFSA) — anterograde amnesia, GHB positive การจัดการต้องครอบคลุม: (1) Medical: supportive care (GHB self-limiting 2-6 ชม., ไม่มี antidote, ระวัง respiratory depression) (2) Forensic: collect chain-of-custody urine (GHB detect window 6-12 ชม., ผม > 1 เดือน) (3) Legal: แจ้งตำรวจตามความยินยอม (4) Sexual assault: SAFE/SANE exam, STI screening, emergency contraception, HIV PEP, HBV vaccination (5) Psychological: trauma-informed care + social work ตัวเลือก B ครบ. A ผิดเพราะ amnesia เป็น pharmacologic. C ผิด — flumazenil reverse benzodiazepine ไม่ใช่ GHB และเสี่ยง seizure. D ผิด — GHB absorb เร็ว charcoal ไม่ทันแล้ว. E ผิดที่สุด — ละเลย forensic + sexual assault evaluation'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'หญิงไทยอายุ 22 ปี ไม่มีโรคประจำตัว มาห้องฉุกเฉินตามเพื่อน หลังเพื่อนพบเธอเดินซุ่มซ่ามและพูดเรื่องไม่ปะติดปะต่อในผับ ผู้ป่วยอ้างว่าจำได้เป็นบางช่วง แต่หลังจาก 2 ชั่วโมงผ่านไป จำเหตุการณ์ในช่วงนั้นไม่ได้เลย ไม่ได้ดื่มสุรามาก (2 แก้ว) เพื่อนสงสัยถูกผสมยาในเครื่องดื่ม

V/S: BP 102/64, HR 78, RR 14, SpO2 99%, DTX 96, Temp 36.8°C
GCS 15 (ตอนนี้), pupils 4 mm reactive, ทรงตัวไม่ดี
ไม่มีบาดแผลที่ตรวจพบ

Urine drug screen: gamma-hydroxybutyrate (GHB) positive';

update public.mcq_questions
set choices = '[{"label":"A","text":"CVP สูง, PCWP สูง, CO ต่ำ, SVR สูง"},{"label":"B","text":"CVP สูง, PCWP สูง, CO ต่ำ, SVR ต่ำ"},{"label":"C","text":"CVP ต่ำ-ปกติ, PCWP ต่ำ-ปกติ, CO สูง, SVR ต่ำ, SvO2 อาจสูง (จาก mitochondrial dysfunction)"},{"label":"D","text":"CVP ต่ำ, PCWP ต่ำ, CO ต่ำ, SVR สูง"},{"label":"E","text":"CVP สูง, PCWP ต่ำ, CO สูง, SVR ปกติ"}]'::jsonb,
    explanation = 'Hemodynamic profiles ของ shock แต่ละชนิด: (1) Hypovolemic: ↓CVP, ↓PCWP, ↓CO, ↑SVR — body พยายามชดเชย (2) Cardiogenic: ↑CVP, ↑PCWP, ↓CO, ↑SVR (3) Obstructive (PE/tamponade): ↑CVP, varies PCWP, ↓CO, ↑SVR (4) Distributive/Septic: ↓-N CVP/PCWP (จาก vasodilation + capillary leak), ↑CO (early warm shock จาก ↓afterload), ↓↓SVR (cytokine-mediated NO release), อาจ ↑SvO2 จาก mitochondrial dysfunction (cells extract O2 ไม่ได้) — ตัวเลือก C ถูก ใน late septic shock CO อาจลดลงจาก myocardial depression (cytokine + circulating depressant factor) เปลี่ยนเป็น "cold shock". A ผิด — ไม่ใช่ septic. B ผิด. D คือ hypovolemic. E ผิด pattern'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'อาจารย์แพทย์อธิบาย physiology ของ shock ใน sepsis: ในระยะ early septic shock มีการลด systemic vascular resistance (SVR) อย่างมาก แต่ cardiac output (CO) เพิ่มขึ้น ("warm shock") ซึ่งต่างจาก hypovolemic หรือ cardiogenic shock

คำถาม: hemodynamic profile ของผู้ป่วย septic shock ตามเกณฑ์ของ Sepsis-3 ที่ตรวจด้วย invasive monitoring จะแสดงค่าใด';

update public.mcq_questions
set choices = '[{"label":"A","text":"แดง (Immediate) — เพราะมี trauma ที่แขน"},{"label":"B","text":"เหลือง (Delayed) — เพราะมีแผลถลอก"},{"label":"C","text":"เขียว (Minor/Walking wounded) — เพราะเดินได้, breathing ปกติ, perfusion ปกติ, mental status ปกติ"},{"label":"D","text":"ดำ (Expectant/Deceased) — เพราะ MCI มีผู้บาดเจ็บมากต้องประหยัด resource"},{"label":"E","text":"ขึ้นอยู่กับการตัดสินใจของ commander ไม่มีเกณฑ์มาตรฐาน"}]'::jsonb,
    explanation = 'START triage system ตั้งแต่ 1983 (Hoag Memorial Hospital) มี 4 categories: (1) Green (Minor): "walking wounded" — ผู้ที่เดินได้ตอบสนองคำสั่ง — แยกออกจากจุดเกิดเหตุก่อน (2) Yellow (Delayed): หายใจดี (RR < 30), perfusion ดี (capillary refill < 2 sec หรือ radial pulse +), mental status ดี — รอได้ 1-2 ชม. (3) Red (Immediate): หายใจหลังเปิด airway, RR > 30, perfusion เสีย (CR > 2 sec หรือไม่มี radial pulse), หรือ mental status เสีย — ต้อง intervention ทันที (4) Black (Expectant): ไม่หายใจหลังเปิด airway ผู้ป่วยรายนี้: เดินได้, RR 18 (< 30), CR < 2 sec, radial pulse ปกติ, GCS 15 → meets Green criteria — ตัวเลือก C ถูก. A ผิดเพราะ minor trauma ไม่ใช่ immediate. B ผิดเพราะเดินได้ = green ไม่ใช่ yellow. D ผิดอย่างยิ่ง ethics. E ผิดเพราะมีระบบมาตรฐาน'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'ในเหตุการณ์ระเบิด mass casualty incident (MCI) ที่ตลาดในเมือง มีผู้บาดเจ็บ 45 คน EMT-paramedic ที่จุดเกิดเหตุต้องทำ triage เพื่อจัดลำดับการขนส่ง

ผู้บาดเจ็บคนหนึ่ง: ชายอายุ 35 ปี รู้สึกตัวดี (GCS 15), เดินได้, มีแผลถลอกที่แขนซ้าย, RR 18, capillary refill < 2 sec, radial pulse ปกติ

ตามระบบ START triage (Simple Triage and Rapid Treatment) ผู้ป่วยรายนี้ควรได้รับการจัดเป็น category สีอะไร';

update public.mcq_questions
set choices = '[{"label":"A","text":"ให้ IV alteplase 0.9 mg/kg ทันที + admit stroke unit"},{"label":"B","text":"Endovascular thrombectomy ภายใน window time + ไม่ให้ IV thrombolytic เพราะ INR > 1.7 → contraindication + control BP < 185/110 ก่อนทำหัตถการ"},{"label":"C","text":"ให้ IV heparin drip และ refer neurology"},{"label":"D","text":"Reverse warfarin ด้วย vitamin K + FFP ก่อนทำอะไรเพราะ INR สูง"},{"label":"E","text":"Aspirin 325 mg + permissive hypertension และ admit observation"}]'::jsonb,
    explanation = 'ผู้ป่วยเป็น Acute Ischemic Stroke ที่มี LVO (proximal MCA) NIHSS 14, time 90 นาที AHA/ASA 2019 update + DAWN/DEFUSE-3 trials: (1) IV thrombolytic (alteplase หรือ tenecteplase) ใน window 4.5 ชม. — แต่ INR > 1.7 ใน warfarin users เป็น contraindication ตาม AHA guideline (2) Mechanical thrombectomy สำหรับ LVO ใน anterior circulation ทำได้ใน window 6 ชม. (standard) ถึง 24 ชม. (selected by imaging — DAWN/DEFUSE-3) แม้ไม่ได้ IV-tPA (3) BP control: < 185/110 ก่อน reperfusion (ICH risk) — ตัวเลือก B ครบ. A ผิดเพราะ INR > 1.7 contraindicate IV tPA. C ผิด — heparin acute ไม่ลด recurrence แต่เพิ่ม bleeding. D ผิดเพราะ reverse warfarin ทำให้เกิด rebound thrombosis และไม่จำเป็นสำหรับ thrombectomy. E ผิด — LVO มี Rx ที่ effective อย่า observe'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'ชายไทยอายุ 72 ปี underlying CHF NYHA III, AF on warfarin (INR target 2-3), CKD stage 3, COPD GOLD II ถูกนำส่งโรงพยาบาลด้วยอาการซึมลง อ่อนแรงครึ่งซีกซ้าย onset 90 นาทีก่อนถึงโรงพยาบาล

V/S: BP 178/102 mmHg, HR 96 (irregular), RR 22, SpO2 95%, DTX 142, Temp 36.5°C
Neuro: NIHSS = 14 (right gaze deviation, left hemiparesis grade 2/5, dysarthria, hemineglect)

Lab: Hb 10.4, Plt 145,000, INR 2.1, Cr 1.8, Glucose 142
CT brain non-contrast: ไม่พบ hemorrhage, hyperdense MCA sign ขวา
CT angiography: large vessel occlusion (LVO) — proximal right MCA';

update public.mcq_questions
set choices = '[{"label":"A","text":"IV haloperidol 5 mg + IV lorazepam 2 mg (combination) + verbal de-escalation + physical restraint ชั่วคราว ถ้าจำเป็นเพื่อความปลอดภัย"},{"label":"B","text":"IM ketamine 4 mg/kg เป็น first-line สำหรับ agitation ทุกเคส"},{"label":"C","text":"Physical restraint อย่างเดียวจนกว่าจะสงบ"},{"label":"D","text":"ส่ง psychiatry ทันทีโดยไม่ให้ยา"},{"label":"E","text":"Naloxone IV ทันทีเพราะ overdose"}]'::jsonb,
    explanation = 'ผู้ป่วยเป็น sympathomimetic toxicity จาก methamphetamine มี agitation รุนแรง + autonomic activation ACEP Clinical Policy on Acute Agitation 2017 และ Project BETA: (1) Verbal de-escalation ก่อน (2) Pharmacologic: combination antipsychotic (haloperidol/droperidol) + benzodiazepine (lorazepam/midazolam) ลด dose ของแต่ละตัว ลด side effect (3) Physical restraint เป็น last resort และ time-limited (4) Workup สาเหตุ (CT brain, electrolytes, CK สำหรับ rhabdomyolysis, EKG สำหรับ QTc) (5) Active cooling ถ้า hyperthermia — ตัวเลือก A ครบ. B ผิดเพราะ ketamine ใช้ใน excited delirium ที่ดื้อ first-line dose อาจสูงเกินไป (1-2 mg/kg IV pure). C ผิดเพราะ physical restraint อย่างเดียวเสี่ยง rhabdomyolysis. D ผิด — ต้อง medical clearance + acute management ก่อน. E ผิด — ไม่ใช่ opioid'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'ชายไทยอายุ 28 ปี ถูกนำส่งโรงพยาบาลโดยตำรวจ มีอาการกระสับกระส่าย พูดเสียงดัง บอกว่ามีคนตามฆ่า เห็นภาพหลอน ใช้ methamphetamine มา 3 วันไม่หลับ

V/S: BP 168/98 mmHg, HR 132, RR 22, Temp 38.2°C, SpO2 99%
ผู้ป่วยปฏิเสธการตรวจ พยายามทำร้ายเจ้าหน้าที่';

update public.mcq_questions
set choices = '[{"label":"A","text":"Oral antibiotics + outpatient follow-up"},{"label":"B","text":"Bedside needle aspiration หรือ incision and drainage + IV ATB ครอบคลุม anaerobe (clindamycin หรือ amoxicillin-clavulanate) + IV steroid + admit"},{"label":"C","text":"Lateral neck X-ray เพื่อ rule out epiglottitis ก่อน"},{"label":"D","text":"ส่ง CT neck with contrast เป็น first-line ทุกเคส"},{"label":"E","text":"ใส่ท่อช่วยหายใจทันทีเพราะ airway compromise"}]'::jsonb,
    explanation = 'ผู้ป่วยมี classic clinical findings ของ Peritonsillar Abscess (PTA / quinsy): "hot potato voice", uvula deviation, trismus, drooling, fever ตาม IDSA และ AAO-HNS guideline: (1) Diagnosis เป็น clinical — ไม่ต้อง imaging ใน classic case (2) Drainage: needle aspiration (78-94% successful) หรือ incision and drainage (3) Antibiotics ครอบคลุม group A strep + anaerobes (amoxicillin-clavulanate, clindamycin) (4) Steroid (dexamethasone) ลด pain และ inflammation (5) Admit ถ้าไม่ stable หรือไม่สามารถ swallow — ตัวเลือก B ถูก. A ผิด — outpatient อย่างเดียวไม่พอ. C ผิดเพราะไม่มีอาการของ epiglottitis (sniffing position, tripod). D ผิดเพราะ classic PTA ไม่ต้อง CT — ใช้ CT เฉพาะถ้าสงสัย parapharyngeal abscess. E ผิด — airway compromise เป็น relative — drainage ก่อน'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'หญิงไทยอายุ 19 ปี มาห้องฉุกเฉินด้วยอาการเจ็บคอรุนแรง กลืนลำบาก เสียงเปลี่ยน "hot potato voice" เป็นมา 4 วัน ก่อนมา 2 วันมี trismus (อ้าปากได้แค่ 2 ซม.)

V/S: HR 108, RR 18, SpO2 98%, Temp 39.1°C
Uvula deviated ไปทางขวา, swelling soft palate ซ้าย (bulging), tonsil ซ้ายดันลงตรงกลาง
Cervical lymphadenopathy left
Drooling +';

update public.mcq_questions
set choices = '[{"label":"A","text":"Oral amoxicillin-clavulanate + ciprofloxacin + outpatient follow-up เพราะ MASCC score < 21"},{"label":"B","text":"Empirical IV broad-spectrum antibiotic ครอบคลุม Pseudomonas (cefepime หรือ piperacillin-tazobactam หรือ carbapenem) ภายใน 1 ชั่วโมง + blood cultures × 2 + admit + ประเมิน source"},{"label":"C","text":"รอผล blood culture ก่อนเริ่มยา + admit observation"},{"label":"D","text":"ให้ G-CSF อย่างเดียวเพื่อ recover neutrophil count"},{"label":"E","text":"Vancomycin IV เพียงตัวเดียว"}]'::jsonb,
    explanation = 'Febrile neutropenia (T ≥ 38.3°C หรือ ≥ 38°C นาน 1 ชม. + ANC < 0.5 หรือคาดว่าจะลดต่ำกว่า 0.5 ใน 48 ชม.) เป็น oncologic emergency IDSA 2010 + ECIL-4 + NCCN guideline: (1) High-risk (MASCC < 21, hospitalized, comorbidity): IV empirical antibiotic ภายใน 1 ชม. ครอบคลุม Pseudomonas (anti-pseudomonal beta-lactam: cefepime, pip-tazo, meropenem) ลด mortality (2) Blood culture × 2 ก่อนให้ยา (1 peripheral + 1 central ถ้ามี) (3) Add vancomycin ถ้าสงสัย MRSA หรือ catheter-related (4) Source identification — ตัวเลือก B ถูก. A ผิดเพราะ AML + ANC 0.18 + mucositis = high risk ต้อง IV. C ผิด — delay > 1 ชม. mortality เพิ่ม. D ผิด — G-CSF เป็น adjunct ไม่ใช่ primary. E ผิด — vancomycin ครอบคลุม gram-positive แต่ FN ต้องครอบ Pseudomonas'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'ชายไทยอายุ 58 ปี เป็น AML on chemotherapy day 8 ของ induction มาห้องฉุกเฉินด้วยไข้สูง 39.2°C

V/S: BP 102/64, HR 112, RR 22, SpO2 96%, Temp 39.2°C
Gen: pale, no obvious focus of infection
Mucositis grade 2 oral
CBC: WBC 0.4 × 10⁹/L, ANC 0.18 × 10⁹/L (severe neutropenia), Hb 8.2, Plt 32,000';

update public.mcq_questions
set choices = '[{"label":"A","text":"ให้ยา carbamazepine ต่อเพราะอาจเป็น drug eruption ทั่วไป + topical steroid"},{"label":"B","text":"หยุด carbamazepine ทันที + admit ICU/Burn unit + IV fluid resuscitation (Parkland formula adjusted) + supportive care + ophthalmology consult + IV IgG หรือ cyclosporine consideration + ห้ามใช้ systemic steroid routine"},{"label":"C","text":"ให้ systemic prednisolone 1-2 mg/kg/วัน high-dose เป็น first-line"},{"label":"D","text":"Plasmapheresis เป็น first-line treatment"},{"label":"E","text":"Discharge home พร้อม oral antihistamine + follow-up"}]'::jsonb,
    explanation = 'ผู้ป่วยเป็น Stevens-Johnson Syndrome / Toxic Epidermal Necrolysis (SJS/TEN) overlap — BSA 10-30% = SJS/TEN overlap; > 30% = TEN; < 10% = SJS classic triggers: anticonvulsants (carbamazepine, lamotrigine, phenytoin), allopurinol, sulfonamides Management (BAD guidelines 2016, French ALDEN scoring): (1) หยุด trigger drug ทันที — เป็นปัจจัยสำคัญสุดต่อ survival (RegiSCAR study) (2) Admit ICU หรือ burn unit (3) Fluid resuscitation — Parkland formula × 0.7-0.8 (น้อยกว่า burn เพราะ less third spacing) (4) Eye care urgent (ophthalmology) ป้องกัน scarring (5) IVIG, cyclosporine มี evidence ลด mortality (6) Systemic steroid controversial — RegiSCAR ไม่แสดง benefit และอาจเพิ่ม infection (ห้าม routine) — ตัวเลือก B ถูก. A ผิดอย่างยิ่ง — ต้องหยุดทันที. C ผิด — steroid routine ไม่แนะนำ. D ผิด — plasmapheresis เป็น experimental. E ผิดอย่างยิ่ง'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'หญิงไทยอายุ 42 ปี เริ่มกินยา carbamazepine สำหรับ epilepsy มา 12 วัน มาห้องฉุกเฉินด้วยผื่นแดงและตุ่มน้ำพองทั่วลำตัว + เยื่อบุปาก ตา และอวัยวะเพศมีแผล

V/S: BP 102/68, HR 110, RR 20, Temp 39.0°C, SpO2 97%
ผิวหนัง: erythematous macules + atypical targets + flaccid bullae ครอบคลุม ~ 18% BSA
Nikolsky sign: positive
Mucosal erosions: oral, conjunctival, genital

Lab: WBC 11,200, Hb 12.4, Plt 188,000, BUN 28, Cr 1.0, Albumin 2.8, AST 142, ALT 168';

update public.mcq_questions
set choices = '[{"label":"A","text":"Vasovagal syncope — discharge home"},{"label":"B","text":"Hypertrophic Cardiomyopathy (HCM) ต้องสงสัย — admit + echocardiogram + cardiology consult + advise avoid strenuous exercise + screen family"},{"label":"C","text":"ส่ง CT brain เพื่อ rule out neurological cause"},{"label":"D","text":"Pacemaker implant ทันที"},{"label":"E","text":"EEG เพราะอาจเป็น seizure"}]'::jsonb,
    explanation = 'Syncope ระหว่าง exertion + family history of sudden cardiac death + systolic murmur ที่เพิ่มขึ้นเมื่อ Valsalva + EKG LVH/Q waves = high suspicion ของ Hypertrophic Cardiomyopathy (HCM) ESC 2018 + AHA/ACC 2020 HCM guideline: (1) Exertional syncope ใน HCM เป็น "red flag" สำคัญสำหรับ sudden cardiac death — admit (2) Echocardiogram ยืนยัน asymmetric septal hypertrophy ≥ 15 mm (3) Cardiology consult เพื่อประเมิน ICD indication (SCD risk score) (4) Counsel: avoid competitive sports, strenuous exercise (5) Family screening (autosomal dominant) — ตัวเลือก B ครบ. A ผิดเพราะ red flags บ่งบอกว่าไม่ใช่ vasovagal. C ผิดเพราะ neuro cause ไม่น่าจะเป็น syncope แบบนี้. D ผิดเพราะ pacemaker ไม่ใช่ first-line (ICD ต่างหาก ถ้า high SCD risk). E ผิดเพราะไม่มีอาการของ seizure'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'emergency_medicine'
  and scenario = 'ชายไทยอายุ 65 ปี ไม่มีโรคประจำตัว มาห้องฉุกเฉินด้วยอาการเป็นลม 1 ครั้ง ก่อนวิ่งออกกำลังกาย หมดสติ 30 วินาทีแล้วฟื้นเองสามารถจำเหตุการณ์ได้

ไม่มี aura, ไม่มี seizure activity, ไม่มี postictal confusion, ไม่มี tongue bite, ไม่มี incontinence

V/S ตอนนี้: BP 122/78 (no orthostasis), HR 68, RR 14, SpO2 99%
Family history: บิดาตายอย่างกะทันหันอายุ 50 ปี
PE: systolic murmur grade 3/6 ที่ apex เพิ่มขึ้นเมื่อ Valsalva

EKG: LVH, deep narrow Q waves ใน lateral leads';

commit;
