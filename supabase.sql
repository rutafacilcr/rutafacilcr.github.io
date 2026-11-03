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
-- 1.74.0 (20 a 150 mensajeros): fotos de entrega en la nube. 'ninguna' (de fábrica) = las fotos quedan
-- solo en el celular y a la nube va la entrega sin fotos (hora, GPS, quién recibió); 'una' = 1 foto
-- reducida + firma; 'todas' = las 3 fotos + firma. dias_fotos = días que se guardan en la nube antes de
-- que la app de cada mensajero las borre sola (0 = no se borran).
alter table public.rf_ajustes add column if not exists fotos_nube text not null default 'ninguna';
alter table public.rf_ajustes drop constraint if exists rf_ajustes_fotos_nube_check;
alter table public.rf_ajustes add constraint rf_ajustes_fotos_nube_check check (fotos_nube in ('ninguna','una','todas'));
alter table public.rf_ajustes add column if not exists dias_fotos int not null default 21
  check (dias_fotos between 0 and 365);
-- dias_cierres: días que se guardan los cierres en la base (0 = siempre). De fábrica 15 (decisión de Victor,
-- 2026-11-03): con 150 mensajeros los cierres llenarían los 500 MB en ~6 semanas; con 15 días usan ~170 MB.
alter table public.rf_ajustes add column if not exists dias_cierres int not null default 15
  check (dias_cierres between 0 and 3650);

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
    'sinpe', a.sinpe, 'precio', a.precio, 'exigir', a.exigir_cuenta,
    'fotos_nube', a.fotos_nube, 'dias_fotos', a.dias_fotos, 'dias_cierres', a.dias_cierres);
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
-- 1.74.0 (20 mensajeros): cada respuesta queda amarrada a la cuenta que la lee primero (owner_id) y
-- después solo esa cuenta la ve, aunque otra cuenta conociera el token. Siempre exige sesión.
-- p_desde: solo devuelve lo que cambió después de esa hora (la app lo manda para no bajar todo cada minuto).
drop function if exists public.leer_respuestas(text[]);
create or replace function public.leer_respuestas(p_tokens text[], p_desde timestamptz default null)
returns setof respuestas language plpgsql security definer set search_path = public as $$
begin
  perform public.rf_exigir_licencia();
  if auth.uid() is null then raise exception 'RF_CUENTA: sin sesión'; end if;
  if coalesce(cardinality(p_tokens), 0) = 0 or cardinality(p_tokens) > 1000 then return; end if;  -- antes 300: con listas grandes no llegaba nada
  update respuestas set owner_id = auth.uid() where token = any(p_tokens) and owner_id is null;
  return query select * from respuestas
    where token = any(p_tokens) and owner_id = auth.uid()
      and (p_desde is null or updated_at > p_desde);
end $$;

revoke all on function public.enviar_respuesta(text,text,text,text,text,double precision,double precision) from public;
revoke all on function public.leer_respuestas(text[], timestamptz) from public, anon;
grant execute on function public.enviar_respuesta(text,text,text,text,text,double precision,double precision) to anon, authenticated;
grant execute on function public.leer_respuestas(text[], timestamptz) to authenticated;

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

alter table public.entregas add column if not exists recibe text;  -- 1.13: nombre de quien recibe ("… (no firmó)" si no firmó)

-- La firma va como la última foto, terminada en _firma.jpg.
drop function if exists public.registrar_entrega(text,text,text,text,double precision,double precision,double precision,timestamptz,text[]);
create or replace function public.registrar_entrega(
  p_evidencia_id text, p_guia text, p_cliente text, p_repartidor text,
  p_lat double precision, p_lng double precision, p_precision double precision,
  p_entregado_en timestamptz, p_fotos text[], p_recibe text default null)
returns void language plpgsql security definer set search_path = public as $$
begin
  perform public.rf_exigir_licencia();
  if auth.uid() is null then raise exception 'RF_CUENTA: sin sesión'; end if;  -- 1.74.0: siempre con cuenta
  insert into entregas (evidencia_id, guia, cliente, repartidor, lat, lng, precision_m, entregado_en, fotos, owner_id, recibe)
  values (p_evidencia_id, left(p_guia,60), left(p_cliente,80), left(p_repartidor,80),
          p_lat, p_lng, p_precision, p_entregado_en, p_fotos[1:10], auth.uid(), left(p_recibe,80))
  on conflict (evidencia_id) do update set fotos = excluded.fotos, recibe = coalesce(excluded.recibe, entregas.recibe)
    where entregas.owner_id = auth.uid();  -- 1.74.0: nadie corrige la entrega de otra cuenta
