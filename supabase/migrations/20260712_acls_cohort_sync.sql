-- Cohort (class-code) system for the ACLS/BLS pre-course, migrated verbatim
-- from emr-ai-clinic (definitions introspected from the live DB).
--
-- Architecture: anonymous student clients call SECURITY DEFINER RPCs with a
-- class_code (bearer secret). Tables are RLS-locked with NO policies so direct
-- access via PostgREST is impossible; only the RPCs (and the service role)
-- can touch them.

create table if not exists public.cohort_classes (
  id              uuid primary key default gen_random_uuid(),
  code            text unique not null,
  name            text not null,
  course_mode     text not null check (course_mode in ('bls','acls')),
  created_at      timestamptz not null default now(),
  archived_at     timestamptz,
  instructor_code text unique
);

create table if not exists public.cohort_students (
  id          uuid primary key,
  class_id    uuid not null references public.cohort_classes(id) on delete cascade,
  student_id  text not null,
  name        text not null,
  phone       text,
  created_at  timestamptz not null default now(),
  unique (class_id, student_id)
);
create index if not exists cohort_students_class_idx
  on public.cohort_students (class_id);

create table if not exists public.cohort_lesson_progress (
  id          uuid primary key default gen_random_uuid(),
  class_id    uuid not null references public.cohort_classes(id) on delete cascade,
  student_pk  uuid not null references public.cohort_students(id) on delete cascade,
  lesson_id   text not null,
  read_at     timestamptz not null default now(),
  unique (student_pk, lesson_id)
);
create index if not exists cohort_lesson_progress_class_idx
  on public.cohort_lesson_progress (class_id);

create table if not exists public.cohort_quiz_attempts (
  id              uuid primary key,
  class_id        uuid not null references public.cohort_classes(id) on delete cascade,
  student_pk      uuid not null references public.cohort_students(id) on delete cascade,
  lesson_id       text not null,
  score           numeric not null,
  total_questions integer not null,
  correct_count   integer not null,
  answers         jsonb not null,
  started_at      timestamptz not null,
  finished_at     timestamptz not null,
  passed          boolean not null,
  attempt_number  integer not null
);
create index if not exists cohort_quiz_attempts_class_idx
  on public.cohort_quiz_attempts (class_id);
create index if not exists cohort_quiz_attempts_student_idx
  on public.cohort_quiz_attempts (student_pk, lesson_id);

-- RLS locked: no policies on purpose.
alter table public.cohort_classes         enable row level security;
alter table public.cohort_students        enable row level security;
alter table public.cohort_lesson_progress enable row level security;
alter table public.cohort_quiz_attempts   enable row level security;

revoke all on public.cohort_classes         from anon, authenticated;
revoke all on public.cohort_students        from anon, authenticated;
revoke all on public.cohort_lesson_progress from anon, authenticated;
revoke all on public.cohort_quiz_attempts   from anon, authenticated;

-- ---------- helpers (not callable by clients) ----------

create or replace function public._cohort_gen_code()
returns text
language plpgsql
set search_path to 'public'
as $$
declare
  alphabet text := 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
  v_code text;
  i int;
  tries int := 0;
begin
  loop
    v_code := '';
    for i in 1..6 loop
      v_code := v_code || substr(alphabet, 1 + floor(random() * length(alphabet))::int, 1);
    end loop;
    exit when not exists (select 1 from cohort_classes where cohort_classes.code = v_code);
    tries := tries + 1;
    if tries > 10 then
      raise exception 'code_generation_failed';
    end if;
  end loop;
  return v_code;
end;
$$;

create or replace function public._cohort_gen_code_v2()
returns text
language plpgsql
set search_path to 'public'
as $$
declare
  alphabet text := 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
  v_code text;
  i int;
  tries int := 0;
begin
  loop
    v_code := '';
    for i in 1..6 loop
      v_code := v_code || substr(alphabet, 1 + floor(random() * length(alphabet))::int, 1);
    end loop;
    exit when not exists (
      select 1 from cohort_classes c
        where c.code = v_code or c.instructor_code = v_code
    );
    tries := tries + 1;
    if tries > 10 then
      raise exception 'code_generation_failed';
    end if;
  end loop;
  return v_code;
end;
$$;

