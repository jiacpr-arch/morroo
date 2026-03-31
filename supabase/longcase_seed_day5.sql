-- ============================================
-- Long Case #8: Severe Asthma Exacerbation
-- Day 5/7
-- ============================================

INSERT INTO public.long_cases (
  title, specialty, difficulty, week_number, is_weekly,
  patient_info, history_script, pe_findings, lab_results,
  correct_diagnosis, accepted_ddx, management_plan, teaching_points,
  examiner_questions, scoring_rubric
) VALUES (
  'หญิง 35 ปี หอบเหนื่อย พูดไม่เป็นประโยค',
  'Pulmonology',
  'medium',
  8,
  TRUE,
  '{"name":"นางสาวพิมพ์ลภัส อรุณรัตน์","age":35,"gender":"หญิง","underlying":["Asthma (poorly controlled)","Allergic rhinitis"],"allergies":["Aspirin (เคย bronchospasm)"],"vitals":{"bp":"140/90","hr":128,"rr":36,"temp":37.0,"o2sat":88}}',

  '{"cc":"หอบเหนื่อยมาก 6 ชั่วโมง ไม่ดีขึ้น","onset":"เริ่มแน่นหน้าอก หายใจลำบากตั้งแต่เช้า พ่น Salbutamol MDI แล้วหลายครั้งไม่ดีขึ้น","pi":"มีอาการหอบหืดบ่อยขึ้น 2 สัปดาห์ที่ผ่านมา ใช้ Salbutamol MDI วันละ 4-5 ครั้ง หยุด ICS (Fluticasone) เอง 1 เดือนก่อนเพราะคิดว่าดีขึ้นแล้ว วันนี้ตื่นมาแน่นหน้าอก หอบมากขึ้นเรื่อยๆ พ่น Salbutamol >10 puffs ไม่ดีขึ้น พูดได้ทีละคำ นอนราบไม่ได้ trigger: สัมผัสแมวของเพื่อนเมื่อวาน + หยุด ICS","pmh":"Asthma ตั้งแต่อายุ 10 ปี admit ICU intubation 1 ครั้ง เมื่อ 5 ปีก่อน Allergic rhinitis","sh":"ไม่สูบบุหรี่ ทำงานออฟฟิศ เลี้ยงแมว (ที่บ้านเพื่อน)"}',

  '{"GA":"หญิงวัยกลางคน นั่งยกไหล่หายใจ ใช้ accessory muscles พูดได้ทีละคำ เหงื่อแตก agitated","Lung":"Bilateral diffuse expiratory wheezing, prolonged expiration, decreased air entry bilateral lower zones, no silent chest","Heart":"Tachycardia regular, no murmur, pulsus paradoxus 18 mmHg","Neck":"Trachea midline, no JVP elevation, SCM contraction visible","Extremities":"No cyanosis, no clubbing"}',

  '{"ABG":{"value":"pH 7.38, PaO2 62, PaCO2 42, HCO3 24","isAbnormal":true},"Peak Flow":{"value":"120 L/min (predicted 420 = 29% predicted)","isAbnormal":true},"CBC":{"value":"WBC 12,500 (Eosinophil 8%), Hb 14.0, Plt 310,000","isAbnormal":true},"CXR":{"value":"Hyperinflation bilateral, no pneumothorax, no infiltrate","isAbnormal":true},"BMP":{"value":"Na 140, K 3.5, Cl 102, Cr 0.8, Glucose 145","isAbnormal":false}}',

  'Severe Acute Asthma Exacerbation (Near-fatal asthma)',
  '["Severe Asthma Exacerbation","Acute exacerbation of COPD","Pneumothorax","Foreign body aspiration","Anaphylaxis","Vocal cord dysfunction"]',
  'O2 high flow target SpO2 93-95%; Continuous nebulized Salbutamol 5 mg + Ipratropium 0.5 mg ทุก 20 นาที x 3 doses; IV Hydrocortisone 200 mg stat แล้ว 100 mg q6h (หรือ IV Methylprednisolone 40-80 mg); IV MgSO4 2 g over 20 min; ถ้าไม่ดีขึ้น: IV Salbutamol infusion หรือ IV Aminophylline; เตรียม intubation ถ้า deterioration (silent chest, cyanosis, exhaustion, PaCO2 rising); Admit ICU; ห้ามให้ Aspirin/NSAIDs (allergy)',

  '["PaCO2 ปกติ (42) ใน severe asthma = ominous sign เพราะควรจะต่ำจาก hyperventilation → บ่งชี้ respiratory fatigue","Pulsus paradoxus >12 mmHg = severe airflow obstruction","Peak flow <25% predicted = life-threatening asthma","Near-fatal asthma criteria: previous ICU/intubation, recent hospital admission, ≥3 ED visits/year, heavy SABA use","ICS withdrawal = common precipitant ผู้ป่วยมักหยุดเมื่อรู้สึกดี","Silent chest = extreme airflow obstruction ไม่ใช่หมายความว่าดีขึ้น","IV MgSO4 = bronchodilator ใน severe asthma ที่ไม่ตอบสนองต่อ initial treatment"]',

  '[{"question":"ทำไม PaCO2 ปกติ (42) ในผู้ป่วย severe asthma ถึงน่ากังวล","modelAnswer":"ใน asthma exacerbation ปกติ ผู้ป่วยจะ hyperventilate ทำให้ PaCO2 ต่ำ (respiratory alkalosis) ถ้า PaCO2 ปกติหรือสูง แสดงว่าผู้ป่วยเริ่ม respiratory muscle fatigue ไม่สามารถ compensate ได้ เป็น sign ของ impending respiratory failure อาจต้อง intubation","points":20},{"question":"เมื่อไรควร intubate ผู้ป่วย severe asthma","modelAnswer":"Indications: altered consciousness/exhaustion, silent chest, cyanosis despite O2, PaCO2 rising หรือ >45, respiratory acidosis, SpO2 <92% despite treatment, cardiac arrest ควรเป็น clinical decision ไม่ใช่รอ ABG อย่างเดียว ใช้ ketamine เป็น induction agent (bronchodilator property)","points":20},{"question":"อธิบาย stepwise management ของ acute severe asthma ใน ER","modelAnswer":"Step 1: O2 + continuous SABA nebulization (Salbutamol q20min) + Ipratropium Step 2: Systemic corticosteroid IV (Hydrocortisone/Methylprednisolone) Step 3: IV MgSO4 2g over 20 min Step 4: IV Salbutamol infusion หรือ IV Aminophylline Step 5: Consider intubation + ICU ประเมินซ้ำทุก 15-30 นาที","points":15},{"question":"ผู้ป่วยรายนี้มี risk factors อะไรบ้างที่บ่งบอกว่าเป็น near-fatal asthma","modelAnswer":"1) Previous ICU admission + intubation 2) หยุด ICS เอง (poor compliance) 3) Overuse SABA (>10 puffs/day) 4) Aspirin-exacerbated respiratory disease (AERD) 5) PaCO2 ปกติ + severe obstruction ทั้งหมดนี้เป็น risk factors ของ near-fatal/fatal asthma","points":15}]',

  '{"history":25,"pe":20,"lab":20,"ddx":15,"management":20}'
);