end $$;
revoke all on function public.registrar_entrega(text,text,text,text,double precision,double precision,double precision,timestamptz,text[],text) from public;
revoke all on function public.registrar_entrega(text,text,text,text,double precision,double precision,double precision,timestamptz,text[],text) from anon;
grant execute on function public.registrar_entrega(text,text,text,text,double precision,double precision,double precision,timestamptz,text[],text) to authenticated;

-- =====================================================================
-- Lista sincronizada (1.18.0). Agregado 2026-10-31.
-- La lista de paquetes y los textos de los mensajes de cada cuenta, para verlos
-- igual en el teléfono y en la PC. Un registro por cuenta (JSON). Sin políticas:
-- solo se lee y escribe con las funciones rf_lista_* (que exigen licencia).
-- =====================================================================
create table if not exists public.rf_listas (
  owner_id    uuid primary key references auth.users(id) on delete cascade,
  datos       jsonb not null default '{}'::jsonb,
  version     bigint not null default 0,
  actualizado timestamptz not null default now()
);
alter table public.rf_listas enable row level security;

-- 1.74.0: p_version = la versión que ya tiene el aparato. Si no cambió, devuelve solo la versión (sin datos):
-- así la revisión de cada minuto pesa unos bytes y no la lista entera (cuida la transferencia del plan gratis).
drop function if exists public.rf_lista_leer();
create or replace function public.rf_lista_leer(p_version bigint default null)
returns json language plpgsql security definer set search_path = public as $$
declare l rf_listas;
begin
  perform public.rf_exigir_licencia();
  if auth.uid() is null then raise exception 'RF_CUENTA: sin sesión'; end if;
  select * into l from rf_listas where owner_id = auth.uid();
  if not found then return json_build_object('version', 0, 'datos', null); end if;
  if p_version is not null and p_version = l.version then
    return json_build_object('version', l.version, 'sin_cambios', true);
  end if;
  return json_build_object('version', l.version, 'datos', l.datos, 'actualizado', l.actualizado);
end $$;

-- Guarda solo si nadie guardó una versión más nueva (p_version = la última que vio este aparato).
-- Si hay una más nueva devuelve ok=false con esos datos, y la app las mezcla y vuelve a guardar.
create or replace function public.rf_lista_guardar(p_datos jsonb, p_version bigint)
returns json language plpgsql security definer set search_path = public as $$
declare l rf_listas;
begin
  perform public.rf_exigir_licencia();
  if auth.uid() is null then raise exception 'RF_CUENTA: sin sesión'; end if;
  if octet_length(p_datos::text) > 2000000 then raise exception 'RF_LISTA: la lista es demasiado grande'; end if;
  select * into l from rf_listas where owner_id = auth.uid() for update;
  if found and l.version <> coalesce(p_version, 0) then
    return json_build_object('ok', false, 'version', l.version, 'datos', l.datos);
  end if;
  insert into rf_listas (owner_id, datos, version, actualizado) values (auth.uid(), p_datos, 1, now())
  on conflict (owner_id) do update set datos = excluded.datos, version = rf_listas.version + 1, actualizado = now()
  returning * into l;
  return json_build_object('ok', true, 'version', l.version);
end $$;
revoke all on function public.rf_lista_leer(bigint) from public, anon;
revoke all on function public.rf_lista_guardar(jsonb, bigint) from public, anon;
grant execute on function public.rf_lista_leer(bigint) to authenticated;
grant execute on function public.rf_lista_guardar(jsonb, bigint) to authenticated;