create or replace function public._cohort_resolve_class(p_code text, p_course_mode text default null)
returns uuid
language plpgsql
security definer
set search_path to 'public'
as $$
declare
  v_id uuid;
  v_mode text;
begin
  if p_code is null or length(trim(p_code)) = 0 then
    raise exception 'invalid_code' using errcode = 'P0001';
  end if;
  select id, course_mode into v_id, v_mode
    from cohort_classes
    where code = upper(trim(p_code)) and archived_at is null;
  if v_id is null then
    raise exception 'invalid_code' using errcode = 'P0001';
  end if;
  if p_course_mode is not null and v_mode <> p_course_mode then
    raise exception 'mode_mismatch' using errcode = 'P0001';
  end if;
  return v_id;
end;
$$;

create or replace function public._cohort_resolve_class_instructor(p_code text)
returns uuid
language plpgsql
security definer
set search_path to 'public'
as $$
declare
  v_id uuid;
begin
  if p_code is null or length(trim(p_code)) = 0 then
    raise exception 'invalid_code' using errcode = 'P0001';
  end if;
  select id into v_id
    from cohort_classes
    where instructor_code = upper(trim(p_code)) and archived_at is null;
  if v_id is not null then
    return v_id;
  end if;
  select id into v_id
    from cohort_classes
    where code = upper(trim(p_code))
      and instructor_code is null
      and archived_at is null;
  if v_id is null then
    raise exception 'invalid_code' using errcode = 'P0001';
  end if;
  return v_id;
end;
$$;

-- ---------- public RPCs (bearer class/instructor code) ----------

create or replace function public.create_class(p_name text, p_course_mode text)
returns table(class_id uuid, code text)
language plpgsql
security definer
set search_path to 'public'
as $$
declare
  v_code text;
  v_id uuid;
begin
  if p_course_mode not in ('bls','acls') then
    raise exception 'invalid_mode';
  end if;
  if p_name is null or length(trim(p_name)) = 0 then
    raise exception 'name_required';
  end if;
  v_code := _cohort_gen_code();
  insert into cohort_classes (code, name, course_mode)
    values (v_code, trim(p_name), p_course_mode)
    returning id into v_id;
  return query select v_id, v_code;
end;
$$;

create or replace function public.create_class_v2(p_name text, p_course_mode text)
returns table(class_id uuid, code text, instructor_code text)
language plpgsql
security definer
set search_path to 'public'
as $$
declare
  v_code text;
  v_instructor_code text;
  v_id uuid;
begin
  if p_course_mode not in ('bls','acls') then
    raise exception 'invalid_mode';
  end if;
  if p_name is null or length(trim(p_name)) = 0 then
    raise exception 'name_required';
  end if;
  v_code := _cohort_gen_code_v2();
  v_instructor_code := _cohort_gen_code_v2();
  insert into cohort_classes (code, name, course_mode, instructor_code)
    values (v_code, trim(p_name), p_course_mode, v_instructor_code)
    returning id into v_id;
  return query select v_id, v_code, v_instructor_code;
end;
$$;

create or replace function public.verify_class_code(p_code text)
returns table(class_id uuid, class_name text, course_mode text)
language plpgsql
security definer
set search_path to 'public'
as $$
declare
  v_class_id uuid;
begin
  v_class_id := _cohort_resolve_class(p_code);
  return query
    select c.id, c.name, c.course_mode
      from cohort_classes c
      where c.id = v_class_id;
end;
$$;

create or replace function public.verify_instructor_code(p_code text)
returns table(class_id uuid, class_name text, course_mode text, class_code text, instructor_code text)
language plpgsql
security definer
set search_path to 'public'
as $$
declare
  v_class_id uuid;
begin
  v_class_id := _cohort_resolve_class_instructor(p_code);
  return query
    select c.id, c.name, c.course_mode, c.code, c.instructor_code
      from cohort_classes c
      where c.id = v_class_id;
end;
$$;

create or replace function public.join_class(p_code text, p_student_uuid uuid, p_student_id text, p_name text, p_phone text default null)
returns table(class_id uuid, student_pk uuid, class_name text, course_mode text)
language plpgsql
security definer
set search_path to 'public'
as $$
declare
  v_class_id uuid;
  v_existing_pk uuid;
  v_pk uuid;
  v_class_name text;
  v_mode text;
  v_phone text;
