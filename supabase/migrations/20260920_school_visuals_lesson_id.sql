-- Link a Visual Summary (รูปสรุปท้ายบท) to the lesson it summarises, so the
-- lesson reader can show the card on the "เรียนจบบทนี้แล้ว" screen and the
-- figure generator can upsert one card per lesson.
alter table public.school_visuals
  add column if not exists lesson_id uuid references public.school_lessons(id) on delete set null;

create index if not exists school_visuals_lesson_id_idx
  on public.school_visuals (lesson_id)
  where lesson_id is not null;
