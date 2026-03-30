-- ============================================
-- Long Case #6: Acute Ischemic Stroke
-- Day 3/7
-- ============================================

INSERT INTO public.long_cases (
  title, specialty, difficulty, week_number, is_weekly,
  patient_info, history_script, pe_findings, lab_results,
  correct_diagnosis, accepted_ddx, management_plan, teaching_points,
  examiner_questions, scoring_rubric
) VALUES (
  'ชาย 65 ปี แขนขาซ้ายอ่อนแรงเฉียบพลัน',
  'Neurology',
  'hard',
  6,
  TRUE,
  '{"name":"นายสมศักดิ์ เจริญสุข","age":65,"gender":"ชาย","underlying":["HT","AF (ไม่ได้ทาน warfarin)","DM type 2"],"allergies":[],"vitals":{"bp":"185/105","hr":88,"rr":18,"temp":37.0,"o2sat":96}}',

  '{"cc":"แขนขาซ้ายอ่อนแรง พูดไม่ชัด 2 ชั่วโมง","onset":"ภรรยาพบผู้ป่วยล้มในห้องน้ำ พูดไม่ชัด แขนขาซ้ายยกไม่ขึ้น เมื่อ 2 ชั่วโมงก่อน Last known well เวลา 06.00 น.","pi":"ตื่นเช้าปกติ 06.00 น. เข้าห้องน้ำ ภรรยาได้ยินเสียงล้มเวลา 06.30 น. พบว่าพูดไม่ชัด ปากเบี้ยวขวา แขนขาซ้ายอ่อนแรง ไม่มีชัก ไม่ปวดหัว ไม่อาเจียน ไม่เคยมีอาการแบบนี้มาก่อน","pmh":"HT 10 ปี ทานยาไม่สม่ำเสมอ AF วินิจฉัย 2 ปีก่อน แพทย์สั่ง warfarin แต่ไม่ทาน DM type 2 ทาน Metformin","sh":"สูบบุหรี่ 30 pack-years ยังสูบอยู่ ดื่มเหล้าสังคม"}',

  '{"GA":"ชายสูงอายุ ตื่น alert แต่พูดไม่ชัด ไม่เข้าใจคำสั่งซับซ้อน","Neuro":"GCS E4V3M6=13; Aphasia: global aphasia (พูดไม่ชัด เข้าใจคำสั่งไม่ได้); Cranial nerve: Left facial droop (UMN pattern), Left homonymous hemianopia; Motor: Left hemiplegia (arm 0/5, leg 2/5); Sensory: decreased sensation left side; NIHSS = 18","Heart":"Irregularly irregular (AF), no murmur","Lung":"Clear","Neck":"No bruit"}',

  '{"CT Brain non-contrast":{"value":"ไม่พบ hemorrhage, early ischemic change: loss of insular ribbon sign ขวา, hyperdense MCA sign ขวา","isAbnormal":true},"CT Angiography":{"value":"Occlusion of right M1 segment of MCA","isAbnormal":true},"ECG":{"value":"Atrial fibrillation, rate 85, no ST change","isAbnormal":true},"CBC":{"value":"WBC 9,800, Hb 13.5, Plt 245,000","isAbnormal":false},"Coagulation":{"value":"PT 12.5s, INR 1.0, aPTT 28s","isAbnormal":false},"BMP":{"value":"Na 140, K 4.2, Cr 1.1, Glucose 165","isAbnormal":false},"Lipid":{"value":"TC 255, LDL 168, HDL 38, TG 220","isAbnormal":true}}',

  'Acute Ischemic Stroke — Right MCA territory, cardioembolic (AF)',
  '["Acute Ischemic Stroke (MCA)","Hemorrhagic Stroke","Todd paralysis post-seizure","Hypoglycemia","Brain tumor with acute presentation"]',
  'Activate Stroke Fast Track; IV rtPA (Alteplase) 0.9 mg/kg (max 90 mg) ภายใน 4.5 ชม. ถ้าไม่มี contraindication; พิจารณา Mechanical thrombectomy (NIHSS ≥6, LVO, ภายใน 24 ชม.); BP control: ก่อน rtPA ลด BP <185/110, หลัง rtPA <180/105; NPO จนกว่า swallow assessment; Monitor neuro q15min x 2 ชม. หลัง rtPA; Admit Stroke Unit; หลัง 24 ชม.: start anticoagulant สำหรับ AF (DOAC preferred)',

  '["Stroke Fast Track: Door-to-needle <60 นาที","IV rtPA window: ภายใน 4.5 ชม. จาก onset (หรือ last known well)","Mechanical thrombectomy: LVO + NIHSS ≥6 + ASPECTS ≥6 ภายใน 24 ชม.","AF เป็น major risk factor สำหรับ cardioembolic stroke — ต้องให้ anticoagulant","Hyperdense MCA sign = acute thrombus ใน MCA บน non-contrast CT","NIHSS score ประเมินความรุนแรง: >15 = severe stroke","ห้ามให้ antiplatelet/anticoagulant ภายใน 24 ชม. หลัง rtPA"]',

  '[{"question":"ผู้ป่วยรายนี้เข้าเกณฑ์ IV rtPA หรือไม่ อธิบาย","modelAnswer":"เข้าเกณฑ์: onset ภายใน 4.5 ชม. (last known well 06.00, มาถึง ~08.30), ไม่มี hemorrhage บน CT, INR 1.0 (ไม่ได้ทาน anticoagulant), NIHSS 18 (significant deficit), ไม่มี contraindication อื่น ควรให้ rtPA 0.9 mg/kg","points":20},{"question":"Mechanical thrombectomy เหมาะกับผู้ป่วยรายนี้ไหม เพราะอะไร","modelAnswer":"เหมาะมาก: มี LVO (Right M1 MCA occlusion), NIHSS 18 (≥6), อยู่ใน time window, ควรทำหลังจากเริ่ม IV rtPA แล้ว (bridging therapy) หรือทำ thrombectomy อย่างเดียวถ้ามี rtPA contraindication","points":20},{"question":"ทำไม AF ถึงทำให้เกิด stroke ได้ และหลังจากเหตุการณ์นี้ควรป้องกันอย่างไร","modelAnswer":"AF ทำให้เลือดไหลวน stasis ใน left atrial appendage เกิด thrombus หลุดไป embolize ใน cerebral artery ป้องกันด้วย anticoagulant: DOAC (เช่น Apixaban, Rivaroxaban) preferred over warfarin เนื่องจาก safer profile ใช้ CHA2DS2-VASc score ประเมิน ผู้ป่วยนี้ score สูงมาก ต้องได้ anticoagulant","points":15},{"question":"BP management ในผู้ป่วย acute stroke ที่จะให้ rtPA ต่างจากไม่ให้อย่างไร","modelAnswer":"ก่อนและระหว่าง rtPA: BP ต้อง <185/110 (ก่อนให้) และ <180/105 (24 ชม.หลังให้) ใช้ Labetalol หรือ Nicardipine IV ถ้าไม่ให้ rtPA: permissive hypertension ยอมได้ถึง 220/120 ลด BP เฉพาะ >220/120 หรือมี end-organ damage","points":15}]',

  '{"history":20,"pe":25,"lab":20,"ddx":15,"management":20}'
);
