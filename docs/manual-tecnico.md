# Manual técnico · RutaFácil CR

Cómo está montada la app, cómo se publica y cómo se mantiene.

## 1. Arquitectura

```
Celular del repartidor          Celular del cliente      Administrador
┌──────────────────────┐        ┌──────────────────┐     ┌──────────────┐
│ index.html + auth.js │        │ entrega.html     │     │ admin.html   │
│ datos: localStorage  │        │ (formulario)     │     │ + auth.js    │
└──────┬───────────────┘        └────────┬─────────┘     └──────┬───────┘
       │ entrar (número + PIN)           │ enviar_respuesta      │ rf_admin_*
       │ rf_mi_cuenta, leer_respuestas,  │ (sin cuenta)          │
       │ registrar_entrega, fotos        │                       │
       ▼                                 ▼                       ▼
            ┌────────────────────────────────────────────────────┐
            │ Supabase: Auth + Postgres (API REST) + Storage      │
            │ cuentas rf_*, respuestas, entregas, evidencias      │
            └────────────────────────────────────────────────────┘
Hosting de los archivos: GitHub Pages (repo rutafacilcr/rutafacilcr.github.io, rama main)
Servicios externos sin cuenta: wa.me (WhatsApp), Google Maps, Waze
```

- No hay servidor propio. Todo el código corre en el navegador; las reglas de acceso (cuentas, teléfono aprobado, mensualidad) se aplican en Supabase.
- La lista de paquetes vive en `localStorage` del navegador (clave `rutafacil-cr-v1`).
- En Supabase se guardan las respuestas del formulario y las **pruebas de entrega** (tabla `entregas` + fotos en Storage, carpeta `evidencias`).
- **Escanear etiquetas** corre todo en el celular: no manda fotos ni datos a ningún servidor y no tiene costo. Las librerías se bajan solo al usar el escáner.
- Las fotos de evidencia también quedan en el celular (IndexedDB `rutafacil-evidencias`).

## 2. Publicación (GitHub Pages)

- Repositorio: https://github.com/rutafacilcr/rutafacilcr.github.io (organización gratis *rutafacilcr*; antes era victormenav/RutafacilCR)
- Pages: **Settings > Pages > Deploy from a branch > main / (root)**.
- URL pública: https://rutafacilcr.github.io/. Al ser el repo `<organización>.github.io`, la app queda en la raíz del dominio.
- Cada push a `main` dispara el workflow automático *pages-build-deployment* (1 a 2 minutos). Se revisa en la pestaña **Actions**.
- Los celulares pueden tener la versión anterior en caché: GitHub Pages manda el HTML con `Cache-Control: max-age=600` (10 min). No hay service worker. La app compara su versión con la publicada (`checkUpdate()`, al abrir y al volver a la app) y, si cambió, muestra *Actualizar*, que recarga con `?v=<versión>` para saltarse el caché.

### Páginas públicas (1.75.0)

