create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  name text not null,
  age integer not null check (age between 10 and 100),
  gender text not null check (gender in ('male', 'female')),
  height_cm numeric not null check (height_cm between 100 and 250),
  weight_kg numeric not null check (weight_kg between 20 and 200),
  activity_level numeric not null check (activity_level in (1.2, 1.375, 1.55, 1.725)),
  goal text not null check (goal in ('loss', 'maintain', 'gain')),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

drop policy if exists "Users can read their own profile" on public.profiles;
create policy "Users can read their own profile"
on public.profiles for select
to authenticated
using (auth.uid() = id);

drop policy if exists "Users can create their own profile" on public.profiles;
create policy "Users can create their own profile"
on public.profiles for insert
to authenticated
with check (auth.uid() = id);

drop policy if exists "Users can update their own profile" on public.profiles;
create policy "Users can update their own profile"
on public.profiles for update
to authenticated
using (auth.uid() = id)
with check (auth.uid() = id);