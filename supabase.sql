-- RutaFácil CR: cuentas, respuestas del formulario de clientes y pruebas de entrega.
-- Pegar completo en Supabase > SQL Editor > New query > Run.
-- Se puede correr de nuevo sin problema (no borra datos).

-- =====================================================================
-- Cuentas y licencias (Fase 1a). Agregado 2026-10-30.
-- Entrada con número de teléfono + PIN de 6 dígitos (Supabase Auth, correo
-- interno <8 dígitos>@rutafacilcr.github.io). Un teléfono por cuenta: la sesión
-- del teléfono aprobado queda guardada en rf_perfiles.sesion_id y las funciones
-- de abajo solo responden a esa sesión. Victor administra todo desde admin.html.
-- Mientras rf_ajustes.exigir_cuenta = false, las funciones viejas siguen
-- respondiendo sin cuenta (para no cortar el piloto).
-- =====================================================================

create table if not exists public.rf_ajustes (
  id            int primary key default 1 check (id = 1),
  exigir_cuenta boolean not null default false,  -- true = sin cuenta activa no se leen respuestas ni se suben evidencias
  sinpe         text    not null default '',     -- número SINPE Móvil que ve el mensajero para pagar
  precio        int     not null default 5000,   -- colones por mes, solo informativo
  dias_gracia   int     not null default 3       -- días que sigue funcionando después de vencer
);
insert into public.rf_ajustes (id) values (1) on conflict (id) do nothing;

create table if not exists public.rf_perfiles (
  id                    uuid primary key references auth.users(id) on delete cascade,
  nombre                text not null default '',
  telefono              text not null default '',
  rol                   text not null default 'mensajero' check (rol in ('mensajero','admin')),
  estado                text not null default 'pendiente' check (estado in ('pendiente','activo','suspendido')),
  vence_en              timestamptz,
  dispositivo           text,          -- teléfono aprobado (id aleatorio guardado en ese celular)
  dispositivo_anterior  text,          -- el que se cerró al aprobar un cambio
  dispositivo_pendiente text,          -- teléfono nuevo esperando aprobación
  pendiente_desde       timestamptz,
  sesion_id             text,          -- sesión de Supabase Auth del teléfono aprobado
  ultimo_acceso         timestamptz,
  creado_en             timestamptz not null default now()
);

create table if not exists public.rf_pagos (
  id          bigint generated always as identity primary key,
  user_id     uuid not null references public.rf_perfiles(id) on delete cascade,
  monto       int  not null default 0,
  dias        int  not null,
  referencia  text,
  creado_por  uuid,
  creado_en   timestamptz not null default now()
);

create table if not exists public.rf_eventos (
  id         bigint generated always as identity primary key,
  user_id    uuid references public.rf_perfiles(id) on delete cascade,
  tipo       text not null,   -- cuenta_nueva | telefono_nuevo | aviso_error | telefono_aprobado | telefono_rechazado | telefono_liberado | renovada | estado | pin
  detalle    jsonb not null default '{}',
  creado_en  timestamptz not null default now()
);

-- Nadie lee estas tablas directo; todo pasa por las funciones de abajo.
alter table public.rf_ajustes  enable row level security;
alter table public.rf_perfiles enable row level security;
alter table public.rf_pagos    enable row level security;
alter table public.rf_eventos  enable row level security;

-- Cada cuenta nueva de Auth crea su perfil en estado 'pendiente' (Victor la activa).
create or replace function public.rf_perfil_nuevo()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into rf_perfiles (id, nombre, telefono)
  values (new.id, left(coalesce(new.raw_user_meta_data->>'nombre',''),60),
          coalesce(nullif(new.raw_user_meta_data->>'telefono',''), split_part(new.email,'@',1)))
  on conflict (id) do nothing;
  insert into rf_eventos (user_id, tipo, detalle) values (new.id, 'cuenta_nueva', '{}');
  return new;
end $$;
drop trigger if exists rf_perfil_nuevo on auth.users;
create trigger rf_perfil_nuevo after insert on auth.users
  for each row execute function public.rf_perfil_nuevo();

