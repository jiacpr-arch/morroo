-- ============================================
-- Long Case #10: Pediatric Febrile Seizure + Meningitis
-- Day 7/7
-- ============================================

INSERT INTO public.long_cases (
  title, specialty, difficulty, week_number, is_weekly,
  patient_info, history_script, pe_findings, lab_results,
  correct_diagnosis, accepted_ddx, management_plan, teaching_points,
  examiner_questions, scoring_rubric
) VALUES (
  'เด็กชาย 2 ปี ชักเกร็ง มีไข้สูง',
  'Pediatrics',
  'hard',
  10,
  TRUE,
  '{"name":"ด.ช.ภูผา แสงทอง","age":2,"gender":"ชาย","underlying":[],"allergies":[],"vitals":{"bp":"85/55","hr":160,"rr":36,"temp":39.8,"o2sat":94}}',

  '{"cc":"ชักเกร็งทั้งตัว มีไข้สูง","onset":"ชักเกร็งกระตุกทั้งตัวที่บ้านนาน 25 นาที แม่โทรเรียกรถพยาบาล ให้ Diazepam rectal ระหว่างทาง ชักหยุด มาถึง ER ชักซ้ำอีก 5 นาที","pi":"ไข้สูง 2 วัน ไอ น้ำมูก ร้องกวน ไม่ยอมกินข้าว วันนี้ไข้สูงขึ้น 39.8 แม่ให้ Paracetamol แต่ไข้ไม่ลง ชักเกร็งกระตุกทั้งตัว ลูกตากลอกขึ้น ริมฝีปากเขียว นาน ~25 นาที ก่อนหน้านี้ไม่เคยชัก ไม่มีท้องเสีย ไม่มีผื่น ไม่มีประวัติศีรษะกระแทก","pmh":"คลอดปกติ ครบกำหนด พัฒนาการสมวัย วัคซีนครบ ไม่เคยชัก ไม่เคย admit","fh":"พ่อเคยชักมีไข้ตอนเด็ก","sh":"อยู่กับพ่อแม่ เข้าเนอร์สเซอรี่"}',

  '{"GA":"เด็กชาย ซึม ไม่ร้อง ตอบสนองต่อความเจ็บปวด GCS E2V3M5=10 (pediatric scale)","HEENT":"Anterior fontanelle ปิดแล้ว ไม่มี bulging, คอแข็ง (neck stiffness), Kernig sign positive, Brudzinski sign positive, pharynx แดง, TM bilateral ปกติ","Heart":"Tachycardia regular, no murmur","Lung":"Bilateral coarse crepitation ทั้ง 2 ข้าง","Abdomen":"Soft, no hepatosplenomegaly","Skin":"ไม่มีผื่น ไม่มี petechiae, CRT 2 sec","Neuro":"Pupils equal 3 mm reactive, no focal deficit หลังหยุดชัก, ซึมลงมาก (post-ictal หรือ meningitis)"}',

  '{"CBC":{"value":"WBC 22,500 (PMN 78%, Band 12%), Hb 11.2, Plt 195,000","isAbnormal":true},"CRP":{"value":"125 mg/L","isAbnormal":true},"Blood culture":{"value":"Pending","isAbnormal":false},"CSF":{"value":"WBC 1,200 (PMN 90%), Protein 180 mg/dL, Glucose 22 mg/dL (serum glucose 95, ratio 0.23), Gram stain: Gram-positive diplococci","isAbnormal":true},"BMP":{"value":"Na 132, K 4.5, Cl 100, BUN 15, Cr 0.3, Glucose 95","isAbnormal":true},"CXR":{"value":"Bilateral perihilar infiltration","isAbnormal":true},"CT Brain":{"value":"No mass, no hydrocephalus, no hemorrhage","isAbnormal":false}}',

  'Bacterial Meningitis (Streptococcus pneumoniae) presenting with prolonged febrile seizure (status epilepticus)',
  '["Bacterial Meningitis","Simple Febrile Seizure","Complex Febrile Seizure","Viral Meningoencephalitis","Brain abscess","Febrile Status Epilepticus"]',
  'ABCs + หยุดชัก: IV Lorazepam 0.1 mg/kg หรือ IV Diazepam 0.2 mg/kg (ถ้ายังชัก); ถ้าชักต่อ: IV Phenytoin 20 mg/kg หรือ IV Levetiracetam 40 mg/kg; IV Ceftriaxone 100 mg/kg/day แบ่ง q12h + IV Vancomycin 60 mg/kg/day แบ่ง q6h (empiric สำหรับ bacterial meningitis); IV Dexamethasone 0.15 mg/kg q6h x 4 days (ให้ก่อนหรือพร้อม ATB dose แรก); IV fluid maintenance (ระวัง SIADH ให้ 2/3 maintenance); Monitor: GCS, pupil, vital signs ทุก 1-2 ชม.; Repeat LP ถ้า clinical ไม่ดีขึ้นใน 48-72 ชม.; Admit PICU',

  '["Febrile seizure แบ่ง Simple vs Complex: Simple = generalized, <15 min, ไม่ซ้ำใน 24 ชม. Complex = focal, >15 min, หรือซ้ำใน 24 ชม.","ผู้ป่วยนี้ชัก >15 min = complex febrile seizure / febrile status epilepticus → ต้อง work up เพิ่มเติม","Meningeal signs ในเด็ก <2 ปี อาจไม่ชัดเจน — ใน case นี้ 2 ปี + คอแข็ง + Kernig/Brudzinski positive = ชัดเจน","CSF ที่บ่งบอก bacterial meningitis: WBC >1000 (PMN predominant), protein >100, glucose <40 หรือ CSF/serum ratio <0.4","Gram-positive diplococci = S. pneumoniae (พบบ่อยสุดในเด็ก >2 เดือน)","Dexamethasone ลด mortality และ hearing loss โดยเฉพาะ S. pneumoniae meningitis — ต้องให้ก่อนหรือพร้อม ATB dose แรก","ชัก >5 นาที = status epilepticus ต้องรักษาทันที ห้ามรอ","SIADH พบบ่อยใน meningitis — restrict fluid + monitor Na"]',

  '[{"question":"ผู้ป่วยรายนี้เป็น Simple หรือ Complex febrile seizure เพราะอะไร และทำไมต้องทำ LP","modelAnswer":"Complex febrile seizure เพราะ: 1) ชักนาน >15 นาที (25 นาที = status epilepticus) 2) ชักซ้ำใน 24 ชม. (ชักซ้ำที่ ER) ต้องทำ LP เพราะ: 1) Complex febrile seizure + อายุ <2 ปี 2) มี meningeal signs (neck stiffness, Kernig+, Brudzinski+) 3) GCS ลดลง ไม่ใช่แค่ post-ictal ธรรมดา 4) High CRP + leukocytosis with left shift","points":20},{"question":"CSF ของผู้ป่วยเข้าได้กับ bacterial หรือ viral meningitis อธิบาย","modelAnswer":"Bacterial meningitis: WBC 1,200 (>1000, สูงมาก), PMN predominant 90%, Protein 180 (สูงมาก >100), Glucose 22 ต่ำมาก (CSF/serum ratio 0.23 <0.4), Gram stain positive ถ้า viral: WBC มักต่ำกว่า (<300), lymphocyte predominant, protein เพิ่มเล็กน้อย, glucose ปกติ","points":20},{"question":"ทำไมต้องให้ Dexamethasone และเมื่อไรควรให้","modelAnswer":"Dexamethasone ลด inflammation ใน subarachnoid space ลด mortality, neurological sequelae โดยเฉพาะ hearing loss จาก S. pneumoniae meningitis (cochlear damage) ต้องให้ก่อนหรือพร้อมกับ ATB dose แรก (ภายใน 30 นาที) ถ้าให้หลังจาก ATB ไปแล้ว ประโยชน์ลดลง Dose: 0.15 mg/kg IV q6h x 4 วัน","points":15},{"question":"ถ้าผู้ป่วยชักไม่หยุดหลังให้ Benzodiazepine 2 doses จะทำอย่างไร","modelAnswer":"Refractory status epilepticus: Step 1: Benzodiazepine (Lorazepam 0.1 mg/kg IV ซ้ำได้ 1 ครั้ง) Step 2: IV Phenytoin 20 mg/kg over 20 min หรือ IV Levetiracetam 40 mg/kg Step 3: ถ้ายังชัก = refractory SE → Midazolam infusion 0.1-0.4 mg/kg/hr หรือ Thiopental/Propofol infusion + intubation → admit PICU + continuous EEG monitoring","points":20}]',

  '{"history":25,"pe":20,"lab":25,"ddx":10,"management":20}'
);
