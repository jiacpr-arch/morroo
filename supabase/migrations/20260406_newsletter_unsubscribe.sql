-- Add newsletter opt-out to profiles
alter table profiles
  add column if not exists newsletter_opted_out boolean not null default false;

-- Unsubscribe tokens table (stateless, token = sha256 of user_id + secret)
-- We verify tokens server-side, no need to store them
