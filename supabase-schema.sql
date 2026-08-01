-- TABLA: movimientos
create table public.movimientos (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid references auth.users(id) on delete cascade not null,
  tipo        text not null check (tipo in ('income','expense','savings')),
  descripcion text not null,
  monto       numeric(14,2) not null,
  categoria   text not null,
  fecha       date not null,
  icono       text default '💰',
  created_at  timestamptz default now()
);

-- TABLA: metas
create table public.metas (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid references auth.users(id) on delete cascade not null,
  nombre     text not null,
  icono      text default '🎯',
  ahorrado   numeric(14,2) default 0,
  meta       numeric(14,2) not null,
  plazo      text,
  created_at timestamptz default now()
);

-- RLS (Row Level Security) — cada usuario solo ve sus datos
alter table public.movimientos enable row level security;
alter table public.metas       enable row level security;

create policy "Usuario ve sus movimientos"
  on public.movimientos for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "Usuario ve sus metas"
  on public.metas for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
