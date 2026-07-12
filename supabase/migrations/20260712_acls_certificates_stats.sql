-- Certificates + admin stat RPCs for the ACLS/BLS course, migrated from
-- emr-ai-clinic. Renames vs the old project (generic names would collide or
-- confuse inside morroo's shared DB):
--   certificates       -> acls_certificates
--   get_admin_stats    -> get_acls_admin_stats
--   get_student_roster -> get_acls_student_roster
--
-- The stat RPCs are service-role only here (the old project granted them to
-- anon, relying on RLS to blank the rows — pointlessly callable).

create table if not exists public.acls_certificates (
  id              uuid primary key default gen_random_uuid(),
  cert_id         text unique not null,
  student_name    text,
  course_mode     text,
  pre_test_score  numeric,
  post_test_score numeric,
  ekg_passed      boolean,
  issued_at       timestamptz not null default now(),
  student_phone   text,
  student_email   text
);

alter table public.acls_certificates enable row level security;
revoke all on public.acls_certificates from anon, authenticated;
-- no policies: service role only (cert-notify API writes, admin API reads)

create or replace function public.get_acls_admin_stats()
returns json
language sql
stable
set search_path to 'public'
as $$
  select json_build_object(
    'students_total', (select count(*) from public.cohort_students),
    'classes_total',  (select count(*) from public.cohort_classes),
    'classes_active', (select count(*) from public.cohort_classes where archived_at is null),
    'students_by_mode', (
      select coalesce(json_agg(t order by t.course_mode), '[]'::json) from (
        select c.course_mode, count(s.id)::int as students
        from public.cohort_students s
        join public.cohort_classes c on c.id = s.class_id
        group by c.course_mode
      ) t
    ),
    'classes_by_mode', (
      select coalesce(json_agg(t order by t.course_mode), '[]'::json) from (
        select course_mode, count(*)::int as classes
        from public.cohort_classes group by course_mode
      ) t
    ),
    'pre_test_passed', (
      select count(distinct student_pk)::int from public.cohort_quiz_attempts
      where lesson_id = 'pre-test' and passed
    ),
    'post_test_passed', (
      select count(distinct student_pk)::int from public.cohort_quiz_attempts
      where lesson_id in ('post-test', 'bls-post-test') and passed
    ),
    'certs_total', (select count(*)::int from public.acls_certificates),
    'certs_by_mode', (
      select coalesce(json_agg(t order by t.course_mode), '[]'::json) from (
        select course_mode, count(*)::int as certs
        from public.acls_certificates group by course_mode
      ) t
    )
  );
$$;

create or replace function public.get_acls_student_roster()
returns json
language sql
stable
set search_path to 'public'
as $$
  with class_students as (
    select
      s.id::text                            as id,
      s.student_id                          as student_id,
      s.name                                as name,
      s.phone                               as phone,
      null::text                            as email,
      c.name                                as class_name,
      c.code                                as class_code,
      c.course_mode                         as course_mode,
      s.created_at                          as created_at,
      exists (
        select 1 from public.cohort_quiz_attempts q
        where q.student_pk = s.id and q.lesson_id = 'pre-test' and q.passed
      )                                     as pre_test_passed,
      exists (
        select 1 from public.cohort_quiz_attempts q
        where q.student_pk = s.id and q.lesson_id in ('post-test', 'bls-post-test') and q.passed
      )                                     as post_test_passed
    from public.cohort_students s
    join public.cohort_classes c on c.id = s.class_id
  ),
  attempt_students as (
    select
      a.student_local_id                                                                          as id,
      max(a.student_code)                                                                         as student_id,
      (array_agg(a.student_name  order by a.created_at desc))[1]                                  as name,
      (array_agg(a.student_phone order by a.created_at desc) filter (where a.student_phone is not null))[1] as phone,
      (array_agg(a.student_email order by a.created_at desc) filter (where a.student_email is not null))[1] as email,
      null::text                                                                                  as class_name,
      null::text                                                                                  as class_code,
      'acls'::text                                                                                as course_mode,
      min(a.created_at)                                                                           as created_at,
      bool_or(a.bank_id = 'pretest'  and a.passed)                                                as pre_test_passed,
      bool_or(a.bank_id = 'posttest' and a.passed)                                                as post_test_passed
    from public.acls_assessment_attempts a
    where a.student_local_id is not null
      and not exists (
        select 1 from public.cohort_students s where s.id::text = a.student_local_id
      )
    group by a.student_local_id
  )
  select coalesce(json_agg(t order by t.created_at desc), '[]'::json)
  from (
    select * from class_students
    union all
    select * from attempt_students
  ) t;
$$;

revoke all on function public.get_acls_admin_stats() from public, anon, authenticated;
revoke all on function public.get_acls_student_roster() from public, anon, authenticated;
