-- Blog posts table for auto-generated SEO articles
create table if not exists blog_posts (
  id          uuid primary key default gen_random_uuid(),
  slug        text not null unique,
  title       text not null,
  description text not null,
  category    text not null,
  reading_time int not null default 5,
  content     text not null,
  published_at timestamptz not null default now(),
  created_at  timestamptz not null default now()
);

-- Allow public read
alter table blog_posts enable row level security;
create policy "Public read blog_posts" on blog_posts
  for select using (true);

-- Only service role can insert/update
create policy "Service role write blog_posts" on blog_posts
  for all using (auth.role() = 'service_role');

-- Seed with existing articles
insert into blog_posts (slug, title, description, category, reading_time, content, published_at) values
(
  'meq-what-is-it',
  'ข้อสอบ MEQ คืออะไร? ทำความเข้าใจก่อนสอบใบประกอบวิชาชีพแพทย์',
  'MEQ (Modified Essay Question) คืออะไร ต่างจาก MCQ อย่างไร และทำไมถึงสำคัญสำหรับสอบ NL Step 3 อธิบายแบบเข้าใจง่าย พร้อมตัวอย่าง',
  'ความรู้ทั่วไป',
  5,
  '<h2>MEQ คืออะไร?</h2><p>MEQ ย่อมาจาก <strong>Modified Essay Question</strong> คือข้อสอบอัตนัยประยุกต์ที่ใช้ในการสอบใบประกอบวิชาชีพเวชกรรม (NL) ขั้นตอนที่ 3 ของประเทศไทย</p>',
  '2026-04-01'
),
(
  'how-to-prepare-nl-step-3',
  'วิธีเตรียมสอบ NL Step 3 ให้ผ่านใน 3 เดือน แผนเรียนครบจบที่เดียว',
  'แผนเตรียมสอบ NL Step 3 (ใบประกอบวิชาชีพเวชกรรม) แบบครบวงจร ตั้งแต่เริ่มต้นจนสอบผ่าน พร้อมเทคนิคทำ MEQ และ MCQ',
  'เตรียมสอบ',
  8,
  '<h2>NL Step 3 คืออะไร?</h2><p>การสอบใบประกอบวิชาชีพเวชกรรม ขั้นตอนที่ 3 (NL Step 3) เป็นด่านสุดท้ายก่อนได้รับใบอนุญาตประกอบวิชาชีพเวชกรรม</p>',
  '2026-04-03'
),
(
  'meq-writing-tips',
  'เทคนิคเขียนตอบ MEQ ให้ได้คะแนนเต็ม — 7 หลักการที่ผู้ตรวจอยากเห็น',
  'เทคนิคเขียนตอบข้อสอบ MEQ ให้ได้คะแนนสูง รู้ว่าผู้ตรวจมองหาอะไร Key Points คืออะไร และควรเขียนอย่างไรให้ถูกต้องครบถ้วน',
  'เทคนิคสอบ',
  6,
  '<h2>ผู้ตรวจ MEQ มองหาอะไร?</h2><p>ก่อนจะเขียนตอบ ต้องเข้าใจว่าคนตรวจข้อสอบ MEQ ให้คะแนนอย่างไร</p>',
  '2026-04-05'
)
on conflict (slug) do nothing;

