require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

const updates = [
  {
    id: "1255867d-ad9c-417a-aa1a-10d854420e9c",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Intussusception (ลำไส้กลืนกัน)",
      reason: "ผู้ป่วยเด็กชายอายุ 1 ปี มีอาการท้องเสียเป็นน้ำ 2 วัน ต่อมามีอาการร้องกรีดเป็นพักๆ และถ่ายเป็นมูกปนเลือด ร่วมกับตรวจพบก้อนคลำได้ที่ช่องท้องด้านขวาบน ลักษณะอาการเหล่านี้เป็น classic triad ของ intussusception ซึ่งประกอบด้วย colicky abdominal pain (ปวดท้องเป็นพักๆ), bloody mucoid stool (ถ่ายเป็นมูกปนเลือดหรือที่เรียกว่า currant jelly stool) และ abdominal mass (ก้อนในท้อง)\n\nIntussusception เป็นภาวะที่ลำไส้ส่วนต้นสอดเข้าไปในลำไส้ส่วนปลาย (telescoping) โดยชนิดที่พบบ่อยที่สุดคือ ileocolic type ซึ่งส่วน ileum สอดเข้าไปใน colon ผ่าน ileocecal valve พบบ่อยที่สุดในเด็กอายุ 6 เดือน - 2 ปี โดยมี peak incidence ที่อายุ 5-9 เดือน สาเหตุส่วนใหญ่ในเด็กเล็กมักเป็น idiopathic แต่อาจมี lead point เช่น Peyer's patch hypertrophy จากการติดเชื้อไวรัส (เช่น adenovirus, rotavirus) ซึ่งสอดคล้องกับประวัติท้องเสียเป็นน้ำ 2 วันก่อนหน้า\n\nพยาธิสรีรวิทยาของ intussusception เกิดจากการที่ลำไส้ส่วนที่สอดเข้าไป (intussusceptum) ถูกบีบรัดโดยลำไส้ส่วนที่รับ (intussuscipiens) ทำให้เกิดการอุดตันของหลอดเลือด venous และ lymphatic drainage ก่อน จากนั้นเกิด mucosal edema, ischemia และ mucosal sloughing ส่งผลให้มีเลือดและมูกออกมาทาง rectum (currant jelly stool) หากไม่ได้รับการรักษาจะนำไปสู่ arterial compromise, bowel necrosis และ perforation ได้\n\nก้อนที่คลำได้บริเวณ right upper quadrant มีลักษณะเป็น sausage-shaped mass ซึ่งเป็นลักษณะเฉพาะของ intussusception โดยก้อนนี้คือส่วนของลำไส้ที่ม้วนเข้าไปซ้อนกัน การวินิจฉัยยืนยันสามารถทำได้โดย ultrasonography ซึ่งจะเห็น target sign หรือ doughnut sign ในภาพตัดขวาง และ pseudokidney sign ในภาพตัดยาว การรักษาเบื้องต้นในกรณีที่ไม่มี peritonitis คือการทำ hydrostatic หรือ pneumatic reduction ภายใต้ fluoroscopy หรือ ultrasound guidance",
      choices: [
        { label: "A", text: "Intussusception", is_correct: true, explanation: "ถูกต้อง Intussusception เป็นคำตอบที่ถูกต้อง เนื่องจากผู้ป่วยมี classic triad ครบถ้วน ได้แก่ ปวดท้องเป็นพักๆ (colicky pain จากการร้องกรีดเป็นช่วงๆ) ถ่ายเป็นมูกปนเลือด (currant jelly stool) และคลำได้ก้อนที่ right upper quadrant (sausage-shaped mass) ซึ่งเป็นลักษณะทางคลินิกที่มีความจำเพาะสูงต่อ intussusception ในเด็กอายุ 1 ปี" },
        { label: "B", text: "Meckel's diverticulum", is_correct: false, explanation: "Meckel's diverticulum มักมาด้วยอาการเลือดออกทางทวารหนักแบบ painless rectal bleeding โดยเลือดมักเป็นสีแดงเข้มหรือ maroon colored stool ไม่มีอาการปวดท้องเป็นพักๆ และไม่คลำได้ก้อนในท้อง ลักษณะเลือดออกเกิดจาก ectopic gastric mucosa ใน diverticulum ที่หลั่งกรดทำให้เกิดแผลที่ลำไส้ข้างเคียง อย่างไรก็ตาม Meckel's diverticulum สามารถเป็น lead point ของ intussusception ได้" },
        { label: "C", text: "Acute gastroenteritis", is_correct: false, explanation: "Acute gastroenteritis มักมีอาการท้องเสียเป็นน้ำ คลื่นไส้อาเจียน และอาจมีไข้ แต่ไม่มีอาการปวดท้องรุนแรงเป็นพักๆ (colicky pain) ไม่มี bloody mucoid stool แบบ currant jelly และไม่คลำได้ก้อนในท้อง แม้ว่าผู้ป่วยจะมีท้องเสียเป็นน้ำ 2 วันก่อนหน้า แต่อาการที่เปลี่ยนไปเป็นร้องกรีดเป็นพักๆ และถ่ายมูกปนเลือดบ่งชี้ว่าเกิดภาวะแทรกซ้อนคือ intussusception" },
        { label: "D", text: "Midgut volvulus", is_correct: false, explanation: "Midgut volvulus มักพบในทารกแรกเกิดหรือเด็กเล็กอายุน้อยกว่า 1 เดือน มักมีอาการอาเจียนเป็นน้ำดี (bilious vomiting) เป็นอาการเด่น ท้องอืด และอาจมี bloody stool ในระยะท้ายเมื่อมี bowel ischemia เกิดจาก malrotation ของลำไส้ที่ทำให้ mesentery บิดตัว ไม่มีลักษณะก้อน sausage-shaped mass ที่ right upper quadrant" },
        { label: "E", text: "Pyloric stenosis", is_correct: false, explanation: "Pyloric stenosis พบในเด็กอายุ 2-8 สัปดาห์ มีอาการอาเจียนแบบ projectile non-bilious vomiting หลังกินนม ตรวจพบ olive-shaped mass ที่ epigastrium ไม่มีอาการถ่ายเป็นมูกปนเลือด ไม่มี colicky pain และอายุของผู้ป่วย 1 ปีไม่สอดคล้องกับโรคนี้เลย" }
      ],
      key_takeaway: "Intussusception เป็นสาเหตุที่พบบ่อยที่สุดของ bowel obstruction ในเด็กอายุ 6 เดือน - 2 ปี Classic triad ประกอบด้วย colicky abdominal pain, currant jelly stool และ sausage-shaped abdominal mass ประวัติท้องเสียนำมาก่อนบ่งชี้ว่า viral infection อาจเป็นตัวกระตุ้นให้เกิด Peyer's patch hypertrophy ซึ่งเป็น lead point"
    }
  },
  {
    id: "126575c5-ce47-4707-b0c1-403403931433",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: C. Oral steroid/NSAID (ยาสเตียรอยด์/ยาแก้อักเสบชนิดรับประทาน)",
      reason: "ผู้ป่วยหญิงอายุ 30 ปีที่กำลังให้นมบุตร มาด้วยอาการเจ็บเต้านมขวา ตรวจพบบวมและกดเจ็บบริเวณ periareolar area ข้างขวา ในกรณีนี้ต้องแยกระหว่าง lactational mastitis, breast abscess และ periductal mastitis/inflammatory condition\n\nPeriareolar inflammation ในหญิงให้นมบุตรที่ไม่มีลักษณะ fluctuant mass, ไม่มีไข้สูง และไม่มี purulent discharge อาจเป็น engorgement หรือ early inflammatory mastitis ที่ยังไม่มีการติดเชื้อ การรักษาเบื้องต้นจึงควรเป็นการลดการอักเสบด้วย oral steroid ร่วมกับ NSAID เพื่อลดอาการบวมและปวด\n\nOral NSAID เช่น ibuprofen เป็นยาที่ปลอดภัยในหญิงให้นมบุตรและมีฤทธิ์ลดการอักเสบและลดปวดได้ดี ยาสเตียรอยด์ช่วยลด inflammation ที่รุนแรง โดยเฉพาะเมื่อมีอาการบวมมากบริเวณ periareolar ซึ่งอาจเกิดจาก ductal ectasia หรือ periductal mastitis ที่ไม่ใช่การติดเชื้อแบคทีเรีย\n\nสิ่งสำคัญคือต้องแยกว่าเป็นภาวะอักเสบ (inflammation) หรือการติดเชื้อ (infection) เนื่องจากการรักษาต่างกัน ในกรณีที่ตรวจพบเพียง tenderness และ swelling โดยไม่มี fluctuance, erythema ที่ชัดเจน, ไข้สูง หรือ purulent discharge ควรรักษาด้วยยาลดการอักเสบก่อน หากไม่ดีขึ้นหรือมีอาการแย่ลงจึงพิจารณาให้ antibiotics หรือ I&D ตามความเหมาะสม",
      choices: [
        { label: "A", text: "Cold compression", is_correct: false, explanation: "Cold compression ใช้ในกรณี breast engorgement เพื่อลดอาการบวมและปวดชั่วคราว แต่ไม่ใช่การรักษาหลักสำหรับ periareolar inflammation ที่มีอาการชัดเจน Cold compression เป็นเพียง supportive measure ไม่สามารถลดการอักเสบได้อย่างมีประสิทธิภาพเท่ากับ anti-inflammatory drugs" },
        { label: "B", text: "IV steroid/NSAID", is_correct: false, explanation: "การให้ IV steroid/NSAID เป็นการรักษาที่รุนแรงเกินไปสำหรับ periareolar inflammation ที่ไม่มีภาวะแทรกซ้อนรุนแรง IV route สงวนไว้สำหรับกรณีที่ผู้ป่วยมีอาการรุนแรง ไม่สามารถรับประทานยาได้ หรือมี sepsis ซึ่งไม่ตรงกับอาการของผู้ป่วยรายนี้" },
        { label: "C", text: "Oral steroid/NSAID", is_correct: true, explanation: "ถูกต้อง Oral steroid/NSAID เป็นการรักษาที่เหมาะสมสำหรับ periareolar inflammation ในหญิงให้นมบุตรที่ไม่มีสัญญาณของการติดเชื้อรุนแรง NSAID เช่น ibuprofen ปลอดภัยในหญิงให้นมบุตร ช่วยลดปวดและลดการอักเสบ ร่วมกับ steroid ช่วยลด inflammatory response ที่รุนแรง" },
        { label: "D", text: "Oral antibiotics", is_correct: false, explanation: "Oral antibiotics ใช้ในกรณี lactational mastitis ที่มีสัญญาณของการติดเชื้อชัดเจน เช่น มีไข้สูง ผิวหนังแดงร้อน มี purulent discharge หรืออาการไม่ดีขึ้นหลังจากรักษาแบบ conservative ในกรณีนี้ผู้ป่วยมีเพียง tenderness และ swelling ที่ periareolar area โดยไม่มีสัญญาณของ bacterial infection ชัดเจน" },
        { label: "E", text: "Incision and drainage", is_correct: false, explanation: "Incision and drainage สงวนไว้สำหรับ breast abscess ที่มี fluctuant mass ชัดเจน มีหนองสะสม ซึ่งต้องได้รับการระบายหนองออก ในกรณีนี้ผู้ป่วยมีเพียง swelling และ tenderness ไม่มี fluctuance หรือ abscess formation การทำ I&D จึงไม่มีข้อบ่งชี้ในขณะนี้" }
      ],
      key_takeaway: "Periareolar inflammation ในหญิงให้นมบุตรที่ไม่มีสัญญาณการติดเชื้อชัดเจน ควรรักษาด้วย oral anti-inflammatory drugs (steroid/NSAID) เป็นอันดับแรก การแยกระหว่าง inflammatory condition กับ bacterial infection มีความสำคัญเพราะการรักษาต่างกัน"
    }
  },
  {
    id: "128de9d0-b2b5-4b7a-85eb-eff268add821",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Tinel test at forearm (แต่คำตอบที่ถูกต้องทางคลินิกควรเป็น C - resist wrist extensor test สำหรับ lateral epicondylitis)",
      reason: "ผู้ป่วยชายอาชีพช่างไม้ มาด้วยอาการปวดศอกขวา ตรวจพบกดเจ็บที่ lateral epicondyle of humerus ลักษณะทางคลินิกนี้เข้าได้กับ lateral epicondylitis หรือที่เรียกว่า tennis elbow ซึ่งเป็นภาวะอักเสบของ common extensor origin ที่ lateral epicondyle\n\nLateral epicondylitis เกิดจากการใช้งาน wrist extensor muscles ซ้ำๆ มากเกินไป (repetitive overuse) ทำให้เกิด microtears ที่ extensor carpi radialis brevis (ECRB) tendon ซึ่งเป็น tendon ที่เกาะที่ lateral epicondyle อาชีพช่างไม้ต้องใช้มือจับค้อนและเครื่องมือช่างบ่อยๆ ทำให้มีความเสี่ยงสูงต่อภาวะนี้\n\nการตรวจที่ใช้ในการวินิจฉัย lateral epicondylitis ได้แก่ Cozen's test (resisted wrist extension) โดยให้ผู้ป่วยกำมือและ extend wrist ขณะที่ผู้ตรวจต้านแรง หากปวดที่ lateral epicondyle แสดงว่าเป็นบวก และ Mill's test (passive wrist flexion with elbow extension) อย่างไรก็ตาม ตามโจทย์คำตอบที่ให้มาคือ Tinel test at forearm ซึ่งเป็นการตรวจ nerve entrapment\n\nTinel test ที่ forearm ใช้ตรวจ radial tunnel syndrome ซึ่งเป็นภาวะที่ posterior interosseous nerve (PIN) ซึ่งเป็น deep branch ของ radial nerve ถูกกดทับบริเวณ radial tunnel ที่ forearm proximal อาการของ radial tunnel syndrome คล้ายกับ lateral epicondylitis มาก คือปวดบริเวณ lateral elbow และ forearm แต่ตำแหน่งกดเจ็บจะอยู่ที่ distal กว่า lateral epicondyle ประมาณ 3-4 cm การทำ Tinel test ที่ forearm จะช่วยแยกโรคทั้งสองนี้ได้",
      choices: [
        { label: "A", text: "Tinel test at forearm", is_correct: true, explanation: "ตามเฉลยของข้อสอบ Tinel test at forearm เป็นคำตอบที่ถูกต้อง ใช้ตรวจ radial tunnel syndrome ซึ่งเป็น differential diagnosis ที่สำคัญของ lateral epicondylitis การเคาะบริเวณ radial tunnel ที่ proximal forearm จะทำให้เกิดอาการชาหรือปวดร้าวไปตามแนว radial nerve distribution หากเป็นบวกบ่งชี้ว่ามี nerve entrapment" },
        { label: "B", text: "Phalen test", is_correct: false, explanation: "Phalen test ใช้ตรวจ carpal tunnel syndrome โดยให้ผู้ป่วยงอข้อมือทั้งสองข้างค้างไว้ 60 วินาที หากเกิดอาการชาบริเวณ median nerve distribution (นิ้วหัวแม่มือ นิ้วชี้ นิ้วกลาง และครึ่งนิ้วนาง) แสดงว่าเป็นบวก Phalen test ไม่เกี่ยวข้องกับอาการปวด lateral epicondyle" },
        { label: "C", text: "Resist wrist extensor test", is_correct: false, explanation: "Resist wrist extension test (Cozen's test) เป็นการตรวจที่ใช้ยืนยัน lateral epicondylitis โดยตรง โดยให้ผู้ป่วย extend wrist ขณะที่ผู้ตรวจต้านแรง หากปวดที่ lateral epicondyle แสดงว่าเป็นบวก แม้จะเป็นการตรวจที่เหมาะสมทางคลินิก แต่ตามเฉลยข้อสอบนี้ไม่ใช่คำตอบที่ถูกต้อง" },
        { label: "D", text: "Resist pronation", is_correct: false, explanation: "Resist pronation test ใช้ตรวจ pronator teres syndrome ซึ่งเป็นภาวะที่ median nerve ถูกกดทับที่ proximal forearm บริเวณ pronator teres muscle ผู้ป่วยจะมีอาการชาบริเวณ median nerve distribution ที่มือ ร่วมกับปวด forearm ไม่เกี่ยวข้องกับอาการปวด lateral epicondyle" }
      ],
      key_takeaway: "ผู้ป่วยที่มีอาการปวด lateral epicondyle ต้องแยกระหว่าง lateral epicondylitis (tennis elbow) กับ radial tunnel syndrome เสมอ Tinel test at forearm ช่วยแยก radial tunnel syndrome ออกจาก lateral epicondylitis ได้ ทั้งสองภาวะนี้มีอาการคล้ายกันแต่การรักษาต่างกัน"
    }
  },
  {
    id: "12a8445f-87ea-44d1-a200-c2c54eee6f6a",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Threatened abortion (แท้งคุกคาม)",
      reason: "ผู้ป่วยหญิงตั้งครรภ์อายุครรภ์ 8 สัปดาห์ มาด้วยเลือดออกทางช่องคลอด 1 วัน ตรวจร่างกายพบมดลูกขนาด 8 สัปดาห์ (ตรงกับอายุครรภ์) ปากมดลูกปิด ไม่มี cervical motion tenderness และไม่มี adnexal mass การวินิจฉัยคือ threatened abortion\n\nThreatened abortion หมายถึงภาวะที่มีเลือดออกทางช่องคลอดในช่วง first trimester (ก่อน 20 สัปดาห์) โดยที่ปากมดลูกยังปิดอยู่ (closed os) ทารกในครรภ์ยังมีชีวิตอยู่ และมดลูกมีขนาดตรงกับอายุครรภ์ ซึ่งเป็นลักษณะที่ตรงกับผู้ป่วยรายนี้ทุกประการ\n\nพยาธิสรีรวิทยาของ threatened abortion อาจเกิดจากหลายสาเหตุ เช่น subchorionic hemorrhage (เลือดออกระหว่าง chorion กับ decidua), implantation bleeding, cervical polyp หรือ cervical ectropion ประมาณ 50% ของ threatened abortion จะ resolve เองโดยไม่มีผลกระทบต่อการตั้งครรภ์ แต่อีก 50% อาจพัฒนาไปเป็น inevitable หรือ incomplete abortion\n\nการตรวจเพิ่มเติมที่สำคัญคือ ultrasonography เพื่อยืนยันว่ามี viable intrauterine pregnancy โดยดู fetal cardiac activity และ serum beta-hCG level เพื่อติดตาม การรักษาเป็นแบบ supportive คือพักผ่อน หลีกเลี่ยงการออกแรงหนัก งดมีเพศสัมพันธ์ และนัดติดตามอาการ\n\nสิ่งสำคัญคือต้องแยก ectopic pregnancy ออกก่อน ซึ่งในกรณีนี้ มดลูกมีขนาดตรงกับอายุครรภ์ ไม่มี cervical motion tenderness และไม่มี adnexal mass ทำให้ ectopic pregnancy มีความเป็นไปได้ต่ำ",
      choices: [
        { label: "A", text: "Threatened abortion", is_correct: true, explanation: "ถูกต้อง Threatened abortion วินิจฉัยจากการมีเลือดออกทางช่องคลอดในไตรมาสแรก ปากมดลูกปิด มดลูกมีขนาดตรงกับอายุครรภ์ ไม่มีอาการปวดท้องรุนแรง ซึ่งตรงกับอาการของผู้ป่วยรายนี้ทุกประการ การรักษาเป็นแบบ conservative" },
        { label: "B", text: "Complete abortion", is_correct: false, explanation: "Complete abortion หมายถึงการแท้งที่ products of conception ถูกขับออกมาหมดแล้ว มดลูกจะมีขนาดเล็กลง (smaller than expected gestational age) ปากมดลูกจะปิด เลือดออกจะลดลง ในกรณีนี้มดลูกยังมีขนาด 8 สัปดาห์ตรงกับอายุครรภ์ แสดงว่ายังไม่ได้เกิดการแท้ง" },
        { label: "C", text: "Incomplete abortion", is_correct: false, explanation: "Incomplete abortion หมายถึงการแท้งที่ products of conception ถูกขับออกมาบางส่วน ปากมดลูกจะเปิด (open os) มีเลือดออกมากและอาจมี tissue ออกมาด้วย ในกรณีนี้ปากมดลูกปิด (os closed) จึงไม่ใช่ incomplete abortion" },
        { label: "D", text: "Inevitable abortion", is_correct: false, explanation: "Inevitable abortion หมายถึงภาวะที่การแท้งจะเกิดขึ้นอย่างหลีกเลี่ยงไม่ได้ ลักษณะสำคัญคือปากมดลูกเปิด (dilated os) มีเลือดออกมาก และอาจมีถุงน้ำคร่ำโป่งออกมาที่ปากมดลูก ในกรณีนี้ปากมดลูกปิดอยู่จึงไม่ใช่ inevitable abortion" },
        { label: "E", text: "Missed abortion", is_correct: false, explanation: "Missed abortion หมายถึงภาวะที่ทารกในครรภ์เสียชีวิตแล้วแต่ยังไม่ถูกขับออก มักไม่มีเลือดออก หรือมีเลือดออกน้อย มดลูกอาจมีขนาดเล็กกว่าอายุครรภ์ ปากมดลูกปิด การวินิจฉัยยืนยันต้องอาศัย ultrasound ที่ไม่พบ fetal cardiac activity ในกรณีนี้ยังไม่มีข้อมูลบ่งชี้ว่าทารกเสียชีวิต" }
      ],
      key_takeaway: "Threatened abortion วินิจฉัยจาก vaginal bleeding ในไตรมาสแรก + closed cervical os + uterine size ตรงกับอายุครรภ์ ต้องแยก ectopic pregnancy ออกเสมอ และควรยืนยัน viable pregnancy ด้วย ultrasound"
    }
  },
  {
    id: "12c842c0-ea06-4127-8c95-d6d80b8cde06",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: D. Intercostal drainage (ICD) (ใส่ท่อระบายทรวงอก)",
      reason: "ผู้ป่วยเด็กชายอายุ 7 ปี วินิจฉัย pneumonia ได้รับ cefotaxime มา 4 วันแต่ไม่ดีขึ้น CXR พบ pleural effusion ด้านขวา ผล thoracentesis แสดง: สีฟางเปรอะ specific gravity 1.030 (exudate), protein 3.0 g/dL (สูง), glucose 49 mg/dL (ต่ำ), WBC 1,500 (PMN predominant 85%) ไม่พบเชื้อใน Gram stain ลักษณะเหล่านี้เข้าได้กับ complicated parapneumonic effusion ในระยะ fibrinopurulent phase\n\nParapneumonic effusion แบ่งเป็น 3 ระยะ: 1) Exudative phase - น้ำในช่องเยื่อหุ้มปอดใส sterile เป็น simple parapneumonic effusion รักษาด้วย antibiotics เพียงอย่างเดียว 2) Fibrinopurulent phase - มี bacterial invasion, fibrin deposition, loculation เริ่มเกิดขึ้น glucose ต่ำ, pH ต่ำ, LDH สูง 3) Organization phase - มี fibroblast ingrowth, thick pleural peel formation ทำให้ปอดถูกห่อหุ้ม (trapped lung)\n\nผลน้ำเยื่อหุ้มปอดของผู้ป่วยบ่งชี้ชัดเจนว่าเป็น complicated parapneumonic effusion/empyema ในระยะ fibrinopurulent เนื่องจาก: glucose ต่ำ (49 mg/dL, ปกติ >60), PMN predominant (85%), specific gravity สูง (1.030) แสดงว่าเป็น exudate ที่มีการอักเสบรุนแรง\n\nการรักษา complicated parapneumonic effusion ในระยะ fibrinopurulent ต้องทำ tube thoracostomy (intercostal drainage, ICD) เพื่อระบายน้ำและหนองออก ร่วมกับให้ antibiotics ที่เหมาะสม การให้เพียง antibiotics อย่างเดียวไม่เพียงพอเนื่องจาก fibrin และ loculation ทำให้ยาเข้าถึงบริเวณที่ติดเชื้อได้ไม่ดี",
      choices: [
        { label: "A", text: "เพิ่มยา cloxacillin เข้าไปกับ cefotaxime", is_correct: false, explanation: "การเพิ่ม cloxacillin เพื่อ cover Staphylococcus aureus อาจเป็นส่วนหนึ่งของการรักษา แต่ไม่ใช่การรักษาหลักที่สำคัญที่สุด ปัญหาหลักคือมี complicated parapneumonic effusion ที่ต้องระบาย การเปลี่ยนหรือเพิ่ม antibiotics เพียงอย่างเดียวไม่สามารถแก้ปัญหา loculated effusion ได้" },
        { label: "B", text: "เปลี่ยนเป็น imipenem", is_correct: false, explanation: "Imipenem เป็น broad-spectrum carbapenem ที่ cover ทั้ง gram positive, gram negative และ anaerobes แต่การเปลี่ยน antibiotic เพียงอย่างเดียวไม่เพียงพอสำหรับ complicated parapneumonic effusion ในระยะ fibrinopurulent ที่ต้องการ drainage เป็นหลัก ยา antibiotic ไม่สามารถ penetrate เข้าไปใน loculated collection ได้ดี" },
        { label: "C", text: "ทำการเจาะน้ำทรวงอกซ้ำ", is_correct: false, explanation: "Repeat thoracentesis อาจใช้ในกรณี simple parapneumonic effusion ที่ต้องการ diagnostic tap ซ้ำ แต่สำหรับ complicated effusion ในระยะ fibrinopurulent ที่มี fibrin deposition และ loculation การเจาะซ้ำไม่สามารถระบายน้ำได้อย่างมีประสิทธิภาพ ต้องใช้ continuous drainage ผ่าน chest tube" },
        { label: "D", text: "ใส่ท่อระบายน้ำ (Intercostal tube drainage)", is_correct: true, explanation: "ถูกต้อง ICD เป็นการรักษาหลักสำหรับ complicated parapneumonic effusion ในระยะ fibrinopurulent ช่วยระบาย infected fluid, fibrin และ debris ออกอย่างต่อเนื่อง ร่วมกับ IV antibiotics ที่เหมาะสม ช่วยให้ปอดขยายตัวได้ดีขึ้นและลดการเกิด organization phase" },
        { label: "E", text: "ผ่าตัดเอาเยื่อหุ้มปอด (Surgical decortication)", is_correct: false, explanation: "Surgical decortication สงวนไว้สำหรับ organization phase (ระยะที่ 3) ที่มี thick fibrous peel ห่อหุ้มปอดจนขยายตัวไม่ได้ (trapped lung) หรือในกรณีที่ ICD ล้มเหลว ผู้ป่วยยังอยู่ในระยะ fibrinopurulent จึงควรลอง ICD ก่อน การผ่าตัดมี morbidity สูงกว่าและควรเป็นทางเลือกสุดท้าย" }
      ],
      key_takeaway: "Complicated parapneumonic effusion ในระยะ fibrinopurulent (glucose ต่ำ, PMN predominant, LDH สูง) ต้องรักษาด้วย intercostal tube drainage ร่วมกับ IV antibiotics การให้ antibiotics เพียงอย่างเดียวไม่เพียงพอ"
    }
  },
  {
    id: "13145816-fefe-4fe9-8650-fb928aca9da2",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Acyclovir (ยาต้านไวรัส Acyclovir - แต่ทางคลินิก NSAID เป็นคำตอบที่เหมาะสมกว่าสำหรับ acute pericarditis)",
      reason: "ผู้ป่วยชายไทยอายุ 20 ปี มาด้วยอาการไข้ต่ำ ปวดเมื่อยกล้ามเนื้อ เจ็บหน้าอก 1 วัน โดยอาการเจ็บหน้าอกดีขึ้นเมื่อนั่งโน้มตัวไปข้างหน้า (lean forward) ตรวจร่างกาย: heart sounds S1S2 ปกติ ไม่มี murmur ไม่มี cardiomegaly ได้ยิน friction rub ที่ apex ลักษณะทางคลินิกนี้เข้าได้กับ acute pericarditis\n\nAcute pericarditis เป็นการอักเสบของเยื่อหุ้มหัวใจ (pericardium) สาเหตุที่พบบ่อยที่สุดในคนหนุ่มสาวคือ viral pericarditis โดยเชื้อไวรัสที่พบบ่อยได้แก่ Coxsackievirus B, Echovirus, Adenovirus, Influenza และอื่นๆ ลักษณะทางคลินิกที่สำคัญของ pericarditis ได้แก่: 1) Chest pain ที่ดีขึ้นเมื่อ lean forward และแย่ลงเมื่อ supine 2) Pericardial friction rub 3) EKG changes (diffuse ST elevation, PR depression) 4) Pericardial effusion\n\nอาการนำของผู้ป่วย (ไข้ต่ำ ปวดเมื่อยกล้ามเนื้อ) บ่งชี้ว่ามี viral prodrome ก่อนเกิด pericarditis ซึ่งสนับสนุนว่าเป็น viral pericarditis การที่เจ็บหน้าอกดีขึ้นเมื่อ lean forward เป็นลักษณะเฉพาะเจาะจงของ pericardial pain เนื่องจากเมื่อนั่งโน้มตัวไปข้างหน้า pericardium จะแยกออกจาก diaphragm ทำให้ลดการเสียดสีและลดอาการปวด\n\nPericardial friction rub เป็นเสียงที่เกิดจากการเสียดสีระหว่าง inflamed visceral และ parietal pericardium มักได้ยินชัดที่สุดที่ left sternal border หรือ apex ในท่านั่งโน้มตัวไปข้างหน้า เป็น pathognomonic sign ของ pericarditis\n\nตามเฉลยข้อสอบ คำตอบคือ Acyclovir ซึ่งอาจเป็นกรณีที่ผู้ออกข้อสอบต้องการรักษา viral etiology โดยตรง แต่ในทางคลินิก การรักษา acute viral pericarditis มาตรฐานคือ NSAID (เช่น ibuprofen, aspirin) ร่วมกับ colchicine",
      choices: [
        { label: "A", text: "Acyclovir", is_correct: true, explanation: "ตามเฉลยข้อสอบ Acyclovir เป็นคำตอบที่ถูกต้อง Acyclovir เป็นยาต้านไวรัสกลุ่ม nucleoside analog ที่ยับยั้ง viral DNA polymerase มีฤทธิ์ต่อ Herpes simplex virus และ Varicella-zoster virus ในบริบทของ viral pericarditis อาจพิจารณาให้ในกรณีที่สงสัยว่าเกิดจาก herpesvirus" },
        { label: "B", text: "NSAID", is_correct: false, explanation: "NSAID (เช่น ibuprofen 600 mg ทุก 8 ชั่วโมง หรือ aspirin 650-1000 mg ทุก 6-8 ชั่วโมง) เป็นยาหลักในการรักษา acute pericarditis ตาม ESC guidelines ช่วยลดการอักเสบและบรรเทาอาการเจ็บหน้าอก มักให้ร่วมกับ colchicine เพื่อลดอัตราการกลับเป็นซ้ำ แม้จะเป็นการรักษามาตรฐานตาม guideline แต่ไม่ใช่คำตอบตามเฉลยข้อสอบนี้" },
        { label: "C", text: "Prednisolone", is_correct: false, explanation: "Corticosteroids ไม่ใช่ first-line treatment สำหรับ acute pericarditis เนื่องจากเพิ่มอัตราการกลับเป็นซ้ำ (recurrence rate) สูงขึ้น สงวนไว้สำหรับกรณีที่มี contraindication ต่อ NSAID และ colchicine หรือไม่ตอบสนองต่อการรักษา first-line หรือในกรณี autoimmune pericarditis" },
        { label: "D", text: "Ceftriaxone", is_correct: false, explanation: "Ceftriaxone เป็นยาปฏิชีวนะกลุ่ม third-generation cephalosporin ใช้รักษาการติดเชื้อแบคทีเรีย Acute pericarditis ในคนหนุ่มสาวส่วนใหญ่เกิดจากไวรัส ไม่ใช่แบคทีเรีย Bacterial (purulent) pericarditis พบน้อยมากและมักเกิดในผู้ป่วยที่มี immunocompromised หรือหลังการผ่าตัดหัวใจ" }
      ],
      key_takeaway: "Acute pericarditis ในคนหนุ่มสาวมักเกิดจากไวรัส ลักษณะเฉพาะคือ chest pain ที่ดีขึ้นเมื่อ lean forward และ pericardial friction rub การรักษามาตรฐานคือ NSAID + colchicine แต่ข้อสอบนี้เลือก acyclovir เป็นคำตอบ"
    }
  },
  {
    id: "1369ed5e-5e7d-4f03-8ce7-8add602be98a",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Diazepam (ยากันชัก Diazepam สำหรับ status epilepticus)",
      reason: "ผู้ป่วยชายอายุ 24 ปี มีอาการชักมา 1 ชั่วโมง มีประวัติเป็นโรคลมชักตั้งแต่อายุ 15 ปี ชัก 3-4 ครั้งต่อปี ไม่ได้รับการรักษามา 1 ปี อาการชักนาน 1 ชั่วโมงจัดเป็น status epilepticus ซึ่งเป็นภาวะฉุกเฉินทางการแพทย์\n\nStatus epilepticus คือภาวะที่มีอาการชักต่อเนื่องนานกว่า 5 นาที หรือมีอาการชักซ้ำโดยไม่ฟื้นคืนสติระหว่าง seizure episodes ตาม definition ใหม่ (ILAE 2015) หรือนานกว่า 30 นาทีตาม traditional definition ผู้ป่วยรายนี้ชักมา 1 ชั่วโมงจึงเข้าเกณฑ์ status epilepticus อย่างชัดเจน\n\nสาเหตุที่พบบ่อยที่สุดของ status epilepticus ในผู้ป่วยโรคลมชักคือ การหยุดยากันชักกะทันหัน (medication noncompliance) ซึ่งตรงกับประวัติผู้ป่วยที่ไม่ได้รับการรักษามา 1 ปี การหยุดยากันชักทำให้ seizure threshold ลดลงอย่างรวดเร็ว นำไปสู่ uncontrolled seizures\n\nPathophysiology ของ status epilepticus เกี่ยวข้องกับ sustained neuronal excitation จาก excessive glutamate release ร่วมกับ failure ของ inhibitory GABA-ergic mechanisms เมื่อชักนานจะเกิด internalization ของ GABA-A receptors ที่ cell surface ทำให้ benzodiazepines มีประสิทธิภาพลดลงตามเวลา จึงต้องให้ยาเร็วที่สุด\n\nFirst-line treatment สำหรับ status epilepticus คือ benzodiazepines โดย IV diazepam (0.15-0.2 mg/kg, max 10 mg) หรือ IV lorazepam (0.1 mg/kg, max 4 mg) เป็นยาที่แนะนำ Diazepam ออกฤทธิ์โดยเพิ่ม frequency ของการเปิด GABA-A receptor chloride channel ทำให้เกิด neuronal inhibition หยุดการชัก",
      choices: [
        { label: "A", text: "Diazepam", is_correct: true, explanation: "ถูกต้อง Diazepam เป็น first-line treatment สำหรับ status epilepticus ออกฤทธิ์เร็วภายใน 1-3 นาทีเมื่อให้ทาง IV โดยเสริมฤทธิ์ GABA-A receptor ทำให้เกิด neuronal inhibition หยุดชักได้รวดเร็ว ให้ขนาด 0.15-0.2 mg/kg IV ไม่เกิน 10 mg ต่อครั้ง" },
        { label: "B", text: "Phenytoin", is_correct: false, explanation: "Phenytoin เป็น second-line treatment (หลังจาก benzodiazepine) สำหรับ status epilepticus ใช้เป็น maintenance therapy หลังจากหยุดชักด้วย benzodiazepine แล้ว ให้ loading dose 15-20 mg/kg IV ที่ rate ไม่เกิน 50 mg/min เนื่องจาก onset ช้ากว่า benzodiazepine จึงไม่ใช่ first-line" },
        { label: "C", text: "Phenobarbital", is_correct: false, explanation: "Phenobarbital เป็น second หรือ third-line treatment สำหรับ status epilepticus ใช้เมื่อ benzodiazepine และ phenytoin ไม่ได้ผล มี onset ช้ากว่า benzodiazepine และมีผลข้างเคียงกด respiratory depression มากกว่า จึงไม่ใช่ยาแรกที่ควรเลือกใช้" },
        { label: "D", text: "Midazolam", is_correct: false, explanation: "Midazolam เป็น benzodiazepine ที่สามารถใช้เป็น first-line treatment ได้เช่นกัน โดยเฉพาะทาง IM route เมื่อไม่สามารถเปิดเส้นเลือดได้ แต่ตามเฉลยข้อสอบนี้ diazepam เป็นคำตอบที่ถูกต้อง ทั้ง diazepam และ midazolam ต่างเป็น benzodiazepine ที่ใช้ได้ใน status epilepticus" },
        { label: "E", text: "Gabapentin", is_correct: false, explanation: "Gabapentin เป็นยากันชักที่ใช้สำหรับ maintenance therapy ในโรคลมชักชนิด partial seizures ไม่มีบทบาทในการรักษา acute status epilepticus เลย เนื่องจาก onset ช้ามาก (ต้องรับประทานเป็นเวลาหลายวันจึงจะ reach therapeutic level) และไม่มี IV formulation" }
      ],
      key_takeaway: "Status epilepticus (ชัก > 5 นาที) เป็นภาวะฉุกเฉิน First-line treatment คือ IV benzodiazepine (diazepam หรือ lorazepam) สาเหตุที่พบบ่อยในผู้ป่วยโรคลมชักคือการหยุดยากันชักกะทันหัน"
    }
  },
  {
    id: "13aa260b-07d5-458b-bb9b-99bc0e6b8dc8",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: A. Prolactinoma (เนื้องอกต่อมใต้สมองชนิดหลั่ง prolactin)",
      reason: "ผู้ป่วยหญิงอายุ 30 ปี นักกีฬามาราธอน แต่งงานแล้ว ยังไม่เคยตั้งครรภ์ มาด้วยอาการปวดหัว ตามัว ไม่มีประจำเดือนมา 1 ปี (amenorrhea) มีน้ำนมไหลจากเต้านมทั้งสองข้าง (bilateral galactorrhea) ตามัวเพิ่มขึ้นเรื่อยๆ และตรวจพบ bilateral hemianopia ลักษณะทางคลินิกเหล่านี้บ่งชี้ชัดเจนว่าเป็น prolactinoma ขนาดใหญ่ (macroprolactinoma)\n\nProlactinoma เป็น pituitary adenoma ที่พบบ่อยที่สุด (ประมาณ 40% ของ pituitary adenomas) ทำหน้าที่หลั่ง prolactin มากผิดปกติ (hyperprolactinemia) Prolactin ที่สูงจะ suppress GnRH secretion จาก hypothalamus ทำให้ LH และ FSH ลดลง ส่งผลให้เกิด anovulation, amenorrhea และ galactorrhea\n\nBitemporal hemianopia เป็นอาการที่เกิดจากก้อนเนื้องอกที่โตขึ้นกด optic chiasm ซึ่งอยู่เหนือ pituitary gland โดย nerve fibers ที่ cross กันที่ chiasm (nasal retinal fibers) จะถูกกดทำให้สูญเสียการมองเห็นด้านข้างทั้งสองข้าง (bilateral temporal visual field loss) การที่ตามัวเพิ่มขึ้นเรื่อยๆ บ่งชี้ว่าก้อนเนื้องอกกำลังโตขึ้นอย่างต่อเนื่อง\n\nMacroprolactinoma (>10 mm) มักมีอาการจาก mass effect ร่วมกับอาการจาก hyperprolactinemia ได้แก่ ปวดหัวจากการยืดขยายของ dura mater, visual field defect จากการกด optic chiasm และ hypopituitarism จากการกดเนื้อ pituitary ปกติ\n\nการวินิจฉัยยืนยันทำโดย MRI brain with gadolinium contrast เพื่อดูขนาดและลักษณะของก้อน ร่วมกับ serum prolactin level ซึ่งจะสูงมาก (มักมากกว่า 200 ng/mL ใน macroprolactinoma) การรักษาหลักคือ dopamine agonist (cabergoline หรือ bromocriptine) ซึ่งสามารถลดขนาดเนื้องอกและลด prolactin level ได้อย่างมีประสิทธิภาพ",
      choices: [
        { label: "A", text: "Prolactinoma", is_correct: true, explanation: "ถูกต้อง Prolactinoma เป็นการวินิจฉัยที่เหมาะสมที่สุด เนื่องจากผู้ป่วยมีอาการ classic triad ของ prolactinoma ขนาดใหญ่ ได้แก่ amenorrhea + galactorrhea (จาก hyperprolactinemia) และ bitemporal hemianopia (จาก optic chiasm compression) การรักษาหลักคือ dopamine agonist" },
        { label: "B", text: "Pituitary adenoma (non-functional)", is_correct: false, explanation: "Non-functional pituitary adenoma ไม่หลั่ง hormone ใดๆ ที่มากผิดปกติ จึงไม่ทำให้เกิด galactorrhea โดยตรง แม้ว่า non-functional adenoma ขนาดใหญ่อาจทำให้ prolactin สูงขึ้นเล็กน้อยจาก stalk effect (การกด pituitary stalk ทำให้ dopamine inhibition ลดลง) แต่ระดับ prolactin มักไม่เกิน 100-150 ng/mL ซึ่งไม่เพียงพอที่จะทำให้เกิด galactorrhea ที่ชัดเจน" },
        { label: "C", text: "Craniopharyngioma", is_correct: false, explanation: "Craniopharyngioma เป็นเนื้องอกที่เกิดจาก remnants ของ Rathke's pouch พบมาก 2 ช่วงอายุคือ 5-14 ปี และ 50-74 ปี มักมีอาการจาก mass effect เช่น visual field defect และ hypopituitarism แต่ไม่ทำให้เกิด galactorrhea ที่ชัดเจน อาจมี calcification เห็นได้จาก imaging ลักษณะเป็น cystic และ solid component" },
        { label: "D", text: "Hypogonadism (primary)", is_correct: false, explanation: "Primary hypogonadism (ovarian failure) ทำให้ estrogen ต่ำ FSH/LH สูง มีอาการ amenorrhea ได้ แต่ไม่ทำให้เกิด galactorrhea และ bitemporal hemianopia Primary hypogonadism เกิดจากปัญหาที่ gonad โดยตรง ไม่เกี่ยวกับก้อนใน pituitary" },
        { label: "E", text: "Pregnancy", is_correct: false, explanation: "การตั้งครรภ์ทำให้ prolactin สูงขึ้นและอาจมี galactorrhea ได้ แต่ไม่ทำให้เกิด bitemporal hemianopia และปวดหัวจาก mass lesion ที่กด optic chiasm แม้ว่า pituitary gland จะโตขึ้นระหว่างตั้งครรภ์ แต่ไม่โตพอที่จะกด optic chiasm ในคนปกติ นอกจากนี้ผู้ป่วยไม่มีประจำเดือนมา 1 ปี ซึ่งไม่สอดคล้องกับการตั้งครรภ์ปกติ" }
      ],
      key_takeaway: "Prolactinoma ขนาดใหญ่ (macroprolactinoma) มีอาการ amenorrhea + galactorrhea จาก hyperprolactinemia ร่วมกับ bitemporal hemianopia จากการกด optic chiasm การรักษาหลักคือ dopamine agonist ไม่ใช่การผ่าตัด"
    }
  },
  {
    id: "1419cf15-95e2-4796-aede-0c20d5f80c80",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: C. Poststreptococcal glomerulonephritis (ไตอักเสบหลังติดเชื้อสเตรปโตค็อกคัส)",
      reason: "ผู้ป่วยหญิงอายุ 18 ปี มาด้วยอาการบวมและไข้ 2 วัน มีประวัติเป็นอาการคล้ายกันเมื่อ 2 ปีก่อน ตรวจพบ pustule ที่ขา ลักษณะอาการเหล่านี้บ่งชี้ poststreptococcal glomerulonephritis (PSGN) ที่เกิดจาก skin infection (impetigo/pyoderma)\n\nPSGN เป็น immune complex-mediated glomerulonephritis ที่เกิดขึ้นหลังการติดเชื้อ Group A beta-hemolytic Streptococcus (GAS) ประมาณ 1-3 สัปดาห์หลัง pharyngitis หรือ 3-6 สัปดาห์หลัง skin infection (impetigo) Nephritogenic strains ของ GAS ที่ทำให้เกิด PSGN ได้แก่ M type 12 (pharyngitis-associated) และ M type 49 (skin infection-associated)\n\nพยาธิสรีรวิทยาของ PSGN เกี่ยวข้องกับการสร้าง immune complexes จาก streptococcal antigens และ anti-streptococcal antibodies ที่ deposit ใน glomeruli ทำให้เกิด complement activation (โดยเฉพาะ C3) ผ่าน alternative pathway ส่งผลให้เกิด inflammatory response ใน glomeruli ทำให้ GBM (glomerular basement membrane) ถูกทำลาย เกิด hematuria, proteinuria, edema และ hypertension\n\nPustule ที่ขาบ่งชี้ว่าผู้ป่วยมี active skin infection จาก Streptococcus ซึ่งเป็น trigger ของ PSGN อาการบวม (edema) เกิดจาก sodium และ water retention จาก decreased GFR และ proteinuria ไข้อาจเกิดจาก active infection หรือ inflammatory response\n\nประวัติที่เคยมีอาการคล้ายกัน 2 ปีก่อนอาจสอดคล้องกับ recurrent streptococcal skin infection แต่ PSGN เอง rarely recurs เนื่องจาก type-specific immunity การที่เกิดซ้ำอาจเป็นจาก different nephrogenic strain",
      choices: [
        { label: "A", text: "Lupus nephritis", is_correct: false, explanation: "Lupus nephritis พบในผู้ป่วย SLE ซึ่งมักมี multi-system involvement เช่น malar rash, arthralgia, oral ulcers, photosensitivity แม้จะพบบ่อยในหญิงวัยเจริญพันธุ์ แต่ผู้ป่วยรายนี้ไม่มีอาการอื่นของ SLE และมี pustule ที่ขาซึ่งบ่งชี้ skin infection มากกว่า lupus skin manifestation" },
        { label: "B", text: "IgA nephropathy", is_correct: false, explanation: "IgA nephropathy มักมาด้วย gross hematuria ที่เกิดพร้อมกับ upper respiratory tract infection (synpharyngitic hematuria) ไม่ใช่หลังจาก skin infection และมักไม่มีอาการ nephritic syndrome ที่รุนแรง (edema, hypertension) ในช่วงแรก IgA nephropathy มัก present ด้วย recurrent gross hematuria โดยไม่มี latent period" },
        { label: "C", text: "Poststreptococcal glomerulonephritis", is_correct: true, explanation: "ถูกต้อง PSGN เป็นการวินิจฉัยที่เหมาะสมที่สุด ผู้ป่วยมี nephritic syndrome (edema, ไข้) ร่วมกับ skin infection (pustule ที่ขา) ซึ่งเป็น streptococcal pyoderma ที่เป็น trigger ของ PSGN ประวัติอาการคล้ายกัน 2 ปีก่อนสนับสนุนว่าเคยมี episode ก่อนหน้า" },
        { label: "D", text: "IgA vasculitis with renal involvement", is_correct: false, explanation: "IgA vasculitis (Henoch-Schonlein purpura) มักมี palpable purpura ที่ขา, arthralgia, abdominal pain และ renal involvement ไม่ใช่ pustule ที่ขา พบบ่อยในเด็กอายุ 3-10 ปี มากกว่าผู้ใหญ่อายุ 18 ปี Rash ใน HSP เป็น non-thrombocytopenic purpura ไม่ใช่ pustule" },
        { label: "E", text: "Membranoproliferative glomerulonephritis", is_correct: false, explanation: "MPGN มักมาด้วย nephrotic หรือ nephritic-nephrotic syndrome มี low C3 level เรื้อรัง มักเกี่ยวข้องกับ chronic infections เช่น hepatitis B หรือ C ไม่ใช่ acute skin infection MPGN มักเป็นโรคเรื้อรังที่ค่อยๆ ลุกลาม ไม่ใช่ acute onset เหมือน PSGN" }
      ],
      key_takeaway: "PSGN เกิดหลังการติดเชื้อ Group A Streptococcus ได้ทั้ง pharyngitis (latent period 1-3 สัปดาห์) และ skin infection/impetigo (latent period 3-6 สัปดาห์) การพบ pustule ร่วมกับ nephritic syndrome บ่งชี้ PSGN จาก streptococcal pyoderma"
    }
  },
  {
    id: "1432a85a-e664-4f74-b72e-4b353b7c351b",
    detailed_explanation: {
      summary: "คำตอบที่ถูกต้อง: D. Methylphenidate (ยากระตุ้นสมาธิ เมทิลเฟนิเดต)",
      reason: "ผู้ป่วยเด็กชายที่มีพฤติกรรม ซุกซน ไม่ยอมฟังพ่อแม่ ชอบเถียง และรบกวนเพื่อนอยู่ตลอดเวลา ลักษณะพฤติกรรมเหล่านี้ต้องพิจารณาแยกระหว่าง Attention Deficit Hyperactivity Disorder (ADHD) และ Oppositional Defiant Disorder (ODD)\n\nADHD เป็นโรคที่มี 3 อาการหลัก: 1) Inattention - ขาดสมาธิ ไม่ตั้งใจฟัง 2) Hyperactivity - ซุกซน อยู่ไม่นิ่ง 3) Impulsivity - หุนหันพลันแล่น อาการเหล่านี้ต้องเกิดก่อนอายุ 12 ปี และมีผลกระทบต่อการเรียนและสังคม ADHD มี neurobiological basis จาก dysfunction ของ prefrontal cortex ที่เกี่ยวข้องกับ dopamine และ norepinephrine neurotransmission\n\nODD มีลักษณะเป็น pattern ของอารมณ์โกรธง่าย เถียง ไม่ยอมทำตามกฎ และจงใจรบกวนผู้อื่น ADHD และ ODD มักพบร่วมกันได้บ่อย (comorbidity ประมาณ 40-60%)\n\nจากลักษณะอาการของผู้ป่วยที่มีทั้ง hyperactivity (ซุกซน), inattention (ไม่ยอมฟัง), และ oppositional behavior (เถียง, รบกวนเพื่อน) คำตอบตามเฉลยข้อสอบคือ Methylphenidate ซึ่งเป็น first-line pharmacotherapy สำหรับ ADHD\n\nMethylphenidate เป็น psychostimulant ที่ออกฤทธิ์โดยยับยั้ง reuptake ของ dopamine และ norepinephrine ที่ prefrontal cortex ทำให้ระดับ neurotransmitter เหล่านี้เพิ่มขึ้น ช่วยปรับปรุง attention, executive function และลด hyperactivity/impulsivity มีประสิทธิภาพดีในผู้ป่วย ADHD ประมาณ 70-80%",
      choices: [
        { label: "A", text: "Haloperidol", is_correct: false, explanation: "Haloperidol เป็น typical antipsychotic ที่ block D2 dopamine receptor ใช้รักษา psychotic disorders เช่น schizophrenia ไม่ใช่ first-line treatment สำหรับ ADHD มีผลข้างเคียงรุนแรง เช่น extrapyramidal symptoms, tardive dyskinesia จึงไม่เหมาะสำหรับใช้ในเด็กที่มีปัญหาพฤติกรรม" },
        { label: "B", text: "Imipramine", is_correct: false, explanation: "Imipramine เป็น tricyclic antidepressant (TCA) เคยใช้เป็น second-line treatment สำหรับ ADHD ในกรณีที่ stimulants ใช้ไม่ได้ แต่มี side effects มากกว่า methylphenidate เช่น anticholinergic effects, cardiac arrhythmia จึงไม่ใช่ first-line และปัจจุบันแทบไม่ได้ใช้ในเด็ก" },
        { label: "C", text: "Amitriptyline", is_correct: false, explanation: "Amitriptyline เป็น TCA อีกตัวหนึ่ง ใช้สำหรับ depression, neuropathic pain และ migraine prophylaxis ไม่มีข้อบ่งชี้ในการรักษา ADHD มี anticholinergic side effects สูง เช่น ปากแห้ง ท้องผูก ง่วงนอน retention ปัสสาวะ ไม่เหมาะสำหรับใช้ในเด็กที่มีปัญหาพฤติกรรม" },
        { label: "D", text: "Methylphenidate", is_correct: true, explanation: "ถูกต้อง Methylphenidate เป็น first-line pharmacotherapy สำหรับ ADHD ออกฤทธิ์โดยยับยั้ง dopamine และ norepinephrine reuptake ที่ prefrontal cortex ช่วยปรับปรุงสมาธิ ลดซุกซน และลดพฤติกรรมหุนหันพลันแล่น มีประสิทธิภาพดีและปลอดภัยในเด็ก" },
        { label: "E", text: "Behavioral therapy and parent training", is_correct: false, explanation: "Behavioral therapy และ parent training เป็นส่วนสำคัญของการรักษา ADHD แบบ multimodal โดยเฉพาะในเด็กอายุน้อยกว่า 6 ปี แม้จะเป็นส่วนที่ควรทำร่วมด้วยเสมอ แต่ตามเฉลยข้อสอบนี้ methylphenidate เป็นคำตอบที่ถูกต้อง เนื่องจากเน้นที่ pharmacological management" }
      ],
      key_takeaway: "ADHD มี 3 อาการหลัก: inattention, hyperactivity, impulsivity First-line pharmacotherapy คือ psychostimulants โดยเฉพาะ methylphenidate ซึ่งยับยั้ง dopamine/norepinephrine reuptake ที่ prefrontal cortex ADHD มักพบร่วมกับ ODD ได้บ่อย"
    }
  }
];

async function main() {
  console.log(`Updating ${updates.length} questions (batch 5: index 80-89)...`);
  let success = 0;
  let failed = 0;

  for (const item of updates) {
    const { error } = await supabase
      .from('mcq_questions')
      .update({ detailed_explanation: item.detailed_explanation })
      .eq('id', item.id);

    if (error) {
      console.error(`Failed ${item.id}:`, error.message);
      failed++;
    } else {
      console.log(`Updated ${item.id}`);
      success++;
    }
  }

  console.log(`\nDone: ${success} succeeded, ${failed} failed`);
}

main().catch(console.error);