-- =====================================================================
-- Cierres (1.51.0). Agregado 2026-11-02.
-- Al tocar "Vaciar lista" la app guarda aquí todos los paquetes y la ruta del día
-- con la fecha del cierre, y después los borra del celular. Un registro por cierre.
-- Sin políticas: solo se lee y escribe con las funciones rf_cierre_* (exigen licencia).
-- =====================================================================
create table if not exists public.rf_cierres (
  id           bigserial primary key,
  owner_id     uuid not null references auth.users(id) on delete cascade,
  fecha_cierre timestamptz not null default now(),
  paquetes     jsonb not null default '[]'::jsonb,
  ruta         jsonb,
  total        int not null default 0,
  entregados   int not null default 0,
  devueltos    int not null default 0,
  devolver     int not null default 0
);
create index if not exists rf_cierres_owner_fecha on public.rf_cierres (owner_id, fecha_cierre desc);
alter table public.rf_cierres enable row level security;

create or replace function public.rf_cierre_guardar(p_paquetes jsonb, p_ruta jsonb)
returns json language plpgsql security definer set search_path = public as $$
declare c rf_cierres; pk jsonb := coalesce(p_paquetes, '[]'::jsonb);
begin
  perform public.rf_exigir_licencia();
  if auth.uid() is null then raise exception 'RF_CUENTA: sin sesión'; end if;
  if jsonb_typeof(pk) <> 'array' then raise exception 'RF_CIERRE: paquetes debe ser una lista'; end if;
  if octet_length(pk::text) + octet_length(coalesce(p_ruta::text, '')) > 3000000 then raise exception 'RF_CIERRE: el cierre es demasiado grande'; end if;
  insert into rf_cierres (owner_id, paquetes, ruta, total, entregados, devueltos, devolver)
  values (auth.uid(), pk, p_ruta, jsonb_array_length(pk),
    (select count(*) from jsonb_array_elements(pk) e where e->>'st' = 'entregado'),
    (select count(*) from jsonb_array_elements(pk) e where e->>'st' = 'devuelto'),
    (select count(*) from jsonb_array_elements(pk) e where (e->>'devolver')::boolean is true))
  returning * into c;
  -- 1.74.0: borra los cierres propios más viejos que rf_ajustes.dias_cierres (si es 0, no borra nada)
  delete from rf_cierres where owner_id = auth.uid()
     and coalesce((select dias_cierres from rf_ajustes where id = 1), 0) > 0
     and fecha_cierre < now() - make_interval(days => (select dias_cierres from rf_ajustes where id = 1));
  return json_build_object('ok', true, 'id', c.id, 'fecha_cierre', c.fecha_cierre);
end $$;

-- Lista los cierres de la cuenta (lo más nuevo primero), sin el detalle, para la pestaña Cierres.
create or replace function public.rf_cierres_listar(p_limite int default 60)
returns json language plpgsql security definer set search_path = public as $$
begin
  perform public.rf_exigir_licencia();
  if auth.uid() is null then raise exception 'RF_CUENTA: sin sesión'; end if;
  return coalesce((select json_agg(x order by x.fecha_cierre desc) from (
    select id, fecha_cierre, total, entregados, devueltos, devolver from rf_cierres
    where owner_id = auth.uid() order by fecha_cierre desc limit least(greatest(coalesce(p_limite, 60), 1), 500)) x), '[]'::json);
end $$;

-- Detalle de un cierre (paquetes y ruta) de la misma cuenta.
create or replace function public.rf_cierre_leer(p_id bigint)
returns json language plpgsql security definer set search_path = public as $$
declare c rf_cierres;
begin
  perform public.rf_exigir_licencia();
  if auth.uid() is null then raise exception 'RF_CUENTA: sin sesión'; end if;
  select * into c from rf_cierres where id = p_id and owner_id = auth.uid();
  if not found then return null; end if;
  return json_build_object('id', c.id, 'fecha_cierre', c.fecha_cierre, 'paquetes', c.paquetes, 'ruta', c.ruta);
end $$;
revoke all on function public.rf_cierre_guardar(jsonb, jsonb) from public, anon;
revoke all on function public.rf_cierres_listar(int) from public, anon;
revoke all on function public.rf_cierre_leer(bigint) from public, anon;
grant execute on function public.rf_cierre_guardar(jsonb, jsonb) to authenticated;
grant execute on function public.rf_cierres_listar(int) to authenticated;
grant execute on function public.rf_cierre_leer(bigint) to authenticated;