begin
  v_class_id := _cohort_resolve_class(p_code);
  select c.id, c.name, c.course_mode into v_class_id, v_class_name, v_mode
    from cohort_classes c where c.id = v_class_id;

  if p_student_id is null or length(trim(p_student_id)) = 0
     or p_name is null or length(trim(p_name)) = 0 then
    raise exception 'student_required';
  end if;

  v_phone := nullif(trim(coalesce(p_phone, '')), '');

  select cs.id into v_existing_pk
    from cohort_students cs
    where cs.class_id = v_class_id
      and cs.student_id = trim(p_student_id);

  if v_existing_pk is not null then
    update cohort_students
       set name = trim(p_name),
           phone = coalesce(v_phone, phone)
     where id = v_existing_pk;
    v_pk := v_existing_pk;
  else
    v_pk := coalesce(p_student_uuid, gen_random_uuid());
    insert into cohort_students (id, class_id, student_id, name, phone)
      values (v_pk, v_class_id, trim(p_student_id), trim(p_name), v_phone)
      on conflict (id) do update set name = excluded.name, phone = coalesce(excluded.phone, cohort_students.phone);
  end if;

  return query select v_class_id, v_pk, v_class_name, v_mode;
end;
$$;

create or replace function public.upsert_lesson_progress(p_code text, p_student_pk uuid, p_lesson_id text, p_read_at timestamptz)
returns void
language plpgsql
security definer
set search_path to 'public'
as $$
declare
  v_class_id uuid;
begin
  v_class_id := _cohort_resolve_class(p_code);
  if not exists (select 1 from cohort_students where id = p_student_pk and class_id = v_class_id) then
    raise exception 'unknown_student';
  end if;
  insert into cohort_lesson_progress (class_id, student_pk, lesson_id, read_at)
    values (v_class_id, p_student_pk, p_lesson_id, coalesce(p_read_at, now()))
    on conflict (student_pk, lesson_id) do nothing;
end;
$$;

create or replace function public.submit_quiz_attempt(p_code text, p_attempt_uuid uuid, p_student_pk uuid, p_lesson_id text, p_payload jsonb)
returns void
language plpgsql
security definer
set search_path to 'public'
as $$
declare
  v_class_id uuid;
begin
  v_class_id := _cohort_resolve_class(p_code);
  if not exists (select 1 from cohort_students where id = p_student_pk and class_id = v_class_id) then
    raise exception 'unknown_student';
  end if;
  insert into cohort_quiz_attempts (
    id, class_id, student_pk, lesson_id,
    score, total_questions, correct_count, answers,
    started_at, finished_at, passed, attempt_number
  ) values (
    p_attempt_uuid,
    v_class_id,
    p_student_pk,
    p_lesson_id,
    (p_payload->>'score')::numeric,
    (p_payload->>'totalQuestions')::int,
    (p_payload->>'correctCount')::int,
    coalesce(p_payload->'answers', '[]'::jsonb),
    (p_payload->>'startedAt')::timestamptz,
    (p_payload->>'finishedAt')::timestamptz,
    (p_payload->>'passed')::boolean,
    coalesce((p_payload->>'attemptNumber')::int, 1)
  )
  on conflict (id) do nothing;
end;
$$;

create or replace function public.get_cohort_summary(p_code text, p_lesson_ids text[])
returns jsonb
language plpgsql
security definer
set search_path to 'public'
as $$
declare
  v_class_id uuid;
  v_result jsonb;
begin
  v_class_id := _cohort_resolve_class_instructor(p_code);

  with students as (
    select id, student_id, name, phone, created_at
      from cohort_students
      where class_id = v_class_id
      order by created_at desc
  ),
  agg as (
    select
      s.id as student_pk,
      jsonb_build_object('id', s.id, 'studentId', s.student_id, 'name', s.name,
                         'phone', s.phone, 'createdAt', s.created_at) as student,
      coalesce(
        (
          select jsonb_object_agg(lid, lesson_obj)
          from (
            select lid,
              jsonb_build_object(
                'read', exists(
                  select 1 from cohort_lesson_progress lp
                    where lp.student_pk = s.id and lp.lesson_id = lid
                ),
                'attemptCount', (
                  select count(*) from cohort_quiz_attempts q
                    where q.student_pk = s.id and q.lesson_id = lid
                ),
                'bestScore', (
                  select max(q.score) from cohort_quiz_attempts q
                    where q.student_pk = s.id and q.lesson_id = lid
                ),
                'passed', coalesce((
                  select bool_or(q.passed) from cohort_quiz_attempts q
                    where q.student_pk = s.id and q.lesson_id = lid
                ), false),
                'lastAttemptAt', (
                  select max(q.finished_at) from cohort_quiz_attempts q
                    where q.student_pk = s.id and q.lesson_id = lid
                )
              ) as lesson_obj
            from unnest(p_lesson_ids) as lid
          ) sub
        ),
        '{}'::jsonb
      ) as lessons
    from students s
  )
  select coalesce(jsonb_agg(jsonb_build_object('student', student, 'lessons', lessons)), '[]'::jsonb)
    into v_result
    from agg;

  return v_result;
