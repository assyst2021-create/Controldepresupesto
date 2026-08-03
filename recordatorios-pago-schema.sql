-- Ejecutar en Supabase SQL Editor
create table if not exists public.recordatorios_pago (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid references auth.users(id) on delete cascade not null,
  nombre        text not null,
  monto         numeric(14,2),
  fecha_limite  date,
  pagado        boolean default false,
  notas         text,
  created_at    timestamptz default now()
);

alter table public.recordatorios_pago enable row level security;

create policy "User owns recordatorios_pago"
  on public.recordatorios_pago for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
