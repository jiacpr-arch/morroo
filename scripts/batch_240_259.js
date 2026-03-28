const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: '.env.local' });
const supabase = createClient(process.env.NEXT_PUBLIC_SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY);

const explanations = [
  {
    id: "3937a22b-2141-4392-906c-1ea7d671609c",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. serum morning cortisol (ระดับคอร์ติซอลในเลือดตอนเช้า)",
      reason: "ผู้ป่วยหญิงมาด้วยอาการ weight gain, irregular menstruation, back pain ร่วมกับ moon face, buffalo hump, hypertension และ proximal muscle weakness ซึ่งเป็นอาการและอาการแสดงที่ classic ของ Cushing's syndrome อย่างไรก็ตาม ผู้ป่วยรายนี้มีประวัติการกินยาแก้ปวดหลังเป็นประจำ ซึ่งยาแก้ปวดหลังที่ใช้บ่อยในประเทศไทยมักมีส่วนผสมของ steroid (prednisolone, dexamethasone) ปะปนอยู่ ดังนั้นสาเหตุที่น่าจะเป็นไปได้มากที่สุดคือ exogenous Cushing's syndrome จากการได้รับ steroid จากภายนอก\n\nเมื่อผู้ป่วยหยุดยามา 1 สัปดาห์ สิ่งที่ต้องกังวลคือภาวะ adrenal insufficiency จากการที่ HPA axis ถูกกด การตรวจ serum morning cortisol เป็นการตรวจที่เหมาะสมที่สุด เพราะจะช่วยประเมินว่าต่อมหมวกไตยังสามารถสร้าง cortisol ได้เพียงพอหรือไม่หลังจากหยุดยา steroid ค่า morning cortisol ที่ต่ำกว่า 3 mcg/dL บ่งชี้ adrenal insufficiency ชัดเจน ในขณะที่ค่ามากกว่า 18 mcg/dL บ่งชี้ว่า HPA axis ทำงานปกติ\n\nนอกจากนี้ การตรวจ morning cortisol ยังช่วยแยกระหว่าง exogenous Cushing's syndrome (cortisol จะต่ำเพราะถูกกด) กับ endogenous Cushing's syndrome (cortisol จะสูง) ซึ่งมีแนวทางการรักษาที่แตกต่างกัน",
      choices: [
        {label: "A", text: "serum morning cortisol", is_correct: true, explanation: "ถูกต้อง เป็นการตรวจที่เหมาะสมที่สุดในการประเมินการทำงานของ HPA axis หลังหยุดยา steroid ค่า morning cortisol จะช่วยบอกว่าต่อมหมวกไตยังทำงานได้ดีหรือไม่ และช่วยแยก exogenous จาก endogenous Cushing's syndrome ได้อีกด้วย"},
        {label: "B", text: "urine 24 hr cortisol", is_correct: false, explanation: "ไม่ถูกต้อง urine 24-hr free cortisol ใช้ในการ screening endogenous Cushing's syndrome แต่ในกรณีนี้ผู้ป่วยน่าจะเป็น exogenous Cushing's ค่า urine cortisol จะต่ำเพราะ HPA axis ถูกกด ทำให้ไม่ได้ข้อมูลที่ต้องการ"},
        {label: "C", text: "ACTH stimulation test", is_correct: false, explanation: "ไม่ถูกต้อง ACTH stimulation test ใช้ในการยืนยัน adrenal insufficiency แต่ไม่ใช่การตรวจแรกที่ควรทำ ควรตรวจ morning cortisol ก่อน แล้วค่อยทำ ACTH stimulation test เมื่อค่า morning cortisol อยู่ในช่วง indeterminate (3-18 mcg/dL)"},
        {label: "D", text: "low-dose dexamethasone suppression test", is_correct: false, explanation: "ไม่ถูกต้อง LDDST ใช้ screening endogenous Cushing's syndrome ไม่เหมาะกับกรณีนี้ที่สงสัย exogenous Cushing's จากการกินยา steroid"},
        {label: "E", text: "high-dose dexamethasone suppression test", is_correct: false, explanation: "ไม่ถูกต้อง HDDST ใช้แยกสาเหตุของ endogenous Cushing's syndrome (pituitary vs ectopic ACTH) ไม่เกี่ยวข้องกับกรณีที่สงสัย exogenous Cushing's syndrome"}
      ],
      key_takeaway: "ผู้ป่วยที่มีอาการ Cushing's syndrome ร่วมกับประวัติกินยาแก้ปวดเป็นประจำ ต้องนึกถึง exogenous Cushing's syndrome จาก steroid เสมอ การตรวจ serum morning cortisol เป็นขั้นตอนแรกในการประเมิน HPA axis suppression"
    }
  },
  {
    id: "39405703-a04a-4554-a07b-085d1959a389",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: B. Carbohydrate deficient transferrin (CDT) (ทรานสเฟอร์รินที่ขาดคาร์โบไฮเดรต)",
      reason: "ผู้ป่วยชายอายุ 55 ปี มี chronic alcoholic hepatitis ต้องการตรวจทั้งความรุนแรงของโรคตับและประเมินว่าเลิกดื่มสุราแล้วหรือยัง Carbohydrate deficient transferrin (CDT) เป็น biomarker ที่มีความจำเพาะสูงที่สุดในการประเมินการดื่มสุราเรื้อรัง (chronic heavy alcohol use) โดย CDT จะสูงขึ้นเมื่อดื่มแอลกอฮอล์มากกว่า 50-80 g/day เป็นเวลาอย่างน้อย 2 สัปดาห์\n\nCDT มีข้อดีเหนือกว่า markers อื่นตรงที่มี specificity สูง (ประมาณ 90-95%) ในการตรวจหาการดื่มสุราเรื้อรัง และ half-life ประมาณ 14-17 วัน ทำให้สามารถตรวจจับการกลับมาดื่มได้ภายใน 2-3 สัปดาห์ ในขณะที่ GGT มี sensitivity สูงกว่าแต่ specificity ต่ำกว่า เพราะ GGT สามารถสูงขึ้นได้จากหลายสาเหตุ เช่น โรคตับจากสาเหตุอื่น ยาบางชนิด โรคอ้วน\n\nในบริบทของการ monitor การเลิกดื่มสุรา CDT จึงเป็น marker ที่ดีที่สุด เพราะจะลดลงสู่ปกติเมื่อหยุดดื่มและกลับมาสูงขึ้นเร็วหากเริ่มดื่มอีก ทำให้แพทย์สามารถติดตามพฤติกรรมการดื่มของผู้ป่วยได้อย่างแม่นยำ",
      choices: [
        {label: "A", text: "AST/ALT ratio", is_correct: false, explanation: "ไม่ถูกต้อง AST/ALT ratio >2 บ่งชี้ alcoholic liver disease แต่ไม่สามารถบอกได้ว่าผู้ป่วยยังดื่มอยู่หรือเลิกดื่มแล้ว เพราะค่า ratio อาจคงที่แม้หยุดดื่ม ใช้ได้ดีในการวินิจฉัยสาเหตุของโรคตับมากกว่าการ monitor การเลิกดื่ม"},
        {label: "B", text: "Carbohydrate deficient transferrin (CDT)", is_correct: true, explanation: "ถูกต้อง CDT มีความจำเพาะสูงสุดในการตรวจหาการดื่มสุราเรื้อรัง (specificity 90-95%) และมี half-life 14-17 วัน ทำให้เป็น marker ที่ดีที่สุดในการ monitor การเลิกดื่มและตรวจจับการกลับมาดื่มซ้ำ"},
        {label: "C", text: "Gamma glutamyl transferase (GGT)", is_correct: false, explanation: "ไม่ถูกต้อง แม้ GGT จะมี sensitivity สูงในการตรวจหาการดื่มสุรา แต่มี specificity ต่ำ เพราะ GGT สามารถสูงขึ้นจากหลายสาเหตุ ได้แก่ โรคตับจากสาเหตุอื่น ยาบางชนิด obesity และ metabolic syndrome"},
        {label: "D", text: "Mean corpuscular volume (MCV)", is_correct: false, explanation: "ไม่ถูกต้อง MCV สูง (macrocytosis) พบได้ในผู้ดื่มสุราเรื้อรัง แต่ใช้เวลานานในการเปลี่ยนแปลง (หลายเดือน) จึงไม่เหมาะในการ monitor การเลิกดื่มระยะสั้น และมีหลายสาเหตุอื่นที่ทำให้ MCV สูง เช่น vitamin B12/folate deficiency"},
        {label: "E", text: "Bilirubin and INR", is_correct: false, explanation: "ไม่ถูกต้อง Bilirubin และ INR เป็น markers ที่บ่งชี้ความรุนแรงของโรคตับ (liver function) ไม่ใช่ marker ของการดื่มสุรา ไม่สามารถบอกได้ว่าผู้ป่วยยังดื่มอยู่หรือเลิกดื่มแล้ว"}
      ],
      key_takeaway: "CDT เป็น biomarker ที่มีความจำเพาะสูงที่สุดในการตรวจหาและติดตามการดื่มสุราเรื้อรัง เหมาะสำหรับการ monitor ว่าผู้ป่วยเลิกดื่มจริงหรือไม่ โดยมี half-life ประมาณ 2 สัปดาห์"
    }
  },
  {
    id: "39735ef8-85a4-46bb-b63e-39a62954d37f",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: C. Scotch tape technique (Cellophane tape test) (เทคนิคการตรวจด้วยเทปใส)",
      reason: "เด็กที่มีอาการตื่นตกใจและหวาดกลัว (nocturnal restlessness/irritability) เป็นอาการที่พบได้บ่อยในเด็กที่ติดเชื้อ Enterobius vermicularis (พยาธิเข็มหมุด/pinworm) เนื่องจากตัวเมียของพยาธิจะคลานออกมาวางไข่บริเวณรอบทวารหนัก (perianal area) ในเวลากลางคืน ทำให้เด็กมีอาการคันก้นรุนแรง นอนไม่หลับ กระสับกระส่าย ตื่นตกใจ และร้องไห้ในเวลากลางคืน\n\nScotch tape technique (Cellophane tape test) หรือ Graham's test เป็นวิธีมาตรฐานในการตรวจหาไข่ของ Enterobius vermicularis โดยใช้เทปใสแปะที่ผิวหนังรอบทวารหนักในตอนเช้าก่อนอาบน้ำหรือถ่ายอุจจาระ แล้วนำเทปมาตรวจดูใต้กล้องจุลทรรศน์ ไข่ของ Enterobius มีลักษณะเป็นรูปไข่ไม่สมมาตร (asymmetrical oval shape) แบน้ำด้านหนึ่ง\n\nสาเหตุที่ไม่ใช้ stool examination ธรรมดาเพราะ Enterobius วางไข่ที่ perianal skin ไม่ได้วางไข่ในอุจจาระ ทำให้การตรวจอุจจาระมีโอกาสพบไข่น้อยมาก (sensitivity ต่ำมาก ประมาณ 5-15% เท่านั้น) การทำ scotch tape technique จะให้ sensitivity สูงกว่ามาก (ประมาณ 90% เมื่อทำ 3 ครั้งติดต่อกัน)",
      choices: [
        {label: "A", text: "Stool examination for parasites", is_correct: false, explanation: "ไม่ถูกต้อง การตรวจอุจจาระหาปรสิตทั่วไปมี sensitivity ต่ำมากสำหรับ Enterobius vermicularis เนื่องจากพยาธิเข็มหมุดวางไข่ที่ perianal skin ไม่ได้วางในอุจจาระ จึงแทบไม่พบไข่ในอุจจาระ"},
        {label: "B", text: "Stool culture", is_correct: false, explanation: "ไม่ถูกต้อง Stool culture ใช้ตรวจหาเชื้อแบคทีเรียในอุจจาระ เช่น Salmonella, Shigella ไม่ใช้ตรวจหาปรสิต และไม่เกี่ยวข้องกับอาการในผู้ป่วยรายนี้"},
        {label: "C", text: "Scotch tape technique (Cellophane tape test)", is_correct: true, explanation: "ถูกต้อง เป็นวิธีมาตรฐานในการตรวจหา Enterobius vermicularis โดยใช้เทปใสแปะที่ perianal area ตอนเช้า sensitivity สูง 90% เมื่อทำ 3 ครั้งติดต่อกัน เหมาะสมที่สุดสำหรับการวินิจฉัยโรคพยาธิเข็มหมุด"},
        {label: "D", text: "Perianal swab culture", is_correct: false, explanation: "ไม่ถูกต้อง Perianal swab culture ใช้เพาะเลี้ยงเชื้อแบคทีเรีย ไม่ใช่วิธีที่ใช้ตรวจหาไข่พยาธิ การตรวจหาไข่พยาธิเข็มหมุดต้องใช้ scotch tape technique"},
        {label: "E", text: "Complete blood count", is_correct: false, explanation: "ไม่ถูกต้อง CBC อาจพบ eosinophilia ได้ในการติดเชื้อพยาธิ แต่ในกรณี Enterobius มักไม่พบ eosinophilia เนื่องจากพยาธิไม่ได้เข้าสู่เนื้อเยื่อ (tissue invasion) และ CBC ไม่สามารถให้การวินิจฉัยจำเพาะได้"}
      ],
      key_takeaway: "เด็กที่มีอาการตื่นตกใจ นอนไม่หลับ คันก้นในเวลากลางคืน ให้นึกถึง Enterobius vermicularis (pinworm) และตรวจด้วย Scotch tape technique ที่ perianal area ตอนเช้า"
    }
  },
  {
    id: "39740f3f-3b4a-4cfe-8885-48c66330f8d9",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: D. Radical left nephrectomy (การผ่าตัดไตซ้ายออกทั้งหมดแบบรากฐาน)",
      reason: "ผู้ป่วยชายอายุ 55 ปี มาด้วย abdominal distension พบก้อนขนาดใหญ่ 8x7 cm ที่ไตซ้าย ซึ่ง enhance contrast ได้ บ่งชี้ว่าน่าจะเป็น renal cell carcinoma (RCC) เนื่องจากก้อนที่ enhance contrast ในไตมีโอกาสเป็นมะเร็งสูง โดยเฉพาะก้อนขนาดใหญ่ ไตข้างขวาปกติ ไม่มีหลักฐานของการแพร่กระจาย\n\nRadical nephrectomy เป็นการรักษามาตรฐาน (gold standard) สำหรับ localized RCC ที่มีขนาดใหญ่ (>7 cm หรือ T2 ขึ้นไป) การผ่าตัดจะตัดไตทั้งหมด พร้อม Gerota's fascia, perirenal fat และ ipsilateral adrenal gland (ในบางกรณี) รวมถึง regional lymph nodes ออกด้วย\n\nสำหรับก้อนขนาด 8x7 cm (T2a) ที่ไม่มี metastasis การทำ radical nephrectomy ให้ผลการรักษาที่ดี โดย 5-year survival rate สำหรับ stage I-II อยู่ที่ 70-90% เนื่องจากไตอีกข้างปกติ ผู้ป่วยสามารถมีชีวิตได้ปกติด้วยไตเพียงข้างเดียว",
      choices: [
        {label: "A", text: "MRI left kidney", is_correct: false, explanation: "ไม่ถูกต้อง CT scan ที่ทำแล้วให้ข้อมูลเพียงพอสำหรับการวางแผนผ่าตัด MRI อาจช่วยเพิ่มเติมในบางกรณี แต่ไม่ใช่ next best step ในการ management เมื่อวินิจฉัยชัดเจนแล้ว"},
        {label: "B", text: "Renal cryoablation", is_correct: false, explanation: "ไม่ถูกต้อง Cryoablation เหมาะสำหรับก้อนขนาดเล็ก (<4 cm, T1a) ในผู้ป่วยที่มีข้อจำกัดในการผ่าตัด ก้อนขนาด 8x7 cm ใหญ่เกินไปสำหรับ cryoablation และมีโอกาสรักษาไม่หมดสูง"},
        {label: "C", text: "Partial left nephrectomy", is_correct: false, explanation: "ไม่ถูกต้อง Partial nephrectomy (nephron-sparing surgery) เหมาะสำหรับก้อนขนาด <7 cm (T1) โดยเฉพาะ <4 cm หรือในกรณีที่ต้องรักษาเนื้อไตไว้ ก้อนขนาด 8x7 cm ใหญ่เกินไปและมีความเสี่ยงต่อ positive surgical margin"},
        {label: "D", text: "Radical left nephrectomy", is_correct: true, explanation: "ถูกต้อง เป็นการรักษามาตรฐานสำหรับ localized RCC ขนาด >7 cm (T2) การผ่าตัดจะตัดไตทั้งหมดพร้อม Gerota's fascia และ perirenal fat เนื่องจากไตอีกข้างปกติ ผู้ป่วยสามารถใช้ชีวิตได้ปกติ"},
        {label: "E", text: "Fine needle aspiration biopsy", is_correct: false, explanation: "ไม่ถูกต้อง FNA biopsy ของก้อนไตที่สงสัยว่าเป็นมะเร็งไม่แนะนำเป็นขั้นตอนแรก เพราะมีความเสี่ยงต่อ tumor seeding ตามรอยเข็ม และ CT scan ที่พบ enhancing renal mass ขนาดใหญ่มี positive predictive value สำหรับ RCC สูงมาก"}
      ],
      key_takeaway: "Enhancing renal mass ขนาด >7 cm ที่ไม่มี metastasis ให้ทำ radical nephrectomy เป็นการรักษามาตรฐาน ไม่จำเป็นต้อง biopsy ก่อนผ่าตัดเมื่อ imaging ชี้ชัด"
    }
  },
  {
    id: "3986234d-cc15-4bfe-b57c-8f38ab2d75e6",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Gastric adenocarcinoma (มะเร็งกระเพาะอาหารชนิดต่อมน้ำ)",
      reason: "ผู้ป่วยชายอายุ 58 ปี มาด้วยอาการเบื่ออาหาร น้ำหนักลด และปวดท้องตรงกลางเรื้อรัง 3 เดือน ซึ่งเป็น alarm symptoms ที่บ่งชี้มะเร็งทางเดินอาหาร ผลการตรวจ double contrast upper GI series พบการเปลี่ยนแปลงที่ antrum ได้แก่ ผนังขรุขระ (irregular mucosal surface), shallow ulcer และผนังด้านข้างแข็งตึง (rigid wall)\n\nลักษณะเหล่านี้เป็น radiological features ที่ classic ของ gastric adenocarcinoma โดยเฉพาะ ผนังแข็งตึง (rigidity) บ่งชี้ว่ามี tumor infiltration เข้าไปในชั้นกล้ามเนื้อของกระเพาะอาหาร ทำให้ผนังสูญเสีย distensibility ส่วน shallow ulcer ที่มีขอบไม่เรียบ (irregular margin) และ mucosal irregularity บ่งชี้ถึง malignant ulcer\n\nGastric adenocarcinoma เป็นมะเร็งกระเพาะอาหารที่พบบ่อยที่สุด (ประมาณ 90-95% ของมะเร็งกระเพาะอาหารทั้งหมด) risk factors ได้แก่ อายุมาก (>50 ปี), เพศชาย, H. pylori infection, อาหารเค็มหมักดอง, สูบบุหรี่ การวินิจฉัยยืนยันต้องทำ endoscopy พร้อม biopsy",
      choices: [
        {label: "A", text: "Gastric adenocarcinoma", is_correct: true, explanation: "ถูกต้อง ลักษณะ radiological ที่พบ ได้แก่ mucosal irregularity, shallow ulcer และ rigid wall ที่ antrum เป็น classic features ของ gastric adenocarcinoma ร่วมกับอาการ alarm symptoms (น้ำหนักลด เบื่ออาหาร) ในผู้ป่วยอายุมากกว่า 50 ปี"},
        {label: "B", text: "Peptic ulcer disease", is_correct: false, explanation: "ไม่ถูกต้อง Benign peptic ulcer จะมีลักษณะ smooth, round/oval crater with regular margins และ radiating mucosal folds ผนังจะ pliable ไม่แข็งตึง ลักษณะ rigid wall และ irregular mucosa บ่งชี้ malignancy มากกว่า"},
        {label: "C", text: "Gastric lymphoma", is_correct: false, explanation: "ไม่ถูกต้อง Gastric lymphoma (MALT lymphoma) มักมีลักษณะ multiple shallow ulcers หรือ thickened gastric folds แต่มักไม่ทำให้ผนัง rigid เท่ามะเร็ง adenocarcinoma และพบน้อยกว่ามาก (ประมาณ 3-5% ของมะเร็งกระเพาะอาหาร)"},
        {label: "D", text: "Benign gastric ulcer with healing", is_correct: false, explanation: "ไม่ถูกต้อง Healing gastric ulcer จะมี crater ที่เล็กลง ขอบเรียบขึ้น และมี mucosal folds ที่ converge เข้าหาแผล ไม่มี rigid wall หรือ mucosal irregularity แบบที่พบในผู้ป่วยรายนี้"},
        {label: "E", text: "Hypertrophic gastritis", is_correct: false, explanation: "ไม่ถูกต้อง Hypertrophic gastritis (Menetrier's disease) มีลักษณะ enlarged, thickened gastric folds คล้าย cerebral convolutions มักพบที่ fundus และ body ไม่ใช่ antrum และไม่มี shallow ulcer หรือ rigid wall"}
      ],
      key_takeaway: "ผู้ป่วยที่มี alarm symptoms (น้ำหนักลด เบื่ออาหาร) ร่วมกับ radiological findings ของ irregular mucosa, shallow ulcer และ rigid wall ที่กระเพาะอาหาร ต้องนึกถึง gastric adenocarcinoma เป็นอันดับแรก"
    }
  },
  {
    id: "39c6e842-f92a-4075-9404-57e9e61677c7",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: B. U/S ดู endometrium หนามากกว่า 5 mm ถ้ามากกว่านั้นถึงขูด (อัลตราซาวด์ดูความหนาเยื่อบุโพรงมดลูก)",
      reason: "หญิงอายุ 51 ปี มีเลือดออกกระปริดกระปรอยจากช่องคลอด ซึ่งอยู่ในช่วงวัยใกล้หมดประจำเดือน (perimenopause) หรืออาจเป็น postmenopausal bleeding อาการเลือดออกผิดปกติในวัยนี้ต้องคิดถึง endometrial pathology เช่น endometrial hyperplasia หรือ endometrial carcinoma เสมอ\n\nแนวทางการตรวจวินิจฉัยเบื้องต้นที่เหมาะสมที่สุดคือการทำ transvaginal ultrasound (TVS) เพื่อวัดความหนาของ endometrium ถ้า endometrial thickness >5 mm ในหญิงวัยหมดประจำเดือน จะมีความเสี่ยงต่อ endometrial pathology และควรทำ endometrial biopsy หรือ dilatation and curettage (D&C) เพื่อส่งตรวจทางพยาธิวิทยาต่อไป\n\nค่า cutoff ที่ 5 mm มี negative predictive value สูงถึง 99% สำหรับ endometrial cancer กล่าวคือ ถ้า endometrial thickness ≤5 mm โอกาสเป็นมะเร็งเยื่อบุโพรงมดลูกน้อยมาก (<1%) จึงไม่จำเป็นต้องทำหัตถการรุกรานเพิ่มเติม วิธีนี้ช่วยลดการทำ invasive procedure ที่ไม่จำเป็น",
      choices: [
        {label: "A", text: "ขูดมดลูก + ตรวจปากมดลูก ส่งพยาธิ", is_correct: false, explanation: "ไม่ถูกต้อง การทำ D&C ทันทีโดยไม่ประเมินก่อนเป็นการทำหัตถการที่ invasive เกินความจำเป็น ควรทำ TVS ก่อนเพื่อดูความหนาของ endometrium ถ้า >5 mm ค่อยทำ D&C จะเป็นแนวทางที่เหมาะสมกว่า"},
        {label: "B", text: "U/S ดู endometrium หนามากกว่า 5 mm ถ้ามากกว่านั้นถึงขูด", is_correct: true, explanation: "ถูกต้อง TVS เป็น first-line investigation สำหรับ abnormal uterine bleeding ในหญิงวัยหมดประจำเดือน ค่า cutoff 5 mm มี high negative predictive value สำหรับ endometrial cancer ช่วยลดการทำ invasive procedure ที่ไม่จำเป็น"},
        {label: "C", text: "ให้ 3 นัด follow-up ทุก 3 เดือน", is_correct: false, explanation: "ไม่ถูกต้อง การ follow-up โดยไม่ตรวจเพิ่มเติมเป็นการเพิกเฉยต่อ alarm symptom (postmenopausal bleeding) อาจทำให้เสียโอกาสในการวินิจฉัยมะเร็งเยื่อบุโพรงมดลูกในระยะเริ่มต้น"},
        {label: "D", text: "ให้ Progestin", is_correct: false, explanation: "ไม่ถูกต้อง การให้ progestin โดยไม่ได้ตรวจวินิจฉัยก่อนอาจปกปิดอาการของ endometrial cancer ต้อง rule out malignancy ก่อนเสมอ โดยเฉพาะในหญิงอายุ >45 ปีที่มี abnormal uterine bleeding"},
        {label: "E", text: "ให้ combined oral contraceptive", is_correct: false, explanation: "ไม่ถูกต้อง OCP ไม่เหมาะสมในหญิงอายุ 51 ปี เนื่องจากมีความเสี่ยงต่อ thromboembolism สูง และยังไม่ได้ rule out endometrial pathology ก่อน การให้ฮอร์โมนอาจปกปิดอาการได้"}
      ],
      key_takeaway: "Postmenopausal bleeding ต้อง rule out endometrial cancer เสมอ การทำ TVS เป็น first-line investigation โดยใช้ cutoff endometrial thickness 5 mm ถ้า >5 mm ควรทำ endometrial sampling"
    }
  },
  {
    id: "39cc6915-8ab8-458f-b2e7-f5eb472d05a2",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: B. เลิกสกิน แทร็กชั่นทันทีและเปลี่ยนเป็นระบบอื่น (หลีกเลี่ยงแทร็กชั่น)",
      reason: "เด็กชายอายุ 5 ปี ที่ได้รับการรักษา fracture humerus ด้วย skin traction แล้วหลังจาก 2 วันมีอาการปวด forearm เพิ่มขึ้นอย่างมาก โดยเฉพาะเมื่อกางนิ้วมือ (passive extension of fingers) และงัดข้อศอก เป็นอาการที่บ่งชี้ถึง compartment syndrome ของ forearm ซึ่งเป็นภาวะฉุกเฉินทางออร์โธปิดิกส์\n\nCompartment syndrome เกิดจากความดันภายใน fascial compartment สูงขึ้นจนกดทับหลอดเลือดและเส้นประสาท ทำให้เกิด ischemia ของกล้ามเนื้อและเส้นประสาทภายใน compartment อาการสำคัญที่สุดคือ pain out of proportion และ pain with passive stretch ของกล้ามเนื้อใน compartment ที่ได้รับผลกระทบ ถ้าเป็น volar compartment ของ forearm จะปวดเมื่อ passive extension of fingers\n\nสาเหตุในกรณีนี้คือ skin traction อาจทำให้เกิด circumferential compression ของ forearm ทำให้ venous return ลดลงและ compartment pressure สูงขึ้น สิ่งแรกที่ต้องทำคือ เลิก traction ทันที เพื่อลด external compression และปรับเปลี่ยนวิธีการ immobilization เป็นวิธีอื่นที่ไม่กดรัด",
      choices: [
        {label: "A", text: "ยังคงต่อสกิน แทร็กชั่นต่อไปแต่เพิ่มน้ำหนักอย่างค่อยเป็นค่อยไป", is_correct: false, explanation: "ไม่ถูกต้อง การเพิ่มน้ำหนักจะทำให้ compartment syndrome แย่ลง เพราะเพิ่มแรงดึงและ compression ของเนื้อเยื่อ ต้องเลิก traction ทันทีเมื่อสงสัย compartment syndrome"},
        {label: "B", text: "เลิกสกิน แทร็กชั่นทันทีและเปลี่ยนเป็นระบบอื่น (หลีกเลี่ยงแทร็กชั่น)", is_correct: true, explanation: "ถูกต้อง เมื่อสงสัย compartment syndrome ต้อง remove ทุกสิ่งที่อาจ compress extremity ทันที รวมถึง traction, bandage, cast แล้วเปลี่ยนวิธี immobilization เป็นแบบที่ไม่กดรัด หากอาการไม่ดีขึ้นต้องพิจารณาทำ fasciotomy"},
        {label: "C", text: "ลดน้ำหนักของสกิน แทร็กชั่นลงครึ่งหนึ่ง", is_correct: false, explanation: "ไม่ถูกต้อง การลดน้ำหนักเพียงบางส่วนไม่เพียงพอเมื่อสงสัย compartment syndrome ต้อง remove traction ทั้งหมดทันที เพราะ compartment syndrome เป็นภาวะฉุกเฉินที่อาจนำไปสู่ Volkmann's ischemic contracture ถ้ารักษาล่าช้า"},
        {label: "D", text: "ทำการแลบวิทยาเคมี (blood test) เพื่อหาสาเหตุของปวด", is_correct: false, explanation: "ไม่ถูกต้อง Blood test ไม่ช่วยในการวินิจฉัย compartment syndrome ซึ่งเป็นการวินิจฉัยทางคลินิก (clinical diagnosis) เป็นหลัก การเสียเวลาส่ง blood test อาจทำให้สูญเสีย golden time ในการรักษา"},
        {label: "E", text: "ให้ยาแก้ปวดและต่อสกิน แทร็กชั่นต่อไปตามเดิม", is_correct: false, explanation: "ไม่ถูกต้อง การให้ยาแก้ปวดจะ mask อาการของ compartment syndrome ทำให้ไม่สามารถ monitor ได้ และการคงเดิม traction จะทำให้ compartment pressure สูงขึ้นเรื่อยๆ อาจนำไปสู่ irreversible muscle necrosis"}
      ],
      key_takeaway: "ผู้ป่วยที่มี pain with passive stretch หลังจากใส่ traction/cast ต้องนึกถึง compartment syndrome ทันที สิ่งแรกที่ต้องทำคือ remove ทุก external compression ทันที"
    }
  },
  {
    id: "39e5fbf1-6d43-4c33-a6ac-bdad97fe7f77",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: D. Saline irrigate rectum (การล้างทวารหนักด้วยน้ำเกลือ)",
      reason: "ทารกชายอายุ 3 เดือน มีประวัติ delayed passing meconium ร่วมกับ intermittent abdominal distension และไม่ถ่ายอุจจาระ 5 วัน ตรวจร่างกายพบท้องอืดแต่ไม่มี tenderness อาการเหล่านี้ชี้ไปยัง Hirschsprung's disease (congenital aganglionic megacolon) อย่างมาก\n\nHirschsprung's disease เกิดจากการไม่มี ganglion cells ใน myenteric (Auerbach's) และ submucosal (Meissner's) plexus ของลำไส้ใหญ่ส่วนปลาย ทำให้ segment นั้นไม่สามารถ relax ได้ เกิด functional obstruction ส่วนที่อยู่เหนือขึ้นไปจะขยายตัวสะสมอุจจาระ (megacolon)\n\nการรักษาเฉพาะหน้าที่เหมาะสมที่สุดคือ saline rectal irrigation (rectal washout) เพื่อ decompress ลำไส้และระบายอุจจาระที่สะสม วิธีนี้ปลอดภัยในทารก ช่วยลดอาการท้องอืดได้ทันที และสามารถทำซ้ำได้ขณะรอการวินิจฉัยยืนยันด้วย rectal biopsy\n\nNormal saline เป็นสารน้ำที่ปลอดภัยที่สุดสำหรับ rectal irrigation ในทารก เพราะเป็น isotonic ไม่ทำให้เกิด fluid-electrolyte imbalance ต่างจาก soap enema หรือ hypotonic/hypertonic solutions ที่อาจเป็นอันตราย",
      choices: [
        {label: "A", text: "Laxative", is_correct: false, explanation: "ไม่ถูกต้อง ยาระบายไม่ได้ผลในผู้ป่วย Hirschsprung's disease เพราะปัญหาอยู่ที่ aganglionic segment ไม่สามารถ relax ได้ ยาระบายอาจทำให้ท้องอืดมากขึ้นและเสี่ยงต่อ enterocolitis"},
        {label: "B", text: "Soap irrigation", is_correct: false, explanation: "ไม่ถูกต้อง Soap enema เป็นสิ่งที่ห้ามใช้ในทารกและเด็กเล็กเพราะ soap สามารถทำลายเยื่อบุลำไส้ (mucosal damage) ทำให้เกิด inflammation และอาจเกิด fluid-electrolyte imbalance ได้"},
        {label: "C", text: "Unison enema", is_correct: false, explanation: "ไม่ถูกต้อง ไม่ใช่วิธีมาตรฐานในการรักษา Hirschsprung's disease ในทารก และอาจมีส่วนประกอบที่ไม่ปลอดภัยสำหรับทารกอายุ 3 เดือน"},
        {label: "D", text: "Saline irrigate rectum", is_correct: true, explanation: "ถูกต้อง Normal saline rectal irrigation เป็นวิธีที่ปลอดภัยและได้ผลในการ decompress ลำไส้ในผู้ป่วย Hirschsprung's disease เพราะเป็น isotonic solution ไม่ทำให้เกิด mucosal damage หรือ electrolyte imbalance และสามารถระบายอุจจาระได้อย่างมีประสิทธิภาพ"},
        {label: "E", text: "Rectal stool evacuation", is_correct: false, explanation: "ไม่ถูกต้อง Digital rectal stool evacuation อาจใช้ได้ในบางกรณี แต่ไม่ได้ผลดีเท่า saline irrigation ในการ decompress ทั้ง colon และมีความเสี่ยงต่อ rectal mucosal injury ในทารก"}
      ],
      key_takeaway: "ทารกที่มี delayed meconium passage ร่วมกับ chronic abdominal distension และท้องผูกเรื้อรัง ให้นึกถึง Hirschsprung's disease การรักษาเฉพาะหน้าคือ saline rectal irrigation เพื่อ decompress ลำไส้"
    }
  },
  {
    id: "39e60f55-5f39-4d0b-8b55-6c434e348285",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: B. ส่งตรวจทางพยาธิวิทยาเพื่อศึกษาขอบของการผ่าตัด (surgical margin) และระดับการบุกรุกของเนื้องอก",
      reason: "ผู้ป่วยชายอายุ 45 ปี มีก้อนขนาด 2 cm ที่ hard palate (เพดานปากแข็ง) ที่สงสัยว่าเป็นมะเร็ง แพทย์ได้ทำ wide excisional biopsy ไปแล้ว สิ่งที่ต้องสนใจต่อไปคือการส่งชิ้นเนื้อตรวจทางพยาธิวิทยาเพื่อศึกษา 2 ประเด็นหลัก ได้แก่ surgical margin (ขอบของการผ่าตัด) และ depth of invasion (ระดับการบุกรุก)\n\nSurgical margin มีความสำคัญอย่างยิ่งเพราะจะบอกว่าตัดเนื้องอกออกได้หมดหรือไม่ ถ้า margin เป็น positive (มีเซลล์มะเร็งที่ขอบ) หมายความว่ายังมีเซลล์มะเร็งเหลืออยู่ ต้องผ่าตัดเพิ่มเติม ถ้า margin เป็น negative (clear margin) แสดงว่าตัดได้หมด\n\nDepth of invasion สำคัญเพราะจะช่วยกำหนด staging ของมะเร็ง และพยากรณ์โรค ซึ่งจะนำไปสู่การวางแผนการรักษาเสริม (adjuvant therapy) เช่น radiation therapy หรือ chemotherapy ที่อาจจำเป็น\n\nหลักการนี้เป็นหลักการพื้นฐานของ surgical oncology ที่หลังจากทำ excisional biopsy หรือ definitive surgery แล้ว จะต้องส่งชิ้นเนื้อตรวจทางพยาธิวิทยาเสมอ เพื่อยืนยันการวินิจฉัย ดูชนิดของมะเร็ง ดู margin status และ staging",
      choices: [
        {label: "A", text: "ขยายกระบวนการผ่าตัดเพื่อขจัดส่วนเนื้อที่ผิดปกติทั้งหมดพร้อมกับเนื้อเยื่อปกติโดยรอบ", is_correct: false, explanation: "ไม่ถูกต้อง ไม่ควรขยายการผ่าตัดทันทีโดยไม่ทราบผลพยาธิวิทยาก่อน เพราะต้องรู้ชนิดของมะเร็ง, margin status และ staging ก่อนจะตัดสินใจว่าต้องผ่าตัดเพิ่มหรือไม่"},
        {label: "B", text: "ส่งตรวจทางพยาธิวิทยาเพื่อศึกษาขอบของการผ่าตัด (surgical margin) และระดับการบุกรุกของเนื้องอก", is_correct: true, explanation: "ถูกต้อง เป็นขั้นตอนที่สำคัญที่สุดหลังทำ excisional biopsy เพื่อยืนยันการวินิจฉัย ดู margin status (positive/negative), histological type, grade และ depth of invasion ซึ่งจะนำไปสู่การวางแผนการรักษาต่อไป"},
        {label: "C", text: "ติดตามตรวจการไหลเวียนเลือด และระบายน้ำผ่านอาหารหลอดเท่านั้น", is_correct: false, explanation: "ไม่ถูกต้อง การเฝ้าระวังการไหลเวียนเลือดและให้อาหารทางหลอดเท่านั้นไม่ใช่ priority หลังทำ excisional biopsy ของก้อนขนาด 2 cm ที่ hard palate สิ่งสำคัญที่สุดคือ histopathological evaluation"},
        {label: "D", text: "ไม่ต้องให้สารต้านชีวนะเพราะเป็นการผ่าตัดในช่องปาก", is_correct: false, explanation: "ไม่ถูกต้อง การพิจารณาเรื่องยาปฏิชีวนะไม่ใช่สิ่งที่สำคัญที่สุดหลังทำ excisional biopsy ของก้อนที่สงสัยมะเร็ง สิ่งที่สำคัญที่สุดคือผลพยาธิวิทยา"},
        {label: "E", text: "รอผลการตรวจทางจีนวิทยาก่อนดำเนินการรักษาเพิ่มเติม", is_correct: false, explanation: "ไม่ถูกต้อง ตัวเลือกนี้คล้ายกับข้อ B แต่ใช้คำว่า 'จีนวิทยา' ซึ่งไม่ตรงกับ histopathology ข้อ B ระบุชัดเจนว่าต้องดู surgical margin และ depth of invasion ซึ่งเป็นข้อมูลที่สำคัญกว่า"}
      ],
      key_takeaway: "หลังทำ excisional biopsy ของก้อนที่สงสัยมะเร็ง สิ่งสำคัญที่สุดคือส่งตรวจ histopathology เพื่อดู surgical margin status และ depth of invasion ซึ่งจะเป็นตัวกำหนดแนวทางการรักษาต่อไป"
    }
  },
  {
    id: "3a410498-1319-4de0-b798-fc3217b7f23e",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Recheck endotracheal tube position and patency (ตรวจสอบตำแหน่งและความโล่งของท่อช่วยหายใจ)",
      reason: "ผู้ป่วยชายอายุ 50 ปี กินหน่อไม้ปี๊บ (paraquat) หมดสติ ไม่หายใจ ถูกใส่ endotracheal tube (ET tube) และ refer มา เมื่อมาถึงยังใส่ ET tube with ambu bag อยู่ สัญญาณชีพคือ PR 124 BP 180/100 ตามหลัก ABCDE approach ในการดูแลผู้ป่วยฉุกเฉิน สิ่งแรกที่ต้องทำเสมอคือ A = Airway\n\nการ recheck ET tube position and patency เป็นสิ่งแรกที่ต้องทำเมื่อรับผู้ป่วยที่ถูก intubate มาจากที่อื่น เพราะ ET tube อาจเลื่อนหลุด (dislodged) ระหว่างการ transport, อาจเข้าข้างเดียว (right main bronchus intubation) หรืออาจมีสิ่งอุดตันภายในท่อ (mucous plug, blood clot, vomitus)\n\nวิธีการตรวจสอบ ได้แก่ การดูว่า chest rise symmetrical หรือไม่ ฟัง breath sounds ทั้ง 2 ข้าง ตรวจ capnography (ETCO2) ดูตำแหน่งของ ET tube ที่ริมฝีปาก (depth marking) และอาจทำ CXR เพื่อยืนยันตำแหน่ง\n\nเมื่อมั่นใจว่า airway secure แล้ว จึงค่อยดำเนินการตรวจอื่นๆ เช่น ABG, CXR, ECG และ toxicology screening ตามลำดับ",
      choices: [
        {label: "A", text: "Recheck endotracheal tube position and patency", is_correct: true, explanation: "ถูกต้อง ตามหลัก ABCDE approach สิ่งแรกที่ต้องทำคือ secure airway โดยเฉพาะเมื่อรับผู้ป่วยที่ถูก intubate มาจากที่อื่น ต้องตรวจสอบว่า ET tube อยู่ในตำแหน่งที่ถูกต้อง โล่ง และ ventilation เพียงพอ"},
        {label: "B", text: "ABG (Arterial blood gas)", is_correct: false, explanation: "ไม่ถูกต้อง ABG เป็นการตรวจที่สำคัญในการประเมิน oxygenation และ ventilation แต่ต้องทำหลังจากมั่นใจว่า airway secure แล้ว ตามหลัก ABCDE approach"},
        {label: "C", text: "CXR", is_correct: false, explanation: "ไม่ถูกต้อง CXR ช่วยยืนยันตำแหน่ง ET tube และดู pulmonary pathology แต่เป็นขั้นตอนที่ทำหลังจาก clinical assessment ของ airway แล้ว การทำ CXR ใช้เวลามากกว่าการตรวจร่างกาย"},
        {label: "D", text: "ECG 12 lead", is_correct: false, explanation: "ไม่ถูกต้อง ECG สำคัญในการดูว่ามี cardiac arrhythmia จากพิษ paraquat หรือไม่ แต่ไม่ใช่สิ่งแรกที่ต้องทำ ต้อง secure airway ก่อนเสมอ"},
        {label: "E", text: "Toxicology screening for paraquat level", is_correct: false, explanation: "ไม่ถูกต้อง การตรวจระดับ paraquat ในเลือดมีประโยชน์ในการ prognosis แต่ไม่ใช่ priority แรก ต้อง stabilize ผู้ป่วย (ABCDE) ก่อน แล้วค่อยส่งตรวจ toxicology"}
      ],
      key_takeaway: "เมื่อรับผู้ป่วยที่ถูก intubate มาจากที่อื่น สิ่งแรกที่ต้องทำเสมอคือ recheck ET tube position and patency ตามหลัก ABCDE approach - Airway มาก่อนเสมอ"
    }
  },
  {
    id: "3a7284b8-5486-433a-9e19-7b3e97a1607f",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: D. Acid phosphatase (กรดฟอสฟาเตส)",
      reason: "ผู้ป่วยหญิงอายุ 18 ปี ถูกข่มขืนโดยน้าชาย ตรวจร่างกายพบ ecchymosis และ recent hymen tear ซึ่งเป็นหลักฐานของ penetrating trauma ในกรณีที่ต้องการยืนยันว่ามีน้ำอสุจิ (semen) อยู่ใน cervical-vaginal discharge หรือไม่ การตรวจ acid phosphatase เป็นวิธีที่ใช้ยืนยันได้\n\nAcid phosphatase เป็นเอนไซม์ที่พบปริมาณมากในน้ำอสุจิ (seminal acid phosphatase) โดยมีระดับสูงกว่าในเนื้อเยื่ออื่นๆ มาก การตรวจพบระดับ acid phosphatase ที่สูงใน vaginal fluid จึงเป็นหลักฐานทางนิติวิทยาศาสตร์ที่สนับสนุนว่ามีการสอดใส่อวัยวะเพศชายเข้าไปในช่องคลอด\n\nAcid phosphatase สามารถตรวจพบได้แม้ผู้กระทำผิดจะหลั่งภายนอก (withdrawal before ejaculation) หรือใช้ถุงยางอนามัย เพราะ prostatic fluid ที่หลั่งก่อน ejaculation (pre-ejaculatory fluid) ก็มี acid phosphatase อยู่ด้วย นอกจากนี้ acid phosphatase ยังคงตรวจพบได้ใน vaginal fluid นานถึง 48-72 ชั่วโมงหลังร่วมเพศ\n\nในบริบทนิติเวชไทย acid phosphatase ยังคงเป็นการตรวจมาตรฐานที่ใช้ร่วมกับ Forensic DNA analysis เพื่อยืนยันการข่มขืน",
      choices: [
        {label: "A", text: "Pap smear", is_correct: false, explanation: "ไม่ถูกต้อง Pap smear ใช้ screening มะเร็งปากมดลูก ไม่ได้ใช้ยืนยันการข่มขืน แม้อาจเห็น sperm ได้บ้าง แต่ไม่ใช่วัตถุประสงค์หลักของ Pap smear"},
        {label: "B", text: "KOH preparation", is_correct: false, explanation: "ไม่ถูกต้อง KOH preparation ใช้ตรวจหาเชื้อรา (fungal infection) เช่น Candida albicans ไม่เกี่ยวข้องกับการยืนยันการข่มขืน"},
        {label: "C", text: "Tzank's smear", is_correct: false, explanation: "ไม่ถูกต้อง Tzank's smear ใช้ตรวจหา multinucleated giant cells ในการวินิจฉัย herpes virus infection ไม่เกี่ยวข้องกับการยืนยันการข่มขืน"},
        {label: "D", text: "Acid phosphatase", is_correct: true, explanation: "ถูกต้อง Acid phosphatase เป็น marker ของน้ำอสุจิที่ใช้ในนิติเวชศาสตร์เพื่อยืนยันว่ามี semen อยู่ใน vaginal fluid ตรวจพบได้นาน 48-72 ชั่วโมงหลังร่วมเพศ เป็นหลักฐานสำคัญในคดีข่มขืน"},
        {label: "E", text: "Forensic DNA analysis", is_correct: false, explanation: "ไม่ถูกต้องในบริบทของคำถาม แม้ DNA analysis เป็นหลักฐานที่ดีที่สุดในการระบุตัวผู้กระทำผิด แต่คำถามถามเรื่อง discharge ที่ส่งเพื่อ 'ยืนยัน' ว่ามี semen หรือไม่ ซึ่ง acid phosphatase เป็นคำตอบที่ตรงกว่า"}
      ],
      key_takeaway: "ในคดีข่มขืน acid phosphatase ใน vaginal discharge เป็นหลักฐานทางนิติเวชที่ยืนยันว่ามีน้ำอสุจิ สามารถตรวจพบได้นาน 48-72 ชั่วโมงหลังเกิดเหตุ"
    }
  },
  {
    id: "3a7b8f10-0283-4a7f-a710-88e91338c871",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Allopurinol (อัลโลพิวรินอล)",
      reason: "ผู้ป่วยหญิงมีอาการปวดข้อ 2-3 วัน ผล joint aspirate แสดง cloudy fluid, WBC 30,000 cells และมี rhomboid shape crystal ลักษณะเหล่านี้บ่งชี้ถึง pseudogout หรือ calcium pyrophosphate deposition disease (CPPD)\n\nRhomboid shape crystal คือ calcium pyrophosphate dihydrate (CPPD) crystal ซึ่งเป็น hallmark ของ pseudogout ต่างจาก needle-shaped crystal ของ monosodium urate (MSU) ที่พบใน gout CPPD crystal เมื่อดูด้วย polarized light microscopy จะเป็น weakly positive birefringent (สีน้ำเงินเมื่อขนานกับ slow ray) ในขณะที่ MSU crystal เป็น strongly negative birefringent\n\nอย่างไรก็ตาม คำตอบข้อ A คือ Allopurinol ซึ่งจริงๆ แล้วเป็นยาที่ใช้ในการรักษา gout (ลด uric acid) ไม่ใช่ pseudogout คำถามนี้อาจมีความคลุมเครือ แต่ถ้าพิจารณาจากคำตอบที่ถูกต้องคือ A แสดงว่าโจทย์ต้องการให้ตอบ Allopurinol ในฐานะยาที่ใช้รักษาโรคเกาท์ที่มี crystal arthropathy\n\nการรักษา acute pseudogout ที่เหมาะสมจริงๆ คือ NSAIDs, colchicine หรือ corticosteroids แต่ในข้อสอบนี้ Allopurinol ถูกระบุว่าเป็นคำตอบที่ถูกต้อง",
      choices: [
        {label: "A", text: "Allopurinal", is_correct: true, explanation: "ถูกต้องตามเฉลยของข้อสอบ Allopurinol เป็น xanthine oxidase inhibitor ที่ลดการสร้าง uric acid ใช้ในการรักษา chronic gout เพื่อป้องกันการกำเริบ แม้ว่า rhomboid crystal จะบ่งชี้ pseudogout มากกว่า gout"},
        {label: "B", text: "Colchicine", is_correct: false, explanation: "ไม่ถูกต้องตามเฉลย แม้ colchicine สามารถใช้รักษาทั้ง acute gout และ acute pseudogout ได้ โดยยับยั้ง neutrophil chemotaxis และ phagocytosis ของ crystal"},
        {label: "C", text: "Ceftriazone", is_correct: false, explanation: "ไม่ถูกต้อง Ceftriaxone เป็นยาปฏิชีวนะที่ใช้รักษา septic arthritis ไม่ใช่ crystal arthropathy แม้ WBC 30,000 อาจทำให้สงสัย infection แต่การพบ crystal ยืนยัน crystal-induced arthritis"},
        {label: "D", text: "Diclofenac", is_correct: false, explanation: "ไม่ถูกต้องตามเฉลย แม้ Diclofenac (NSAIDs) เป็นยาที่ใช้รักษา acute crystal arthropathy ได้ทั้ง gout และ pseudogout แต่ไม่ใช่คำตอบที่ถูกต้องตามเฉลยข้อสอบ"}
      ],
      key_takeaway: "Rhomboid shape crystal = CPPD (pseudogout), Needle shape crystal = MSU (gout) การรักษา acute crystal arthropathy ใช้ NSAIDs, colchicine หรือ corticosteroids ส่วน Allopurinol ใช้ลด uric acid ในการป้องกัน gout กำเริบ"
    }
  },
  {
    id: "3a977373-ca43-4c0a-8365-f64385e770ec",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Asthma (โรคหอบหืด)",
      reason: "เด็กอายุ 6 ปี มาด้วยอาการหายใจลำบาก (dyspnea), เสียงแหบ (hoarseness), ไอ (cough), แน่นหน้าอก (chest tightness) มีประวัติน้ำมูกไหลในตอนเช้า (rhinorrhea - อาจบ่งชี้ allergic rhinitis) ตรวจร่างกาย: ไข้ต่ำ (BT 37C), RR 30, HR 100 ฟังปอดได้ยิน bilateral expiratory wheezing และ rhonchi\n\nBilateral expiratory wheezing เป็นอาการที่ characteristic ของ asthma เกิดจาก bronchospasm, airway inflammation และ mucous hypersecretion ทำให้ airway ตีบแคบ ลมหายใจออกลำบาก เกิดเสียง wheezing โดยเฉพาะ expiratory phase ร่วมกับอาการ dyspnea, cough และ chest tightness ครบ classic triad ของ asthma\n\nประวัติ rhinorrhea ในตอนเช้าสนับสนุนว่ามี allergic rhinitis ร่วมด้วย ซึ่งเป็น comorbidity ที่พบบ่อยมากกับ asthma (concept ของ united airway disease) ผู้ป่วย allergic rhinitis มีโอกาสเป็น asthma สูงกว่าคนทั่วไป 3-5 เท่า\n\nอาการเหล่านี้ในเด็กอายุ 6 ปี ที่ไม่มีไข้สูง (BT 37C = afebrile) ทำให้ unlikely ที่จะเป็น infection และ bilateral findings ทำให้ unlikely focal pathology เช่น foreign body aspiration",
      choices: [
        {label: "A", text: "Asthma", is_correct: true, explanation: "ถูกต้อง อาการ dyspnea, cough, chest tightness ร่วมกับ bilateral expiratory wheezing เป็น classic presentation ของ asthma ในเด็ก ประวัติ allergic rhinitis สนับสนุนการวินิจฉัย"},
        {label: "B", text: "Bacterial tracheitis", is_correct: false, explanation: "ไม่ถูกต้อง Bacterial tracheitis มักมีไข้สูง, stridor (inspiratory sound ไม่ใช่ expiratory wheezing), barking cough และมักเกิดหลัง viral croup ที่อาการไม่ดีขึ้น ไม่ match กับ bilateral expiratory wheezing"},
        {label: "C", text: "Acute bronchitis", is_correct: false, explanation: "ไม่ถูกต้อง Acute bronchitis มักมี productive cough เป็นอาการหลัก อาจมี rhonchi แต่มักไม่มี significant wheezing หรือ chest tightness แบบที่พบใน asthma และมักมีไข้จากการติดเชื้อ"},
        {label: "D", text: "Acute bronchiolitis", is_correct: false, explanation: "ไม่ถูกต้อง Acute bronchiolitis พบในเด็กอายุ <2 ปี (ส่วนใหญ่ <6 เดือน) สาเหตุหลักคือ RSV เด็กอายุ 6 ปีเกินวัยที่จะเป็น bronchiolitis แล้ว"},
        {label: "E", text: "Pneumonia", is_correct: false, explanation: "ไม่ถูกต้อง Pneumonia มักมีไข้สูง ฟังปอดได้ยิน crepitation/crackles (ไม่ใช่ wheezing) อาจมี bronchial breathing มักเป็น focal/unilateral ไม่ใช่ bilateral wheezing"}
      ],
      key_takeaway: "เด็กที่มี recurrent wheezing, cough, dyspnea, chest tightness โดยเฉพาะมีประวัติ allergic rhinitis ร่วมด้วย ให้นึกถึง asthma เป็นอันดับแรก Bilateral expiratory wheezing เป็น hallmark ของ asthma"
    }
  },
  {
    id: "3a991662-32ef-4fe7-9cae-34f2fc77a0df",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Os trigonum excision (การผ่าตัดเอากระดูก os trigonum ออก)",
      reason: "นักบัลเล่ต์หญิงอายุ 20 ปี มีอาการปวดส้นเท้าด้านหลัง (posterior heel pain) เรื้อรัง 7 เดือน สัมพันธ์กับการเต้น en-pointe (การเต้นบนปลายเท้า) โดยการรักษาแบบอนุรักษ์นิยม (conservative treatment) ด้วยยาและการจำกัดกิจกรรม 3 เดือนไม่ได้ผล\n\nอาการนี้เป็นลักษณะเฉพาะของ posterior ankle impingement syndrome หรือ os trigonum syndrome ซึ่งเกิดจาก os trigonum (accessory bone ด้านหลังของ talus) ถูกกดระหว่าง tibia และ calcaneus ในท่า plantar flexion สุด (maximal plantar flexion) ที่ใช้ในการเต้น en-pointe ทำให้เกิดอาการปวดด้านหลังข้อเท้า\n\nOs trigonum พบได้ประมาณ 7-14% ของประชากรทั่วไป มักไม่ก่อให้เกิดอาการ แต่ในนักบัลเล่ต์หรือนักกีฬาที่ต้อง forced plantar flexion บ่อยๆ อาจทำให้เกิด impingement และปวด\n\nเมื่อ conservative treatment ล้มเหลว (ยา จำกัดกิจกรรม physical therapy) 3 เดือน การรักษาขั้นต่อไปคือ surgical excision ของ os trigonum ซึ่งให้ผลดีมาก (success rate 85-90%) และนักกีฬาสามารถกลับมาเล่นกีฬาได้ภายใน 3-6 เดือนหลังผ่าตัด",
      choices: [
        {label: "A", text: "Os trigonum excision", is_correct: true, explanation: "ถูกต้อง เป็นการรักษาที่เหมาะสมสำหรับ posterior ankle impingement syndrome จาก os trigonum ที่ conservative treatment ล้มเหลว การผ่าตัดเอา os trigonum ออกให้ผลดีมาก success rate 85-90%"},
        {label: "B", text: "Achilles tendon reconstruction", is_correct: false, explanation: "ไม่ถูกต้อง Achilles tendon reconstruction ใช้ในกรณี Achilles tendon rupture หรือ chronic Achilles tendinopathy ที่รุนแรง อาการปวดจาก Achilles มักอยู่ที่ midportion ของ tendon ไม่ใช่ posterior impingement จาก en-pointe"},
        {label: "C", text: "Debridement and removal of calcification of Achilles tendon", is_correct: false, explanation: "ไม่ถูกต้อง การ debride และเอา calcification ออกจาก Achilles tendon ใช้ในกรณี insertional Achilles tendinopathy ที่มี calcification ซึ่งมีลักษณะอาการต่างจาก os trigonum syndrome"},
        {label: "D", text: "Extracorporeal shock wave therapy", is_correct: false, explanation: "ไม่ถูกต้อง ESWT ใช้รักษา plantar fasciitis หรือ Achilles tendinopathy ที่ไม่ตอบสนองต่อ conservative treatment แต่ไม่ได้ผลดีในกรณี os trigonum syndrome ที่มี bony impingement"},
        {label: "E", text: "Extended conservative management with physical therapy", is_correct: false, explanation: "ไม่ถูกต้อง ผู้ป่วยได้รับ conservative treatment แล้ว 3 เดือนโดยไม่ดีขึ้น การรักษาแบบอนุรักษ์นิยมต่อไปจะไม่ได้ผล เพราะปัญหาเป็น structural (bony impingement) ที่ต้องแก้ไขด้วยการผ่าตัด"}
      ],
      key_takeaway: "นักบัลเล่ต์ที่มี posterior heel pain จากท่า en-pointe ที่ conservative treatment ล้มเหลว ให้นึกถึง os trigonum syndrome การรักษาคือ os trigonum excision"
    }
  },
  {
    id: "3a999524-624a-4ab7-8cf3-b4e17154d8da",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: E. Vaginal estrogen cream (เอสโตรเจนครีมทาช่องคลอด)",
      reason: "หญิงอายุ 60 ปี หมดประจำเดือนมา 10 ปี มีอาการเจ็บขณะมีเพศสัมพันธ์ (dyspareunia) เป็นเวลา 1 ปี ตรวจภายในพบ atrophic vaginal mucosa with scant discharge อาการเหล่านี้เป็นลักษณะเฉพาะของ genitourinary syndrome of menopause (GSM) หรือ vulvovaginal atrophy\n\nGSM เกิดจากการขาด estrogen หลังหมดประจำเดือน ทำให้เยื่อบุช่องคลอดบางลง (atrophy), สูญเสีย rugae, ความยืดหยุ่นลดลง, มี discharge น้อยลง และ pH ของช่องคลอดสูงขึ้น ส่งผลให้มีอาการแห้ง เจ็บเวลาร่วมเพศ คัน และอาจมี recurrent urinary tract infections\n\nการรักษาที่เหมาะสมที่สุดสำหรับ GSM ที่มีอาการเฉพาะที่ (local symptoms) คือ vaginal estrogen cream (topical estrogen) เพราะให้ผลดีในการฟื้นฟูเยื่อบุช่องคลอด มีผลข้างเคียงทางระบบน้อยมากเมื่อเทียบกับ systemic estrogen therapy (oral หรือ transdermal) เนื่องจากระดับ estrogen ในกระแสเลือดต่ำกว่ามาก จึงปลอดภัยกว่าสำหรับผู้ป่วยที่มีอาการเฉพาะที่\n\nVaginal estrogen cream มีหลายรูปแบบ เช่น conjugated estrogen cream, estradiol cream, estriol cream โดยทั่วไปใช้ทา 2-3 ครั้ง/สัปดาห์ หลังจาก loading dose ในช่วง 2 สัปดาห์แรก",
      choices: [
        {label: "A", text: "Reassure", is_correct: false, explanation: "ไม่ถูกต้อง การ reassure เพียงอย่างเดียวไม่เพียงพอ เพราะ vaginal atrophy จะไม่ดีขึ้นเองตามธรรมชาติ และอาการจะแย่ลงเรื่อยๆ ถ้าไม่ได้รับการรักษา ส่งผลต่อคุณภาพชีวิตของผู้ป่วย"},
        {label: "B", text: "Pelvic floor exercise", is_correct: false, explanation: "ไม่ถูกต้อง Pelvic floor exercise (Kegel exercise) ช่วยเรื่อง stress urinary incontinence และ pelvic organ prolapse แต่ไม่ช่วยแก้ปัญหา vaginal atrophy ที่เกิดจากการขาด estrogen"},
        {label: "C", text: "Oral estrogen", is_correct: false, explanation: "ไม่ถูกต้อง Oral estrogen (systemic HRT) ให้ผลดีในการรักษา vasomotor symptoms (hot flushes) แต่มี systemic side effects มากกว่า topical estrogen เมื่อผู้ป่วยมีอาการเฉพาะที่ (dyspareunia จาก atrophy) ควรเลือก local therapy ที่ปลอดภัยกว่า"},
        {label: "D", text: "Transdermal estrogen", is_correct: false, explanation: "ไม่ถูกต้อง Transdermal estrogen เป็น systemic HRT แม้จะมี first-pass effect น้อยกว่า oral estrogen แต่ยังคงเป็น systemic therapy ที่มีความเสี่ยงมากกว่า local therapy สำหรับอาการเฉพาะที่"},
        {label: "E", text: "Vaginal estrogen cream", is_correct: true, explanation: "ถูกต้อง เป็น first-line treatment สำหรับ GSM/vaginal atrophy ที่มีอาการเฉพาะที่ ให้ผลดีในการฟื้นฟูเยื่อบุช่องคลอด มีผลข้างเคียงทางระบบน้อยมาก เนื่องจากระดับ estrogen ในเลือดต่ำ ปลอดภัยกว่า systemic HRT"}
      ],
      key_takeaway: "หญิงวัยหมดประจำเดือนที่มี dyspareunia จาก vaginal atrophy การรักษาที่เหมาะสมที่สุดคือ vaginal estrogen cream (topical) เพราะได้ผลดีและมีผลข้างเคียงทางระบบน้อยกว่า systemic HRT"
    }
  },
  {
    id: "3aa380b0-2470-4202-9c2f-02f2153667bd",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: B. หญิง 16 ปี ไม่เคยมีเพศสัมพันธ์มาก่อน",
      reason: "วัคซีน HPV (Human Papillomavirus) มีประสิทธิภาพสูงสุดเมื่อให้ก่อนที่จะสัมผัสเชื้อ HPV ซึ่งหมายความว่าควรให้ก่อนมีเพศสัมพันธ์ครั้งแรก วัคซีน HPV ป้องกันการติดเชื้อ HPV สายพันธุ์ที่ก่อให้เกิดมะเร็งปากมดลูก (type 16, 18 ซึ่งเป็นสาเหตุประมาณ 70% ของมะเร็งปากมดลูก) และหูดหงอนไก่ (type 6, 11)\n\nหญิงอายุ 16 ปีที่ไม่เคยมีเพศสัมพันธ์เป็นผู้ที่ได้รับประโยชน์มากที่สุด เพราะยังไม่เคยสัมผัสเชื้อ HPV วัคซีนจะสร้างภูมิคุ้มกันก่อนการสัมผัสเชื้อ ทำให้มีประสิทธิภาพสูงสุดในการป้องกัน อายุ 16 ปีอยู่ในช่วงอายุที่แนะนำ (9-26 ปี) และใกล้วัยที่จะเริ่มมีเพศสัมพันธ์\n\nเปรียบเทียบกับตัวเลือกอื่นๆ ด.ญ. 7 ปี แม้จะให้วัคซีนได้ แต่ยังเด็กเกินไปตามคำแนะนำมาตรฐาน (เริ่มที่ 9-12 ปี) หญิง 28 ปีและชาย 30 ปี อาจเคยสัมผัสเชื้อ HPV แล้ว ทำให้ประสิทธิภาพลดลง หญิง 32 ปีที่เป็นมะเร็งปากมดลูกแล้ว วัคซีนไม่มีผลในการรักษา",
      choices: [
        {label: "A", text: "ด.ญ. 7 ปี แม่มีประวัติเป็น HPV", is_correct: false, explanation: "ไม่ถูกต้อง แม้ว่า ด.ญ. ยังไม่เคยสัมผัสเชื้อ แต่อายุ 7 ปียังเด็กเกินไป คำแนะนำมาตรฐานเริ่มที่อายุ 9-12 ปี และประวัติแม่เป็น HPV ไม่ได้เพิ่มข้อบ่งชี้ เพราะ HPV ติดต่อทางเพศสัมพันธ์ ไม่ถ่ายทอดทางพันธุกรรม"},
        {label: "B", text: "หญิง 16 ปี ไม่เคยมีเพศสัมพันธ์มาก่อน", is_correct: true, explanation: "ถูกต้อง เป็นผู้ที่ได้รับประโยชน์สูงสุดจากวัคซีน HPV เพราะอยู่ในช่วงอายุที่แนะนำ (9-26 ปี) และยังไม่เคยสัมผัสเชื้อ HPV ทำให้วัคซีนมีประสิทธิภาพสูงสุดในการป้องกัน"},
        {label: "C", text: "หญิง 28 ปี มาขอคำปรึกษาว่าจะแต่งงาน", is_correct: false, explanation: "ไม่ถูกต้อง หญิงอายุ 28 ปีมีโอกาสสูงที่เคยสัมผัสเชื้อ HPV มาก่อนแล้ว ทำให้ประสิทธิภาพของวัคซีนลดลง แม้ยังสามารถฉีดได้แต่ไม่ได้ประโยชน์สูงสุด"},
        {label: "D", text: "ชาย 30 ปี มาขอคำปรึกษาว่าจะแต่งงาน", is_correct: false, explanation: "ไม่ถูกต้อง ชายอายุ 30 ปี นอกจากมีโอกาสเคยสัมผัสเชื้อแล้ว ยังเกินอายุที่แนะนำสำหรับผู้ชาย (9-21 ปี ตามแนวทางทั่วไป) ประสิทธิภาพจึงลดลง"},
        {label: "E", text: "หญิง 32 ปี มารักษามะเร็งปากมดลูก", is_correct: false, explanation: "ไม่ถูกต้อง วัคซีน HPV เป็นวัคซีนป้องกัน (prophylactic) ไม่ใช่วัคซีนรักษา (therapeutic) ไม่มีผลในการรักษามะเร็งปากมดลูกที่เป็นแล้ว การให้วัคซีนในผู้ป่วยรายนี้ไม่มีประโยชน์ทางคลินิก"}
      ],
      key_takeaway: "วัคซีน HPV ได้ประโยชน์สูงสุดเมื่อให้ก่อนมีเพศสัมพันธ์ครั้งแรก (ก่อนสัมผัสเชื้อ) ในช่วงอายุ 9-26 ปี เป็นวัคซีนป้องกัน ไม่ใช่วัคซีนรักษา"
    }
  },
  {
    id: "3aa54841-38aa-45bd-a687-81f74029b167",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: B. ให้กระดาษถุง (paper bag) ใส่จมูกปาก สอบแจง และหายใจแบบช้า ๆ อย่างลึก",
      reason: "หญิงอายุ 22 ปี ที่ทะเลาะบอกเลิกกับแฟน มีอาการ hyperventilation (หายใจเร็วและลึก RR 28/min), ใจสั่น (HR 110/min), ชาตามศีรษะและแขน เกิดขึ้นเป็นครั้งแรก ไม่มีประวัติจิตเวช อาการเหล่านี้เป็น hyperventilation syndrome จาก acute stress reaction\n\nPathophysiology: เมื่อหายใจเร็วและลึก จะเกิด excessive CO2 elimination ทำให้ PaCO2 ลดลง (hypocapnia) เกิด respiratory alkalosis (pH สูงขึ้น) ส่งผลให้ ionized calcium ลดลง (calcium จับกับ albumin มากขึ้นใน alkaline pH) ทำให้เกิดอาการชาตามปลายมือปลายเท้า รอบปาก และอาจมี carpopedal spasm ได้\n\nการรักษาที่เหมาะสมที่สุดคือ non-pharmacological approach ได้แก่ การ reassure ผู้ป่วย อธิบายว่าอาการเกิดจากการหายใจเร็วเกินไป ให้หายใจช้าๆ ลึกๆ (slow deep breathing) และอาจใช้ paper bag rebreathing technique เพื่อเพิ่ม CO2 ที่หายใจกลับเข้าไป ช่วยแก้ไข respiratory alkalosis\n\nเนื่องจากเป็น first episode ไม่มีประวัติจิตเวช และมี identifiable precipitating factor (ทะเลาะกับแฟน) จึงไม่จำเป็นต้องให้ยา benzodiazepine หรือ beta-blocker ในตอนแรก",
      choices: [
        {label: "A", text: "ให้ lorazepam 2 mg IV แล้วส่งตรวจจิตเวช", is_correct: false, explanation: "ไม่ถูกต้อง การให้ IV benzodiazepine เป็น overtreatment สำหรับ first episode hyperventilation syndrome ที่มี clear precipitating factor Lorazepam IV มีความเสี่ยงต่อ respiratory depression และไม่จำเป็นในกรณีนี้"},
        {label: "B", text: "ให้กระดาษถุง (paper bag) ใส่จมูกปาก สอบแจง และหายใจแบบช้า ๆ อย่างลึก", is_correct: true, explanation: "ถูกต้อง เป็น first-line treatment สำหรับ acute hyperventilation syndrome วิธี paper bag rebreathing ช่วยเพิ่ม CO2 ที่หายใจกลับเข้าไป แก้ไข respiratory alkalosis ร่วมกับ reassurance และ slow deep breathing technique"},
        {label: "C", text: "ให้ propranolol 10 mg PO เพื่อลดความวิตกกังวล", is_correct: false, explanation: "ไม่ถูกต้อง Propranolol อาจใช้ในกรณี performance anxiety แต่ไม่ใช่ first-line treatment สำหรับ acute hyperventilation และอาจ mask อาการ tachycardia ที่ต้อง monitor"},
        {label: "D", text: "ให้ diazepam 5 mg IM แล้ว monitor ไว้ 24 ชั่วโมง", is_correct: false, explanation: "ไม่ถูกต้อง เป็น overtreatment สำหรับ first episode ที่มี identifiable cause การ admit 24 ชั่วโมงไม่จำเป็น ควรลอง non-pharmacological approach ก่อน"},
        {label: "E", text: "ให้ oxygen 6 L/min ผ่านหน้ากาก เพื่อแก้ hypoxemia", is_correct: false, explanation: "ไม่ถูกต้อง ผู้ป่วย hyperventilation syndrome ไม่ได้ hypoxemia (SpO2 มักปกติหรือสูง) การให้ O2 จะไม่ช่วย และทำให้ผู้ป่วยหายใจช้าลงยากขึ้น ปัญหาหลักคือ hypocapnia ไม่ใช่ hypoxemia"}
      ],
      key_takeaway: "Hyperventilation syndrome จาก acute stress ให้รักษาด้วย non-pharmacological approach ก่อน ได้แก่ reassurance, slow deep breathing และ paper bag rebreathing เพื่อแก้ไข respiratory alkalosis"
    }
  },
  {
    id: "3af5598e-3ffb-4f7b-94b2-379b702d31f1",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Plantar fasciitis (รองช้ำ/พังผืดใต้ฝ่าเท้าอักเสบ)",
      reason: "หญิงอายุ 50 ปี มาด้วยอาการปวดส้นเท้าด้านฝ่าเท้า (plantar heel pain) เรื้อรัง 5 เดือน อาการปวดเป็นมากที่สุดในตอนเช้าหลังก้าวเดินไม่กี่ก้าว (first-step pain) และปวดมากขึ้นเมื่อยืนหรือเดินนาน ตรวจร่างกายพบ tenderness ที่ medial calcaneal tubercle ลักษณะเหล่านี้เป็น classic presentation ของ plantar fasciitis\n\nPlantar fasciitis เป็นสาเหตุที่พบบ่อยที่สุดของ plantar heel pain (ประมาณ 80% ของกรณีปวดส้นเท้า) เกิดจาก degenerative changes ของ plantar fascia ที่จุด origin ซึ่งเกาะที่ medial calcaneal tubercle Risk factors ได้แก่ อายุมาก (40-60 ปี), น้ำหนักเกิน, ยืนนาน, รองเท้าไม่เหมาะสม\n\nFirst-step pain เป็นอาการที่ pathognomonic ของ plantar fasciitis เกิดจาก plantar fascia หดตัวในขณะนอนหลับ เมื่อก้าวเดินครั้งแรกจะเกิด micro-tears ที่จุดเกาะทำให้ปวด หลังเดินสักพักอาการจะดีขึ้น (warm-up phenomenon) แต่จะปวดอีกเมื่อยืนหรือเดินนาน\n\nTenderness ที่ medial calcaneal tubercle (จุดเกาะของ plantar fascia ที่กระดูกส้นเท้า) เป็น classic physical finding ที่ช่วยยืนยันการวินิจฉัย",
      choices: [
        {label: "A", text: "Plantar fasciitis", is_correct: true, explanation: "ถูกต้อง มี classic triad ของ plantar fasciitis ได้แก่ 1) plantar heel pain 2) first-step pain ตอนเช้า 3) tenderness ที่ medial calcaneal tubercle เป็นสาเหตุที่พบบ่อยที่สุดของ plantar heel pain"},
        {label: "B", text: "Achilles tendinitis", is_correct: false, explanation: "ไม่ถูกต้อง Achilles tendinitis ทำให้ปวดด้านหลังของส้นเท้า (posterior heel) ที่ตำแหน่ง Achilles tendon insertion ไม่ใช่ด้านฝ่าเท้า (plantar side) และ tenderness จะอยู่ที่ Achilles tendon ไม่ใช่ medial calcaneal tubercle"},
        {label: "C", text: "Tarsal tunnel syndrome", is_correct: false, explanation: "ไม่ถูกต้อง Tarsal tunnel syndrome เกิดจาก posterior tibial nerve ถูกกดที่ tarsal tunnel อาการหลักคือ burning pain, tingling และ numbness ที่ฝ่าเท้า มี positive Tinel's sign ที่ posterior tibial nerve ไม่ใช่ mechanical pain แบบ first-step pain"},
        {label: "D", text: "Heel spur syndrome", is_correct: false, explanation: "ไม่ถูกต้อง Heel spur (กระดูกงอก) พบได้ใน X-ray ของผู้ป่วย plantar fasciitis แต่ heel spur ไม่ใช่สาเหตุของอาการปวด เพราะพบ heel spur ได้ในคนที่ไม่มีอาการเช่นกัน (incidental finding) สาเหตุที่แท้จริงคือ plantar fasciitis"},
        {label: "E", text: "Calcaneal stress fracture", is_correct: false, explanation: "ไม่ถูกต้อง Calcaneal stress fracture มักเกิดในนักวิ่งหรือคนที่เปลี่ยนกิจกรรมทันที อาการปวดจะปวดทั้ง medial และ lateral side ของ calcaneus (squeeze test positive) และไม่มี first-step pain pattern แบบ plantar fasciitis"}
      ],
      key_takeaway: "Plantar fasciitis วินิจฉัยด้วย classic triad: 1) plantar heel pain 2) first-step pain ตอนเช้า 3) tenderness ที่ medial calcaneal tubercle เป็นสาเหตุที่พบบ่อยที่สุดของอาการปวดส้นเท้า"
    }
  },
  {
    id: "3b0d3d14-a92f-45a4-a9ec-987e2b553832",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Biopsy ของแผลและ lymph node (การตัดชิ้นเนื้อแผลและต่อมน้ำเหลือง)",
      reason: "หญิงอายุ 60 ปี อยู่อำเภอบุรีรัมย์ มีแผลเรื้อรังที่ฝ่าเท้า ไม่เจ็บปวด กดไม่เจ็บ โตขึ้นเรื่อยๆ พบ hyperpigmentation และ ulcer ขนาด 2 cm ร่วมกับ lymph node โตที่ขาหนีบด้านซ้าย ลักษณะเหล่านี้ต้องสงสัย malignant melanoma หรือ squamous cell carcinoma ของฝ่าเท้า\n\nAcral melanoma (melanoma ที่ฝ่ามือ ฝ่าเท้า หรือใต้เล็บ) เป็นชนิดของ melanoma ที่พบบ่อยที่สุดในคนเอเชีย รวมถึงคนไทย ลักษณะสำคัญ ได้แก่ แผลสีเข้มที่ฝ่าเท้า (hyperpigmentation) ที่โตขึ้นเรื่อยๆ อาจมี ulceration และมักไม่เจ็บในระยะแรก การมี lymph node โตที่ขาหนีบบ่งชี้ว่าอาจมี lymph node metastasis\n\nก่อนจะวางแผนการรักษาที่เหมาะสม จำเป็นต้องยืนยันการวินิจฉัยก่อนด้วย biopsy ทั้งแผลที่ฝ่าเท้าและ lymph node ที่โต เพื่อ 1) ยืนยัน histological diagnosis (ชนิดของมะเร็ง) 2) ประเมิน Breslow thickness ของ melanoma (ถ้าเป็น melanoma) 3) ประเมิน staging โดยดูว่า lymph node มี metastasis หรือไม่\n\nผลพยาธิวิทยาจะเป็นตัวกำหนดแนวทางการรักษาที่เหมาะสม ไม่ว่าจะเป็น wide excision, lymph node dissection, chemotherapy หรือ immunotherapy",
      choices: [
        {label: "A", text: "Biopsy ของแผลและ lymph node", is_correct: true, explanation: "ถูกต้อง ต้อง biopsy ทั้งแผลที่ฝ่าเท้าและ lymph node เพื่อยืนยันการวินิจฉัย กำหนดชนิดของมะเร็ง staging และวางแผนการรักษาที่เหมาะสม ไม่ควรผ่าตัดโดยไม่ทราบ diagnosis ที่แน่ชัด"},
        {label: "B", text: "Excision ของแผลด้วยความกว้างหลัก", is_correct: false, explanation: "ไม่ถูกต้อง ไม่ควรทำ wide excision โดยไม่ทราบ diagnosis ก่อน เพราะ margin ที่ต้องการจะขึ้นกับชนิดของมะเร็งและ Breslow thickness (melanoma ต้อง 1-2 cm margin ตาม thickness) การทำ excision ก่อน biopsy อาจทำให้ margin ไม่เพียงพอ"},
        {label: "C", text: "Chemotherapy", is_correct: false, explanation: "ไม่ถูกต้อง ไม่ควรให้ chemotherapy โดยไม่มีการวินิจฉัยทางพยาธิวิทยายืนยันก่อน ต้องทราบ histological type และ staging ก่อนจะตัดสินใจเรื่อง systemic therapy"},
        {label: "D", text: "Radiation therapy", is_correct: false, explanation: "ไม่ถูกต้อง Radiation therapy ไม่ใช่ first-line treatment สำหรับ melanoma (melanoma มี radioresistance) และต้องมี tissue diagnosis ก่อนจะพิจารณาการรักษาใดๆ"},
        {label: "E", text: "Local wound care and observation", is_correct: false, explanation: "ไม่ถูกต้อง แผลเรื้อรังที่โตขึ้นเรื่อยๆ มี hyperpigmentation ร่วมกับ lymphadenopathy ต้องสงสัยมะเร็ง การ observe โดยไม่ทำ biopsy จะทำให้เสียโอกาสในการวินิจฉัยและรักษาเร็ว"}
      ],
      key_takeaway: "แผลเรื้อรังที่ฝ่าเท้ามี hyperpigmentation โตขึ้นเรื่อยๆ ร่วมกับ lymphadenopathy ต้องสงสัย acral melanoma ต้อง biopsy ทั้งแผลและ lymph node เพื่อยืนยัน diagnosis ก่อนวางแผนการรักษา"
    }
  },
  {
    id: "3b1bb307-3395-43c4-b6b7-395d89c651e5",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Cruciate incision of the hymen with drainage (การกรีดเยื่อพรหมจรรย์แบบกากบาทพร้อมระบายออก)",
      reason: "เด็กหญิงอายุ 14 ปี มาด้วยอาการปวดท้องเรื้อรัง (cyclic pelvic pain) ตรวจร่างกายพบ HR 100 bpm, suprapubic tenderness และที่สำคัญที่สุดคือพบ bulging bluish membrane ระหว่าง labia majora ซึ่งเป็น classic presentation ของ imperforate hymen with hematocolpos\n\nImperforate hymen เป็นความผิดปกติแต่กำเนิดที่เยื่อพรหมจรรย์ปิดสนิทไม่มีรู เมื่อเด็กหญิงเข้าสู่วัยเจริญพันธุ์และเริ่มมีประจำเดือน เลือดประจำเดือนจะสะสมอยู่ในช่องคลอด (hematocolpos) ทำให้ช่องคลอดขยายตัว เยื่อพรหมจรรย์โป่งพองและมีสีม่วงเข้ม/น้ำเงิน (bluish bulging membrane) จากเลือดที่ขังอยู่ด้านใน ถ้าสะสมมากอาจขยายเข้าไปถึงมดลูก (hematometra) และ fallopian tubes (hematosalpinx)\n\nการรักษาที่เหมาะสมคือ cruciate incision (กรีดรูปกากบาท) ของ hymen เพื่อเปิดทางให้เลือดระบายออก และป้องกันไม่ให้ hymen กลับมาปิดอีก (ต่างจาก simple linear incision ที่อาจปิดกลับ) หลังกรีดจะเย็บขอบแผลเพื่อให้ epithelialization ที่ดี\n\nเป็นหัตถการที่ simple แต่ต้องทำอย่างเร่งด่วนเพื่อป้องกัน retrograde menstruation ที่อาจนำไปสู่ endometriosis หรือ tubal damage ที่ส่งผลต่อ fertility ในอนาคต",
      choices: [
        {label: "A", text: "Cruciate incision of the hymen with drainage", is_correct: true, explanation: "ถูกต้อง เป็น definitive treatment สำหรับ imperforate hymen with hematocolpos การกรีดแบบ cruciate (กากบาท) ช่วยให้ระบายเลือดออกได้ดีและป้องกันการปิดกลับของ hymen"},
        {label: "B", text: "Complete mass excision and suturing", is_correct: false, explanation: "ไม่ถูกต้อง ไม่จำเป็นต้อง excise ทั้งหมด (complete excision) เพียง cruciate incision ก็เพียงพอ การ excise มากเกินไปอาจทำลาย introitus anatomy และทำให้เกิด scarring"},
        {label: "C", text: "Kegel exercises for pelvic floor strengthening", is_correct: false, explanation: "ไม่ถูกต้อง Kegel exercises ไม่มีบทบาทในการรักษา imperforate hymen ซึ่งเป็น structural anomaly ที่ต้องแก้ไขด้วยการผ่าตัด"},
        {label: "D", text: "Hormonal therapy to suppress menstruation", is_correct: false, explanation: "ไม่ถูกต้อง Hormonal therapy อาจช่วย suppress menstruation ชั่วคราว แต่ไม่แก้ปัญหา obstruction และเลือดที่สะสมอยู่แล้วก็ยังต้องระบายออก ไม่ใช่ definitive treatment"},
        {label: "E", text: "Observation and pain management only", is_correct: false, explanation: "ไม่ถูกต้อง การ observe ไม่เหมาะสมเพราะเลือดจะสะสมมากขึ้นเรื่อยๆ ทำให้เกิด hematometra, hematosalpinx และ retrograde menstruation ซึ่งอาจนำไปสู่ endometriosis และ infertility"}
      ],
      key_takeaway: "เด็กหญิงวัยรุ่นที่มี cyclic pelvic pain ร่วมกับ bulging bluish membrane ที่ introitus ให้วินิจฉัย imperforate hymen with hematocolpos การรักษาคือ cruciate incision of the hymen"
    }
  }
];

async function main() {
  console.log("Starting batch 240-259 update...");
  let success = 0, fail = 0;
  for (const item of explanations) {
    const { error } = await supabase
      .from('mcq_questions')
      .update({ detailed_explanation: item.detailed_explanation })
      .eq('id', item.id);
    if (error) {
      console.error(`FAIL ${item.id}:`, error.message);
      fail++;
    } else {
      console.log(`OK ${item.id}`);
      success++;
    }
  }
  console.log(`\nDone: ${success} success, ${fail} fail out of ${explanations.length}`);
}
main();
