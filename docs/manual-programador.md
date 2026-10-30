# Manual de programador y diseño · RutaFácil CR

Para quien vaya a modificar el código o el diseño.

## 1. Principios

- **Celular primero y responsive (regla de Victor, 30-oct):** todo se diseña para 360–400 px y se prueba a ese ancho. Botones de tamaño normal (no de ancho completo salvo la acción principal de una pantalla), áreas de toque de al menos 40 px y nada de scroll horizontal.

- **Sin build ni frameworks.** HTML, CSS y JavaScript plano. Se edita el archivo y se hace push.
- **Un archivo por pantalla:** `index.html` (app del repartidor), `entrega.html` (formulario del cliente; `f.html` solo redirige links viejos) y `admin.html` (panel). CSS y JS van dentro de cada archivo. La única pieza compartida es `auth.js` (cuentas).
- **Celular primero:** se diseña para 400 px de ancho y se agranda hasta 760 px.
- **Funciona sin backend:** si `config.js` está vacío, todo lo que no sea el formulario sigue funcionando.

## 2. Estructura de `index.html`

| Bloque | Contenido |
|---|---|
| `<style>` | Tokens de diseño (`:root`) y componentes. |
| `header.top` + `nav.tabs` | Encabezado y barra de pestañas fija abajo (*Paquetes / Mensajes / Ruta*), cada una con ícono SVG en línea y texto. `#n-pk` es el globito con la cantidad de paquetes. |
| `#v-paquetes` | Importación, formulario manual, lista. |
| `#v-mensajes` | Plantillas de mensaje, panel de respuestas (`#syncPanel`), lista de clientes. |
| `#v-ruta` | Parámetros de ruta y resultado (`#routeOut`). |
| `<script>` | Estado, parseo, render, ruta, sincronización y eventos. |

### Estado (`S`), guardado en `localStorage['rutafacil-cr-v1']`

```js
S = {
  pk: [Paquete],          // lista del día
  ex: bool,               // ¿son datos de ejemplo?
  yo, fecha,              // nombre del repartidor y fecha mostrada
  coord, form, camino,    // plantillas: primer mensaje, mensaje con formulario, voy en camino
  start, hora, vel, min, ret, filter,   // parámetros de ruta (hora = salida 'HH:MM')
  route: {start, ids, noC} | null // última ruta calculada
}
Paquete = {
  id, nombre, tel, dir, ubic, guia, nota,
  st: 'pendiente'|'confirmado'|'noresponde'|'entregado'|'fallido',
  sent,                   // se abrió WhatsApp
  tok,                    // token aleatorio de 12 caracteres para el formulario
  horario, senas, recibe, resp, respAt   // datos que llegan del formulario
}
```

`save()` y `load()` envuelven `localStorage` en try/catch. Al cargar, los paquetes viejos sin `tok` reciben uno.

### Funciones clave

| Función | Hace |
|---|---|
| `parseCoord(s)` | Busca `lat,lng` en cualquier texto o link (decodifica URL) y valida que esté dentro de Costa Rica. |
| `phoneWA(p)` | Limpia el teléfono y agrega `506` si tiene 8 dígitos. |
| `rowsToPkgs(rows)` | Detecta encabezados por regex (`COLS`). Si no hay encabezado, asume el orden nombre, teléfono, dirección, ubicación, guía, nota. |
| `parseText(t)` | Pegado: separa por tab, `;` o `\|`. Los CSV con comas se leen con SheetJS. |
| `fill(tpl, p, extra)` | Reemplaza `{variables}` en las plantillas. |
| `formLink(p)` | Arma `entrega?t=&n=` (corto a propósito: links largos dan desconfianza). |
| `coordText(p)` | Texto del primer mensaje. Siempre quita las líneas con `{formulario}`: el primer mensaje nunca lleva links. |
| Botón **📝 Mandar formulario** | Segundo mensaje con `S.form` (`DEF_FORM`), que sí lleva `{formulario}`. Marca `p.formSent`. Solo aparece si `config.js` tiene Supabase. |
| `parseWin(texto)` | Convierte el horario del cliente en ventanas en minutos del día (`"2 a 4 pm"` → `[[840,960]]`; `"4 pm"` → 3:30–5:00; *mañana* 8–12, *tarde* 12–6, *noche* 6–9; `null` = cualquier hora). Horas sin am/pm de 1 a 6 se toman como pm. |
| `sched(ord, M, W, t0, min, ret)` | Recorre un orden con la matriz de minutos `M`: llegada, espera si llega antes y atraso. Costo = tiempo total + 3 × minutos tarde + 60 por parada tarde. |
| `optimize(pts, W, t0, min, vel, ret)` | Dos arranques (vecino más cercano por distancia y otro que considera horarios), luego búsqueda local con 2-opt y reubicación de tramos de 1 a 3 paradas sobre el costo de `sched`. Tope de 2,5 s. Con 70 paradas tarda menos de 1 s en PC. |
| `hav(a, b)` | Distancia haversine × 1.35 (factor por calles). |
| `syncResp()` | Llama `leer_respuestas` con todos los tokens. Corre al abrir, cada 60 s con la pestaña visible y al volver a la app. |

