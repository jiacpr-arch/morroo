-- ============================================
-- หมอรู้ (MorRoo) — School: quota ถาม AI + เก็บกวาดของค้างจาก PR #402
-- ============================================
-- PR #402 (ส.ค. 2026) รัน migration 20260808_school_paid_access บน production
-- แต่ตัว PR ไม่เคยถูก merge และหายไปพร้อมการ restore main จาก Vercel เมื่อ
-- 2 ก.ย. — DB จึงมีของที่ repo ไม่รู้จักอยู่ ไฟล์นี้ทำให้สองฝั่งตรงกัน:
--
--   เก็บไว้ (โค้ดใน lib/school/ai-quota.ts ใช้แล้ว):
--     school_ai_usage + school_bump_ai_usage  → เขียนซ้ำแบบ idempotent
--
--   ถอดออก (ไม่มีโค้ดไหนใช้ และขัดกับระบบสิทธิ์ปัจจุบัน):
--     trigger เพดาน bookmark/note 20 ชิ้น — เช็คสิทธิ์จาก
--       profiles.membership_type แบบเดิม แต่ตอนนี้ผู้ซื้อได้สิทธิ์ผ่าน
--       membership_entitlements คนที่ซื้อวิชา/ชั้นปีจะถูกนับเป็นผู้ใช้ฟรี
--       แล้วถูกบล็อกเงียบ ๆ โดยไม่มี UI บอก
--     school_topics.is_preview — โมเดล "วิชาตัวอย่าง" ถูกแทนด้วยการขายรายวิชา
--       (lib/items.ts) และ "บทแรกอ่านฟรี" (lib/school/topic-access.ts)
--
-- ค่า school_term ใน profiles_membership_type_check ปล่อยไว้ — ไม่มีแถวไหนใช้
-- และการเพิ่มค่าที่รับได้ใน check ไม่กระทบอะไร

-- ----------------------------------------------
-- 1. Quota ถาม AI ต่อวัน (มีอยู่แล้วบน production — เขียนซ้ำให้ repo ครบ)
-- ----------------------------------------------
create table if not exists public.school_ai_usage (
  user_id uuid not null references auth.users on delete cascade,
  -- นับตามวันเวลาไทย quota ใหม่มาตอนเที่ยงคืนบ้านเรา ไม่ใช่ 7 โมงเช้า
  usage_date date not null default ((now() at time zone 'Asia/Bangkok')::date),
  count int not null default 0,
  updated_at timestamptz not null default now(),
  primary key (user_id, usage_date)
);

alter table public.school_ai_usage enable row level security;

-- อ่านของตัวเองได้ แต่เขียนไม่ได้ — ถ้าเขียนได้จะรีเซ็ตตัวนับผ่าน anon key
drop policy if exists "Users read own school AI usage" on public.school_ai_usage;
create policy "Users read own school AI usage"
  on public.school_ai_usage for select using (auth.uid() = user_id);

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

-- เรียกได้เฉพาะ service role จาก API route
revoke all on function public.school_bump_ai_usage(uuid, int) from public, anon, authenticated;
grant execute on function public.school_bump_ai_usage(uuid, int) to service_role;

-- ----------------------------------------------
-- 2. ถอดของค้างจาก PR #402
-- ----------------------------------------------
drop trigger if exists trg_school_bookmarks_free_cap on public.school_user_bookmarks;
drop trigger if exists trg_school_notes_free_cap on public.school_user_notes;
drop function if exists public.school_enforce_free_save_cap();

drop index if exists public.idx_school_topics_is_preview;
alter table public.school_topics drop column if exists is_preview;
