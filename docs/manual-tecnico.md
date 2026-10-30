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
- Los celulares pueden tener la versión anterior en caché. Cerrar y volver a abrir la app la actualiza.

### Mudanza a la organización (30-oct-2026)

- **Por qué:** el link viejo (`victormenav.github.io/RutafacilCR`) mostraba el nombre del dueño. Un dominio propio (ej. subdominio de infolinkcr.com) se descartó.
- **Qué se hizo:** se creó la organización gratis **rutafacilcr** en GitHub, se transfirió el repo y se renombró a `rutafacilcr.github.io`. Se instaló la app de Claude en la organización y se activó Pages (main / root).
- **Efectos:** el link viejo dejó de funcionar. El navegador guarda los datos por dirección, así que en la dirección nueva la lista del celular arranca vacía y hay que reinstalar el ícono. Las evidencias ya subidas siguen en Supabase (no cambió nada allá). Los links de formulario mandados antes de la mudanza ya no abren.

### Logo e íconos

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
6. Abrir `https://rutafacilcr.github.io/admin.html` > **Ajustes**: número SINPE, precio, días de gracia > **Guardar ajustes**.
7. Cuando todos los celulares tengan la 1.7.0 y su cuenta: encender **Exigir cuenta activa**.

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

- `supabase.sql` crea la tabla `entregas`, la función `registrar_entrega` y el bucket **privado** `evidencias` (solo JPEG, máx. 2 MB por foto).
- La app solo puede **subir** fotos (política `rutafacil subir evidencias`; con *Exigir cuenta activa*, solo desde una cuenta al día). El administrador puede listarlas y borrarlas (políticas `rutafacil admin ve/borra evidencias`); verlas o descargarlas se hace desde el panel de Supabase: **Storage > evidencias**. Las fotos se guardan como `AAAA-MM-DD/<guia>_<id>_<n>.jpg`.
- **Espacio:** cada foto pesa ~100–150 KB (1024 px, JPEG 65 %), unos 0,3–0,45 MB por entrega con 3 fotos.
  - Supabase gratis: **1 GB de Storage** → unas **2.200–3.300 entregas**. Con 30 entregas por día, unos 2,5 a 3,5 meses. La tabla `entregas` ocupa menos de 1 KB por entrega: los 500 MB de base de datos no son problema.
  - Celular: las fotos respaldadas se borran del celular a los **7 días** (`LOCAL_DIAS`). Queda el registro (fecha, GPS, cantidad de fotos) y las fotos siguen en Supabase.
  - Supabase avisa por correo al acercarse al límite. Opciones: descargar y borrar fotos viejas (ver *Consultas útiles*) o pasar a **Pro** (25 USD/mes, 100 GB).
  - **Liberar espacio desde el panel de RutaFácil:** `admin.html` > *Fotos de entrega* > **Calcular espacio usado** y **Borrar** las de más de N días (mínimo 7). Borra los archivos con la API de Storage; el registro en `entregas` queda.
  - **Liberar espacio a mano:** Supabase > **Storage** > **evidencias** > abrir la carpeta de un día viejo > seleccionar las fotos > **Download** (guardarlas en la PC) > **Delete**. Las carpetas se llaman por fecha (`AAAA-MM-DD`), así que se borran las más viejas primero. El registro en la tabla `entregas` se puede dejar: casi no ocupa.
  - En iPhone, si la app se usa desde Safari y no desde el ícono, Safari puede borrar los datos de la página tras ~7 días sin abrirla. Por eso Supabase es el respaldo oficial.

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
| OpenStreetMap Nominatim | Buscar un lugar por nombre cuando el link de ubicación no trae coordenadas (botón *Pegar respuesta*) | Pegar las coordenadas o un link con coordenadas. Uso bajo, sin llave. |
| Geolocalización del navegador | Botón "Estoy en mi casa" del formulario | El cliente la manda por WhatsApp o pega un link. Requiere HTTPS (GitHub Pages ya lo da). En iPhone depende de *Ajustes > Privacidad y seguridad > Localización > Sitios web de Safari* y del permiso por sitio en Safari (*aA > Configuración del sitio web > Ubicación*), también dentro del navegador de WhatsApp. |

## 6. Mantenimiento

- **Versión:** se muestra al final de la app, chiquita: *RutaFácil CR · versión 1.7.2*. Se usa versionado semántico **mayor.menor.corrección**: *mayor* sube con cambios grandes que obligan a reinstalar o migrar datos, *menor* con funciones nuevas y *corrección* con arreglos o ajustes visuales. Al publicar se cambia el número en `index.html` y `admin.html` (`#appVer`) y se anota en `CHANGELOG.md`. Sirve para confirmar si un celular ya tiene la versión nueva.

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
