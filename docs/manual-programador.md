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
| `#m-yo` / `S.yoPropio` | El nombre que firma los mensajes. `usarCuenta()` pone el nombre de la cuenta solo si el repartidor no escribió uno propio (`S.yoPropio`); vaciar el campo lo devuelve al de la cuenta. Antes de 1.14.1 el campo quedaba `readOnly` y en iPhone no salía el teclado. |
| `#tplPanel` | `<details>` plegado al final de Mensajes con las plantillas `#m-coord`, `#m-form`, `#m-camino`. Al abrirlo (`toggle`) se recalcula la altura de los cuadros con `grow()`. Orden de la pestaña: nombre y fecha → Clientes → Respuestas del formulario → plantillas. |
| `#podOk` | Nunca queda `disabled` mientras falte algo: con la clase `.off` se ve tenue y al tocarlo avisa qué falta y hace scroll. Si el GPS falló (`#podGeoRetry` visible) pide `confirm()` y guarda la entrega con `lat/lng/acc = null` (la ficha dice *Sin GPS* y no sale en *Recorrido de hoy*). Errores al guardar se muestran en un toast. `sigInit()` también reinicia el largo del trazo (evento `sigreset`). |
| `cleanName(s)` | Mayúscula inicial con `\p{L}` (respeta tildes y ñ) y quita guiones o puntos sueltos al inicio y final. La usan el escáner y `vcfName()`. `fixOldName()` repara al cargar los nombres guardados con el error viejo (*ChavarríA*). |
| `saveContacts()` | Arma un `.vcf` (vCard 3.0) con un contacto por teléfono (`phoneWA`), nombre `vcfName()` = `S.pref`-Nombre-guías (guías del mismo teléfono unidas con `/`), y lo descarga con un `<a download>` sobre un Blob `text/vcard`. En iPhone (`IOS`) usa `navigator.share({files})`: Safari, al abrir un `.vcf` con varios contactos, solo ofrece el primero; desde *Archivos* sí sale *Agregar los N contactos* (aviso `#vcfIos`). Desde 1.18.2 primero abre `#vcfSheet` con los pasos (Mail o Archivos; *Contactos* en el menú también importa solo el primero) y el botón **Continuar** llama `navigator.share` (necesita el toque del usuario). `S.pref` (casilla `#m-pref`) vale `TM` por defecto. `vcfEsc()` escapa `\\ , ;`. |
| `nubeSync()` | Lista en la nube. Lee `rf_lista_leer`; si la versión cambió, `nubeMezclar()` une por `id` usando `S.baseIds` (ids de la última sincronización) para distinguir *borrado en un lado* de *nuevo en el otro*; si hay cambios locales (`S.dirty`) gana lo local. Luego sube con `rf_lista_guardar(p_datos, p_version)`; si otro aparato guardó antes, la función devuelve `ok:false` con sus datos, se mezcla y se reintenta (hasta 3). Corre al abrir, cada 60 s, al volver a la app y 2,5 s después de cada `save()` (`nubeSoon`). `saveLocal()` guarda sin marcar cambios. Claves sincronizadas: `NUBE_KEYS`. Desde 1.19.1 las claves que no son `pk` se mezclan una por una con `S.nubeBase` (huella al último sync): gana lo local solo si esa clave cambió aquí (sin huella previa, gana lo local si hay cambios pendientes). `nubeSync(force)`: con la misma versión también sube si a la nube le falta una clave que el aparato tiene; `force` (☁️, cargar ruta) sube siempre. Abrir *Entrega* llama `nubeSync()` antes de dibujar. Las claves que esta versión no conoce se guardan en `S.nubeOtros` y se vuelven a subir; si la nube perdió una clave que el aparato tiene (`NUBE.falta`), se sube de nuevo. Estado en el pie (`#nubeInfo`, se toca para sincronizar): *al día*, *sin activar* (404: faltan las funciones), *sin permiso* o *sin conexión*. |
| `entCargar(file)` | Pestaña *Entrega*. Lee con SheetJS la hoja `Ruta ordenada` (o la primera), ubica columnas por encabezado (`orden, nombre, telefono, direccion, guia, nota, ubicacion, Waze`) y saca coordenadas del hipervínculo de `ubicacion`/`Waze` (`cell.l.Target`) con `parseCoord`. Guarda `S.ent` (sincronizado en la nube vía `NUBE_KEYS`). Paradas sin coordenadas van al final. El aviso rojo sale si el nombre no es *Ruta* de hoy ni de mañana (fecha local). Tocar ☁️ en el pie muestra versión de la nube, paquetes y ruta cargada (diagnóstico). |
| `renderEnt()` / `entSel(i)` | Mapa Leaflet `#entMap` (sticky, 42vh) con pines `.epin` numerados y polilínea en orden; lista `.estop`. Tocar una parada centra el mapa; tocar un pin hace scroll a la parada. `entPkg(s)` busca el paquete por guía o teléfono para abrir la prueba de entrega (`openPOD`). |
| `entOrdenar(start)` | Reordena las paradas pendientes con `optimize()` (la misma de *Ruta*) desde `start`, con ventanas `parseWin` del paquete que coincida y la hora actual; renumera y guarda `S.ent.inicio`. Lo llaman **📍 Ordenar desde aquí** (GPS con `getCurrentPosition`, alta precisión y respaldo de baja) y **🎯 Elegir en el mapa** (`EMAP.pick` + click en el mapa). `entEta()` (lo llama `entMe()`, o sea en cada render y cada lectura de GPS) llena los `<span class="eeta" data-eta="i">` junto a los botones Evidencia (`data-eok`, solo si `entPkg` encuentra el paquete) y Entregado (`data-edone`, pone `s.done=true`). Para una parada entregada se muestra `data-eundo` (solo si fue `s.done`). Las paradas entregadas se ven grises (`.estop.ok .n`, `.epin.ok` con `#9aa0a6`). Usa `OSRM.r[ckey(c)]=[km,min]` de `osrmPedir()` (tabla OSRM, `sources=0`) si la consulta se hizo a menos de 300 m de tu punto actual; si no, `hav()`. La fórmula es min = max(OSRM×1,3, km/18 km/h) + 1; vacío se oculta con `:empty`. `optimize()` acepta un 7.º parámetro opcional `Mx` (matriz de minutos); `entOrdenar` es async y se lo pasa desde `osrmMatriz(pts)` (duraciones ×1,3), o `null` para usar `hav`. `entTotal()` (también desde `entMe()`; la línea "Inicio · fin" usa la hora actual + total, sin `S.hora`, y un `setInterval` de 60 s la refresca) llena `#entTot` (`.entrow` junto a `#entGps`): `RTOT` guarda la caché de `osrmCadena()` con clave `k` = las `ckey` pendientes. El manejo es max(duración×1,3, km/18 km/h) y el total va de manejo + n×3 a manejo + n×5. WhatsApp en `renderPk()` (1.32.0): `<a class="btn sm wa">` a `wa.me/${phoneWA(p.tel)}` al final de `.actions`, solo si `phoneWA` devuelve número. Corregir etiqueta (1.31.0): `data-act="rescan"` llama `scanCorregir(p)`, que pone `SCAN.fix=p.id`, cambia el título y abre `#scanCam`. `scanFile` rellena con los datos del paquete lo que el OCR no leyó; `scanSave` con `SCAN.fix` hace `Object.assign` de nombre, tel, dir, guía y nota, y cierra. `scanDupCheck` ignora el mismo paquete y `closeScan` limpia `fix`. Orden en `renderPk()` (1.30.0): orden estable por `rk(p)` (0 los que faltan, 1 entregado, 2 devuelto) y luego por índice original; `S.pk` no se reordena. Devuelto (1.29.0): `STATUS` agrega `['devuelto','Devuelto']` y la clase `.st-devuelto` en gris. `data-act="dev"` alterna entre `devuelto` y `stAntes`. `calcRoute` lo excluye y `renderStats` lo cuenta si hay alguno. `entSyncPk()` (1.29.1) recorre las paradas con `done` y pasa a entregado los paquetes que no estén `entregado` ni `devuelto`. Se llama en `render()` (con try, por el TDZ del primer render), en `renderEnt()` y con un `setTimeout` después de `entDone`. `guiaN()` normaliza las guías (O→0, I/L→1, sin espacios). `.estop .n.no` en amarillo `#f5c518` con texto grafito (1.35.0). 1.38.1: `renderPk` arma `enR` (id de paquete → parada con `entPkg`, dentro de try). Muestra el estado y `data-act="aruta"`, que llama `entAgregarPk(p)`: este agrega la parada con `pkFijo` y reordena con `EPOS`. Avisa si `p.ubic` no se puede leer con `parseCoord`. 1.41.0: en `renderPk()` el orden de `.actions` es paste, edit, Waze (si `c`), `del` ("Borrar"), `dev`, `rescan` ("📷 Escáner"), WhatsApp; desde 1.41.1 Escáner y WhatsApp van juntos en `span.scanwa` (columna flex) para que WhatsApp quede siempre debajo de Escáner; se quitó el link Maps de la tarjeta (en Ruta sigue). 1.48.3: `.epin.hold.sel` mantiene el amarillo (solo crece). 1.48.2: `.epin.hold` (`#f5c518`, texto grafito) para paradas con `s.hold` no cerradas; `.sel` sigue pudiendo agrandarlo. 1.48.1: el prompt de `data-elink` con 1 a 3 dígitos (o `#62`) busca por `p.num` exacto. 1.48.0: `entPkg` ahora es `entPkgCand` (puntaje) + `entFuerte`; todo (eNum, entDone, chips, Lista, renderPk, diagnóstico) usa solo uniones seguras. `eNum` sin paquete devuelve "–". `entDone` incluye paquetes devueltos; `entDev(s)` para la etiqueta y para no contarlos como entregados. `entMod()` pone `S.ent.mod` en cargar, ordenar, Hold/Quitar/Entregado/Deshacer/Unir/Evidencia, `entAgregarPk`, `entPonerC` y `entCopiarPk`. `nubeMezclar` para `ent` llama `entMezclar(local,nube)`: distinta `at` → la más nueva; si no, gana `mod` mayor y se copian `done/at/gps` de la otra por clave `pkFijo||pkId||nombre|tel`. 1.47.2: `entUnirLibres` ya no une por palabras ni auto-agrega; solo una vez (`E.limpia147`) quita paradas `agregada && !done`. `entFuerte(s,p)` (pkFijo, guía, `nomN` igual o teléfono/`telsAnt`) decide si `entSyncPk` copia tel/nombre/guía/ubicación y marca entregado. `entParadasDe` usa `pkFijo` o `entPkg`+`entFuerte`. `entCopiarPk` fija `pkId`/`pkFijo` y, si el paquete editado no tiene parada y sí ubicación, llama `entAgregarPk`. 1.47.1: en `.acts3` va primero `data-ehold` y después `data-edone`. 1.47.0: `data-ehold="i"` en `.acts3` (solo si `s.c`) alterna `s.hold`; al ponerlo mueve la parada después de la última pendiente con `c`, renumera `n` y guarda; al quitarlo reordena con `entOrdenar` si hay `EPOS`. `entOrdenar` optimiza solo las pendientes sin `hold` y deja `held` después (si solo quedan en hold, las ordena a ellas). `erk` da 0.5 a las de hold (en `renderEnt` y en la Lista). `.ehold.on` amarillo `#f5c518`. 1.46.0: `#entLista` (en `#entTools`) reusa `#diagSheet`: cambia `#diagTitle` a "📋 Ruta en orden" y llena `#diagTxt` con las paradas en el orden de `renderEnt` (`erk`: pendientes con `c`, sin `c`, entregadas) como `k. #eNum nombre · tel`. `#supDiag` vuelve a poner su título y Compartir usa el título actual. 1.45.3: `parseCoord` primero prueba grados/minutos/segundos (`°`, `'`/`′`/`’`, `"`/`″`/`”`, coma o punto decimal, N/S y E/W/O) y devuelve 6 decimales si cae en Costa Rica; si no, sigue con decimal y geohash de Waze. 1.45.2: en `renderPk`, si `enR[p.id]` no tiene `c` y el paquete pendiente sí tiene ubicación, se muestra `data-act="aruta"` ("📍 Poner en la ruta"). `entAgregarPk` busca primero con `entParadasDe(p)` una parada sin `c` ni `done`; si existe le pone `c`, `n` = max+1, `pkId`/`pkFijo`, tel y nombre, borra `ub`/`waze` y reordena; si no, agrega una parada nueva como antes. 1.45.1: `renderPk` agrega `.sinub` cuando `!parseCoord(p.ubic)` y el paquete no está entregado ni devuelto; `#pkgList .pkg.sinub` lleva borde de 2 px `var(--bad)` (Mensajes no se toca). 1.45.0: `#p-buscar` (input search, 16 px para que iPhone no haga zoom) llama `renderPk()` en `input`. `renderPk` filtra con `ok(p)`: todas las palabras en el nombre (normalizado NFD local, no usa `sinTilde` por el TDZ del primer render), o la guía, o `p.num` exacto (1 a 3 dígitos), o 3+ dígitos del teléfono (últimos 8). Sin resultados muestra `.empty`. 1.44.5: `.acts` = `.eeta`, Waze, WhatsApp; `.acts2` = Quitar, Maps, Evidencia, Co-out; `.estop .eeta{flex:0 0 auto!important}`. 1.44.4: en `.acts` de `renderEnt` va primero Maps (`nav`) y luego Waze (`wz`). 1.44.3: la `.row` de `#scanCamBtn` y `label[for=scanGal]` va con `flex-wrap:nowrap`; la etiqueta dice "🖼️ Galería" (title con el texto largo). 1.44.2: `.estop .acts` sin salto (`nowrap`) con botones `flex:1 1 0` (tres iguales); en `.acts2` los botones crecen (`flex-grow:1`) y `.eeta` queda `flex:0 0 auto`; las dos líneas miden lo mismo. 1.44.1: *Mensajes* (`#msgList`) usa la misma tarjeta `.pkg`, así que el estilo de botones de 1.41.2 va con `#pkgList .pkg .actions`; `.pkg .actions` volvió a la regla original (columna 2, `flex-wrap:wrap`). 1.44.0: la tarjeta de `renderEnt` tiene `.acts` (Waze, Maps, WhatsApp `.wa`), `.acts2` (`data-equitar`, `.eeta`, `data-eok`, Co-out) y `.acts3` centrado (`.edone` grafito `#1f2125` o `data-eundo`), las tres con `grid-column:1/-1`. `.eeta` ya no ocupa toda la línea: `entEta` escribe `🚗 ~min<br>km` con `innerHTML`. 1.43.0: `entWaUrl(wa,t)` arma el `wa.me` con el texto "Estamos en camino…"; el link de la parada lleva `data-ewa="i"` y, en el click (sin `preventDefault`), se reescribe el `href` con `fmtT(el.dataset.min)` del `[data-eta=i]` (que `entEta` ahora guarda en `dataset.min`); sin ETA va sin el tiempo. 1.42.0: `data-equitar="i"` (en `.acts` de cada parada) con `confirm`; guarda `entPkg(s).id` en `S.ent.quitadas`, hace `splice`, `ESEL=-1`, `save()`, `render()` y `renderEnt()`. `entUnirLibres` excluye `quitadas` de los libres (no se auto-agregan) y `entAgregarPk` saca el id de `quitadas`. 1.41.2: sin `span.scanwa`; dos `.actions` (paste/edit/rescan; del/dev/WhatsApp) con `grid-column:1/-1`, `flex-wrap:nowrap` y botones `flex:1` de 12,5 px con elipsis; sin Waze. El aviso de ubicación ilegible es `.ubwarn` en la columna 2 (antes se metía en la columna del número). 1.40.1: `renderPk` agrega `.entregado` a `.pkg` (fondo `#eceef0`, `grayscale(1)`, opacidad .6; vuelve a 1 con `:focus-within`); los botones no se deshabilitan. 1.40.0: `.estop.ok .n` y `.epin.ok` con `text-decoration:line-through` (2 px); la tarjeta muestra `eNum(s)` también si está entregada sin `c` (antes "?"). En `renderPk`, `.num.tachado` (gris) si `p.st==="entregado"`. 1.39.2: `#supDiag` ya no copia: pone el texto en `#diagTxt` (`<pre>` con scroll, 12 px) dentro de `#diagSheet` y cierra `#supSheet`. `#diagShare` usa `navigator.share` (ignora `AbortError`) o `wa.me/${SOPORTE_WA}`; `#diagCopy` prueba `clipboard.writeText` y luego selección + `execCommand("copy")`. Sección nueva: paquetes con ubicación cuyo dueño (`entPkg` de cada parada) es una parada sin `c`, entregada, o más de una. 1.39.1: `#supDiag` lista las paradas sin `c` con `entPkg`, los paquetes con ubicación sin parada y las ubicaciones que no se leen (y el error con stack si algo falla). 1.39.0: `entUnirLibres()` (al inicio de `entSyncPk`) une cada parada sin paquete con el paquete libre de más palabras en común (de más de 2 letras, ×2) más la nota igual (+2), con mínimo 2 puntos, y agrega como paradas (`agregada:true`) los paquetes libres con ubicación que no estén entregados. `entPkg` cuenta `p.telsAnt` en el +1 de teléfono; Editar y corregir etiqueta guardan ahí el teléfono anterior. 1.38.2: `S.nums` es el respaldo {id:num} (en `NUBE_KEYS`). `numerar()` recupera de ahí el número que falte, numera los nuevos con max+1 (contando los quitados) y nunca reasigna uno existente; si `p.num` difiere de `S.nums`, gana `S.nums`. Se limpia solo con Vaciar lista, reemplazar al importar o al quitar el ejemplo. 1.38.0: `numerar()` (en `render()`): si falta algún `num`, la primera vez numera por índice; después cada nuevo recibe max+1, y llama `save()`. `.num` en Paquetes y Mensajes usa `p.num`. En Ruta, `eNum(s)` usa el `num` del paquete (`entPkg`) en la tarjeta, el pin y el popup, y si no hay paquete usa `s.n`. 1.37.3: `entSyncPk` copia también `nombre` (y `guia` si la parada no tiene) y siempre fija `s.pkId`. En `entPkg`, `pkId` vale +2 y cuenta antes del filtro `k>0`, así el paquete ya unido sigue siendo candidato aunque cambien nombre, guía y teléfono. 1.37.2: `entPkg` asigna puntos a cada candidato (guía +4, nombre +3 o +2, tel +1, `pkId` +1, ubicación +2) y en empate gana el `ing` más nuevo. `s.pkFijo` (puesto a mano con `data-elink`) manda sobre todo. Chip `data-elink` también con paquete cuando `!s.c`. 1.37.1: `geohash()` lo usa `parseCoord`. `entPkg` busca por nombre con `nomN` (igual) y después con `nom2` (dos primeras palabras). El chip `data-elink` sale cuando `entPkg(s)` no encuentra paquete: busca con un prompt (nombre, teléfono o guía), fija `s.pkId` y `render()` sincroniza. Ubicación a Ruta (1.37.0): en `entSyncPk()`, si `parseCoord(p.ubic)` difiere de `s.c` (más de 1e-5) se copia. Si la parada no tenía `c`, recibe el siguiente número, se borra `ub`, las que tienen `c` se ponen primero y, con `EPOS`, se llama `entOrdenar` (con setTimeout). Pestañas (1.36.0): sin `#tab-ruta`; el listener de `[data-tab="ruta"]` usa `?.`. `#v-ruta`, `calcRoute` y `renderRoute` quedan sin acceso desde la interfaz (`routeEta` para los mensajes sigue funcionando). `#tab-entrega` conserva su id y su `data-tab`, solo dice "Ruta". Orden en `renderEnt()` (1.35.0): la lista se ordena para mostrar con `erk(s)` (0 pendiente con `c`, 1 sin `c`, 2 `entDone`) y luego el índice; `data-ei` sigue siendo el índice real. `entSyncPk()` (1.35.1) además copia `p.tel` a `s.tel` cuando `phoneWA` difiere, y vuelve a pintar Entrega si está abierta. Teléfono a Entrega (1.34.0): `entParadasDe(p)` busca las paradas antes de editar (por `pkId` o `entPkg`); `entCopiarPk(p,ps)` copia tel, nombre y guía y fija `s.pkId`. `entPkg` ahora prueba primero `s.pkId`. Se usa en el guardar de Editar y en el de corregir etiqueta. Hora y GPS (1.33.0): `data-edone` guarda `s.at` y `s.gps` ({lat,lng,acc} de `EPOS`, o null) y los copia a `p.entAt`/`p.entGps`. Deshacer los borra. `renderPk` los muestra en `.ev` si no hay `pod`. Entregado en Paquetes (1.28.0): `data-edone` usa `entPkg(s)`, que ahora también busca por nombre igual con `sinTilde`. Pone `p.st='entregado'` y `p.entAt`, y guarda `s.prevSt` y `s.pkId` en la parada. `data-eundo` restaura `prevSt` si el paquete no tiene `pod`. Ambos llaman `render()`. Pie (1.27.1): `div.copy` con estilos en línea va después de `footer.appver` en `index.html` y `admin.html`, en letra de 11 px. Lupa (1.27.0): `#entBus` / `#entBuscar` entre `#entTools` y `#entMap`. `entBuscar(sig)` usa `sinTilde()` (NFD sin diacríticos): todas las palabras deben estar en el nombre, o 3 o más dígitos en el tel, o la guía. `EBUS.k` avanza con Enter. Pone `ESEL`, centra el mapa y hace `scrollIntoView` con block `end` por el mapa fijo. Tarjeta (1.26.4): `.acts` con los links, luego `.eeta` a todo lo ancho, luego `.acts2` sin salto de línea (Evidencia, Co-out, Entregado/Deshacer; 12,5 px, relleno 6 px). Botón `📲 Co-out` (`shortcuts://run-shortcut?name=Co-out`): se muestra en `.acts` de todas las paradas, después de WhatsApp (desde la 1.26.3). Sin ubicación: el chip `.eub[data-eub]` muestra `ubx`, que es `s.ub` o, si `s.ub` es `undefined` (ruta vieja), el `ubic` del paquete que coincide cuando no es una coordenada. que se convierte a "Co-out" si dice /^aplicaci[oó]n$/i, a "Vacío" si está vacío y a "Sin dato" si es `undefined`. `entUbicar(i)` hace `prompt` + `parseCoord`, o pone `EMAP.pickStop=i` y el click del mapa llama `entPonerC(i,c)`, que pone el siguiente número, la mueve con las demás que tienen coordenadas y llama `entOrdenar` si hay `EPOS`. Bandera `EAUTO`: en `gpsOk`, la primera lectura (acc < 500 m) llama `entOrdenar` si `S.ent.inicio` falta o queda a más de 0,8 km (`hav`); `entCargar` la reinicia y ordena de una vez si ya hay `EPOS`; el botón la pone en `true` para no ordenar dos veces. El punto azul (`.mepos`, `entMe()`) se actualiza con `watchPosition` mientras la pestaña está abierta. |
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
- Librerías cargadas con `loadScript()` solo al escanear: ZXing (`LIB_ZXING`) y Tesseract.js (`LIB_OCR`). Un solo worker de Tesseract (`SCAN.ocr`, idioma `spa`) por sesión.
- `scanCanvas(file, rot)`: reduce a 2000 px y gira de 90 en 90 (botón *Girar*).
- `readCodes(c)`: `BarcodeDetector` nativo si existe (Android); si no, ZXing con `TRY_HARDER` sobre la foto entera y por franjas, porque la etiqueta trae más de un código.
- `deskew(c)`: busca el ángulo (−12° a 12°, afinado a 0,25°) con el perfil de proyección de filas más marcado y endereza; con 2–3° de inclinación Tesseract pasaba de leer bien a no leer nada. Aplica gris y contraste.
- `parseLabel(texto, códigos)`: guía = código tipo `HZCR56461310263` (o regex en el texto); teléfono = 8 dígitos que empiecen en 2/4/5/6/7/8, prefiriendo líneas con *tel/cel*, y descartando dígitos de la guía; nombre = texto después de *TO/Destinatario/Nombre/Para* (o primera línea de 2–5 palabras); dirección = líneas con palabras de señas o provincias (`L_ADDR`), sin las del remitente (`L_SENDER`: Temu, China, aduana…).
- *Guardar* abre la cámara **dentro del mismo toque** (iPhone no deja abrirla después de un `await`) y agrega con `mkPkg()`. Las fotos de etiqueta no se guardan.
- Prueba local: las CDN están bloqueadas en el sandbox; se instalan los paquetes con npm y Playwright sirve los archivos interceptando las URL de jsDelivr. Las etiquetas de prueba se generan con JsBarcode.

