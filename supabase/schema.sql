-- Run this once in Supabase: SQL Editor -> New query -> paste -> Run.
create table if not exists public.profiles(
  id uuid primary key references auth.users(id) on delete cascade,
  name text not null default '', photo text not null default '',
  subjects jsonb not null default '[]', settings jsonb not null default '{}',
  timer jsonb, sub_v int not null default 2, goal_day text not null default '',
  updated_at bigint not null default 0
);
create table if not exists public.sessions(
  user_id uuid not null references auth.users(id) on delete cascade,
  id text not null,
  start_ms bigint not null, end_ms bigint not null, dur int not null,
  type text not null, mode text not null default 'pomodoro',
  subject text not null default '', status text not null,
  created_at timestamptz not null default now(),
  primary key (user_id, id)
);
create index if not exists sessions_user_created on public.sessions(user_id, created_at);
alter table public.profiles enable row level security;
alter table public.sessions enable row level security;
drop policy if exists "own profile" on public.profiles;
drop policy if exists "own sessions" on public.sessions;
create policy "own profile" on public.profiles for all to authenticated using (auth.uid()=id) with check (auth.uid()=id);
create policy "own sessions" on public.sessions for all to authenticated using (auth.uid()=user_id) with check (auth.uid()=user_id);
create or replace function public.delete_my_account() returns void
language sql security definer set search_path=public,auth as $$ delete from auth.users where id=auth.uid(); $$;
revoke all on function public.delete_my_account() from public, anon;
grant execute on function public.delete_my_account() to authenticated;

-- Added for tasks, notes and tests sync (safe to run again)
alter table public.profiles add column if not exists extra jsonb not null default '{}'::jsonb;
