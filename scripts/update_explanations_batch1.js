require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

const explanations = [
  {
    id: "005fe56f-5a4a-4298-abf6-0ec06265f642",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Clostridium difficile (การติดเชื้อ C. difficile หลังใช้ยาปฏิชีวนะ)",
      reason: `ผู้ป่วยรายนี้เข้ารับการรักษาด้วยโรค hospital-acquired pneumonia และได้รับยาปฏิชีวนะร่วมกับ vancomycin เป็นเวลา 7 วัน หลังจากอาการดีขึ้นแล้วกลับมามีอาการท้องเสียและไข้อีกครั้ง ซึ่งเป็นลักษณะทางคลินิกที่คลาสสิกของการติดเชื้อ Clostridioides difficile (เดิมชื่อ Clostridium difficile) ที่เกิดขึ้นหลังการใช้ยาปฏิชีวนะ

พยาธิสรีรวิทยาของ C. difficile infection (CDI) เริ่มจากการที่ยาปฏิชีวนะทำลาย normal flora ในลำไส้ใหญ่ ทำให้เกิด ecological niche ที่เปิดโอกาสให้ C. difficile ซึ่งเป็น spore-forming anaerobic gram-positive bacillus เจริญเติบโตและสร้าง toxin A (enterotoxin) และ toxin B (cytotoxin) ขึ้นมา toxin เหล่านี้จะทำลาย tight junction ของเซลล์เยื่อบุลำไส้ กระตุ้นการอักเสบ และทำให้เกิด pseudomembranous colitis

ยาปฏิชีวนะที่มีความเสี่ยงสูงในการทำให้เกิด CDI ได้แก่ fluoroquinolones, clindamycin, cephalosporins (โดยเฉพาะรุ่นที่ 3) และ broad-spectrum penicillins แม้ว่า vancomycin ที่ให้ทาง IV จะไม่ค่อยเป็นสาเหตุหลักเพราะไม่ถูกขับออกทางลำไส้มากนัก แต่การใช้ยาปฏิชีวนะอื่นร่วมด้วยเป็นปัจจัยเสี่ยงสำคัญ

ปัจจัยเสี่ยงอื่นๆ ของ CDI ได้แก่ การนอนโรงพยาบาลนาน (hospital-acquired), อายุมาก, การใช้ proton pump inhibitors, และภาวะภูมิคุ้มกันต่ำ อาการทางคลินิกที่สำคัญได้แก่ watery diarrhea (มักมีกลิ่นเหม็นเฉพาะตัว), ไข้, ปวดท้อง, และ leukocytosis การวินิจฉัยยืนยันทำได้โดยตรวจหา C. difficile toxin ในอุจจาระ หรือ PCR สำหรับ toxin gene`,
      choices: [
        { label: "A", text: "Clostridium difficile", is_correct: true, explanation: "ถูกต้อง เพราะ C. difficile เป็นสาเหตุที่พบบ่อยที่สุดของ antibiotic-associated diarrhea ในผู้ป่วยที่นอนโรงพยาบาล โดยเฉพาะหลังได้รับยาปฏิชีวนะแบบ broad-spectrum อาการมักเกิดขึ้นหลังจากเริ่มใช้ยาปฏิชีวนะ 5-10 วัน หรืออาจนานถึงหลายสัปดาห์หลังหยุดยา" },
        { label: "B", text: "Entamoeba histolytica", is_correct: false, explanation: "ไม่ถูกต้อง เพราะ E. histolytica ทำให้เกิด amoebic dysentery ที่มักมีอาการถ่ายเป็นเลือดและมูก (bloody mucoid diarrhea) ไม่ใช่ watery diarrhea และมักเกิดจากการรับประทานอาหารหรือน้ำที่ปนเปื้อน ไม่เกี่ยวข้องกับการใช้ยาปฏิชีวนะโดยตรง" },
        { label: "C", text: "Recurrent hospital-acquired pneumonia", is_correct: false, explanation: "ไม่ถูกต้อง เพราะ recurrent pneumonia จะมีอาการทางระบบทางเดินหายใจเป็นหลัก เช่น ไอ เสมหะ หอบเหนื่อย ไม่ใช่ท้องเสีย แม้จะมีไข้ร่วมด้วยก็ตาม การที่ผู้ป่วยมีอาการ diarrhea เป็นหลักบ่งชี้ปัญหาทางระบบทางเดินอาหารมากกว่า" },
        { label: "D", text: "Pseudomonas aeruginosa", is_correct: false, explanation: "ไม่ถูกต้อง เพราะ Pseudomonas aeruginosa เป็นสาเหตุของ hospital-acquired pneumonia ได้ แต่ไม่ใช่สาเหตุหลักของ antibiotic-associated diarrhea ถ้า Pseudomonas เป็นสาเหตุของอาการใหม่ มักจะเป็น pneumonia ที่แย่ลง ไม่ใช่ diarrhea" },
        { label: "E", text: "Candida albicans", is_correct: false, explanation: "ไม่ถูกต้อง เพราะ Candida albicans อาจเจริญเติบโตมากขึ้นหลังใช้ยาปฏิชีวนะ แต่มักทำให้เกิด oral thrush หรือ esophageal candidiasis มากกว่า diarrhea แม้ว่า Candida จะสามารถพบในอุจจาระได้ แต่มักไม่เป็นสาเหตุหลักของ antibiotic-associated diarrhea ที่รุนแรง" }
      ],
      key_takeaway: "C. difficile infection เป็นสาเหตุที่พบบ่อยที่สุดของ antibiotic-associated diarrhea ในผู้ป่วยที่นอนโรงพยาบาล ควรนึกถึงเสมอเมื่อผู้ป่วยมี diarrhea หลังได้รับยาปฏิชีวนะ โดยเฉพาะ broad-spectrum antibiotics"
    }
  },
  {
    id: "00787001-5441-4f10-b03b-988cb26b974c",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: C. Esophageal perforation (หลอดอาหารทะลุหลังทำหัตถการขยายหลอดอาหาร)",
      reason: `ผู้ป่วยหญิงอายุ 20 ปี มาทำหัตถการ esophageal dilatation แล้วเกิดอาการแน่นหน้าอก (chest tightness) ภายใน 1 ชั่วโมงหลังหัตถการ ซึ่งเป็นอาการที่ต้องนึกถึง esophageal perforation เป็นอันดับแรก เนื่องจากเป็นภาวะแทรกซ้อนที่สำคัญและอันตรายที่สุดของการทำ esophageal dilatation

พยาธิสรีรวิทยาของ esophageal perforation คือ เมื่อผนังหลอดอาหารถูกฉีกทะลุทุกชั้น (transmural perforation) จะทำให้อากาศ น้ำลาย และเนื้อหาในหลอดอาหารรั่วเข้าสู่ mediastinum ทำให้เกิด mediastinitis ซึ่งเป็นการอักเสบรุนแรงของช่องกลางทรวงอก หากไม่ได้รับการรักษาทันท่วงที อัตราการเสียชีวิตสูงมาก อาจสูงถึง 50% หากวินิจฉัยช้าเกิน 24 ชั่วโมง

อาการของ esophageal perforation ได้แก่ chest pain/tightness (พบมากที่สุด), odynophagia, dyspnea, subcutaneous emphysema (คลำได้ crepitus ที่คอ/หน้าอก) และ Hamman's sign (mediastinal crunch คือเสียง crunching sound ที่ได้ยินตามจังหวะการเต้นของหัวใจ) Mackler's triad ประกอบด้วย vomiting, chest pain, และ subcutaneous emphysema เป็นลักษณะคลาสสิกของ esophageal rupture

การวินิจฉัยทำได้โดย CXR อาจพบ pneumomediastinum, pleural effusion (มักเป็น left-sided), subcutaneous emphysema หรือ wide mediastinum การยืนยันด้วย CT chest with oral contrast หรือ esophagogram ด้วย water-soluble contrast (Gastrografin) การรักษาขึ้นกับขนาดและตำแหน่งของ perforation อาจเป็น conservative treatment (NPO, IV antibiotics, drainage) หรือ surgical repair`,
      choices: [
        { label: "A", text: "Pneumothorax", is_correct: false, explanation: "แม้ว่า pneumothorax จะทำให้แน่นหน้าอกได้ แต่ในบริบทของการทำ esophageal dilatation ภาวะแทรกซ้อนที่ต้องนึกถึงก่อนคือ esophageal perforation Pneumothorax อาจเป็นผลตามมาจาก esophageal perforation ได้ แต่ไม่ใช่สาเหตุหลักที่เกิดจากหัตถการนี้โดยตรง" },
        { label: "B", text: "Pulmonary embolism", is_correct: false, explanation: "Pulmonary embolism มักเกิดจาก deep vein thrombosis และมีปัจจัยเสี่ยงเช่น immobilization, surgery ที่นาน, หรือ hypercoagulable state ผู้ป่วยรายนี้อายุ 20 ปี มาทำหัตถการที่สั้น PE จึงไม่ใช่สาเหตุที่น่าจะเป็นที่สุด และอาการมักเป็น dyspnea, tachycardia, pleuritic chest pain" },
        { label: "C", text: "Esophageal perforation", is_correct: true, explanation: "ถูกต้อง เพราะ esophageal perforation เป็นภาวะแทรกซ้อนที่สำคัญที่สุดของ esophageal dilatation โดยมีอุบัติการณ์ประมาณ 0.1-0.4% อาการ chest tightness ที่เกิดขึ้นภายใน 1 ชั่วโมงหลังหัตถการเป็น red flag ที่สำคัญ ต้องรีบสืบค้นและรักษาทันที" },
        { label: "D", text: "Acute myocardial infarction", is_correct: false, explanation: "ไม่น่าจะเป็น AMI เพราะผู้ป่วยอายุ 20 ปี ซึ่งเป็นอายุที่พบ AMI น้อยมาก และไม่มีปัจจัยเสี่ยงที่ชัดเจน อีกทั้ง timing ที่เกิดหลังทำหัตถการ esophageal dilatation ทำให้ต้องนึกถึงภาวะแทรกซ้อนจากหัตถการมากกว่า" },
        { label: "E", text: "Pericarditis", is_correct: false, explanation: "Pericarditis มักมีอาการ sharp chest pain ที่เจ็บเมื่อหายใจเข้าลึก และมักเป็นจาก viral infection ไม่ใช่ภาวะแทรกซ้อนที่เกิดจาก esophageal dilatation โดยตรง แม้ว่า esophageal perforation ที่รุนแรงอาจลุกลามไปยัง pericardium ได้ แต่ไม่ใช่คำตอบที่ตรงที่สุดในกรณีนี้" }
      ],
      key_takeaway: "Esophageal perforation เป็นภาวะแทรกซ้อนที่อันตรายที่สุดของ esophageal dilatation ต้องนึกถึงเสมอเมื่อผู้ป่วยมีอาการเจ็บหน้าอกหลังทำหัตถการ การวินิจฉัยเร็วและรักษาทันทีเป็นสิ่งสำคัญที่สุดเพื่อลดอัตราการเสียชีวิต"
    }
  },
  {
    id: "00a5caa1-8ff5-46f7-a7e4-44b1308e3372",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Paracetamol toxicity (พิษจากพาราเซตามอลในผู้ป่วยตับแข็ง)",
      reason: `ผู้ป่วยชายอายุ 50 ปี เป็น alcoholic cirrhosis มีไข้ 4 วัน ซื้อ paracetamol กินเอง 500 mg 2 เม็ด ทุก 6 ชั่วโมง (= 4 กรัม/วัน) หลังจากนั้นมีคลื่นไส้อาเจียน ผลเลือดพบ AST 8000, ALT 4000 ซึ่ง ALP ปกติ แสดงถึง hepatocellular injury ที่รุนแรงมาก

พยาธิสรีรวิทยาของ paracetamol toxicity ในผู้ป่วยตับแข็งนั้น ในคนปกติ paracetamol ถูก metabolize ผ่าน 3 ทาง: glucuronidation (40-67%), sulfation (20-46%) และ CYP2E1 oxidation (5-15%) ทาง CYP2E1 จะสร้าง NAPQI (N-acetyl-p-benzoquinone imine) ซึ่งเป็น toxic metabolite ที่ถูก detoxify โดย glutathione ในคนปกติ

ในผู้ป่วยที่ดื่มแอลกอฮอล์เรื้อรัง CYP2E1 จะถูก induced ทำให้มีการสร้าง NAPQI มากขึ้น ในขณะเดียวกัน glutathione stores จะลดลงจากภาวะ malnutrition และ chronic alcohol use ทำให้ NAPQI ที่เกิดขึ้นไม่ถูก detoxify อย่างเพียงพอ ส่งผลให้เกิด hepatocellular necrosis แม้จะใช้ paracetamol ในขนาดที่ถือว่าเป็น therapeutic dose ในคนปกติ (4 กรัม/วัน)

ลักษณะของ paracetamol hepatotoxicity ที่สำคัญคือ AST/ALT สูงมาก (มักเกิน 1000-10000 IU/L) ในขณะที่ ALP ปกติหรือสูงเล็กน้อย ซึ่งเป็น pattern ของ hepatocellular injury ไม่ใช่ cholestatic injury นอกจากนี้ AST มักสูงกว่า ALT ในช่วงแรก เนื่องจาก mitochondrial AST ถูกปล่อยออกมาจาก hepatocyte necrosis

การรักษาคือให้ N-acetylcysteine (NAC) ซึ่งเป็น glutathione precursor เพื่อเพิ่ม glutathione stores และช่วย detoxify NAPQI รวมถึงการรักษาแบบ supportive care`,
      choices: [
        { label: "A", text: "Paracetamol toxicity", is_correct: true, explanation: "ถูกต้อง เพราะผู้ป่วย alcoholic cirrhosis มี CYP2E1 induction ทำให้สร้าง NAPQI มากขึ้น และ glutathione stores ลดลง ทำให้เกิด hepatotoxicity แม้ใช้ paracetamol ในขนาด therapeutic dose ผล lab ที่ AST/ALT สูงมากโดย ALP ปกติ สอดคล้องกับ hepatocellular injury จาก paracetamol" },
        { label: "B", text: "Acute viral hepatitis", is_correct: false, explanation: "แม้ว่า acute viral hepatitis จะทำให้ AST/ALT สูงได้ แต่มักไม่สูงถึงระดับ 8000/4000 ในผู้ป่วยที่ไม่มีปัจจัยเสี่ยงเฉพาะ และ timing ที่เกิดหลังกิน paracetamol ทำให้ paracetamol toxicity เป็นคำตอบที่เหมาะสมกว่า นอกจากนี้ viral hepatitis มักมี prodromal symptoms นานกว่า" },
        { label: "C", text: "Alcoholic hepatitis", is_correct: false, explanation: "Alcoholic hepatitis มักมี AST/ALT สูงไม่เกิน 300-500 IU/L โดย AST:ALT ratio มักมากกว่า 2:1 ค่า AST 8000 และ ALT 4000 สูงเกินกว่าที่จะเกิดจาก alcoholic hepatitis เพียงอย่างเดียว อีกทั้ง alcoholic hepatitis มักมี jaundice เด่น" },
        { label: "D", text: "Acute cholangitis", is_correct: false, explanation: "Acute cholangitis จะมี Charcot's triad (fever, jaundice, RUQ pain) และมักพบ ALP สูงกว่า AST/ALT (cholestatic pattern) ผู้ป่วยรายนี้มี ALP ปกติ จึงไม่สอดคล้องกับ cholangitis นอกจากนี้ cholangitis มักเกี่ยวข้องกับ biliary obstruction เช่น choledocholithiasis" },
        { label: "E", text: "Drug-induced liver injury from paracetamol in cirrhotic patient", is_correct: false, explanation: "แม้ว่าตัวเลือกนี้จะกล่าวถึง paracetamol ในผู้ป่วย cirrhosis แต่คำว่า drug-induced liver injury (DILI) มักหมายถึง idiosyncratic reaction ไม่ใช่ dose-dependent toxicity ในขณะที่ paracetamol toxicity เป็น dose-dependent (intrinsic) hepatotoxicity ซึ่ง choice A ตรงกว่าในทางเภสัชวิทยา" }
      ],
      key_takeaway: "ผู้ป่วย alcoholic liver disease มีความเสี่ยงสูงต่อ paracetamol toxicity แม้ใช้ในขนาด therapeutic dose เนื่องจาก CYP2E1 induction และ glutathione depletion ควรจำกัดขนาด paracetamol ไม่เกิน 2 กรัม/วัน ในผู้ป่วยกลุ่มนี้"
    }
  },
  {
    id: "00a6f910-7552-46b2-b94a-a3875ed4a751",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. ใส่เฝือกแขนท่อนบนและท่อนล่าง (การรักษาแบบอนุรักษ์สำหรับ humeral shaft fracture ที่มี radial nerve palsy)",
      reason: `ผู้ป่วยมี oblique fracture ที่ middle 1/3 ของ right humerus ร่วมกับอาการของ radial nerve palsy ได้แก่ wrist drop (กระดกข้อมือไม่ได้), finger extension grade 0, และ decreased sensation ที่ dorsum of 1st web space ซึ่งเป็น sensory territory ของ superficial branch of radial nerve

Radial nerve วิ่งอยู่ใน spiral groove (radial groove) ของ humerus ซึ่งอยู่บริเวณ junction ของ middle 1/3 และ distal 1/3 ทำให้ nerve มีความเสี่ยงสูงต่อการบาดเจ็บเมื่อเกิด fracture บริเวณนี้ โดยพบ radial nerve palsy ร่วมกับ humeral shaft fracture ได้ประมาณ 11-18% โดยเฉพาะ oblique fracture ที่ middle-distal junction

สิ่งสำคัญคือ radial nerve palsy ที่เกิดร่วมกับ closed fracture ส่วนใหญ่ (90-95%) เป็น neuropraxia (nerve contusion/stretching) ไม่ใช่ nerve transection ดังนั้นเส้นประสาทจะฟื้นตัวได้เองโดยไม่ต้องผ่าตัดซ่อม โดยทั่วไปจะฟื้นตัวภายใน 3-4 เดือน

การรักษา humeral shaft fracture ที่ไม่ซับซ้อนคือ conservative treatment ด้วยการใส่ functional brace (Sarmiento brace) หรือ long arm splint/cast โดยมี union rate สูงกว่า 90% ไม่จำเป็นต้องผ่าตัดดามกระดูกในกรณีนี้เพราะเป็น closed fracture ข้อบ่งชี้ของการผ่าตัดได้แก่ open fracture, vascular injury, bilateral fracture, floating elbow หรือ failure of conservative treatment`,
      choices: [
        { label: "A", text: "ใส่เฝือกแขนท่อนบนและท่อนล่าง", is_correct: true, explanation: "ถูกต้อง เพราะ humeral shaft fracture ที่เป็น closed fracture สามารถรักษาแบบอนุรักษ์ได้ด้วย functional brace/splint และ radial nerve palsy ในกรณี closed fracture ส่วนใหญ่เป็น neuropraxia ที่จะฟื้นตัวได้เอง ควรติดตามการฟื้นตัวของเส้นประสาทเป็นระยะ" },
        { label: "B", text: "ทำ EMG และใส่เฝือกแขนท่อนบนและท่อนล่าง", is_correct: false, explanation: "การทำ EMG ในช่วงแรกไม่มีประโยชน์เพราะ denervation changes ใน EMG จะยังไม่ปรากฏจนกว่าจะผ่านไปอย่างน้อย 2-3 สัปดาห์ การทำ EMG ควรทำหลัง 3-4 สัปดาห์หากยังไม่มีการฟื้นตัว เพื่อประเมิน severity ของ nerve injury" },
        { label: "C", text: "ผ่าตัดดามกระดูกและต่อเส้นประสาท", is_correct: false, explanation: "ไม่จำเป็นต้องผ่าตัดต่อเส้นประสาทในกรณี closed fracture เพราะส่วนใหญ่เป็น neuropraxia ที่จะฟื้นตัวเอง การผ่าตัดสำรวจเส้นประสาทจะพิจารณาเมื่อไม่มี recovery หลัง 3-4 เดือน หรือในกรณีที่เป็น open fracture ที่สงสัย nerve transection" },
        { label: "D", text: "ผ่าตัดดามกระดูกและใส่เฝือกท่อนบนและท่อนล่าง", is_correct: false, explanation: "ไม่จำเป็นต้องผ่าตัดดามกระดูกเพราะ humeral shaft fracture ส่วนใหญ่สามารถรักษาแบบอนุรักษ์ได้ด้วย functional brace การผ่าตัดมีข้อบ่งชี้เฉพาะเช่น open fracture, polytrauma, pathological fracture หรือ failure of conservative treatment" },
        { label: "E", text: "ผ่าตัดต่อเส้นประสาทและใส่เฝือกแขนท่อนบน", is_correct: false, explanation: "การผ่าตัดต่อเส้นประสาทโดยไม่รอดูการฟื้นตัวก่อนไม่เหมาะสม เพราะ radial nerve palsy ใน closed humeral shaft fracture ส่วนใหญ่เป็น neuropraxia ที่ฟื้นตัวได้เองภายใน 3-4 เดือน การผ่าตัดสำรวจเส้นประสาทควรทำเมื่อไม่มีการฟื้นตัวหลังติดตามอย่างเพียงพอ" }
      ],
      key_takeaway: "Radial nerve palsy ที่เกิดร่วมกับ closed humeral shaft fracture ส่วนใหญ่เป็น neuropraxia ที่ฟื้นตัวได้เอง การรักษาเบื้องต้นคือ conservative treatment ด้วย functional brace และติดตามการฟื้นตัวของเส้นประสาท"
    }
  },
  {
    id: "00bc4de4-e876-494f-b8c0-2cc91cc3b6bc",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: B. ตรวจประเมินความเสี่ยง neurovascular compromise และการสูญเสีย soft tissue perfusion",
      reason: `เด็กชาย 6 ปี ล้มจากที่สูงกระแทกด้านข้างของข้อศอก มีอาการบวมที่ด้านนอกของข้อศอก การเคลื่อนไหวจำกัด X-ray พบ lateral condylar fracture ที่มี displacement > 2 mm คำถามถามถึงการจัดการที่สำคัญที่สุดในขั้นต้น

Lateral condylar fracture เป็นกระดูกหักที่พบบ่อยเป็นอันดับ 2 ของข้อศอกในเด็ก (รองจาก supracondylar fracture) คิดเป็นประมาณ 12-20% ของ elbow fractures ในเด็ก กลไกการบาดเจ็บมักเป็น varus stress หรือ pull-off mechanism จากแรงดึงของ extensor muscles

หลักการสำคัญที่สุดในการจัดการ fracture ใดๆ ในขั้นต้นคือการประเมิน neurovascular status ของ extremity ก่อนเสมอ เพราะ compartment syndrome, vascular injury หรือ nerve injury ที่ไม่ได้รับการวินิจฉัยและรักษาอย่างทันท่วงทีอาจนำไปสู่ผลเสียถาวรที่ร้ายแรง เช่น Volkmann ischemic contracture, limb loss หรือ permanent nerve damage

สำหรับข้อศอก เส้นประสาทที่ต้องตรวจได้แก่ radial nerve (wrist/finger extension, sensation at 1st web space), median nerve (thumb opposition, sensation at palmar aspect of index finger), ulnar nerve (finger abduction, sensation at little finger) และ posterior interosseous nerve เส้นเลือดที่ต้องตรวจคือ radial pulse และ capillary refill

แม้ว่า displaced lateral condylar fracture > 2 mm จะต้องได้รับการผ่าตัด ORIF แต่ก่อนที่จะวางแผนการผ่าตัด สิ่งที่สำคัญที่สุดในขั้นต้นคือต้องมั่นใจว่าไม่มี neurovascular compromise ที่ต้องการการรักษาเร่งด่วนก่อน`,
      choices: [
        { label: "A", text: "ผ่าตัดลอยตัวแบบเร่งด่วน (Emergent open reduction and internal fixation)", is_correct: false, explanation: "แม้ว่า displaced lateral condylar fracture > 2 mm จะต้องผ่าตัด ORIF แต่ไม่ใช่สิ่งที่ต้องทำ 'เป็นอันดับแรก' ต้องประเมิน neurovascular status ก่อนเสมอ นอกจากนี้ lateral condylar fracture ไม่ใช่ surgical emergency เหมือน open fracture หรือ vascular injury สามารถผ่าตัดภายใน 24-48 ชั่วโมงได้" },
        { label: "B", text: "ตรวจประเมินความเสี่ยง neurovascular compromise และการสูญเสีย soft tissue perfusion", is_correct: true, explanation: "ถูกต้อง เพราะในการจัดการ fracture ทุกชนิด การประเมิน neurovascular status เป็นสิ่งที่ต้องทำเป็นอันดับแรกเสมอ เพื่อตรวจหา vascular injury, nerve injury หรือ compartment syndrome ที่ต้องการการรักษาเร่งด่วน ก่อนที่จะวางแผนการรักษา definitive" },
        { label: "C", text: "บรรจุน้ำแข็งและยาแก้ปวดทันที จากนั้นส่งต่อไปโรงพยาบาล", is_correct: false, explanation: "การประคบน้ำแข็งและให้ยาแก้ปวดเป็นการรักษาเบื้องต้นที่ดี แต่ไม่ใช่สิ่งที่ 'สำคัญที่สุด' ก่อนจะให้การรักษาใดๆ ต้องประเมิน neurovascular status ก่อน เพราะถ้ามี vascular compromise การ delay อาจทำให้เกิดภาวะแทรกซ้อนร้ายแรง" },
        { label: "D", text: "จำกัดการเคลื่อนไหวด้วย posterior slab splint ในสภาวะเฉพาะหน้า", is_correct: false, explanation: "Splinting เป็นการ immobilize ที่เหมาะสมในขั้นต้น แต่ก่อนที่จะ splint ต้องประเมิน neurovascular status ก่อน เพราะ splint ที่แน่นเกินไปอาจทำให้ compartment syndrome แย่ลง และต้องมี baseline neurovascular exam เพื่อเปรียบเทียบภายหลัง" },
        { label: "E", text: "ลด fracture ด้วยวิธี closed reduction และรอให้ healing ตามธรรมชาติ", is_correct: false, explanation: "Displaced lateral condylar fracture > 2 mm ไม่ควรรักษาด้วย closed reduction เพียงอย่างเดียว เพราะเป็น intra-articular fracture ที่ต้องการ anatomical reduction เพื่อป้องกัน nonunion, malunion และ cubitus valgus deformity ต้องผ่าตัด ORIF" }
      ],
      key_takeaway: "ในการจัดการ fracture ทุกชนิด สิ่งที่สำคัญที่สุดในขั้นต้นคือการประเมิน neurovascular status เสมอ ก่อนที่จะวางแผนการรักษา definitive เพื่อป้องกันภาวะแทรกซ้อนร้ายแรงที่อาจเกิดจาก vascular injury หรือ compartment syndrome"
    }
  },
  {
    id: "00c22aef-d4ce-4ad6-9bba-201cb5dac825",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Heat stroke (โรคลมแดดจากการวิ่งมาราธอน)",
      reason: `ผู้ป่วยชายอายุ 40 ปี สุขภาพแข็งแรง วิ่งมาราธอนแล้วเริ่มเหนื่อย อาเจียน ล้มลง เกร็งกระตุก 2 ครั้ง หมดสติ ตรวจพบ BT 40°C, PR 120, BP 160/100, RR 30 หายใจดัง ไม่มี focal neurological deficit แต่ปวดหัวมาก อาการทั้งหมดนี้เข้าได้กับ exertional heat stroke

Heat stroke แบ่งเป็น 2 ชนิด: Classic heat stroke (เกิดในผู้สูงอายุ เด็ก หรือผู้ที่มีโรคประจำตัวในสภาพอากาศร้อน) และ Exertional heat stroke (เกิดในคนที่ออกกำลังกายหนักในสภาพอากาศร้อน) ผู้ป่วยรายนี้เข้าได้กับ exertional heat stroke

พยาธิสรีรวิทยาของ heat stroke เกิดจากร่างกายไม่สามารถระบายความร้อนได้ทันกับการสร้างความร้อนจากกล้ามเนื้อ ทำให้ core temperature สูงขึ้นจนเกิน 40°C ส่งผลให้เกิด thermoregulatory failure ความร้อนที่สูงทำให้เกิด protein denaturation, cell membrane instability, inflammatory cascade activation และ multiorgan dysfunction รวมถึง CNS dysfunction (สับสน ชัก หมดสติ), rhabdomyolysis, DIC, acute kidney injury และ hepatic failure

ลักษณะทางคลินิกที่สำคัญของ heat stroke ได้แก่ core temperature > 40°C (104°F) ร่วมกับ CNS dysfunction (altered mental status, seizure, coma) อาการอื่นๆ ได้แก่ tachycardia, tachypnea, hypotension หรือ hypertension (จากการกระตุ้น sympathetic nervous system) ผิวหนังอาจแห้งหรือเปียกชุ่มเหงื่อ (ใน exertional type)

สิ่งสำคัญคือผู้ป่วยรายนี้ไม่มี focal neurological deficit ซึ่งช่วยแยก stroke ออกได้ การรักษาคือ rapid cooling ให้ core temperature ลดลงต่ำกว่า 39°C ภายใน 30 นาที ด้วยวิธี evaporative cooling, ice water immersion หรือ cold IV fluid`,
      choices: [
        { label: "A", text: "Heat stroke", is_correct: true, explanation: "ถูกต้อง เพราะผู้ป่วยมี classic triad ของ heat stroke คือ core temperature > 40°C, altered mental status (หมดสติ, seizure) ภายหลังจากออกกำลังกายหนัก (วิ่งมาราธอน) ร่วมกับ tachycardia, hypertension จากการกระตุ้น sympathetic nervous system และไม่มี focal neurological deficit" },
        { label: "B", text: "TIA", is_correct: false, explanation: "TIA (Transient Ischemic Attack) มักมี focal neurological deficit เช่น อ่อนแรงซีกเดียว พูดไม่ชัด ตามองไม่เห็น ซึ่งผู้ป่วยรายนี้ไม่มี นอกจากนี้ TIA มักไม่ทำให้ core temperature สูงถึง 40°C และไม่ค่อยเกี่ยวข้องกับการออกกำลังกาย" },
        { label: "C", text: "Acute MI", is_correct: false, explanation: "Acute MI มักมีอาการเจ็บหน้าอก หายใจลำบาก และอาจมี cardiogenic shock แม้ว่า cardiac arrest จากการออกกำลังกายเป็นสิ่งที่ต้องระวัง แต่อาการ core temperature 40°C, seizure โดยไม่มี chest pain เด่น ทำให้ heat stroke เป็นคำตอบที่เหมาะสมกว่า" },
        { label: "D", text: "Pulmonary embolism", is_correct: false, explanation: "Pulmonary embolism มักมีอาการ dyspnea, pleuritic chest pain, tachycardia และ hypoxemia แม้ว่าจะเกิดระหว่างออกกำลังกายได้ แต่ไม่ทำให้ core temperature สูงถึง 40°C และมักไม่มี seizure เป็น presenting symptom" },
        { label: "E", text: "Intracerebral hemorrhage", is_correct: false, explanation: "Intracerebral hemorrhage มักมี focal neurological deficit เด่นชัด เช่น hemiparesis, aphasia หรือ gaze deviation ผู้ป่วยรายนี้ 'no focal neurological deficit' ซึ่งทำให้ ICH มีโอกาสน้อย แม้ว่า severe hypertension ขณะออกกำลังกายอาจเป็นปัจจัยเสี่ยงของ ICH ได้ก็ตาม" }
      ],
      key_takeaway: "Heat stroke วินิจฉัยจาก core temperature > 40°C ร่วมกับ altered mental status โดยไม่มี focal neurological deficit หลังจากสัมผัสความร้อนหรือออกกำลังกายหนัก การรักษาเร่งด่วนคือ rapid cooling ภายใน 30 นาที"
    }
  },
  {
    id: "00ec9122-097d-4592-82ad-addd3e27662f",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Carbon monoxide (พิษจากก๊าซคาร์บอนมอนอกไซด์จากการเผาไหม้ตะเกียงในเต็นท์ปิด)",
      reason: `นักท่องเที่ยวกางเต็นท์บนดอยอินทนนท์และจุดตะเกียงไว้ข้างใน วันรุ่งขึ้นถูกพบเสียชีวิต สาเหตุที่เป็นไปได้มากที่สุดคือ carbon monoxide (CO) poisoning จากการเผาไหม้ไม่สมบูรณ์ (incomplete combustion) ของเชื้อเพลิงตะเกียงในพื้นที่ปิดที่มีการระบายอากาศไม่ดี

พยาธิสรีรวิทยาของ CO poisoning: CO เป็นก๊าซไม่มีสี ไม่มีกลิ่น ไม่มีรส จึงไม่สามารถรับรู้ได้ CO มี affinity ต่อ hemoglobin สูงกว่า oxygen ประมาณ 200-250 เท่า เมื่อ CO จับกับ hemoglobin จะเกิดเป็น carboxyhemoglobin (COHb) ซึ่งไม่สามารถขนส่ง oxygen ได้ นอกจากนี้ CO ยัง shift oxygen-hemoglobin dissociation curve ไปทางซ้าย ทำให้ hemoglobin ที่เหลือปล่อย oxygen ให้เนื้อเยื่อได้ยากขึ้น

CO ยังจับกับ myoglobin และ cytochrome oxidase ในมรรคา electron transport chain ของ mitochondria ทำให้เกิด cellular hypoxia โดยตรง ส่งผลให้อวัยวะที่ต้องการ oxygen มาก เช่น สมองและหัวใจ ได้รับผลกระทบมากที่สุด

อาการของ CO poisoning เริ่มจาก headache, dizziness, nausea (COHb 20-30%) ไปจนถึง confusion, loss of consciousness, seizure, cardiac arrhythmia และ death (COHb > 50-60%) ลักษณะทางนิติเวชที่สำคัญคือ cherry-red discoloration ของ skin และ blood เนื่องจาก COHb มีสีแดงสด

สิ่งสำคัญคือบนดอยอินทนนท์ อุณหภูมิต่ำมากในตอนกลางคืน ทำให้ผู้ประสบเหตุปิดเต็นท์แน่นเพื่อกันหนาว ส่งผลให้ไม่มีการระบายอากาศเพียงพอ เมื่อตะเกียงเผาไหม้ใช้ oxygen ในเต็นท์จนหมด จะเกิด incomplete combustion สร้าง CO ขึ้นในปริมาณมาก`,
      choices: [
        { label: "A", text: "Carbon monoxide", is_correct: true, explanation: "ถูกต้อง เพราะ CO เกิดจาก incomplete combustion ของเชื้อเพลิงตะเกียงในเต็นท์ปิด CO เป็นก๊าซไม่มีสี ไม่มีกลิ่น จึงไม่สามารถรับรู้ได้ก่อนหมดสติ CO จับ hemoglobin แน่นกว่า oxygen 200-250 เท่า ทำให้เกิด tissue hypoxia และเสียชีวิตในที่สุด" },
        { label: "B", text: "Ozone", is_correct: false, explanation: "Ozone (O₃) พบในชั้นบรรยากาศสูงและเกิดจากปฏิกิริยาทางเคมีในอากาศ ไม่ได้เกิดจากการเผาไหม้ของตะเกียง แม้ว่า ozone จะเป็นสารพิษต่อระบบทางเดินหายใจ แต่ไม่เกี่ยวข้องกับสถานการณ์นี้" },
        { label: "C", text: "Sulfur dioxide", is_correct: false, explanation: "Sulfur dioxide (SO₂) เกิดจากการเผาไหม้เชื้อเพลิงที่มีกำมะถัน เช่น ถ่านหิน น้ำมันดีเซล ไม่ใช่เชื้อเพลิงตะเกียงทั่วไป SO₂ มีกลิ่นฉุนจึงสามารถรับรู้ได้ และมักทำให้เกิดอาการระคายเคืองทางเดินหายใจก่อน ไม่ใช่หมดสติทันที" },
        { label: "D", text: "Carbon dioxide", is_correct: false, explanation: "แม้ว่า CO₂ จะเกิดจากการเผาไหม้เช่นกัน แต่ CO₂ มีพิษน้อยกว่า CO มาก ต้องมีความเข้มข้นสูงมาก (>10%) จึงจะทำให้หมดสติและเสียชีวิต ในสถานการณ์เต็นท์ปิดกับตะเกียง CO จะถูกสร้างขึ้นก่อนที่ CO₂ จะสะสมถึงระดับอันตราย" },
        { label: "E", text: "Nitrogen dioxide", is_correct: false, explanation: "Nitrogen dioxide (NO₂) เกิดจากการเผาไหม้ที่อุณหภูมิสูงมาก เช่น ในเครื่องยนต์หรือโรงงานอุตสาหกรรม ไม่ใช่จากตะเกียงทั่วไป NO₂ มีสีน้ำตาลแดงและมีกลิ่น จึงสามารถรับรู้ได้ ไม่ใช่สาเหตุที่เป็นไปได้ในสถานการณ์นี้" }
      ],
      key_takeaway: "Carbon monoxide poisoning เป็นภัยเงียบจากการเผาไหม้เชื้อเพลิงในพื้นที่ปิด CO ไม่มีสี ไม่มีกลิ่น จับ hemoglobin แน่นกว่า O₂ 200-250 เท่า ห้ามจุดไฟหรือใช้เตาแก๊สในเต็นท์หรือห้องปิดเด็ดขาด"
    }
  },
  {
    id: "00f04927-409b-469d-ba12-106bf939933c",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Reassurance and breathing exercise (ให้ความมั่นใจและฝึกหายใจ)",
      reason: `ผู้ป่วยหญิงวัยรุ่นมีอาการหายใจเร็ว (hyperventilation) เป็นเวลา 2 ชั่วโมงหลังจากถูกแฟนตะโกนใส่ ซึ่งเป็นอาการที่เกิดจากภาวะเครียดทางจิตใจ (psychogenic hyperventilation) การจัดการที่เหมาะสมที่สุดคือ reassurance and breathing exercise

Hyperventilation syndrome เกิดจากการหายใจเร็วและลึกเกินไป ทำให้เกิดการหายใจออก CO₂ มากเกินปกติ (excessive CO₂ elimination) ส่งผลให้เกิด respiratory alkalosis (pH สูง, PaCO₂ ต่ำ) ภาวะ alkalosis ทำให้ ionized calcium ในเลือดลดลง (เพราะ calcium จับกับ albumin มากขึ้นในสภาวะ alkaline) ส่งผลให้เกิด neuromuscular excitability

อาการที่พบได้แก่ paresthesia (ชาปลายมือปลายเท้า รอบปาก), carpopedal spasm (มือเกร็งจีบ), chest tightness, dizziness, lightheadedness และ palpitations ในกรณีรุนแรงอาจเป็นลมหมดสติได้

การรักษาหลักคือ reassurance (ให้ความมั่นใจว่าไม่เป็นอันตราย อาการจะดีขึ้นเอง) ร่วมกับ breathing exercise โดยสอนให้หายใจช้าลง (slow breathing technique) เช่น หายใจเข้า 4 วินาที กลั้นหายใจ 2 วินาที หายใจออก 6 วินาที เพื่อลดการสูญเสีย CO₂ และแก้ไข respiratory alkalosis

สิ่งสำคัญคือต้องตรวจให้แน่ใจว่าไม่มี organic cause ของ hyperventilation ก่อน เช่น asthma, PE, metabolic acidosis, pneumothorax ก่อนที่จะวินิจฉัยว่าเป็น psychogenic hyperventilation`,
      choices: [
        { label: "A", text: "Reassurance and breathing exercise", is_correct: true, explanation: "ถูกต้อง เพราะเป็นการรักษาที่เหมาะสมที่สุดสำหรับ psychogenic hyperventilation syndrome การให้ความมั่นใจช่วยลดความวิตกกังวล และ breathing exercise ช่วยลดอัตราการหายใจ ทำให้ CO₂ กลับสู่ระดับปกติ แก้ไข respiratory alkalosis อย่างปลอดภัย" },
        { label: "B", text: "Re-breathing using a paper bag", is_correct: false, explanation: "การหายใจกลับผ่านถุงกระดาษ (paper bag rebreathing) เคยเป็นวิธีที่แนะนำในอดีต แต่ปัจจุบันไม่แนะนำเนื่องจากอาจทำให้เกิด hypoxia ได้ โดยเฉพาะถ้าผู้ป่วยมี organic cause ของ hyperventilation ที่ยังไม่ได้รับการวินิจฉัย เช่น asthma หรือ PE นอกจากนี้ยังมีรายงาน cardiac arrest จากการใช้วิธีนี้" },
        { label: "C", text: "Diazepam", is_correct: false, explanation: "Benzodiazepines ไม่จำเป็นในกรณี psychogenic hyperventilation ที่ไม่รุนแรง การใช้ยากล่อมประสาทอาจทำให้เกิด respiratory depression, drowsiness และ dependency ได้ ควรใช้เฉพาะกรณีที่ reassurance และ breathing exercise ไม่ได้ผล หรือมี severe anxiety/panic attack" },
        { label: "D", text: "Oxygen therapy", is_correct: false, explanation: "Oxygen therapy ไม่จำเป็นใน hyperventilation syndrome เพราะผู้ป่วยไม่ได้ขาด oxygen แต่เป็นการหายใจออก CO₂ มากเกินไป PaO₂ จะสูงกว่าปกติด้วยซ้ำ การให้ oxygen อาจทำให้ผู้ป่วยรู้สึกว่ามีปัญหาจริงจัง เพิ่มความวิตกกังวล" },
        { label: "E", text: "Intubation", is_correct: false, explanation: "การใส่ท่อช่วยหายใจเป็นการรักษาที่เกินจำเป็นอย่างมากสำหรับ hyperventilation syndrome ไม่มีข้อบ่งชี้ของ respiratory failure ที่แท้จริง (airway compromise, inability to protect airway, severe hypoxia) การใส่ท่อช่วยหายใจมีความเสี่ยงและเป็น invasive procedure ที่ไม่สมเหตุสมผลในกรณีนี้" }
      ],
      key_takeaway: "Psychogenic hyperventilation syndrome รักษาด้วย reassurance และ breathing exercise ไม่แนะนำ paper bag rebreathing เนื่องจากเสี่ยงต่อ hypoxia ต้องแยก organic cause ออกก่อนเสมอ"
    }
  },
  {
    id: "00fff64f-d910-42ce-a08b-53c9a64a4f11",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: B. Glucose tolerance test (การทดสอบความทนทานต่อกลูโคส)",
      reason: `เด็กชายอายุ 10 ปี พบ acanthosis nigricans ซึ่งเป็น velvety, dark, thickened skin patches ที่มักพบบริเวณคอ รักแร้ ขาหนีบ ร่วมกับประวัติครอบครัวเป็น type 2 diabetes mellitus (พ่อและยายเป็นเบาหวาน) สิ่งที่ต้องนึกถึงคือ insulin resistance ที่เป็นสาเหตุของ acanthosis nigricans และเสี่ยงต่อ type 2 DM

Acanthosis nigricans เกิดจาก hyperinsulinemia ที่เป็นผลมาจาก insulin resistance insulin ที่มีระดับสูงจะกระตุ้น insulin-like growth factor-1 (IGF-1) receptors ที่ keratinocytes และ fibroblasts ในผิวหนัง ทำให้เกิดการเจริญเติบโตมากผิดปกติ (hyperproliferation) ของเซลล์ผิวหนัง ส่งผลให้ผิวหนังหนาขึ้นและมีสีเข้มขึ้น

ในเด็กที่มี acanthosis nigricans ร่วมกับ strong family history ของ type 2 DM ตาม ADA guidelines ควรทำการคัดกรอง diabetes โดยใช้ oral glucose tolerance test (OGTT) ซึ่งเป็น gold standard ในการวินิจฉัย diabetes และ prediabetes (impaired glucose tolerance) ในเด็ก

เกณฑ์การคัดกรอง diabetes ในเด็กตาม ADA: อายุ ≥ 10 ปี หรือเริ่มเข้า puberty ร่วมกับ overweight (BMI ≥ 85th percentile) และมีปัจจัยเสี่ยงอย่างน้อย 1 อย่าง ได้แก่ family history ของ type 2 DM (1st or 2nd degree relative), signs of insulin resistance (เช่น acanthosis nigricans, hypertension, PCOS), เชื้อชาติที่มีความเสี่ยงสูง ผู้ป่วยรายนี้มีทั้ง acanthosis nigricans และ family history จึงเข้าเกณฑ์การคัดกรอง`,
      choices: [
        { label: "A", text: "Chromosome study", is_correct: false, explanation: "Chromosome study ใช้ในกรณีที่สงสัย chromosomal abnormalities เช่น Turner syndrome, Klinefelter syndrome หรือ Down syndrome ไม่ใช่การตรวจที่เหมาะสมสำหรับเด็กที่มี acanthosis nigricans และ family history ของ DM2 ซึ่งบ่งชี้ insulin resistance" },
        { label: "B", text: "Glucose tolerance test", is_correct: true, explanation: "ถูกต้อง เพราะ OGTT เป็นการตรวจที่เหมาะสมที่สุดในการคัดกรอง diabetes และ impaired glucose tolerance ในเด็กที่มี risk factors ได้แก่ acanthosis nigricans (บ่งชี้ insulin resistance) ร่วมกับ strong family history ของ type 2 DM" },
        { label: "C", text: "Growth hormone test", is_correct: false, explanation: "Growth hormone test ใช้ในกรณีที่สงสัย growth hormone deficiency หรือ acromegaly ไม่ใช่การตรวจที่เหมาะสมสำหรับ acanthosis nigricans ที่เกิดจาก insulin resistance แม้ว่า acromegaly จะทำให้เกิด acanthosis nigricans ได้ แต่พบได้น้อยมากในเด็ก" },
        { label: "D", text: "Dexamethasone suppression test", is_correct: false, explanation: "Dexamethasone suppression test ใช้ในการวินิจฉัย Cushing syndrome แม้ว่า Cushing syndrome จะทำให้เกิด insulin resistance และ acanthosis nigricans ได้ แต่ในเด็กที่ไม่มีอาการอื่นของ Cushing เช่น moon face, buffalo hump, striae ร่วมกับ family history ของ DM2 ทำให้ GTT เหมาะสมกว่า" },
        { label: "E", text: "24-hour free cortisol test", is_correct: false, explanation: "24-hour free cortisol test เป็นอีกวิธีหนึ่งในการคัดกรอง Cushing syndrome เช่นเดียวกับ dexamethasone suppression test ในกรณีนี้ ผู้ป่วยไม่มีลักษณะทางคลินิกของ Cushing syndrome และ family history ชี้ไปทาง insulin resistance/DM2 จึงไม่ใช่การตรวจที่เหมาะสม" }
      ],
      key_takeaway: "Acanthosis nigricans ในเด็กบ่งชี้ insulin resistance ร่วมกับ family history ของ type 2 DM ควรทำ glucose tolerance test เพื่อคัดกรอง diabetes และ prediabetes ตามเกณฑ์ ADA guidelines"
    }
  },
  {
    id: "0135cec9-ebca-42d8-830e-a56add6619df",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: E. Chromosomal abnormalities (ความผิดปกติของโครโมโซม)",
      reason: `ผู้ป่วยหญิงอายุ 34 ปี มีประวัติตั้งครรภ์ 3 ครั้ง แต่แท้งทุกครั้งที่อายุครรภ์ 7, 11 และ 8 สัปดาห์ตามลำดับ ซึ่งเป็น recurrent pregnancy loss (RPL) หรือ recurrent miscarriage โดยทั้ง 3 ครั้งเกิดใน first trimester (< 13 สัปดาห์)

สาเหตุที่พบบ่อยที่สุดของ first trimester miscarriage คือ chromosomal abnormalities ของ embryo/fetus พบได้ประมาณ 50-60% ของ sporadic first trimester miscarriages ชนิดที่พบบ่อยที่สุดคือ autosomal trisomy (เช่น trisomy 16, 22, 21) ตามด้วย monosomy X (45,X) และ polyploidy (triploidy, tetraploidy)

ในกรณีของ recurrent pregnancy loss (≥ 3 ครั้งติดต่อกัน หรือ ≥ 2 ครั้งตามเกณฑ์ใหม่) สาเหตุจาก chromosomal abnormalities ยังคงเป็นสาเหตุที่พบบ่อยที่สุด ประมาณ 50-60% โดยอาจเป็น de novo chromosomal errors ในแต่ละครรภ์ หรืออาจเป็นจาก balanced translocation ใน parental chromosomes ซึ่งทำให้เกิด unbalanced translocation ใน offspring

สิ่งที่สำคัญคือการแท้งทุกครั้งเกิดใน first trimester ซึ่งเป็นช่วงที่ chromosomal abnormalities เป็นสาเหตุหลัก หากเป็น second trimester loss ต้องนึกถึง cervical incompetence, uterine anomaly หรือ infection มากกว่า

การตรวจสอบเพิ่มเติมในผู้ป่วย RPL ได้แก่ karyotype ของทั้งคู่สามีภรรยา, antiphospholipid antibody syndrome screening, uterine anatomical evaluation (HSG, sonohysterogram, hysteroscopy), thyroid function tests และ evaluation for thrombophilia`,
      choices: [
        { label: "A", text: "Myoma uteri", is_correct: false, explanation: "Myoma uteri (uterine fibroids) อาจเป็นสาเหตุของ miscarriage ได้ โดยเฉพาะ submucous myoma ที่อยู่ใน uterine cavity แต่มักทำให้เกิด second trimester loss มากกว่า first trimester loss และพบได้น้อยในหญิงอายุ 34 ปี ที่ไม่มีประวัติ menorrhagia" },
        { label: "B", text: "Bicornuate uterus", is_correct: false, explanation: "Bicornuate uterus เป็น uterine anomaly ที่อาจทำให้เกิด recurrent miscarriage ได้ แต่มักทำให้เกิด second trimester loss มากกว่า เพราะมดลูกมีพื้นที่ไม่เพียงพอสำหรับทารกที่โตขึ้น การแท้งใน first trimester (7-11 สัปดาห์) ไม่ค่อยเกี่ยวข้องกับ uterine anomaly" },
        { label: "C", text: "Infection", is_correct: false, explanation: "การติดเชื้อ เช่น TORCH infections (Toxoplasma, Rubella, CMV, HSV) อาจทำให้เกิด miscarriage ได้ แต่ไม่ค่อยเป็นสาเหตุของ recurrent miscarriage เพราะหลังติดเชื้อครั้งแรก ร่างกายจะสร้างภูมิคุ้มกันขึ้น ทำให้ไม่น่าจะเกิดซ้ำ 3 ครั้ง" },
        { label: "D", text: "Cervical incompetence", is_correct: false, explanation: "Cervical incompetence ทำให้ปากมดลูกเปิดก่อนกำหนดโดยไม่มีอาการเจ็บครรภ์ มักเกิดใน second trimester (16-24 สัปดาห์) ไม่ใช่ first trimester ผู้ป่วยรายนี้แท้งที่อายุครรภ์ 7-11 สัปดาห์ ซึ่งเร็วเกินไปที่จะเป็น cervical incompetence" },
        { label: "E", text: "Chromosomal abnormalities", is_correct: true, explanation: "ถูกต้อง เพราะ chromosomal abnormalities เป็นสาเหตุที่พบบ่อยที่สุดของ first trimester miscarriage (50-60%) และเป็นสาเหตุหลักของ recurrent pregnancy loss การแท้ง 3 ครั้งใน first trimester (7-11 สัปดาห์) สอดคล้องกับ chromosomal abnormalities มากที่สุด" }
      ],
      key_takeaway: "Chromosomal abnormalities เป็นสาเหตุที่พบบ่อยที่สุดของ first trimester miscarriage และ recurrent pregnancy loss ควรส่ง karyotype ของทั้งคู่สามีภรรยาเพื่อหา balanced translocation และตรวจหาสาเหตุอื่นๆ ร่วมด้วย"
    }
  },
  {
    id: "01b7ac85-2e9d-4795-b8ce-97f164bd4c07",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: C. Hyperventilation syndrome (กลุ่มอาการหายใจเกิน)",
      reason: `ผู้ป่วยหญิงอายุ 18 ปี มีอาการหายใจเร็วลึก (rapid, deep breathing) และมือเกร็งจีบ (clenched hands) เป็นเวลา 2 ชั่วโมง หลังจากถูกรุ่นพี่ตะโกนใส่ อาการทั้งหมดนี้เข้าได้กับ hyperventilation syndrome

Hyperventilation syndrome คือภาวะที่ผู้ป่วยหายใจเร็วและลึกเกินความจำเป็นทางสรีรวิทยา ทำให้สูญเสีย CO₂ มากเกินไป เกิด respiratory alkalosis (pH สูง, PaCO₂ ต่ำ) ภาวะ alkalosis ทำให้ calcium ที่ ionized ลดลง เนื่องจาก albumin จับ calcium มากขึ้นในสภาวะ alkaline ส่งผลให้เกิด neuromuscular excitability

อาการ clenched hands (carpopedal spasm) เป็นอาการที่เกิดจาก hypocalcemia ที่เป็นผลจาก respiratory alkalosis เป็น Trousseau sign ที่เกิดจากการกระตุ้นเส้นประสาทส่วนปลาย ทำให้กล้ามเนื้อมือเกร็งจีบ (main d'accoucheur position) นอกจากนี้ผู้ป่วยอาจมีอาการ perioral numbness, tingling ที่ปลายนิ้ว, chest tightness และ lightheadedness

สิ่งสำคัญที่ช่วยแยก hyperventilation syndrome จาก panic disorder คือ ใน hyperventilation syndrome อาการหลักคือการหายใจเกินที่เกิดจาก trigger ที่ชัดเจน (ถูกตะโกนใส่) และ physical symptoms จาก respiratory alkalosis เป็นเด่น ในขณะที่ panic disorder จะมี intense fear หรือ impending doom เป็นอาการเด่น โดยมี somatic symptoms ร่วม เช่น palpitations, sweating, trembling

Hyperventilation syndrome มักเกิดขึ้นเฉียบพลันจาก emotional stress และอาการจะหายได้เองเมื่อผู้ป่วยสงบลง ซึ่งต่างจาก generalized anxiety disorder ที่มีอาการวิตกกังวลเรื้อรังอย่างน้อย 6 เดือน`,
      choices: [
        { label: "A", text: "Conversion disorder", is_correct: false, explanation: "Conversion disorder (Functional neurological symptom disorder) มีอาการทางระบบประสาทที่ไม่สอดคล้องกับพยาธิสภาพทางกาย เช่น paralysis, blindness, seizure-like episodes โดยไม่มี organic cause ผู้ป่วยรายนี้มีอาการที่อธิบายได้ด้วยกลไก respiratory alkalosis ไม่ใช่ conversion" },
        { label: "B", text: "Acute stress disorder", is_correct: false, explanation: "Acute stress disorder เกิดหลัง traumatic event ที่รุนแรงมาก (เช่น อุบัติเหตุ, ภัยธรรมชาติ, ถูกทำร้าย) มีอาการ intrusion, dissociation, avoidance, arousal เป็นเวลา 3 วัน - 1 เดือน การถูกรุ่นพี่ตะโกนใส่ไม่ถือเป็น traumatic event ที่รุนแรงพอสำหรับ ASD" },
        { label: "C", text: "Hyperventilation syndrome", is_correct: true, explanation: "ถูกต้อง เพราะผู้ป่วยมี triad ของ hyperventilation syndrome คือ (1) rapid deep breathing หลังจาก emotional trigger (2) carpopedal spasm (clenched hands) จาก respiratory alkalosis-induced hypocalcemia (3) อาการเป็นเฉียบพลันและเกิดจาก precipitating factor ที่ชัดเจน" },
        { label: "D", text: "Generalized anxiety disorder", is_correct: false, explanation: "GAD มีอาการวิตกกังวลเรื้อรังเกินกว่า 6 เดือน เกี่ยวกับเรื่องต่างๆ ในชีวิตประจำวัน มีอาการ restlessness, fatigue, difficulty concentrating, irritability, muscle tension, sleep disturbance ผู้ป่วยรายนี้มีอาการเฉียบพลันไม่ใช่เรื้อรัง" },
        { label: "E", text: "Panic disorder", is_correct: false, explanation: "Panic disorder มี recurrent unexpected panic attacks ที่เกิดขึ้นอย่างกะทันหัน พร้อมกับความกลัวที่รุนแรง อาการถึงจุดสูงสุดภายใน 10 นาที ในกรณีนี้ อาการเกิดจาก trigger ที่ชัดเจน (ถูกตะโกนใส่) ไม่ใช่ unexpected attack และอาการหลักคือ hyperventilation ไม่ใช่ intense fear" }
      ],
      key_takeaway: "Hyperventilation syndrome วินิจฉัยจาก rapid deep breathing หลัง emotional trigger ร่วมกับ carpopedal spasm จาก respiratory alkalosis แยกจาก panic disorder โดย panic มี intense fear เป็นเด่น ส่วน hyperventilation มี physical symptoms จาก alkalosis เป็นเด่น"
    }
  },
  {
    id: "01d2d8e2-229f-4f66-b570-afd3ac89cbd5",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Calcium gluconate IV (แคลเซียมกลูโคเนตทางหลอดเลือดดำ)",
      reason: `ผู้ป่วยชายอายุ 65 ปี เบาหวาน ความดันโลหิตสูง มาด้วยอาการเหนื่อย หัวใจเต้นผิดจังหวะ Lab พบ K 7.2 mEq/L (severe hyperkalemia) EKG แสดง peaked T wave และ wide QRS complex ซึ่งเป็นสัญญาณอันตรายของ cardiac toxicity จาก hyperkalemia

Hyperkalemia (K > 5.5 mEq/L) เป็นภาวะฉุกเฉินที่อาจทำให้เกิด fatal cardiac arrhythmia ได้ EKG changes ของ hyperkalemia เรียงตามลำดับความรุนแรง: peaked T waves (K 5.5-6.5) → PR prolongation, loss of P waves (K 6.5-7.0) → wide QRS (K 7.0-7.5) → sine wave pattern → ventricular fibrillation/asystole (K > 8.0)

ผู้ป่วยรายนี้มี peaked T waves และ wide QRS ซึ่งบ่งชี้ severe hyperkalemia ที่กำลังจะเข้าสู่ระดับอันตราย การรักษาต้องเร่งด่วนและแบ่งเป็น 3 ขั้นตอน:

1) Cardiac membrane stabilization: Calcium gluconate IV เป็นยาที่ต้องให้เป็นอันดับแรก เพราะ calcium จะ stabilize cardiac membrane โดยการเพิ่ม threshold potential ทำให้ myocardial cells ทนต่อ hyperkalemia ได้ดีขึ้น ออกฤทธิ์ภายใน 1-3 นาที แต่ไม่ได้ลดระดับ potassium ลง

2) Shift potassium into cells: Insulin + glucose (regular insulin 10 units + D50W 25g), sodium bicarbonate (ถ้ามี metabolic acidosis), nebulized salbutamol

3) Remove potassium from body: Kayexalate (sodium polystyrene sulfonate), furosemide, hemodialysis

เหตุผลสำคัญที่ต้องให้ calcium gluconate ก่อนคือ ผู้ป่วยมี EKG changes ที่บ่งชี้ cardiac toxicity แล้ว การให้ calcium จะช่วยป้องกัน fatal arrhythmia ในขณะที่รอให้ยาอื่นๆ ออกฤทธิ์ลดระดับ potassium`,
      choices: [
        { label: "A", text: "Calcium gluconate IV", is_correct: true, explanation: "ถูกต้อง เพราะเป็นยาที่ต้องให้เป็นอันดับแรกใน hyperkalemia ที่มี EKG changes เนื่องจาก calcium ออกฤทธิ์ stabilize cardiac membrane ภายใน 1-3 นาที ป้องกัน fatal arrhythmia แม้จะไม่ได้ลดระดับ potassium แต่เป็น cardioprotective ที่สำคัญที่สุดในสถานการณ์ฉุกเฉิน" },
        { label: "B", text: "Insulin + Dextrose", is_correct: false, explanation: "Insulin + Dextrose เป็นการรักษาที่สำคัญในลำดับถัดมา โดย insulin จะ shift potassium เข้าเซลล์ผ่านทาง Na-K-ATPase pump ลด serum K ได้ 0.5-1.5 mEq/L ภายใน 15-30 นาที แต่ต้องให้ calcium gluconate ก่อนเพื่อ stabilize cardiac membrane ก่อน เพราะผู้ป่วยมี EKG changes แล้ว" },
        { label: "C", text: "Sodium bicarbonate", is_correct: false, explanation: "Sodium bicarbonate ช่วย shift potassium เข้าเซลล์โดยการแก้ไข metabolic acidosis แต่ออกฤทธิ์ช้ากว่า insulin และมีประสิทธิภาพน้อยกว่า ควรใช้ในกรณีที่มี metabolic acidosis ร่วมด้วย ไม่ใช่ first-line treatment สำหรับ hyperkalemia ที่มี EKG changes" },
        { label: "D", text: "Furosemide", is_correct: false, explanation: "Furosemide เป็น loop diuretic ที่ช่วยขับ potassium ออกทางไต แต่ออกฤทธิ์ช้า (30-60 นาที) และต้องมี renal function ที่ดีพอ ไม่เหมาะเป็น first-line treatment ในภาวะฉุกเฉิน hyperkalemia ที่มี EKG changes" },
        { label: "E", text: "Sodium polystyrene sulfonate", is_correct: false, explanation: "Kayexalate (sodium polystyrene sulfonate) เป็น cation exchange resin ที่จับ potassium ในลำไส้และขับออกทางอุจจาระ แต่ออกฤทธิ์ช้ามาก (4-6 ชั่วโมง) และมีประสิทธิภาพไม่แน่นอน ไม่เหมาะเป็น acute treatment สำหรับ hyperkalemia ที่มี EKG changes" }
      ],
      key_takeaway: "Hyperkalemia ที่มี EKG changes (peaked T, wide QRS) ต้องให้ calcium gluconate IV เป็นอันดับแรกเพื่อ stabilize cardiac membrane ตามด้วย insulin + dextrose เพื่อ shift K เข้าเซลล์ และ kayexalate/dialysis เพื่อ remove K ออกจากร่างกาย"
    }
  },
  {
    id: "02293390-12a9-4ede-b47d-cfe188bfc61f",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Acute hemolytic anemia (โลหิตจางจากเม็ดเลือดแดงแตกเฉียบพลัน)",
      reason: `ผู้ป่วยชายอายุ 18 ปี มาด้วยไข้ 5 วัน อ่อนเพลีย 3 วัน ตรวจพบ pallor (ซีด), mild jaundice (ตัวเหลืองเล็กน้อย) และ spleen just palpable (ม้ามโตเล็กน้อย) ผลเลือด: Hb 7.2 g/dL (ต่ำมาก), MCV 90 fL (normocytic), WBC 4200/cumm (ปกติ), Plt 150000/cumm (ปกติ)

การวิเคราะห์: ผู้ป่วยมี anemia ที่รุนแรง (Hb 7.2) ร่วมกับ jaundice ซึ่งเมื่อพบ anemia + jaundice ร่วมกัน ต้องนึกถึง hemolytic anemia เป็นอันดับแรก เพราะการแตกของเม็ดเลือดแดงจะทำให้เกิดทั้ง anemia (จากเม็ดเลือดแดงลดลง) และ jaundice (จาก unconjugated hyperbilirubinemia ที่เกิดจากการปลดปล่อย hemoglobin ซึ่งถูก metabolize เป็น bilirubin)

Splenomegaly สอดคล้องกับ hemolytic anemia เพราะม้ามเป็นอวัยวะหลักในการทำลายเม็ดเลือดแดง (extravascular hemolysis) เมื่อมี hemolysis มากขึ้น ม้ามจะทำงานหนักขึ้นและโตขึ้น MCV 90 fL เป็น normocytic anemia ซึ่งสอดคล้องกับ hemolytic anemia (เม็ดเลือดแดงปกติถูกทำลาย ไม่ใช่ปัญหาในการสร้าง)

WBC และ platelet ที่ปกติช่วยแยก aplastic anemia (ที่จะมี pancytopenia) และ leukemia (ที่มักมี abnormal WBC count) ออกได้ ไข้ในผู้ป่วยรายนี้อาจเป็นจาก underlying infection ที่ trigger hemolysis เช่น Mycoplasma pneumoniae หรือ EBV ที่ทำให้เกิด autoimmune hemolytic anemia หรืออาจเป็นจาก G6PD deficiency ที่ triggered โดย infection

ค่า lab ที่ช่วยยืนยัน hemolysis ได้แก่ elevated indirect bilirubin, elevated LDH, decreased haptoglobin, elevated reticulocyte count และ positive Coombs test (ในกรณี autoimmune hemolytic anemia)`,
      choices: [
        { label: "A", text: "Acute hemolytic anemia", is_correct: true, explanation: "ถูกต้อง เพราะ triad ของ anemia + jaundice + splenomegaly เป็น classic presentation ของ hemolytic anemia MCV ปกติ, WBC และ platelet ปกติ สนับสนุนว่าเป็นการทำลายเม็ดเลือดแดงเท่านั้น ไม่ใช่ bone marrow failure หรือ malignancy" },
        { label: "B", text: "Acute leukemia", is_correct: false, explanation: "Acute leukemia มักมี abnormal WBC count (สูงมากหรือต่ำมาก) ร่วมกับ thrombocytopenia และ blast cells ใน peripheral blood smear ผู้ป่วยรายนี้มี WBC 4200 และ platelet 150000 ซึ่งปกติ ทำให้ leukemia มีโอกาสน้อย นอกจากนี้ leukemia มักไม่ทำให้เกิด jaundice เด่น" },
        { label: "C", text: "Aplastic anemia", is_correct: false, explanation: "Aplastic anemia มีลักษณะ pancytopenia (low RBC, WBC, platelet) เนื่องจาก bone marrow failure ผู้ป่วยรายนี้มี WBC 4200 และ platelet 150000 ซึ่งปกติ จึงไม่ใช่ pancytopenia นอกจากนี้ aplastic anemia ไม่ทำให้เกิด jaundice เพราะไม่มี hemolysis" },
        { label: "D", text: "Iron deficiency anemia", is_correct: false, explanation: "Iron deficiency anemia มี MCV ต่ำ (microcytic anemia) โดยทั่วไป MCV < 80 fL ผู้ป่วยรายนี้มี MCV 90 fL (normocytic) ไม่สอดคล้องกับ iron deficiency นอกจากนี้ iron deficiency ไม่ทำให้เกิด jaundice หรือ splenomegaly" },
        { label: "E", text: "Infectious mononucleosis", is_correct: false, explanation: "Infectious mononucleosis จาก EBV มักมีไข้, pharyngitis, lymphadenopathy และ splenomegaly แม้ว่าจะมี splenomegaly ร่วมด้วย แต่ anemia ที่รุนแรง (Hb 7.2) และ jaundice ไม่ใช่ลักษณะเด่นของ infectious mono ถ้ามี hemolytic anemia ร่วมด้วยจะเป็น autoimmune hemolytic anemia ที่ triggered โดย EBV ซึ่งคำตอบ A ยังคงเหมาะสมกว่า" }
      ],
      key_takeaway: "Triad ของ anemia + jaundice + splenomegaly เป็น classic presentation ของ hemolytic anemia ต้องตรวจ reticulocyte count, LDH, haptoglobin, indirect bilirubin และ Coombs test เพื่อยืนยันการวินิจฉัย"
    }
  },
  {
    id: "024f6670-800b-4d6e-bc9d-38e95995b85f",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: B. เพิ่ม statin และเพิ่ม antihypertensive เป็น combination therapy (ACE-I/ARB + CCB หรือ thiazide)",
      reason: `ผู้ป่วยหญิงอายุ 60 ปี เป็น DM 3 ปี FBS 140-160 mg/dL HbA1C 7.8% มี hypertension + dyslipidemia BP 140/90 แล้ว 150/90 mmHg สูง 150 cm น้ำหนัก 65 kg (BMI = 28.9 kg/m² = overweight)

ผู้ป่วยรายนี้มี cardiovascular risk factors หลายอย่าง: DM, hypertension, dyslipidemia และ overweight ตาม guidelines ปัจจุบัน การจัดการต้องครอบคลุมทุกปัจจัยเสี่ยง

สำหรับ hypertension ในผู้ป่วย DM: เป้าหมาย BP < 130/80 mmHg (ตาม ADA 2023) ผู้ป่วยมี BP 150/90 ซึ่งไม่ถึงเป้าหมาย ยา first-line สำหรับ hypertension ใน DM คือ ACE-I หรือ ARB เพราะมี renoprotective effect ผ่านการลด intraglomerular pressure หาก BP ยังไม่ถึงเป้าหมายด้วย monotherapy ควรใช้ combination therapy โดยเพิ่ม CCB (เช่น amlodipine) หรือ thiazide diuretic

สำหรับ dyslipidemia: ผู้ป่วย DM อายุ 40-75 ปี ที่มี ASCVD risk factors ต้องได้ statin therapy ตาม ADA guidelines โดยเป็น moderate-intensity statin เป็นอย่างน้อย (เช่น atorvastatin 10-20 mg หรือ rosuvastatin 5-10 mg) หากมี additional risk factors ควรได้ high-intensity statin

สำหรับ DM: HbA1C 7.8% ยังไม่ถึงเป้าหมาย < 7% ต้องปรับยาเบาหวานให้เข้มข้นขึ้น แต่คำถามนี้เน้นที่การจัดการ hypertension + dyslipidemia มากกว่า

ดังนั้นคำตอบที่ถูกต้องที่สุดคือการเพิ่ม statin (สำหรับ dyslipidemia) และเพิ่ม antihypertensive เป็น combination therapy ที่รวม ACE-I/ARB ร่วมกับ CCB หรือ thiazide`,
      choices: [
        { label: "A", text: "เพิ่ม antihypertensive เป็น 2 ชนิด และปรับ antidiabetic ให้เข้มข้นขึ้น", is_correct: false, explanation: "ตัวเลือกนี้ขาดการจัดการ dyslipidemia ด้วย statin ซึ่งเป็นสิ่งจำเป็นในผู้ป่วย DM ที่มี cardiovascular risk factors หลายอย่าง การไม่ให้ statin ในผู้ป่วยกลุ่มนี้ถือว่าขาดส่วนสำคัญของการจัดการ" },
        { label: "B", text: "เพิ่ม statin และเพิ่ม antihypertensive เป็น combination therapy (ACE-I/ARB + CCB หรือ thiazide)", is_correct: true, explanation: "ถูกต้องที่สุด เพราะครอบคลุมการจัดการ dyslipidemia ด้วย statin (ลด ASCVD risk) และจัดการ hypertension ด้วย combination therapy ที่รวม ACE-I/ARB (renoprotective) ร่วมกับ CCB หรือ thiazide เพื่อให้ BP ถึงเป้าหมาย" },
        { label: "C", text: "ใช้ metoprolol เพียงชนิดเดียวเพื่อควบคุมทั้ง hypertension และ diabetes", is_correct: false, explanation: "Beta-blocker เช่น metoprolol ไม่ใช่ first-line สำหรับ hypertension ใน DM เพราะอาจ mask hypoglycemic symptoms, worsen insulin resistance และไม่มี renoprotective effect เหมือน ACE-I/ARB นอกจากนี้ beta-blocker ไม่ได้ช่วยควบคุม diabetes" },
        { label: "D", text: "เพิ่มขนาน sulfonylurea และหยุด antihypertensive เนื่องจาก BP เพิ่งสูงขึ้นเล็กน้อย", is_correct: false, explanation: "การหยุด antihypertensive เป็นอันตรายมากในผู้ป่วย DM ที่มี BP 150/90 ซึ่งสูงกว่าเป้าหมาย < 130/80 mmHg Uncontrolled hypertension เพิ่มความเสี่ยง cardiovascular events, stroke และ diabetic nephropathy อย่างมาก" },
        { label: "E", text: "ให้ ACE-I เพียงชนิดเดียว และทำการลดน้ำหนัก โดยไม่ต้องเพิ่มยาอื่น", is_correct: false, explanation: "ACE-I monotherapy อาจไม่เพียงพอเนื่องจาก BP 150/90 ค่อนข้างสูง อาจต้อง combination therapy ที่สำคัญคือตัวเลือกนี้ขาดการให้ statin สำหรับ dyslipidemia ซึ่งจำเป็นในผู้ป่วย DM ที่มี cardiovascular risk factors" }
      ],
      key_takeaway: "ผู้ป่วย DM ที่มี hypertension + dyslipidemia ต้องจัดการครอบคลุมทุกปัจจัยเสี่ยง: ACE-I/ARB เป็น first-line antihypertensive (renoprotective), statin สำหรับ dyslipidemia และ combination therapy ถ้า BP ไม่ถึงเป้าหมาย"
    }
  },
  {
    id: "02a59e84-f5f8-419c-a618-f9bb1d7c1963",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: B. Stimson technique (เทคนิค Stimson สำหรับจัดกระดูกไหล่หลุด)",
      reason: `ผู้ป่วยมี X-ray แสดง shoulder dislocation โดย head of humerus หลุดออกจาก glenoid fossa คำถามถามว่าเทคนิคใดทำให้เกิดอาการบาดเจ็บน้อยที่สุด (least traumatic)

Shoulder dislocation พบบ่อยที่สุดเป็น anterior dislocation (95%) กลไกมักเป็น abduction + external rotation ทำให้ humeral head เลื่อนไปด้านหน้าผ่าน inferior glenohumeral ligament มีเทคนิคหลายวิธีในการ reduce shoulder dislocation:

Stimson technique (Dangling technique): ผู้ป่วยนอนคว่ำ (prone position) บนเตียงโดยให้แขนข้างที่หลุดห้อยลงจากขอบเตียง แขวนน้ำหนัก 2-5 kg ที่ข้อมือหรือปล่อยให้แรงโน้มถ่วงดึงเอง รอประมาณ 20-30 นาที แรงโน้มถ่วงจะค่อยๆ ดึง humeral head กลับเข้า glenoid เทคนิคนี้ถือว่า least traumatic ที่สุดเพราะใช้แรงน้อย ไม่ต้องใช้ leverage หรือ traction มาก ลดความเสี่ยงของ iatrogenic fracture

Milch technique: ผู้ป่วยนอนหงาย ค่อยๆ abduct แขนขึ้นเหนือศีรษะ (overhead position) แล้วใช้ thumb ดัน humeral head กลับเข้า glenoid เป็นเทคนิคที่ gentle แต่ยังต้องใช้แรงในการ manipulate

Hippocratic technique: แพทย์ใช้ส้นเท้าวางที่ axilla ของผู้ป่วยเป็น counter-traction แล้วดึงแขน เป็นเทคนิคเก่าแก่ที่มีความเสี่ยงต่อ axillary nerve injury สูงกว่า

Kocher technique: ใช้ series ของ movements (traction, external rotation, adduction, internal rotation) มีความเสี่ยงต่อ spiral fracture ของ humerus ได้

External rotation technique: ค่อยๆ external rotate แขนที่ adducted เทคนิคนี้ gentle แต่อาจใช้เวลานาน`,
      choices: [
        { label: "A", text: "Milch technique", is_correct: false, explanation: "Milch technique เป็นเทคนิคที่ gentle เช่นกัน โดยค่อยๆ abduct แขนขึ้นเหนือศีรษะแล้วดัน humeral head กลับเข้า glenoid แต่ยังต้องใช้แรงในการ manipulate และต้องมีผู้ช่วย จึงไม่ใช่เทคนิคที่ least traumatic ที่สุดเมื่อเทียบกับ Stimson" },
        { label: "B", text: "Stimson technique", is_correct: true, explanation: "ถูกต้อง เพราะ Stimson technique เป็นเทคนิคที่ least traumatic ที่สุด ใช้เพียงแรงโน้มถ่วงในการดึง humeral head กลับเข้า glenoid โดยไม่ต้องใช้แรง manipulation จากแพทย์มาก ลดความเสี่ยง iatrogenic injury ผู้ป่วยนอนคว่ำ แขนห้อย ใช้น้ำหนักเล็กน้อยช่วย" },
        { label: "C", text: "Hippocrate technique", is_correct: false, explanation: "Hippocratic technique ใช้ส้นเท้าเป็น fulcrum ที่ axilla ร่วมกับ traction ที่แขน เป็นเทคนิคที่ใช้แรงมากพอสมควรและมีความเสี่ยงต่อ axillary nerve injury, vascular injury บริเวณ axilla จึงไม่ใช่ least traumatic" },
        { label: "D", text: "Kocher technique", is_correct: false, explanation: "Kocher technique ใช้ series ของ movements ที่รวม traction, external rotation, adduction และ internal rotation มีความเสี่ยงต่อ spiral fracture ของ humeral shaft โดยเฉพาะในผู้สูงอายุที่มี osteoporosis จึงไม่ใช่ least traumatic" },
        { label: "E", text: "External rotation technique", is_correct: false, explanation: "External rotation technique เป็นเทคนิคที่ค่อนข้าง gentle โดยค่อยๆ external rotate แขนที่อยู่ในท่า adduction แต่ยังต้องใช้แรงในการ rotate และอาจเจ็บในระหว่างทำ Stimson technique ที่ใช้เพียงแรงโน้มถ่วงจึง least traumatic กว่า" }
      ],
      key_takeaway: "Stimson technique (dangling technique) เป็นวิธี reduce shoulder dislocation ที่ least traumatic ที่สุด เพราะใช้เพียงแรงโน้มถ่วง ผู้ป่วยนอนคว่ำ แขนห้อยจากขอบเตียง แขวนน้ำหนักเล็กน้อย รอ 20-30 นาที"
    }
  },
  {
    id: "02e605ad-718f-4f6b-ad70-e24dfb34ee99",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Colles' fracture (กระดูกปลายแขนหัก Colles')",
      reason: `ผู้ป่วยหญิงไทยอายุ 50 ปี ล้มเอาศอกยันพื้น (fall on outstretched hand - FOOSH mechanism) ตรวจพบข้อมือขวาบวมผิดรูป ซึ่งเป็น classic presentation ของ Colles' fracture

Colles' fracture คือ fracture ของ distal radius ที่เกิดภายใน 2.5 cm จาก articular surface โดยมี dorsal angulation/displacement ของ distal fragment ทำให้ข้อมือมีลักษณะ "dinner fork deformity" เมื่อมองจากด้านข้าง เป็น fracture ที่พบบ่อยที่สุดของ distal radius

กลไกการบาดเจ็บ: เมื่อล้มแล้วใช้มือยันพื้น (FOOSH) แรงกระแทกจะส่งผ่านมือไปยัง distal radius ในขณะที่ข้อมืออยู่ในท่า dorsiflexion ทำให้ distal radius หักและเลื่อนไปทางด้านหลัง (dorsal displacement)

ผู้ป่วยหญิงอายุ 50 ปี เป็นกลุ่มที่มีความเสี่ยงสูงต่อ Colles' fracture เนื่องจาก postmenopausal osteoporosis ทำให้กระดูก cancellous bone ที่ distal radius อ่อนแอลง Colles' fracture จึงถูกเรียกว่า "osteoporotic fracture" หรือ "fragility fracture"

การตรวจร่างกายมักพบ swelling, deformity (dinner fork), tenderness ที่ distal radius และอาจมี median nerve compression (carpal tunnel syndrome) จากอาการบวม การวินิจฉัยยืนยันด้วย X-ray AP และ lateral view ที่จะพบ fracture line ที่ distal radius with dorsal angulation/displacement`,
      choices: [
        { label: "A", text: "Colles' fracture", is_correct: true, explanation: "ถูกต้อง เพราะ Colles' fracture เป็น fracture ที่พบบ่อยที่สุดจาก FOOSH mechanism ในหญิงวัย postmenopausal อาการข้อมือบวมผิดรูปหลังล้มเอาศอกยันพื้นเป็น classic presentation ของ Colles' fracture ที่มี dorsal displacement ของ distal radius fragment" },
        { label: "B", text: "Greenstick fracture", is_correct: false, explanation: "Greenstick fracture เป็น incomplete fracture ที่พบเฉพาะในเด็กเท่านั้น เพราะกระดูกเด็กยังมี periosteum ที่หนาและยืดหยุ่น ทำให้กระดูกหักเพียงด้านเดียวคล้ายกิ่งไม้สด ผู้ป่วยรายนี้อายุ 50 ปี จึงไม่ใช่ greenstick fracture" },
        { label: "C", text: "Fracture both bone", is_correct: false, explanation: "Fracture both bone forearm หมายถึงกระดูก radius และ ulna หักทั้งคู่ มักเกิดจากแรงกระแทกโดยตรง (direct blow) ที่ forearm ไม่ใช่ FOOSH mechanism และมักทำให้เกิด deformity ที่ forearm ไม่ใช่ที่ข้อมือ" },
        { label: "D", text: "Wrist dislocation", is_correct: false, explanation: "Wrist dislocation (เช่น lunate dislocation, perilunate dislocation) พบได้น้อยกว่า Colles' fracture มาก และมักเกิดจากแรงกระแทกที่รุนแรงกว่า เช่น ตกจากที่สูง หรืออุบัติเหตุรถยนต์ ในหญิงอายุ 50 ปีที่ล้มธรรมดา Colles' fracture เป็นคำตอบที่เหมาะสมกว่า" },
        { label: "E", text: "Supracondylar Fracture", is_correct: false, explanation: "Supracondylar fracture เป็น fracture ที่เกิดเหนือ condyle ของ humerus (ข้อศอก) ไม่ใช่ที่ข้อมือ พบบ่อยในเด็กมากกว่าผู้ใหญ่ ผู้ป่วยรายนี้มี deformity ที่ข้อมือ ไม่ใช่ที่ข้อศอก จึงไม่ใช่ supracondylar fracture" }
      ],
      key_takeaway: "Colles' fracture เป็น distal radius fracture ที่พบบ่อยที่สุดจาก FOOSH mechanism โดยเฉพาะในหญิง postmenopausal ที่มี osteoporosis ลักษณะสำคัญคือ dinner fork deformity จาก dorsal displacement ของ distal fragment"
    }
  },
  {
    id: "0331a7d2-6ddc-43c3-ae29-c60c27160b2f",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: C. เข้ารับการประเมินความเสี่ยงทันทีที่ห้องแพทย์ เพื่อพิจารณาการให้ยาป้องกันหลังการสัมผัสเชื้อ (PEP) ภายใน 2 ชั่วโมง",
      reason: `เจ้าหน้าที่ห้องแล็บเกิดอุบัติเหตุเข็มเจาะทะลุมือ (needlestick injury) หลังจากเจาะเลือดผู้ป่วยที่ติดเชื้อ HIV นี่คือ occupational exposure ที่ต้องมีการจัดการอย่างเร่งด่วนและเป็นระบบ

ขั้นตอนการจัดการ needlestick injury จาก HIV-positive source:

1. First aid ทันที: ล้างบาดแผลด้วยน้ำไหลและสบู่ ไม่ควรบีบหรือรีดเลือดออก (การบีบอาจทำให้เนื้อเยื่อบาดเจ็บเพิ่มและเพิ่มการดูดซึมเชื้อ)

2. Risk assessment และ PEP: สิ่งที่สำคัญที่สุดคือการเข้ารับการประเมินความเสี่ยง (risk assessment) ทันทีเพื่อพิจารณาให้ Post-Exposure Prophylaxis (PEP) ภายใน 2 ชั่วโมง (ไม่ควรเกิน 72 ชั่วโมง) ความเสี่ยงการติดเชื้อ HIV จาก needlestick injury ประมาณ 0.3% (1 ใน 300) ขึ้นอยู่กับ viral load ของ source, depth of injury, hollow vs solid needle และ presence of visible blood

3. PEP regimen: ตามแนวทางปัจจุบันใช้ 3-drug ART regimen (เช่น tenofovir + emtricitabine + dolutegravir) ให้ต่อเนื่อง 28 วัน

4. Baseline testing: ตรวจ HIV, HBV, HCV ของ exposed person ที่ baseline แล้วติดตามที่ 6 สัปดาห์, 12 สัปดาห์ และ 6 เดือน

5. Counseling: ให้คำปรึกษาเรื่องอาการข้างเคียงของ PEP, การป้องกันการแพร่เชื้อระหว่างรอผลตรวจ (ใช้ถุงยาง, ห้ามบริจาคเลือด)

เหตุผลที่ข้อ C ถูกต้องที่สุดคือเน้น 'การประเมินความเสี่ยงทันทีเพื่อพิจารณา PEP' ซึ่งเป็นขั้นตอนที่สำคัญที่สุดและมีผลต่อ outcome มากที่สุด`,
      choices: [
        { label: "A", text: "ล้างบาดแผลด้วยน้ำไหลและสบู่ทันทีแล้วบีบเลือดออกมาเพื่อลดโอกาสการติดเชื้อ", is_correct: false, explanation: "การล้างแผลด้วยน้ำไหลและสบู่ถูกต้องเป็น first aid แต่การบีบเลือดออกไม่แนะนำตาม WHO guidelines เพราะอาจทำให้เนื้อเยื่อบาดเจ็บเพิ่มขึ้นและเพิ่มพื้นที่ผิวที่สัมผัสเชื้อ ที่สำคัญกว่าคือต้องเข้ารับ risk assessment เพื่อพิจารณา PEP ทันที" },
        { label: "B", text: "นั่งรอและสังเกตอาการเพราะอุบัติเหตุจากเข็มมีความเสี่ยงต่ำในการส่งเชื้อ HIV", is_correct: false, explanation: "แม้ความเสี่ยงจะอยู่ที่ 0.3% แต่ไม่ใช่ศูนย์ และ HIV เป็นโรคที่รักษาไม่หาย PEP ที่ให้ทันเวลาสามารถลดความเสี่ยงได้ถึง 80% การนั่งรอโดยไม่ทำอะไรเป็นการปฏิบัติที่ไม่เหมาะสมอย่างยิ่ง" },
        { label: "C", text: "เข้ารับการประเมินความเสี่ยงทันทีที่ห้องแพทย์ เพื่อพิจารณาการให้ยาป้องกันหลังการสัมผัสเชื้อ (PEP) ภายใน 2 ชั่วโมง", is_correct: true, explanation: "ถูกต้องที่สุด เพราะ PEP เป็นมาตรการที่สำคัญที่สุดในการลดความเสี่ยงการติดเชื้อ HIV หลัง needlestick injury ต้องเริ่มให้เร็วที่สุด โดยเฉพาะภายใน 2 ชั่วโมง (ไม่ควรเกิน 72 ชั่วโมง) การประเมินความเสี่ยงจะช่วยตัดสินใจว่าควรให้ PEP หรือไม่" },
        { label: "D", text: "ไม่จำเป็นต้องรับการตรวจเลือด เพราะความเสี่ยงส่วนใหญ่มาจากการผ่าตัด ไม่ใช่เจาะเลือด", is_correct: false, explanation: "ข้อมูลนี้ไม่ถูกต้อง needlestick injury จากเข็มกลวง (hollow bore needle) ที่ใช้เจาะเลือดมีความเสี่ยงสูงกว่าเข็มตัน (solid needle) เช่น เข็มเย็บแผล เพราะเข็มกลวงสามารถบรรจุเลือดปริมาณมากกว่า การตรวจเลือดของ exposed person เป็นสิ่งจำเป็น" },
        { label: "E", text: "เข้ารับการรักษาด้วยยา antiretroviral แบบปกติ (ART) ตั้งแต่วันแรก", is_correct: false, explanation: "PEP ไม่เหมือนกับ ART ที่ใช้รักษาผู้ป่วย HIV PEP ใช้เป็นระยะเวลา 28 วันเท่านั้น ไม่ใช่ lifelong treatment แม้ว่าจะใช้ยา ART เหมือนกัน แต่จุดประสงค์ต่างกัน คือ PEP มุ่งป้องกันการติดเชื้อ ไม่ใช่รักษา HIV ที่ยืนยันแล้ว" }
      ],
      key_takeaway: "Needlestick injury จาก HIV-positive source ต้องรีบเข้ารับการประเมินความเสี่ยงและพิจารณา PEP ภายใน 2 ชั่วโมง (ไม่เกิน 72 ชั่วโมง) ใช้ 3-drug ART regimen ต่อเนื่อง 28 วัน PEP สามารถลดความเสี่ยงการติดเชื้อ HIV ได้ถึง 80%"
    }
  },
  {
    id: "03f3913c-72e1-4c17-8f68-bf54786d14d5",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: C. การเจาะเลือดจากสายสัมพันธ์ (line) ที่ใช้ heparin flush ก่อนหรือไม่ได้ล้างอย่างถูกต้อง",
      reason: `ผู้ป่วยชายอายุ 65 ปี ได้รับ heparin IV infusion สำหรับ DVT มา 5 วัน ตรวจ APTT ซ้ำพบว่ายาวขึ้นเกินคาด (prolonged APTT) ตัวอย่างเลือดมีสีเหลืองอ่อน สงสัย heparin contamination ในตัวอย่างเลือด

In vitro heparin contamination เป็นปัญหา pre-analytical error ที่พบบ่อยในการตรวจ coagulation studies สาเหตุที่พบบ่อยที่สุดคือการเจาะเลือดจาก IV line หรือ central venous catheter ที่ใช้ heparin flush/lock โดยไม่ได้ discard blood ปริมาณที่เพียงพอก่อน (มักต้อง discard อย่างน้อย 5-6 mL หรือ 2-3 เท่าของ dead space volume)

เมื่อ heparin ปนเปื้อนในตัวอย่างเลือดจะทำให้ APTT ยาวขึ้นอย่างมาก เนื่องจาก heparin จะ potentiate antithrombin III ในหลอดทดลอง ทำให้ coagulation factors (โดยเฉพาะ thrombin และ factor Xa) ถูก inhibit PT อาจยาวขึ้นเล็กน้อยถ้ามี heparin contamination มาก

Plasma ที่มี heparin contamination มักมีลักษณะสีเหลืองอ่อนใสกว่าปกติ (icteremic plasma ต่างจาก heparin contamination ตรงที่จะเป็นสีเหลืองเข้ม) สิ่งที่ช่วยยืนยัน heparin contamination ได้แก่ thrombin time ที่ยาวมาก (very sensitive to heparin), protamine sulfate correction test หรือ heparinase treatment ที่ทำให้ APTT กลับสู่ปกติ

วิธีป้องกัน heparin contamination: เจาะเลือดจาก site อื่นที่ไม่ใช่ IV line, ถ้าจำเป็นต้องเจาะจาก line ต้อง flush ด้วย NSS ก่อนและ discard blood อย่างน้อย 5-6 mL ก่อนเก็บตัวอย่างสำหรับ coagulation study`,
      choices: [
        { label: "A", text: "การใช้หลอดแบบสีเขียว (green top tube) ที่มี lithium heparin แทนหลอดเก็บเลือดสำหรับ coagulation study", is_correct: false, explanation: "แม้ว่าการใช้ green top tube (lithium heparin tube) แทน blue top tube (sodium citrate) จะทำให้ APTT ผิดปกติได้ แต่ข้อผิดพลาดนี้จะถูกตรวจพบง่ายเพราะเจ้าหน้าที่จะเห็นว่าใช้หลอดผิดชนิด ในทางปฏิบัติไม่ค่อยเกิดขึ้นเพราะมีระบบ labeling ที่ชัดเจน" },
        { label: "B", text: "การสะอาดแขนด้วยสารฆ่าเชื้ออย่าง heparin ก่อนเจาะเลือด", is_correct: false, explanation: "ไม่มีการใช้ heparin เป็นสารทำความสะอาดผิวหนังก่อนเจาะเลือด สารที่ใช้ทำความสะอาดคือ alcohol swab (70% isopropyl alcohol) หรือ chlorhexidine ซึ่งไม่มีผลต่อ coagulation tests ตัวเลือกนี้จึงไม่ถูกต้องทั้งในแง่ข้อเท็จจริงและเหตุผล" },
        { label: "C", text: "การเจาะเลือดจากสายสัมพันธ์ (line) ที่ใช้ heparin flush ก่อนหรือไม่ได้ล้างอย่างถูกต้อง", is_correct: true, explanation: "ถูกต้อง เพราะนี่คือสาเหตุหลักที่พบบ่อยที่สุดของ heparin contamination ใน coagulation specimens เมื่อเจาะเลือดจาก IV line ที่ใช้ heparin flush/lock โดยไม่ discard blood เพียงพอ heparin residual จะปนเปื้อนในตัวอย่างทำให้ APTT ยาวขึ้นเกินจริง" },
        { label: "D", text: "การเก็บตัวอย่างเลือดในหลอดสีม่วง (lavender top tube) ที่มีสารละลาย heparin", is_correct: false, explanation: "หลอดสีม่วง (lavender top tube) มี EDTA เป็น anticoagulant ไม่ใช่ heparin EDTA จะทำให้ APTT ยาวขึ้นได้เช่นกัน แต่ผ่านกลไกที่ต่างกัน (chelation of calcium) และจะทำให้ทั้ง PT และ APTT ยาวขึ้น ไม่ใช่สาเหตุของ heparin contamination" },
        { label: "E", text: "การปนเปื้อนจากแพทย์ที่ใส่มือถุง heparin coated ระหว่างการเจาะเลือด", is_correct: false, explanation: "ไม่มีการใช้ heparin-coated gloves ในทางปฏิบัติทางการแพทย์ ถุงมือที่ใช้ในการเจาะเลือดเป็น latex, nitrile หรือ vinyl ไม่ได้เคลือบ heparin ตัวเลือกนี้ไม่เป็นจริงทางคลินิก" }
      ],
      key_takeaway: "Heparin contamination จากการเจาะเลือดผ่าน IV line ที่ใช้ heparin flush เป็น pre-analytical error ที่พบบ่อยที่สุดใน coagulation studies ป้องกันโดยเจาะเลือดจาก peripheral site อื่น หรือ discard blood อย่างน้อย 5-6 mL ก่อนเก็บตัวอย่าง"
    }
  },
  {
    id: "040ff8c1-2870-422e-a66d-b1cf4d6c3cf5",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: B. Amphetamine (พิษจากแอมเฟตามีน - Sympathomimetic toxidrome)",
      reason: `ผู้ป่วยหญิงอายุ 45 ปี กินยาอะไรไม่ทราบมา 2 ชั่วโมง ตรวจพบ: T 38°C (ไข้เล็กน้อย), P 130 (tachycardia), BP 140/90 (hypertension), stupor (ซึม), flushing (หน้าแดง), lung clear, decreased bowel sound, pupil 4mm reactive to light

การวิเคราะห์ toxidrome: ผู้ป่วยมี tachycardia + hypertension + hyperthermia + altered mental status ซึ่งเป็นลักษณะของ sympathomimetic toxidrome ที่เกิดจากสารกระตุ้นระบบประสาท sympathetic เช่น amphetamine, cocaine, methamphetamine

Sympathomimetic toxidrome เกิดจากการกระตุ้น catecholamine release (norepinephrine, dopamine, serotonin) ทำให้เกิด: tachycardia (beta-1 stimulation), hypertension (alpha-1 stimulation), hyperthermia (เพิ่ม metabolic rate), mydriasis (alpha-1 ที่ dilator pupillae), diaphoresis, agitation หรือ psychosis

ต้องแยกจาก toxidrome อื่นๆ:
- Anticholinergic toxidrome (amitriptyline): มี "hot as a hare, blind as a bat, dry as a bone, red as a beet, mad as a hatter" คือ mydriasis, dry skin, urinary retention, decreased bowel sound ผู้ป่วยรายนี้มี decreased bowel sound แต่ pupil 4mm ไม่ dilated มาก ซึ่งไม่ค่อยเข้ากับ anticholinergic ที่มักมี pupil dilated มาก (6-8mm)
- Sedative/hypnotic (diazepam): จะมี CNS depression, miosis, hypotension, decreased RR ตรงข้ามกับผู้ป่วยรายนี้
- Opioid: จะมี miosis (pinpoint pupils), respiratory depression, hypotension
- Organophosphate (cholinergic toxidrome): จะมี SLUDGE (salivation, lacrimation, urination, defecation, GI cramps, emesis), miosis, bradycardia

Amphetamine ทำให้เกิด tachycardia, hypertension, hyperthermia, agitation/stupor ซึ่งตรงกับผู้ป่วยรายนี้มากที่สุด Pupil 4mm อาจยังไม่ dilated มากเพราะอยู่ในช่วง stupor`,
      choices: [
        { label: "A", text: "Amitriptyline", is_correct: false, explanation: "Amitriptyline (TCA) toxicity จะมี anticholinergic signs ที่เด่นชัดกว่า: mydriasis ขนาดใหญ่ (6-8mm), dry mucous membranes, urinary retention, skin flush แม้จะมี tachycardia ร่วมด้วย แต่ TCA toxicity ที่รุนแรงมักมี wide QRS complex, seizure และ hypotension มากกว่า hypertension ผู้ป่วยรายนี้มี pupil 4mm ซึ่งไม่เข้ากับ anticholinergic toxidrome" },
        { label: "B", text: "Amphetamine", is_correct: true, explanation: "ถูกต้อง เพราะ amphetamine toxicity ทำให้เกิด sympathomimetic toxidrome ที่ตรงกับอาการผู้ป่วย: tachycardia (P 130), hypertension (BP 140/90), hyperthermia (T 38°C), altered mental status (stupor), flushing จากการเพิ่ม catecholamine release" },
        { label: "C", text: "Diazepam", is_correct: false, explanation: "Diazepam (benzodiazepine) toxicity ทำให้เกิด CNS depression, drowsiness, ataxia แต่จะมี normal vital signs หรือ mild hypotension, normal-to-slow heart rate ไม่ทำให้เกิด tachycardia, hypertension หรือ hyperthermia ที่เด่นชัดเช่นนี้" },
        { label: "D", text: "Opioid", is_correct: false, explanation: "Opioid toxicity มี classic triad: CNS depression (coma), respiratory depression (RR ต่ำ) และ miosis (pinpoint pupils) ผู้ป่วยรายนี้มี RR ที่ไม่ลดลง (ไม่ได้ระบุว่าต่ำ), pupil 4mm (ไม่ใช่ pinpoint) และ tachycardia + hypertension ซึ่งตรงข้ามกับ opioid toxicity" },
        { label: "E", text: "Organophosphate", is_correct: false, explanation: "Organophosphate poisoning ทำให้เกิด cholinergic crisis: SLUDGE symptoms (salivation, lacrimation, urination, defecation, GI cramps, emesis), miosis (pinpoint pupils), bradycardia, bronchospasm ผู้ป่วยรายนี้มี decreased bowel sound (ตรงข้ามกับ increased bowel activity), tachycardia (ไม่ใช่ bradycardia) จึงไม่ใช่ organophosphate" }
      ],
      key_takeaway: "Sympathomimetic toxidrome (amphetamine/cocaine): tachycardia, hypertension, hyperthermia, mydriasis, agitation/psychosis แยกจาก anticholinergic ที่มี dry skin, urinary retention, mydriasis ขนาดใหญ่กว่า และ opioid ที่มี miosis, respiratory depression"
    }
  },
  {
    id: "041a87fa-93e4-46f7-9d96-122c916a2779",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: B. ให้คำปรึกษาอย่างรอบด้านเกี่ยวกับความเสี่ยงและตัวเลือกต่างๆ แล้วตัดสินใจร่วมกับมารดา",
      reason: `สตรีตั้งครรภ์ 28 สัปดาห์ ผล quad screen แสดงความเสี่ยงสูงต่อ Down syndrome คำถามคือแพทย์ควรดำเนินการอย่างไรต่อไป

Quad screen (Quadruple marker test) เป็นการตรวจคัดกรอง (screening test) ไม่ใช่การตรวจวินิจฉัย (diagnostic test) ประกอบด้วย AFP (low), hCG (high), uE3 (low) และ inhibin A (high) ในกรณี Down syndrome ค่า detection rate อยู่ที่ประมาณ 81% โดยมี false positive rate 5%

เนื่องจาก quad screen เป็น screening test ผลบวกไม่ได้หมายความว่าทารกเป็น Down syndrome แน่นอน จำเป็นต้องมีการตรวจยืนยัน (confirmatory diagnostic test) ก่อน ซึ่งได้แก่:
- Amniocentesis (การเจาะน้ำคร่ำ): ทำได้ตั้งแต่ 15-20 สัปดาห์ ที่ 28 สัปดาห์ยังทำได้ มีความเสี่ยง pregnancy loss ประมาณ 0.1-0.3%
- Chorionic villus sampling (CVS): ทำที่ 10-13 สัปดาห์ ที่ 28 สัปดาห์ไม่สามารถทำได้แล้ว
- Non-invasive prenatal testing (NIPT): ตรวจ cell-free fetal DNA ในเลือดมารดา มี sensitivity > 99% สำหรับ Down syndrome ไม่มี risk ของ pregnancy loss

หลักการทางจริยธรรมการแพทย์ที่สำคัญในกรณีนี้คือ respect for autonomy (เคารพสิทธิ์การตัดสินใจของผู้ป่วย) และ shared decision making (การตัดสินใจร่วมกัน) แพทย์ต้องให้ข้อมูลที่ครบถ้วนเกี่ยวกับความเสี่ยง ตัวเลือกการตรวจเพิ่มเติม ข้อดีข้อเสียของแต่ละตัวเลือก แล้วให้มารดาตัดสินใจเลือกร่วมกับแพทย์ ไม่ควรตัดสินใจแทนผู้ป่วยหรือบังคับให้ทำหัตถการ`,
      choices: [
        { label: "A", text: "บอกมารดาว่ามีความเสี่ยงสูงมาก แนะนำให้ทำการตัดสินใจตามที่มารดาต้องการหลังจากให้คำแนะนำเพียงพอ", is_correct: false, explanation: "แม้ว่าจะเคารพสิทธิ์การตัดสินใจของมารดา แต่ไม่ได้ระบุถึงตัวเลือกการตรวจเพิ่มเติมที่เฉพาะเจาะจง การบอกว่า 'เสี่ยงสูงมาก' โดยไม่อธิบายว่า screening test ต่างจาก diagnostic test อาจทำให้มารดาเข้าใจผิดและตกใจเกินไป" },
        { label: "B", text: "ให้คำปรึกษาอย่างรอบด้านเกี่ยวกับความเสี่ยงและตัวเลือกต่างๆ แล้วตัดสินใจร่วมกับมารดา", is_correct: true, explanation: "ถูกต้องที่สุด เพราะสอดคล้องกับหลัก shared decision making แพทย์ต้องอธิบายว่า quad screen เป็น screening test ที่อาจมี false positive ให้ข้อมูลเกี่ยวกับตัวเลือก (amniocentesis, NIPT) ข้อดีข้อเสีย ความเสี่ยงของแต่ละตัวเลือก แล้วตัดสินใจร่วมกัน" },
        { label: "C", text: "ส่งตรวจ amniocentesis ทันที โดยไม่ต้องปรึกษาหรือขออนุญาตจากมารดา", is_correct: false, explanation: "การส่งตรวจ amniocentesis โดยไม่ปรึกษาหรือขออนุญาตจากมารดาเป็นการละเมิดหลัก informed consent และ respect for autonomy Amniocentesis เป็น invasive procedure ที่มีความเสี่ยง pregnancy loss ต้องได้รับ informed consent ก่อนเสมอ" },
        { label: "D", text: "บอกให้มารดาไปหาคำปรึกษาจากสถาบันอื่นๆ เพราะแพทย์ไม่มีหน้าที่ในการให้คำแนะนำในเรื่องนี้", is_correct: false, explanation: "แพทย์ผู้ดูแลการตั้งครรภ์มีหน้าที่โดยตรงในการให้คำปรึกษาเกี่ยวกับผลการตรวจคัดกรอง การปฏิเสธหน้าที่นี้ถือว่า abandonment of care อาจส่ง refer ไปพบ genetic counselor ได้ แต่ไม่ใช่การ 'ไม่มีหน้าที่'" },
        { label: "E", text: "บอกมารดาว่าไม่จำเป็นต้องทำการตรวจเพิ่มเติม เพราะ quad screen ไม่ได้บ่งชี้ถึงโรคที่แน่นอน", is_correct: false, explanation: "แม้ว่าจะถูกต้องที่ quad screen ไม่ได้วินิจฉัยโรค แต่การบอกว่าไม่จำเป็นต้องตรวจเพิ่มเติมเป็นการให้ข้อมูลที่ไม่ครบถ้วน ผลที่ positive ควรได้รับการ counseling และเสนอ confirmatory testing เพื่อให้มารดาตัดสินใจอย่างรอบคอบ" }
      ],
      key_takeaway: "เมื่อ screening test (quad screen) ให้ผลบวก ต้องให้ genetic counseling อย่างรอบด้าน อธิบายว่าเป็น screening ไม่ใช่ diagnosis เสนอ confirmatory testing (amniocentesis, NIPT) และตัดสินใจร่วมกันตามหลัก shared decision making"
    }
  },
  {
    id: "044fa007-2ff4-420d-9a1e-a953b0adfde6",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: B. Airway obstruction, bleeding, CNS injury (การอุดตันทางเดินหายใจ เลือดออก การบาดเจ็บสมอง)",
      reason: `คำถามถามถึง 3 สาเหตุแรกที่พบบ่อยที่สุดของการเสียชีวิตจากอุบัติเหตุ (trauma) ในเด็ก ตามลำดับความสำคัญ

ในเด็กที่ได้รับบาดเจ็บ สาเหตุการเสียชีวิตเรียงตามลำดับความพบบ่อย:

1. Airway obstruction: เป็นสาเหตุที่สำคัญที่สุดและป้องกันได้มากที่สุด เด็กมีความเสี่ยงสูงต่อ airway obstruction เนื่องจาก anatomical differences ได้แก่ ศีรษะใหญ่กว่าตัว (relatively large occiput) ทำให้ neck flexion เวลานอนหงาย, ลิ้นใหญ่เมื่อเทียบกับช่องปาก, larynx อยู่สูงกว่าและ anterior มากกว่าผู้ใหญ่, trachea สั้นและเล็ก ทำให้ foreign body obstruction ง่ายกว่า

2. Hemorrhage/Bleeding: เป็นสาเหตุที่สำคัญเป็นอันดับ 2 เด็กมี circulating blood volume น้อย (~80 mL/kg) ดังนั้นการสูญเสียเลือดแม้เพียงเล็กน้อยอาจทำให้เกิด hypovolemic shock ได้ อวัยวะที่มักได้รับบาดเจ็บและเลือดออกในเด็กคือ ม้าม ตับ และไต เนื่องจากผนังหน้าท้องบาง กระดูกซี่โครงยืดหยุ่นป้องกันอวัยวะได้น้อยกว่า

3. CNS injury: เป็นสาเหตุที่สำคัญเป็นอันดับ 3 Traumatic brain injury (TBI) เป็นสาเหตุหลักของ long-term disability และ death ในเด็ก เด็กมีความเสี่ยงสูงต่อ TBI เพราะศีรษะใหญ่เมื่อเทียบกับตัว สมองมี higher water content และ unmyelinated fibers ทำให้ susceptible ต่อ diffuse axonal injury มากกว่า

ลำดับนี้สอดคล้องกับหลัก ATLS (Advanced Trauma Life Support) ที่ว่า A (Airway) มาก่อน B (Breathing) C (Circulation/bleeding) และ D (Disability/neurological)`,
      choices: [
        { label: "A", text: "Bleeding, CNS injury, Airway obstruction", is_correct: false, explanation: "ลำดับไม่ถูกต้อง Airway obstruction เป็นสาเหตุแรก ไม่ใช่อันดับ 3 ตามหลัก ATLS airway problem ต้องได้รับการจัดการก่อน circulation เสมอ เพราะ airway obstruction ทำให้เสียชีวิตเร็วที่สุดถ้าไม่ได้รับการแก้ไข" },
        { label: "B", text: "Airway obstruction, bleeding, CNS injury", is_correct: true, explanation: "ถูกต้อง ตามลำดับความสำคัญ: (1) Airway obstruction เป็นอันตรายเร่งด่วนที่สุดและป้องกันได้มากที่สุด (2) Hemorrhage/bleeding เป็นสาเหตุที่สำคัญเป็นอันดับ 2 (3) CNS injury เป็นสาเหตุหลักของ long-term disability" },
        { label: "C", text: "Airway obstruction, bleeding, chest trauma", is_correct: false, explanation: "Chest trauma เป็นกลไกของการบาดเจ็บ ไม่ใช่สาเหตุการเสียชีวิตโดยตรง Chest trauma อาจทำให้เกิด pneumothorax, hemothorax หรือ cardiac tamponade ซึ่งจะนำไปสู่ airway/breathing problem หรือ hemorrhage ดังนั้น CNS injury เหมาะสมกว่าเป็นอันดับ 3" },
        { label: "D", text: "Bleeding, chest trauma, abdominal injury", is_correct: false, explanation: "ลำดับไม่ถูกต้องและไม่รวม airway obstruction ซึ่งเป็นสาเหตุอันดับ 1 นอกจากนี้ chest trauma และ abdominal injury เป็นกลไกของการบาดเจ็บ ไม่ใช่ categories ของสาเหตุการเสียชีวิต" },
        { label: "E", text: "CNS injury, bleeding, abdominal injury", is_correct: false, explanation: "ลำดับไม่ถูกต้อง CNS injury ไม่ใช่สาเหตุอันดับ 1 และไม่รวม airway obstruction ซึ่งเป็นสาเหตุที่สำคัญที่สุด Abdominal injury เป็นกลไก ไม่ใช่ category ของสาเหตุการเสียชีวิต" }
      ],
      key_takeaway: "สาเหตุการเสียชีวิตจากอุบัติเหตุในเด็ก 3 อันดับแรก: (1) Airway obstruction (2) Hemorrhage (3) CNS injury สอดคล้องกับ ATLS sequence A-B-C-D และเด็กมีความเสี่ยงสูงกว่าผู้ใหญ่เนื่องจาก anatomical differences"
    }
  }
];

async function main() {
  console.log('Starting batch 1: questions 0-19');
  let success = 0;
  let failed = 0;

  for (const item of explanations) {
    try {
      const { error } = await supabase
        .from('mcq_questions')
        .update({ detailed_explanation: item.detailed_explanation })
        .eq('id', item.id);

      if (error) {
        console.error(`Failed ${item.id}: ${error.message}`);
        failed++;
      } else {
        console.log(`Updated ${item.id}`);
        success++;
      }
    } catch (err) {
      console.error(`Error ${item.id}: ${err.message}`);
      failed++;
    }
  }

  console.log(`\nBatch 1 complete: ${success} success, ${failed} failed`);
}

main();
