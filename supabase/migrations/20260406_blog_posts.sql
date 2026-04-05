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