Los enlaces de Google Maps se parten cada 10 paradas (límite de waypoints en Maps URLs).

## 3. Formulario `entrega.html`

- GitHub Pages sirve `entrega.html` también como `/entrega` (sin extensión).
- Parámetros de URL: `t` (token, obligatorio, ≥12) y `n` (nombre). Acepta también `g` (guía) e `y` (repartidor) de links viejos.
- Vista previa sobria: solo `og:title` ("RutaFácil · Su entrega") y `og:image` (`icon-512.png`). Sin descripción: textos como "no pide pagos" generaban desconfianza.
- Envía con `POST /rest/v1/rpc/enviar_respuesta`. Volver a enviar actualiza la respuesta (upsert por token).
- Ubicación, en este orden en pantalla: (1) *Se la mando por WhatsApp*, (2) pegar link, (3) GPS dentro de un `<details>`, porque en iPhone suele estar bloqueado.
- Detalle del GPS:
  1. GPS: primero `enableHighAccuracy` con 10 s; si falla (no por permiso), reintenta con ubicación aproximada, 20 s y caché de 5 min. Si el error es de permiso (`code 1`), muestra cómo habilitarlo (iOS: Ajustes > Privacidad y seguridad > Localización > Sitios web de Safari, y en Safari aA > Configuración del sitio web > Ubicación) y recomienda la opción de WhatsApp.
  2. "Prefiero mandarla por WhatsApp": agrega *(Manda la ubicación por WhatsApp)* a `senas` e indica los pasos en el chat.
  3. Pegar link de Maps/Waze (dentro de un `<details>`).
- Los mensajes no deben llevar el signo `+`: al pasar por `wa.me` WhatsApp lo convierte en espacio.
- Plantillas: `DEF_SIMPLE` es la vigente (corta, sin link). `DEF_COORD`, `DEF_COORD_F` y `OLD_COORD_F` son anteriores; si el usuario tiene guardada una sin cambios, se reemplaza sola por `DEF_SIMPLE` al abrir.

## 3a. Pegar respuesta

- Botón **📋 Pegar respuesta** (en *Paquetes* y *Mensajes*) → `pasteReply(p)`: lee el portapapeles (`navigator.clipboard.readText`). Si no puede, abre `#pasteSheet` para pegar a mano.
- `applyReply(p, texto)`: ubicación con `parseCoord()` y, si el link solo trae el nombre del lugar (`?q=Vitafuerte…`), la busca con `geocodeText()` en OpenStreetMap Nominatim, solo Costa Rica. La hora sale de `findTime()` (regex `TIME_RE`: "4 pm", "a las 4", "de 2 a 4", "en la tarde", "cualquier hora"…), que ignora líneas con links o coordenadas y quita el encabezado `[hora, fecha] Nombre:` que WhatsApp agrega al copiar varios mensajes.
- Guarda `p.ubic`, `p.horario` y pasa `pendiente`/`noresponde` a `confirmado`.

## 3c. Escanear etiquetas

