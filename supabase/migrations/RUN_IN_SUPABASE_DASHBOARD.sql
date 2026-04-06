-- ════════════════════════════════════════════════════════════════
-- STEP 1: Enable extensions (must do this FIRST in the dashboard)
-- Dashboard → Database → Extensions → enable "pg_cron" and "pg_net"
-- ════════════════════════════════════════════════════════════════

-- ════════════════════════════════════════════════════════════════
-- STEP 2: Add newsletter_opted_out to profiles
-- ════════════════════════════════════════════════════════════════
alter table profiles
  add column if not exists newsletter_opted_out boolean not null default false;

-- ════════════════════════════════════════════════════════════════
-- STEP 3: Create blog_posts table
-- ════════════════════════════════════════════════════════════════
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

alter table blog_posts enable row level security;

create policy "Public read blog_posts" on blog_posts
  for select using (true);

create policy "Service role write blog_posts" on blog_posts
  for all using (auth.role() = 'service_role');

-- ════════════════════════════════════════════════════════════════
-- STEP 4: Seed blog articles
-- ════════════════════════════════════════════════════════════════
insert into blog_posts (slug, title, description, category, reading_time, content, published_at) values
(
  'meq-what-is-it',
  'ข้อสอบ MEQ คืออะไร? ทำความเข้าใจก่อนสอบใบประกอบวิชาชีพแพทย์',
  'MEQ (Modified Essay Question) คืออะไร ต่างจาก MCQ อย่างไร และทำไมถึงสำคัญสำหรับสอบ NL Step 3 อธิบายแบบเข้าใจง่าย พร้อมตัวอย่าง',
  'ความรู้ทั่วไป', 5,
  '<h2>MEQ คืออะไร?</h2><p>MEQ ย่อมาจาก <strong>Modified Essay Question</strong> คือข้อสอบอัตนัยประยุกต์ที่ใช้ในการสอบใบประกอบวิชาชีพเวชกรรม (NL) ขั้นตอนที่ 3 ของประเทศไทย</p>',
  '2026-04-01'
),
(
  'how-to-prepare-nl-step-3',
  'วิธีเตรียมสอบ NL Step 3 ให้ผ่านใน 3 เดือน แผนเรียนครบจบที่เดียว',
  'แผนเตรียมสอบ NL Step 3 (ใบประกอบวิชาชีพเวชกรรม) แบบครบวงจร ตั้งแต่เริ่มต้นจนสอบผ่าน พร้อมเทคนิคทำ MEQ และ MCQ',
  'เตรียมสอบ', 8,
  '<h2>NL Step 3 คืออะไร?</h2><p>การสอบใบประกอบวิชาชีพเวชกรรม ขั้นตอนที่ 3 (NL Step 3) เป็นด่านสุดท้ายก่อนได้รับใบอนุญาตประกอบวิชาชีพเวชกรรม</p>',
  '2026-04-03'
),
(
  'meq-writing-tips',
  'เทคนิคเขียนตอบ MEQ ให้ได้คะแนนเต็ม — 7 หลักการที่ผู้ตรวจอยากเห็น',
  'เทคนิคเขียนตอบข้อสอบ MEQ ให้ได้คะแนนสูง รู้ว่าผู้ตรวจมองหาอะไร Key Points คืออะไร และควรเขียนอย่างไรให้ถูกต้องครบถ้วน',
  'เทคนิคสอบ', 6,
  '<h2>ผู้ตรวจ MEQ มองหาอะไร?</h2><p>ก่อนจะเขียนตอบ ต้องเข้าใจว่าคนตรวจข้อสอบ MEQ ให้คะแนนอย่างไร</p>',
  '2026-04-05'
),
(
  'what-is-long-case-exam',
  'Long Case Exam คืออะไร? วิธีเตรียมตัวและฝึกสอบก่อนวันจริง',
  'Long Case Exam คืออะไร ต่างจาก MEQ อย่างไร และควรเตรียมตัวอย่างไรให้ผ่านการสอบ OSCE-style นี้ได้อย่างมั่นใจ',
  'ความรู้ทั่วไป', 6,
  '<h2>Long Case Exam คืออะไร?</h2><p>Long Case Exam เป็นรูปแบบการสอบที่ใกล้เคียงการทำงานจริงมากที่สุด ผู้สอบต้องซักประวัติผู้ป่วย ตรวจร่างกาย สั่งตรวจ และนำเสนอเคสต่อผู้ตรวจ (Examiner) ในเวลาจำกัด</p>',
  '2026-03-28'
),
(
  'differential-diagnosis-systematic',
  'วิธีคิด Differential Diagnosis อย่างเป็นระบบ — ไม่พลาด Diagnosis สำคัญ',
  'เทคนิคคิด DD ให้ครบและเป็นระบบ ใช้ได้ทั้ง MEQ, Long Case และห้อง ER จริง รวมถึง framework ที่ผู้ตรวจต้องการเห็น',
  'เทคนิคสอบ', 5,
  '<h2>ทำไม DD ถึงสำคัญใน MEQ?</h2><p>ในข้อสอบ MEQ ตอนที่ 2 มักถามว่า "บอก Differential Diagnosis ที่เป็นไปได้" คะแนนส่วนนี้ขึ้นอยู่กับว่าคุณนึกถึง <strong>โรคที่สำคัญและ Dangerous Diagnosis</strong> ได้หรือไม่</p>',
  '2026-03-25'
),
(
  'nl-step3-exam-structure',
  'โครงสร้างข้อสอบ NL Step 3 ครบทุกส่วน — รู้ก่อนเตรียมได้ตรงจุด',
  'รายละเอียดโครงสร้างการสอบใบประกอบวิชาชีพเวชกรรม ขั้นตอนที่ 3 ทุกส่วน MCQ MEQ คะแนน เวลา และเกณฑ์ผ่าน',
  'เตรียมสอบ', 7,
  '<h2>NL Step 3 ประกอบด้วยอะไรบ้าง?</h2><p>การสอบใบประกอบวิชาชีพเวชกรรม ขั้นตอนที่ 3 จัดโดยแพทยสภาปีละ 2 ครั้ง แบ่งเป็น MCQ (200 ข้อ 3 ชั่วโมง) และ MEQ (5 เคส 2.5 ชั่วโมง)</p>',
  '2026-03-20'
),
(
  'time-management-medical-exam',
  'เทคนิค Time Management ในห้องสอบแพทย์ — ไม่ตกเวลา ทุกข้อ',
  'วิธีบริหารเวลาในการสอบ NL Step 3 ทั้ง MCQ และ MEQ ให้ทำได้ครบทุกข้อ ไม่พลาดคะแนนเพราะเวลาหมด',
  'เทคนิคสอบ', 5,
  '<h2>ปัญหาเรื่องเวลาที่พบบ่อย</h2><p>ผู้สอบหลายคนทำข้อสอบได้ดี แต่ไม่ผ่านเพราะ <strong>เวลาหมดก่อนทำครบ</strong> โดยเฉพาะ MEQ ที่ต้องเขียนตอบ</p>',
  '2026-03-15'
),
(
  'common-drugs-nl-step3',
  '20 ยาที่ต้องจำให้ได้สำหรับสอบ NL Step 3 — Dose, Route, Indication',
  'รายการยาที่ออกสอบบ่อยที่สุดใน NL Step 3 พร้อม dose, route, indication และ side effects ที่ต้องรู้ก่อนเข้าห้องสอบ',
  'เตรียมสอบ', 8,
  '<h2>ยาที่ต้องรู้ใน MEQ</h2><p>MEQ มักถามให้สั่งยาพร้อม dose ครบ การไม่รู้ dose เท่ากับเสียคะแนนครึ่งหนึ่ง</p>',
  '2026-03-10'
)
on conflict (slug) do nothing;