create or replace function public.rf_es_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from rf_perfiles where id = auth.uid() and rol = 'admin');
$$;

-- ¿Esta llamada viene de una cuenta al día, desde su teléfono aprobado?
create or replace function public.rf_licencia_ok()
returns boolean language sql stable security definer set search_path = public as $$
  select case
    when not coalesce((select exigir_cuenta from rf_ajustes where id = 1), false) then true
    else exists (
      select 1 from rf_perfiles p, rf_ajustes a
      where a.id = 1 and p.id = auth.uid()
        and (p.rol = 'admin'
             or (p.estado = 'activo'
                 and p.vence_en + make_interval(days => a.dias_gracia) > now()
                 and p.sesion_id = (auth.jwt()->>'session_id'))))
  end;
$$;

create or replace function public.rf_exigir_licencia()
returns void language plpgsql stable security definer set search_path = public as $$
begin
  if not public.rf_licencia_ok() then
    raise exception 'RF_CUENTA: la cuenta no está activa en este teléfono';
  end if;
end $$;

-- La app la llama al abrir y cada 15 minutos. Registra el teléfono y devuelve el estado.
create or replace function public.rf_mi_cuenta(p_dispositivo text)
returns json language plpgsql security definer set search_path = public as $$
declare
  p   rf_perfiles;
  a   rf_ajustes;
  sid text := auth.jwt()->>'session_id';
  d   text := left(coalesce(p_dispositivo,''),64);
  est text;
begin
  if auth.uid() is null then raise exception 'RF_CUENTA: sin sesión'; end if;
  select * into a from rf_ajustes where id = 1;
  select * into p from rf_perfiles where id = auth.uid();
  if not found then
    insert into rf_perfiles (id, nombre, telefono)
      select id, coalesce(raw_user_meta_data->>'nombre',''), split_part(email,'@',1) from auth.users where id = auth.uid()
      returning * into p;
  end if;

  if p.rol = 'admin' then
    update rf_perfiles set dispositivo = coalesce(dispositivo, d), ultimo_acceso = now()
      where id = p.id returning * into p;
    est := 'ok';
  elsif p.dispositivo is null or p.dispositivo = d then
    update rf_perfiles set dispositivo = d, sesion_id = sid, ultimo_acceso = now(),
        dispositivo_pendiente = nullif(dispositivo_pendiente, d)
      where id = p.id returning * into p;
    est := 'ok';
  elsif p.dispositivo_anterior = d then
    est := 'cerrado';       -- este teléfono se reemplazó por otro
  else
    if p.dispositivo_pendiente is distinct from d then
      update rf_perfiles set dispositivo_pendiente = d, pendiente_desde = now()
        where id = p.id returning * into p;
      insert into rf_eventos (user_id, tipo, detalle) values (p.id, 'telefono_nuevo', json_build_object('dispositivo', d)::jsonb);
    end if;
    est := 'pendiente';     -- otro teléfono intenta usar la cuenta: Victor decide
  end if;

  return json_build_object(
    'nombre', p.nombre, 'telefono', p.telefono, 'rol', p.rol, 'estado', p.estado,
    'vence_en', p.vence_en, 'dispositivo', est,
    'activo', p.rol = 'admin' or (p.estado = 'activo' and p.vence_en + make_interval(days => a.dias_gracia) > now()),
    'en_gracia', p.rol <> 'admin' and p.estado = 'activo' and p.vence_en < now(),
    'sinpe', a.sinpe, 'precio', a.precio, 'exigir', a.exigir_cuenta);
end $$;

-- ---------- Funciones del panel de Victor (solo rol admin) ----------

create or replace function public.rf_admin_check()
returns void language plpgsql stable security definer set search_path = public as $$
begin
  if not public.rf_es_admin() then raise exception 'RF_ADMIN: solo el administrador'; end if;
end $$;