- Panel **Escanear etiquetas** en *Paquetes* + hoja `#scanSheet`. Entradas: `#scanCam` (`capture=environment`) y `#scanGal` (`multiple`, va a la cola `SCAN.queue`).
- Librerías cargadas con `loadScript()` solo al escanear: ZXing (`LIB_ZXING`) y Tesseract.js (`LIB_OCR`). Un solo worker de Tesseract (`SCAN.ocr`, idioma `spa`) por sesión.
- `scanCanvas(file, rot)`: reduce a 2000 px y gira de 90 en 90 (botón *Girar*).
- `readCodes(c)`: `BarcodeDetector` nativo si existe (Android); si no, ZXing con `TRY_HARDER` sobre la foto entera y por franjas, porque la etiqueta trae más de un código.
- `deskew(c)`: busca el ángulo (−12° a 12°, afinado a 0,25°) con el perfil de proyección de filas más marcado y endereza; con 2–3° de inclinación Tesseract pasaba de leer bien a no leer nada. Aplica gris y contraste.
- `parseLabel(texto, códigos)`: guía = código tipo `HZCR56461310263` (o regex en el texto); teléfono = 8 dígitos que empiecen en 2/4/5/6/7/8, prefiriendo líneas con *tel/cel*, y descartando dígitos de la guía; nombre = texto después de *TO/Destinatario/Nombre/Para* (o primera línea de 2–5 palabras); dirección = líneas con palabras de señas o provincias (`L_ADDR`), sin las del remitente (`L_SENDER`: Temu, China, aduana…).
- *Guardar* abre la cámara **dentro del mismo toque** (iPhone no deja abrirla después de un `await`) y agrega con `mkPkg()`. Las fotos de etiqueta no se guardan.
- Prueba local: las CDN están bloqueadas en el sandbox; se instalan los paquetes con npm y Playwright sirve los archivos interceptando las URL de jsDelivr. Las etiquetas de prueba se generan con JsBarcode.

## 3d. Soporte

- Ícono: SVG en línea de audífonos con micrófono (`stroke=currentColor`, clase `.ico-sop`), sin archivos ni librerías; toma el color del texto. El mismo trazo va en `ayuda` y `contacto()` de `auth.js`.
- Botón `#supTab` (cuarto botón de `nav.tabs`, ícono `.ico-sop`, sin `role=tab`: abre la hoja y no cambia de pestaña; el manejador de pestañas filtra `nav.tabs [role=tab]`) y enlace `#supPie` en el pie → `openSupport()` abre `#supSheet`.
- WhatsApp: `wa.me/SOPORTE_WA` con texto que incluye la versión (`#appVer`).
- Videos: `fetch('videos.json',{cache:'no-cache'})`; si la URL es de YouTube usa un `<iframe>` de youtube-nocookie, si no un `<video controls playsinline preload=metadata>`. Al cerrar (`#supClose`, `.btn.primary` naranja del tamaño de *Guardar ajustes*, centrado y con `position:sticky` abajo, siempre visible) se pausan y se vacía la lista para no gastar datos.
- El pie también lo usa `auth.js` (`.rfcuenta`, cuenta y Salir): el enlace de soporte va al inicio del pie para no tocar ese bloque.

## 3b. Prueba de entrega

- Al pasar un paquete a **entregado** (botón o etiqueta de estado) se abre `#podSheet` con `openPOD(p)`. Nunca se pone `st='entregado'` sin evidencia.
- GPS: `enableHighAccuracy` 15 s, `maximumAge 0`; si falla (no por permiso) reintenta aproximado 20 s.
- Fotos: `<input type=file capture=environment>`. `stampPhoto()` reduce a 1024 px, dibuja el sello (fecha/hora, cliente, guía, GPS) y exporta JPEG 0.65 (~100–150 KB).
- `cleanLocal()` (corre con `uploadPending`) vacía `fotos` en IndexedDB de evidencias ya subidas con más de `LOCAL_DIAS = 7` días.
- Mínimo `MIN_FOTOS = 3`. *Confirmar* se habilita con 3 fotos + GPS.
- Guardado local: IndexedDB `rutafacil-evidencias`, store `ev` → `{id, pid, guia, cliente, at, lat, lng, acc, fotos:[Blob], up}`. En el paquete queda `p.pod = {id, n, at, lat, lng, acc, up}`.
- Subida: `uploadPOD(id)` sube cada foto a `storage/v1/object/evidencias/<día>/<guia>_<id>_<n>.jpg` y luego llama `registrar_entrega`. Si falla, queda `up:false` y `uploadPending()` reintenta cada 60 s y al tocar *Revisar respuestas ahora*.
- `openEvidence(p)` muestra fotos (desde IndexedDB), hora, GPS y estado del respaldo.

## 3d. Cuentas (`auth.js`)

Se carga después de `config.js` en `index.html` y `admin.html`. Sin Supabase en `config.js` no hace nada (`RF_AUTH.on = false`, `listo` resuelve `null`).