-- Carpeta privada para las fotos. La app solo puede SUBIR; verlas se hace desde el panel de Supabase.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('evidencias', 'evidencias', false, 2097152, array['image/jpeg'])
on conflict (id) do nothing;

drop policy if exists "rutafacil subir evidencias" on storage.objects;
create policy "rutafacil subir evidencias" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'evidencias' and auth.uid() is not null and public.rf_licencia_ok());  -- 1.74.0: solo con cuenta

-- El administrador puede ver y borrar fotos viejas desde admin.html (para no pasarse del plan gratis).
drop policy if exists "rutafacil admin ve evidencias" on storage.objects;
create policy "rutafacil admin ve evidencias" on storage.objects
  for select to authenticated
  using (bucket_id = 'evidencias' and public.rf_es_admin());
drop policy if exists "rutafacil admin borra evidencias" on storage.objects;
create policy "rutafacil admin borra evidencias" on storage.objects
  for delete to authenticated
  using (bucket_id = 'evidencias' and public.rf_es_admin());

-- =====================================================================
-- 20 mensajeros (1.74.0). Agregado 2026-11-03.
-- Plan gratis de Supabase: 500 MB de base, 1 GB de fotos, 5 GB de transferencia al mes.
-- =====================================================================

-- Cada mensajero puede borrar SOLO sus propias fotos y SOLO si ya pasaron los días de
-- rf_ajustes.dias_fotos (la app lo hace sola una vez al día). Nadie ve fotos de otra cuenta.
create or replace function public.rf_dias_fotos()
returns int language sql stable security definer set search_path = public as $$
  select coalesce((select dias_fotos from rf_ajustes where id = 1), 0);
$$;
revoke all on function public.rf_dias_fotos() from public, anon;
grant execute on function public.rf_dias_fotos() to authenticated;

-- Supabase Storage pide permiso de ver (select) para poder borrar: cada quien ve solo lo suyo.
drop policy if exists "rutafacil mensajero ve sus evidencias" on storage.objects;
create policy "rutafacil mensajero ve sus evidencias" on storage.objects
  for select to authenticated
  using (bucket_id = 'evidencias' and owner_id = auth.uid()::text);
drop policy if exists "rutafacil mensajero borra sus evidencias viejas" on storage.objects;
create policy "rutafacil mensajero borra sus evidencias viejas" on storage.objects
  for delete to authenticated
  using (bucket_id = 'evidencias' and owner_id = auth.uid()::text
         and public.rf_dias_fotos() > 0
         and created_at < now() - make_interval(days => public.rf_dias_fotos()));

-- Nombres de las fotos propias que ya se pueden borrar (máximo 500 por vez).
create or replace function public.rf_evidencias_viejas()
returns json language plpgsql stable security definer set search_path = public, storage as $$
declare d int := coalesce((select dias_fotos from rf_ajustes where id = 1), 0);
begin
  perform public.rf_exigir_licencia();
  if auth.uid() is null then raise exception 'RF_CUENTA: sin sesión'; end if;
  if d <= 0 then return '[]'::json; end if;
  return coalesce((select json_agg(name) from (
    select o.name from storage.objects o
     where o.bucket_id = 'evidencias' and o.owner_id = auth.uid()::text
       and o.created_at < now() - make_interval(days => d)
     order by o.created_at limit 500) x), '[]'::json);
end $$;
revoke all on function public.rf_evidencias_viejas() from public, anon;
grant execute on function public.rf_evidencias_viejas() to authenticated;

-- Panel: cómo se cambia el modo de las fotos y los días en la nube.
create or replace function public.rf_admin_fotos(p_modo text, p_dias int)
returns json language plpgsql security definer set search_path = public as $$
declare a rf_ajustes;
begin
  perform public.rf_admin_check();
  update rf_ajustes set
    fotos_nube = case when p_modo in ('ninguna','una','todas') then p_modo else fotos_nube end,
    dias_fotos = case when p_dias is null then dias_fotos else least(greatest(p_dias,0),365) end
   where id = 1 returning * into a;
  return json_build_object('fotos_nube', a.fotos_nube, 'dias_fotos', a.dias_fotos);