-- Additional seed articles
insert into blog_posts (slug, title, description, category, reading_time, content, published_at) values
(
  'what-is-long-case-exam',
  'Long Case Exam คืออะไร? วิธีเตรียมตัวและฝึกสอบก่อนวันจริง',
  'Long Case Exam คืออะไร ต่างจาก MEQ อย่างไร และควรเตรียมตัวอย่างไรให้ผ่านการสอบ OSCE-style นี้ได้อย่างมั่นใจ',
  'ความรู้ทั่วไป',
  6,
  '<h2>Long Case Exam คืออะไร?</h2>
<p>Long Case Exam เป็นรูปแบบการสอบที่ใกล้เคียงการทำงานจริงมากที่สุด ผู้สอบต้องซักประวัติผู้ป่วย ตรวจร่างกาย สั่งตรวจ และนำเสนอเคสต่อผู้ตรวจ (Examiner) ในเวลาจำกัด</p>

<h2>โครงสร้าง Long Case ที่หมอรู้ใช้</h2>
<ol>
  <li><strong>ซักประวัติกับ AI Patient</strong> — พิมพ์คำถาม AI ตอบเหมือนผู้ป่วยจริง</li>
  <li><strong>เลือก Physical Examination</strong> — เลือกสิ่งที่จะตรวจ AI แสดงผล PE</li>
  <li><strong>สั่ง Investigation</strong> — เลือก Lab/Imaging ที่ต้องการ รับผล</li>
  <li><strong>Presentation ต่อ AI Examiner</strong> — นำเสนอ 3 นาที รับ feedback + คะแนน</li>
</ol>

<h2>เทคนิคที่ช่วยได้จริง</h2>
<ul>
  <li><strong>ฝึก Presentation format:</strong> CC → HPI → PMH → FH/SH → PE key findings → Investigation → Diagnosis → Plan</li>
  <li><strong>จับเวลาตัวเอง:</strong> นำเสนอให้จบใน 3 นาที ไม่ใช่ 5 นาที</li>
  <li><strong>ฝึกบ่อย ๆ กับเคสหลากหลาย:</strong> สาขาที่ออกบ่อยคือ Cardiology, Surgery, Obs-Gyn</li>
</ul>

<p>ลอง <a href="/longcase">ฝึก Long Case กับ AI ที่หมอรู้</a> ได้เลย ไม่ต้องรอคิวเหมือนสอบจริง</p>',
  '2026-03-28'
),
(
  'differential-diagnosis-systematic',
  'วิธีคิด Differential Diagnosis อย่างเป็นระบบ — ไม่พลาด Diagnosis สำคัญ',
  'เทคนิคคิด DD ให้ครบและเป็นระบบ ใช้ได้ทั้ง MEQ, Long Case และห้อง ER จริง รวมถึง framework ที่ผู้ตรวจต้องการเห็น',
  'เทคนิคสอบ',
  5,
  '<h2>ทำไม DD ถึงสำคัญใน MEQ?</h2>
<p>ในข้อสอบ MEQ ตอนที่ 2 มักถามว่า "บอก Differential Diagnosis ที่เป็นไปได้" คะแนนส่วนนี้ขึ้นอยู่กับว่าคุณนึกถึง <strong>โรคที่สำคัญและ Dangerous Diagnosis</strong> ได้หรือไม่</p>

<h2>Framework: VITAMIN C</h2>
<p>ใช้ VITAMIN C เป็น checklist เพื่อไม่ให้ลืมกลุ่มโรค:</p>
<ul>
  <li><strong>V</strong> — Vascular (MI, Stroke, PE, DVT)</li>
  <li><strong>I</strong> — Infectious (Sepsis, Pneumonia, Meningitis)</li>
  <li><strong>T</strong> — Traumatic / Toxic</li>
  <li><strong>A</strong> — Autoimmune / Allergic</li>
  <li><strong>M</strong> — Metabolic (DKA, Hypo/Hyperglycemia, Electrolyte)</li>
  <li><strong>I</strong> — Iatrogenic (Drug side effect)</li>
  <li><strong>N</strong> — Neoplastic</li>
  <li><strong>C</strong> — Congenital / Degenerative</li>
</ul>

<h2>กฎ Must-Not-Miss</h2>
<p>เสมอต้องมี DD ที่ "ถ้าพลาดแล้วผู้ป่วยตาย" เช่น:</p>
<ul>
  <li>เจ็บหน้าอก → ACS, Aortic dissection, PE</li>
  <li>ปวดหัวรุนแรงทันที → SAH</li>
  <li>ไข้ + altered consciousness → Meningitis, Encephalitis</li>
</ul>

<p><a href="/exams">ฝึก DD ผ่านข้อสอบ MEQ</a> จะช่วยให้คิดเร็วและครบขึ้นเรื่อย ๆ</p>',
  '2026-03-25'
),
(
  'nl-step3-exam-structure',
  'โครงสร้างข้อสอบ NL Step 3 ครบทุกส่วน — รู้ก่อนเตรียมได้ตรงจุด',
  'รายละเอียดโครงสร้างการสอบใบประกอบวิชาชีพเวชกรรม ขั้นตอนที่ 3 ทุกส่วน MCQ MEQ คะแนน เวลา และเกณฑ์ผ่าน',
  'เตรียมสอบ',
  7,
  '<h2>NL Step 3 ประกอบด้วยอะไรบ้าง?</h2>
<p>การสอบใบประกอบวิชาชีพเวชกรรม ขั้นตอนที่ 3 (NL Step 3) จัดโดยแพทยสภาปีละ 2 ครั้ง แบ่งเป็น 2 วันสอบ:</p>

<h3>วันที่ 1 — MCQ (Multiple Choice Questions)</h3>
<table>
  <thead><tr><th>รายการ</th><th>รายละเอียด</th></tr></thead>
  <tbody>
    <tr><td>จำนวนข้อ</td><td>200 ข้อ</td></tr>
    <tr><td>เวลา</td><td>3 ชั่วโมง (180 นาที)</td></tr>
    <tr><td>รูปแบบ</td><td>เลือกตอบ A–E (1 ตัวเลือก)</td></tr>
    <tr><td>สาขา</td><td>อายุรศาสตร์, ศัลยศาสตร์, กุมาร, สูติ-นรีเวช, ออร์โธ, จิตเวช</td></tr>
  </tbody>
</table>

<h3>วันที่ 2 — MEQ (Modified Essay Questions)</h3>
<table>
  <thead><tr><th>รายการ</th><th>รายละเอียด</th></tr></thead>
  <tbody>
    <tr><td>จำนวนเคส</td><td>5 เคส</td></tr>
    <tr><td>ตอน/เคส</td><td>6 ตอน (Progressive Case)</td></tr>
    <tr><td>เวลา</td><td>2.5 ชั่วโมง (150 นาที)</td></tr>
    <tr><td>รูปแบบ</td><td>เขียนตอบอัตนัย ให้คะแนนตาม Key Points</td></tr>
  </tbody>
</table>

<h2>เกณฑ์ผ่าน</h2>
<p>ต้องผ่านทั้ง MCQ และ MEQ — ไม่มีการนำคะแนนมาเฉลี่ยข้ามกัน แต่ละส่วนต้องผ่านเกณฑ์ที่แพทยสภากำหนด (โดยทั่วไป ~60%)</p>

<h2>สาขาที่ควรเน้น</h2>
<p>จากสถิติข้อสอบย้อนหลัง สาขาที่ออกมากที่สุดคือ <strong>อายุรศาสตร์</strong> (ประมาณ 30-35%) รองมาคือ ศัลยศาสตร์ และสูติ-นรีเวช</p>

<p><a href="/exams">เริ่มฝึก MEQ</a> และ <a href="/nl">ฝึก MCQ</a> ตามสัดส่วนที่ออกสอบจริงได้ที่หมอรู้</p>',
  '2026-03-20'
),
(
  'time-management-medical-exam',
  'เทคนิค Time Management ในห้องสอบแพทย์ — ไม่ตกเวลา ทุกข้อ',
  'วิธีบริหารเวลาในการสอบ NL Step 3 ทั้ง MCQ และ MEQ ให้ทำได้ครบทุกข้อ ไม่พลาดคะแนนเพราะเวลาหมด',
  'เทคนิคสอบ',
  5,
  '<h2>ปัญหาเรื่องเวลาที่พบบ่อย</h2>
<p>ผู้สอบหลายคนทำข้อสอบได้ดี แต่ไม่ผ่านเพราะ <strong>เวลาหมดก่อนทำครบ</strong> โดยเฉพาะ MEQ ที่ต้องเขียนตอบ การบริหารเวลาจึงเป็นทักษะที่ต้องฝึก ไม่ใช่แค่รู้เนื้อหา</p>

<h2>MCQ: 200 ข้อ ใน 180 นาที</h2>
<p>เฉลี่ย <strong>54 วินาที/ข้อ</strong> — น้อยมาก ต้องใช้กลยุทธ์:</p>
<ol>
  <li>Pass ข้อที่ไม่รู้ทันที — ทำเครื่องหมายแล้วกลับมา</li>
  <li>ทุก 50 ข้อ เช็คเวลา — ควรใช้ไม่เกิน 45 นาที</li>
  <li>อ่านคำถามก่อนอ่าน stem ยาว — บางครั้งรู้คำตอบทันที</li>
  <li>ห้ามนั่งคิดข้อเดียวเกิน 2 นาที</li>
</ol>

<h2>MEQ: 5 เคส ใน 150 นาที</h2>
<p>เฉลี่ย <strong>30 นาที/เคส</strong> แบ่งเป็น:</p>
<ul>
  <li>2 นาที — อ่านโจทย์ทั้งเคสให้ครบก่อน</li>
  <li>15-20 นาที — ตอบทุกตอน</li>
  <li>3-5 นาที — ตรวจทานและเพิ่มเติม</li>
</ul>
<p>ถ้าติดตอนไหน <strong>ให้ข้ามก่อนเสมอ</strong> อย่าเสียเวลากับตอนที่ไม่รู้</p>

<h2>เทคนิคเพิ่มเติม</h2>
<ul>
  <li>ฝึกกับ Mock Exam เต็มรูปแบบ — จับเวลาจริง</li>
  <li>หมอรู้มีตัวจับเวลาในแต่ละตอนของ MEQ — ฝึกให้ชินก่อนสอบจริง</li>
</ul>

<p><a href="/exams">ลองทำ MEQ พร้อม Timer</a> ได้ที่หมอรู้</p>',
  '2026-03-15'
),
(
  'common-drugs-nl-step3',
  '20 ยาที่ต้องจำให้ได้สำหรับสอบ NL Step 3 — Dose, Route, Indication',
  'รายการยาที่ออกสอบบ่อยที่สุดใน NL Step 3 พร้อม dose, route, indication และ side effects ที่ต้องรู้ก่อนเข้าห้องสอบ',
  'เตรียมสอบ',
  8,
  '<h2>ยาที่ต้องรู้ใน MEQ</h2>
<p>MEQ มักถามให้สั่งยาพร้อม dose ครบ การไม่รู้ dose เท่ากับเสียคะแนนครึ่งหนึ่ง ต่อไปนี้คือยาที่ออกสอบบ่อยที่สุด:</p>

<h3>Antibiotics ที่ออกบ่อย</h3>
<table>
  <thead><tr><th>ยา</th><th>Dose ผู้ใหญ่</th><th>Route</th><th>Indication หลัก</th></tr></thead>
  <tbody>
    <tr><td>Ceftriaxone</td><td>1-2g OD</td><td>IV/IM</td><td>Sepsis, Meningitis, Pneumonia</td></tr>
    <tr><td>Ampicillin-Sulbactam</td><td>3g q6h</td><td>IV</td><td>Intra-abdominal infection</td></tr>
    <tr><td>Metronidazole</td><td>500mg TDS</td><td>PO/IV</td><td>Anaerobic, C. diff, BV</td></tr>
    <tr><td>Azithromycin</td><td>500mg OD x5d</td><td>PO</td><td>Community pneumonia, STI</td></tr>
    <tr><td>Doxycycline</td><td>100mg BD</td><td>PO</td><td>Atypical pneumonia, Chlamydia</td></tr>
  </tbody>
</table>

<h3>Cardiovascular</h3>
<table>
  <thead><tr><th>ยา</th><th>Dose</th><th>Indication</th></tr></thead>
  <tbody>
    <tr><td>Aspirin (loading)</td><td>300mg</td><td>ACS, ischemic stroke</td></tr>
    <tr><td>Clopidogrel (loading)</td><td>300mg</td><td>ACS (DAPT)</td></tr>
    <tr><td>Morphine</td><td>2-4mg IV PRN</td><td>Pain in ACS</td></tr>
    <tr><td>Furosemide</td><td>20-40mg IV</td><td>Acute pulmonary edema</td></tr>
    <tr><td>Metoprolol</td><td>25-50mg BD PO</td><td>Heart failure, HTN</td></tr>
  </tbody>
</table>

<h3>DM / Metabolic</h3>
<table>
  <thead><tr><th>ยา</th><th>Dose</th><th>Route</th></tr></thead>
  <tbody>
    <tr><td>Metformin</td><td>500mg BD with meal</td><td>PO</td></tr>
    <tr><td>Regular Insulin</td><td>0.1 unit/kg/hr</td><td>IV drip (DKA)</td></tr>
    <tr><td>50% Dextrose</td><td>50mL stat</td><td>IV (Hypoglycemia)</td></tr>
  </tbody>
</table>

<p>การฝึกตอบ MEQ บ่อย ๆ จะช่วยให้จำ dose ยาได้โดยอัตโนมัติ <a href="/exams">เริ่มฝึกได้เลยที่หมอรู้</a></p>',
  '2026-03-10'
)
on conflict (slug) do nothing;
