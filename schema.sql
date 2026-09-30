-- Interview Prep Desk: run this once in the Supabase SQL editor.

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text not null unique check (username ~ '^[a-z0-9_]{3,30}$'),
  recovery_email text,
  created_at timestamptz not null default now()
);

create table if not exists public.jobs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  title text not null,
  company text not null default '',
  job_url text,
  job_summary text not null default '',
  resume_summary text not null default '',
  differentiators jsonb not null default '[]'::jsonb,
  is_sample boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.questions (
  id uuid primary key default gen_random_uuid(),
  job_id uuid not null references public.jobs(id) on delete cascade,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  kind text not null check (kind in ('behavioral', 'job_specific')),
  question text not null,
  testing text not null default '',
  starred boolean not null default false,
  position int not null default 0,
  created_at timestamptz not null default now()
);

create index if not exists questions_job_idx on public.questions (job_id, position);
create index if not exists jobs_user_idx on public.jobs (user_id, created_at desc);

-- Row Level Security: every user sees and changes only their own rows.
alter table public.profiles  enable row level security;
alter table public.jobs      enable row level security;
alter table public.questions enable row level security;

create policy "profiles: own row" on public.profiles
  for all using (id = auth.uid()) with check (id = auth.uid());

create policy "jobs: own rows" on public.jobs
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy "questions: own rows" on public.questions
  for all using (user_id = auth.uid())
  with check (
    user_id = auth.uid()
    and exists (select 1 from public.jobs j where j.id = job_id and j.user_id = auth.uid())
  );