- **Sin librerías:** habla con Supabase Auth por REST (`/auth/v1/signup`, `/auth/v1/token?grant_type=password|refresh_token`, `/auth/v1/logout`).
- **Correo interno:** `<8 dígitos>@rutafacilcr.github.io`; el PIN (6 números) es la contraseña. `tel8()` quita `506` y lo que no sea número.
- **localStorage:** `rutafacil-sesion` (tokens), `rutafacil-dispositivo` (id aleatorio de 32 hex del celular, se crea una vez), `rutafacil-cuenta` (última respuesta buena de `rf_mi_cuenta` + hora).
- **Bloqueo:** agrega la clase `rf-bloq` a `<html>` (oculta todo menos `#rfGate`) y pinta la pantalla en `#rfGate`. Si hay una revisión buena de menos de 3 días (`OFFLINE_DIAS`), abre de una vez y revisa por detrás; así funciona sin internet.
- **Revisión:** `revisar()` llama `rf_mi_cuenta(p_dispositivo)` al abrir, cada 15 min con la app visible y al volver a la app (si pasaron 5 min). Si la cuenta deja de servir, bloquea de nuevo. Un 404 de la función (SQL sin correr) abre la app con aviso en el pie.
- **Soporte:** `SOPORTE` (de `RF_CONFIG.soporte`, por defecto 62700666). `ayuda` (enlace de WhatsApp) va al pie de `vEntrar`, `vCrear` y `vError`; `contacto()` (botón) en `vEstado`.
- **Espera de activación:** mientras la pantalla de cuenta está visible (`!abierta`), `revisar()` corre cada 60 s y al volver a la app, así abre sola cuando el administrador la activa.
- **Vistas:** `vEntrar`, `vCrear`, `vEstado` (pendiente de activación, vencida, suspendida, teléfono pendiente o cerrado) y `vError`.
- **API `window.RF_AUTH`:** `on`, `listo` (promesa con la cuenta), `cuenta`, `headers()` (async: `apikey` + `Authorization: Bearer <token>` renovando el token si vence en menos de 1 min; sin sesión, los headers anónimos de antes), `rpc(fn, args)`, `revisar(manual)`, `salir()`, `dispositivo`. Al abrir dispara el evento `rf-cuenta` en `document`.
- **En `index.html`:** `syncResp()` y `uploadPOD()` usan `await RF_AUTH.headers()`. La sincronización arranca dentro de `RF_AUTH.listo.then(...)`. `usarCuenta(c)` pone `S.yo = c.nombre` y deja `#m-yo` de solo lectura.
- **`admin.html`:** define `window.RF_AUTH_ADMIN = true` antes de `auth.js` (exige `rol = 'admin'`). Lista cuentas (`rf_admin_cuentas`), movimientos (`rf_admin_eventos`) y ajustes (`rf_admin_ajustes` con nulos = solo leer). Acciones: `rf_admin_renovar`, `rf_admin_estado`, `rf_admin_telefono` (`aprobar|rechazar|liberar`), `rf_admin_pin` (PIN aleatorio de 6 dígitos), `rf_admin_nombre`. Después de activar, renovar o reactivar, `ofrecerAviso(c, nuevo)` muestra `#avisar` con un enlace `wa.me/506<tel>?text=…` ya escrito (no se abre solo: los navegadores bloquean ventanas que no vienen de un toque). Avisos: `rf_admin_avisos` (nulos = leer; las llaves solo se escriben y vuelven como `true/false`) y `rf_admin_probar_avisos`. Fotos: `storage/v1/object/list/evidencias` por carpeta de día y `DELETE storage/v1/object/evidencias` con `prefixes` (de 500 en 500).

## 4. Base de datos y seguridad (`supabase.sql`)

### Cuentas

```
rf_ajustes(id=1, exigir_cuenta, sinpe, precio, dias_gracia)
rf_perfiles(id → auth.users, nombre, telefono, rol mensajero|admin, estado pendiente|activo|suspendido,
            vence_en, dispositivo, dispositivo_anterior, dispositivo_pendiente, pendiente_desde,
            sesion_id, ultimo_acceso, creado_en)
rf_pagos(user_id, monto, dias, referencia, creado_por, creado_en)
rf_eventos(user_id, tipo, detalle jsonb, creado_en)
```