create or replace function public.rf_admin_cuentas()
returns json language plpgsql stable security definer set search_path = public as $$
begin
  perform public.rf_admin_check();
  return coalesce((select json_agg(x order by x.pendiente desc, x.creado_en desc) from (
    select p.id, p.nombre, p.telefono, p.rol, p.estado, p.vence_en, p.ultimo_acceso, p.creado_en,
           p.dispositivo is not null as con_telefono,
           p.dispositivo_pendiente is not null as pendiente, p.pendiente_desde,
           (select json_build_object('monto', g.monto, 'dias', g.dias, 'fecha', g.creado_en, 'referencia', g.referencia)
              from rf_pagos g where g.user_id = p.id order by g.creado_en desc limit 1) as ultimo_pago
    from rf_perfiles p) x), '[]'::json);
end $$;

create or replace function public.rf_admin_renovar(p_id uuid, p_dias int, p_monto int, p_referencia text)
returns void language plpgsql security definer set search_path = public as $$
begin
  perform public.rf_admin_check();
  if p_dias < 1 or p_dias > 400 then raise exception 'RF_ADMIN: días fuera de rango'; end if;
  update rf_perfiles set estado = 'activo',
         vence_en = greatest(coalesce(vence_en, now()), now()) + make_interval(days => p_dias)
   where id = p_id;
  insert into rf_pagos (user_id, monto, dias, referencia, creado_por)
    values (p_id, greatest(coalesce(p_monto,0),0), p_dias, left(p_referencia,80), auth.uid());
  insert into rf_eventos (user_id, tipo, detalle)
    values (p_id, 'renovada', json_build_object('dias', p_dias, 'monto', p_monto)::jsonb);
end $$;

create or replace function public.rf_admin_estado(p_id uuid, p_estado text)
returns void language plpgsql security definer set search_path = public as $$
begin
  perform public.rf_admin_check();
  if p_estado not in ('activo','suspendido') then raise exception 'RF_ADMIN: estado inválido'; end if;
  update rf_perfiles set estado = p_estado where id = p_id and rol <> 'admin';
  insert into rf_eventos (user_id, tipo, detalle) values (p_id, 'estado', json_build_object('estado', p_estado)::jsonb);
end $$;

-- aprobar = el teléfono nuevo reemplaza al viejo (el viejo se cierra); rechazar = se ignora;
-- liberar = la cuenta queda libre y el próximo teléfono que entre queda aprobado.
create or replace function public.rf_admin_telefono(p_id uuid, p_accion text)
returns void language plpgsql security definer set search_path = public as $$
begin
  perform public.rf_admin_check();
  if p_accion = 'aprobar' then
    update rf_perfiles set dispositivo_anterior = dispositivo, dispositivo = dispositivo_pendiente,
           dispositivo_pendiente = null, pendiente_desde = null, sesion_id = null
     where id = p_id and dispositivo_pendiente is not null;
  elsif p_accion = 'rechazar' then
    update rf_perfiles set dispositivo_pendiente = null, pendiente_desde = null where id = p_id;
  elsif p_accion = 'liberar' then
    update rf_perfiles set dispositivo_anterior = null, dispositivo = null, dispositivo_pendiente = null,
           pendiente_desde = null, sesion_id = null where id = p_id;
  else
    raise exception 'RF_ADMIN: acción inválida';
  end if;
  insert into rf_eventos (user_id, tipo, detalle) values (p_id, 'telefono_' || left(p_accion, length(p_accion) - 1) || 'do', '{}');
end $$;

-- PIN nuevo para quien lo olvidó (Victor se lo pasa por WhatsApp).
create or replace function public.rf_admin_pin(p_id uuid, p_pin text)
returns void language plpgsql security definer set search_path = public, extensions as $$
begin
  perform public.rf_admin_check();
  if p_pin !~ '^\d{6}$' then raise exception 'RF_ADMIN: el PIN debe tener 6 números'; end if;
  update auth.users set encrypted_password = extensions.crypt(p_pin, extensions.gen_salt('bf')), updated_at = now()
   where id = p_id;
  insert into rf_eventos (user_id, tipo, detalle) values (p_id, 'pin', '{}');
end $$;