end;
$$;

create or replace function public.get_student_progress(p_code text, p_student_id text)
returns jsonb
language plpgsql
security definer
set search_path to 'public'
as $$
declare
  v_class_id uuid;
  v_student cohort_students%rowtype;
  v_result jsonb;
begin
  v_class_id := _cohort_resolve_class(p_code);

  if p_student_id is null or length(trim(p_student_id)) = 0 then
    return jsonb_build_object('student', null);
  end if;

  select * into v_student
    from cohort_students
    where class_id = v_class_id
      and student_id = trim(p_student_id);

  if not found then
    return jsonb_build_object('student', null);
  end if;

  select jsonb_build_object(
    'student', jsonb_build_object(
      'id', v_student.id,
      'studentId', v_student.student_id,
      'name', v_student.name,
      'phone', v_student.phone,
      'createdAt', v_student.created_at
    ),
    'lessonProgress', coalesce((
      select jsonb_agg(jsonb_build_object(
        'lessonId', lp.lesson_id,
        'readAt', lp.read_at
      ))
      from cohort_lesson_progress lp
      where lp.student_pk = v_student.id
    ), '[]'::jsonb),
    'quizAttempts', coalesce((
      select jsonb_agg(jsonb_build_object(
        'uuid', qa.id,
        'lessonId', qa.lesson_id,
        'score', qa.score,
        'totalQuestions', qa.total_questions,
        'correctCount', qa.correct_count,
        'answers', qa.answers,
        'startedAt', qa.started_at,
        'finishedAt', qa.finished_at,
        'passed', qa.passed,
        'attemptNumber', qa.attempt_number
      ))
      from cohort_quiz_attempts qa
      where qa.student_pk = v_student.id
    ), '[]'::jsonb)
  ) into v_result;

  return v_result;
end;
$$;

create or replace function public.delete_cohort_student(p_code text, p_student_pk uuid)
returns void
language plpgsql
security definer
set search_path to 'public'
as $$
declare
  v_class_id uuid;
begin
  v_class_id := _cohort_resolve_class_instructor(p_code);
  delete from cohort_students where id = p_student_pk and class_id = v_class_id;
end;
$$;

-- ---------- grants ----------

-- helpers: not callable by clients
revoke all on function public._cohort_gen_code() from public, anon, authenticated;
revoke all on function public._cohort_gen_code_v2() from public, anon, authenticated;
revoke all on function public._cohort_resolve_class(text, text) from public, anon, authenticated;
revoke all on function public._cohort_resolve_class_instructor(text) from public, anon, authenticated;

-- public RPCs: callable with the anon key (bearer class/instructor code)
grant execute on function public.create_class(text, text) to anon, authenticated;
grant execute on function public.create_class_v2(text, text) to anon, authenticated;
grant execute on function public.verify_class_code(text) to anon, authenticated;
grant execute on function public.verify_instructor_code(text) to anon, authenticated;
grant execute on function public.join_class(text, uuid, text, text, text) to anon, authenticated;
grant execute on function public.upsert_lesson_progress(text, uuid, text, timestamptz) to anon, authenticated;
grant execute on function public.submit_quiz_attempt(text, uuid, uuid, text, jsonb) to anon, authenticated;
grant execute on function public.get_cohort_summary(text, text[]) to anon, authenticated;
grant execute on function public.get_student_progress(text, text) to anon, authenticated;
grant execute on function public.delete_cohort_student(text, uuid) to anon, authenticated;
