-- ============================================
-- Long Case #7: Dengue Hemorrhagic Fever
-- Day 4/7
-- ============================================

INSERT INTO public.long_cases (
  title, specialty, difficulty, week_number, is_weekly,
  patient_info, history_script, pe_findings, lab_results,
  correct_diagnosis, accepted_ddx, management_plan, teaching_points,
  examiner_questions, scoring_rubric
) VALUES (
  'หญิง 16 ปี ไข้สูง 5 วัน ปวดท้อง ซึมลง',
  'Infectious Disease',
  'hard',
  7,
  TRUE,
  '{"name":"นางสาวณัฐธิดา แก้วมณี","age":16,"gender":"หญิง","underlying":[],"allergies":[],"vitals":{"bp":"90/70","hr":120,"rr":24,"temp":37.2,"o2sat":95}}',

  '{"cc":"ไข้สูง 5 วัน ปวดท้อง ซึมลง","onset":"ไข้สูง 39-40°C มา 5 วัน วันนี้ไข้ลง แต่ซึมลง ปวดท้องมาก","pi":"เริ่มไข้สูงลอย 5 วันก่อน ปวดศีรษะมาก ปวดกระบอกตา ปวดเมื่อยตัว เบื่ออาหาร คลื่นไส้ วันที่ 3-4 มีจุดเลือดออกที่แขน ขา วันที่ 5 (วันนี้) ไข้ลดลงเหลือ 37.2 แต่ปวดท้องบริเวณชายโครงขวามาก ซึมลง กระสับกระส่าย มือเท้าเย็น เลือดกำเดาไหล 1 ครั้ง","pmh":"แข็งแรงดี เคยเป็นไข้เลือดออกเมื่อ 3 ปีก่อน","sh":"นักเรียน ม.4 อยู่กทม."}',

  '{"GA":"เด็กสาว ซึม กระสับกระส่าย มือเท้าเย็น ชื้น","HEENT":"หน้าแดง conjunctival injection ไม่มี subconjunctival hemorrhage","Heart":"Tachycardia, regular, S1S2 normal, faint heart sound","Lung":"Decreased breath sound right base","Abdomen":"ตับโต 3 cm below costal margin กดเจ็บ RUQ มาก positive shifting dullness (ascites)","Skin":"Petechiae ที่แขนขา Tourniquet test positive (>20 petechiae/inch²) มี ecchymosis บริเวณที่เจาะเลือด","Extremities":"Cool, clammy, CRT 4 sec, weak thready pulse"}',

  '{"CBC (Day 5)":{"value":"WBC 3,200, Hb 16.8 (Hct 50.4% สูงขึ้นจาก baseline 38%), Plt 28,000","isAbnormal":true},"CBC (Day 3)":{"value":"WBC 4,500, Hb 13.0 (Hct 38%), Plt 95,000","isAbnormal":true},"Dengue NS1 Ag":{"value":"Positive","isAbnormal":true},"Dengue IgM/IgG":{"value":"IgM positive, IgG positive (secondary infection)","isAbnormal":true},"LFT":{"value":"AST 520, ALT 280, Albumin 2.8","isAbnormal":true},"Coagulation":{"value":"PT 15.8s (prolonged), aPTT 42s (prolonged)","isAbnormal":true},"CXR":{"value":"Right pleural effusion","isAbnormal":true},"US Abdomen":{"value":"Ascites, gallbladder wall thickening 6 mm, right pleural effusion, hepatomegaly","isAbnormal":true}}',

  'Dengue Hemorrhagic Fever Grade III (Dengue Shock Syndrome)',
  '["Dengue Hemorrhagic Fever/DSS","Chikungunya","Zika","Leptospirosis","Typhoid fever","Acute hepatitis"]',
  'Fluid resuscitation: NSS 10-20 mL/kg bolus ใน 15-30 นาที ซ้ำได้; ถ้าดีขึ้น ลดเป็น 10→7→5→3 mL/kg/hr ตาม protocol; Monitor Hct ทุก 2-4 ชม.; ถ้า Hct ลด + unstable → สงสัย internal bleeding ให้ PRC; Platelet transfusion เฉพาะ active significant bleeding; ห้ามให้ NSAIDs/Aspirin; IV Vitamin K ถ้า coagulopathy; Monitor urine output ≥0.5 mL/kg/hr; Watch for fluid overload ใน recovery phase',

  '["Critical phase = วันที่ไข้ลง (defervescence) วันที่ 4-7 ไม่ใช่ตอนไข้สูง","Hct rising ≥20% from baseline = evidence of plasma leakage","DHF grading: I-IV, Grade III-IV = DSS","Secondary dengue infection รุนแรงกว่า primary (antibody-dependent enhancement)","Warning signs: ปวดท้อง ซึมลง อาเจียนมาก ตับโต Hct สูงขึ้นเร็ว Plt ลดเร็ว","ห้ามให้ fluid มากเกินในช่วง recovery phase → pulmonary edema","Tourniquet test: ≥10 petechiae/inch² = positive (WHO criteria)"]',

  '[{"question":"ทำไม critical phase ถึงเป็นตอนไข้ลง ไม่ใช่ตอนไข้สูง","modelAnswer":"Defervescence phase เป็นช่วง maximum plasma leakage จาก increased vascular permeability ทำให้ Hct สูงขึ้น (hemoconcentration) เกิด pleural effusion ascites ถ้า leakage มาก → hypovolemic shock (DSS) ช่วง febrile phase ยังไม่มี significant leakage","points":20},{"question":"Hematocrit ของผู้ป่วยเปลี่ยนแปลงอย่างไร บ่งชี้อะไร","modelAnswer":"Hct เพิ่มจาก 38% เป็น 50.4% = เพิ่ม 32.6% จาก baseline (>20%) ยืนยัน significant plasma leakage ซึ่งเป็น criteria ของ DHF ร่วมกับ thrombocytopenia + hemorrhagic manifestation + evidence of plasma leakage","points":15},{"question":"ผู้ป่วยรายนี้จัดเป็น DHF grade อะไร เพราะอะไร","modelAnswer":"DHF Grade III (DSS): มีครบ 4 criteria ของ DHF (fever, hemorrhage, thrombocytopenia, plasma leakage) + signs of circulatory failure: pulse pressure ≤20 mmHg (90/70 = PP 20), cold clammy skin, restlessness, tachycardia Grade III = compensated shock, Grade IV = profound shock (undetectable BP)","points":20},{"question":"เมื่อไรควรให้ platelet transfusion ในไข้เลือดออก","modelAnswer":"ไม่ให้ตาม platelet count อย่างเดียว ให้เฉพาะเมื่อมี significant active bleeding (เช่น GI bleed, massive epistaxis) หรือ platelet <10,000 ที่มีความเสี่ยงสูง Prophylactic platelet transfusion ไม่มีประโยชน์และอาจเพิ่ม fluid overload","points":15}]',

  '{"history":25,"pe":20,"lab":25,"ddx":10,"management":20}'
);
