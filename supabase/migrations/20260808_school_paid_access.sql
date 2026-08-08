-- ============================================
-- หมอรู้ (MorRoo) — School: แพ็กเกจขาย + เส้นแบ่งฟรี/จ่าย
-- ============================================
-- แนวคิด: ตัดที่ "หัวข้อ" ไม่ใช่ "จำนวนใบ"
--   ฟรี  = หัวข้อตัวอย่าง (is_preview) ใช้ได้เต็มรูปแบบ
--   จ่าย = ทุกหัวข้อ + SRS review + mixed + progress ละเอียด + AI quota สูง
--
-- ไฟล์นี้ทำ 4 อย่าง
--   1. เพิ่ม tier school_monthly / school_term / school_yearly
--   2. school_topics.is_preview — ธงหัวข้อตัวอย่าง (admin เลือกได้เอง)
--   3. school_ai_usage — ตัวนับ quota AI ต่อวัน (เขียนได้เฉพาะ service role)
--   4. เพดาน bookmark/note ของผู้ใช้ฟรี

-- ----------------------------------------------
-- 1. Membership tiers ของ School
-- ----------------------------------------------
-- school_term = ราย 4 เดือน ให้ตรงภาคการศึกษา (หน่วยการซื้อของ นศพ.)
alter table public.profiles drop constraint if exists profiles_membership_type_check;
alter table public.profiles add constraint profiles_membership_type_check
  check (membership_type = any (array[
    'free', 'bundle', 'monthly', 'yearly',
    'mcq_monthly', 'mcq_yearly',
    'meq_monthly', 'meq_yearly',
    'longcase_monthly', 'longcase_yearly',
    'board_monthly', 'board_yearly',
    'school_monthly', 'school_term', 'school_yearly'
  ]));

-- ----------------------------------------------
-- 2. หัวข้อตัวอย่าง (free preview)
-- ----------------------------------------------
alter table public.school_topics
  add column if not exists is_preview boolean not null default false;

comment on column public.school_topics.is_preview is
  'true = หัวข้อตัวอย่างที่ผู้ใช้ฟรีเข้าถึงได้เต็มรูปแบบ (อ่าน/ควิซ/การ์ด ครบ)';

create index if not exists idx_school_topics_is_preview
  on public.school_topics(is_preview) where is_preview;

-- ตั้งค่าเริ่มต้น: เลือกหัวข้อที่ "มีเนื้อหามากที่สุด" 1 หัวข้อต่อ (ชั้นปี × ระบบ)
-- เป็นตัวอย่างให้ก่อน — admin ปรับเปลี่ยนภายหลังได้ตามต้องการ
with unit_counts as (
  select t.id,
         t.year,
         t.system_id,
         t.sort_order,
         (select count(*) from public.school_lessons l
            where l.topic_id = t.id and l.status = 'active')
         + (select count(*) from public.school_quizzes q
              where q.topic_id = t.id and q.status = 'active')
         + (select count(*) from public.school_flashcards f
              where f.topic_id = t.id and f.status = 'active') as units
    from public.school_topics t
), ranked as (
  select id,
         units,
         row_number() over (
           partition by year, system_id
           order by units desc, sort_order
         ) as rn
    from unit_counts
)
update public.school_topics t
   set is_preview = true
  from ranked r
 where r.id = t.id
   and r.rn = 1
   and r.units > 0
   and not t.is_preview;

-- ----------------------------------------------
-- 3. Quota การถาม AI ต่อวัน
-- ----------------------------------------------
-- ตัวนับอยู่ฝั่งเซิร์ฟเวอร์ (service role เท่านั้น) — ถ้าให้ผู้ใช้อัปเดตเองได้
-- จะรีเซ็ตตัวนับตัวเองผ่าน anon key ได้ทันที
create table if not exists public.school_ai_usage (
  user_id uuid not null references auth.users on delete cascade,
  -- นับตามวันเวลาไทย ผู้ใช้จะได้ quota ใหม่ตอนเที่ยงคืนบ้านเรา ไม่ใช่ 7 โมงเช้า
  usage_date date not null default ((now() at time zone 'Asia/Bangkok')::date),
  count int not null default 0,
  updated_at timestamptz not null default now(),
  primary key (user_id, usage_date)
);

alter table public.school_ai_usage enable row level security;

-- อ่านของตัวเองได้ (ใช้โชว์ "เหลืออีกกี่คำถามวันนี้") แต่เขียนไม่ได้
drop policy if exists "Users read own school AI usage" on public.school_ai_usage;
create policy "Users read own school AI usage"
  on public.school_ai_usage for select using (auth.uid() = user_id);

-- เพิ่มตัวนับแบบ atomic — เรียกด้วย service role จาก API route เท่านั้น
create or replace function public.school_bump_ai_usage(
  p_user_id uuid,
  p_limit int
)
returns table (allowed boolean, used int, quota int)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_today date := (now() at time zone 'Asia/Bangkok')::date;
  v_used int;
begin
  insert into public.school_ai_usage (user_id, usage_date, count, updated_at)
  values (p_user_id, v_today, 0, now())
  on conflict (user_id, usage_date) do nothing;

  select c.count into v_used
    from public.school_ai_usage c
   where c.user_id = p_user_id and c.usage_date = v_today
     for update;

  if v_used >= p_limit then
    return query select false, v_used, p_limit;
    return;
  end if;

  update public.school_ai_usage c
     set count = c.count + 1,
         updated_at = now()
   where c.user_id = p_user_id and c.usage_date = v_today
  returning c.count into v_used;

  return query select true, v_used, p_limit;
end;
$$;

revoke all on function public.school_bump_ai_usage(uuid, int) from public, anon, authenticated;

-- ----------------------------------------------
-- 4. เพดาน bookmark / note ของผู้ใช้ฟรี
-- ----------------------------------------------
-- ผู้ใช้เขียนตารางนี้ตรงจากฝั่ง client (RLS = own row) จึงบังคับเพดานที่ trigger
-- ไม่ใช่ที่ UI — ไม่งั้นเลี่ยงได้ด้วยการยิง supabase-js เอง
create or replace function public.school_enforce_free_save_cap()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_has_school boolean;
  v_used int;
begin
  select p.membership_type = any (array[
           'school_monthly', 'school_term', 'school_yearly', 'monthly', 'yearly'
         ])
         and (p.membership_expires_at is null or p.membership_expires_at > now())
    into v_has_school
    from public.profiles p
   where p.id = new.user_id;

  if coalesce(v_has_school, false) then
    return new;
  end if;

  execute format('select count(*) from public.%I where user_id = $1', tg_table_name)
     into v_used
    using new.user_id;

  if v_used >= 20 then
    raise exception 'SCHOOL_FREE_SAVE_CAP'
      using hint = 'ผู้ใช้ฟรีบันทึกได้ 20 ชิ้น — สมัครแพ็ก School เพื่อบันทึกไม่จำกัด';
  end if;

  return new;
end;
$$;

drop trigger if exists trg_school_bookmarks_free_cap on public.school_user_bookmarks;
create trigger trg_school_bookmarks_free_cap
  before insert on public.school_user_bookmarks
  for each row execute function public.school_enforce_free_save_cap();

drop trigger if exists trg_school_notes_free_cap on public.school_user_notes;
create trigger trg_school_notes_free_cap
  before insert on public.school_user_notes
  for each row execute function public.school_enforce_free_save_cap();
