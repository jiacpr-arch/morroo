-- ปฏิทินสอบ ศรว. ในฐานข้อมูล (แทน NL_EXAM_ROUNDS ในไฟล์โค้ด — ไฟล์เดิมเหลือเป็นค่าสำรอง)
-- อัปเดตเองจากประกาศ ศรว. โดย cron exam-watch (lib/exam-round-scan.ts) และแก้มือได้ที่ /admin/exam-dates
--   source        seed (ข้อมูลตั้งต้น) | manual (แอดมินเพิ่ม) | auto (อ่านจากประกาศ)
--   confirmed     true = วันจากประกาศทางการ (การเตือนนับถอยหลังส่งเฉพาะรอบนี้)
--   locked        แอดมินแก้เองแล้ว — การอัปเดตอัตโนมัติห้ามแตะ
--   evidence      ข้อความต้นฉบับจากประกาศที่ใช้อ้างอิงวันสอบ
--   previous_date วันเดิมก่อนถูกเลื่อน
-- additive ทั้งหมด ไม่มี DROP; unique (kind, label) ใช้จับว่าเป็นรอบเดียวกัน

create table if not exists public.exam_rounds (
  id            uuid primary key default gen_random_uuid(),
  kind          text not null check (kind in ('nl1', 'nl2', 'part1', 'osce', 'meq')),
  label         text not null,
  exam_date     date not null,
  confirmed     boolean not null default false,
  is_active     boolean not null default true,
  source        text not null default 'manual' check (source in ('seed', 'manual', 'auto')),
  source_url    text,
  evidence      text,
  locked        boolean not null default false,
  previous_date date,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  unique (kind, label)
);

create index if not exists exam_rounds_exam_date_idx
  on public.exam_rounds (exam_date)
  where is_active;

alter table public.exam_rounds enable row level security;

-- คนทั่วไปอ่านได้เฉพาะรอบที่แสดง; เขียนผ่าน service role เท่านั้น (ไม่มี write policy)
do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'exam_rounds' and policyname = 'Public read active exam_rounds'
  ) then
    create policy "Public read active exam_rounds" on public.exam_rounds
      for select using (is_active);
  end if;
end $$;

-- ข้อมูลตั้งต้น = ค่าเดิมใน lib/exam-dates.ts (รวมสถานะ confirmed) — พฤติกรรมของเว็บไม่เปลี่ยน
insert into public.exam_rounds (kind, label, exam_date, confirmed, source) values
  ('nl1', 'NL ขั้นตอนที่ 1 รอบ 1/2569', '2026-01-24', true, 'seed'),
  ('nl2', 'NL ขั้นตอนที่ 2 รอบ 1/2569', '2026-01-25', true, 'seed'),
  ('nl2', 'NL ขั้นตอนที่ 2 รอบ 2/2569', '2026-04-19', true, 'seed'),
  ('nl2', 'NL ขั้นตอนที่ 2 รอบ 3/2569', '2026-07-19', true, 'seed'),
  ('nl2', 'NL ขั้นตอนที่ 2 รอบ 4/2569', '2026-10-11', false, 'seed'),
  ('part1', 'ส่วนที่ 1 รอบ 1/2570', '2027-05-01', false, 'seed'),
  ('part1', 'ส่วนที่ 1 รอบ 2/2570', '2027-10-09', false, 'seed'),
  ('osce', 'NL ขั้นตอนที่ 3 (OSCE) รอบ 1/2569', '2026-01-11', true, 'seed'),
  ('osce', 'NL ขั้นตอนที่ 3 (OSCE) รอบ 2/2569', '2026-02-08', true, 'seed'),
  ('osce', 'NL ขั้นตอนที่ 3 (OSCE) รอบ 3/2569', '2026-03-08', true, 'seed'),
  ('osce', 'NL ขั้นตอนที่ 3 (OSCE) รอบ 4/2569', '2026-03-29', true, 'seed'),
  ('osce', 'NL ขั้นตอนที่ 3 (OSCE) รอบพิเศษ/2569', '2026-06-07', true, 'seed'),
  ('osce', 'OSCE รอบ 1/2570', '2027-01-10', false, 'seed')
on conflict (kind, label) do nothing;
