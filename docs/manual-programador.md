# Manual de programador y diseño · RutaFácil CR

Para quien vaya a modificar el código o el diseño.

## 1. Principios

- **Sin build ni frameworks.** HTML, CSS y JavaScript plano. Se edita el archivo y se hace push.
- **Un archivo por pantalla:** `index.html` (app del repartidor) y `f.html` (formulario del cliente). CSS y JS van dentro de cada archivo.
- **Celular primero:** se diseña para 400 px de ancho y se agranda hasta 760 px.
- **Funciona sin backend:** si `config.js` está vacío, todo lo que no sea el formulario sigue funcionando.

## 2. Estructura de `index.html`

| Bloque | Contenido |
|---|---|
| `<style>` | Tokens de diseño (`:root`) y componentes. |
| `header.top` + `nav.tabs` | Encabezado y pestañas *1 Paquetes / 2 Mensajes / 3 Ruta*. |
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
  coord, camino,          // plantillas de mensaje
  start, vel, min, ret, filter,   // parámetros de ruta
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
| `formLink(p)` | Arma `f.html?t=&n=&g=&y=`. |
| `coordText(p)` | Texto final del mensaje de coordinación. Si el formulario está activo y la plantilla no trae `{formulario}`, agrega el link al final. |
| `optimize(pts, ret)` | Vecino más cercano y luego mejora 2-opt. |
| `hav(a, b)` | Distancia haversine × 1.35 (factor por calles). |
| `syncResp()` | Llama `leer_respuestas` con todos los tokens. Corre al abrir, cada 60 s con la pestaña visible y al volver a la app. |

Los enlaces de Google Maps se parten cada 10 paradas (límite de waypoints en Maps URLs).

## 3. Formulario `f.html`

- Parámetros de URL: `t` (token, obligatorio, ≥12), `n` (nombre), `g` (guía), `y` (repartidor).
- Envía con `POST /rest/v1/rpc/enviar_respuesta`. Volver a enviar actualiza la respuesta (upsert por token).
- Geolocalización con `enableHighAccuracy` y 15 s de espera. Si falla, se puede pegar un link.

## 4. Base de datos y seguridad (`supabase.sql`)

```
respuestas(id, token UNIQUE, guia, horario, senas, recibe, lat, lng,
           owner_id → auth.users, created_at, updated_at)
```

- RLS activado **sin políticas**: nadie lee ni escribe la tabla directo.
- Acceso solo por dos funciones `security definer`:
  - `enviar_respuesta(...)`: insert o update por token, con textos recortados.
  - `leer_respuestas(p_tokens text[])`: devuelve solo los tokens pedidos (máximo 300).
- El token aleatorio (12 caracteres, alfabeto de 32 → 60 bits) funciona como contraseña de cada respuesta.
- **Al agregar login:** llenar `owner_id`, cambiar `leer_respuestas` para filtrar por `auth.uid()` y exigir suscripción vigente.

## 5. Sistema de diseño

**Concepto:** señalización vial. Verde carretera de fondo, amarillo de demarcación como acento y tipografía condensada como de rótulo.

### Colores (tokens en `:root`, con versión oscura)

| Token | Claro | Uso |
|---|---|---|
| `--road` | `#1f4d46` | Encabezado, pestañas, botones principales de ruta. |
| `--accent` | `#e8a317` | Acción principal, borde de pestañas, línea de ruta. |
| `--bg` / `--surface` | `#f3f5f4` / `#ffffff` | Fondo / tarjetas. |
| `--ink` / `--muted` | `#15302c` / `#5b6f6b` | Texto. |
| `--wa` | `#1f9d55` | Solo botones de WhatsApp. |
| `--ok` `--warn` `--bad` | verde / naranja / rojo | Estados. No se usan como acento. |

Modo oscuro: `@media (prefers-color-scheme: dark)` redefine los mismos tokens. Nunca poner colores fijos en componentes.

### Tipografía

| Rol | Fuente | Uso |
|---|---|---|
| Display | Barlow Condensed 600/700, mayúsculas | Títulos, pestañas, números de parada. |
| Texto | Public Sans 400–700 | Todo lo demás. |
| Datos | JetBrains Mono 500 | Teléfonos, guías, coordenadas, km. |

### Componentes

- `.btn` (`.primary` amarillo, `.road` verde, `.wa` WhatsApp, `.sm`, `.ghost`, `.danger`).
- `.chip.st-*`: etiqueta de estado. Tocarla rota el estado.
- `.pkg`: tarjeta de paquete con número grande a la izquierda.
- `.stop` + `.dot`: línea de ruta punteada amarilla entre paradas.
- `.toast`: confirmación breve abajo.

### Ícono

Pin amarillo con caja al final de una ruta punteada, sobre degradado verde. Archivos: `apple-touch-icon.png` (180), `icon-192.png`, `icon-512.png`, `favicon.png` (32). Se generan desde un SVG de 512 px.

## 6. Cómo probar

No hay pruebas automáticas en el repositorio. Antes de cada push:

1. Servir la carpeta local (`python3 -m http.server`) y abrir a 400 px de ancho.
2. Revisar la consola sin errores.
3. Flujo completo: importar, editar con link de Maps, abrir mensaje, calcular ruta.
4. Formulario: abrir el link desde **Ver mensaje**, enviar y tocar **Revisar respuestas ahora**.

## 7. Convenciones

- Textos en español de Costa Rica (voseo en la app del repartidor, usted en el formulario del cliente).
- Commits en español, en imperativo ("Agregar…", "Corregir…").
- Cada cambio actualiza: `CHANGELOG.md` y los manuales afectados (`README.md`, `docs/`).