- `conoce.html` y `privacidad.html` son HTML estáticos **sin** `config.js` ni `auth.js`: no consultan Supabase y se ven sin cuenta. Solo cargan la fuente de Google Fonts; los videos (`videos/*.mp4`, 2–3 MB) van con `preload="none"` y solo se bajan al darles Play.
- Las capturas de `img/` (`demo-*.jpg`, `video-*.jpg`) se sacaron con Playwright de la app en modo ejemplo (sin Supabase, la app carga la lista `EXAMPLE` de nombres inventados). **Nunca** poner capturas con datos de clientes reales.
- La política promete borrar una cuenta dada de baja en máximo 30 días. Para hacerlo: borrar el usuario en Supabase **Authentication > Users** (por `on delete cascade` se borran `rf_perfiles`, `rf_pagos`, `rf_eventos`, `rf_listas` y `rf_cierres`) y borrar sus fotos en **Storage > evidencias** y sus filas de `entregas` (columna `owner_id`).
- La política describe lo que trae la 1.74.0 (PR #10): código de recuperación cifrado (bcrypt), 5 intentos y bloqueo de 30 min, cierres guardados 15 días, fotos 30 días en el celular y en la nube solo si el administrador lo activa. Mergear el #10 antes o junto con este.
- Si cambia algún servicio externo (Supabase, OSRM, OpenStreetMap, TomTom, Resend), el número de soporte o el proceso de recuperación, actualizar `privacidad.html` y su fecha.

### Mudanza a la organización (30-oct-2026)

- **Por qué:** el link viejo (`victormenav.github.io/RutafacilCR`) mostraba el nombre del dueño. Un dominio propio (ej. subdominio de infolinkcr.com) se descartó.
- **Qué se hizo:** se creó la organización gratis **rutafacilcr** en GitHub, se transfirió el repo y se renombró a `rutafacilcr.github.io`. Se instaló la app de Claude en la organización y se activó Pages (main / root).
- **Efectos:** el link viejo dejó de funcionar. El navegador guarda los datos por dirección, así que en la dirección nueva la lista del celular arranca vacía y hay que reinstalar el ícono. Las evidencias ya subidas siguen en Supabase (no cambió nada allá). Los links de formulario mandados antes de la mudanza ya no abren.

### Logo e íconos

`entrega.html` no lleva `og:image`, `og:title` ni `<title>` en el HTML (el título de la pestaña se pone con JS), para que WhatsApp no muestre tarjeta de vista previa. Si algún día se pone una imagen, usar un nombre de archivo nuevo, porque WhatsApp guarda en caché la imagen vieja.

`favicon-32.png` y `apple-touch-icon.png` se referencian con `<link>` en `index.html` y `entrega.html`; `icon-192.png`, `icon-512.png` e `icon-maskable-512.png` en `manifest.json` (`theme_color` y `background_color` `#1f2125`). Tras cambiar el ícono, el celular puede guardar el viejo: quitar el acceso directo y volverlo a agregar.

## 3. Supabase

| Dato | Valor |
|---|---|
| Organización | RutaFacilCR (plan Free) |
| Proyecto | RutaFacil |
| Región | West US (Oregon), us-west-2 |
| URL | `https://mdomcfdmqzgtmnvcfzrs.supabase.co` |
| Llave usada por la app | publishable (`sb_publishable_…`), en `config.js` |

### Instalación desde cero

1. Crear proyecto en https://supabase.com. Seguridad recomendada: Data API **activada**, "Automatically expose new tables" **desactivada**, RLS automático **activado**.
2. **SQL Editor** > pegar todo `supabase.sql` > **Run** → "Success. No rows returned". El script se puede volver a correr sin problema.
3. Copiar URL y llave publishable/anon en `config.js` y hacer push.

### Llaves

- **publishable / anon:** pública, va en `config.js`. No da acceso a la tabla, solo permite llamar las dos funciones.
- **secret / service_role** y **contraseña de la base:** nunca van en el repositorio ni se comparten. Las guarda el dueño del proyecto.
- Con llaves `sb_publishable_` la app manda solo el header `apikey`. Con llaves JWT antiguas (`eyJ…`) manda además `Authorization: Bearer`.

### Cuentas y licencias (Fase 1a, versión 1.7.0)

Cada repartidor entra con su número de teléfono + un PIN de 6 números. Por dentro es una cuenta de **Supabase Auth** con correo interno `<8 dígitos>@rutafacilcr.github.io` (nunca se le manda correo) y el PIN como contraseña. Costo: **cero** (plan gratis).

**Puesta en marcha (una sola vez, en este orden):**

1. **SQL Editor** > pegar todo `supabase.sql` > **Run**. Crea `rf_ajustes`, `rf_perfiles`, `rf_pagos`, `rf_eventos` y sus funciones. No borra nada y no corta la versión vieja: mientras *Exigir cuenta activa* esté apagado, todo sigue respondiendo sin cuenta.
2. **Authentication > Sign In / Providers > Email**: dejar **Enable Email provider** encendido, **Confirm email apagado** (si queda encendido, la cuenta se crea pero no puede entrar) y **Allow new users to sign up** encendido. La longitud mínima de contraseña debe ser 6 (es la de fábrica).
3. Publicar la versión 1.7.0 (merge a `main`).
4. Abrir la app, **Crear cuenta** con el número del administrador.
5. **SQL Editor**: `update public.rf_perfiles set rol = 'admin', estado = 'activo' where telefono = '62700666';` (el número de 8 dígitos con que se creó la cuenta).
6. Abrir `https://rutafacilcr.github.io/admin.html` > **Ajustes**: número SINPE (uno o dos, separados por coma; 1.76.1), precio, días de gracia > **Guardar ajustes**.
7. Cuando todos los celulares tengan la 1.7.0 y su cuenta: encender **Exigir cuenta activa**.

8. Avisos de cuentas nuevas (versión 1.10.0, gratis). Las llaves se guardan desde el Panel en la tabla `rf_avisos` (nunca en el repositorio ni de vuelta al navegador). Usa la extensión **pg_net** de Supabase, que `supabase.sql` activa sola.
   - **WhatsApp (CallMeBot):** en el WhatsApp del administrador, agregar el contacto de CallMeBot que indica https://www.callmebot.com/blog/free-api-whatsapp-messages/ y mandarle `I allow callmebot to send me messages`. Contesta con un *apikey*. Solo manda mensajes a ese mismo número (sirve para avisarle al administrador, no a los repartidores).
   - **Correo (Resend):** crear cuenta gratis en https://resend.com **con el mismo correo donde se quieren recibir los avisos** (sin dominio propio, Resend solo deja mandar al correo de la cuenta). **API Keys > Create API Key** (permiso *Sending access*), copiar la llave `re_…`. Plan gratis: 3.000 correos al mes.
   - Panel > **Ajustes > Avisos cuando alguien crea cuenta**: número, llave de CallMeBot, correo, llave de Resend > **Guardar avisos** > **Mandarme una prueba**.
   - Si un aviso falla, la cuenta se crea igual y en *Movimientos recientes* sale **Aviso no enviado**. Detalle de cada envío: SQL `select * from net._http_response order by created desc limit 10;`.
   - Mensaje automático **al repartidor** por WhatsApp: no hay forma gratis (requiere la API de WhatsApp Business de Meta, con costo por mensaje y verificación de empresa). Por eso el Panel deja el mensaje listo para enviar con un toque, y la app del repartidor revisa cada minuto mientras espera y se abre sola.

**Qué protege cada pieza:**

| Pieza | Protege | Dónde |
|---|---|---|
| Número + PIN | Que la app no se use sin cuenta | `auth.js` (pantalla) + Supabase Auth |
| Un teléfono por cuenta | Pasarse el PIN entre compañeros: el segundo celular queda *pendiente* y el administrador decide | `rf_mi_cuenta` guarda el teléfono y la **sesión** aprobada (`sesion_id` = `session_id` del token) |
| Mensualidad y estado | Usarla sin pagar o suspendida | `rf_licencia_ok()`: estado activo + `vence_en` + días de gracia |
| Reglas en el servidor | Saltarse la pantalla de entrada | Con *Exigir cuenta activa*, `leer_respuestas`, `registrar_entrega` y la subida de fotos solo responden a una cuenta al día **desde su sesión aprobada** |
| Panel | Solo el administrador | Funciones `rf_admin_*` revisan `rol = 'admin'` |

**Límites conocidos (para fases siguientes):**

- El código de la app es público (repo público en GitHub Pages gratis). Alguien podría copiar la página y quitar la pantalla de entrada; tendría la lista y la ruta, pero **sin** respuestas del formulario, sin respaldo de evidencias y sin actualizaciones. Lo cierra la Fase 1b: repo privado + pasar la ruta al servidor.
- Sin código por WhatsApp/SMS, el número no se verifica al crear la cuenta. Por eso las cuentas nacen **sin activar** y el administrador decide; la prueba gratis se da a mano.
- Supabase Auth limita intentos de entrada por IP, lo que frena adivinar PIN. Si alguien insiste, se le cambia el PIN desde el panel.
- Si se borran los datos del navegador, el celular cuenta como teléfono nuevo y hay que aprobarlo.

**Consultas útiles:**

```sql
-- Confirmar una cuenta creada mientras "Confirm email" estaba encendido
update auth.users set email_confirmed_at = now() where email = '88887777@rutafacilcr.github.io';

-- Cambiar el número de una cuenta (ej. se escribió mal al crearla)
update auth.users set email = '<nuevo>@rutafacilcr.github.io', raw_user_meta_data = raw_user_meta_data || '{"telefono":"<nuevo>"}' where email = '<viejo>@rutafacilcr.github.io';
update auth.identities set identity_data = identity_data || '{"email":"<nuevo>@rutafacilcr.github.io"}' where provider = 'email' and identity_data->>'email' = '<viejo>@rutafacilcr.github.io';
update rf_perfiles set telefono = '<nuevo>' where telefono = '<viejo>';

-- Cuentas y vencimientos
select nombre, telefono, rol, estado, vence_en, ultimo_acceso, dispositivo_pendiente is not null as pide_cambio
from rf_perfiles order by creado_en desc;

-- Pagos del mes
select p.nombre, g.monto, g.dias, g.referencia, g.creado_en
from rf_pagos g join rf_perfiles p on p.id = g.user_id
where g.creado_en >= date_trunc('month', now()) order by g.creado_en desc;

-- Volver a dejar todo abierto (emergencia)
update rf_ajustes set exigir_cuenta = false where id = 1;
```

### Prueba de entrega (Storage)

- `supabase.sql` crea la tabla `entregas`, la función `registrar_entrega` y el bucket **privado** `evidencias` (solo JPEG, máx. 2 MB por foto). Desde la firma de entrega hay columna `recibe` y `registrar_entrega` acepta `p_recibe`: **volver a correr `supabase.sql`** (si no, la app reintenta sin el nombre y la firma igual se guarda como foto).
- La app solo puede **subir** fotos (política `rutafacil subir evidencias`; desde la 1.74.0 siempre con sesión, y con *Exigir cuenta activa* solo desde una cuenta al día). Cada cuenta ve y borra solo sus propias fotos vencidas (1.74.0, ver *20 mensajeros*). El administrador puede listarlas y borrarlas (políticas `rutafacil admin ve/borra evidencias`); verlas o descargarlas se hace desde el panel de Supabase: **Storage > evidencias**. Las fotos se guardan como `AAAA-MM-DD/<guia>_<id>_<n>.jpg`.
- **Espacio:** cada foto pesa ~100–150 KB (1024 px, JPEG 65 %), unos 0,3–0,45 MB por entrega con 3 fotos.
  - Supabase gratis: **1 GB de Storage** → unas **2.200–3.300 entregas**. Con 30 entregas por día, unos 2,5 a 3,5 meses. La tabla `entregas` ocupa menos de 1 KB por entrega: los 500 MB de base de datos no son problema.
  - Celular: las fotos respaldadas se borran del celular a los **7 días** (`LOCAL_DIAS`). Queda el registro (fecha, GPS, cantidad de fotos) y las fotos siguen en Supabase.
  - Supabase avisa por correo al acercarse al límite. Opciones: descargar y borrar fotos viejas (ver *Consultas útiles*) o pasar a **Pro** (25 USD/mes, 100 GB).
  - **Liberar espacio desde el panel de RutaFácil:** `admin.html` > *Fotos de entrega* > **Calcular espacio usado** y **Borrar** las de más de N días (mínimo 7). Borra los archivos con la API de Storage; el registro en `entregas` queda.
  - **Liberar espacio a mano:** Supabase > **Storage** > **evidencias** > abrir la carpeta de un día viejo > seleccionar las fotos > **Download** (guardarlas en la PC) > **Delete**. Las carpetas se llaman por fecha (`AAAA-MM-DD`), así que se borran las más viejas primero. El registro en la tabla `entregas` se puede dejar: casi no ocupa.
  - En iPhone, si la app se usa desde Safari y no desde el ícono, Safari puede borrar los datos de la página tras ~7 días sin abrirla. Por eso Supabase es el respaldo oficial.

### Ordenar desde aquí (1.20.0) y orden automático (1.20.1)

WhatsApp en Paquetes (1.32.0): link `wa.me/<número>`, sin texto ni servicios extra.

Corregir etiqueta (1.31.0): usa el mismo escáner gratis (código de barras + OCR en el celular). Solo cambia los campos del paquete en `S.pk`.

Orden de Paquetes (1.30.0): solo cambia cómo se muestra la lista; el orden guardado en `S.pk` y en la nube no cambia.

Devuelto (1.29.0): nuevo valor `st='devuelto'` en los paquetes (con `stAntes` y `devAt`); viaja en `S.pk` por `rf_listas`, sin cambios en `supabase.sql`.

Guías con hora (1.73.3): solo el PDF. Cierres sin "Próximamente" (1.73.2): solo marcado. Ruta sin tachado (1.73.1): solo CSS. Mensajes 4 y 5 (1.73.0): los textos `comp` y `ext` viajan dentro de la lista en `rf_lista_guardar` como los otros mensajes; no hay SQL nuevo. Guías por fecha de recibido (1.72.3, 1.72.2; en la 1.72.3 hay un arreglo único `fixIng1031()` solo para la cuenta 62700666 que deja en 31/10/2026 la fecha de recibido de los paquetes ingresados del 31/10 al 03/11; corre en el celular y se sincroniza como siempre): solo cambia el PDF. Guías con dirección (1.72.1): solo cambia el PDF. Ruta fija al iniciar (1.72.0): el puesto de cada parada (`ent.stops[].o`) viaja dentro de la lista como siempre; no hay SQL nuevo y no consulta OSRM mientras la jornada está en curso. Regresar en naranja y a la derecha (1.70.6 a 1.70.9) y En la ruta junto a la ubicación (1.70.8): solo marcado y CSS. Reporte de guías (1.71.0): se arma en el celular con los mismos datos (lista actual y `rf_cierre_leer`); no hay tablas ni funciones nuevas. Ícono de código de barras (1.70.5): solo marcado. Guía y teléfono con etiqueta (1.70.2 a 1.70.4): solo texto. Tráfico en vivo (1.70.0): TomTom Routing API, plan gratis (2.500 consultas al día, sin tarjeta; al pasarse responde 403 y la app vuelve al estimado sin tráfico, no cobra). La clave **no** va en el repositorio ni en `config.js`: cada repartidor la pega en la app y viaja dentro de su lista en Supabase (`ttKey`). Para cambiarla en la base, desde la app tocando 🚦 cuando diga "revisar clave". Eliminar (1.69.9): solo texto. Sin paradas repetidas (1.69.7): la limpieza se hace en el celular sobre `ent` y se sincroniza como siempre. Regresar a Ruta (1.69.4): solo texto. Mensajes en orden de ruta (1.69.3): solo pantalla. Ruta acomodada (1.67.6 y 1.67.7): solo marcado y CSS. Reportes por fecha (1.57.0): la app lee los cierres con `rf_cierres_listar` y `rf_cierre_leer` (en `supabase.sql`, exigen licencia); si esas funciones no están creadas en Supabase, la lista muestra solo las fechas de la lista actual. Vehículo en el mensaje (1.56.4): solo texto del link `wa.me`. Hora real de entrega (1.56.3): la hora del toque (`ent.stops[].at`) y la del paquete (`pk[].entAt`) viajan a Supabase dentro de la lista (`rf_lista_guardar`) y al cierre (`rf_cierre_guardar`); se corrigió que `entAt` tomara la hora de la sincronización. Encabezado en columna (1.56.2): solo el PDF. Reporte por hora (1.56.1): solo cambia el orden del PDF. Vehículo (1.55.0): `veh` se suma a los datos que se sincronizan con `rf_lista_guardar` (dentro del JSON de la lista; no requiere cambios en la base). Reporte con nombre (1.54.2): solo cambia el PDF. Encabezado del reporte (1.54.1): los km y las horas se calculan en el celular con los datos de entrega que ya existen (`entAt`, `entGps`, `pod`, `devAt`, `ent.inicio`); no usa servicios pagados. Reporte PDF (1.54.0): usa jsPDF 2.5.1 y jspdf-autotable 3.8.2 desde cdnjs (gratis), que se cargan al abrir *Cierres*; el PDF se arma en el celular, no consulta Supabase ni guarda nada nuevo. Orden en Paquetes (1.53.2): solo pantalla. Devolver en Paquetes (1.53.1): solo marcado; usa los mismos campos `st`, `devolver` y `ent` que ya se sincronizan. Hold en amarillo (1.48.2, 1.48.3): solo CSS. Coordinar corregido (1.52.3): bandera `coord4`. Contador Sin 📍 (1.52.2): solo texto. Mensajes ordenados (1.52.1, Hold en 1.52.4): solo pantalla. Mensaje Coordinar (1.51.1): `coord` viaja en la nube como siempre; la marca `coord3` evita volver a ponerlo. Mensaje con política (1.48.4, texto nuevo en 1.48.5): texto fijo en `entWaUrl`. Unir por número (1.48.1): solo en el celular. Ruta consistente (1.48.0): `ent.mod` marca el último cambio hecho a mano; al sincronizar, si los dos aparatos cambiaron la ruta, gana el `mod` más nuevo (o la ruta cargada más nueva por `ent.at`) y se suman las entregas de la otra. Ruta sin cambios solos (1.47.2): limpieza única marcada con `ent.limpia147`. Hold (1.47.0; a la izquierda desde 1.47.1): `s.hold` se guarda en la parada dentro de `ent` y se sincroniza como siempre. Lista de la ruta (1.46.0): se arma en el celular, no consulta nada. Coordenadas en grados (1.45.3): se convierten en el celular a decimal; se guarda el texto tal como se pegó. Poner en la ruta (1.45.2): solo cambia la ruta guardada (`ent`), que se sincroniza como siempre. Borde rojo (1.45.1): solo CSS. Buscar en Paquetes (1.45.0): filtra en el celular, no consulta Supabase. Tiempo arriba (1.44.5): solo marcado. Maps y Waze (1.44.4): solo marcado. Galería a la par (1.44.3): solo marcado. Ruta alineada (1.44.2): solo CSS. Mensajes como antes (1.44.1): solo CSS. Botones de Ruta (1.44.0): solo marcado y CSS. WhatsApp en camino (1.43.0): solo arma un link `wa.me` con el texto; no usa la API de WhatsApp ni cuesta nada. Quitar parada (1.42.0): `S.ent.quitadas` (ids de paquete) viaja con la ruta en la nube dentro de `ent`. Número tachado (1.40.0), tarjeta gris (1.40.1) y orden de botones en Paquetes (1.41.0 a 1.41.2): solo CSS y marcado en `index.html`; no cambia datos ni Supabase.

Diagnóstico (1.39.1): `#supDiag` arma el texto en el celular y lo copia al portapapeles; no lo manda a ningún lado. Incluye teléfonos y ubicaciones, así que se comparte solo con soporte. Desde la 1.39.2 se muestra en la hoja `#diagSheet`; Compartir usa la Web Share API del celular (si no existe, abre `wa.me` de soporte con los primeros 3.500 caracteres). Nada se sube a Supabase.

Unión automática (1.39.0): nuevo campo `telsAnt` en los paquetes (teléfonos anteriores); todo se calcula en el celular.

Estado en la ruta (1.38.1): todo se calcula en el celular. Los links cortos de Google no se pueden abrir desde el navegador (CORS) para sacarles las coordenadas.

Número fijo (1.38.0, 1.38.2): además, la clave `nums` ({id: número}) se sincroniza como clave propia de `rf_listas` y sirve de respaldo; campo nuevo `num` en cada paquete de `S.pk`, que se sincroniza en `rf_listas`; no hay cambios en `supabase.sql`.

Unir parada y paquete (1.37.1–1.37.3): nombre, teléfono y ubicación de Paquetes se copian a la ruta; el cálculo es en el celular; la unión manual queda en `S.ent.stops[].pkFijo`. `parseCoord` decodifica el geohash de los links `waze.com/ul/h…`, sin consultar a ningún servidor. Los links cortos de Google (maps.app.goo.gl) siguen sin poder leerse desde el navegador.

Ubicación a Ruta (1.37.0): la ubicación del paquete (`ubic`) manda sobre la de la parada; solo cambia `S.ent` (sincronizado en `rf_listas`).

Pestañas (1.36.0): se quitó el botón `#tab-ruta`. La sección `#v-ruta` y su código siguen en el archivo pero ya no se pueden abrir, y `S.vel`, `S.min` y `S.route` se conservan porque otras partes los usan. La pestaña `data-tab="entrega"` muestra el texto "Ruta".

Orden en Entrega (1.35.0): solo cambia cómo se muestra la lista; el orden guardado de `S.ent.stops` no cambia.

Teléfono a Entrega (1.34.0, 1.35.1). Al abrir la app también se igualan los teléfonos con los de Paquetes. solo cambia `S.ent` en el celular y la nube (`rf_listas`).

Hora y GPS del Entregado (1.33.0): se guardan en la parada (`S.ent.stops[].at/gps`) y en el paquete (`entAt`, `entGps`), dentro de `rf_listas` (no en el bucket de evidencias). La evidencia con fotos sigue en "evidencias".

Entregado en Paquetes (1.28.0, 1.29.1): `entSyncPk()` se corre al abrir la app y en cada `render()`. cambia `st` del paquete en `S.pk`, que se sincroniza con `rf_listas` como siempre. No hay cambios en `supabase.sql`.

Pie con derechos (1.27.1): texto fijo en `index.html` y `admin.html`.

Lupa (1.27.0): búsqueda local en el celular, no consulta a ningún servidor.

Orden de botones (1.26.4): solo cambia el diseño, no hay cambios de datos.

Botón Co-out (1.26.0): abre el link `shortcuts://run-shortcut?name=Co-out`. iOS no deja abrir una app cualquiera desde una página web si la app no publica su propio link, así que se pasa por un atajo de la app Atajos que el usuario crea una vez. No funciona en Android. Desde la 1.26.3 sale en todas las paradas; desde la 1.26.2 la etiqueta se toma del paquete en esos casos.

Paradas sin ubicación (1.25.0): `entCargar` guarda el texto de la columna ubicación en `s.ub`; no cambia nada en Supabase (va dentro de `S.ent`).

Total de la ruta (1.24.0; la 1.24.1 se revirtió en la 1.24.2). La hora de inicio es la hora actual del celular (se refresca cada minuto) y la de fin es inicio + total. una consulta a OSRM `route/v1/driving` (`overview=false`) con tu punto y las paradas pendientes en orden. Se repite solo si cambian las pendientes o te movés más de 300 m, con un mínimo de 10 s entre consultas. Si falla, usa línea recta ×1,35.

Orden por calle (1.22.0): `entOrdenar` pide a OSRM la matriz completa de tiempos (`table/v1/driving` con todas las paradas pendientes más tu punto, máximo 100 puntos y 8 s de espera). Si falla, ordena con línea recta.

Botones de la parada (1.22.1, 1.23.0): **📸 Evidencia** (antes "Entregar") abre la prueba de entrega. **✓ Entregado** marca la parada (`done` dentro de `S.ent`, se sincroniza con la nube) y **↩ Deshacer** la desmarca.

Tiempo a cada parada (1.21.0, 1.21.1): el celular consulta la tabla del servidor público de OSRM (`router.project-osrm.org/table/v1/driving`, gratis, sin llave, uso moderado). Hace una sola consulta con todas las paradas pendientes y la repite solo si te movés más de 150 m o pasan 2 minutos, con un mínimo de 8 s entre consultas. Si OSRM no responde, usa línea recta ×1,35. Si ese servidor deja de servir, la alternativa es montar OSRM propio; mientras tanto el respaldo sigue funcionando.

Desde la 1.20.1, la primera lectura de GPS con precisión menor a 500 m (por carga de página o al cargar un archivo) reordena sola si `S.ent.inicio` falta o está a más de 800 m. Distancias en línea recta ×1,35, sin tráfico.

Solo `index.html`. Usa el GPS del navegador (pide permiso la primera vez; en iPhone hay que permitir la ubicación a Safari) y la misma optimización de *Ruta*, todo en el celular, gratis.

### Ruta que no subía (1.19.5)

Solo `index.html`. Si la nube quedaba en la misma versión que el aparato pero sin la ruta (la había pisado una versión vieja), nadie la volvía a subir. Ahora se detecta y se sube sola.

### Diagnóstico de la nube (1.19.2)

Tocar *☁️* en el pie sincroniza y muestra un aviso con la versión de la lista en la nube, cuántos paquetes tiene y qué ruta. Si en el celular y la PC sale la misma versión, están iguales.

### Sincronización por partes (1.19.1)

Solo `index.html`. Arregla que un aparato con cambios pendientes (o con una versión vieja) pisara datos nuevos del otro, como la ruta de *Entrega*.

### Pestaña Entrega (1.19.0)

Solo `index.html`. Usa SheetJS y Leaflet (cdnjs) con mapas de OpenStreetMap, gratis. La ruta cargada viaja en la lista de la nube (`rf_listas.datos.ent`); no hace falta correr SQL nuevo.

### Aviso de cédula (1.18.3 y 1.18.4)

`entrega.html` (pantalla final del formulario) y los mensajes *Coordinar* (1.19.3) y *Voy en camino* de `index.html`. No toca Supabase.

### Lista en la nube (1.18.0)

**Hay que volver a correr `supabase.sql`** (SQL Editor > New query > pegar todo > Run). Crea la tabla `rf_listas` (un registro JSON por cuenta, con RLS y sin políticas) y las funciones `rf_lista_leer()` y `rf_lista_guardar(p_datos, p_version)`, que llaman `rf_exigir_licencia()` y solo responden a una sesión con cuenta. Mientras no se corra, la app sigue funcionando solo en el aparato y el pie dice *☁️ sin activar: falta correr supabase.sql*.

- Se guardan los paquetes y los textos de los mensajes, no las fotos de evidencia (siguen en el celular y en el bucket `evidencias`).
- Con *Exigir cuenta activa*, un repartidor solo puede usar un teléfono a la vez; el administrador puede entrar desde varios aparatos.
- Tamaño máximo por cuenta: 2 MB de JSON (unos miles de paquetes). Cabe de sobra en el plan gratis.

### Excel del día (1.17.0)

Solo `index.html`. Usa SheetJS 0.18.5, que ya se carga desde cdnjs para importar Excel; el archivo se arma en el celular. En iPhone (1.17.1) sale por el menú de compartir; una página web no puede escribir directo en una carpeta del iPhone, el usuario elige *Guardar en Archivos*.

### Nombres con tildes (1.16.2)

Solo `index.html`. Al abrir la app se corrigen solos los nombres ya guardados en el celular.

### Contactos del día (1.16.0)

Solo `index.html`; el `.vcf` se arma en el celular, no pasa por Supabase ni por ningún servidor. En iPhone (1.16.1) se entrega con el menú de compartir (Web Share con archivos, iOS 15+), porque Safari solo importa el primer contacto de un `.vcf`.

### Confirmar entrega (1.15.4)

Solo `index.html`. Una entrega sin GPS llega a `registrar_entrega` con `p_lat`, `p_lng` y `p_precision` en `null` (las columnas lo permiten); no hay que volver a correr `supabase.sql`.

### Mensajes reordenada (1.15.0)

Solo `index.html`. Las plantillas quedan guardadas igual en el celular (`S.coord`, `S.form`, `S.camino`); solo cambian de lugar.

### Nombre editable en Mensajes (1.14.1)

Solo `index.html`. El nombre de la cuenta (`rf_perfiles.nombre`) se usa de fábrica; el repartidor lo puede cambiar en su celular sin tocar la cuenta.

### Selector de mensajes (1.14.0)

Solo cambia `index.html`; no hay que tocar Supabase ni `config.js`. Si `config.js` no tiene Supabase, el selector muestra solo *Coordinar* y *Voy en camino*.

### Firma (1.13.0)

La firma se sube al bucket `evidencias` como `AAAA-MM-DD/<guia>_<id>_firma.jpg` (unos 5–20 KB) y va al final de `fotos` en la tabla `entregas`. El nombre de quien recibe se guarda en `entregas.recibe` (con "(no firmó)" si no quiso firmar). **Hay que volver a correr `supabase.sql`** para que exista `p_recibe`; mientras tanto la app reintenta sin ese dato y la evidencia igual se respalda.

### 20 mensajeros (1.74.0)

**Después de publicar, volver a correr `supabase.sql` completo** (se puede correr de nuevo sin perder datos). Mientras no se corra, la app nueva sigue funcionando con las funciones viejas (reintenta sin los parámetros nuevos), pero sin el aislamiento nuevo ni la limpieza de fotos.

Aislamiento por cuenta (nada compartido entre mensajeros):

| Dato | Dónde | Cómo se separa |
|---|---|---|
| Lista, ruta, plantillas, clave de TomTom | `rf_listas` | una fila por `owner_id`; solo `rf_lista_leer/guardar` con `auth.uid()` |
| Cierres | `rf_cierres` | `owner_id`; `rf_cierre_*` filtran por `auth.uid()` |
| Respuestas del formulario | `respuestas` | **nuevo:** `leer_respuestas` amarra cada respuesta a la primera cuenta que la lee (`owner_id`) y después solo esa cuenta la ve; exige sesión aunque *Exigir cuenta activa* esté apagado |
| Entregas | `entregas` | `owner_id = auth.uid()`; **nuevo:** `registrar_entrega` exige sesión y no deja que otra cuenta cambie una entrega ajena |
| Fotos | Storage `evidencias` | **nuevo:** solo cuentas con sesión suben (antes también `anon`); cada cuenta ve y borra **solo** sus fotos (`owner_id`) y solo las vencidas; el administrador ve y borra todas |
| Datos en el celular | `localStorage` | **nuevo:** la lista lleva `owner` (número de la cuenta). Si entra otra cuenta, se aparta en `rutafacil-cr-v1@<número>` (solo si tenía cambios sin subir) y se abre la de la nueva |

Todas las tablas tienen RLS encendido y **ninguna política** de lectura directa: todo pasa por funciones `security definer` que filtran por `auth.uid()` y llaman `rf_exigir_licencia()`. Para el futuro "admin ve a todos los mensajeros", basta con funciones `rf_admin_*` nuevas que llamen `rf_admin_check()` (como `rf_admin_uso`); no hay que cambiar las tablas.

Funciones y ajustes nuevos: `rf_admin_cierres(p_dias)` y columna `rf_ajustes.dias_cierres` (15 de fábrica; `rf_cierre_guardar` borra los cierres propios vencidos), `fotos_nube` acepta `ninguna` (de fábrica), `leer_respuestas` acepta hasta 1000 tokens (antes 300), `rf_lista_leer(p_version)` (si la versión no cambió responde `{version, sin_cambios:true}` sin datos), `leer_respuestas(p_tokens, p_desde)` (solo lo cambiado después de `p_desde`), `rf_evidencias_viejas()`, `rf_dias_fotos()`, `rf_admin_fotos(p_modo, p_dias)`, `rf_admin_uso()`, columnas `rf_ajustes.fotos_nube` (`ninguna`/`una`/`todas`, de fábrica `ninguna`) y `rf_ajustes.dias_fotos` (21), e índices `respuestas_owner` y `entregas_owner_fecha`. `rf_mi_cuenta` devuelve también `fotos_nube` y `dias_fotos`.

Recomendado al pasar a varios mensajeros: en el Panel encender **Exigir cuenta activa**.

**Avisos (1.75.2):** ningún `confirm()`, `alert()` ni `prompt()` del navegador en la app ni en el Panel; todo usa `RF_DIALOGO` de `auth.js`. Solo HTML/CSS/JS, no cambia nada en Supabase.

**Número alterno del administrador (1.76.0):** columna `rf_perfiles.telefono_alterno` (única). `rf_numero_entrar(p_telefono)` (anon) devuelve el número principal si el que se escribió es el alterno de un admin; si no, el mismo número. `auth.js` la llama antes de entrar, al crear cuenta (bloquea crear cuenta con un número alterno) y después de `rf_recuperar`, que también acepta el alterno. `rf_admin_alterno(p_telefono)` (solo admin; `''` lo borra) rechaza un número que ya tenga su propia cuenta, que sea alterno de otra o que sea el principal; deja el evento `alterno`. No es una segunda cuenta: Supabase Auth sigue teniendo un solo usuario (`<principal>@rutafacilcr.github.io`). Si el número ya tenía cuenta propia, borrarla antes en SQL Editor: `delete from auth.users where email = '<8 dígitos>@rutafacilcr.github.io';` (borra su perfil y sus datos en cascada). Pasos para activarlo: correr `supabase.sql`, Panel > *Tu número alterno* > *Guardar número*.

**Código de recuperación** (1.75.1: los avisos de *Código de recuperación* y *Salir* son HTML propio de `auth.js`, no `confirm()`; no cambia nada en Supabase): columnas `rf_perfiles.rec_hash` (bcrypt), `rec_creado`, `rec_intentos`, `rec_bloqueo`; funciones `rf_codigo_nuevo()` (solo desde la sesión aprobada) y `rf_recuperar(p_telefono, p_codigo, p_pin, p_dispositivo)` (sin sesión: cambia el PIN, pasa la cuenta al aparato nuevo y devuelve un código nuevo; 5 fallos bloquean 30 min; un fallo devuelve `ok:false` para que el contador quede guardado). Eventos `codigo_nuevo`, `codigo_fallido`, `recuperada`. No llaman `rf_exigir_licencia()` porque son manejo de cuenta, no datos del repartidor.

**Intentos de PIN:** el PIN lo revisa Supabase Auth, que en el plan gratis no permite bloquear por cuenta. Lo que protege: (1) **Authentication > Rate Limits** de Supabase limita los intentos por IP (recomendado: *sign-ups and sign-ins* en 10 por 5 minutos); (2) aunque alguien adivine el PIN, entra desde un aparato no aprobado y queda *esperando aprobación*: con **Exigir cuenta activa** encendido no ve ningún dato. Por eso, antes de sumar mensajeros, **encender Exigir cuenta activa** es obligatorio.

**Sesiones:** el token de Supabase dura 1 hora y se renueva solo; cambiar de aparato (aprobado o con código) deja sin datos a la sesión vieja (`sesion_id`). El Panel (`admin.html`) vuelve a pedir el PIN si pasaron 12 horas (`ADMIN_HORAS` en `auth.js`, guardado en `localStorage['rutafacil-pin-at']`). Cerrar sesiones por inactividad en el servidor es de Supabase Pro.

**Exportaciones** (Excel, PDF, contactos .vcf): se arman en el celular con los datos de la cuenta abierta; no pasan por ningún servidor ni pueden traer datos de otra cuenta. Quien tenga el celular desbloqueado las puede bajar: por eso la cuenta va atada a un solo aparato y *Salir* aparta los datos.

**Cuentas de los planes gratis** (supuesto: 70 entregas por mensajero al día, el peor caso; con 35 todo dura el doble). Con **150 mensajeros** y fotos en el celular (de fábrica) todo cabe gratis: base ~170 MB con cierres de 15 días, transferencia muy por debajo de 5 GB, 150 usuarios de 50.000. Con fotos en la nube, 150 mensajeros necesitan Supabase Pro (25 USD/mes). Detalle con 20 mensajeros:

| Servicio | Límite gratis | Uso estimado con 20 | ¿Alcanza? |
|---|---|---|---|
| Supabase base | 500 MB | listas ~2–4 MB; cierres ~50–100 KB por día y mensajero → ~30–60 MB al mes | Sí, unos 8–15 meses; después borrar cierres viejos |
| Supabase fotos, 3 fotos (~0,4 MB por entrega) | 1 GB | ~560 MB al día | **No**: se llena en menos de 2 días |
| Supabase fotos, *1 foto chica* (~50 KB por entrega) | 1 GB | ~70 MB al día | Sí con 14 días en la nube (21 si son ~45 entregas diarias) |
| Supabase transferencia | 5 GB al mes | antes: la lista entera cada minuto (~100 KB × 600 revisiones × 20 ≈ 36 GB/mes); ahora unos bytes si no cambió | Sí |
| Supabase usuarios (Auth) | 50.000 activos al mes | 20 | Sí |
| Supabase pausa | se pausa tras 7 días sin uso | se usa a diario | Sí |
| TomTom tráfico | 2.500 consultas al día **por clave** | ~300 por mensajero al día | Sí, **si cada mensajero pega su propia clave** (gratis, sin tarjeta). Una sola clave para todos se pasa a la hora del almuerzo |
| OSRM (rutas sin tráfico) | servidor de demostración, sin cuota fija | 1 consulta cada ~2 min por mensajero | Sí, pero sin garantía; si falla, la app usa la estimación en línea recta |
| Resend (correo a Victor) | 3.000 al mes, 100 al día | 1 por cuenta nueva o cambio de teléfono | Sí |

Si más adelante hace falta guardar las 3 fotos por meses, la única opción es pagar (Supabase Pro, 25 USD al mes, 100 GB).

### Voy en camino (1.78.0)

Solo JavaScript y HTML en `index.html` (aviso `#wzSheet`); no toca Supabase, `auth.js` ni `supabase.sql`. No guarda nada nuevo ni en el celular ni en la nube. El mensaje de WhatsApp es el mismo de antes.

### Pestañas más rápidas (1.77.0)

Solo JavaScript en `index.html`; no toca Supabase, `auth.js`, `supabase.sql` ni el diseño. No hace falta correr nada en la base. Al abrir Ruta la app sigue pidiendo la lista a la nube (`rf_lista_leer`) como antes, pero ya no vuelve a pintar la ruta si la nube no trajo cambios.

Medición (Playwright, Chromium con CPU 6× más lenta para imitar un celular sencillo, 90 paquetes y 90 paradas): tiempo hasta que se ve el cambio de pestaña. Mensajes con lista pendiente: 14,4 s → 0,03 s; Ruta: ~0,5 s → ~0,13 s; Paquetes y Cierres ya estaban bien (~0,03 s). Un celular real va unas 6 veces más rápido que esa prueba.

### Contraste (1.76.2)

Solo CSS en `index.html` (bloque `/* 1.76.2 · Contraste */` al final del `<style>`); no toca Supabase, `auth.js` ni la lógica. Se revisó con axe-core (el mismo motor de la auditoría de accesibilidad de Lighthouse), regla `color-contrast`, en tema claro y oscuro a 390 px. Quedan avisos conocidos que son decisión de marca: texto blanco sobre el naranja `#f26b1d` de los botones principales (3,0:1), el verde de WhatsApp y el verde de «● Ubicación lista» en claro (4,3:1).

### Límites del plan gratis

500 MB de base de datos y pausa automática del proyecto tras ~1 semana sin uso. Si se pausa, el formulario deja de guardar: entrar al panel y tocar **Restore**. Cada respuesta ocupa menos de 1 KB.

### Consultas útiles (SQL Editor)

```sql
-- Últimas respuestas
select guia, horario, senas, recibe, lat, lng, updated_at
from respuestas order by updated_at desc limit 50;

-- Entregas con evidencia de un día
select guia, cliente, entregado_en, lat, lng, precision_m, fotos
from entregas where entregado_en::date = '2026-10-30' order by entregado_en;

-- Espacio usado por las fotos (MB)
select round(sum((metadata->>'size')::bigint)/1048576.0,1) as mb, count(*) as fotos
from storage.objects where bucket_id = 'evidencias';

-- Borrar respuestas de más de 30 días
delete from respuestas where updated_at < now() - interval '30 days';
```

### Resumen de la 1.53 a la 1.68 (para hosting y Supabase)

- **No hay tablas nuevas.** Todo lo nuevo viaja dentro del JSON de la lista (`rf_lista_guardar`): `veh` (vehículo; si no existe se usa carro), `jor` (jornada: hora y GPS de inicio y fin), `pk[].entAt`, `entGps`, `devAt`, `devolver` y `ent.stops[].at`, `gps`, `hold`, `devolver`. Al vaciar la lista se guarda en `rf_cierres` con `rf_cierre_guardar`.
- **Funciones de la base que usa la app:** `rf_lista_leer`, `rf_lista_guardar`, `rf_cierre_guardar`, `rf_cierres_listar` y `rf_cierre_leer`. Las cinco exigen licencia (`rf_exigir_licencia`). Si `rf_cierres_listar` o `rf_cierre_leer` no están creadas en Supabase, *Cierres* muestra solo la lista actual: corré `supabase.sql` completo, porque se puede correr de nuevo sin borrar datos.
- **Servicios externos gratis:** jsPDF 2.5.1 y jspdf-autotable 3.8.2 desde cdnjs para el PDF, y OSRM público para tiempos y la línea por calles. No hay llaves ni costos.
- **Publicación:** push a `main` y GitHub Pages. En computadora, Ctrl + Shift + R fuerza la versión nueva. Si la app falla, sale un aviso rojo con la versión y la línea, para soporte.
- **PIN olvidado del administrador:** en el SQL Editor, `update auth.users set encrypted_password = extensions.crypt('NUEVO', extensions.gen_salt('bf')), updated_at = now() where email = '<número>@rutafacilcr.github.io';`. El PIN no se puede leer, solo reemplazar.

## 4. Configuración (`config.js`)

```js
window.RF_CONFIG = {
  supabaseUrl: 'https://<proyecto>.supabase.co',
  supabaseAnonKey: '<llave publishable o anon>'
};
```

Opcional: `soporte: '62700666'` cambia el WhatsApp de soporte que muestra la pantalla de entrar (`auth.js`); si falta, usa 62700666.

Si los dos valores están vacíos, la app funciona sin formulario: los mensajes no llevan link y no aparece el panel de respuestas.

## 5. Dependencias externas

| Recurso | Uso | Si falla |
|---|---|---|
| cdnjs `xlsx 0.18.5` | Leer Excel/CSV subido | Se puede pegar la lista. |
| Google Fonts | Tipografías | Usa fuentes del sistema. |
| `wa.me` | Abrir WhatsApp con texto | Botón **Copiar texto**. |
| Google Maps / Waze | Navegación | Se pueden copiar las coordenadas. |
| jsDelivr `@zxing/library 0.21.3` | Leer el código de barras de la etiqueta (solo si el navegador no trae `BarcodeDetector`, como en iPhone) | Se escribe la guía a mano. |
| jsDelivr `tesseract.js 5.1.1` (+ núcleo WASM y datos de idioma `spa`, unos 5 MB la primera vez; luego quedan en IndexedDB del navegador) | Leer el texto de la etiqueta (OCR) | Se llenan los datos a mano. |
| cdnjs `leaflet 1.9.4` + mosaicos de OpenStreetMap | Mapa de *Recorrido de hoy* (se carga solo al abrir *Ruta* con entregas del día) | Botón *Abrir en Google Maps*. Uso bajo, sin llave. |
| OpenStreetMap Nominatim | Buscar un lugar por nombre cuando el link de ubicación no trae coordenadas (botón *Pegar respuesta*) | Pegar las coordenadas o un link con coordenadas. Uso bajo, sin llave. |
| Geolocalización del navegador | Botón "Estoy en mi casa" del formulario | El cliente la manda por WhatsApp o pega un link. Requiere HTTPS (GitHub Pages ya lo da). En iPhone depende de *Ajustes > Privacidad y seguridad > Localización > Sitios web de Safari* y del permiso por sitio en Safari (*aA > Configuración del sitio web > Ubicación*), también dentro del navegador de WhatsApp. |

## 6. Mantenimiento

- **Videos de ayuda:** se suben como MP4 a `videos/` (verticales 720p, idealmente menos de 25 MB cada uno; GitHub rechaza archivos de más de 100 MB) y se listan en `videos.json`: `[{"titulo","url","dur","desc"}]`. `url` puede ser relativa (`videos/01-entrar.mp4`) o un link de YouTube (se muestra embebido). Con la lista vacía, la app dice "Pronto vas a ver aquí los videos". Los seis videos actuales (1.75.1: entrar, paquetes, mensajes, ruta, entregar, cierres; 0:46 a 1:30, unos 17 MB en total) se grabaron con Playwright sobre la app real con datos de ejemplo y la cuenta simulada (no tocan Supabase), voz Piper `es_MX-claude-high` y subtítulos. El guion y los scripts para regrabarlos cuando cambie la app están en la carpeta del proyecto (`rutafacil/video/fuente-v3/`; las copias en 1080p en `rutafacil/video/v3-hd/`). Desde la máquina de grabación no se llega a los mapas (OpenStreetMap, OSRM, TomTom), así que el mapa sale con fondo liso y las distancias en línea recta; para grabarlo con calles hay que permitir esos dominios en el ambiente.
- **WhatsApp de soporte:** constante `SOPORTE_WA` en `index.html` (`50662700666`).
- **Pantalla de espera (1.12.0):** sin cambios en Supabase; la app consulta `rf_mi_cuenta` cada minuto mientras espera activación (1 llamada por minuto por teléfono en espera).
- **Ruta por calles (1.68.0):** usa el servidor público de OSRM (`router.project-osrm.org`, gratis, sin llave, con límite de uso razonable); si no responde, la línea queda recta.
- **Jornada (1.59.0):** `S.jor` se sincroniza en `rf_listas` y se guarda dentro de `ruta.jor` en `rf_cierres`; no hay tabla nueva ni SQL que correr.
- **Cierres (1.51.0):** tabla `rf_cierres` (un registro por cierre: `fecha_cierre`, `paquetes` y `ruta` en JSON, conteos) y funciones `rf_cierre_guardar`, `rf_cierres_listar`, `rf_cierre_leer`, todas con `rf_exigir_licencia()`. Hay que **correr de nuevo `supabase.sql`** en el SQL Editor (no borra nada). Hasta entonces *Vaciar lista* avisa que no pudo guardar y no borra. Consulta: `select owner_id, fecha_cierre, total, entregados from rf_cierres order by fecha_cierre desc;`
- **Botón de soporte (1.49.0):** está en el encabezado de `index.html`; la barra de abajo tiene la pestaña *Cierres* en su lugar.
- **Ícono de soporte (1.8.3):** SVG en línea dentro de `index.html` y `auth.js`; no hay archivo de imagen que subir ni caché extra.

- **Versión:** se muestra al final de la app, chiquita: *RutaFácil CR · versión 1.8.1*. Se usa versionado semántico **mayor.menor.corrección**: *mayor* sube con cambios grandes que obligan a reinstalar o migrar datos, *menor* con funciones nuevas y *corrección* con arreglos o ajustes visuales. Al publicar se cambia el número en `index.html` y `admin.html` (`#appVer`) y se anota en `CHANGELOG.md`. Sirve para confirmar si un celular ya tiene la versión nueva.

- **Cambiar textos o mensajes por defecto:** `index.html`, constantes `DEF_COORD`, `DEF_COORD_F` y `DEF_CAMINO`.
- **Cambiar horarios del formulario:** `entrega.html`, arreglo `SLOTS`.
- **Links viejos** (`f.html?…`) redirigen a `entrega.html`. No borrar `f.html` mientras haya mensajes viejos circulando.
- **Respaldo:** el repositorio es el respaldo del código. La tabla `respuestas` es temporal (se puede limpiar).
- Cada cambio se anota en `CHANGELOG.md` y en el manual que corresponda.

## 7. Plan futuro (no implementado)

- **Fase 1b:** código de verificación por WhatsApp o SMS al crear la cuenta y al cambiar de teléfono (Twilio o API de WhatsApp de Meta; tiene costo por mensaje).
- **Repo privado:** GitHub Team (~4 USD/mes, mantiene `rutafacilcr.github.io`) o Cloudflare Pages (gratis, cambia el link). Con eso se puede ofuscar el código publicado.
- **Ruta e importación en el servidor** (Supabase Edge Functions): que una copia de la página no sirva sin cuenta.
- **Play Store** con TWA o Capacitor cuando haya clientes pagando.
- `respuestas.owner_id` sigue sin usarse: hoy cada respuesta se protege con su token.
