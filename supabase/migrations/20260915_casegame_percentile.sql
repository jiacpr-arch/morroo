-- DEPLOY ORDER: safe in either order — app/api/casegame/rank/route.ts treats a
-- missing/erroring function as "no rank data" and the debrief renders without
-- that row. Idempotent (create-if-not-exists / create-or-replace throughout).
--
-- ทำไมต้องอ่านจาก analytics_events แทน sim_runs: sim_runs มีแค่ผู้เล่นที่
-- ล็อกอิน (~8% ของคนเล่นเกมเคส) ตัวอย่างต่อ slug จึงบางเกินจะทำ percentile
-- ที่น่าเชื่อถือ ส่วน analytics_events.casegame_complete ยิงจากทุกคนรวม guest
-- (lib/sim/track.ts) มี slug/category/score ครบในตอนเดียวกันอยู่แล้ว

-- Partial index — สแกนเฉพาะแถว casegame_complete เรียงตาม slug ใหม่สุดก่อน
create index if not exists analytics_events_casegame_complete_slug_idx
  on public.analytics_events ((properties->>'slug'), created_at desc)
  where event_name = 'casegame_complete';

create or replace function public.get_casegame_percentile(
  p_slug text,
  p_score int,
  p_category text default null,
  p_days int default 180
)
returns table (scope text, sample int, below int, tie int)
language sql
stable
security definer
set search_path = public
as $$
  with runs as (
    select (properties->>'score')::int as score,
           properties->>'slug'         as slug,
           properties->>'category'     as category
    from public.analytics_events
    where event_name = 'casegame_complete'
      and created_at >= now() - make_interval(days => p_days)
      and properties->>'score' ~ '^[0-9]+$'
      and (
        properties->>'slug' = p_slug
        or (p_category is not null and properties->>'category' = p_category)
      )
  )
  select 'slug'::text, count(*)::int,
         count(*) filter (where score < p_score)::int,
         count(*) filter (where score = p_score)::int
  from runs where slug = p_slug
  union all
  select 'category'::text, count(*)::int,
         count(*) filter (where score < p_score)::int,
         count(*) filter (where score = p_score)::int
  from runs where p_category is not null and category = p_category;
$$;

-- Service-role only (SECURITY DEFINER) — the public surface is the rate-limited
-- /api/casegame/rank route using createAdminClient(), not a direct anon grant.
revoke all on function public.get_casegame_percentile(text, int, text, int) from public, anon, authenticated;
