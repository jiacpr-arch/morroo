-- ============================================
-- Long Case #5: Acute Appendicitis
-- Day 2/7
-- ============================================

INSERT INTO public.long_cases (
  title, specialty, difficulty, week_number, is_weekly,
  patient_info, history_script, pe_findings, lab_results,
  correct_diagnosis, accepted_ddx, management_plan, teaching_points,
  examiner_questions, scoring_rubric
) VALUES (
  'ชาย 28 ปี ปวดท้องย้ายมาลงท้องน้อยขวา',
  'Surgery',
  'medium',
  5,
  TRUE,
  '{"name":"นายธนพล วงศ์สุวรรณ","age":28,"gender":"ชาย","underlying":[],"allergies":[],"vitals":{"bp":"130/80","hr":98,"rr":20,"temp":38.3,"o2sat":99}}',

  '{"cc":"ปวดท้องน้อยขวา 1 วัน","onset":"เริ่มปวดรอบสะดือเมื่อวานตอนเย็น ต่อมาย้ายลงมาปวดท้องน้อยด้านขวา","pi":"เริ่มปวดแบบจุกๆ รอบสะดือก่อน ไม่มากนัก คลื่นไส้ เบื่ออาหาร กินข้าวไม่ได้ ประมาณ 6 ชม. ต่อมาปวดย้ายลงมาที่ท้องน้อยขวา ปวดตลอดเวลา เจ็บมากขึ้นเวลาเดินหรือไอ อาเจียน 2 ครั้ง มีไข้ต่ำๆ ไม่มีท้องเสีย ถ่ายปกติเมื่อเช้า ไม่มีปัสสาวะแสบขัด","pmh":"ไม่มีโรคประจำตัว ไม่เคยผ่าตัด","sh":"พนักงานออฟฟิศ ไม่สูบบุหรี่ ดื่มเบียร์บ้างนานๆ ครั้ง"}',

  '{"GA":"ชายหนุ่ม นอนนิ่ง ไม่อยากขยับตัว ดูเจ็บปวด","Abdomen":"กดเจ็บ RLQ มากที่สุดที่ McBurney point, rebound tenderness (+), guarding (+) RLQ, Rovsing sign (+), Psoas sign (+), Obturator sign (-), bowel sound ลดลง","HEENT":"ปกติ ลิ้นค่อนข้างแห้ง","Heart":"Regular, tachycardia, no murmur","Lung":"Clear","DRE":"Tenderness at right side on rectal exam"}',

  '{"CBC":{"value":"WBC 15,800 (PMN 85%, Band 5%), Hb 14.5, Plt 290,000","isAbnormal":true},"UA":{"value":"Normal, WBC 0-2, RBC 0-1, no bacteria","isAbnormal":false},"CRP":{"value":"85 mg/L (ปกติ <5)","isAbnormal":true},"CT Abdomen":{"value":"Dilated appendix 12 mm with wall enhancement, periappendiceal fat stranding, no free air, small amount of free fluid in RLQ","isAbnormal":true},"Electrolytes":{"value":"Na 139, K 3.9, Cl 101, BUN 18, Cr 1.0","isAbnormal":false}}',

  'Acute Appendicitis (uncomplicated)',
  '["Acute Appendicitis","Mesenteric lymphadenitis","Right ureteral stone","Meckel diverticulitis","Cecal diverticulitis"]',
  'NPO; IV fluid NSS hydration; IV antibiotics (Ceftriaxone + Metronidazole หรือ Piperacillin-Tazobactam); Laparoscopic appendectomy ภายใน 24 ชม.; Pain control: Morphine IV prn (ให้ analgesic ได้ไม่ต้องรอ surgeon); Post-op: early ambulation, diet advancement, ATB 24 ชม. ถ้า uncomplicated',

  '["Classic migration pain: periumbilical → RLQ = คลาสสิกมากของ appendicitis","McBurney point = junction ของ outer 1/3 และ inner 2/3 ของเส้น ASIS-umbilicus","Rovsing sign = กดท้องน้อยซ้ายแล้วเจ็บขวา บ่งชี้ peritoneal irritation","Psoas sign (+) = retrocecal appendix","ห้าม delay analgesic — การให้ยาแก้ปวดไม่ mask การตรวจร่างกาย (evidence-based)","Alvarado Score ช่วย clinical diagnosis: Migration, Anorexia, Nausea, RLQ tenderness, Rebound, Elevated temp, Leukocytosis, Left shift","CT sensitivity 94-98% สำหรับ appendicitis — gold standard imaging"]',

  '[{"question":"อธิบาย pathophysiology ว่าทำไมปวดรอบสะดือก่อนแล้วค่อยย้ายลง RLQ","modelAnswer":"ระยะแรก appendix อุดตัน เกิด visceral pain ผ่าน visceral afferent nerve (T10) ทำให้ปวดรอบสะดือ (referred pain) เมื่อ inflammation ลุกลามถึง parietal peritoneum จะเกิด somatic pain ซึ่ง localize ได้ที่ RLQ ตรงตำแหน่ง appendix","points":20},{"question":"Alvarado Score ของผู้ป่วยรายนี้เท่าไร แจกแจงให้ดู","modelAnswer":"Migration (+1), Anorexia (+1), Nausea/Vomiting (+1), RLQ tenderness (+2), Rebound (+1), Temperature >37.3 (+1), Leukocytosis (+2), Left shift (+1) = 10/10 คะแนนเต็ม บ่งชี้ appendicitis สูงมาก","points":15},{"question":"ถ้า CT พบ appendix diameter 8 mm ไม่มี fat stranding จะวินิจฉัยอย่างไร","modelAnswer":"Appendix 6-8 mm ถือว่า borderline (ปกติ <6 mm) ถ้าไม่มี fat stranding อาจเป็น early appendicitis หรือ normal variant ควร clinical correlation + serial exam หรือ repeat imaging ใน 6-12 ชม.","points":15},{"question":"Laparoscopic vs Open appendectomy ข้อดีข้อเสียอย่างไร","modelAnswer":"Laparoscopic: แผลเล็ก เจ็บน้อย ฟื้นเร็ว กลับไปทำงานเร็ว มองเห็น peritoneal cavity ได้ดี สามารถวินิจฉัยโรคอื่นได้ด้วย ข้อเสีย: ใช้เวลานานกว่าเล็กน้อย ต้องใช้ equipment พิเศษ Open: เร็ว ง่าย ไม่ต้องใช้ equipment พิเศษ เหมาะกับ complicated case ปัจจุบัน laparoscopic เป็น standard of care","points":20}]',

  '{"history":20,"pe":25,"lab":20,"ddx":15,"management":20}'
);
