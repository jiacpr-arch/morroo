-- ============================================
-- Long Case #9: Severe Preeclampsia
-- Day 6/7
-- ============================================

INSERT INTO public.long_cases (
  title, specialty, difficulty, week_number, is_weekly,
  patient_info, history_script, pe_findings, lab_results,
  correct_diagnosis, accepted_ddx, management_plan, teaching_points,
  examiner_questions, scoring_rubric
) VALUES (
  'หญิง 32 ปี ตั้งครรภ์ 34 สัปดาห์ ปวดศีรษะ ตาพร่ามัว',
  'Obstetrics',
  'hard',
  9,
  TRUE,
  '{"name":"นางสุภาวดี ศรีสมบูรณ์","age":32,"gender":"หญิง","underlying":["G2P1 GA 34 weeks","Chronic HT (on Methyldopa)"],"allergies":["Sulfa drugs"],"vitals":{"bp":"175/115","hr":100,"rr":22,"temp":36.8,"o2sat":97}}',

  '{"cc":"ปวดศีรษะรุนแรง ตาพร่ามัว 6 ชั่วโมง","onset":"ปวดศีรษะรุนแรงบริเวณท้ายทอยตั้งแต่เช้า ตาพร่ามัว จุดดำลอยไปมา","pi":"ครรภ์ที่ 2 อายุครรภ์ 34 สัปดาห์ ฝากครรภ์สม่ำเสมอ มี chronic HT ทาน Methyldopa 250 mg วันละ 3 เวลา ความดันคุมได้ดี 130-140/80-90 วันนี้ตื่นมาปวดศีรษะรุนแรงมาก ตาพร่ามัว คลื่นไส้อาเจียน 2 ครั้ง จุกแน่นลิ้นปี่ ขาบวมมากขึ้น 1 สัปดาห์ น้ำหนักขึ้นเร็ว 3 kg ใน 1 สัปดาห์ ลูกดิ้นดี ไม่มีเลือดออกทางช่องคลอด ไม่มีน้ำเดิน","pmh":"G2P1 ลูกคนแรกคลอดปกติ ไม่มี preeclampsia ครั้งก่อน Chronic HT วินิจฉัย 3 ปีก่อน","sh":"แม่บ้าน สามีทำงานโรงงาน"}',

  '{"GA":"หญิงตั้งครรภ์ ดู alert แต่กระสับกระส่าย ปวดหัวมาก หน้าบวม","HEENT":"หน้าบวม conjunctiva ไม่ซีด fundoscopy: retinal edema, no papilledema","Heart":"Tachycardia regular, loud S2, no murmur","Lung":"Bilateral basal fine crepitation","Abdomen":"Uterus 34 wk size, FHS 155 bpm, cephalic presentation, no tenderness, no contraction","Extremities":"Pitting edema 3+ bilateral ขา, DTR 3+ with sustained ankle clonus (4-5 beats)","Neuro":"Alert, oriented, no focal deficit, visual blurring reported"}',

  '{"CBC":{"value":"WBC 10,200, Hb 11.5, Plt 88,000","isAbnormal":true},"LFT":{"value":"AST 185, ALT 165, LDH 650, Albumin 2.5","isAbnormal":true},"Renal":{"value":"BUN 22, Cr 1.3, Uric acid 8.5","isAbnormal":true},"Urine protein":{"value":"Protein/Creatinine ratio 5.2 (>0.3 = significant)","isAbnormal":true},"Coagulation":{"value":"PT 12s, aPTT 30s, Fibrinogen 180 (low normal)","isAbnormal":false},"Peripheral smear":{"value":"Schistocytes present, fragmented RBCs","isAbnormal":true},"NST":{"value":"Reactive, no decelerations","isAbnormal":false},"US Obstetric":{"value":"Singleton, cephalic, EFW 1,950 g (<10th percentile), AFI 6 cm (low normal), UA Doppler: increased resistance (S/D ratio 4.5)","isAbnormal":true}}',

  'Severe Preeclampsia with features of HELLP syndrome, superimposed on Chronic Hypertension',
  '["Severe Preeclampsia","HELLP syndrome","Eclampsia (impending)","Chronic hypertension exacerbation","Thrombotic thrombocytopenic purpura (TTP)","Acute fatty liver of pregnancy"]',
  'MgSO4 loading 4-6 g IV over 20 min แล้ว maintenance 1-2 g/hr (seizure prophylaxis); IV Labetalol 20 mg หรือ IV Hydralazine 5 mg สำหรับ acute BP control เป้าหมาย <160/110; Betamethasone 12 mg IM x 2 doses ห่าง 24 ชม. (fetal lung maturity); Monitor: Mg level, urine output, DTR ทุก 1-2 ชม.; CBC + LFT ทุก 6-12 ชม.; วางแผน delivery ภายใน 24-48 ชม. หลังให้ steroid (ถ้า stable); ถ้า deterioration (eclampsia, DIC, abruption, fetal distress) → emergency C/S ทันที; เตรียม NICU สำหรับทารก preterm; ห้ามใช้ NSAIDs, ACEi, ARB ในหญิงตั้งครรภ์',

  '["Preeclampsia = new-onset HT + proteinuria หลัง 20 wk; Superimposed preeclampsia = preeclampsia บน chronic HT","HELLP = Hemolysis + Elevated Liver enzymes + Low Platelets — อาจเกิดโดยไม่มี severe HT","Severe features: BP ≥160/110, Plt <100K, liver transaminases 2x, Cr >1.1, pulmonary edema, visual/cerebral symptoms","MgSO4 เป็น first-line seizure prophylaxis ไม่ใช่ antihypertensive — monitor toxicity: loss of DTR → respiratory depression → cardiac arrest","Antidote MgSO4 toxicity = Calcium gluconate 1 g IV","Definitive treatment = delivery ไม่ว่า GA เท่าไร ถ้า severe + unstable","FGR (fetal growth restriction) พบบ่อยใน preeclampsia จาก placental insufficiency","Clonus = hyperreflexia = increased risk of eclamptic seizure"]',

  '[{"question":"ผู้ป่วยรายนี้มี severe features อะไรบ้าง","modelAnswer":"1) BP 175/115 (≥160/110) 2) ปวดศีรษะรุนแรง + ตาพร่ามัว (cerebral/visual symptoms) 3) จุกแน่นลิ้นปี่ (RUQ/epigastric pain) 4) Plt 88,000 (<100K) 5) AST/ALT สูง >2x 6) Cr 1.3 (>1.1) 7) Pulmonary edema (crepitation) 8) Clonus — มีหลาย severe features มาก","points":20},{"question":"ทำไมต้องให้ MgSO4 และ monitor อะไร","modelAnswer":"MgSO4 เป็น first-line สำหรับ seizure prophylaxis ใน severe preeclampsia ลด risk eclampsia ได้ 58% (Magpie trial) Monitor: 1) DTR ทุก 1-2 ชม. (ถ้าหายไป = toxic) 2) RR >12/min 3) Urine output ≥25 mL/hr (Mg excrete ทางไต) 4) Therapeutic level 4-7 mEq/L Toxic signs: loss DTR (>7), respiratory depression (>10), cardiac arrest (>12) Antidote: Calcium gluconate 1 g IV","points":20},{"question":"HELLP syndrome criteria ครบไหมในผู้ป่วยรายนี้ อธิบาย","modelAnswer":"Hemolysis: LDH 650 (>600) + schistocytes บน peripheral smear = มี Elevated Liver enzymes: AST 185, ALT 165 (>2x upper normal) = มี Low Platelets: 88,000 (<100K) = มี ครบ 3 criteria ของ HELLP syndrome ถือว่าเป็น complete HELLP","points":20},{"question":"ถ้า GA 28 สัปดาห์ แทนที่จะเป็น 34 สัปดาห์ การ management จะต่างกันไหม","modelAnswer":"หลักการเหมือนกัน: MgSO4 + BP control + steroid แต่ถ้า 28 wk + stable อาจ expectant management (admit + close monitoring) เพื่อยืดอายุครรภ์ แต่ถ้า unstable (uncontrolled BP, eclampsia, DIC, HELLP worsening, fetal distress) ต้อง deliver ทันทีไม่ว่า GA เท่าไร เพราะ definitive treatment = delivery GA ≥34 wk = recommend delivery, <34 wk = อาจ expectant ถ้า stable","points":15}]',

  '{"history":20,"pe":25,"lab":25,"ddx":10,"management":20}'
);
