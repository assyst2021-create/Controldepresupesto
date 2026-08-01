-- =============================================
-- TABLAS NUEVAS v2 — ejecutar en Supabase SQL Editor
-- Las tablas movimientos y metas ya existen, no tocar
-- =============================================

-- PAGOS FIJOS (ingresos recurrentes + gastos obligatorios)
create table if not exists public.pagos_fijos (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid references auth.users(id) on delete cascade not null,
  nombre      text not null,
  monto       numeric(14,2) not null,
  tipo        text not null check (tipo in ('ingreso','gasto')),
  dia_cobro   int check (dia_cobro between 1 and 31),
  entidad     text,
  url_pago    text,
  icono       text default '💳',
  activo      boolean default true,
  created_at  timestamptz default now()
);

-- LISTA DE COMPRAS / PLANEADOR
create table if not exists public.items_compras (
  id               uuid primary key default gen_random_uuid(),
  user_id          uuid references auth.users(id) on delete cascade not null,
  nombre           text not null,
  precio_estimado  numeric(14,2),
  prioridad        text check (prioridad in ('alta','media','baja')) default 'media',
  categoria        text,
  url              text,
  comprado         boolean default false,
  notas            text,
  created_at       timestamptz default now()
);

-- RLS
alter table public.pagos_fijos   enable row level security;
alter table public.items_compras enable row level security;

create policy "User owns pagos_fijos"
  on public.pagos_fijos for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "User owns items_compras"
  on public.items_compras for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
