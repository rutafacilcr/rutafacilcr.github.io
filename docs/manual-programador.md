# Manual de programador y diseño · RutaFácil CR

Para quien vaya a modificar el código o el diseño.

## 1. Principios

- **Celular primero y responsive (regla de Victor, 30-oct):** todo se diseña para 360–400 px y se prueba a ese ancho. Botones de tamaño normal (no de ancho completo salvo la acción principal de una pantalla), áreas de toque de al menos 44 px (1.79.0) y nada de scroll horizontal.

- **Sin build ni frameworks.** HTML, CSS y JavaScript plano. Se edita el archivo y se hace push.
- **Un archivo por pantalla:** `index.html` (app del repartidor), `entrega.html` (formulario del cliente; `f.html` solo redirige links viejos) y `admin.html` (panel). CSS y JS van dentro de cada archivo. La única pieza compartida es `auth.js` (cuentas).
- **Celular primero:** se diseña para 400 px de ancho y se agranda hasta 760 px.
- **Funciona sin backend:** si `config.js` está vacío, todo lo que no sea el formulario sigue funcionando.

## 1a. Diseño accesible (1.79.0, WCAG 2.2 AA)

Todo vive al final del `<style>` de `index.html`, en el bloque «1.79.0 · Diseño y accesibilidad». Reglas para lo que se agregue de aquí en adelante:

