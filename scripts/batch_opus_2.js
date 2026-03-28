const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: '.env.local' });
const supabase = createClient(process.env.NEXT_PUBLIC_SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY);

const explanations = [
{
  id: "01b7ac85-2e9d-4795-b8ce-97f164bd4c07",
  detailed_explanation: {
    summary: "คำตอบที่ถูกต้อง: C. Hyperventilation syndrome (กลุ่มอาการหายใจเร็วเกินไป)",
    reason: "ผู้ป่วยหญิงอายุ 18 ปี มีอาการหายใจเร็วลึก (rapid, deep breathing) และมือเกร็ง (clenched hands) เป็นเวลา 2 ชั่วโมง หลังจากถูกตะโกนใส่ ซึ่งเป็นสถานการณ์ที่กระตุ้นความเครียดทางอารมณ์\n\nอาการทั้งหมดเข้าได้กับ hyperventilation syndrome อย่างชัดเจน กลไกที่เกิดขึ้นคือ ความเครียดทางอารมณ์กระตุ้นให้หายใจเร็วและลึกเกินไป ทำให้เกิดการขับ CO2 ออกจากร่างกายมากเกินไป (hypocapnia) ส่งผลให้เกิด respiratory alkalosis เมื่อ pH ในเลือดสูงขึ้น จะทำให้ ionized calcium ลดลง (เพราะ calcium จับกับ albumin มากขึ้นในสภาวะด่าง) ส่งผลให้เกิดอาการ tetany ซึ่งแสดงออกเป็น carpopedal spasm (มือเกร็งงอเป็นท่า accoucheur's hand หรือ clenched hands)\n\nนอกจากนี้ผู้ป่วยอาจมีอาการชาปลายมือปลายเท้า (paresthesia) เวียนศีรษะ แน่นหน้าอก ใจสั่น เนื่องจาก alkalosis ส่งผลต่อระบบประสาทและหัวใจ การวินิจฉัยทำได้จากประวัติและอาการทางคลินิกเป็นหลัก โดยตรวจ ABG จะพบ pH สูง, pCO2 ต่ำ, HCO3 ปกติหรือต่ำเล็กน้อย (acute respiratory alkalosis)",
    choices: [
      {label: "A", text: "Conversion disorder", is_correct: false, explanation: "ไม่ถูกต้อง: Conversion disorder (Functional neurological symptom disorder) เป็นความผิดปกติที่ผู้ป่วยมีอาการทางระบบประสาท เช่น อัมพาต ตาบอด ชัก โดยไม่พบสาเหตุทางกายภาพ อาการของผู้ป่วยรายนี้ (หายใจเร็ว มือเกร็ง) มีกลไกทาง pathophysiology อธิบายได้ชัดเจน (respiratory alkalosis → hypocalcemia → tetany) จึงไม่ใช่ conversion disorder"},
      {label: "B", text: "Acute stress disorder", is_correct: false, explanation: "ไม่ถูกต้อง: Acute stress disorder เกิดหลังเหตุการณ์ traumatic รุนแรง (เช่น อุบัติเหตุ ภัยพิบัติ ความรุนแรง) มีอาการ intrusion, dissociation, avoidance และ arousal เป็นเวลา 3 วันถึง 1 เดือน การถูกตะโกนใส่ไม่จัดเป็น traumatic event ที่รุนแรงพอ และอาการหลักของผู้ป่วยคือ hyperventilation ไม่ใช่ PTSD-like symptoms"},
      {label: "C", text: "Hyperventilation syndrome", is_correct: true, explanation: "ถูกต้อง: อาการครบถ้วน — หายใจเร็วลึก (hyperventilation) หลังถูกกระตุ้นทางอารมณ์ ร่วมกับมือเกร็ง (carpopedal spasm จาก respiratory alkalosis → ionized calcium ต่ำ → tetany) เป็นอาการคลาสสิกของ hyperventilation syndrome กลไกคือ hypocapnia → respiratory alkalosis → increased protein binding of calcium → decreased ionized calcium → neuromuscular excitability"},
      {label: "D", text: "Generalized anxiety disorder", is_correct: false, explanation: "ไม่ถูกต้อง: GAD มีลักษณะเป็นความกังวลมากเกินไปเรื้อรัง (> 6 เดือน) เกี่ยวกับหลายเรื่อง ร่วมกับอาการทางกาย เช่น ตึงกล้ามเนื้อ นอนไม่หลับ ผู้ป่วยรายนี้มีอาการเฉียบพลัน 2 ชั่วโมง ไม่ใช่อาการเรื้อรัง และอาการหลักคือ hyperventilation with tetany ไม่ใช่ chronic worry"},
      {label: "E", text: "Panic disorder", is_correct: false, explanation: "ไม่ถูกต้อง: Panic disorder มี recurrent unexpected panic attacks (อาการกลัวรุนแรงเฉียบพลันที่เกิดขึ้นโดยไม่มี trigger ชัดเจน) ผู้ป่วยรายนี้มี trigger ชัดเจน (ถูกตะโกนใส่) และอาการหลักคือ hyperventilation with carpopedal spasm ซึ่งเป็น physiological response ไม่ใช่ panic attack แม้ panic attack อาจมี hyperventilation ร่วมด้วย แต่ลักษณะ clenched hands จาก tetany ชี้ไปทาง hyperventilation syndrome โดยตรง"}
    ],
    key_takeaway: "Hyperventilation syndrome: หายใจเร็ว → CO2 ต่ำ → respiratory alkalosis → ionized Ca ต่ำ → carpopedal spasm (มือเกร็ง) เป็น classic presentation ที่ต้องจำ จุดสำคัญคือมี trigger ทางอารมณ์ชัดเจน และอาการ tetany อธิบายได้ด้วย pathophysiology"
  }
},
{
  id: "01d2d8e2-229f-4f66-b570-afd3ac89cbd5",
  detailed_explanation: {
    summary: "คำตอบที่ถูกต้อง: A. Calcium gluconate IV (แคลเซียมกลูโคเนตทางหลอดเลือดดำ)",
    reason: "ผู้ป่วยชายอายุ 65 ปี เบาหวาน ความดันสูง มาด้วยอาการเหนื่อย หัวใจเต้นผิดจังหวะ Lab พบ K สูง (hyperkalemia) ซึ่งเป็นภาวะฉุกเฉินที่อันตรายถึงชีวิต\n\nHyperkalemia ที่มี cardiac manifestation (หัวใจเต้นผิดจังหวะ) ถือเป็นภาวะฉุกเฉินทางอายุรศาสตร์ เพราะ K+ สูงจะทำให้ resting membrane potential ของ cardiac myocyte เปลี่ยนแปลง ลด excitability และ conduction ส่งผลให้เกิด arrhythmia ที่อันตรายได้ตั้งแต่ peaked T wave, widened QRS, sine wave pattern จนถึง ventricular fibrillation และ asystole\n\nการรักษา hyperkalemia แบ่งเป็น 3 ขั้นตอนตามลำดับความเร่งด่วน:\n1. **Cardiac membrane stabilization** — Calcium gluconate IV เป็นยาที่ต้องให้เป็นอันดับแรก เพราะออกฤทธิ์ภายใน 1-3 นาที โดย antagonize ผลของ K+ ต่อ cardiac membrane ลดความเสี่ยง fatal arrhythmia ทันที (แต่ไม่ลดระดับ K+ ในเลือด)\n2. **Shift K+ into cells** — Insulin + Dextrose, NaHCO3, beta-2 agonist\n3. **Remove K+ from body** — Kayexalate, Furosemide, Dialysis\n\nเนื่องจากผู้ป่วยมี cardiac arrhythmia แล้ว สิ่งแรกที่ต้องทำคือ stabilize หัวใจด้วย Calcium gluconate IV ก่อนจะรักษาอื่นๆ",
    choices: [
      {label: "A", text: "Calcium gluconate IV", is_correct: true, explanation: "ถูกต้อง: เป็นการรักษาอันดับแรกใน hyperkalemia ที่มี cardiac involvement เพราะ calcium จะ antagonize ผลของ K+ ต่อ cardiac membrane potential ออกฤทธิ์ภายใน 1-3 นาที ป้องกัน fatal arrhythmia ได้ทันที สำคัญคือ calcium ไม่ได้ลดระดับ K+ แต่ซื้อเวลาให้ทำ definitive treatment ต่อ ขนาดที่ใช้คือ 10% Calcium gluconate 10 mL IV ให้ช้าๆ ใน 2-3 นาที"},
      {label: "B", text: "Insulin + Dextrose", is_correct: false, explanation: "ไม่ถูกต้องเป็นคำตอบแรก: แม้ Insulin + Dextrose เป็นการรักษาที่สำคัญมาก (ลดระดับ K+ ได้จริงโดย shift K+ เข้า cells ภายใน 15-30 นาที) แต่เป็นขั้นตอนที่ 2 หลังจาก stabilize หัวใจแล้ว ในผู้ป่วยที่มี arrhythmia ต้องให้ Calcium gluconate ก่อนเพื่อป้องกัน cardiac arrest"},
      {label: "C", text: "Sodium bicarbonate", is_correct: false, explanation: "ไม่ถูกต้อง: NaHCO3 ช่วย shift K+ เข้า cells ได้ในผู้ป่วยที่มี metabolic acidosis ร่วม แต่ประสิทธิภาพน้อยกว่า Insulin + Dextrose และไม่ใช่ first-line treatment ที่ต้องทำก่อน cardiac stabilization นอกจากนี้ต้องระวังในผู้ป่วย renal failure เพราะอาจเกิด volume overload"},
      {label: "D", text: "Furosemide", is_correct: false, explanation: "ไม่ถูกต้อง: Furosemide ช่วยขับ K+ ออกทางไต แต่ออกฤทธิ์ช้า (30-60 นาที) และอาจไม่ได้ผลดีในผู้ป่วย renal impairment เป็นการรักษาในขั้นตอน K+ removal ไม่ใช่ immediate cardiac stabilization ในผู้ป่วยที่มี arrhythmia ต้องให้ Calcium gluconate ก่อน"},
      {label: "E", text: "Sodium polystyrene sulfonate", is_correct: false, explanation: "ไม่ถูกต้อง: Kayexalate (Sodium polystyrene sulfonate) เป็น cation exchange resin ที่จับ K+ ในทางเดินอาหาร ออกฤทธิ์ช้ามาก (4-6 ชั่วโมง) ไม่เหมาะสำหรับ acute management โดยเฉพาะเมื่อมี cardiac arrhythmia ใช้เป็น adjunct therapy ในระยะยาวเท่านั้น"}
    ],
    key_takeaway: "Hyperkalemia + cardiac arrhythmia → ให้ Calcium gluconate IV เป็นอันดับแรกเสมอ เพื่อ stabilize cardiac membrane (ออกฤทธิ์ใน 1-3 นาที) จากนั้นค่อย shift K+ ด้วย Insulin+Dextrose แล้วค่อย remove K+ ออกจากร่างกาย จำลำดับ: Stabilize → Shift → Remove"
  }
},
{
  id: "02293390-12a9-4ede-b47d-cfe188bfc61f",
  detailed_explanation: {
    summary: "คำตอบที่ถูกต้อง: A. Acute hemolytic anemia (ภาวะโลหิตจางจากเม็ดเลือดแดงแตกเฉียบพลัน)",
    reason: "เด็กชายอายุ 18 ปี มาด้วยไข้ 5 วัน อ่อนเพลีย 3 วัน ตรวจร่างกายพบ pallor (ซีด), mild jaundice (ตัวเหลืองเล็กน้อย) และ spleen just palpable (ม้ามโตเล็กน้อย) อาการทั้ง 3 นี้เป็น triad ของ hemolytic anemia\n\nกลไก: เมื่อเม็ดเลือดแดงแตก (hemolysis) จะเกิดสิ่งต่อไปนี้:\n- **Pallor** — จำนวนเม็ดเลือดแดงลดลงทำให้ซีด (anemia)\n- **Jaundice** — Hemoglobin ที่ปล่อยออกมาจะถูก metabolize เป็น unconjugated bilirubin ที่เพิ่มขึ้นจนเกิดตัวเหลือง (indirect hyperbilirubinemia)\n- **Splenomegaly** — ม้ามทำงานหนักขึ้นในการกำจัดเม็ดเลือดแดงที่ผิดปกติ (extravascular hemolysis) ทำให้ม้ามโต\n\nการมีไข้ร่วมด้วยบ่งชี้ว่ามี trigger จากการติดเชื้อ ซึ่งเป็นสาเหตุที่พบบ่อยของ acute hemolytic crisis โดยเฉพาะในผู้ป่วยที่มี underlying condition เช่น G6PD deficiency, hereditary spherocytosis หรือ autoimmune hemolytic anemia Lab ที่สนับสนุน hemolysis ได้แก่ reticulocyte count สูง, LDH สูง, haptoglobin ต่ำ, direct/indirect Coombs test",
    choices: [
      {label: "A", text: "Acute hemolytic anemia", is_correct: true, explanation: "ถูกต้อง: Triad ของ hemolytic anemia ครบ — pallor (anemia) + jaundice (unconjugated hyperbilirubinemia จาก Hb breakdown) + splenomegaly (extravascular hemolysis) ร่วมกับมีไข้เป็น trigger อาการเฉียบพลัน (5 วัน) เข้ากับ acute hemolysis เช่น infection-triggered hemolytic crisis ใน G6PD deficiency หรือ autoimmune hemolytic anemia"},
      {label: "B", text: "Acute leukemia", is_correct: false, explanation: "ไม่ถูกต้อง: Acute leukemia อาจทำให้ซีด ไข้ และม้ามโตได้ แต่มักมี hepatosplenomegaly ที่ชัดเจนกว่า ร่วมกับ lymphadenopathy, petechiae/purpura จาก thrombocytopenia และ bone pain จุดสำคัญคือ leukemia ไม่ทำให้เกิด jaundice จาก hemolysis โดยตรง ถ้าจะมี jaundice มักจะจาก liver infiltration ซึ่งเป็น conjugated hyperbilirubinemia"},
      {label: "C", text: "Aplastic anemia", is_correct: false, explanation: "ไม่ถูกต้อง: Aplastic anemia เกิดจาก bone marrow failure ทำให้ pancytopenia (ซีด + เลือดออกง่ายจาก thrombocytopenia + ติดเชื้อง่ายจาก leukopenia) แต่ม้ามมักไม่โต และไม่มี jaundice เพราะไม่มี hemolysis ม้ามอาจเล็กลงด้วยซ้ำ"},
      {label: "D", text: "Iron deficiency anemia", is_correct: false, explanation: "ไม่ถูกต้อง: IDA เป็นโลหิตจางเรื้อรัง มีอาการค่อยๆ ซีด อ่อนเพลีย อาจมี koilonychia, angular stomatitis ไม่ทำให้เกิดไข้ ตัวเหลือง หรือม้ามโต เพราะไม่มี hemolysis ลักษณะเม็ดเลือดแดงเป็น microcytic hypochromic"},
      {label: "E", text: "Infectious mononucleosis", is_correct: false, explanation: "ไม่ถูกต้อง: Infectious mononucleosis (EBV infection) ทำให้ไข้ เจ็บคอ lymphadenopathy และม้ามโตได้ แต่ไม่ค่อยทำให้ซีดหรือตัวเหลืองมากนัก ถ้ามี jaundice มักจาก hepatitis ไม่ใช่ hemolysis และ pallor ไม่ใช่อาการเด่นของ IM อาจมี atypical lymphocytes ใน PBS"}
    ],
    key_takeaway: "Triad ของ hemolytic anemia: Pallor + Jaundice + Splenomegaly เมื่อเห็น 3 อาการนี้ร่วมกัน ให้นึกถึง hemolysis เสมอ Jaundice เกิดจาก unconjugated bilirubin สูง ม้ามโตจาก extravascular hemolysis"
  }
},
{
  id: "024f6670-800b-4d6e-bc9d-38e95995b85f",
  detailed_explanation: {
    summary: "คำตอบที่ถูกต้อง: B. เพิ่ม statin และเพิ่ม antihypertensive เป็น combination therapy",
    reason: "ผู้ป่วยหญิงอายุ 60 ปี เป็นเบาหวาน 3 ปี ร่วมกับ hypertension และ dyslipidemia ถือเป็นผู้ป่วยที่มี cardiovascular risk สูงมาก ต้องควบคุมปัจจัยเสี่ยงทุกตัวอย่างเข้มงวด\n\nวิเคราะห์ปัญหาทีละตัว:\n1. **Diabetes**: FBS 140-160, HbA1C 7.8% → ยังไม่ถึงเป้า (เป้า HbA1C < 7%) ต้องปรับยา แต่ไม่ใช่ปัญหาเร่งด่วนที่สุด\n2. **Hypertension**: BP 140/90 → สูงกว่าเป้าสำหรับผู้ป่วยเบาหวาน (เป้า < 130/80 ตาม guideline) ต้องเพิ่มยา\n3. **Dyslipidemia**: ยังไม่ได้รับ statin → ผู้ป่วยเบาหวานอายุ > 40 ปีที่มี CV risk factors ต้องได้ statin ตาม guideline\n\nตาม JNC8 และ ACC/AHA guidelines ผู้ป่วยเบาหวานที่ BP > 130/80 ควรเริ่ม combination antihypertensive therapy โดยยาที่เหมาะสมคือ ACE-I หรือ ARB (มี renoprotective effect) ร่วมกับ CCB หรือ thiazide ส่วน statin ต้องเริ่มในผู้ป่วยเบาหวานที่มี CV risk factors ตาม ADA guidelines",
    choices: [
      {label: "A", text: "เพิ่ม antihypertensive เป็น 2 ชนิด และปรับ antidiabetic", is_correct: false, explanation: "ไม่ถูกต้อง: แม้แนวคิดถูกที่ต้องเพิ่มยาลดความดัน แต่ขาด statin ซึ่งเป็นสิ่งจำเป็นสำหรับผู้ป่วยเบาหวานที่มี dyslipidemia และ CV risk สูง การไม่ให้ statin ถือว่าพลาด evidence-based management ที่สำคัญ"},
      {label: "B", text: "เพิ่ม statin และเพิ่ม antihypertensive เป็น combination therapy", is_correct: true, explanation: "ถูกต้อง: ครอบคลุมการรักษาครบทุกปัจจัยเสี่ยง — statin สำหรับ dyslipidemia และ CV risk reduction ร่วมกับ combination antihypertensive (ACE-I/ARB + CCB หรือ thiazide) สำหรับควบคุม BP ให้ถึงเป้า < 130/80 ในผู้ป่วยเบาหวาน เป็นแนวทางที่สอดคล้องกับ ADA และ ACC/AHA guidelines"},
      {label: "C", text: "ใช้ metoprolol เพียงชนิดเดียว", is_correct: false, explanation: "ไม่ถูกต้อง: Beta-blocker ไม่ใช่ first-line antihypertensive ในผู้ป่วยเบาหวาน เพราะ mask hypoglycemia symptoms และอาจ worsen insulin resistance นอกจากนี้ BP 140/90 ในผู้ป่วย DM มักต้อง combination therapy ไม่ใช่ยาตัวเดียว และยังขาด statin"},
      {label: "D", text: "เพิ่ม sulfonylurea และหยุด antihypertensive", is_correct: false, explanation: "ไม่ถูกต้อง: การหยุดยาความดันเป็นสิ่งที่อันตรายมาก BP 140/90 สูงกว่าเป้าในผู้ป่วย DM ชัดเจน ต้องเพิ่มยาไม่ใช่หยุด การเพิ่ม sulfonylurea อาจพิจารณาได้แต่ไม่ใช่ priority แรก"},
      {label: "E", text: "ให้ ACE-I เพียงชนิดเดียว และลดน้ำหนัก", is_correct: false, explanation: "ไม่ถูกต้อง: ACE-I เป็นยาที่ดีสำหรับ DM+HT แต่ BP 140/90 มักต้อง combination therapy เพื่อถึงเป้า < 130/80 ยาตัวเดียวมักไม่เพียงพอ และยังขาด statin สำหรับ dyslipidemia การลดน้ำหนักดีแต่ไม่พอเป็นการรักษาเดียว"}
    ],
    key_takeaway: "ผู้ป่วย DM + HT + Dyslipidemia ต้องรักษาครบทุกปัจจัย: ACE-I/ARB-based combination therapy สำหรับ HT (เป้า < 130/80) + Statin สำหรับ CV risk reduction ตาม ADA guidelines"
  }
},
{
  id: "02a59e84-f5f8-419c-a618-f9bb1d7c1963",
  detailed_explanation: {
    summary: "คำตอบที่ถูกต้อง: B. Stimson technique (เทคนิคสติมสัน)",
    reason: "ข้อสอบถามถึงวิธีดันข้อไหล่หลุดกลับที่ (shoulder reduction) ที่ traumatic น้อยที่สุด (least traumatic) ซึ่งหมายถึงวิธีที่ใช้แรงน้อย อ่อนโยน และเสี่ยงต่อการบาดเจ็บเพิ่มเติมน้อยที่สุด\n\nStimson technique (หรือ Stimson's gravity method/hanging arm technique) เป็นวิธีที่ใช้แรงโน้มถ่วงช่วย โดยให้ผู้ป่วยนอนคว่ำบนเตียงสูง แขนข้างที่หลุดห้อยลงจากขอบเตียง แล้วแขวนน้ำหนัก 2-5 kg ที่ข้อมือ ปล่อยให้แรงโน้มถ่วงดึงหัวกระดูกต้นแขนลงมาช้าๆ กล้ามเนื้อรอบข้อไหล่จะค่อยๆ relax และหัวกระดูกจะเลื่อนกลับเข้าที่เองภายใน 15-30 นาที\n\nข้อดีของ Stimson technique:\n- ใช้แรงน้อยที่สุด (ใช้ gravity เป็นหลัก)\n- ไม่ต้อง leverage หรือ manipulation รุนแรง\n- ความเสี่ยงต่อ iatrogenic fracture หรือ neurovascular injury น้อยมาก\n- ผู้ป่วยเจ็บน้อย อาจไม่ต้อง sedation",
    choices: [
      {label: "A", text: "Milch technique", is_correct: false, explanation: "ไม่ถูกต้อง: Milch technique ใช้การ abduct แขนผู้ป่วยขึ้นเหนือศีรษะช้าๆ แล้ว external rotate เพื่อให้หัวกระดูกเลื่อนกลับ แม้เป็นวิธีที่อ่อนโยนพอสมควร แต่ต้องใช้การ manipulation มากกว่า Stimson และต้องอาศัย operator skill สูงกว่า"},
      {label: "B", text: "Stimson technique", is_correct: true, explanation: "ถูกต้อง: เป็นวิธีที่ least traumatic ที่สุด ใช้แรงโน้มถ่วงดึงหัวกระดูกกลับเข้าที่ ไม่ต้อง forceful manipulation ผู้ป่วยนอนคว่ำ แขนห้อยลง แขวนน้ำหนัก 2-5 kg รอ 15-30 นาที ข้อเสียคือใช้เวลานานและ success rate อาจต่ำกว่าวิธีอื่น แต่ปลอดภัยที่สุด"},
      {label: "C", text: "Hippocrate technique", is_correct: false, explanation: "ไม่ถูกต้อง: Hippocratic method ใช้ส้นเท้าของแพทย์ดันที่ axilla ของผู้ป่วยแล้วดึงแขน (traction-countertraction) เป็นวิธีที่ใช้แรงมาก มีความเสี่ยงต่อ axillary nerve injury และ humeral fracture สูง ถือเป็นวิธีที่ traumatic มากกว่า Stimson อย่างชัดเจน"},
      {label: "D", text: "Kocher technique", is_correct: false, explanation: "ไม่ถูกต้อง: Kocher technique ใช้ leverage โดย external rotation → adduction → internal rotation เป็น multi-step manipulation ที่ใช้ torque มาก มีความเสี่ยงสูงต่อ spiral fracture ของ humerus โดยเฉพาะในผู้สูงอายุที่กระดูกเปราะ ถือเป็นวิธีที่ traumatic ที่สุดในตัวเลือกทั้งหมด"},
      {label: "E", text: "External rotation technique", is_correct: false, explanation: "ไม่ถูกต้อง: External rotation method ใช้การหมุนแขนออกช้าๆ ในท่า adduction แม้อ่อนโยนกว่า Kocher แต่ยังต้องใช้ manual manipulation มากกว่า Stimson ที่ใช้แค่ gravity อย่างไรก็ตามเป็นวิธีที่ค่อนข้างปลอดภัยและนิยมใช้ใน ER"}
    ],
    key_takeaway: "Stimson technique (gravity method) เป็นวิธี shoulder reduction ที่ least traumatic ที่สุด ใช้แรงโน้มถ่วงช่วย ไม่ต้อง forceful manipulation ส่วน Kocher technique เป็นวิธีที่ traumatic ที่สุดเพราะใช้ leverage มาก เสี่ยง fracture"
  }
}
];

(async () => {
  for (const item of explanations) {
    const { error } = await supabase.from('mcq_questions')
      .update({ detailed_explanation: item.detailed_explanation })
      .eq('id', item.id);
    if (error) console.log('ERROR:', item.id, error.message);
    else console.log('OK:', item.id);
  }
  console.log('Done! Updated', explanations.length, 'questions');
})();