end $$;
revoke all on function public.rf_admin_fotos(text,int) from public, anon;
grant execute on function public.rf_admin_fotos(text,int) to authenticated;

-- Panel: cuánto se está usando del plan gratis, en total y por cuenta.
create or replace function public.rf_admin_uso()
returns json language plpgsql stable security definer set search_path = public, storage as $$
begin
  perform public.rf_admin_check();
  return json_build_object(
    'base_bytes', pg_database_size(current_database()),
    'fotos_bytes', (select coalesce(sum((metadata->>'size')::bigint),0) from storage.objects where bucket_id = 'evidencias'),
    'fotos', (select count(*) from storage.objects where bucket_id = 'evidencias'),
    'fotos_nube', (select fotos_nube from rf_ajustes where id = 1),
    'dias_fotos', (select dias_fotos from rf_ajustes where id = 1),
    'dias_cierres', (select dias_cierres from rf_ajustes where id = 1),
    'cierres_bytes', pg_total_relation_size('public.rf_cierres'),
    'cuentas', coalesce((select json_agg(x order by x.fotos_bytes desc) from (
      select p.nombre, p.telefono, p.estado, p.ultimo_acceso,
        (select coalesce(sum((o.metadata->>'size')::bigint),0) from storage.objects o
          where o.bucket_id = 'evidencias' and o.owner_id = p.id::text) as fotos_bytes,
        (select coalesce(octet_length(l.datos::text),0) from rf_listas l where l.owner_id = p.id) as lista_bytes,
        (select count(*) from rf_cierres c where c.owner_id = p.id) as cierres,
        (select count(*) from entregas e where e.owner_id = p.id and e.entregado_en > now() - interval '30 days') as entregas_30d
      from rf_perfiles p) x), '[]'::json));
end $$;
revoke all on function public.rf_admin_uso() from public, anon;
grant execute on function public.rf_admin_uso() to authenticated;

-- Índices para que 20 cuentas no hagan lentas las búsquedas por dueño.
create index if not exists respuestas_owner on public.respuestas (owner_id);
create index if not exists entregas_owner_fecha on public.entregas (owner_id, entregado_en desc);

-- =====================================================================
-- Código de recuperación (1.74.0). Agregado 2026-11-03.
-- Cada cuenta puede tener un código de 12 letras (se guarda solo cifrado). Con el número + el código,
-- el mensajero pone un PIN nuevo y, si cambió de celular, la cuenta pasa al celular nuevo sin esperar
-- al administrador (el anterior se cierra). El código se usa una vez: al usarlo sale uno nuevo.
-- Contra adivinanzas: 5 intentos fallidos bloquean 30 minutos ese número.
-- No llama rf_exigir_licencia(): es manejo de la cuenta (como rf_mi_cuenta), no datos del repartidor;
-- tiene que funcionar aunque la cuenta esté vencida.
-- =====================================================================
alter table public.rf_perfiles add column if not exists rec_hash      text;
alter table public.rf_perfiles add column if not exists rec_creado    timestamptz;
alter table public.rf_perfiles add column if not exists rec_intentos  int not null default 0;
alter table public.rf_perfiles add column if not exists rec_bloqueo   timestamptz;

create or replace function public.rf_codigo_generar(p_id uuid)
returns text language plpgsql volatile security definer set search_path = public, extensions as $$
declare
  abc text := 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';  -- sin 0/O, 1/I/L
  b bytea := extensions.gen_random_bytes(12);
  c text := '';
begin
  for i in 0..11 loop c := c || substr(abc, (get_byte(b, i) % length(abc)) + 1, 1); end loop;
  update rf_perfiles set rec_hash = extensions.crypt(c, extensions.gen_salt('bf')), rec_creado = now(),
         rec_intentos = 0, rec_bloqueo = null where id = p_id;
  return substr(c,1,4) || '-' || substr(c,5,4) || '-' || substr(c,9,4);
end $$;

