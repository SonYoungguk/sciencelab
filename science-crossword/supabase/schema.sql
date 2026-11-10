-- 과학 용어 퍼즐 배틀: Supabase 스키마
create table public.rooms (
  code text primary key check (code ~ '^[0-9]{4}$'),
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
create table public.players (
  code text not null references public.rooms(code) on delete cascade,
  pid text not null check (char_length(pid) between 4 and 40),
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (code, pid)
);
alter table public.rooms replica identity full;
alter table public.players replica identity full;

alter table public.rooms enable row level security;
alter table public.players enable row level security;
-- 로그인 없는 교실용 게임: 방 번호를 아는 누구나 읽고 쓸 수 있다
create policy "rooms open read" on public.rooms for select to anon, authenticated using (true);
create policy "rooms open insert" on public.rooms for insert to anon, authenticated with check (true);
create policy "rooms open update" on public.rooms for update to anon, authenticated using (true) with check (true);
create policy "players open read" on public.players for select to anon, authenticated using (true);
create policy "players open insert" on public.players for insert to anon, authenticated with check (true);
create policy "players open update" on public.players for update to anon, authenticated using (true) with check (true);
create policy "players open delete" on public.players for delete to anon, authenticated using (true);

-- 방 문서의 최상위 필드만 합치는 갱신
create or replace function public.merge_room(p_code text, p_patch jsonb)
returns void language sql security invoker set search_path = public as $$
  update public.rooms set data = data || p_patch, updated_at = now() where code = p_code;
$$;
grant execute on function public.merge_room(text, jsonb) to anon, authenticated;

-- 기기마다 다른 시계를 맞추기 위한 서버 시각 (밀리초)
create or replace function public.server_now_ms()
returns bigint language sql stable security invoker set search_path = public as $$
  select (extract(epoch from clock_timestamp()) * 1000)::bigint;
$$;
grant execute on function public.server_now_ms() to anon, authenticated;

-- 오래된 방 정리: 새 방이 만들어질 때 3일 지난 방을 지운다
create or replace function public.cleanup_old_rooms()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  delete from public.rooms where updated_at < now() - interval '3 days';
  return new;
end $$;
revoke execute on function public.cleanup_old_rooms() from public, anon, authenticated;
create trigger rooms_cleanup after insert on public.rooms for each statement execute function public.cleanup_old_rooms();

alter publication supabase_realtime add table public.rooms, public.players;
