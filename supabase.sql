-- RutaFácil CR: respuestas del formulario de clientes.
-- Pegar completo en Supabase > SQL Editor > New query > Run.

create table if not exists public.respuestas (
  id          bigint generated always as identity primary key,
  token       text not null unique check (char_length(token) between 12 and 40),
  guia        text,
  horario     text,
  senas       text,
  recibe      text,
  lat         double precision,
  lng         double precision,
  owner_id    uuid references auth.users(id),  -- se usará cuando la app tenga login
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- Nadie accede a la tabla directo; solo por las dos funciones de abajo.
alter table public.respuestas enable row level security;

-- El cliente envía (o corrige) su respuesta. Solo quien tiene el link con el token puede escribirla.
create or replace function public.enviar_respuesta(
  p_token text, p_guia text, p_horario text, p_senas text, p_recibe text,
  p_lat double precision, p_lng double precision)
returns void language sql security definer set search_path = public as $$
  insert into respuestas (token, guia, horario, senas, recibe, lat, lng)
  values (p_token, left(p_guia,60), left(p_horario,120), left(p_senas,600), left(p_recibe,80), p_lat, p_lng)
  on conflict (token) do update set
    horario = excluded.horario, senas = excluded.senas, recibe = excluded.recibe,
    lat = coalesce(excluded.lat, respuestas.lat), lng = coalesce(excluded.lng, respuestas.lng),
    updated_at = now();
$$;

-- La app del repartidor lee solo las respuestas de los tokens que ella misma generó.
create or replace function public.leer_respuestas(p_tokens text[])
returns setof respuestas language sql security definer set search_path = public as $$
  select * from respuestas where token = any(p_tokens) and cardinality(p_tokens) <= 300;
$$;

revoke all on function public.enviar_respuesta(text,text,text,text,text,double precision,double precision) from public;
revoke all on function public.leer_respuestas(text[]) from public;
grant execute on function public.enviar_respuesta(text,text,text,text,text,double precision,double precision) to anon, authenticated;
grant execute on function public.leer_respuestas(text[]) to anon, authenticated;