-- La app lo pide al crear la cuenta o desde el pie (Código de recuperación). Solo desde el teléfono aprobado.
create or replace function public.rf_codigo_nuevo()
returns json language plpgsql security definer set search_path = public as $$
declare p rf_perfiles;
begin
  if auth.uid() is null then raise exception 'RF_CUENTA: sin sesión'; end if;
  select * into p from rf_perfiles where id = auth.uid();
  if not found then raise exception 'RF_CUENTA: sin cuenta'; end if;
  if p.rol <> 'admin' and p.sesion_id is distinct from (auth.jwt()->>'session_id') then
    raise exception 'RF_CUENTA: el código solo se saca desde el teléfono aprobado';
  end if;
  insert into rf_eventos (user_id, tipo, detalle) values (p.id, 'codigo_nuevo', '{}');
  return json_build_object('codigo', public.rf_codigo_generar(p.id));
end $$;

-- Sin sesión (la persona no puede entrar). Devuelve el código nuevo; el PIN queda cambiado.
create or replace function public.rf_recuperar(p_telefono text, p_codigo text, p_pin text, p_dispositivo text)
returns json language plpgsql security definer set search_path = public, extensions as $$
declare
  p rf_perfiles;
  t text := right(regexp_replace(coalesce(p_telefono,''),'\D','','g'), 8);
  c text := upper(regexp_replace(coalesce(p_codigo,''),'[^A-Za-z0-9]','','g'));
  d text := nullif(left(coalesce(p_dispositivo,''),64),'');
begin
  if coalesce(p_pin,'') !~ '^\d{6}$' then raise exception 'RF_CUENTA: el PIN debe tener 6 números'; end if;
  select * into p from rf_perfiles where telefono = t;
  if not found or p.rec_hash is null then
    raise exception 'RF_CUENTA: número o código incorrecto';
  end if;
  if p.rec_bloqueo is not null and p.rec_bloqueo > now() then
    raise exception 'RF_CUENTA: demasiados intentos; probá de nuevo en % minutos', ceil(extract(epoch from p.rec_bloqueo - now())/60);
  end if;
  if extensions.crypt(c, p.rec_hash) <> p.rec_hash then
    update rf_perfiles set
           rec_bloqueo  = case when rec_intentos + 1 >= 5 then now() + interval '30 minutes' else rec_bloqueo end,
           rec_intentos = case when rec_intentos + 1 >= 5 then 0 else rec_intentos + 1 end
     where id = p.id;
    insert into rf_eventos (user_id, tipo, detalle) values (p.id, 'codigo_fallido', '{}');
    return json_build_object('ok', false, 'error', 'Número o código incorrecto');
  end if;
  update auth.users set encrypted_password = extensions.crypt(p_pin, extensions.gen_salt('bf')), updated_at = now()
   where id = p.id;
  if d is not null and p.rol <> 'admin' and p.dispositivo is distinct from d then
    update rf_perfiles set dispositivo_anterior = dispositivo, dispositivo = d,
           dispositivo_pendiente = null, pendiente_desde = null, sesion_id = null where id = p.id;
  end if;
  insert into rf_eventos (user_id, tipo, detalle) values (p.id, 'recuperada', json_build_object('telefono_nuevo', d is not null and p.dispositivo is distinct from d)::jsonb);
  return json_build_object('ok', true, 'codigo', public.rf_codigo_generar(p.id));
end $$;

revoke all on function public.rf_codigo_generar(uuid) from public, anon, authenticated;
revoke all on function public.rf_codigo_nuevo() from public, anon;
revoke all on function public.rf_recuperar(text,text,text,text) from public;
grant execute on function public.rf_codigo_nuevo() to authenticated;
grant execute on function public.rf_recuperar(text,text,text,text) to anon, authenticated;

-- Panel: días que se guardan los cierres (0 = siempre). Cada cuenta borra los suyos vencidos al guardar un cierre nuevo.
create or replace function public.rf_admin_cierres(p_dias int)
returns json language plpgsql security definer set search_path = public as $$
declare a rf_ajustes;
begin
  perform public.rf_admin_check();
  update rf_ajustes set dias_cierres = least(greatest(coalesce(p_dias, dias_cierres),0),3650) where id = 1 returning * into a;
  return json_build_object('dias_cierres', a.dias_cierres);
end $$;
revoke all on function public.rf_admin_cierres(int) from public, anon;
grant execute on function public.rf_admin_cierres(int) to authenticated;