create or replace function public.rf_admin_nombre(p_id uuid, p_nombre text)
returns void language plpgsql security definer set search_path = public as $$
begin
  perform public.rf_admin_check();
  update rf_perfiles set nombre = left(trim(p_nombre),60) where id = p_id;
end $$;

create or replace function public.rf_admin_ajustes(p_exigir boolean, p_sinpe text, p_precio int, p_gracia int)
returns json language plpgsql security definer set search_path = public as $$
declare a rf_ajustes;
begin
  perform public.rf_admin_check();
  update rf_ajustes set
    exigir_cuenta = coalesce(p_exigir, exigir_cuenta),
    sinpe         = coalesce(left(p_sinpe,20), sinpe),
    precio        = case when p_precio is null then precio else greatest(p_precio,0) end,
    dias_gracia   = case when p_gracia is null then dias_gracia else least(greatest(p_gracia,0),30) end
  where id = 1 returning * into a;
  return row_to_json(a);
end $$;

create or replace function public.rf_admin_eventos()
returns json language plpgsql stable security definer set search_path = public as $$
begin
  perform public.rf_admin_check();
  return coalesce((select json_agg(x) from (
    select e.tipo, e.detalle, e.creado_en, p.nombre, p.telefono
      from rf_eventos e left join rf_perfiles p on p.id = e.user_id
     order by e.creado_en desc limit 60) x), '[]'::json);
end $$;

-- ---------------------------------------------------------------------
-- Avisos a Victor (1.10.0): cuando alguien crea cuenta o pide usar otro
-- teléfono, la base le manda un WhatsApp (CallMeBot, gratis, solo a su propio
-- número) y un correo (Resend, plan gratis). Las llaves se guardan desde el
-- Panel (Ajustes > Avisos) y nunca vuelven al navegador ni van al repositorio.
-- Si falta una llave, ese aviso simplemente no sale; la cuenta se crea igual.
-- ---------------------------------------------------------------------
create extension if not exists pg_net;

create table if not exists public.rf_avisos (
  id            int primary key default 1 check (id = 1),
  whatsapp      text not null default '',   -- 8 dígitos del administrador
  callmebot_key text not null default '',
  correo        text not null default '',
  resend_key    text not null default ''
);
insert into public.rf_avisos (id) values (1) on conflict (id) do nothing;
alter table public.rf_avisos enable row level security;

create or replace function public.rf_avisar_admin(p_asunto text, p_texto text)
returns void language plpgsql security definer set search_path = public as $$
declare a rf_avisos;
begin
  select * into a from rf_avisos where id = 1;
  if not found then return; end if;
  begin
    if a.whatsapp <> '' and a.callmebot_key <> '' then
      perform net.http_get('https://api.callmebot.com/whatsapp.php',
        jsonb_build_object('phone', '+506' || a.whatsapp, 'text', p_texto, 'apikey', a.callmebot_key));
    end if;
    if a.correo <> '' and a.resend_key <> '' then
      perform net.http_post('https://api.resend.com/emails',
        jsonb_build_object('from', 'RutaFácil <onboarding@resend.dev>', 'to', jsonb_build_array(a.correo),
                           'subject', p_asunto, 'text', p_texto),
        '{}'::jsonb,
        jsonb_build_object('Authorization', 'Bearer ' || a.resend_key, 'Content-Type', 'application/json'));
    end if;
  exception when others then
    insert into rf_eventos (tipo, detalle) values ('aviso_error', json_build_object('error', sqlerrm)::jsonb);
  end;
end $$;

create or replace function public.rf_evento_aviso()
returns trigger language plpgsql security definer set search_path = public as $$
declare p rf_perfiles; quien text; panel text := 'https://rutafacilcr.github.io/admin.html';
begin
  select * into p from rf_perfiles where id = new.user_id;
  quien := coalesce(nullif(p.nombre,''), '(sin nombre)') || ' · ' || coalesce(p.telefono,'');
  if new.tipo = 'cuenta_nueva' then
    perform rf_avisar_admin('RutaFácil: cuenta nueva por activar',
      'RutaFácil: cuenta nueva de ' || quien || '. Activala en el Panel cuando pague: ' || panel);
  elsif new.tipo = 'telefono_nuevo' then
    perform rf_avisar_admin('RutaFácil: pide usar otro teléfono',
      'RutaFácil: ' || quien || ' pide usar la cuenta en otro teléfono. Aprobalo o rechazalo en el Panel: ' || panel);
  end if;
  return new;
