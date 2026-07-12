-- ACLS/BLS course news feed + web-push subscriptions, migrated from
-- emr-ai-clinic. Renamed (news -> acls_news, push_subscriptions ->
-- acls_push_subscriptions) to keep morroo's own news/blog system separate.
--
-- RLS change vs the old project: push subscriptions had anon INSERT/DELETE
-- there; here subscribe/unsubscribe go through app/api/acls/push (service
-- role), so the table has no client policies.

create table if not exists public.acls_news (
  id           uuid primary key default gen_random_uuid(),
  title        text not null,
  summary      text not null,
  source_url   text,
  source_name  text,
  language     text not null default 'th' check (language in ('th','en')),
  course       text not null default 'both' check (course in ('acls','bls','both')),
  topics       text[] not null default '{}',
  published_at timestamptz not null default now(),
  fetched_at   timestamptz not null default now(),
  is_active    boolean not null default true,
  created_at   timestamptz not null default now(),
  is_evergreen boolean not null default false
);
create index if not exists acls_news_course_active_published_idx
  on public.acls_news (course, is_active, published_at desc);
create index if not exists acls_news_evergreen_published_idx
  on public.acls_news (is_evergreen, published_at desc);
create index if not exists acls_news_source_url_idx
  on public.acls_news (source_url) where source_url is not null;

alter table public.acls_news enable row level security;

drop policy if exists acls_news_public_read on public.acls_news;
create policy acls_news_public_read on public.acls_news
  for select using (is_active = true);

create table if not exists public.acls_push_subscriptions (
  id            uuid primary key default gen_random_uuid(),
  endpoint      text unique not null,
  p256dh        text not null,
  auth          text not null,
  course        text not null default 'both' check (course in ('acls','bls','both')),
  user_agent    text,
  created_at    timestamptz not null default now(),
  last_sent_at  timestamptz,
  failure_count integer not null default 0,
  disabled_at   timestamptz
);
create index if not exists acls_push_subscriptions_active_idx
  on public.acls_push_subscriptions (course, disabled_at) where disabled_at is null;

alter table public.acls_push_subscriptions enable row level security;
revoke all on public.acls_push_subscriptions from anon, authenticated;
-- no policies: service role only