## 3d. Soporte

- 1.49.0: `#supTab` ya no es parte de `nav.tabs`; es `button.hdsop` dentro de `.hdrow` (con `#daypill`) en `header.top`. Su lugar en la barra lo ocupa `#tab-cierres` (`data-tab="cierres"`), que muestra `#v-cierres` (sección vacía, contenido por definir); la lista de vistas del cambio de pestaña incluye `cierres`.

- Ícono: SVG en línea de audífonos con micrófono (`stroke=currentColor`, clase `.ico-sop`), sin archivos ni librerías; toma el color del texto. El mismo trazo va en `ayuda` y `contacto()` de `auth.js`.
- Botón `#supTab` (cuarto botón de `nav.tabs`, ícono `.ico-sop`, sin `role=tab`: abre la hoja y no cambia de pestaña; el manejador de pestañas filtra `nav.tabs [role=tab]`) y enlace `#supPie` en el pie → `openSupport()` abre `#supSheet`.
- WhatsApp: `wa.me/SOPORTE_WA` con texto que incluye la versión (`#appVer`).
- Videos: `fetch('videos.json',{cache:'no-cache'})`; si la URL es de YouTube usa un `<iframe>` de youtube-nocookie, si no un `<video controls playsinline preload=metadata>`. Al cerrar (`#supClose`, arriba a la derecha junto al título; mismo tamaño que `.btn.pri` del panel: 14 px, 8×12 px de relleno, radio 8 px) se pausan y se vacía la lista para no gastar datos.
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

- **Aviso de actualización:** `checkUpdate()` busca `id="appVer">x.y.z<` en `index.html` publicado; por eso el número de versión debe seguir en ese formato.

- **Versión:** semántica `mayor.menor.corrección` en `#appVer` (pie de `index.html` y de `admin.html`). Subirla en cada publicación y anotarla en `CHANGELOG.md`.

- Textos en español de Costa Rica (voseo en la app del repartidor, usted en el formulario del cliente).
- Commits en español, en imperativo ("Agregar…", "Corregir…").
- Cada cambio actualiza: `CHANGELOG.md` y los manuales afectados (`README.md`, `docs/`).
