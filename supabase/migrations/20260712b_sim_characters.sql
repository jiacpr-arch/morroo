-- ============================================
-- Code Blue Sim — ตัวละครที่แอดมินเพิ่ม/อัปโหลดรูปเอง
-- (ตัวละคร built-in 4 ตัวยังอยู่ในโค้ด lib/sim/characters.tsx —
--  ตารางนี้เก็บเฉพาะตัวที่เพิ่มผ่านหน้า /admin/sim/characters)
-- ============================================

create table if not exists public.sim_characters (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  name text not null,
  role text,
  plate_top text not null default '#2FA8A0',
  plate_bottom text not null default '#17706B',
  -- key = pose หรือ pose_talk (idle/talk/panic/stern/happy[_talk]) → public URL
  images jsonb not null default '{}'::jsonb,
  -- บุคลิก/วิธีพูด — AI ใช้เขียนบทพูดให้ต่างกันต่อตัวละคร
  personality text,
  -- ท่าเคลื่อนไหวตอนยืนบนเวที
  motion text not null default 'none' check (motion in ('none', 'bob', 'sway', 'pulse')),
  status text not null default 'active' check (status in ('active', 'archived')),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table public.sim_characters enable row level security;

-- เกมโหลดตัวละคร active ได้ทุกคน; งานเขียนทั้งหมดผ่าน service role (admin API)
create policy "Active sim characters readable by everyone"
  on public.sim_characters for select using (status = 'active');

-- Bucket เก็บรูปตัวละคร (public read ผ่าน public URL; upload ผ่าน service role)
insert into storage.buckets (id, name, public)
values ('sim-characters', 'sim-characters', true)
on conflict (id) do nothing;
