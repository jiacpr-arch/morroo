-- Central news feed: aggregates product updates, blog posts, exam announcements,
-- and external sources surfaced via /news.
create table if not exists news_items (
  id            uuid primary key default gen_random_uuid(),
  source_type   text not null check (source_type in ('product_update', 'blog', 'exam', 'external_health')),
  source_section text,  -- 'exams' | 'school' | 'longcase' | 'acls' | 'nl' | null
  title         text not null,
  summary       text not null,
  body          text,
  link          text,
  cover_image   text,
  published_at  timestamptz not null default now(),
  created_at    timestamptz not null default now(),
  pinned        boolean not null default false,
  -- Used by the blog→news sync trigger to keep idempotency without leaking blog ids.
  external_ref  text unique
);

create index if not exists news_items_published_at_idx
  on news_items (published_at desc);

create index if not exists news_items_section_published_at_idx
  on news_items (source_section, published_at desc)
  where source_section is not null;

create index if not exists news_items_source_type_published_at_idx
  on news_items (source_type, published_at desc);

alter table news_items enable row level security;

create policy "Public read news_items" on news_items
  for select using (true);

create policy "Service role write news_items" on news_items
  for all using (auth.role() = 'service_role');

-- Sync blog_posts → news_items so /news surfaces newly published blog content.
create or replace function sync_blog_to_news()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_summary text;
begin
  v_summary := coalesce(new.description, '');
  insert into news_items (
    source_type, source_section, title, summary, link, cover_image,
    published_at, external_ref
  ) values (
    'blog',
    'blog',
    new.title,
    v_summary,
    '/blog/' || new.slug,
    new.cover_image,
    new.published_at,
    'blog:' || new.id::text
  )
  on conflict (external_ref) do update
    set title = excluded.title,
        summary = excluded.summary,
        link = excluded.link,
        cover_image = excluded.cover_image,
        published_at = excluded.published_at;
  return new;
end;
$$;

drop trigger if exists sync_blog_to_news_trg on blog_posts;
create trigger sync_blog_to_news_trg
  after insert or update on blog_posts
  for each row execute function sync_blog_to_news();

-- Backfill existing blog posts so /news isn't empty on first load.
insert into news_items (
  source_type, source_section, title, summary, link, cover_image,
  published_at, external_ref
)
select
  'blog',
  'blog',
  bp.title,
  coalesce(bp.description, ''),
  '/blog/' || bp.slug,
  bp.cover_image,
  bp.published_at,
  'blog:' || bp.id::text
from blog_posts bp
on conflict (external_ref) do nothing;

-- A few seed product updates so the feed isn't dominated by blog posts.
insert into news_items (source_type, source_section, title, summary, body, link, pinned)
values
(
  'product_update',
  'longcase',
  'Long Case AI Examiner ปรับใหม่ — feedback ละเอียดกว่าเดิม',
  'AI Examiner ใน Long Case ตอนนี้ให้ feedback แยกตาม HPI, PE, Investigation, Plan ชัดเจนขึ้น พร้อมแนะนำจุดที่ควรเพิ่ม',
  null,
  '/longcase',
  false
),
(
  'product_update',
  'nl',
  'MCQ NL Step 3 เพิ่มฟีเจอร์ "อธิบายเฉลย" แบบ AI',
  'หลังตอบข้อสอบ MCQ แล้ว สามารถกด "อธิบายเฉลย" เพื่อให้ AI อธิบายแนวคิดและ DDx ที่เกี่ยวข้องได้ทันที',
  null,
  '/nl',
  false
),
(
  'exam',
  'exams',
  'ศรว. เปิดสอบ NL Step 3 รอบถัดไป — เช็กตารางสอบล่าสุด',
  'ตารางสอบใบประกอบวิชาชีพเวชกรรม ขั้นตอนที่ 3 รอบถัดไปประกาศแล้ว ตรวจสอบกำหนดการสมัครและเอกสารที่ต้องเตรียม',
  null,
  'https://www.tmc.or.th/',
  false
)
on conflict do nothing;