end $$;
drop trigger if exists rf_evento_aviso on public.rf_eventos;
create trigger rf_evento_aviso after insert on public.rf_eventos
  for each row when (new.tipo in ('cuenta_nueva','telefono_nuevo'))
  execute function public.rf_evento_aviso();

-- Lee (todo null) o cambia los avisos. Las llaves solo se escriben: se devuelve si hay una guardada.
-- Texto vacío ('') borra el valor; null lo deja como está.
create or replace function public.rf_admin_avisos(p_whatsapp text, p_callmebot_key text, p_correo text, p_resend_key text)
returns json language plpgsql security definer set search_path = public as $$
declare a rf_avisos;
begin
  perform public.rf_admin_check();
  update rf_avisos set
    whatsapp      = case when p_whatsapp is null then whatsapp else left(regexp_replace(p_whatsapp,'\D','','g'),8) end,
    callmebot_key = case when p_callmebot_key is null then callmebot_key else left(trim(p_callmebot_key),80) end,
    correo        = case when p_correo is null then correo else left(trim(p_correo),120) end,
    resend_key    = case when p_resend_key is null then resend_key else left(trim(p_resend_key),120) end
   where id = 1 returning * into a;
  return json_build_object('whatsapp', a.whatsapp, 'correo', a.correo,
    'callmebot', a.callmebot_key <> '', 'resend', a.resend_key <> '');
end $$;

create or replace function public.rf_admin_probar_avisos()
returns void language plpgsql security definer set search_path = public as $$
begin
  perform public.rf_admin_check();
  perform rf_avisar_admin('RutaFácil: prueba de avisos', 'RutaFácil: prueba de avisos. Si te llegó esto, los avisos de cuentas nuevas funcionan.');
end $$;

revoke all on function public.rf_perfil_nuevo() from public, anon, authenticated;
revoke all on function public.rf_es_admin() from public;
revoke all on function public.rf_licencia_ok() from public;
revoke all on function public.rf_exigir_licencia() from public;
revoke all on function public.rf_mi_cuenta(text) from public;
revoke all on function public.rf_admin_check() from public;
revoke all on function public.rf_admin_cuentas() from public;
revoke all on function public.rf_admin_renovar(uuid,int,int,text) from public;
revoke all on function public.rf_admin_estado(uuid,text) from public;
revoke all on function public.rf_admin_telefono(uuid,text) from public;
revoke all on function public.rf_admin_pin(uuid,text) from public;
revoke all on function public.rf_admin_nombre(uuid,text) from public;
revoke all on function public.rf_admin_ajustes(boolean,text,int,int) from public;
revoke all on function public.rf_admin_eventos() from public;
revoke all on function public.rf_avisar_admin(text,text) from public, anon, authenticated;
revoke all on function public.rf_evento_aviso() from public, anon, authenticated;
revoke all on function public.rf_admin_avisos(text,text,text,text) from public;
revoke all on function public.rf_admin_probar_avisos() from public;
grant execute on function public.rf_licencia_ok() to anon, authenticated;
grant execute on function public.rf_exigir_licencia() to anon, authenticated;
grant execute on function public.rf_es_admin() to authenticated;
grant execute on function public.rf_mi_cuenta(text) to authenticated;
grant execute on function public.rf_admin_check() to authenticated;
grant execute on function public.rf_admin_cuentas() to authenticated;
grant execute on function public.rf_admin_renovar(uuid,int,int,text) to authenticated;
grant execute on function public.rf_admin_estado(uuid,text) to authenticated;
grant execute on function public.rf_admin_telefono(uuid,text) to authenticated;
grant execute on function public.rf_admin_pin(uuid,text) to authenticated;
grant execute on function public.rf_admin_nombre(uuid,text) to authenticated;
grant execute on function public.rf_admin_ajustes(boolean,text,int,int) to authenticated;
grant execute on function public.rf_admin_eventos() to authenticated;
grant execute on function public.rf_admin_avisos(text,text,text,text) to authenticated;
grant execute on function public.rf_admin_probar_avisos() to authenticated;

