export interface BlogPost {
  slug: string;
  title: string;
  description: string;
  publishedAt: string;
  category: string;
  readingTime: number; // minutes
  content: string; // HTML string
}

export const blogPosts: BlogPost[] = [
  {
    slug: "meq-what-is-it",
    title: "ข้อสอบ MEQ คืออะไร? ทำความเข้าใจก่อนสอบใบประกอบวิชาชีพแพทย์",
    description:
      "MEQ (Modified Essay Question) คืออะไร ต่างจาก MCQ อย่างไร และทำไมถึงสำคัญสำหรับสอบ NL Step 3 อธิบายแบบเข้าใจง่าย พร้อมตัวอย่าง",
    publishedAt: "2026-04-01",
    category: "ความรู้ทั่วไป",
    readingTime: 5,
    content: `
<h2>MEQ คืออะไร?</h2>
<p>MEQ ย่อมาจาก <strong>Modified Essay Question</strong> คือข้อสอบอัตนัยประยุกต์ที่ใช้ในการสอบใบประกอบวิชาชีพเวชกรรม (NL) ขั้นตอนที่ 3 ของประเทศไทย</p>
<p>จุดเด่นของ MEQ คือเป็น <strong>Progressive Case</strong> — โจทย์จะเปิดเผยข้อมูลผู้ป่วยทีละส่วน ราวกับที่คุณกำลังดูแลผู้ป่วยจริงในห้องฉุกเฉิน ตั้งแต่รับผู้ป่วยเข้ามา ซักประวัติ ตรวจร่างกาย สั่งตรวจ จนถึงการวินิจฉัยและวางแผนการรักษา</p>

<h2>โครงสร้างของข้อสอบ MEQ</h2>
<p>ข้อสอบ MEQ 1 ชุด ประกอบด้วย <strong>6 ตอน</strong> (Parts) ต่อเนื่องกัน:</p>
<ul>
  <li><strong>ตอนที่ 1:</strong> อาการสำคัญและประวัติเบื้องต้น → ถามว่าจะซักประวัติเพิ่มเติมอะไร</li>
  <li><strong>ตอนที่ 2:</strong> ผลการตรวจร่างกาย → วินิจฉัยแยกโรค (Differential Diagnosis)</li>
  <li><strong>ตอนที่ 3:</strong> ผลการตรวจทางห้องปฏิบัติการ → การตรวจที่จำเป็น</li>
  <li><strong>ตอนที่ 4:</strong> ผล Lab/Imaging → การวินิจฉัยและการรักษา</li>
  <li><strong>ตอนที่ 5:</strong> การดำเนินโรค → การติดตามผลและภาวะแทรกซ้อน</li>
  <li><strong>ตอนที่ 6:</strong> สรุปและการจำหน่าย → การให้คำแนะนำผู้ป่วย</li>
</ul>

<h2>MEQ ต่างจาก MCQ อย่างไร?</h2>
<table>
  <thead><tr><th>MEQ</th><th>MCQ</th></tr></thead>
  <tbody>
    <tr><td>ตอบอัตนัย เขียนเอง</td><td>เลือกตอบ A–E</td></tr>
    <tr><td>ทดสอบกระบวนการคิด</td><td>ทดสอบความรู้</td></tr>
    <tr><td>ให้คะแนนตาม Key Points</td><td>ถูก/ผิด ชัดเจน</td></tr>
    <tr><td>ใช้เวลา ~20 นาที/เคส</td><td>ใช้เวลา ~1 นาที/ข้อ</td></tr>
  </tbody>
</table>

<h2>เคล็ดลับการทำข้อสอบ MEQ ให้ได้คะแนนดี</h2>
<ol>
  <li><strong>อ่านโจทย์ให้ครบทุกบรรทัด</strong> — ข้อมูลทุกอย่างที่โจทย์ให้มีความหมาย</li>
  <li><strong>ตอบเป็นข้อ ๆ</strong> — ง่ายต่อการให้คะแนน ไม่ตอบเป็นย่อหน้ายาว</li>
  <li><strong>ใช้ภาษาทางการแพทย์</strong> — เขียน "Acute MI" ดีกว่า "หัวใจวาย"</li>
  <li><strong>บอก Dose ให้ครบ</strong> — ยา ต้องมี ชื่อยา + ขนาด + ความถี่ + วิธีให้</li>
  <li><strong>ฝึกบ่อย ๆ</strong> — MEQ ยิ่งฝึก ยิ่งเก่ง ต่างจาก MCQ ที่จำได้</li>
</ol>

<h2>เริ่มฝึก MEQ ได้ที่ไหน?</h2>
<p>หมอรู้มีข้อสอบ MEQ แบบ Progressive Case ครบทั้ง 6 สาขา พร้อม AI ตรวจคำตอบและให้ feedback ทันที <a href="/exams">ลองทำข้อสอบ MEQ ฟรีได้เลย</a> ไม่ต้องใส่บัตรเครดิต</p>
    `.trim(),
  },
  {
    slug: "how-to-prepare-nl-step-3",
    title: "วิธีเตรียมสอบ NL Step 3 ให้ผ่านใน 3 เดือน แผนเรียนครบจบที่เดียว",
    description:
      "แผนเตรียมสอบ NL Step 3 (ใบประกอบวิชาชีพเวชกรรม) แบบครบวงจร ตั้งแต่เริ่มต้นจนสอบผ่าน พร้อมเทคนิคทำ MEQ และ MCQ",
    publishedAt: "2026-04-03",
    category: "เตรียมสอบ",
    readingTime: 8,
    content: `
<h2>NL Step 3 คืออะไร?</h2>
<p>การสอบใบประกอบวิชาชีพเวชกรรม ขั้นตอนที่ 3 (NL Step 3) เป็นด่านสุดท้ายก่อนได้รับใบอนุญาตประกอบวิชาชีพเวชกรรม จัดโดย <strong>แพทยสภา</strong> ปีละ 2 ครั้ง ประกอบด้วย 2 ส่วนหลัก:</p>
<ul>
  <li><strong>ข้อสอบ MCQ</strong> — 200 ข้อ ใช้เวลา 3 ชั่วโมง</li>
  <li><strong>ข้อสอบ MEQ</strong> — 5 เคส ใช้เวลา 2.5 ชั่วโมง</li>
</ul>

<h2>แผนเตรียมสอบ 3 เดือน</h2>

<h3>เดือนที่ 1 — ทบทวนความรู้รากฐาน</h3>
<p>เน้นทบทวนความรู้พื้นฐานทั้ง 6 สาขา:</p>
<ul>
  <li>อายุรศาสตร์ — โรคที่พบบ่อย: DM, HT, ACS, Stroke, Pneumonia</li>
  <li>ศัลยศาสตร์ — Acute abdomen, Trauma, Surgical emergencies</li>
  <li>กุมารเวชศาสตร์ — Fever in child, Dehydration, Asthma</li>
  <li>สูติ-นรีเวช — Antepartum/Postpartum hemorrhage, Preeclampsia</li>
  <li>ออร์โธปิดิกส์ — Fracture management, Compartment syndrome</li>
  <li>จิตเวช — Depression, Schizophrenia, Crisis intervention</li>
</ul>
<p><strong>เป้าหมาย:</strong> ทำ MCQ ให้ได้ 60% ขึ้นไปในแต่ละสาขา</p>

<h3>เดือนที่ 2 — ฝึกทำข้อสอบเข้มข้น</h3>
<ul>
  <li>MCQ: ทำ 50 ข้อ/วัน + อ่านเฉลยทุกข้อ (ไม่ใช่แค่ข้อที่ผิด)</li>
  <li>MEQ: ทำ 1 เคสเต็ม/วัน + เปรียบเทียบกับเฉลย</li>
  <li>จดบันทึก "จุดที่พลาดซ้ำ" แล้วกลับมาทบทวน</li>
</ul>
<p><strong>เป้าหมาย:</strong> MCQ 70%+ และ MEQ ทำครบ Key Points 60%+</p>

<h3>เดือนที่ 3 — Simulation และทบทวน</h3>
<ul>
  <li>ทำ Mock Exam เต็มรูปแบบ (MCQ 200 ข้อ + MEQ 5 เคส) สัปดาห์ละครั้ง</li>
  <li>จำลองสภาพสอบจริง — จับเวลา ไม่เปิดหนังสือ</li>
  <li>ทบทวนเฉพาะจุดอ่อน ไม่อ่านทุกอย่างใหม่</li>
</ul>

<h2>เทคนิคเฉพาะสำหรับ MEQ</h2>
<ol>
  <li><strong>อ่าน Stem แล้วคิด DD ก่อนอ่านคำถาม</strong> — ฝึกความคิดอิสระ</li>
  <li><strong>เขียนเป็นข้อ</strong> — ผู้ตรวจให้คะแนนทีละ Key Point</li>
  <li><strong>ห้ามข้ามตอน</strong> — แต่ละตอนใช้ข้อมูลจากตอนก่อน</li>
  <li><strong>ใช้เวลา 15–20 นาที/เคส</strong> — วางแผนเวลาให้ดี</li>
</ol>

<h2>แหล่งเรียนที่แนะนำ</h2>
<ul>
  <li><strong>หมอรู้</strong> — ข้อสอบ MEQ + MCQ 1,300+ ข้อ + Long Case กับ AI <a href="/pricing">ดูแพ็กเกจ</a></li>
  <li>ตำราอายุรศาสตร์ Harrison's / Cecil's (เน้น Chapter ที่ออกบ่อย)</li>
  <li>แนวสอบของแพทยสภา (ดาวน์โหลดได้จากเว็บแพทยสภา)</li>
</ul>

<h2>สรุป</h2>
<p>การสอบ NL Step 3 ไม่ได้ยากเกินความสามารถ ถ้าวางแผนดีและฝึกสม่ำเสมอ 3 เดือนเพียงพอสำหรับผู้ที่มีพื้นฐานแล้ว เริ่มต้นวันนี้ <a href="/exams">ลองทำข้อสอบ MEQ ฟรี</a> แล้วประเมินตัวเองก่อนเลยครับ</p>
    `.trim(),
  },
  {
    slug: "meq-writing-tips",
    title: "เทคนิคเขียนตอบ MEQ ให้ได้คะแนนเต็ม — 7 หลักการที่ผู้ตรวจอยากเห็น",
    description:
      "เทคนิคเขียนตอบข้อสอบ MEQ ให้ได้คะแนนสูง รู้ว่าผู้ตรวจมองหาอะไร Key Points คืออะไร และควรเขียนอย่างไรให้ถูกต้องครบถ้วน",
    publishedAt: "2026-04-05",
    category: "เทคนิคสอบ",
    readingTime: 6,
    content: `
<h2>ผู้ตรวจ MEQ มองหาอะไร?</h2>
<p>ก่อนจะเขียนตอบ ต้องเข้าใจว่าคนตรวจข้อสอบ MEQ ให้คะแนนอย่างไร คำตอบของคุณจะถูกเทียบกับ <strong>Key Points</strong> ซึ่งเป็นรายการของสิ่งที่ผู้เชี่ยวชาญกำหนดว่าคำตอบที่ดีควรมี</p>
<p>คุณไม่จำเป็นต้องเขียนทุกอย่างที่รู้ แต่ต้องเขียน <strong>สิ่งที่สำคัญที่สุด</strong> ก่อน</p>

<h2>7 หลักการเขียนตอบ MEQ ให้ได้คะแนนสูง</h2>

<h3>1. เขียนเป็นข้อ ไม่เขียนเป็นย่อหน้า</h3>
<p>❌ ไม่ดี: "ผมคิดว่าน่าจะเป็นโรคหัวใจ เพราะผู้ป่วยเจ็บหน้าอก มีเหงื่อออก และความดันโลหิตต่ำ น่าจะต้องทำ ECG และตรวจเลือด..."</p>
<p>✅ ดีกว่า:</p>
<ul>
  <li>Acute MI (STEMI)</li>
  <li>Aortic dissection</li>
  <li>Pulmonary embolism</li>
</ul>

<h3>2. ใช้ภาษาทางการแพทย์ที่ถูกต้อง</h3>
<p>เขียน "Acute MI" ไม่ใช่ "หัวใจวาย" เขียน "Ceftriaxone 1g IV OD" ไม่ใช่ "ให้ยาปฏิชีวนะ" การใช้ภาษาเฉพาะทางแสดงให้เห็นว่าคุณรู้จริง</p>

<h3>3. ตอบยาให้ครบ 4 องค์ประกอบ</h3>
<p>ทุกครั้งที่ตอบเรื่องยา ต้องมีครบ:</p>
<ul>
  <li><strong>ชื่อยา</strong> — Generic name ดีกว่า brand name</li>
  <li><strong>ขนาดยา</strong> — mg/kg หรือ absolute dose</li>
  <li><strong>ช่องทางให้ยา</strong> — PO, IV, IM, SC</li>
  <li><strong>ความถี่</strong> — OD, BD, TDS, QID, PRN</li>
</ul>
<p>ตัวอย่าง: <em>"Metformin 500 mg PO BD with meal"</em></p>

<h3>4. ลำดับความสำคัญให้ถูกต้อง</h3>
<p>ถ้าโจทย์ถามว่า "จะรักษาอย่างไร" ให้เรียงลำดับตาม <strong>ความเร่งด่วน</strong>:</p>
<ol>
  <li>Stabilize (Airway, Breathing, Circulation)</li>
  <li>Specific treatment</li>
  <li>Supportive care</li>
  <li>Monitoring</li>
</ol>

<h3>5. อย่าลืม Safety nets</h3>
<p>ผู้ตรวจมักให้คะแนนพิเศษสำหรับการนึกถึงความปลอดภัยของผู้ป่วย เช่น:</p>
<ul>
  <li>ข้อห้ามใช้ยา (Contraindication)</li>
  <li>การแพ้ยา</li>
  <li>การตรวจซ้ำ / Follow-up</li>
  <li>สัญญาณเตือนที่ต้องกลับมาพบแพทย์</li>
</ul>

<h3>6. จัดการเวลาให้ดี</h3>
<p>แต่ละ MEQ เคส ควรใช้เวลาไม่เกิน <strong>20 นาที</strong>:</p>
<ul>
  <li>2 นาที — อ่านโจทย์ทั้งหมดก่อน</li>
  <li>15 นาที — ตอบทุกตอน</li>
  <li>3 นาที — ตรวจทาน</li>
</ul>
<p>ถ้าติดตอนใดตอนหนึ่ง ให้ข้ามไปก่อนแล้วกลับมา อย่าเสียเวลากับตอนที่ไม่รู้นาน</p>

<h3>7. ฝึกกับ Feedback</h3>
<p>การฝึกคนเดียวโดยไม่มี feedback มีประสิทธิภาพต่ำมาก คุณต้องรู้ว่าตรงไหนที่คิดผิด หมอรู้ใช้ <strong>AI ตรวจคำตอบ</strong> และบอกว่าคุณได้ Key Points ไหนบ้าง ช่วยให้พัฒนาได้เร็วขึ้นหลายเท่า</p>

<h2>ข้อผิดพลาดที่พบบ่อยในการสอบ MEQ</h2>
<ul>
  <li>เขียนยาวเกินไป — ผู้ตรวจไม่ได้ให้คะแนนตามความยาว</li>
  <li>ไม่ตอบคำถามที่ถาม — อ่านคำถามให้ดีก่อนตอบ</li>
  <li>ลืม DD ที่สำคัญ — มักลืมโรคที่ "ต้องห้ามพลาด" เช่น meningitis, PE</li>
  <li>ไม่เขียน dose ยา — ตอบชื่อยาอย่างเดียวได้คะแนนแค่ครึ่ง</li>
</ul>

<h2>ฝึกทักษะ MEQ วันนี้</h2>
<p>ทักษะการเขียนตอบ MEQ พัฒนาได้จากการฝึกเท่านั้น <a href="/exams">เริ่มทำข้อสอบ MEQ ฟรี</a> และรับ feedback จาก AI ได้เลยที่หมอรู้</p>
    `.trim(),
  },
];

export function getBlogPost(slug: string): BlogPost | undefined {
  return blogPosts.find((p) => p.slug === slug);
}

export function getAllSlugs(): string[] {
  return blogPosts.map((p) => p.slug);
}
