const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: '.env.local' });
const supabase = createClient(process.env.NEXT_PUBLIC_SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY);

const explanations = [
  {
    id: "005fe56f-5a4a-4298-abf6-0ec06265f642",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Clostridium difficile (เชื้อแบคทีเรียที่ก่อโรคท้องเสียจากการใช้ยาปฏิชีวนะ)",
      reason: "ผู้ป่วยที่ได้รับยาปฏิชีวนะในโรงพยาบาล (hospital-acquired pneumonia) มีความเสี่ยงสูงต่อการติดเชื้อ Clostridium difficile เนื่องจากยาปฏิชีวนะทำลาย normal flora ในลำไส้ ทำให้ C. difficile ซึ่งสร้างสปอร์ทนทานต่อยาปฏิชีวนะ เจริญเติบโตแทนที่และสร้าง toxin A และ B ทำให้เกิด pseudomembranous colitis มีอาการท้องเสียเป็นน้ำ ปวดท้อง ไข้ และ leukocytosis",
      choices: [
        {label: "A", text: "Clostridium difficile", is_correct: true, explanation: "ถูกต้อง: เป็นสาเหตุที่พบบ่อยที่สุดของ antibiotic-associated diarrhea โดยเฉพาะหลังใช้ clindamycin, fluoroquinolones หรือ broad-spectrum cephalosporins วินิจฉัยด้วยการตรวจ toxin ในอุจจาระ"},
        {label: "B", text: "Entamoeba histolytica", is_correct: false, explanation: "ไม่ถูกต้อง: เป็นเชื้อปรสิตที่ทำให้เกิด amoebic dysentery มักพบในพื้นที่ที่สุขาภิบาลไม่ดี ไม่สัมพันธ์กับการใช้ยาปฏิชีวนะ"},
        {label: "C", text: "Recurrent hospital-acquired pneumonia", is_correct: false, explanation: "ไม่ถูกต้อง: การกลับเป็นซ้ำของ pneumonia ไม่ได้ทำให้เกิดอาการท้องเสีย อาการหลักของ pneumonia คือไข้ ไอ หอบเหนื่อย"},
        {label: "D", text: "Pseudomonas aeruginosa", is_correct: false, explanation: "ไม่ถูกต้อง: แม้เป็นเชื้อที่พบบ่อยใน hospital-acquired infection แต่มักทำให้เกิด pneumonia, UTI หรือ wound infection มากกว่า ไม่ใช่สาเหตุหลักของ antibiotic-associated diarrhea"},
        {label: "E", text: "Candida albicans", is_correct: false, explanation: "ไม่ถูกต้อง: เป็นเชื้อราที่อาจเพิ่มจำนวนหลังใช้ยาปฏิชีวนะ แต่มักทำให้เกิด oral thrush หรือ vaginal candidiasis มากกว่า diarrhea"}
      ],
      key_takeaway: "ผู้ป่วยที่ได้รับยาปฏิชีวนะแล้วมีอาการท้องเสีย ต้องนึกถึง C. difficile infection เสมอ โดยเฉพาะในผู้ป่วยที่นอนโรงพยาบาล"
    }
  },
  {
    id: "00787001-5441-4f10-b03b-988cb26b974c",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: C. Esophageal perforation (หลอดอาหารทะลุ)",
      reason: "ผู้ป่วยที่มาทำ esophageal dilatation มีความเสี่ยงสูงต่อ esophageal perforation ซึ่งเป็นภาวะแทรกซ้อนที่พบได้บ่อยและอันตรายที่สุดของหัตถการนี้ อาการแสดงหลังทำหัตถการ ได้แก่ เจ็บหน้าอกรุนแรง หายใจลำบาก ไข้ และอาจพบ subcutaneous emphysema ที่คอ การวินิจฉัยยืนยันด้วย water-soluble contrast esophagography หรือ CT chest ต้องรักษาอย่างเร่งด่วนเพราะอาจนำไปสู่ mediastinitis และ sepsis",
      choices: [
        {label: "A", text: "Pneumothorax", is_correct: false, explanation: "ไม่ถูกต้อง: แม้อาจเกิดร่วมกับ esophageal perforation ได้ แต่ไม่ใช่ภาวะแทรกซ้อนโดยตรงของ esophageal dilatation"},
        {label: "B", text: "Pulmonary embolism", is_correct: false, explanation: "ไม่ถูกต้อง: ไม่สัมพันธ์กับหัตถการ esophageal dilatation PE มักเกิดจาก deep vein thrombosis"},
        {label: "C", text: "Esophageal perforation", is_correct: true, explanation: "ถูกต้อง: เป็นภาวะแทรกซ้อนที่สำคัญที่สุดของ esophageal dilatation เกิดจากแรงกดที่มากเกินไปทำให้ผนังหลอดอาหารฉีกขาด ต้องวินิจฉัยและรักษาอย่างเร่งด่วน"},
        {label: "D", text: "Acute myocardial infarction", is_correct: false, explanation: "ไม่ถูกต้อง: ไม่สัมพันธ์โดยตรงกับหัตถการ esophageal dilatation แม้อาการเจ็บหน้าอกอาจคล้ายกันแต่กลไกต่างกัน"},
        {label: "E", text: "Pericarditis", is_correct: false, explanation: "ไม่ถูกต้อง: ไม่ใช่ภาวะแทรกซ้อนที่พบบ่อยของ esophageal dilatation มักเกิดจากไวรัสหรือภูมิคุ้มกัน"}
      ],
      key_takeaway: "Esophageal perforation เป็นภาวะแทรกซ้อนที่อันตรายที่สุดของ esophageal dilatation ต้องสงสัยเสมอเมื่อมีอาการเจ็บหน้าอกหลังทำหัตถการ"
    }
  },
  {
    id: "00a5caa1-8ff5-46f7-a7e4-44b1308e3372",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Paracetamol toxicity (พิษจากยาพาราเซตามอล)",
      reason: "ผู้ป่วยตับแข็งจาก alcoholic cirrhosis ที่ไปซื้อยากินเอง มีความเสี่ยงสูงมากต่อ paracetamol toxicity เนื่องจากตับที่เสียหายอยู่แล้วมีความสามารถในการ metabolize paracetamol ลดลง ทำให้ toxic metabolite (NAPQI) สะสมมากขึ้น นอกจากนี้ผู้ป่วยโรคตับมักมี glutathione ต่ำ ซึ่ง glutathione เป็นสารสำคัญในการกำจัด NAPQI ดังนั้นแม้ได้รับ paracetamol ในขนาดปกติก็อาจเกิดพิษได้",
      choices: [
        {label: "A", text: "Paracetamol toxicity", is_correct: true, explanation: "ถูกต้อง: ผู้ป่วย cirrhosis มี glutathione stores ต่ำและ CYP2E1 ถูกกระตุ้นจากแอลกอฮอล์ ทำให้สร้าง NAPQI มากขึ้น เกิด hepatotoxicity ได้แม้ในขนาดปกติ"},
        {label: "B", text: "Acute viral hepatitis", is_correct: false, explanation: "ไม่ถูกต้อง: แม้อาจเกิดร่วมได้ แต่ประวัติบ่งชี้ว่าซื้อยากินเอง จึงต้องนึกถึง drug-induced cause ก่อน"},
        {label: "C", text: "Alcoholic hepatitis", is_correct: false, explanation: "ไม่ถูกต้อง: แม้ผู้ป่วยมี alcoholic cirrhosis แต่อาการกำเริบเฉียบพลันหลังซื้อยากินเอง บ่งชี้ถึงสาเหตุจากยามากกว่า"},
        {label: "D", text: "Acute cholangitis", is_correct: false, explanation: "ไม่ถูกต้อง: cholangitis มักมีอาการ Charcot's triad (ไข้ ดีซ่าน ปวดท้องด้านขวาบน) และสัมพันธ์กับ bile duct obstruction ไม่ใช่การกินยา"},
        {label: "E", text: "Drug-induced liver injury from paracetamol in cirrhotic patient", is_correct: false, explanation: "ไม่ถูกต้อง: แม้ความหมายใกล้เคียงกับข้อ A แต่ paracetamol toxicity เป็นคำที่ถูกต้องกว่าและเฉพาะเจาะจงกว่า"}
      ],
      key_takeaway: "ผู้ป่วย alcoholic cirrhosis มีความเสี่ยงต่อ paracetamol toxicity สูงมาก แม้ในขนาดปกติ เพราะ glutathione ต่ำและ CYP2E1 ถูกกระตุ้น"
    }
  },
  {
    id: "00a6f910-7552-46b2-b94a-a3875ed4a751",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. ใส่เฝือกแขนท่อนบนและท่อนล่าง",
      reason: "ผู้ป่วยตกจากที่สูงมีแขนผิดรูป ปวดบวม กระดกข้อมือไม่ได้ ซึ่งบ่งชี้ว่ามีกระดูกหักบริเวณแขน อาการกระดกข้อมือไม่ได้อาจเกิดจากอาการปวดและบวม (pain inhibition) มากกว่า nerve injury โดยตรง การรักษาเบื้องต้นที่เหมาะสมคือการใส่เฝือก (immobilization) คลุมทั้งแขนท่อนบนและท่อนล่างเพื่อลดการเคลื่อนไหวที่ตำแหน่งกระดูกหัก ลดอาการปวด และป้องกันการบาดเจ็บเพิ่มเติม",
      choices: [
        {label: "A", text: "ใส่เฝือกแขนท่อนบนและท่อนล่าง", is_correct: true, explanation: "ถูกต้อง: เป็นการรักษาเบื้องต้นที่เหมาะสมสำหรับ fracture ที่ไม่ซับซ้อน การ immobilize ทั้งข้อต่อเหนือและใต้ตำแหน่งหักช่วยลดปวดและป้องกัน displacement"},
        {label: "B", text: "ทำ EMG และใส่เฝือกแขนท่อนบนและท่อนล่าง", is_correct: false, explanation: "ไม่ถูกต้อง: EMG ไม่จำเป็นในระยะเฉียบพลัน เพราะ nerve conduction จะยังไม่เปลี่ยนแปลงในช่วงแรก ต้องรออย่างน้อย 2-3 สัปดาห์"},
        {label: "C", text: "ผ่าตัดดามกระดูกและต่อเส้นประสาท", is_correct: false, explanation: "ไม่ถูกต้อง: ยังไม่มีข้อบ่งชี้ชัดเจนว่ามี nerve injury ที่ต้องผ่าตัดต่อเส้นประสาท การกระดกข้อมือไม่ได้อาจเกิดจากอาการปวด"},
        {label: "D", text: "ผ่าตัดดามกระดูกและใส่เฝือกท่อนบนและท่อนล่าง", is_correct: false, explanation: "ไม่ถูกต้อง: ยังไม่มีข้อบ่งชี้ในการผ่าตัดดามกระดูก (ORIF) ในกรณีนี้ การรักษาแบบ conservative ด้วยเฝือกเพียงพอ"},
        {label: "E", text: "ผ่าตัดต่อเส้นประสาทและใส่เฝือกแขนท่อนบน", is_correct: false, explanation: "ไม่ถูกต้อง: ไม่มีข้อบ่งชี้ในการผ่าตัดต่อเส้นประสาท ต้องประเมินซ้ำหลัง immobilization ก่อน"}
      ],
      key_takeaway: "กระดูกแขนหักที่ไม่ซับซ้อน ให้ immobilize ด้วยเฝือกคลุมข้อต่อเหนือและใต้ตำแหน่งหัก อาการ wrist drop อาจเกิดจากปวดไม่ใช่ nerve injury เสมอไป"
    }
  },
  {
    id: "00bc4de4-e876-494f-b8c0-2cc91cc3b6bc",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: B. ตรวจประเมินความเสี่ยง neurovascular compromise",
      reason: "เด็กชาย 6 ปี ล้มจากที่สูงกระแทกข้อศอก มีอาการบวมที่ด้านนอก สิ่งแรกที่ต้องทำคือประเมิน neurovascular status เพราะ fracture บริเวณข้อศอก (โดยเฉพาะ lateral condyle fracture) มีความเสี่ยงสูงต่อ vascular injury (brachial artery) และ nerve injury (radial, median, ulnar nerves) การประเมินนี้จะกำหนดแนวทางการรักษาต่อไปว่าต้องผ่าตัดเร่งด่วนหรือไม่",
      choices: [
        {label: "A", text: "ผ่าตัดลอยตัวแบบเร่งด่วน", is_correct: false, explanation: "ไม่ถูกต้อง: ก่อนตัดสินใจผ่าตัด ต้องประเมิน neurovascular status ก่อนเสมอ การผ่าตัดทันทีโดยไม่ประเมินอาจพลาดภาวะ vascular compromise"},
        {label: "B", text: "ตรวจประเมินความเสี่ยง neurovascular compromise", is_correct: true, explanation: "ถูกต้อง: เป็นขั้นตอนแรกที่สำคัญที่สุด ต้องตรวจ pulse (radial, ulnar), capillary refill, sensation และ motor function ของมือ เพื่อประเมินว่ามี vascular หรือ nerve injury หรือไม่"},
        {label: "C", text: "บรรจุน้ำแข็งและยาแก้ปวดทันที", is_correct: false, explanation: "ไม่ถูกต้อง: แม้การลดปวดสำคัญ แต่ต้องประเมิน neurovascular status ก่อน เพราะถ้ามี vascular compromise ต้องรักษาอย่างเร่งด่วน"},
        {label: "D", text: "จำกัดการเคลื่อนไหวด้วย posterior slab splint", is_correct: false, explanation: "ไม่ถูกต้อง: การ splint เป็นการรักษาเบื้องต้นที่ดี แต่ต้องประเมิน neurovascular status ก่อน splint เพื่อไม่ให้พลาด compartment syndrome"},
        {label: "E", text: "ลด fracture ด้วยวิธี closed reduction", is_correct: false, explanation: "ไม่ถูกต้อง: ยังไม่ควร reduce ทันทีโดยไม่ประเมิน neurovascular status ก่อน และ lateral condyle fracture มักต้อง open reduction"}
      ],
      key_takeaway: "Elbow fracture ในเด็ก ต้องประเมิน neurovascular status เป็นอันดับแรกเสมอ เพราะมีความเสี่ยงต่อ brachial artery และ nerve injury สูง"
    }
  },
  {
    id: "00c22aef-d4ce-4ad6-9bba-201cb5dac825",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Heat stroke (โรคลมแดด)",
      reason: "ชายอายุ 40 ปี แข็งแรงดี วิ่งมาราธอน 5-10 km แล้วเริ่มเหนื่อย วิ่งต่อไม่ไหว อาการนี้บ่งชี้ถึง exertional heat stroke ซึ่งเกิดจากการออกกำลังกายหนักในสภาพอากาศร้อน ร่างกายไม่สามารถระบายความร้อนได้ทัน ทำให้อุณหภูมิกายสูงขึ้นจนกระทบระบบประสาทส่วนกลาง มีอาการสับสน อ่อนเพลีย และอาจหมดสติ เป็นภาวะฉุกเฉินที่ต้องลดอุณหภูมิกายอย่างรวดเร็ว",
      choices: [
        {label: "A", text: "Heat stroke", is_correct: true, explanation: "ถูกต้อง: เป็น exertional heat stroke ที่พบบ่อยในนักวิ่ง อาการสำคัญคืออุณหภูมิกาย >40°C ร่วมกับอาการทางระบบประสาท ต้องลดอุณหภูมิทันที"},
        {label: "B", text: "TIA", is_correct: false, explanation: "ไม่ถูกต้อง: TIA มักมีอาการ focal neurological deficit เช่น แขนขาอ่อนแรงครึ่งซีก พูดไม่ชัด ไม่สัมพันธ์กับการออกกำลังกายโดยตรง"},
        {label: "C", text: "Acute MI", is_correct: false, explanation: "ไม่ถูกต้อง: ชายอายุ 40 ปีแข็งแรงดี ความเสี่ยง MI ต่ำ และอาการหลักของ MI คือเจ็บหน้าอก ไม่ใช่แค่เหนื่อยหลังวิ่ง"},
        {label: "D", text: "Pulmonary embolism", is_correct: false, explanation: "ไม่ถูกต้อง: PE มักเกิดในผู้ที่นั่งนิ่งนานหรือมี risk factors เช่น DVT ไม่สัมพันธ์กับการออกกำลังกาย อาการหลักคือหอบเหนื่อยเฉียบพลัน"},
        {label: "E", text: "Intracerebral hemorrhage", is_correct: false, explanation: "ไม่ถูกต้อง: มักเกิดในผู้ที่มี HT หรือ vascular malformation อาการหลักคือปวดศีรษะรุนแรงเฉียบพลันและ focal neurological deficit"}
      ],
      key_takeaway: "นักวิ่งที่มีอาการเหนื่อยผิดปกติระหว่างออกกำลังกาย ต้องนึกถึง exertional heat stroke เสมอ โดยเฉพาะในสภาพอากาศร้อน"
    }
  },
  {
    id: "00ec9122-097d-4592-82ad-addd3e27662f",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Carbon monoxide (ก๊าซคาร์บอนมอนอกไซด์)",
      reason: "นักท่องเที่ยวกางเต็นท์จุดตะเกียงในเต็นท์ปิด เป็นสถานการณ์คลาสสิกของ carbon monoxide (CO) poisoning เนื่องจากการเผาไหม้ที่ไม่สมบูรณ์ในที่อับอากาศจะสร้าง CO ซึ่งเป็นก๊าซไม่มีสี ไม่มีกลิ่น CO จับกับ hemoglobin ได้ดีกว่า O2 ถึง 200-250 เท่า ทำให้เกิด carboxyhemoglobin (COHb) ลดการขนส่ง O2 ไปเลี้ยงเนื้อเยื่อ ทำให้เสียชีวิตได้",
      choices: [
        {label: "A", text: "Carbon monoxide", is_correct: true, explanation: "ถูกต้อง: การเผาไหม้ไม่สมบูรณ์ในที่อับอากาศสร้าง CO ซึ่งจับ Hb ได้แน่นกว่า O2 200-250 เท่า ผิวหนังผู้เสียชีวิตจะมีสี cherry red จากการจับกับ COHb"},
        {label: "B", text: "Ozone", is_correct: false, explanation: "ไม่ถูกต้อง: Ozone เป็นก๊าซที่พบในชั้นบรรยากาศ ไม่ได้เกิดจากการเผาไหม้ตะเกียง"},
        {label: "C", text: "Sulfur dioxide", is_correct: false, explanation: "ไม่ถูกต้อง: SO2 เกิดจากการเผาไหม้เชื้อเพลิงที่มีกำมะถัน เช่น ถ่านหิน ไม่ใช่จากตะเกียงทั่วไป และมีกลิ่นฉุน"},
        {label: "D", text: "Carbon dioxide", is_correct: false, explanation: "ไม่ถูกต้อง: CO2 เกิดจากการเผาไหม้สมบูรณ์ แม้สะสมได้ในที่อับอากาศ แต่ต้องมีความเข้มข้นสูงมากจึงเป็นอันตราย CO มีพิษรุนแรงกว่ามาก"},
        {label: "E", text: "Nitrogen dioxide", is_correct: false, explanation: "ไม่ถูกต้อง: NO2 เกิดจากกระบวนการอุตสาหกรรมและเครื่องยนต์ดีเซล ไม่ใช่จากตะเกียงในเต็นท์"}
      ],
      key_takeaway: "การเผาไหม้ในที่อับอากาศ = CO poisoning เสมอ CO เป็นก๊าซไม่มีสีไม่มีกลิ่น จับ Hb ได้ดีกว่า O2 200-250 เท่า"
    }
  },
  {
    id: "00f04927-409b-469d-ba12-106bf939933c",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Reassurance and breathing exercise (ให้ความมั่นใจและฝึกการหายใจ)",
      reason: "คู่รักมาโรงพยาบาลหลังเลิกกัน ฝ่ายหญิงมีอาการที่เข้าได้กับ hyperventilation syndrome จากความเครียดทางอารมณ์ การรักษาเบื้องต้นที่เหมาะสมที่สุดคือ reassurance (ให้ความมั่นใจ) ร่วมกับ breathing exercise (ฝึกหายใจช้าๆ ลึกๆ) เพื่อลดอัตราการหายใจและแก้ไข respiratory alkalosis ที่เกิดจากการหายใจเร็วเกินไป",
      choices: [
        {label: "A", text: "Reassurance and breathing exercise", is_correct: true, explanation: "ถูกต้อง: เป็นการรักษาแรกที่เหมาะสมสำหรับ hyperventilation syndrome จากความเครียด ช่วยลดอาการโดยไม่ต้องใช้ยา"},
        {label: "B", text: "Re-breathing using a paper bag", is_correct: false, explanation: "ไม่ถูกต้อง: แม้เคยใช้กันแพร่หลาย แต่ปัจจุบันไม่แนะนำเพราะอาจทำให้ hypoxia ได้ในกรณีที่มีโรคหัวใจหรือปอดซ่อนอยู่"},
        {label: "C", text: "Diazepam", is_correct: false, explanation: "ไม่ถูกต้อง: ยา benzodiazepine ไม่ใช่ first-line treatment สำหรับ hyperventilation syndrome ใช้เฉพาะกรณีที่มี severe anxiety ที่ไม่ตอบสนองต่อ non-pharmacological treatment"},
        {label: "D", text: "Oxygen therapy", is_correct: false, explanation: "ไม่ถูกต้อง: ผู้ป่วย hyperventilation มี O2 saturation ปกติหรือสูง การให้ O2 เพิ่มไม่ช่วยและอาจทำให้ผู้ป่วยกังวลเพิ่ม"},
        {label: "E", text: "Intubation", is_correct: false, explanation: "ไม่ถูกต้อง: ไม่มีข้อบ่งชี้ในการ intubation สำหรับ hyperventilation syndrome เป็น overtreatment ที่อันตราย"}
      ],
      key_takeaway: "Hyperventilation syndrome จากความเครียด ให้รักษาด้วย reassurance + controlled breathing exercise เป็นอันดับแรก ไม่ต้องใช้ยาหรือหัตถการ"
    }
  },
  {
    id: "00fff64f-d910-42ce-a08b-53c9a64a4f11",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: B. Glucose tolerance test (การตรวจความทนต่อกลูโคส)",
      reason: "เด็กชายอายุ 10 ปี พบ acanthosis nigricans ซึ่งเป็นสัญญาณของ insulin resistance ร่วมกับประวัติครอบครัวที่บิดาและยายเป็นเบาหวาน บ่งชี้ว่าเด็กมีความเสี่ยงสูงต่อ type 2 diabetes mellitus หรือ prediabetes การตรวจที่เหมาะสมคือ glucose tolerance test (OGTT) เพื่อประเมินว่ามี impaired glucose tolerance หรือเป็นเบาหวานแล้วหรือไม่",
      choices: [
        {label: "A", text: "Chromosome study", is_correct: false, explanation: "ไม่ถูกต้อง: ไม่มีข้อบ่งชี้ในการตรวจโครโมโซม เพราะไม่ได้สงสัย genetic syndrome ที่เกี่ยวข้อง"},
        {label: "B", text: "Glucose tolerance test", is_correct: true, explanation: "ถูกต้อง: Acanthosis nigricans + family history of DM บ่งชี้ insulin resistance สูง OGTT เป็นการตรวจที่ sensitive ที่สุดในการวินิจฉัย prediabetes และ diabetes"},
        {label: "C", text: "Growth hormone test", is_correct: false, explanation: "ไม่ถูกต้อง: ไม่มีข้อบ่งชี้เรื่อง growth hormone deficiency จากข้อมูลที่ให้มา acanthosis nigricans ไม่สัมพันธ์กับ GH abnormality"},
        {label: "D", text: "Dexamethasone suppression test", is_correct: false, explanation: "ไม่ถูกต้อง: ใช้สำหรับวินิจฉัย Cushing syndrome แม้อาจมี acanthosis nigricans ได้ แต่ family history of DM ชี้ไปทาง insulin resistance มากกว่า"},
        {label: "E", text: "24-hour free cortisol test", is_correct: false, explanation: "ไม่ถูกต้อง: ใช้ screen Cushing syndrome เช่นกัน ไม่ใช่ first-line investigation ในเด็กที่มี acanthosis nigricans + DM family history"}
      ],
      key_takeaway: "Acanthosis nigricans ในเด็ก + family history of DM = insulin resistance ต้องตรวจ OGTT เพื่อ screen diabetes/prediabetes"
    }
  },
  {
    id: "0135cec9-ebca-42d8-830e-a56add6619df",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: E. Chromosomal abnormalities (ความผิดปกติของโครโมโซม)",
      reason: "หญิงอายุ 34 ปี ตั้งครรภ์ 3 ครั้ง แท้งทั้ง 3 ครั้งในอายุครรภ์ 7, 11 และ 8 สัปดาห์ ซึ่งเป็น recurrent first trimester abortion (แท้งซ้ำในไตรมาสแรก) สาเหตุที่พบบ่อยที่สุดของการแท้งในไตรมาสแรก คือ chromosomal abnormalities ของตัวอ่อน พบได้ถึง 50-60% ของการแท้งในช่วงนี้ ที่พบบ่อยได้แก่ trisomy, monosomy X และ polyploidy",
      choices: [
        {label: "A", text: "Myoma uteri", is_correct: false, explanation: "ไม่ถูกต้อง: Myoma อาจทำให้แท้งได้ แต่มักเป็นสาเหตุของ second trimester loss มากกว่า และมักมีอาการอื่นร่วม เช่น ประจำเดือนมาก"},
        {label: "B", text: "Bicornuate uterus", is_correct: false, explanation: "ไม่ถูกต้อง: ความผิดปกติของมดลูกมักทำให้แท้งในไตรมาสที่ 2 มากกว่าไตรมาสแรก เพราะปัญหาอยู่ที่พื้นที่ไม่พอสำหรับทารกที่โตขึ้น"},
        {label: "C", text: "Infection", is_correct: false, explanation: "ไม่ถูกต้อง: การติดเชื้อเป็นสาเหตุของการแท้งที่พบได้น้อย และมักไม่ทำให้แท้งซ้ำในรูปแบบเดียวกันทุกครั้ง"},
        {label: "D", text: "Cervical incompetence", is_correct: false, explanation: "ไม่ถูกต้อง: Cervical incompetence ทำให้แท้งในไตรมาสที่ 2 (16-24 สัปดาห์) ไม่ใช่ไตรมาสแรก อาการคือปากมดลูกเปิดโดยไม่เจ็บครรภ์"},
        {label: "E", text: "Chromosomal abnormalities", is_correct: true, explanation: "ถูกต้อง: เป็นสาเหตุที่พบบ่อยที่สุดของ recurrent first trimester abortion พบได้ 50-60% ควรส่งตรวจ karyotype ทั้งสามีและภรรยา"}
      ],
      key_takeaway: "Recurrent abortion ในไตรมาสแรก (< 12 สัปดาห์) สาเหตุที่พบบ่อยที่สุดคือ chromosomal abnormalities ส่วนไตรมาสที่ 2 นึกถึง cervical incompetence และ uterine anomaly"
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