-- Para hacerse administrador (una sola vez, después de crear la cuenta en la app):
--   update public.rf_perfiles set rol = 'admin', estado = 'activo' where telefono = '62700666';

-- =====================================================================
-- Formulario de clientes
-- =====================================================================

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
-- Con exigir_cuenta activo, solo responde a una cuenta al día desde su teléfono aprobado.
create or replace function public.leer_respuestas(p_tokens text[])
returns setof respuestas language plpgsql security definer set search_path = public as $$
begin
  perform public.rf_exigir_licencia();
  return query select * from respuestas where token = any(p_tokens) and cardinality(p_tokens) <= 300;
end $$;

revoke all on function public.enviar_respuesta(text,text,text,text,text,double precision,double precision) from public;
revoke all on function public.leer_respuestas(text[]) from public;
grant execute on function public.enviar_respuesta(text,text,text,text,text,double precision,double precision) to anon, authenticated;
grant execute on function public.leer_respuestas(text[]) to anon, authenticated;

-- =====================================================================
-- Prueba de entrega (fotos + GPS + fecha/hora). Agregado 2026-10-29.
-- Se puede correr de nuevo sin problema.
-- =====================================================================

create table if not exists public.entregas (
  id            bigint generated always as identity primary key,
  evidencia_id  text not null unique check (char_length(evidencia_id) between 12 and 40),
  guia          text,
  cliente       text,
  repartidor    text,
  lat           double precision,
  lng           double precision,
  precision_m   double precision,
  entregado_en  timestamptz not null,
  fotos         text[] not null default '{}',
  owner_id      uuid references auth.users(id),  -- se usará cuando la app tenga login
  created_at    timestamptz not null default now()
);
alter table public.entregas enable row level security;

create or replace function public.registrar_entrega(
  p_evidencia_id text, p_guia text, p_cliente text, p_repartidor text,
  p_lat double precision, p_lng double precision, p_precision double precision,
  p_entregado_en timestamptz, p_fotos text[])
returns void language plpgsql security definer set search_path = public as $$
begin
  perform public.rf_exigir_licencia();
  insert into entregas (evidencia_id, guia, cliente, repartidor, lat, lng, precision_m, entregado_en, fotos, owner_id)
  values (p_evidencia_id, left(p_guia,60), left(p_cliente,80), left(p_repartidor,80),
          p_lat, p_lng, p_precision, p_entregado_en, p_fotos[1:10], auth.uid())
  on conflict (evidencia_id) do update set fotos = excluded.fotos;
end $$;
revoke all on function public.registrar_entrega(text,text,text,text,double precision,double precision,double precision,timestamptz,text[]) from public;
grant execute on function public.registrar_entrega(text,text,text,text,double precision,double precision,double precision,timestamptz,text[]) to anon, authenticated;

-- Carpeta privada para las fotos. La app solo puede SUBIR; verlas se hace desde el panel de Supabase.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('evidencias', 'evidencias', false, 2097152, array['image/jpeg'])
on conflict (id) do nothing;

drop policy if exists "rutafacil subir evidencias" on storage.objects;
create policy "rutafacil subir evidencias" on storage.objects
  for insert to anon, authenticated
  with check (bucket_id = 'evidencias' and public.rf_licencia_ok());

-- El administrador puede ver y borrar fotos viejas desde admin.html (para no pasarse del plan gratis).
drop policy if exists "rutafacil admin ve evidencias" on storage.objects;
create policy "rutafacil admin ve evidencias" on storage.objects
  for select to authenticated
  using (bucket_id = 'evidencias' and public.rf_es_admin());
drop policy if exists "rutafacil admin borra evidencias" on storage.objects;
create policy "rutafacil admin borra evidencias" on storage.objects
  for delete to authenticated
  using (bucket_id = 'evidencias' and public.rf_es_admin());