- RLS activado **sin políticas** en las cuatro; todo pasa por funciones `security definer`.
- Trigger `rf_perfil_nuevo` en `auth.users`: crea el perfil `pendiente` con `nombre` y `telefono` de `raw_user_meta_data`.
- `rf_mi_cuenta(p_dispositivo)`: primer teléfono → queda aprobado; mismo teléfono → actualiza `sesion_id` con `auth.jwt()->>'session_id'`; teléfono anterior → `cerrado`; otro → `pendiente` (+ evento). El admin no queda atado a un teléfono.
- `rf_licencia_ok()`: `true` si `exigir_cuenta` está apagado; si no, admin, o estado activo + `vence_en + dias_gracia > now()` + `sesion_id` igual al de la llamada. `rf_exigir_licencia()` lanza `RF_CUENTA: …` si no.
- `leer_respuestas` y `registrar_entrega` (ahora plpgsql) llaman `rf_exigir_licencia()`; `registrar_entrega` guarda `owner_id = auth.uid()`. La política de subida a `evidencias` usa `rf_licencia_ok()`.
- Aprobar un teléfono pone `sesion_id = null`: la sesión vieja deja de pasar al instante y la nueva se registra en su siguiente `rf_mi_cuenta`.
- **Avisos (1.10.0):** `rf_avisos(id=1, whatsapp, callmebot_key, correo, resend_key)` con RLS y sin políticas. Trigger `rf_evento_aviso` en `rf_eventos` (solo `cuenta_nueva` y `telefono_nuevo`) → `rf_avisar_admin(asunto, texto)`, que usa `pg_net` (`net.http_get` a CallMeBot, `net.http_post` a Resend). Es asíncrono y va dentro de `begin … exception`: si falla, guarda un evento `aviso_error` y la cuenta se crea igual. `rf_avisar_admin` y `rf_evento_aviso` no se pueden llamar desde la app.
- `rf_admin_pin` cambia `auth.users.encrypted_password` con `extensions.crypt(pin, gen_salt('bf'))` (bcrypt, el mismo formato de Supabase Auth).

### Formulario y entregas

`entregas(evidencia_id UNIQUE, guia, cliente, repartidor, lat, lng, precision_m, entregado_en, fotos text[], owner_id)`: RLS sin políticas, se escribe solo con `registrar_entrega`. Bucket `evidencias` privado con política de solo INSERT para `anon`.


```
respuestas(id, token UNIQUE, guia, horario, senas, recibe, lat, lng,
           owner_id → auth.users, created_at, updated_at)
```

- RLS activado **sin políticas**: nadie lee ni escribe la tabla directo.
- Acceso solo por dos funciones `security definer`:
  - `enviar_respuesta(...)`: insert o update por token, con textos recortados.
  - `leer_respuestas(p_tokens text[])`: devuelve solo los tokens pedidos (máximo 300).
- El token aleatorio (12 caracteres, alfabeto de 32 → 60 bits) funciona como contraseña de cada respuesta.
- `leer_respuestas` ya exige cuenta (ver *Cuentas*). Pendiente: llenar `respuestas.owner_id` para filtrar también por dueño.

## 5. Sistema de diseño

**Concepto (desde 30-oct, paleta B "Grafito y naranja"):** sobrio y profesional, como una app de envíos. Encabezado grafito, naranja solo para la acción principal y títulos en tipo normal (sin mayúsculas). Se eligió entre tres paletas (A azul marino, B grafito y naranja, C verde azulado).

### Colores (tokens en `:root`, con versión oscura)

| Token | Claro | Oscuro | Uso |
|---|---|---|---|
| `--road` | `#1f2125` | `#1f2125` | Encabezado, pestañas, botones de ruta, números de parada. |
| `--accent` / `--accent-ink` | `#f26b1d` / `#ffffff` | `#f5803a` / `#1f2125` | Acción principal, borde de pestañas, línea de ruta, "Fácil" del título. |
| `--bg` / `--surface` | `#f5f5f4` / `#ffffff` | `#121315` / `#1b1d21` | Fondo / tarjetas. |
| `--ink` / `--muted` / `--line` | `#1c1917` / `#6b6560` / `#e2dfdc` | `#ececeb` / `#a8a4a0` / `#2e3137` | Texto y bordes. |
| `--wa` | `#1f9d55` | `#3cc37a` | Solo botones de WhatsApp. |
| `--ok` `--warn` `--bad` | verde / naranja / rojo | | Estados. No se usan como acento. |

