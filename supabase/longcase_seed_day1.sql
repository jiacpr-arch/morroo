-- ============================================
-- Long Case #4: Diabetic Ketoacidosis (DKA)
-- Day 1/7
-- ============================================

INSERT INTO public.long_cases (
  title, specialty, difficulty, week_number, is_weekly,
  patient_info, history_script, pe_findings, lab_results,
  correct_diagnosis, accepted_ddx, management_plan, teaching_points,
  examiner_questions, scoring_rubric
) VALUES (
  'หญิง 22 ปี หอบเหนื่อย สับสน',
  'Endocrinology',
  'hard',
  4,
  TRUE,
  '{"name":"นางสาวปิยะดา จันทร์สว่าง","age":22,"gender":"หญิง","underlying":["DM type 1 (diagnosed age 12)"],"allergies":[],"vitals":{"bp":"95/60","hr":125,"rr":32,"temp":37.8,"o2sat":98}}',

  '{"cc":"หอบเหนื่อย สับสน 1 วัน","onset":"เริ่มคลื่นไส้อาเจียนเมื่อวาน ต่อมาหอบเหนื่อยมากขึ้นเรื่อยๆ ญาติพบว่าสับสน เรียกไม่ค่อยรู้ตัว","pi":"มีไข้หวัด เจ็บคอ 3 วันก่อน หยุดฉีด insulin เอง 2 วัน เพราะกินอาหารไม่ได้ คิดว่าไม่จำเป็น คลื่นไส้อาเจียน 5-6 ครั้ง ปวดท้องทั่วๆ กินน้ำไม่ได้ ปัสสาวะบ่อยมาก กระหายน้ำ","pmh":"DM type 1 ฉีด insulin 10 ปี เคย admit DKA 1 ครั้งตอนอายุ 15 ปี","sh":"นักศึกษา อยู่หอคนเดียว ไม่สูบบุหรี่ ไม่ดื่มเหล้า"}',

  '{"GA":"หญิงสาว ดูซึม ตอบช้า GCS E3V4M6=13 หายใจเร็วลึก (Kussmaul breathing) ลมหายใจมีกลิ่นผลไม้ (fruity breath)","HEENT":"ริมฝีปากแห้งแตก ลิ้นแห้ง ตาโบ๋ คอแดงเล็กน้อย","Heart":"Tachycardia regular rhythm, no murmur","Lung":"Clear, deep rapid breathing","Abdomen":"กดเจ็บทั่วๆ เล็กน้อย ไม่มี guarding ไม่มี rebound tenderness bowel sound ปกติ","Skin":"Turgor ลดลง แห้ง capillary refill 3 วินาที"}',

  '{"CBG":{"value":"485 mg/dL","isAbnormal":true},"ABG":{"value":"pH 7.12, pCO2 18, HCO3 6.5, BE -22","isAbnormal":true},"Serum Ketone":{"value":"6.8 mmol/L (สูงมาก)","isAbnormal":true},"BMP":{"value":"Na 128 (corrected 134), K 5.8, Cl 95, BUN 32, Cr 1.6","isAbnormal":true},"CBC":{"value":"WBC 18,500 (PMN 82%), Hb 14.2, Plt 310,000","isAbnormal":true},"UA":{"value":"Glucose 4+, Ketone 4+, Specific gravity 1.035","isAbnormal":true},"Serum Osmolality":{"value":"320 mOsm/kg","isAbnormal":true}}',

  'Diabetic Ketoacidosis (DKA) — precipitated by infection + insulin omission',
  '["Diabetic Ketoacidosis","Hyperosmolar Hyperglycemic State (HHS)","Sepsis with metabolic acidosis","Alcoholic ketoacidosis"]',
  'IV NSS 1L bolus แล้ว 500 mL/hr; Regular insulin IV drip 0.1 unit/kg/hr (ห้าม bolus ถ้า K<3.3); เมื่อ glucose <250 เปลี่ยนเป็น D5W + insulin drip; K replacement: ถ้า K 4-5.3 ให้ KCl 20-30 mEq/L ใน IV fluid; Monitor glucose ทุก 1 ชม., electrolytes ทุก 2-4 ชม.; หา precipitating cause: ให้ ATB ถ้าสงสัย infection; เมื่อ AG ปิด + กินได้ → เปลี่ยน subcutaneous insulin overlap 1-2 ชม. ก่อนหยุด drip',

  '["DKA triad: Hyperglycemia + Metabolic acidosis (AG) + Ketonemia","Kussmaul breathing = respiratory compensation สำหรับ metabolic acidosis","Corrected Na = measured Na + 1.6 x (glucose-100)/100","ห้ามหยุด insulin แม้กินอาหารไม่ได้ — ลด dose ได้แต่ห้ามหยุด","Pseudohyperkalemia: K สูงจาก acidosis แต่ total body K ต่ำ เมื่อแก้ acidosis K จะตก","Abdominal pain ใน DKA เป็น common finding ไม่จำเป็นต้องเป็น surgical abdomen","Precipitating factors 5I: Infection, Insulin omission, Infarction, Intoxication, Initial presentation"]',

  '[{"question":"ทำไมผู้ป่วยถึง K สูง ทั้งที่ total body K ต่ำ","modelAnswer":"ใน DKA acidosis ทำให้ H+ เข้าเซลล์ แลก K+ ออกมา และขาด insulin ทำให้ K+ ไม่เข้าเซลล์ ดังนั้น serum K สูงแต่ total body K depleted เมื่อเริ่ม insulin + แก้ acidosis K จะตกเร็ว ต้อง monitor + replace","points":20},{"question":"เมื่อไรควรเปลี่ยนจาก NSS เป็น D5W ในการรักษา DKA","modelAnswer":"เมื่อ blood glucose ลดลงเหลือ <200-250 mg/dL เปลี่ยนเป็น D5 0.45% NaCl + ต่อ insulin drip เพื่อป้องกัน hypoglycemia และยัง clear ketones ต่อ","points":15},{"question":"Anion gap ของผู้ป่วยเท่าไร คำนวณให้ดู","modelAnswer":"AG = Na - (Cl + HCO3) = 128 - (95 + 6.5) = 26.5 (ปกติ 8-12) สูงมาก confirm high anion gap metabolic acidosis จาก ketoacidosis","points":15},{"question":"ก่อนหยุด insulin drip ต้องทำอะไรก่อน และทำไม","modelAnswer":"ต้องให้ subcutaneous insulin (basal + bolus) overlap อย่างน้อย 1-2 ชั่วโมง ก่อนหยุด drip เพราะ IV insulin half-life สั้นมาก (~5 นาที) ถ้าหยุดทันที จะเกิด rebound DKA","points":20}]',

  '{"history":25,"pe":15,"lab":25,"ddx":15,"management":20}'
);