- **Dos naranjas.** `--accent` (#f26b1d) es la marca: logo, raya del encabezado, pestaña activa, bordes, pines. `--accent-btn` (#c4510f, 4,6 a 1 con blanco) es para **todo botón naranja con letra blanca** (`.btn.primary`, «↪ Regresar a Ruta», «← Regresar», globito de pestañas). Al tocar/pasar: `--accent-btn-hover` (#a9450d). Para texto naranja sobre fondo claro: `--accent-text` (#b8470f). Nunca poner letra blanca sobre #f26b1d (3,05 a 1, no cumple).
- **WhatsApp:** `--wa-btn` (#15803d, 5 a 1).
- **Bordes de controles:** `--ctl-line` (3 a 1 contra la tarjeta). `--line` queda solo para separadores.
- **Estados de entrega:** variables `--st-<estado>` y `--st-<estado>-bg` (claro y oscuro). Clases `.chip.st-pendiente|confirmado|noresponde|entregado|fallido` (el ícono sale de `::before`, no del texto, así `SLABEL`, Excel y mensajes no cambian) y `.devtag` gris para ⛔ Devuelto. `.devtag.on` (rojo) queda solo para «⛔ Devolver» (pendiente de devolver).
- **Área táctil:** `--tap` (44 px) como `min-height` de `.btn` y `.coordbtn` dentro de `#v-paquetes`, `#v-entrega`, `#v-ruta`, `#v-cierres`, `.sheet` y `.rfdlg`; selector de vehículo de 44 × 44; etiquetas de 32 px; 8 px entre botones. **Mensajes no se tocó** (regla de Victor): solo hereda los colores compartidos.
- **Estados de botón:** `:active` (se encoge y oscurece un poco), `:focus-visible` (contorno de 3 px), `:disabled`/`aria-disabled="true"` (gris punteado, no se toca) y `.cargando`/`aria-busy="true"` (ruedita, no se toca). Para mostrar carga: `b.classList.add('cargando')` y quitarla al terminar.
- **Tarjetas cerradas** (`.pkg.entregado`, `.estop.ok`): no usar `opacity` ni `grayscale` para apagar (bajan el contraste del texto). Se apagan con fondo gris, texto `--muted` y botones con borde punteado, igual que los devueltos (1.76.2).
- **1.84.0 (completa la lista):** íconos de estado en círculos de color 🟡 Pendiente, 🔵 Confirmado, 🟠 No responde, 🟢 Entregado, 🔴 No se entregó y ⚪ Devuelto (este último es texto en `stChip()`, `devBar()` y la parada de Ruta). Mensajes también a 44 px (`#v-mensajes`), igual que las etiquetas que se tocan (`.chip`, `button.devtag`). Carga: `conCarga(boton, fn)` pone `aria-busy` mientras corre `fn` y evita el doble toque; se usa en Bajar Excel, Guardar contactos, Usar esta respuesta y (a mano) en Confirmar entrega. Confirmación: el `#toast` tiene `role="status"` para que el lector de pantalla lo anuncie.
- **Cómo verificar:** Lighthouse (accesibilidad 100 en `index.html`, `admin.html`, `entrega.html`, `conoce.html`) y axe-core sobre las cuatro pestañas en claro y oscuro, a 390 px y 1280 px, con paquetes de prueba en cada estado y `config.js` vacío.

## 1b. Páginas públicas (1.75.0)

- `conoce.html` (voseo, para el mensajero) y `privacidad.html` (usted, porque la leen también los clientes) son páginas sueltas con su propio `<style>`: mismos tokens de color que `index.html` (grafito `#1f2125`, naranja `#f26b1d`), modo oscuro por `prefers-color-scheme`, primero para celular (una columna; desde 640 px los pasos van con la captura a la par). Botones compactos naranja con letra blanca y alineados a la derecha. Los videos de `conoce.html` apuntan a los mismos archivos de `videos/` que *Soporte* (1.75.1: `01-entrar`, `02-paquetes`, `03-mensajes` y `04-ruta`, con su póster en `img/video-*.jpg`); si se renombra un video, hay que cambiarlo en `videos.json` y en `conoce.html`.
- En celular los videos van en una fila que se desliza de lado (`overflow-x:auto` con `scroll-snap`), sin mover la página. Probado a 390 px y 1280 px sin desborde horizontal.
- `auth.js`: la constante `intro` (vacía en el panel, `RF_AUTH_ADMIN`) se pinta antes de `<h2>Entrar</h2>` y `<h2>Crear cuenta</h2>` con estilos en línea (`.rfmsg`), para no tocar el CSS del portero.
- `entrega.html`: una línea `.hint` después del formulario con el enlace a `privacidad.html`.
- No se nombra ninguna tienda en estas páginas (se dice "compras en línea").

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

Desde la 1.74.0 `S.owner` = número de la cuenta dueña de estos datos (ver 3c-0a). `save()` y `load()` envuelven `localStorage` en try/catch. Al cargar, los paquetes viejos sin `tok` reciben uno.

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
| `#m-yo` / `S.yoPropio` | El nombre que firma los mensajes. `usarCuenta()` pone el nombre de la cuenta solo si el repartidor no escribió uno propio (`S.yoPropio`); vaciar el campo lo devuelve al de la cuenta. Antes de 1.14.1 el campo quedaba `readOnly` y en iPhone no salía el teclado. |
| `#tplPanel` | `<details>` plegado al final de Mensajes con las plantillas `#m-coord`, `#m-form`, `#m-camino`. Al abrirlo (`toggle`) se recalcula la altura de los cuadros con `grow()`. Orden de la pestaña: nombre y fecha → Clientes → Respuestas del formulario → plantillas. |
| `#podOk` | Nunca queda `disabled` mientras falte algo: con la clase `.off` se ve tenue y al tocarlo avisa qué falta y hace scroll. Si el GPS falló (`#podGeoRetry` visible) pide `confirm()` y guarda la entrega con `lat/lng/acc = null` (la ficha dice *Sin GPS* y no sale en *Recorrido de hoy*). Errores al guardar se muestran en un toast. `sigInit()` también reinicia el largo del trazo (evento `sigreset`). |
| `cleanName(s)` | Mayúscula inicial con `\p{L}` (respeta tildes y ñ) y quita guiones o puntos sueltos al inicio y final. La usan el escáner y `vcfName()`. `fixOldName()` repara al cargar los nombres guardados con el error viejo (*ChavarríA*). |
| `saveContacts()` | Arma un `.vcf` (vCard 3.0) con un contacto por teléfono (`phoneWA`), nombre `vcfName()` = `S.pref`-Nombre-guías (guías del mismo teléfono unidas con `/`), y lo descarga con un `<a download>` sobre un Blob `text/vcard`. En iPhone (`IOS`) usa `navigator.share({files})`: Safari, al abrir un `.vcf` con varios contactos, solo ofrece el primero; desde *Archivos* sí sale *Agregar los N contactos* (aviso `#vcfIos`). Desde 1.18.2 primero abre `#vcfSheet` con los pasos (Mail o Archivos; *Contactos* en el menú también importa solo el primero) y el botón **Continuar** llama `navigator.share` (necesita el toque del usuario). `S.pref` (casilla `#m-pref`) vale `TM` por defecto. `vcfEsc()` escapa `\\ , ;`. |
| `nubeSync()` | Lista en la nube. Lee `rf_lista_leer`; si la versión cambió, `nubeMezclar()` une por `id` usando `S.baseIds` (ids de la última sincronización) para distinguir *borrado en un lado* de *nuevo en el otro*; si hay cambios locales (`S.dirty`) gana lo local. Luego sube con `rf_lista_guardar(p_datos, p_version)`; si otro aparato guardó antes, la función devuelve `ok:false` con sus datos, se mezcla y se reintenta (hasta 3). Corre al abrir, cada 60 s, al volver a la app y 2,5 s después de cada `save()` (`nubeSoon`). `saveLocal()` guarda sin marcar cambios. Claves sincronizadas: `NUBE_KEYS`. Desde 1.19.1 las claves que no son `pk` se mezclan una por una con `S.nubeBase` (huella al último sync): gana lo local solo si esa clave cambió aquí (sin huella previa, gana lo local si hay cambios pendientes). `nubeSync(force)`: con la misma versión también sube si a la nube le falta una clave que el aparato tiene; `force` (☁️, cargar ruta) sube siempre. Abrir *Entrega* llama `nubeSync()` antes de dibujar. Las claves que esta versión no conoce se guardan en `S.nubeOtros` y se vuelven a subir; si la nube perdió una clave que el aparato tiene (`NUBE.falta`), se sube de nuevo. Estado en el pie (`#nubeInfo`, se toca para sincronizar): *al día*, *sin activar* (404: faltan las funciones), *sin permiso* o *sin conexión*. |
| `entCargar(file)` | Pestaña *Entrega*. Lee con SheetJS la hoja `Ruta ordenada` (o la primera), ubica columnas por encabezado (`orden, nombre, telefono, direccion, guia, nota, ubicacion, Waze`) y saca coordenadas del hipervínculo de `ubicacion`/`Waze` (`cell.l.Target`) con `parseCoord`. Guarda `S.ent` (sincronizado en la nube vía `NUBE_KEYS`). Paradas sin coordenadas van al final. El aviso rojo sale si el nombre no es *Ruta* de hoy ni de mañana (fecha local). Tocar ☁️ en el pie muestra versión de la nube, paquetes y ruta cargada (diagnóstico). |
| `renderEnt()` / `entSel(i)` | Mapa Leaflet `#entMap` (sticky, 42vh) con pines `.epin` numerados y polilínea en orden; lista `.estop`. Tocar una parada centra el mapa; tocar un pin hace scroll a la parada. `entPkg(s)` busca el paquete por guía o teléfono para abrir la prueba de entrega (`openPOD`). |
| `entOrdenar(start)` | Reordena las paradas pendientes con `optimize()` (la misma de *Ruta*) desde `start`, con ventanas `parseWin` del paquete que coincida y la hora actual; renumera y guarda `S.ent.inicio`. Lo llaman **📍 Ordenar desde aquí** (GPS con `getCurrentPosition`, alta precisión y respaldo de baja) y **🎯 Elegir en el mapa** (`EMAP.pick` + click en el mapa). `entEta()` (lo llama `entMe()`, o sea en cada render y cada lectura de GPS) llena los `<span class="eeta" data-eta="i">` junto a los botones Evidencia (`data-eok`, solo si `entPkg` encuentra el paquete) y Entregado (`data-edone`, pone `s.done=true`). Para una parada entregada se muestra `data-eundo` (solo si fue `s.done`). Las paradas entregadas se ven grises (`.estop.ok .n`, `.epin.ok` con `#9aa0a6`). Usa `OSRM.r[ckey(c)]=[km,min]` de `osrmPedir()` (tabla OSRM, `sources=0`) si la consulta se hizo a menos de 300 m de tu punto actual; si no, `hav()`. La fórmula es min = max(OSRM×1,3, km/18 km/h) + 1; vacío se oculta con `:empty`. `optimize()` acepta un 7.º parámetro opcional `Mx` (matriz de minutos); `entOrdenar` es async y se lo pasa desde `osrmMatriz(pts)` (duraciones ×1,3), o `null` para usar `hav`. `entTotal()` (también desde `entMe()`; la línea "Inicio · fin" usa la hora actual + total, sin `S.hora`, y un `setInterval` de 60 s la refresca) llena `#entTot` (`.entrow` junto a `#entGps`): `RTOT` guarda la caché de `osrmCadena()` con clave `k` = las `ckey` pendientes. El manejo es max(duración×1,3, km/18 km/h) y el total va de manejo + n×3 a manejo + n×5. WhatsApp en `renderPk()` (1.32.0): `<a class="btn sm wa">` a `wa.me/${phoneWA(p.tel)}` al final de `.actions`, solo si `phoneWA` devuelve número. Corregir etiqueta (1.31.0): `data-act="rescan"` llama `scanCorregir(p)`, que pone `SCAN.fix=p.id`, cambia el título y abre `#scanCam`. `scanFile` rellena con los datos del paquete lo que el OCR no leyó; `scanSave` con `SCAN.fix` hace `Object.assign` de nombre, tel, dir, guía y nota, y cierra. `scanDupCheck` ignora el mismo paquete y `closeScan` limpia `fix`. Orden en `renderPk()` (1.30.0): orden estable por `rk(p)` (0 los que faltan, 1 entregado, 2 devuelto) y luego por índice original; `S.pk` no se reordena. Devuelto (1.29.0): `STATUS` agrega `['devuelto','Devuelto']` y la clase `.st-devuelto` en gris. `data-act="dev"` alterna entre `devuelto` y `stAntes`. `calcRoute` lo excluye y `renderStats` lo cuenta si hay alguno. `entSyncPk()` (1.29.1) recorre las paradas con `done` y pasa a entregado los paquetes que no estén `entregado` ni `devuelto`. Se llama en `render()` (con try, por el TDZ del primer render), en `renderEnt()` y con un `setTimeout` después de `entDone`. `guiaN()` normaliza las guías (O→0, I/L→1, sin espacios). `.estop .n.no` en amarillo `#f5c518` con texto grafito (1.35.0). 1.38.1: `renderPk` arma `enR` (id de paquete → parada con `entPkg`, dentro de try). Muestra el estado y `data-act="aruta"`, que llama `entAgregarPk(p)`: este agrega la parada con `pkFijo` y reordena con `EPOS`. Avisa si `p.ubic` no se puede leer con `parseCoord`. 1.41.0: en `renderPk()` el orden de `.actions` es paste, edit, Waze (si `c`), `del` ("Borrar"), `dev`, `rescan` ("📷 Escáner"), WhatsApp; desde 1.41.1 Escáner y WhatsApp van juntos en `span.scanwa` (columna flex) para que WhatsApp quede siempre debajo de Escáner; se quitó el link Maps de la tarjeta (en Ruta sigue). 1.52.4: `renderMsg` usa `enHold(p)` (parada de `entParadasDe` con `hold` y sin `done`): orden 0 pendiente, 1 hold, 2 entregado, 3 devuelto; hold lleva `.entregado` (gris) sin tachar el número y la etiqueta "⏸ hold". 1.52.3: `DEF_COORD4` reemplaza a `DEF_COORD3` una vez (bandera `S.coord4`) solo si `S.coord` sigue igual a `DEF_COORD3`. 1.52.2: en `renderStats` la etiqueta del contador `sinUb` es "Sin 📍". 1.52.1: `renderMsg` ordena con `rk` (pendientes, entregados, devueltos; estable por índice) y agrega `.entregado` a `.pkg` y `.tachado` a `.num` si `p.st==="entregado"`; no cambia los estilos de los botones. 1.51.1: `DEF_COORD3` (con `{nombre}`, `{yo}`, `{fecha}`) se asigna a `S.coord` una vez con la bandera `S.coord3`. 1.48.5: `entWaUrl` usa el texto nuevo; el tiempo va como ", en {t}" y se omite si no hay ETA. 1.48.4: `entWaUrl` agrega el bloque "Política de entrega" (texto de Victor, tal cual). 1.48.3: `.epin.hold.sel` mantiene el amarillo (solo crece). 1.48.2: `.epin.hold` (`#f5c518`, texto grafito) para paradas con `s.hold` no cerradas; `.sel` sigue pudiendo agrandarlo. 1.48.1: el prompt de `data-elink` con 1 a 3 dígitos (o `#62`) busca por `p.num` exacto. 1.48.0: `entPkg` ahora es `entPkgCand` (puntaje) + `entFuerte`; todo (eNum, entDone, chips, Lista, renderPk, diagnóstico) usa solo uniones seguras. `eNum` sin paquete devuelve "–". `entDone` incluye paquetes devueltos; `entDev(s)` para la etiqueta y para no contarlos como entregados. `entMod()` pone `S.ent.mod` en cargar, ordenar, Hold/Quitar/Entregado/Deshacer/Unir/Evidencia, `entAgregarPk`, `entPonerC` y `entCopiarPk`. `nubeMezclar` para `ent` llama `entMezclar(local,nube)`: distinta `at` → la más nueva; si no, gana `mod` mayor y se copian `done/at/gps` de la otra por clave `pkFijo||pkId||nombre|tel`. 1.47.2: `entUnirLibres` ya no une por palabras ni auto-agrega; solo una vez (`E.limpia147`) quita paradas `agregada && !done`. `entFuerte(s,p)` (pkFijo, guía, `nomN` igual o teléfono/`telsAnt`) decide si `entSyncPk` copia tel/nombre/guía/ubicación y marca entregado. `entParadasDe` usa `pkFijo` o `entPkg`+`entFuerte`. `entCopiarPk` fija `pkId`/`pkFijo` y, si el paquete editado no tiene parada y sí ubicación, llama `entAgregarPk`. 1.47.1: en `.acts3` va primero `data-ehold` y después `data-edone`. 1.47.0: `data-ehold="i"` en `.acts3` (solo si `s.c`) alterna `s.hold`; al ponerlo mueve la parada después de la última pendiente con `c`, renumera `n` y guarda; al quitarlo reordena con `entOrdenar` si hay `EPOS`. `entOrdenar` optimiza solo las pendientes sin `hold` y deja `held` después (si solo quedan en hold, las ordena a ellas). `erk` da 0.5 a las de hold (en `renderEnt` y en la Lista). `.ehold.on` amarillo `#f5c518`. 1.46.0: `#entLista` (en `#entTools`) reusa `#diagSheet`: cambia `#diagTitle` a "📋 Ruta en orden" y llena `#diagTxt` con las paradas en el orden de `renderEnt` (`erk`: pendientes con `c`, sin `c`, entregadas) como `k. #eNum nombre · tel`. `#supDiag` vuelve a poner su título y Compartir usa el título actual. 1.45.3: `parseCoord` primero prueba grados/minutos/segundos (`°`, `'`/`′`/`’`, `"`/`″`/`”`, coma o punto decimal, N/S y E/W/O) y devuelve 6 decimales si cae en Costa Rica; si no, sigue con decimal y geohash de Waze. 1.45.2: en `renderPk`, si `enR[p.id]` no tiene `c` y el paquete pendiente sí tiene ubicación, se muestra `data-act="aruta"` ("📍 Poner en la ruta"). `entAgregarPk` busca primero con `entParadasDe(p)` una parada sin `c` ni `done`; si existe le pone `c`, `n` = max+1, `pkId`/`pkFijo`, tel y nombre, borra `ub`/`waze` y reordena; si no, agrega una parada nueva como antes. 1.45.1: `renderPk` agrega `.sinub` cuando `!parseCoord(p.ubic)` y el paquete no está entregado ni devuelto; `#pkgList .pkg.sinub` lleva borde de 2 px `var(--bad)` (Mensajes no se toca). 1.45.0: `#p-buscar` (input search, 16 px para que iPhone no haga zoom) llama `renderPk()` en `input`. `renderPk` filtra con `ok(p)`: todas las palabras en el nombre (normalizado NFD local, no usa `sinTilde` por el TDZ del primer render), o la guía, o `p.num` exacto (1 a 3 dígitos), o 3+ dígitos del teléfono (últimos 8). Sin resultados muestra `.empty`. 1.44.5: `.acts` = `.eeta`, Waze, WhatsApp; `.acts2` = Quitar, Maps, Evidencia, Co-out; `.estop .eeta{flex:0 0 auto!important}`. 1.44.4: en `.acts` de `renderEnt` va primero Maps (`nav`) y luego Waze (`wz`). 1.44.3: la `.row` de `#scanCamBtn` y `label[for=scanGal]` va con `flex-wrap:nowrap`; la etiqueta dice "🖼️ Galería" (title con el texto largo). 1.44.2: `.estop .acts` sin salto (`nowrap`) con botones `flex:1 1 0` (tres iguales); en `.acts2` los botones crecen (`flex-grow:1`) y `.eeta` queda `flex:0 0 auto`; las dos líneas miden lo mismo. 1.44.1: *Mensajes* (`#msgList`) usa la misma tarjeta `.pkg`, así que el estilo de botones de 1.41.2 va con `#pkgList .pkg .actions`; `.pkg .actions` volvió a la regla original (columna 2, `flex-wrap:wrap`). 1.44.0: la tarjeta de `renderEnt` tiene `.acts` (Waze, Maps, WhatsApp `.wa`), `.acts2` (`data-equitar`, `.eeta`, `data-eok`, Co-out) y `.acts3` centrado (`.edone` grafito `#1f2125` o `data-eundo`), las tres con `grid-column:1/-1`. `.eeta` ya no ocupa toda la línea: `entEta` escribe `🚗 ~min<br>km` con `innerHTML`. 1.43.0: `entWaUrl(wa,t)` arma el `wa.me` con el texto "Estamos en camino…"; el link de la parada lleva `data-ewa="i"` y, en el click (sin `preventDefault`), se reescribe el `href` con `fmtT(el.dataset.min)` del `[data-eta=i]` (que `entEta` ahora guarda en `dataset.min`); sin ETA va sin el tiempo. 1.42.0: `data-equitar="i"` (en `.acts` de cada parada) con `confirm`; guarda `entPkg(s).id` en `S.ent.quitadas`, hace `splice`, `ESEL=-1`, `save()`, `render()` y `renderEnt()`. `entUnirLibres` excluye `quitadas` de los libres (no se auto-agregan) y `entAgregarPk` saca el id de `quitadas`. 1.41.2: sin `span.scanwa`; dos `.actions` (paste/edit/rescan; del/dev/WhatsApp) con `grid-column:1/-1`, `flex-wrap:nowrap` y botones `flex:1` de 12,5 px con elipsis; sin Waze. El aviso de ubicación ilegible es `.ubwarn` en la columna 2 (antes se metía en la columna del número). 1.40.1: `renderPk` agrega `.entregado` a `.pkg` (fondo `#eceef0`, `grayscale(1)`, opacidad .6; vuelve a 1 con `:focus-within`); los botones no se deshabilitan. 1.40.0: `.estop.ok .n` y `.epin.ok` con `text-decoration:line-through` (2 px); la tarjeta muestra `eNum(s)` también si está entregada sin `c` (antes "?"). En `renderPk`, `.num.tachado` (gris) si `p.st==="entregado"`. 1.39.2: `#supDiag` ya no copia: pone el texto en `#diagTxt` (`<pre>` con scroll, 12 px) dentro de `#diagSheet` y cierra `#supSheet`. `#diagShare` usa `navigator.share` (ignora `AbortError`) o `wa.me/${SOPORTE_WA}`; `#diagCopy` prueba `clipboard.writeText` y luego selección + `execCommand("copy")`. Sección nueva: paquetes con ubicación cuyo dueño (`entPkg` de cada parada) es una parada sin `c`, entregada, o más de una. 1.39.1: `#supDiag` lista las paradas sin `c` con `entPkg`, los paquetes con ubicación sin parada y las ubicaciones que no se leen (y el error con stack si algo falla). 1.39.0: `entUnirLibres()` (al inicio de `entSyncPk`) une cada parada sin paquete con el paquete libre de más palabras en común (de más de 2 letras, ×2) más la nota igual (+2), con mínimo 2 puntos, y agrega como paradas (`agregada:true`) los paquetes libres con ubicación que no estén entregados. `entPkg` cuenta `p.telsAnt` en el +1 de teléfono; Editar y corregir etiqueta guardan ahí el teléfono anterior. 1.38.2: `S.nums` es el respaldo {id:num} (en `NUBE_KEYS`). `numerar()` recupera de ahí el número que falte, numera los nuevos con max+1 (contando los quitados) y nunca reasigna uno existente; si `p.num` difiere de `S.nums`, gana `S.nums`. Se limpia solo con Vaciar lista, reemplazar al importar o al quitar el ejemplo. 1.38.0: `numerar()` (en `render()`): si falta algún `num`, la primera vez numera por índice; después cada nuevo recibe max+1, y llama `save()`. `.num` en Paquetes y Mensajes usa `p.num`. En Ruta, `eNum(s)` usa el `num` del paquete (`entPkg`) en la tarjeta, el pin y el popup, y si no hay paquete usa `s.n`. 1.37.3: `entSyncPk` copia también `nombre` (y `guia` si la parada no tiene) y siempre fija `s.pkId`. En `entPkg`, `pkId` vale +2 y cuenta antes del filtro `k>0`, así el paquete ya unido sigue siendo candidato aunque cambien nombre, guía y teléfono. 1.37.2: `entPkg` asigna puntos a cada candidato (guía +4, nombre +3 o +2, tel +1, `pkId` +1, ubicación +2) y en empate gana el `ing` más nuevo. `s.pkFijo` (puesto a mano con `data-elink`) manda sobre todo. Chip `data-elink` también con paquete cuando `!s.c`. 1.37.1: `geohash()` lo usa `parseCoord`. `entPkg` busca por nombre con `nomN` (igual) y después con `nom2` (dos primeras palabras). El chip `data-elink` sale cuando `entPkg(s)` no encuentra paquete: busca con un prompt (nombre, teléfono o guía), fija `s.pkId` y `render()` sincroniza. Ubicación a Ruta (1.37.0): en `entSyncPk()`, si `parseCoord(p.ubic)` difiere de `s.c` (más de 1e-5) se copia. Si la parada no tenía `c`, recibe el siguiente número, se borra `ub`, las que tienen `c` se ponen primero y, con `EPOS`, se llama `entOrdenar` (con setTimeout). Pestañas (1.36.0): sin `#tab-ruta`; el listener de `[data-tab="ruta"]` usa `?.`. `#v-ruta`, `calcRoute` y `renderRoute` quedan sin acceso desde la interfaz (`routeEta` para los mensajes sigue funcionando). `#tab-entrega` conserva su id y su `data-tab`, solo dice "Ruta". Orden en `renderEnt()` (1.35.0): la lista se ordena para mostrar con `erk(s)` (0 pendiente con `c`, 1 sin `c`, 2 `entDone`) y luego el índice; `data-ei` sigue siendo el índice real. `entSyncPk()` (1.35.1) además copia `p.tel` a `s.tel` cuando `phoneWA` difiere, y vuelve a pintar Entrega si está abierta. Teléfono a Entrega (1.34.0): `entParadasDe(p)` busca las paradas antes de editar (por `pkId` o `entPkg`); `entCopiarPk(p,ps)` copia tel, nombre y guía y fija `s.pkId`. `entPkg` ahora prueba primero `s.pkId`. Se usa en el guardar de Editar y en el de corregir etiqueta. Hora y GPS (1.33.0): `data-edone` guarda `s.at` y `s.gps` ({lat,lng,acc} de `EPOS`, o null) y los copia a `p.entAt`/`p.entGps`. Deshacer los borra. `renderPk` los muestra en `.ev` si no hay `pod`. Entregado en Paquetes (1.28.0): `data-edone` usa `entPkg(s)`, que ahora también busca por nombre igual con `sinTilde`. Pone `p.st='entregado'` y `p.entAt`, y guarda `s.prevSt` y `s.pkId` en la parada. `data-eundo` restaura `prevSt` si el paquete no tiene `pod`. Ambos llaman `render()`. Pie (1.27.1): `div.copy` con estilos en línea va después de `footer.appver` en `index.html` y `admin.html`, en letra de 11 px. Lupa (1.27.0): `#entBus` / `#entBuscar` entre `#entTools` y `#entMap`. `entBuscar(sig)` usa `sinTilde()` (NFD sin diacríticos): todas las palabras deben estar en el nombre, o 3 o más dígitos en el tel, o la guía. `EBUS.k` avanza con Enter. Pone `ESEL`, centra el mapa y hace `scrollIntoView` con block `end` por el mapa fijo. Tarjeta (1.26.4): `.acts` con los links, luego `.eeta` a todo lo ancho, luego `.acts2` sin salto de línea (Evidencia, Co-out, Entregado/Deshacer; 12,5 px, relleno 6 px). Botón `📲 Co-out` (`shortcuts://run-shortcut?name=Co-out`): se muestra en `.acts` de todas las paradas, después de WhatsApp (desde la 1.26.3). Sin ubicación: el chip `.eub[data-eub]` muestra `ubx`, que es `s.ub` o, si `s.ub` es `undefined` (ruta vieja), el `ubic` del paquete que coincide cuando no es una coordenada. que se convierte a "Co-out" si dice /^aplicaci[oó]n$/i, a "Vacío" si está vacío y a "Sin dato" si es `undefined`. `entUbicar(i)` hace `prompt` + `parseCoord`, o pone `EMAP.pickStop=i` y el click del mapa llama `entPonerC(i,c)`, que pone el siguiente número, la mueve con las demás que tienen coordenadas y llama `entOrdenar` si hay `EPOS`. Bandera `EAUTO`: en `gpsOk`, la primera lectura (acc < 500 m) llama `entOrdenar` si `S.ent.inicio` falta o queda a más de 0,8 km (`hav`); `entCargar` la reinicia y ordena de una vez si ya hay `EPOS`; el botón la pone en `true` para no ordenar dos veces. El punto azul (`.mepos`, `entMe()`) se actualiza con `watchPosition` mientras la pestaña está abierta. |
| `saveExcel()` | SheetJS `aoa_to_sheet` + `writeFile`: columnas de `plantilla-paquetes.xlsx` (`nombre, telefono, direccion, ubicacion, guia, nota`) más `fecha ingreso` (`p.ing`, dd/mm/aaaa) y `contacto` (`vcfName`). Teléfono en 8 dígitos. Reimportable: `COLS` ignora las columnas extra. En iPhone se entrega con `navigator.share` (`XLSX.write` tipo `array` → `File`), porque una web no puede elegir carpeta; aviso `#xlsIos`. |
| `p.ing` | Marca de tiempo de cuando se agregó el paquete (`mkPkg`). Los paquetes guardados antes de 1.17.0 la reciben al cargar. |
| `tidyName(s)` | Como `cleanName` pero sin poner mayúscula a todo (respeta *de*, *del*): solo baja la mayúscula pegada a una minúscula y quita guiones sueltos. Se usa en contactos, Excel y al reparar nombres viejos. |
| `#m-buscar` | Filtra la lista de Mensajes por nombre, guía o dígitos del teléfono (compara los últimos 8). Solo oculta tarjetas; la numeración se mantiene. |
| `CEDULA` | Texto *Recuerde que para la entrega debe presentar la cédula.* Va en `DEF_SIMPLE` (Coordinar) y `DEF_CAMINO`; se agrega una sola vez a los textos guardados `S.coord` (1.19.3, marca `S.cedula2`) y `S.camino` (1.18.4, marca `S.cedula`) si no mencionan la cédula. |
| `msgOpts()` | Mensajes que se pueden elegir en cada cliente: `coord`, `form` (solo si `config.js` tiene Supabase) y `camino`. |
| `msgSel(p)` | Mensaje elegido (`p.msgSel`); si no hay, propone `coord` y, ya enviado, `form`. |
| `msgText(p, k)` | Texto del mensaje `k`: `coordText`, `S.form` (`DEF_FORM`, con `{formulario}`) o `S.camino` con `{eta}` de `routeEta(p)`. Lo usan la vista previa, **Abrir WhatsApp** (`data-k`) y **Copiar**. |
| Selector `.msgsel` | Botones `data-act="msgsel"` (radiogroup). Al marcar *Enviado* se guarda `p.sent`, `p.formSent` o `p.caminoSent` según `data-k` y se borra `p.msgSel`. Antes de 1.14.0 había un botón aparte *📝 Mandar formulario* y *Abrir WhatsApp* siempre mandaba el primer mensaje. |
| `parseWin(texto)` | Convierte el horario del cliente en ventanas en minutos del día (`"2 a 4 pm"` → `[[840,960]]`; `"4 pm"` → 3:30–5:00; *mañana* 8–12, *tarde* 12–6, *noche* 6–9; `null` = cualquier hora). Horas sin am/pm de 1 a 6 se toman como pm. |
| `sched(ord, M, W, t0, min, ret)` | Recorre un orden con la matriz de minutos `M`: llegada, espera si llega antes y atraso. Costo = tiempo total + 3 × minutos tarde + 60 por parada tarde. |
| `optimize(pts, W, t0, min, vel, ret)` | Dos arranques (vecino más cercano por distancia y otro que considera horarios), luego búsqueda local con 2-opt y reubicación de tramos de 1 a 3 paradas sobre el costo de `sched`. Tope de 2,5 s. Con 70 paradas tarda menos de 1 s en PC. |
| `hav(a, b)` | Distancia haversine × 1.35 (factor por calles). |
| `syncResp()` | Llama `leer_respuestas` con todos los tokens. Corre al abrir, cada 60 s con la pestaña visible y al volver a la app. |

Los enlaces de Google Maps se parten cada 10 paradas (límite de waypoints en Maps URLs).

## 3. Formulario `entrega.html`

- GitHub Pages sirve `entrega.html` también como `/entrega` (sin extensión).
- Parámetros de URL: `t` (token, obligatorio, ≥12) y `n` (nombre). Acepta también `g` (guía) e `y` (repartidor) de links viejos.
- Pantalla final (`#done`): *¡Listo, gracias!* más el aviso de la cédula (1.18.3), resaltado en naranja.
- Sin vista previa (1.15.3): no lleva `og:image`, `og:title` ni `<title>` en el HTML (el título "RutaFácil · Su entrega" se pone con JS), para que WhatsApp no arme tarjeta de vista previa. Sin descripción: textos como "no pide pagos" generaban desconfianza.
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
- Librerías cargadas con `loadScript()` solo al escanear: zxing-wasm (`LIB_ZXW`, desde 1.96.0), ZXing JS de respaldo (`LIB_ZXING`) y Tesseract.js (`LIB_OCR`). Un solo worker de Tesseract (`SCAN.ocr`, idioma `spa`) por sesión.
- `scanCanvas(file, rot)`: reduce a 2000 px y gira de 90 en 90 (botón *Girar*).
- `readCodes(c)`: `BarcodeDetector` nativo si existe (Android); si no, ZXing con `TRY_HARDER` sobre la foto entera y por franjas, porque la etiqueta trae más de un código.
- `deskew(c)`: busca el ángulo (−12° a 12°, afinado a 0,25°) con el perfil de proyección de filas más marcado y endereza; con 2–3° de inclinación Tesseract pasaba de leer bien a no leer nada. Aplica gris y contraste.
- `parseLabel(texto, códigos)`: guía = código tipo `HZCR56461310263` (o regex en el texto); teléfono = 8 dígitos que empiecen en 2/4/5/6/7/8, prefiriendo líneas con *tel/cel*, y descartando dígitos de la guía; nombre = texto después de *TO/Destinatario/Nombre/Para* (o primera línea de 2–5 palabras); dirección = líneas con palabras de señas o provincias (`L_ADDR`), sin las del remitente (`L_SENDER`: Temu, China, aduana…).
- 1.96.0 (escáner más certero, probado con 3 fotos reales de etiquetas J&T inclinadas y con reflejo):
  - **Cámara en vivo** (`LIVE`, `liveStart/liveLoop/liveShot/liveStop`): `getUserMedia` con `facingMode: environment` e ideal 1920×1080 en `#scanVid` dentro de `#scanLive` (`.scanlive`, marco `.scanmarco`, verde con `.ok`). Cada ~120 ms se baja un cuadro a 1000 px y se busca una guía (`esGuia`: 2–5 letras + 8 o más dígitos) con `readCodesN` (BarcodeDetector) y `readCodesW` (`tryHarder:false`, solo QR y Code128). Al encontrarla vibra, toma el cuadro a resolución completa (`liveFrame(4000)`), apaga la cámara y lo pasa a `scanFile(blob)`. `liveYa(g)` evita volver a tomar una guía que ya está en la lista (salvo al corregir con `SCAN.fix`). Botones `#scanAhora` (toma ya), `#scanLuz` (`torch`, solo si `getCapabilities().torch`) y `#scanFotoAlt` (cámara normal). Si `getUserMedia` no existe o falla, `SCAN.live=false` y se usa `#scanCam` como antes. Se apaga en `closeScan` y al ocultar la página. `scanUI` tiene el modo `'live'`.
  - **zxing-wasm 3.1.6** (`LIB_ZXW`, IIFE global `ZXingWASM`, baja `zxing_reader.wasm` de fastly.jsdelivr.net): `readCodesW(c,opc)` devuelve `{t, qr, p:[4 esquinas]}`. `leerCodigos(c)` prueba nativo + wasm y, si no encuentra nada, la foto girada −30/30/−60/60° (`rotCanvas`); devuelve `{codes, qrs, c}` (la foto en que encontró). Si zxing-wasm no carga, cae a `readCodes` (ZXing JS de antes).
  - `recorteCliente(c, qrs)`: las etiquetas J&T tienen 2 QR abajo con la guía. Con sus esquinas se saca el ángulo y la distancia `d` entre QR; el bloque del cliente queda entre 0,44·d y 1,12·d por encima de la línea de los QR (de −0,3·d a 1,2·d a lo ancho). Con un solo QR se usa `d = 3,75 × lado del QR` y un ancho que cubre ambos lados. Se endereza y agranda a ~1500 px.
  - `binarizar(c)`: umbral adaptativo (promedio local con imagen integral, ventana = ancho/40, 0,86).
  - `leerTexto(L)`: pasadas `readText(recorte)` (PSM 6, el de siempre), `readText(binarizar(recorte),'11')` (texto disperso) y la foto entera; la primera manda y las otras solo rellenan campos vacíos; para con los 4 datos. Sin QR, una sola pasada sobre la foto como antes. `readText(c, psm)` cambia `tessedit_pageseg_mode` solo si hace falta.
  - `parseJT(lines)`: nombre después de *Nombre:* (o en la línea de abajo), sin *YC - Log*; teléfono de 8 dígitos después de *Tel:* (con O→0); dirección = líneas después de *C.P./Tel* hasta la que tiene 2 `/` (*Distrito/Cantón/Provincia*), descartando rayas y basura (menos de 55 % letras o más de 40 % de "palabras" de 1 letra), y cortando antes del remitente. `parseLabel` lo usa si la guía empieza con `JCR` o el texto trae *C.P … Tel*; si le falta algo, rellena con la lectura general de antes.
  - Prueba: `node` + Playwright con Chromium `--use-fake-device-for-media-stream --use-file-for-fake-video-capture=etiqueta.y4m` (hecho con ffmpeg desde la foto) y `http://localhost` (getUserMedia exige contexto seguro).
- *Guardar* abre la cámara **dentro del mismo toque** (iPhone no deja abrirla después de un `await`) y agrega con `mkPkg()`. Las fotos de etiqueta no se guardan.
- Prueba local: las CDN están bloqueadas en el sandbox; se instalan los paquetes con npm y Playwright sirve los archivos interceptando las URL de jsDelivr. Las etiquetas de prueba se generan con JsBarcode.

## 3c-0c. Reportes de Cierres (1.95.0)

- `repEstado(p)`: Entregado, Devuelto (incluye ⛔ Devolver), Hold, En ruta, Por entregar, Sin ubicación (usa `repParadas`).
- `repFilas(L)` ya no filtra: ordena por `EO` (orden de estados) y luego por `repT`; tiempo y km solo en entregados. `repResumen` suma `ruta` y `hold`; el encabezado del PDF tiene una cuarta fila (Hold) y la tabla empieza en `startY:46`.
- `guiGrupos()` toma todos los recibidos; `guiPdf` lista por `p.ing` con Estado y Hora escaneo. `guiEntPdf()` + `#guiFechaEnt` / `#guiEntBtn`: entregados cuyo `repDia(repT(p))` es la fecha elegida.
- La 1.93.0 (PR #18) se juntó con main en esta versión; `NUBE_KEYS` lleva `entr`, `h1`, `h2` y `gan`.

## 3c-0d. Ganancia, zonas y resumen en Cierres (1.93.0)

- **Marcado:** al inicio de `#v-cierres`: `.ganper` con `#ganPer` (`.segper`, botones `data-per` = `hoy|semana|mes|mespas`) y `#ganRango`; panel 💰 con `#ganCfgBtn`, `#ganCfg` (`#g-pago`, `#g-dev`, `#g-kml`, `#g-litro`, `#ganGuardar`), `#ganRes` (`.gangrid` de 4 `.stat`, 2×2 en celular; `.ganneto` en verde) y `#ganDias` (`.gandia` con `input[data-gas]`); panel 📍 `#zonRes` (`.zont`, `.zonlist`); panel 📊 `#resTxt`, `#resWa`, `#resXls` (naranja, a la derecha, `.ganacts`).
- **Datos:** `S.gan = {pago, pagoDev, kml, litro, gas:{'AAAA-MM-DD':₡}, dias:{'AAAA-MM-DD':{e,d,km,min,z:{zona:[entregados,devueltos,minutos,tramos]}}}}`. `'gan'` está en `NUBE_KEYS`. `ganS()` lo crea si falta. `pago` vacío = `GAN_PAGO` (500); `kml` vacío = `GAN_KML[S.veh]` (moto 30, carro 12, buseta 8).
- **`ganActualizar()`:** agrupa `repTodos()` por día de entrega (`repDia(repT(p))`) y de devolución (`repDia(p.devAt)`), y con `ganDiaCalc(E,D)` usa `repTramos`/`repTotales` (los mismos km y horas del PDF) y `zonaDe(p)`. Un día solo se reemplaza si ahora hay igual o más paquetes (cuando un cierre se borra, el día queda como estaba). Borra días con más de `GAN_DIAS` (70). Se llama al abrir Cierres, cuando llegan los cierres guardados (`repCierres`) y al empezar `cerrarDia` (Vaciar lista).
- **`zonaDe(p)`:** con `repCoord(p)` toma el punto más cercano de `ZONAS` (`[nombre, lat, lng, alias]`, distancia `hav/1.35` = línea recta, ≤ 12 km; si no, "Fuera de la GAM"). Sin coordenadas, busca los alias (sin tildes) en `p.dir` + `p.senas`; gana el alias más largo. Si no, "Sin ubicación" (no entra al ranking).
- **`ganPeriodo(per)`:** `ganRango` (semana = lunes a hoy) → días, totales `T`, gasolina por día (`ganGasDia`: anotada en `gas[k]` o `km / kml × litro`), y rankings `rap` (≥ 2 tramos, min. promedio asc.) y `dev` (≥ 2 paquetes, % devueltos desc.), 5 cada uno. `ganPintar()` pinta todo; `ganTexto()` arma el WhatsApp; `ganWa()` usa `navigator.share` en Android/iPhone o `wa.me/?text=`; `ganXls()` usa `cargarXlsx()` y en iPhone comparte el archivo (`resumen-semana-DD-MM-AAAA.xlsx`, fechas en pantalla y en el Excel como dd/mm/aaaa; hojas *Resumen* y *Zonas*). Colones con `ganCol(n)` → `₡18.500`.
- **Rentabilidad:** `ganRentaCalc(T)` → `pkNeto` (neto ÷ entregados), `pkMin`, `pkKm`, `pkGas`, `hora` (neto ÷ horas) y `km` (neto ÷ km); `ganRenta(T)` pinta `.ganrent`/`.ganrent3` dentro de `#ganRes`; `ganRentaFila(T)` agrega 5 columnas al Excel. Las zonas guardan además `[4]` km de tramos y `[5]` cuántos tramos con km (los días viejos con 4 valores siguen sirviendo). `ganPeriodo` arma `renta` (≥ 2 tramos, `(pago − kmProm × litro/kml) ÷ minProm × 60`, mayor primero); va arriba del ranking, en el WhatsApp y en la hoja *Zonas* (*Km promedio por entrega*, *₡ por hora*).
- **Diseño:** botones de período tipo píldora (naranja = elegido); "Guardar tarifas", "WhatsApp" y "Excel" en naranja con letra blanca en negrita, compactos y a la derecha.

## 3c-0c. Voy en camino: Waze al volver de WhatsApp (1.78.0)

- Un navegador no puede abrir dos apps con un solo toque, y abrir Waze sin que la persona toque se bloquea (no es gesto del usuario). Por eso es en dos pasos.
- El clic en `[data-ewa]` (botón WhatsApp de cada parada en Ruta) guarda en memoria `EWZ={wz,nombre,n,at}` con el link de Waze de esa parada (`s.waze` o `waze.com/ul?ll=…&navigate=yes`). No se guarda en `S`.
- Un `visibilitychange` (al volver a la app) muestra el aviso `#wzSheet` si pasaron menos de 15 min y Ruta está a la vista; `EWZ` se borra al primer regreso. `#wzGo` es un `<a>` (toque real → abre Waze); `#wzNo` y tocar fuera cierran.
- Diseño: aviso de abajo como los demás `.sheet`, botones a la derecha, el principal naranja (`.btn.primary`).

## 3c-0b. Pestañas al instante (1.77.0)

- **Por qué era lento:** el clic de una pestaña corría todo en el mismo turno (y `requestAnimationFrame` corre *antes* de pintar), así que el botón no se iluminaba hasta terminar de pintar la lista. Y `entPkg(s)` (paquete de una parada) recorre todos los paquetes normalizando nombre, teléfono, guía y ubicación; `entParadasDe(p)` lo llama por cada parada, y `renderMsg`/`renderPk`/`renderStats` lo llamaban varias veces por paquete (incluso dentro del `sort`): O(n³) normalizaciones.
- **`memoTxt(fn, copia)`** (arriba de `KEY`): memoria `Map` para funciones de texto **puras** (solo strings; otros tipos pasan directo; se vacía a los 5000). La usan `parseCoord` (devuelve copia del arreglo), `phoneWA`, `guiaN`, `nomN`, `nom2` y `sinTilde`. Solo envolver funciones que no lean `S` ni nada externo.
- **`trasPintar(fn)`** = `requestAnimationFrame` + `setTimeout 0`: corre `fn` después del primer pintado. El cambio de pestaña lo hace `RF_TAB` (captura); el `onclick` de cada pestaña solo agenda con `trasPintar` lo pesado (`renderPk`/`renderMsg` pendientes, Cierres, ajuste de alto de textos de Mensajes, `renderEnt`) y revisa con `aLaVista()` que la pestaña siga abierta.
- `renderMsg`, `renderPk` y `renderStats` calculan el hold y las paradas de cada paquete **una vez** por pintada (`Map` local `HOLD`/`PAR`).
- Ruta: se quitó el `nubeSync().then(renderEnt)`; si la nube trae cambios, `nubeAplicar()` → `render()` ya repinta la pestaña visible.
- Se quitó el `addEventListener('click', subAbrir(null))` repetido de las pestañas (`RF_TAB` ya lo hace).
- Verificación: el HTML de `#stats`, `#pkgList`, `#msgList`, `#entList`, `#entInfo` y `#repLista` es idéntico antes y después con 40 paquetes mezclados (tildes, hold, devueltos, sin ubicación, paradas unidas por nombre/teléfono/guía).

## 3c-0a. 20 mensajeros (1.74.0)

- **Datos locales por cuenta:** `cuentaLocal(c)` (junto a `toast`) se llama en `RF_AUTH.listo` y en el evento `rf-cuenta`. `S.owner` guarda el número (8 dígitos) de la cuenta dueña de `localStorage['rutafacil-cr-v1']`. Si entra otra cuenta: si `S.dirty`, la lista vieja se aparta en `rutafacil-cr-v1@<número>`; si no, se borra (ya está en la nube). Se carga la de la nueva (o `{owner}` vacío) y se recarga la página. Las fotos en IndexedDB no se tocan: sus ids son aleatorios y solo se suben desde los paquetes de la lista abierta. `fixIng1031()` sigue igual (corre en `nubeAplicar`).
- **Nube liviana:** `nubeLeer(force)` manda `p_version` a `rf_lista_leer`; con `sin_cambios` no hace nada. Con `force` (☁️) o sin versión baja todo. Si la base no tiene la función nueva (404/PGRST202) marca `NUBE.vieja` y usa la llamada sin parámetros.
- **Respuestas por partes:** `syncResp` guarda `S.respDesde` (la mayor `updated_at` vista) y `S.respDesdeN` (cantidad de paquetes en ese momento); cada minuto pide `p_desde` y, si cambió la cantidad de paquetes o se tocó *Revisar*, pide todo. `syncResp.vieja` = base sin `p_desde`.
- **Fotos:** `fotosNube()` lee `RF_AUTH.cuenta.fotos_nube` (`'todas'` si la base es vieja). En modo `una`, `uploadPOD` sube solo `rec.fotos[0]` pasada por `achicar(blob,640,.6)` más la firma, y marca `rec.una`. `limpiarNube()` (desde `uploadPending`, una vez al día con `S.nubeLimpia`) pide `rf_evidencias_viejas` y borra con `DELETE /storage/v1/object/evidencias {prefixes}`; la política de la base impide borrar fotos ajenas o no vencidas.
- **Listas grandes:** `render()` pinta Paquetes y Mensajes solo si su pestaña está a la vista (`PEND.pk/msg` + `aLaVista`); el clic de la pestaña pinta lo pendiente. `renderPk()` pinta 60 tarjetas y agrega el resto en tandas de 100 (`renderPk.tk` cancela tandas viejas); `#pkgList>.pkg` lleva `content-visibility:auto`. Medido con 817 paquetes y CPU 6× más lenta: `render()` de ~5 s a ~0,6 s.
- **Respuestas:** `syncResp` manda solo tokens de paquetes no entregados ni devueltos (máx. 300; la base acepta 1000).
- **Aviso de cierres:** `diasCierres()` lee `RF_AUTH.cuenta.dias_cierres` (lo manda `rf_mi_cuenta`); `repLista()` llena `#cierreAviso` y marca las fechas con `repBorraEn(k)` ≤ 3 (cuenta desde la fecha de recibido, así avisa antes, nunca tarde).
- **Cierres en el celular:** `cierreLeer(id)` usa IndexedDB `rutafacil-cierres` (clave `<owner>:<id>`), y solo llama `rf_cierre_leer` si no está.
- **Fotos `ninguna`:** `uploadPOD` registra la entrega sin subir fotos y marca `rec.sinNube`; `cleanLocal` las guarda `LOCAL_DIAS_SIN_NUBE` (30) días.
- **Diálogos (1.75.2):** `dialogo()` se publica como `window.RF_DIALOGO` y acepta `campos:[{label,valor,tipo:'text'|'tel'|'number',placeholder,ayuda,copiar,largo}]`: con campos devuelve la lista de valores o `null`; Enter envía. `ponerCSS()` inyecta el CSS aunque no haya Supabase. En `index.html`, `pedir(o)` envuelve un solo campo (con `prompt` de respaldo si falta `auth.js`) y se usa en 🚦 Tráfico, `entUbicar` (ahora `async`) y unir parada (`data-elink`). En `admin.html`, `D(o)` reemplaza todos los `confirm`/`prompt`: Registrar pago (3 campos), PIN nuevo (confirmar + mensaje con Copiar), Suspender, Liberar, Nombre, Borrar fotos y días de cierres. `rfConfirm` de `index.html` (preguntas de Paquetes, Ruta y Entrega) ya era propio y no cambió. Regla: **no usar nunca `confirm/alert/prompt`**.
- **SINPE (1.76.1):** `rf_ajustes.sinpe` guarda hasta dos números de 8 dígitos separados por coma (`62700666,88202220`, 17 caracteres; la función recorta a 20). `admin.html` los saca con `/\d{8}/g` y los muestra con `tel()`; `sinpes()` en `auth.js` los pinta como «al X o al Y». El WhatsApp de soporte (`SOPORTE`, `privacidad.html`, `conoce.html`) es otra cosa y sigue fijo en 6270 0666.
- **Número alterno (1.76.0):** `numeroEntrar(t)` en `auth.js` llama `rf_numero_entrar` y devuelve el número principal (o el mismo si falla la llamada); el correo de login sale de ese número. Se usa en Entrar, en Crear cuenta (si el número resuelve a otro, muestra *Ese número ya tiene cuenta*) y en el login después de recuperar. En `admin.html`, panel *Tu número alterno* (`#a-alterno`, `#a-alterno-ok`) → `rf_admin_alterno`; se llena con `telefono_alterno` de `rf_mi_cuenta`. `EVENTO.alterno` = *Número alterno del administrador*.
- **Diálogo de cuenta (1.75.1):** `dialogo({ico,titulo,texto,si,no,mal})` en `auth.js` devuelve una promesa (true/false) y reemplaza `confirm()`/`alert()` en el pie (*🔑 Código de recuperación*, *Salir*). Clases `.rfadlg*` en el CSS de `auth.js` (funciona igual en la app y en el Panel): caja redonda, ícono en círculo naranja suave, botones a la derecha, el principal `--accent` con letra blanca en negrita. `texto` acepta HTML (ya escapado por quien llama); `no:''` deja un solo botón. Cierra con Escape o tocando afuera.
- **`auth.js`:** `vRecuperar(tel, cambio)` → `rf_recuperar` → login con el PIN nuevo → `vCodigo`. `mostrarCodigoNuevo` después de *Crear cuenta*. Pie: *Código de recuperación* (`rf_codigo_nuevo`). `vEstado` (otro teléfono) ofrece el código. `abrir()` en el Panel llama `vPinAdmin` si `KA` tiene más de `ADMIN_HORAS`.
- **Panel (`admin.html`):** sección *Uso del plan gratis* (`verUso` → `rf_admin_uso`, barras `.ubar`, tabla `.utab` con scroll horizontal propio) y en *Fotos de entrega* los campos `#f-modo` / `#f-nube` que guardan con `rf_admin_fotos`. Botones naranja a la derecha.
- **Pruebas hechas:** `supabase.sql` corrido dos veces en Postgres 16 con stubs de Supabase; dos cuentas: B no lee respuestas, lista, cierres ni fotos de A, no pisa entregas de A y solo borra sus fotos vencidas. En el navegador (Playwright, 375 px, Supabase simulado): al pasar de la cuenta A a la B, la lista de A desaparece y B abre vacía.

## 3c-0. Mapa rápido de lo agregado de la 1.53 a la 1.68

| Tema | Dónde | Funciones / datos |
|---|---|---|
| Reportes (Cierres) | `#repLista`, `.replin`, `data-rep` | `repCargar` (jsPDF 2.5.1 + autotable 3.8.2, cdnjs), `repCierres` (`rf_cierres_listar`, `rf_cierre_leer`), `repTodos`, `repGrupos`, `repT`, `repTramos`, `repTotales`, `repResumen`, `repFilas`, `repPdf`, `repEntregasDe` |
| Hora real de entrega | `entSyncPk`, `data-edone` | `s.at`, `p.entAt`, `p.entGps`, `p.devAt` |
| Jornada | `#jorBar` | `S.jor`, `jorRender`, `jorGps` |
| Vehículo | `#vehSel` | `S.veh` (en `NUBE_KEYS`), `vehPintar`, `vehIcono`, `conVeh` |
| Devolver / Devuelto | `.devol`, `.devkeep`, `devBar` | `p.devolver`, `s.devolver`, `pkDevol`, `pkOff`, acciones `devok`, `devno`, `dev` |
| Orden de Paquetes | `renderPk` | `rk`: activos 0, Hold 1, devueltos 2, entregados 3 |
| Pestañas a prueba de fallas | inicio del `<script>` | `RF_TAB`, listener de `error` |
| Ruta por calles | mapa | `osrmCadena`, `RTOT.geo`, `entLinea` |

## 3c-quindecies. Tarjeta desactivada por Devolver (1.66.0)

- 1.94.0 (lista de noviembre):
  - `notasMay()` (al inicio de `render`) y `mkPkg` pasan `nota` a mayúsculas; `#f-nota` con `text-transform:uppercase`.
  - `renderStats`: contador `enRuta` (pendiente con parada con `c`, sin Hold, sin `done`) y clases `.stat.s-rec/.s-ent/.s-ruta/.s-hold/.s-dev/.s-sin`; en el celular la grilla es de 3×2.
  - Tarjeta de Paquetes: `.meta` con Guía y Tel. antes de `.addr` (`#pkgList .pkg>:is(.name,.meta,.addr){grid-column:2}`); `pkChip` pone `⛔ Devolver` arriba y `devBar(p,1)` ya no repite la etiqueta; `.devtag` y `.devbtn` en rojo `#c0392b`.
  - `pkSacarDeRuta(p)` quita las paradas pendientes; `dev` y `devno` llaman `entAgregarPk` con ubicación (aunque no haya ruta abierta) o `pkSacarDeRuta` sin ella. `aruta` sin ubicación la pide con `pedir()`.
  - Orden: `pkEntT(p)` y `pkGrupoT(p)` (entregado → hora de entrega; devuelto → `devAt`; ⛔ Devolver → `devolverAt`; Hold → `s.holdAt`) después de `rk` en `renderPk` y `renderMsg`.
  - 1.95.3 (🎯 Elegir en el mapa): en el celular Leaflet descarta el `click` del mapa si el dedo se mueve más de 3 px (`clickTolerance` de `Draggable`) y el toque sobre un pin iba a `entSel`. Ahora `entMapaCrear` escucha `pointerdown`/`pointerup` en captura sobre el contenedor y, si `entPicking()`, un solo dedo y ≤ 14 px, llama `entPickTap(EMAP.mouseEventToLatLng(e))`; el `click` de Leaflet queda de respaldo. `entPickModo(on,txt)` pinta el modo (`#entMap.picking`, `#entPick.on`, aviso `.pickban` con ✖ Cancelar dentro del mapa, con `L.DomEvent.disableClickPropagation`). El clic del pin no llama `entSel` mientras se elige ni 800 ms después (`EMAP.pickAt`). `entUbicar` usa el mismo modo con `EMAP.pickStop`.
  - 1.96.8: `#msgFil` queda `hidden` y no se llena; `MSGF` siempre `todos` (el código de `FIL` queda por si se vuelve a pedir).
  - 1.96.7: `msgFab196` también cambia a `DEF_COORD6` si `S.coord` coincide con `/nos gustar[ií]a coordinar la entrega/i`.
  - 1.96.6: `DEF_COORD6` (migra desde `DEF_COORD3`–`5` en `msgFab196`); de noche `pkCoordText` antepone `DISC_TIT`, pone `DISC_HORA` en la línea siguiente al saludo y cambia el "¡Gracias!" final por "¡Gracias! Buenas noches".
  - 1.96.5: `DEF_COORD5`; `msgFab196()` lo pone si `S.coord` seguía igual a `DEF_COORD3`/`DEF_COORD4` (se llama otra vez después de las migraciones `coord3`/`coord4`). `DISC_HORA` nuevo y `pkCoordText` lo mete después del primer párrafo; `msgText(p,"coord")` usa `pkCoordText` y el clic en *Abrir WhatsApp* con `k==="coord"` recalcula el link.
  - 1.96.4: `entPosManual(c)` pone `EPOS={c,acc:0,manual:true,gps0}` (punto azul, `entLinea`, `entEta`, `entTotal` lo usan) y `EAUTO=true`. `gpsOk(g,forzar)` no pisa una `EPOS.manual` mientras el GPS real esté a menos de 200 m de `gps0` (la primera lectura). `📍 Ordenar desde aquí` llama `gpsOk(g,1)`. `s.gps` (prueba de entrega) y `jorGps` ignoran `EPOS.manual`.
  - 1.96.3 (🎯 Elegir en el mapa): `entPickTap` llama `entPickEspera(c)` (pin `.mepos.pickpt` en `EMAP.pickPin` y aviso `.pickban.busy`) y, al terminar `entOrdenar`, `entPickSalir()` quita ambos y hace `#v-entrega.scrollIntoView` (la app se desplaza dentro de `#app`, no en `window`; por eso `window.scrollTo` no sirve). `entOrdenar` limpia `#entGps` después de `osrmMatriz` aunque no haya GPS.
  - 1.96.2: nuevos `DEF_CAMINO`, `DEF_COMP`, `DEF_ENTR`, `DEF_H1`, `DEF_H2`; `OLD_MSG196` guarda los anteriores y `msgFab196()` (al iniciar y en `nubeAplicar`) cambia solo los que siguen iguales al texto de fábrica (normaliza espacios; en `camino` ignora `CEDULA` y "¡Gracias!"). El 🚙 de En camino lo sigue poniendo `conVeh`. Etiqueta `h1`: "Horario 8 a 12 md".
  - 1.96.1: `renderMsg` — `enHold` se define antes de `FIL`; `FIL` es una partición (`sin/nr/ok` usan `act2` = activo y sin Hold; `hold`, `dev` sin devueltos, `ent`, `devu`) para que la suma dé `S.pk.length`. La tarjeta en Hold ya no lleva la clase `entregado` (botones habilitados), sigue el orden después de los pendientes.
  - 1.95.7: el botón `data-act="paste"` lleva `primary` solo si `!c` (sin coordenadas).
  - 1.95.6: texto del botón `data-act="paste"` y de `#pasteTitle`: "Pegar ubicación".
  - 1.95.5: `pkChip` devuelve `.msgst.ms-hold` si alguna parada del paquete está en Hold; borde negro con `#pkgList .pkg:not(.entregado):not(.devol)` y `.sinub` con la misma especificidad en rojo.
  - 1.95.4: `.pkg .name>:is(.chip,.msgst,.coordbtn){margin-left:auto}`; `#pkgList .pkg:not(.entregado)` con borde `2px solid var(--ink)` y `.sinub` vuelve a rojo después.
  - 1.95.2: `devBar` ya no pinta la etiqueta (ni en Paquetes ni en Mensajes); la etiqueta va en `pkChip` / `msgChip` y `#v-mensajes .pkg .name>.msgst.ms-dev` lleva `margin-left:auto`.
  - 1.95.1: en `msgOpts()` `ext` (Horario extendido) va de último; los números salen solos del orden (`i+1`) y las etiquetas de `#tplPanel` se renumeraron a mano.
  - Mensajes: `msgChip(p,hold)` con `.ms-ent`, `.ms-dev`, `.ms-hold`; `msgOpts` suma `hablar`, `entr`, `h1`, `h2` (`DEF_ENTR`, `DEF_H1`, `DEF_H2`, textareas `#m-entr`, `#m-h1`, `#m-h2`); `waLink` sin texto abre `wa.me/<número>` limpio.
  - Ruta: Tel. (`.etel`) y nota (`.pknota`) en `.estop`; pines `.epin.dev` para devueltos sin parada (`zIndexOffset:-2000`); `entrAvisar(p)` abre `#enSheet` tras `data-edone`; `data-eundo` saca la parada y agrega el id a `S.ent.quitadas`; `data-edevol` pide nota con `pedir()` y confirma con `rfConfirm`; `entWaUrl` con 3 líneas más; `#entLista` agrupa Hold y pendientes.
  - `.camwa` (📷 blanco), `.pknota` con letra `#1f2125`, encabezado de PDFs "Entregado por". `fixAleja()` (arreglo único en la cuenta 62700666, se llama en `nubeAplicar`, marca `S.fixAleja`): borrar en una versión futura.
  - Marco de iPhone: script al inicio de `<head>` redirige a `marco.html` (pantalla ≥ 900 px, `hover:hover`, `pointer:fine`, `window.top===window`, sin `?marco=no`); dentro del iframe se agrega `html.enmarco` (espacio para la isla). `#diagShare` usa `window.open` dentro del iframe porque wa.me no deja abrirse en un iframe.
- 1.92.4: `esTarde(d)` (21:30 a 4:59), `DISC_HORA` y `pkCoordText(p)` antepone la disculpa; lo usa `pkChip` y el clic `data-act="sent"` de `.coordbtn` recalcula el `href` al tocar (la hora de pintar puede ser vieja). Mensajes sigue con `coordText`. La nota en Paquetes va en `<div class="pknota">` (fondo #e0a100, letra blanca en negrita).
- 1.92.3: en `renderPk`, `rk(p)` = 0 con coordenadas (`parseCoord`) o con parada en la ruta (`enR`), 1 Hold, 2 sin ubicación ni ruta, 3 devuelto / ⛔ Devolver, 4 entregado; empates por orden de la lista. `enR` se calcula antes de `rk`.
- 1.92.2: helpers `fDMY(t)` (dd/mm/aaaa), `fDMYh(t)` (con hora) e `isoDMY(x)` (cambia AAAA-MM-DD a dd/mm/aaaa solo para mostrar; el nombre guardado de la ruta y los nombres de archivo siguen en ISO). `fmtDT`, `tomorrow`, `repEntregasDe`, el encabezado de Ruta y `#entInfo` los usan; `admin.html` y `auth.js` tienen su propio `fecha`. `FIL.dev` = `p.devolver && p.st!=='entregado'` con su botón `dev` en `#msgFil`. Tarjeta de Paquetes: `<a class="btn sm wa">📷</a>` con `https://wa.me/<tel>` antes del botón *WhatsApp*.
- 1.92.1: `.vcfrow`, su `<p>` y los avisos `#xlsIos` / `#vcfIos` se movieron a `#vcfPanel`, después de `#msgList` y `#syncPanel` y antes de `#tplPanel`.
- 1.92.0: en Mensajes la etiqueta es `msgChip(p)` (un `<span class="msgst">`, no se toca) con `msgEst(p)`: `ok` si `p.st==='confirmado'` o tiene coordenadas, `esp` si `p.sent`, si no `sin`. Los filtros `FIL` usan `msgEst`. En Paquetes y Ruta `p.st` sigue igual; `stChip` ya no se usa en Mensajes.
- 1.91.1: en `msgOpts` la clave `coord` se muestra como "Pedir ubicación" (la clave interna sigue siendo `coord`).
- 1.91.0: `#jorBar` vive dentro del primer `.enthead` (después de `#entAqui`), sin cuadro (`.enthead .jorbar`), y sin iniciar solo muestra el botón (la ayuda va en `title`); iniciada muestra `⏱ hora`. `gpsOk` y `entOrdenar` ya no escriben "Estás aquí" en `#entGps` (solo avisos: buscando, calculando, error), que ocupa su propia línea (`flex-basis:100%`). `pkChip` devuelve vacío si `parseCoord(p.ubic)`; el texto es "Pedir ubicación". Mensajes: sin el `<p>` de ayuda, sin `<h2>Clientes</h2>`, sin `data-act="paste"` en la tarjeta, y `#syncPanel` con `display:none!important` (`syncResp` sigue corriendo).
- 1.89.0: `msgOpts` ya no incluye `form` (el texto `S.form` y `#m-form` se conservan, ocultos) y `msgSel` cae siempre en `coord`. En la tarjeta de Mensajes se quitaron `data-act="copy"` y `data-act="set"` (Confirmó / No responde); el estado se cambia con el chip `data-act="st"`. `.msgsel` es una cuadrícula 2×2 y `.msgacts` alinea a la derecha (Pegar respuesta, luego Abrir WhatsApp). `#diagSheet` lleva la clase `.rfwin` (centrada, `#diagIco`, `#diagSub`, `.rfwin-btns` a la derecha); los títulos se ponen sin emoji y el ícono en `#diagIco`.
- 1.88.0: `#msgFil` (debajo de `#m-buscar`) lo pinta `renderMsg` con la variable `MSGF` (`todos`, `sin`, `nr`, `ok`; solo en memoria). `FIL` filtra por `p.st` entre los activos (`act`: sin entregado, devuelto ni `devolver`) y `hit` combina filtro y búsqueda (`hit0`). Si nada coincide, la lista dice "Ningún cliente en este filtro". Estilo `.msgfil`: píldoras de 12px; la activa en `--accent-btn` con letra blanca.
- 1.87.2: la rama vacía de `renderEnt` solo aplica sin ruta, o con ruta vacía cerrada o sin nombre (después de *Vaciar lista*). Una ruta abierta con `stops` vacío sigue por la rama normal, con todas sus herramientas, y la lista dice "No quedan paradas en esta ruta".
- 1.87.1: en la rama vacía de `renderEnt`, `#entInfo` queda vacío y se oculta (`#entInfo:empty{display:none}`). `.jorbar` con menos relleno (6px 8px, margen 6px) y `.jtxt` a 12,5px. Texto de `jorRender` sin iniciar: "Al salir: guarda hora y punto de salida."
- 1.87.0: `[data-edevol]` en Ruta, si la parada tiene paquete unido, pone `p.devolver=true`, agrega el id a `S.ent.quitadas` y hace `splice` de la parada (sin paquete queda como antes, `s.devolver`). `entSacarDevol()` (al inicio de `entSyncPk`) saca las paradas viejas con `devolver` sin entregar unidas con `entFuerte`. `devno` en Paquetes llama `entAgregarPk` si el paquete ya no tiene parada y tiene ubicación (eso lo saca de `quitadas`). `entCopiarPk` no re-agrega paquetes con `devolver`, y la tarjeta no muestra *➕ Agregar a la ruta* para ellos.
- 1.86.2: `entPonerC` (poner ubicación a una parada desde Ruta) ya copiaba la coordenada a `p.ubic`, pero solo repintaba Ruta, así que la tarjeta de Paquetes quedaba vieja. Ahora, si copió al paquete, fija `pkFijo` y llama `save();render()`. Ojo: desde la 1.63.0 el `s.n=...` de esa función quedó dentro del comentario `//` de la misma línea (no se ejecuta); el número lo pone después `entOrdenar`.
- 1.86.1: el mapa de Ruta nunca se oculta. `entMapaCrear()` (sacado de `renderEnt`) crea `EMAP`; la rama de ruta vacía o cerrada muestra `#entGps`, llama `entVigilar()`, crea el mapa, pinta `entMe()` y centra una vez (`EMAP.fitted='vacio'`; `entMe` re-centra a la primera posición GPS con `EMAP.meC`). Con ruta, `fitBounds` solo si hay paradas con `c`. `entAgregarPk` crea `S.ent={nombre:'Ruta AAAA-MM-DD',stops:[]}` si no hay ruta, está vacía o `cerrada`. Al guardar Editar, si el paquete tenía coordenadas y ya no, a sus paradas sin terminar se les borra `c` y `ub`. El auto-orden de `gpsOk` exige al menos una parada con `c`.
- 1.86.0: `#n-ruta` (span `.n` en la pestaña Ruta) lo llena `rutaGlobo()` desde `renderStats` y `renderEnt`: paradas de `S.ent.stops` con `!entDone(s)` (0 si la ruta está cerrada; vacío si no hay). `entDone` es `const` más abajo: en la primera pintada da error de TDZ, el `try` deja 0 y se corrige en la pintada final.
- 1.85.2: en modo a mano `pickAbrir` ya no busca (return antes de `pickTodos`; el código de búsqueda queda sin usar), `#pickBusca` va `hidden` y `#pickAviso` dice que se guíe por la tarjeta. `pickTodos`, `pickTomTom`, `pickOsm` y `pickLista` se pueden borrar más adelante.
- 1.84.1: se quitaron `#pickPedir`, `PIDE_UBIC` y `p.pideUbic`; `#pickNeg` solo trae la guía de Waze y `#pickAMano`.
- 1.82.0: `pickAbrir(p,t,mano)`: con negocio pegado y sin `mano` (`guia`) muestra `#pickNeg` (título "📍 Falta la ubicación", `#pickPedir` = `waLink(p, fill(PIDE_UBIC,p))`, guía de Waze) y esconde `#pickManual` y `#pickOk`, sin buscar. `#pickPedir` marca `p.pideUbic` y cierra. `#pickAMano` llama `pickAbrirMano` (= `pickAbrir(p,t,true)`) con el buscador y la lista de antes.
- 1.81.5: el autoseleccionado exige que todas las palabras del nombre pegado (3+ letras, sin "bar", "restaurante", "soda", etc.) estén en `x.nom` (sin tildes) y `km<=PICK_KM`; si no, `pickLista(R,null)` y el mapa vuelve a `PICK.ref`.
- 1.81.4: sin límite de distancia. `pickTodos(q)` junta `pickTomTom` (hasta 6, sesgo `lat/lon` sin `radius`) y `pickOsm` (Nominatim, 6, sin `viewbox`), quita repetidos a menos de 150 m, calcula `km` desde `PICK.ref` y ordena por cercanía. `pickLista(R,auto)` pinta `#pickRes` (`.pickopt`, `aria-pressed`) y `pickElegir(i)` pone el pin. Se marca solo el primero si `km<=PICK_KM`.
- 1.81.3: `pickRef(p)` = mediana de las coordenadas de los demás paquetes (3 o más), si no `EPOS`, `S.start` o San José; se guarda en `PICK.ref`. TomTom recibe `lat`, `lon` y `radius` (`PICK_KM`=30 km) y Nominatim `viewbox` con `bounded=1`. Si un resultado queda a más de `PICK_KM` (`pickKm`, `hav` sin el ×1,35) no pone pin y avisa.
- 1.81.2: `pickTomTom(q)` usa TomTom Search (`/search/2/search/{q}.json`, `countrySet=CR`, `S.ttKey`) y solo cuenta como hallazgo exacto si `type==="POI"`; se prueba antes que Nominatim. `#pickBusca` (`#pickQ`, se llena con nombre y zona pegados) busca a mano: TomTom y si no Nominatim, pone el pin.
- 1.81.1: `pickAbrir` prioriza lo pegado: si `lugarDe(t)` trae nombre o zona ignora `p.ubic`; limpia la zona (sin código postal ni `CR-SJ, CR`), prueba en Nominatim "nombre, zona", "nombre, ciudad", "nombre" (si encuentra, pone el pin y habilita *Usar este punto*) y luego la zona, "Ruta N, ciudad" y la ciudad (solo centra). La ubicación guardada sale solo con el botón 🎯 y nada pegado.
- 1.81.0: `lugarDe(t)` saca nombre y zona del texto pegado (sin links ni horas). `applyReply` llama `pickAbrir(p,t)` si no hay coordenadas y hay un link o un nombre de lugar (guarda la hora si venía). `#pickSheet` + `#pickMap` (Leaflet, `PMAP`, `PICK={p,c}`); `pickBuscar` usa Nominatim (`countrycodes=cr`) con "nombre, zona" y si no, solo la zona; `pickOk` guarda `p.ubic=cTxt(c)`, pasa a *Confirmado* y borra `S.route`. Botón `#pasteMapa` en `#pasteSheet`.
- 1.73.3: `guiPdf` suma la columna *Hora entrega* = `fmtT2(repT(p))` (la misma hora real del reporte de entregas).
- 1.73.2: `#v-cierres` ya no tiene el primer `.panel` ("Cierres … Próximamente"); empieza con *Reporte de entregas* (`#repLista`).
- 1.73.1: `.epin.ok` y `.estop.ok .n` sin `line-through` (siguen en gris; `.estop.ok` con opacidad).
- 1.73.0: `msgOpts()` numera solo (`i+1`) y suma `comp` (Comprensión) y `ext` (Horario extendido); textos en `DEF_COMP` / `DEF_EXT`, guardados en `S.comp` / `S.ext` (en `NUBE_KEYS`, `bind`, `nubeAplicar`, textareas `#m-comp` y `#m-ext`). Al abrir `data-act="sent"` con esas claves marca `p.compSent` / `p.extSent`. CSS: `.pkg .num.tachado` sin `line-through` y `.pkg .name>.coordbtn{margin-left:auto}`.
- 1.72.3: `guiGrupos()` agrupa por fecha de recibido `repDia(p.ing)` (clave `sin` si no hay `ing`), `guiTit(k)` arma "Paquetes recibidos DD/MM/AAAA"; dentro del PDF, un título "Entregados DD/MM/AAAA (n)" y una tabla por día de entrega (`repDia(repT(p))`). Lo de abajo describe la versión anterior. `fixIng1031()` (llamado en `nubeAplicar` y al abrir *Cierres*) es un arreglo único para la cuenta de Victor; borrarlo cuando esa lista se vacíe.
- 1.71.0: reporte de guías. `guiGrupos()` agrupa `repTodos()` entregados por `repDia(repT(p))` (más nuevo primero, filas por hora de entrega); `guiLista()` pinta `#guiLista` (`.replin` con `data-gui`); `guiPdf(k)` arma el PDF horizontal (jsPDF + autotable) con Nombre, Tel., Guía y Dirección (`p.dir`; era Nota hasta 1.72.1), archivo `guias-AAAA-MM-DD.pdf`. Desde 1.72.2 agrupa por `repDia(p.ing)` (fecha de recibido, más vieja primero; sin `ing` al final) con un título "Paquetes recibidos DD/MM/AAAA (n)" y una tabla por grupo (`doc.lastAutoTable.finalY`). Se llama al abrir *Cierres* y otra vez cuando llegan los cierres guardados.
- 1.70.10: `#entPick`, `#entLista` y `#ttBtn` van en `.entbtns` (fila completa, flex `1 1 auto`, 12,5 px, sin salto). "En la ruta" con 🏍️.
- 1.70.9: `.btn.subback` con `margin-left:auto` y `align-self:flex-end` (a la derecha); `.devkeep .btn.devno` con `margin-left:auto`; `.estop.devol .acts3` con `space-between` (etiqueta a la izquierda, botón a la derecha).
- 1.70.8: el aviso "🗺️ En la ruta" / "No está en la ruta" pasa de `.pkruta` a `.meta` (después de `.pin`); `.pkruta` deja solo los botones `aruta` y Pegar respuesta. `.estop.ok.devol{opacity:1}` para que `.estop.ok` no destiña `.acts3`.
- 1.70.7: el naranja va con `!important` y selectores `.btn.ghost.subback`, `.btn.sm.subback` y `.estop .btn[data-edevno]` (antes `.btn.ghost` lo dejaba transparente con letra blanca). `.pkg.devol .actions [data-act="dev"]` se oculta. En *Ruta*, `.estop.devol` apaga los hijos con `:has(.acts3)` para que `.acts3` (Quitar devolver) no herede la opacidad.
- 1.70.6: `.devkeep .btn.devno` y `.btn.subback` con `--accent` (naranja) y letra `--accent-ink` en negrita.
- 1.70.5: ícono de código de barras en SVG en línea (`svg.bcico`, `currentColor`, 28 px en `.sysbtn` y 16 px en la tarjeta) en lugar del emoji 📷 (no existe emoji de código de barras).
- 1.70.4: la etiqueta es `Tel. …`.
- 1.70.3: `.meta` muestra `Teléfono: …` (o "sin teléfono").
- 1.70.2: en `renderPk`, `.meta` muestra la guía como `Guía: …`.
- 1.70.0: tráfico en vivo. `#ttBtn` en `#entTools`; `S.ttKey`/`S.ttOn` (en `NUBE_KEYS`). `TT={at,pos,k,min,del,busy,err}`; `ttPedir(force)` llama `api.tomtom.com/routing/1/calculateRoute/{pos}:{próxima}/json?traffic=true&travelMode=car` para `entProxima()` (primera pendiente con `c`, sin Hold) como máximo cada 2 min, o si cambia la parada o te moviste 300 m (mínimo 20 s entre consultas). Lo llaman `entEta()` y el `setInterval` de 60 s. En `entEta`, si `TT` es de esa parada, de hace menos de 6 min y desde menos de 500 m, `m = TT.min + 1` y muestra "🚦 … (+n tráfico)". 401/403 → `TT.err` y el botón dice "revisar clave". `ttPintar()` desde `renderEnt` (no al cargar, por la zona muerta de `const TT`).
- 1.69.9: el botón `data-act="del"` dice "Eliminar" y su `rfConfirm` empieza con "¿Eliminar…" (el verbo `eliminar` va en rojo). `data-equitar` en *Ruta* solo saca la parada y anota `S.ent.quitadas`.
- 1.69.7: `entAgregarPk` sale con "ya está en la ruta" si hay una parada con `c` y `pkFijo===p.id`, en `entParadasDe(p)` o con `entPkg(x)===p` (salvo la parada sin pin que se completa). Guarda y renderiza antes de `entOrdenar` (async), así el botón desaparece enseguida. `entSinDup()` (al inicio de `entSyncPk`) agrupa por `entPkg(s).id` y quita las repetidas con el mismo `pkFijo` o el mismo `nomN(nombre)`; se queda `done/devolver`, luego con `c`, luego la primera; pasa `done/at/gps/prevSt` y renumera `n`.
- 1.69.4: `devBar(p,enPk)`: con `enPk` (lo pasa `renderPk`) el botón del devuelto dice "↪ Regresar a Ruta"; en `renderMsg` sigue "↪ Quitar devuelto". El botón `data-act="dev"` de la tarjeta también dice "Regresar a Ruta".
- 1.69.3: `renderMsg` ordena por `rk` y luego por `rpos[p.id]`: la posición de su parada en la lista de *Ruta* (mismo `erk` que `renderEnt`); sin parada, `1e6+índice`.
- 1.69.2: vehículo por defecto `carro` en `vehPintar` y `vehIcono` cuando `S.veh` no está; `renderEnt` llama `vehPintar()` para reflejar el valor que llega de la nube.
- 1.69.1: se quitó la fila con `<h2>Lista del día</h2>`; `#clearAll` (oculto) sigue en el DOM porque `cerrarDia` le cambia el texto.
- 1.67.4: se quitó el aviso de `entInfo` "no es la de hoy ni la de mañana".
- 1.67.3: orden de `nav.tabs`: paquetes, cierres, mensajes, entrega (Ruta).
- 1.67.2: `#p-buscar` va antes del encabezado de la lista en `#v-paquetes`.
- 1.67.1 y 1.66.1: orden de `.subbtns`: `#vaciarTile`, Agregar a mano, Importar, Escanear.
- 1.70.1: regla base `input,textarea,select` a 16 px en `index.html` (y `!important` en `admin.html`): con menos, Safari de iPhone hace zoom al enfocar y la vista queda corrida.
- 1.69.8: `data-act="dev"` sobre un devuelto: texto "¿Regresar a Ruta…?" (botón "Regresar a Ruta"); vuelve a `stAntes` (nunca a entregado), borra `devolver`; si no tiene parada y hay ruta abierta, `entAgregarPk(p)` (con ubicación) o avisa.
- 1.69.6: `.pkruta` (ancho completo, sin salto) lleva el estado de ruta (`aruta` / En la ruta) y `data-act="paste"`; al final del `<script>` principal se llama `render()` otra vez (el primero corre antes de `entPkg` y el `enR` quedaba vacío).
- 1.69.5: `.rfdlg-box` centrado con `position:fixed;left:50%;top:50%;transform:translate(-50%,-50%)`, ancho `min(340px,100vw-40px)`; botones en columna (acción arriba); un último párrafo que empieza con "Ojo" va en `.rfdlg-ojo`; el foco inicial solo con `(hover:hover)`.
- 1.69.0: `rfConfirm(texto)` → `Promise<boolean>` reemplaza todos los `confirm()` (las funciones que lo usan pasaron a `async`). Primera línea = título; la etiqueta del botón sale del verbo de la pregunta; rojo (`.mal`) para borrar/quitar/vaciar/devolver/finalizar o textos de riesgo. `cTxt(c)` guarda coordenadas con 6 decimales (`mkPkg`, Excel, Pegar respuesta, `entPonerC`); `parseCoord` acepta además un texto que sea solo `lat,lng` con 1-2 decimales. *Editar* rellena con `||""` y compara teléfono por dígitos y ubicación por coordenadas.
- 1.68.0: `osrmCadena` pide `overview=full&geometries=geojson` y guarda `RTOT.geo` ([lat,lng]); `entLinea()` pone en `EMAP.linea` el trazo si `RTOT.k` coincide con las paradas pendientes (si no, recta). Se llama al dibujar el mapa y cuando llega la respuesta.
- 1.67.8: `#vehSel` va dentro de `#entTools` antes de `#entPick`, con `margin-left:auto` y botones de 32 px; queda a la derecha de `#entTot`.
- 1.67.5: al inicio del `<script>` principal, `window.RF_TAB(t)` y un listener de `click` en captura sobre `nav.tabs [role=tab]` cambian la pestaña sin depender del resto; un listener de `error` muestra una vez un aviso rojo con mensaje, línea y versión.
- 1.67.0: `#vaciarTile` (`.sysbtn.sysdanger`, 4.ª columna de `.subbtns`) hace `confirm` con el total y los pendientes y llama `cerrarDia($("#clearAll"))`; `#clearAll` queda oculto (lo usa `cerrarDia` para el texto del botón).
- 1.66.4: en el mapa de *Ruta*, `EPILA` agrupa los pines por `c` redondeado a 4 decimales; dentro del grupo (pendientes primero) cada uno corre su `iconAnchor` 12 px a la derecha. La coordenada real no cambia.
- 1.66.3: `zIndexOffset` de los pines: seleccionada 3000, pendiente 1000, Hold 500, `entDone` −1000.
- 1.66.2: `pkOff(p)` = `pkDevol(p)` o `st==="devuelto"` pone `.devol`; `devBar` para devueltos usa `data-act="dev"` ("↪ Quitar devuelto").
- `pkDevol(p)` (devolver y no entregado ni devuelto) agrega `.devol` a `.pkg` en `renderPk` y `renderMsg`; `devBar(p)` agrega `.devkeep` con `span.devtag.on` y `data-act="devno"`. CSS: los hijos que no son `.devkeep` van al 45 %, gris y sin `pointer-events`.
- `devno`: `confirm`, borra `p.devolver` y `devolver` de sus paradas, `entMod`, render de todo. En *Ruta*, `.estop.devol` deja activo solo `.acts3` (etiqueta roja + `data-edevno`, ahora con `confirm`).

## 3c-quattuordecies. Botones de sistema (1.65.0)

- `.subbtns` es una cuadrícula de 3 `.sysbtn` (fondo `rgba(120,120,128,.12)`, radio 14 px, ícono de 22 px arriba, fuente del sistema). `#formPanel` es `details.panel.subpn[open]` con el `summary` oculto, `.subback` y `h2#formTitle`. `subAbrir('formPanel')` lo abre y llena `#f-lote`; *Editar* cambia a la pestaña y llama `subAbrir`; guardar, Cancelar y Regresar (con `resetForm` si se editaba) llaman `subAbrir(null)`.

## 3c-terdecies. Subpaneles de Paquetes (1.64.0)

- `.subbtns` con `data-sub="pnScan|pnImp"`; los paneles son `.panel.subpn` (ocultos sin `.on`). `subAbrir(id)` pone `.on` al panel y `.sub-open` en `#v-paquetes`, que oculta todo lo demás de la sección; `.subback` y el cambio de pestaña llaman `subAbrir(null)`. `#importBtn` regresa al terminar.

## 3c-duodecies. Datos relacionados (1.63.0)

- 1.63.2: en `renderEnt` el WhatsApp es `phoneWA(p&&entFuerte(s,p)?p.tel:s.tel)`; `entSyncPk` copia `p.tel` a `s.tel` siempre que difieran los dígitos (antes solo si el nuevo era válido). `telsAnt` sigue guardando los anteriores para `entFuerte`.
- 1.63.1: `entCopiarPk` y `entSyncPk` copian también `guia`, `dir` y `nota` del paquete a la parada (el paquete manda).
- `pkReflejar(p)`: si `p.st!=='entregado'` limpia `done/at/gps/prevSt` de `entParadasDe(p)`; con devuelto o `devolver` quita `hold`. Se llama en `data-act` `st`, `set` y `dev`.
- `del`: `confirm`, saca las paradas de `entParadasDe(p)` de `S.ent.stops` y renumera.
- `st` (desde entregado o devuelto) y `dev` piden `confirm`. *Editar* arma la lista de cambios y pide `confirm`.
- `entPonerC` copia `c` a `p.ubic` si la unión es segura (`entFuerte`) y el paquete no tenía ubicación legible.
- `supabase.sql` probado entero dos veces seguidas en PostgreSQL 16 (con stubs de `auth`, `storage` y `net`): corre sin errores y sin borrar datos.

## 3c-undecies. Promedios (1.62.0)

- `repResumen` devuelve además `pMin` y `pKm` (= `min`/`km` de `repTotales` ÷ entregados con hora) y `dias` (días distintos con entregas). PDF: "Días de entrega" (casilla 6) y "Promedio por entrega" (casilla 9). `cerrarDia` pone `S.jor={}` (ya va en `p_ruta.jor`).

## 3c-decies. Lote del paquete a mano (1.61.0)

- `#f-lote` (select) lo llena `loteLlenar(sel)`: los días `repDia(p.ing)` de la lista más hoy; por defecto el día con más paquetes (o `sel` al editar). `loteIng(k,prev)` da el `ing`: el mismo si no cambió el día, `Date.now()` si es hoy, o las 12:00 de ese día. Se usa al agregar a mano y al guardar *Editar*. Las cargas en lote (Excel, pegar, escáner) siguen con `Date.now()`.

## 3c-nonies. Nombre del grupo (1.60.0)

- `repEntregasDe(k)` → "Entregas del 2 de noviembre" (de `repDia(p.ing)`); se usa en la lista de *Cierres*, el título del PDF y el nombre del archivo (`entregas-del-AAAA-MM-DD.pdf`). El campo del encabezado pasa a "Recibidos el".

## 3c-octies. Jornada (1.59.0)

- `S.jor['AAAA-MM-DD'] = {ini:{t,c}, fin:{t,c}}` (en `NUBE_KEYS`; también va en `p_ruta.jor` del cierre y `repCierres` lo junta en `REPC.jor`). `#jorBar` lo pinta `jorRender()` (desde `renderEnt`); `jorGps()` usa `getCurrentPosition` (o `EPOS`).
- `repTramos`: al empezar un día, si `repJor(d).ini.t <= primera entrega`, la primera mide desde `ini` (`desdeIni`, "▶" en la fila).
- `repTotales`: con `ini` y `fin`, cambia la suma de tramos del día por `fin − ini` y suma `hav(última entrega, fin.c)`.
- **Ruta fija (1.72.0):** `jorEnCurso()` = hay `ini` y no `fin` hoy. Con jornada en curso, `entOrdenar(start,desde,manual)` sin `manual` no llama a OSRM: asigna `s.o` (puesto fijo; los que no tienen, en orden de `n`, al final) y ordena pendientes por `o`, luego Hold por `o`, luego hechas y sin ubicación; renumera `n`. Solo `#entAqui` y el clic de 🎯 pasan `manual=true` (piden `rfConfirm`) y una reordenada real borra `s.o`. ▶ Iniciar también borra `s.o`. Sacar de Hold llama `entOrdenar` aunque no haya GPS si la jornada está en curso.

## 3c-septies. Tramos del reporte (1.58.0)

- `repTramos(L)` → `Map(id → {inicio:true} | {min,km})`: entregados con `repT`, ordenados por hora; el tramo se mide contra la entrega anterior solo si es el mismo `repDia`. `repCoord(p)`: `entGps`, `pod` lat/lng, parada con `c` o `parseCoord(p.ubic)`; `km` = `hav` (×1,35) o `null` sin coordenadas.
- `repResumen`: `min` y `km` = suma de tramos (sin `inicio`). Ya no usa `S.ent.inicio` ni los `devAt`.
- `repFilas` agrega las columnas 9 y 10 (*Tiempo desde anterior*, *Km desde anterior*); autotable a 8,5 pt.

## 3c-sexies. Etiqueta de devueltos (1.56.0)

- `stChip(p)` con `st==='devuelto'` devuelve `button.chip.devtag` "⛔ Devuelto" (mismo `data-act="st"`). En `renderEnt`, la parada devuelta usa `span.devtag`.

## 3c-quinquies. Coordinar en Paquetes (1.53.0)

- `renderPk` usa `pkChip(p)` en vez de `stChip(p)`: para abiertos es `a.coordbtn` a `waLink(p,coordText(p))` con `data-act="sent" data-k="coord"` (marca `p.sent`); sin teléfono, `span.coordbtn.off`. Entregado/devuelto siguen con `stChip`. *Mensajes* sigue con `stChip`.

## 3c-quater. Contadores (1.52.0)

- `renderStats()`: Recibidos = `S.pk.length`; Entregados = `st==='entregado'`; Devueltos = `devuelto` o `p.devolver`; Hold = abiertos con alguna parada (`entParadasDe`) `hold && !done`; Sin ubicación = abiertos sin `parseCoord(p.ubic)` ni parada con `c`. `.stats` es `repeat(5,minmax(0,1fr))`; en celular centrado y letra de 11 px.

## 3c-ter. Cierre (1.51.0)

- `#clearAll` (dos toques) llama `cerrarDia(b)`: con `NUBE.on` manda `RF_AUTH.rpc('rf_cierre_guardar',{p_paquetes,p_ruta})` con `fecha_cierre` (ISO) en cada paquete, en la ruta y en cada parada; si falla no borra. Sin cuenta pide `confirm`.
- Después: `S.pk=[]`, `S.nums={}`, `S.route=null` y `S.ent={nombre:'',at,mod,stops:[],cerrada}` (no `null`: `nubeMezclar` toma la de la nube cuando la local es `null`; con `at` más nuevo gana en `entMezclar`). `entAgregarPk` no agrega a una ruta `cerrada`.
- `rf_cierres_listar(p_limite)` y `rf_cierre_leer(p_id)` quedan listas para la pestaña *Cierres*.
- Globito `#n-pk`: cuenta `S.pk` sin `entregado`, `devuelto` ni `p.devolver`.

## 3c-bis. Devolver (1.50.0)

- `data-edevol="i"` en `.acts3` de `renderEnt` (con `confirm`) pone `s.devolver=true` (quita `hold`) y `p.devolver=true` en el paquete unido (`entPkg`). No cambia `p.st`.
- `entDone(s)` cuenta `s.devolver` como cerrada (sale de `entOrdenar`, de la línea, de `entTotal` y el pin va gris) y `entDev(s)` también, así no suma en "entregadas".
- `.estop.devol`: gris, `pointer-events:none` en `.acts`, `.acts2` y `.eub`; el click no llama `entSel`. Solo queda `data-edevno` ("↩ Quitar devolver"), que borra ambos flags y reordena si hay `EPOS`.
- `renderPk` muestra `span.devtag` "⛔ Devolver" si `p.devolver`, junto con `stChip(p)` dentro de `span.chips1` (`inline-flex`, `nowrap`) para que no se separen (1.50.1). 📋 Lista dice "⛔ devolver".
- 1.67.7: `#entTot` es el primer hijo de `#entTools` (ya no existe `.entrow`); `#entPick` lleva `margin-left:auto` para que los botones vayan a la derecha; `.enttot` alineado a la izquierda.
- 1.67.6: `#entAqui` y `#entGps` se movieron al primer `.enthead` (con `#entFile` y `#entInfo`); `renderEnt` los muestra u oculta junto con `#entTools`. `#entGps` lleva `margin-left:auto` (a la derecha) y `.entrow` solo tiene `#entTot`.
- 1.57.0: reportes por fecha de recibido. `repTodos()` = `S.pk` + paquetes de cierres (`REPC.pk`, cargados con `rf_cierres_listar` y `rf_cierre_leer` en `repCierres()`, una vez por cierre, al abrir Cierres). `REPC.st[id]` guarda las paradas del cierre por `pkFijo||pkId` y `repParadas(p)` las usa en `repT` y `repResumen`. `repGrupos()` agrupa por `repDia(p.ing)` (AAAA-MM-DD local, lo más nuevo primero, sin fecha al final). `repLista()` pinta `#repLista` (`.replin` con `button[data-rep]`), y `repPdf(k)` arma el PDF de esa fecha; el encabezado suma "Fecha de recibido" en la col. 3. Ya no existe `#repPdf`.
- 1.56.4: `vehIcono()` (🏍️/🚙/🚐 según `S.veh`) y `conVeh(t)` (pone el ícono tras la primera palabra "camino"). Se usa en `entWaUrl` y en `msgText` para `k==='camino'`; la plantilla guardada `S.camino` no cambia.
- 1.56.3: `entSyncPk` pone `p.entAt=s.at` (antes `Date.now()`) cuando una parada `done` se une a su paquete, y corrige `p.entAt` si es posterior a `s.at` (sin `pod`). `repT(p)` da la hora del reporte: `pod.at`, el `at` más temprano de `entParadasDe(p)` hechas, o `entAt`; devueltos `devAt`.
- 1.56.2: `enc` en 3 filas de la cuadrícula de 4: col. 1 = fecha y mensajero, col. 2 = km y horas, col. 4 = recibidos, entregados, devueltos; tabla en y=40.
- 1.56.1: `repFilas` ordena por `tE(p)` (`entAt`/`pod.at` o `devAt`), sin hora al final (`Infinity`) y empate por `num`.
- 1.55.0: `#vehSel` (`span.vehsel` en `#entTools`, después de `#entLista`) con 3 `button[data-veh]` (moto, carro, buseta). `vehPintar()` marca `.on` y `aria-pressed`; el valor queda en `S.veh` (por defecto moto) y viaja en `NUBE_KEYS`. No se usa en cálculos todavía. Fix: `repResumen` ya no multiplica ×1,3 porque `hav()` ya trae ×1,35.
- 1.54.2: la 4.ª columna de `repFilas` es `tidyName(p.nombre)` (ya no tel 2). `enc` tiene posiciones fijas en una cuadrícula de 4: fila 2 = km, horas, `null` (hueco) y devueltos, para que devueltos quede bajo entregados.
- 1.54.1: `repResumen()` da {rec, ent, dev, km, min}. km = suma de `hav()` desde `S.ent.inicio` (o la primera entrega) por cada entrega ordenada por hora (coordenada de `entGps`, `pod`, la parada o `p.ubic`) ×1,3 por calles. min = de la primera a la última hora de entrega o devolución. El encabezado va en 2 filas de 4 pares etiqueta (negrita) y valor, y la tabla empieza en y=34.
- 1.54.0 (Reporte PDF, pestaña Cierres): `repCargar()` carga `REP_JS` una vez (al tocar la pestaña Cierres, para que en iPhone `navigator.share` siga dentro del toque). `repFilas()` toma `S.pk` con `st` entregado/devuelto o `p.devolver`, ordena por `num` y arma [num, guia, tel, tel2, estado, fecha `ing`, fecha y hora de `entAt`/`pod.at` (o `devAt`)]. Tel 2 = primer `telsAnt` o teléfono de parada (`entParadasDe`) distinto del principal. `repPdf()` usa `jsPDF({orientation:'landscape',format:'letter'})` + `autoTable` (encabezado grafito #1f2125, estado en verde/rojo); en iPhone comparte el archivo, si no `doc.save`.
- 1.53.2: `renderPk` ordena con `rk`: 0 activos, 1 Hold (`entParadasDe(p)` con `hold` y sin `done`), 2 devueltos o `p.devolver`, 3 entregados; empate por orden de la lista.
- 1.53.1: en `renderPk` la etiqueta es `button.devtag` con `data-act="devok"`. El manejador global de `[data-act]`: primer `confirm` → `p.st='devuelto'` (guarda `stAntes`, `devAt`) y borra `p.devolver` y `s.devolver` de las paradas unidas (`entPkg(s)===p`); segundo `confirm` → solo borra las marcas. Luego `entMod()`, `save()`, `render()`, `renderEnt()`.

## 3d. Soporte

- 1.49.0: `#supTab` ya no es parte de `nav.tabs`; es `button.hdsop` dentro de `.hdrow` (con `#daypill`) en `header.top`. Su lugar en la barra lo ocupa `#tab-cierres` (`data-tab="cierres"`), que muestra `#v-cierres` (sección vacía, contenido por definir); la lista de vistas del cambio de pestaña incluye `cierres`.

- Ícono: SVG en línea de audífonos con micrófono (`stroke=currentColor`, clase `.ico-sop`), sin archivos ni librerías; toma el color del texto. El mismo trazo va en `ayuda` y `contacto()` de `auth.js`.
- Botón `#supTab` (cuarto botón de `nav.tabs`, ícono `.ico-sop`, sin `role=tab`: abre la hoja y no cambia de pestaña; el manejador de pestañas filtra `nav.tabs [role=tab]`) y enlace `#supPie` en el pie → `openSupport()` abre `#supSheet`.
- WhatsApp: `wa.me/SOPORTE_WA` con texto que incluye la versión (`#appVer`).
- Videos: `fetch('videos.json',{cache:'no-cache'})`; si la URL es de YouTube usa un `<iframe>` de youtube-nocookie, si no un `<video controls playsinline preload=metadata>`. Al cerrar (`#supClose`, arriba a la derecha junto al título; mismo tamaño que `.btn.pri` del panel: 14 px, 8×12 px de relleno, radio 8 px) se pausan y se vacía la lista para no gastar datos.
- Grabación de los videos (1.75.1): `record3.js` usa un escenario de 540×960 escalado ×2 con la app en un `<iframe>`, simula Supabase con `ctx.route` (incluye `rf_codigo_nuevo`, `rf_lista_leer` y `rf_lista_guardar`), el GPS con un `navigator.geolocation` falso (`window.__geo`) y el reloj con `ctx.clock` (adelanta minutos para que el reporte tenga horas y km). Las escenas salen de `scenes.json` (subtítulo `cap` y texto para la voz `say`).
- Reporte PDF (1.75.1): en *Tiempo desde anterior* la primera entrega después de ▶ Iniciar dice `desde inicio: N min`. Antes llevaba el carácter ▶, que la fuente estándar de jsPDF no tiene y salía como «%¶». En los PDF de jsPDF usá solo texto latino, sin emojis ni símbolos.
- El pie también lo usa `auth.js` (`.rfcuenta`, cuenta y Salir): el enlace de soporte va al inicio del pie para no tocar ese bloque.

## 3b. Prueba de entrega

- Al pasar un paquete a **entregado** (botón o etiqueta de estado) se abre `#podSheet` con `openPOD(p)`. Nunca se pone `st='entregado'` sin evidencia.
- GPS: `enableHighAccuracy` 15 s, `maximumAge 0`; si falla (no por permiso) reintenta aproximado 20 s.
- Fotos: `<input type=file capture=environment>`. `stampPhoto()` reduce a 1024 px, dibuja el sello (fecha/hora, cliente, guía, GPS) y exporta JPEG 0.65 (~100–150 KB).
- `cleanLocal()` (corre con `uploadPending`) vacía `fotos` en IndexedDB de evidencias ya subidas con más de `LOCAL_DIAS = 7` días.
- Mínimo `MIN_FOTOS = 3`. *Confirmar* se habilita con 3 fotos + GPS.
- Guardado local: IndexedDB `rutafacil-evidencias`, store `ev` → `{id, pid, guia, cliente, at, lat, lng, acc, fotos:[Blob], up}`. En el paquete queda `p.pod = {id, n, at, lat, lng, acc, up}`.
- Subida: `uploadPOD(id)` sube cada foto a `storage/v1/object/evidencias/<día>/<guia>_<id>_<n>.jpg` y luego llama `registrar_entrega`. Si falla, queda `up:false` y `uploadPending()` reintenta cada 60 s y al tocar *Revisar respuestas ahora*.
- **Firma:** `<canvas id="podSig">` con eventos `pointer*` (`touch-action:none`). `POD.signed` pasa a `true` después de 40 px de trazo. `sigBlob()` exporta JPEG 0.7 con fondo blanco y sello "Recibió: … · fecha" (el bucket solo acepta JPEG). En IndexedDB: `rec.firma` (Blob), `rec.recibe`, `rec.sinFirma`; en el paquete `p.pod.firma` y `p.pod.recibe`. `uploadPOD` sube la firma como `_firma.jpg` al final de `p_fotos` y manda `p_recibe`; si el RPC responde 300/400/404 (base sin `p_recibe`) reintenta sin él.
- **Recorrido de hoy:** `trackStops()` toma los paquetes con `pod` de hoy ordenados por hora; `renderTrack()` carga Leaflet (`LIB_MAP`/`CSS_MAP`) solo si hay entregas y la pestaña *Ruta* está visible, dibuja marcadores `.tpin` numerados y una línea punteada, y arma links de Google Maps en tramos de 10.
- `openEvidence(p)` muestra fotos (desde IndexedDB), hora, GPS y estado del respaldo.

## 3d. Cuentas (`auth.js`)

Se carga después de `config.js` en `index.html` y `admin.html`. Sin Supabase en `config.js` no hace nada (`RF_AUTH.on = false`, `listo` resuelve `null`).

- **Sin librerías:** habla con Supabase Auth por REST (`/auth/v1/signup`, `/auth/v1/token?grant_type=password|refresh_token`, `/auth/v1/logout`).
- **Correo interno:** `<8 dígitos>@rutafacilcr.github.io`; el PIN (6 números) es la contraseña. `tel8()` quita `506` y lo que no sea número.
- **localStorage:** `rutafacil-sesion` (tokens), `rutafacil-dispositivo` (id aleatorio de 32 hex del celular, se crea una vez), `rutafacil-cuenta` (última respuesta buena de `rf_mi_cuenta` + hora).
- **Bloqueo:** agrega la clase `rf-bloq` a `<html>` (oculta todo menos `#rfGate`) y pinta la pantalla en `#rfGate`. Si hay una revisión buena de menos de 3 días (`OFFLINE_DIAS`), abre de una vez y revisa por detrás; así funciona sin internet.
- **Revisión:** `revisar()` llama `rf_mi_cuenta(p_dispositivo)` al abrir, cada 15 min con la app visible y al volver a la app (si pasaron 5 min). Si la cuenta deja de servir, bloquea de nuevo. Un 404 de la función (SQL sin correr) abre la app con aviso en el pie.
- **Soporte:** `SOPORTE` (de `RF_CONFIG.soporte`, por defecto 62700666). `ayuda` (enlace de WhatsApp) va al pie de `vEntrar`, `vCrear` y `vError`; `contacto()` (botón) en `vEstado`.
- **Espera de activación:** mientras la pantalla de cuenta está visible (`!abierta`), `revisar()` corre cada 60 s y al volver a la app. Si la cuenta está pendiente, vencida o con teléfono por aprobar, `vEstado` pinta un botón gris deshabilitado (`.rfespera`, *Esperando activación* / *Esperando aprobación*) y marca `esperando = true`; cuando `rf_mi_cuenta` responde que ya sirve, `vListo(c)` muestra *Cuenta habilitada* (`.rflisto`, verde) con el botón naranja **Entrar**, que llama `abrir(c)`. Suspendida o teléfono cerrado siguen con *Revisar de nuevo*.
- **Enlaces:** `.rflink` va subrayado; *Crear cuenta* es un `.rflink` dentro de un `<p class="rfmuted">` (mismo aspecto que el enlace de WhatsApp de `ayuda`).
- **Campos:** en `vCrear` no hay `placeholder` y nombre/número llevan `autocomplete="off"` (parecían ya llenos). Los placeholders del gate usan `--muted` con `opacity:.45`.
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

`entregas(evidencia_id UNIQUE, guia, cliente, repartidor, lat, lng, precision_m, entregado_en, fotos text[], owner_id, recibe)`: RLS sin políticas, se escribe solo con `registrar_entrega(…, p_fotos, p_recibe text default null)`. `recibe` es el nombre de quien recibe ("… (no firmó)" si no firmó); la firma va como la última foto, terminada en `_firma.jpg`. Al reenviar la misma `evidencia_id`, `recibe` solo se reemplaza si llega un valor. Bucket `evidencias` privado con política de solo INSERT para `anon`.


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
| `--accent-text` | `#b8470f` | = `--accent` | Texto naranja sobre fondo claro (pestaña seleccionada, 1.76.2): `#f26b1d` sobre blanco da 3,0:1 y no pasa; `#b8470f` da 5,3:1. |
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
- `nav.tabs`: barra inferior tipo app (fondo `--surface`, activa en `--accent` con raya arriba). Respeta `safe-area-inset-bottom` del iPhone; el `.toast` sube a 84 px para no taparse.
- 1.85.1 (estructura de la página): `html,body` con `height:100%;overflow:hidden`, `body` es columna flex de `100dvh`; `header.top` y `main` van dentro de `<div id="app">` (`flex:1;overflow-y:auto`), que es lo único que se desplaza, y `nav.tabs` va después, en el flujo (`position:relative`, no `fixed`), por el error de iOS 26 que deja lo `fixed` a media pantalla. Para subir al inicio usar `#app.scrollTo(...)`, no `window.scrollTo`. Las hojas, diálogos y el toast siguen `position:fixed` encima de todo. `main.wrap` ya no necesita dejar 96 px abajo (queda en 24 px).
- Tarjeta desactivada (`.pkg.devol`, `.estop.devol`, 1.76.2): **no usar `opacity` ni `filter` sobre el texto** (Lighthouse lo marca y no se lee). El texto queda en `--ink`/`--muted` sobre el fondo gris; lo que no se toca sigue con `pointer-events:none` y los botones se ven apagados con fondo transparente, letra `--muted` y borde punteado. La etiqueta `.devtag` (⛔ Devuelto) y el botón naranja de regresar no se apagan.
- Contraste mínimo 4,5:1 para texto normal en ambos temas. Para revisarlo: axe-core `color-contrast` (ver manual técnico, *Contraste 1.76.2*).
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

- **Aviso de actualización:** `checkUpdate()` busca `id="appVer">x.y.z<` en `index.html` publicado; por eso el número de versión debe seguir en ese formato.

- **Versión:** semántica `mayor.menor.corrección` en `#appVer` (pie de `index.html` y de `admin.html`). Subirla en cada publicación y anotarla en `CHANGELOG.md`.

- Textos en español de Costa Rica (voseo en la app del repartidor, usted en el formulario del cliente).
- Commits en español, en imperativo ("Agregar…", "Corregir…").
- Cada cambio actualiza: `CHANGELOG.md` y los manuales afectados (`README.md`, `docs/`).