Modo oscuro: `@media (prefers-color-scheme: dark)` redefine los mismos tokens. Nunca poner colores fijos en componentes. `entrega.html` usa los mismos tokens.

### Tipografía

| Rol | Fuente | Uso |
|---|---|---|
| Display (`--f-display`) | Public Sans 700–800, tipo oración | Títulos, pestañas, números grandes. |
| Texto | Public Sans 400–700 | Todo lo demás. |
| Datos | JetBrains Mono 500 | Teléfonos, guías, coordenadas, km. |

Antes era Barlow Condensed en mayúsculas; se cambió porque se veía menos profesional.

### Componentes

- `.btn` (`.primary` naranja, `.road` grafito, `.wa` WhatsApp, `.sm`, `.ghost`, `.danger`).
- `.chip.st-*`: etiqueta de estado. Tocarla rota el estado.
- `.pkg`: tarjeta de paquete (grilla de 2 columnas) con número grande a la izquierda. Todo bloque nuevo dentro de la tarjeta va en `grid-column:2` (como `.actions` y `.ev`), si no cae bajo el número y aprieta el contenido.
- `.stop` + `.dot`: línea de ruta punteada naranja entre paradas.
- `nav.tabs`: barra inferior fija tipo app (fondo `--surface`, activa en `--accent` con raya arriba). Respeta `safe-area-inset-bottom` del iPhone; `main.wrap` deja 96 px abajo y el `.toast` sube a 84 px para no taparse.
- `.sheet`: hojas que suben desde abajo (prueba de entrega, pegar respuesta, evidencia, escanear etiquetas).
- `.toast`: confirmación breve abajo (encima de las hojas).

### Logo e íconos

**Pin con paquete:** pin naranja (ubicación y ruta) con una caja blanca (la entrega) y líneas de velocidad (rapidez), sobre grafito. Grilla de 512 px.

| Color | Hex |
|---|---|
| Grafito (fondo) | `#1f2125` |
| Grafito claro (brillo, 55 %) | `#2e3137` |
| Naranja (pin) | `#f26b1d` |
| Naranja oscuro (cinta) | `#c9520f` |
| Blanco (caja, líneas) | `#ffffff` |

Archivos: `logo.svg` (fuente maestra; los PNG se regeneran desde él), `icon-192.png`, `icon-512.png`, `icon-maskable-512.png` (Android, contenido al 80 %), `apple-touch-icon.png` (180, sin transparencia) y `favicon-32.png`. El logo también va en el encabezado de la app.

**No usar logos ni marcas de terceros** (Temu u otras): puede traer problemas legales, sobre todo si la app se vende. "Temu" solo aparece en el texto de los mensajes.

## 6. Cómo probar

No hay pruebas automáticas en el repositorio. Antes de cada push:

1. Servir la carpeta local (`python3 -m http.server`) y abrir a 400 px de ancho. Con Supabase en `config.js` aparece la pantalla de entrada; para probar sin servidor se pueden simular las respuestas de `/auth/v1/*` y `/rest/v1/rpc/*` con `page.route()` de Playwright.
2. Revisar la consola sin errores.
3. Flujo completo: importar, editar con link de Maps, abrir mensaje, calcular ruta.
4. Formulario: abrir el link desde **Ver mensaje**, enviar y tocar **Revisar respuestas ahora**.
5. Cuentas: `supabase.sql` se probó en un Postgres 16 local con stubs mínimos de Supabase (`auth.users`, `auth.uid()`, `auth.jwt()` leyendo `request.jwt.claims`, `storage.objects`, `extensions.pgcrypto`, roles `anon`/`authenticated`): correr el script dos veces y recorrer crear cuenta → activar → segundo teléfono pendiente → aprobar → teléfono viejo cerrado → anónimo rechazado con *exigir* encendido.

## 7. Convenciones

- **Versión:** semántica `mayor.menor.corrección` en `#appVer` (pie de `index.html` y de `admin.html`). Subirla en cada publicación y anotarla en `CHANGELOG.md`.

- Textos en español de Costa Rica (voseo en la app del repartidor, usted en el formulario del cliente).
- Commits en español, en imperativo ("Agregar…", "Corregir…").
- Cada cambio actualiza: `CHANGELOG.md` y los manuales afectados (`README.md`, `docs/`).