-- ════════════════════════════════════════════════════════════════
-- STEP 5: Set app config for cron jobs
-- Replace the values below with your actual values
-- ════════════════════════════════════════════════════════════════
alter database postgres set "app.site_url" = 'https://www.morroo.com';
alter database postgres set "app.blog_generate_secret" = 'morroo-blog-secret-2026';

-- ════════════════════════════════════════════════════════════════
-- STEP 6: Set up pg_cron jobs (requires pg_cron extension enabled)
-- ════════════════════════════════════════════════════════════════

-- Remove old jobs if re-running
select cron.unschedule('auto-generate-blog-post') where exists (
  select 1 from cron.job where jobname = 'auto-generate-blog-post'
);
select cron.unschedule('send-weekly-newsletter') where exists (
  select 1 from cron.job where jobname = 'send-weekly-newsletter'
);

-- Auto-generate blog post: every Monday 01:00 UTC (08:00 ICT)
select cron.schedule(
  'auto-generate-blog-post',
  '0 1 * * 1',
  $$
    select net.http_post(
      url := current_setting('app.site_url') || '/api/blog/generate?secret=' || current_setting('app.blog_generate_secret'),
      headers := '{"Content-Type": "application/json"}'::jsonb,
      body := '{}'::jsonb
    );
  $$
);

-- Send weekly newsletter: every Monday 02:00 UTC (09:00 ICT)
select cron.schedule(
  'send-weekly-newsletter',
  '0 2 * * 1',
  $$
    select net.http_post(
      url := current_setting('app.site_url') || '/api/newsletter/send?secret=' || current_setting('app.blog_generate_secret'),
      headers := '{"Content-Type": "application/json"}'::jsonb,
      body := '{}'::jsonb
    );
  $$
);
