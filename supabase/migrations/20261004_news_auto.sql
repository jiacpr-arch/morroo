-- ข่าวสอบแพทย์ที่ดึงอัตโนมัติ (cron /api/cron/exam-news-fetch + ปุ่ม "ดึงข่าวตอนนี้" ใน /admin/news)
-- ใช้ตาราง news_items เดิม (source_type = 'exam') — เพิ่มเฉพาะคอลัมน์ที่ข่าวอัตโนมัติต้องใช้:
--   origin        manual | auto   — ข่าวอัตโนมัติ "ห้าม" ถูกโพสต์ Facebook/LINE เอง (autopost กรอง origin = manual)
--   is_active     ซ่อน/แสดง       — ข่าวที่ AI ว่าไม่เกี่ยวข้องเก็บแบบซ่อน; แอดมินซ่อน/แสดงทีหลังได้
--   reviewed_at   ตรวจแล้วโดย AI/แอดมิน
--   exam_schedule ข่าวกำหนดการ/เกณฑ์สอบ — แจ้งแอดมินให้ไปเช็ก lib/exam-dates.ts
--   source_name   ชื่อสำนักข่าวต้นทาง
-- dedupe ใช้ external_ref (unique อยู่แล้ว) รูปแบบ "auto:<guid>"
-- additive ทั้งหมด — โค้ดเดิมยังทำงานได้ (ทุกแถวเดิม = manual + แสดง)

alter table public.news_items
  add column if not exists origin text not null default 'manual' check (origin in ('manual', 'auto')),
  add column if not exists is_active boolean not null default true,
  add column if not exists reviewed_at timestamptz,
  add column if not exists exam_schedule boolean not null default false,
  add column if not exists source_name text;

create index if not exists news_items_active_published_at_idx
  on public.news_items (published_at desc)
  where is_active;

-- คนทั่วไปอ่านได้เฉพาะข่าวที่แสดง (ALTER POLICY ไม่ต้อง DROP)
-- หน้า /admin/news อ่านผ่าน service role (GET /api/admin/news) จึงยังเห็นข่าวที่ซ่อน
alter policy "Public read news_items" on public.news_items
  using (is_active);
