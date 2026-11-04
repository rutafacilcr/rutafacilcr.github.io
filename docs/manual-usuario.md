# Manual de usuario · RutaFácil CR

Guía para el repartidor. No hace falta saber de computadoras.

**Link de la app:** https://rutafacilcr.github.io/

---

## La app hoy (versión 1.74)

Resumen de cómo está la app ahora. Más abajo se explica cada parte con la versión en que llegó.

**Cuentas (1.74):** cada mensajero ve solo lo suyo. Si en un celular entra otra cuenta, la app aparta la lista de la anterior.

**Avisos (1.75.2):** cuando la app pregunta algo o pide un dato (Salir, Código de recuperación, clave de 🚦 Tráfico, ubicación de una parada, unir parada con paquete) sale un aviso de RutaFácil con botones a la derecha. El naranja hace la acción; **Cancelar** o tocar afuera no hace nada.

**Cierres (1.74):** se guardan 15 días. **Bajá el PDF de cada fecha y guardalo o imprimilo: es tu respaldo.** En *Cierres* sale en rojo *⚠ Se borra en N días* cuando faltan 3 días o menos.

**Barra de abajo:** **Paquetes**, **Cierres**, **Mensajes** y **Ruta**. *Paquetes* lleva una burbuja con los paquetes que faltan por entregar y, desde la 1.86.0, *Ruta* lleva otra con las paradas de la ruta que faltan (las de Hold cuentan; entregadas y devueltas no). Siempre queda pegada al fondo de la pantalla y lo que desplazás es lo de arriba, así no tapa nada (1.85.1; antes, en iPhone, a veces se quedaba a media pantalla). **Soporte** está arriba, en el encabezado. En la computadora, si no ves los cambios, apretá **Ctrl + Shift + R**.

**Paquetes**
- Arriba, cinco contadores: **Recibidos**, **Entregados**, **Hold**, **Devueltos** y **Sin 📍** (sin ubicación).
- Cuatro botones grandes: **🧹 Vaciar lista** (en rojo), **Agregar a mano**, **Importar** y **Escanear**.
- Después, el buscador 🔍 y enseguida las tarjetas (desde la 1.69.1 ya no está el título *Lista del día*).
- El orden de las tarjetas es: activos, Hold, devueltos y al final los entregados (en gris; desde la 1.73.0 el número ya no sale tachado).
- Cada tarjeta tiene **1. Coordinar** (arriba a la derecha desde la 1.73.0), **Pegar respuesta**, **Editar**, **Escáner**, **Eliminar** (1.69.9; antes *Borrar*), **Devuelto** y **WhatsApp**.
- **⛔ Devolver en Ruta (1.87.0):** el paquete sale de la ruta y queda en *Paquetes* con ⛔ Devolver, para que al final del día sepás qué llevar al almacén. **↩ Quitar devolver** lo vuelve a meter en la ruta (si tiene ubicación).
- **Pedir ubicación (1.91.0):** el botón negro a la par del nombre (antes *1. Coordinar*) abre WhatsApp con el mensaje para pedir la ubicación. Solo sale cuando el paquete **no tiene ubicación**; si la tiene se quita, y si se la borrás con *Editar*, vuelve.
- Los paquetes **⛔ Devolver** y **⛔ Devuelto** se ven grises y sin botones. Solo queda activo el botón para quitar la marca: en un devuelto dice **↪ Regresar a Ruta** (1.69.4).

**Ruta**
- **Primera línea:** 📂 Cargar ruta, el nombre de la ruta, 📍 Ordenar desde aquí y, a la derecha, 📍 Estás aquí (tu GPS).
- **Arriba (1.91.0):** ya no sale "Estás aquí"; tu punto azul está en el mapa. **▶ Iniciar entregas** va a la derecha de 📂 Cargar ruta (sin ruta) o de 📍 Ordenar desde aquí (con ruta). Ya iniciada, ahí sale la hora de inicio (⏱) y **■ Finalizar**.
- **Ruta abierta sin paradas (1.87.2):** si todas las paradas salen (por ejemplo, a ⛔ Devolver), siguen el resumen, los vehículos, 🎯 Elegir en el mapa, 📋 Lista, 🚦 Tráfico y buscar.
- **Sin paradas (1.87.1):** arriba solo quedan 📂 Cargar ruta y 📍 Estás aquí en una línea, y el mapa sube; la explicación está abajo del mapa.
- **Segunda línea:** ▶ Iniciar entregas / ■ Finalizar. Guardan la hora y el punto de salida y de cierre para el reporte. Desde que tocás ▶ Iniciar, **el orden de la ruta queda fijo** (1.72.0): los nuevos van al final y solo 📍 / 🎯 la reordenan, preguntando antes.
- **🚦 Tráfico (1.70.0):** con la clave gratis de TomTom, el tiempo a la próxima parada toma en cuenta el tráfico.
- **Tercera línea:** a la izquierda, el resumen (⏱ tiempo, km, inicio y fin) y los vehículos 🏍️ 🚙 🚐 (🚙 carro marcado de entrada). A la derecha, 🎯 Elegir en el mapa y 📋 Lista.
- **El mapa:** la línea va por las calles reales. Los pines pendientes quedan encima, Hold en amarillo y los que están en el mismo lugar se abren en abanico.
- **El mapa siempre está (1.86.1):** aunque no haya paradas o acabés de *Vaciar lista*, sale el mapa con tu punto actual. En Paquetes, **➕ Agregar a la ruta** arma la ruta del día si no hay una. Si borrás la ubicación de un paquete y guardás, su parada sale del mapa y cuenta en **Sin 📍** hasta que le pongás una nueva. Si se la ponés desde **Ruta** (tocando el "?"), también queda en Paquetes al instante (1.86.2).
- **Cada parada:** Waze, Maps, WhatsApp "Estamos en camino 🏍️…" (con el ícono del vehículo elegido), Quitar, Evidencia, Co-out, Hold, ⛔ Devolver y ✓ Entregado.
- **✓ Entregado** guarda la fecha y la hora reales del toque.

**Cierres**
- Empieza directo en *Reporte de entregas* (1.73.2: se quitó el aviso "Próximamente").
- Hay un reporte por cada grupo de *Entregas del …*, según el día en que se recibieron los paquetes. También salen las listas ya vaciadas.
- Cada grupo tiene su botón **📄 PDF** horizontal.
- **Guías por fecha de recibido** (1.71.0 a 1.72.3): un PDF por fecha de recibido (*Guías · Paquetes recibidos 31/10/2026*) con Nombre, Tel., Guía, Dirección y Hora entrega, separado por día de entrega.
- El **encabezado** trae: fecha, mensajero, recibidos el, km, horas, días de entrega, promedio por entrega, y recibidos, entregados y devueltos.
- Las **filas** van por fecha y hora de entrega, con estas columnas: número, guía / pedido, teléfono, nombre, estado, fecha recibido, fecha y hora de entrega, y tiempo y km desde la entrega anterior.

**Mensajes**
- Están **1. Pedir ubicación** (antes *1. Coordinar*, 1.91.1), **2. Voy en camino** (lleva el ícono del vehículo después de "camino"), **3. Comprensión** y **4. Horario extendido**, en dos filas. Desde la 1.89.0 ya no está *Formulario*.
- **Botones (1.89.0; 1.91.0):** abajo a la derecha queda **Abrir WhatsApp** (*Pegar respuesta* se usa desde *Paquetes*). Desde la 1.91.0 tampoco están el texto de ayuda, el título *Clientes* ni la tarjeta *Respuestas del formulario*. Se quitaron *Copiar texto*, *Confirmó* y *No responde*; el estado se cambia tocando la etiqueta del cliente (por ejemplo 🟡 Pendiente).
- **Estado automático (1.92.0):** la etiqueta a la par del nombre cambia sola: **🟡 Sin enviar**, luego **📨 Esperando respuesta** cuando tocás *Abrir WhatsApp*, y **🔵 Confirmado** cuando pegás la ubicación (o si el paquete ya la tiene). Tocarla no hace nada. Los entregados y devueltos solo dicen su estado.
- **Filtros (1.88.0; nombres desde 1.92.0):** debajo de buscar están **Todos**, **🟡 Sin enviar**, **📨 Esperando respuesta** y **🔵 Confirmados**, con cuántos hay en cada uno. Tocá uno para ver solo esos clientes (por ejemplo, a quién volver a escribirle). La etiqueta cambia con **Confirmó**, **No responde** o al pegar la respuesta con ubicación. Los entregados, devueltos y para devolver solo salen en *Todos*.
- Los clientes salen en el **mismo orden que en Ruta** (1.69.3). Los entregados, en Hold o devueltos se ven grises y bajan al final, y los que no están en la ruta van después de los pendientes.

**Confirmaciones:** desde la 1.69.0, al borrar, devolver, vaciar o guardar cambios sale una hoja abajo con dos botones grandes: **Cancelar** y la acción (en rojo si borra o desactiva).

**Si algo falla**
- Arriba sale un aviso rojo "Error en la app…". Mandale captura a soporte.

---

## 1. Antes de empezar

- Usá la app en el **mismo celular** donde tenés WhatsApp con el número que les escribe a los clientes. Los mensajes salen de la cuenta de WhatsApp abierta en ese celular.
- Recomendado: usar **WhatsApp Business**. Es gratis y los clientes confían más.
- La lista se guarda **en ese celular**. Si abrís la app en otro teléfono o en la PC, no vas a ver la misma lista.

### Instalar el ícono

- **iPhone (Safari):** abrí el link > botón **Compartir** > **Agregar a pantalla de inicio** > **Agregar**.
- **Android (Chrome):** abrí el link > menú **⋮** > **Agregar a la pantalla principal** (o **Instalar app**).

Vas a ver el pin naranja con el paquete sobre fondo grafito. Después abrí siempre la app desde el ícono **RutaFácil**. En iPhone, el ícono guarda sus datos aparte de Safari.

**Importante:** instalá el ícono **antes** de crear la cuenta o entrar. En iPhone, Safari y el ícono cuentan como teléfonos distintos.

### Conocer la app antes de crear la cuenta (1.75.0)

En la pantalla de entrar hay un recuadro corto que explica la app, con dos enlaces:

- **Ver cómo funciona** abre https://rutafacilcr.github.io/conoce.html: para quién es, qué te ahorra, los 4 pasos con capturas, videos de un minuto y preguntas frecuentes. Se ve sin cuenta, así que podés mandar ese link a un compañero que quiera probarla. Las capturas y los videos tienen datos inventados.
- **Privacidad** abre https://rutafacilcr.github.io/privacidad.html: por qué se pide tu número, qué datos se guardan, quién los ve y cómo pedir la baja (WhatsApp al 6270 0666 desde el número de tu cuenta).

El formulario que llena el cliente también tiene el enlace a *Privacidad* al final.

### Tu cuenta

La app pide entrar con **tu número de teléfono** y un **PIN de 6 números**.

1. **Crear cuenta** (solo la primera vez): tocá *¿No tenés cuenta? Crear cuenta*, escribí tu nombre (así te ven los clientes en los mensajes), tu número de WhatsApp y elegí un PIN (los campos salen en blanco). No uses PIN fáciles como 111111 o 123456.
2. **Activación:** la cuenta queda *esperando activación*. Pagá la mensualidad por **SINPE Móvil** al número que muestra la pantalla (si salen dos, a cualquiera de los dos), con el detalle **RF + tu número** (ej. *RF 88887777*), y avisale al administrador por WhatsApp. Cuando la active, tocá **Revisar de nuevo**.
3. **Los días siguientes** la app abre sola. Si te pide entrar, poné tu número y PIN.

Reglas de la cuenta:

- **Es personal y funciona en un solo teléfono.** Si entrás en otro celular, ese queda *esperando aprobación* hasta que el administrador lo apruebe; cuando lo aprueba, el teléfono anterior se cierra.
- **Tu nombre** en los mensajes sale de la cuenta, pero lo podés cambiar en *Mensajes* (por ejemplo, solo el primer nombre). Si borrás el campo, vuelve el nombre de la cuenta.
- **Sin internet** la app sigue abriendo hasta 3 días con la última revisión.
- **Mensualidad:** al final de la app dice *al día hasta el …*. Si vence, tenés unos días de gracia (lo dice en rojo) y después la app se bloquea hasta que pagués.
- **Código de recuperación (1.74):** al crear la cuenta la app te muestra un código de 12 letras (ej. *ABCD-EFGH-JKMN*). **Tomale captura.** Si ya tenías cuenta, bajá hasta el final de la app (la línea gris donde dice *Cuenta de …*) y tocá **🔑 Código de recuperación**; sale un aviso que explica para qué sirve: tocá **Sacar código** (o **Cancelar**). Si ya tenías uno, el anterior deja de servir. No se lo des a nadie.
- **¿Olvidaste el PIN?** En la pantalla de entrar tocá **Usá tu código de recuperación**: número, código y un PIN nuevo. Entrás de una vez y te damos un código nuevo (cada código sirve una vez). Si escribís mal el código 5 veces, ese número queda bloqueado 30 minutos. Sin código, pedile un PIN nuevo al administrador por WhatsApp.
- **¿Cambiaste de celular?** En el celular nuevo entrá con tu número y PIN. Si sale *Esta cuenta está en otro teléfono*, tocá **Usar código de recuperación** y la cuenta pasa al nuevo (el viejo se cierra). Sin código, el administrador lo aprueba (normalmente el mismo día) y la pantalla se abre sola.
- **¿Necesitás ayuda?** En la pantalla de entrar está el enlace *Escribinos por WhatsApp* (soporte: 6270 0666).
- **Salir:** al final de la app, **Salir**. Tu lista de paquetes se queda en el celular.
- **Un celular para dos cuentas (1.74):** si en este celular entra otra cuenta, la app guarda aparte tu lista y abre la de la otra persona, vacía o con lo suyo. Nunca ves los paquetes de otro mensajero ni él los tuyos. Cuando volvés a entrar con tu número, aparece tu lista como la dejaste (también está en la nube).

---


**Mientras esperás la activación** el botón de abajo está gris y dice *⏳ Esperando activación*. No tenés que tocar nada: la app revisa sola cada minuto. Cuando el administrador activa tu cuenta, sale *✅ Cuenta habilitada* y el botón se pone naranja: tocá **Entrar**.

## 2. Rutina diaria

La app tiene cuatro pestañas en la **barra de abajo** (orden desde la 1.67.3: Paquetes, Cierres, Mensajes, Ruta): **Paquetes** (📦, con un globito que dice cuántos hay), **Mensajes** (💬), **Ruta** y **Cierres** (por ahora vacía). El botón **Soporte** (🎧) que abre la ayuda está **arriba**, en el encabezado, a la par del día de entrega. La pestaña en la que estás se marca en naranja.

### Día antes: cargar paquetes (pestaña **Paquetes**)

La primera vez vas a ver datos de ejemplo: tocá **Borrar ejemplo**.

Tenés cuatro formas de cargar:

1. **Escanear etiquetas (lo más rápido con muchos paquetes):** tocá **📷 Escanear etiquetas** y tomale foto a la etiqueta.
   - La app saca la **guía** del código de barras y trata de leer **nombre, teléfono y dirección**.
   - Revisá los datos, corregí lo que haga falta y tocá **Guardar y tomar otra**. Así seguís con los 70 sin salir de la pantalla. Al final tocá **Terminar**.
   - **Si ya tomaste las fotos:** tocá **🖼️ Galería** y seleccioná varias. La app las va mostrando una por una.
   - **Para que lea bien:** etiqueta derecha y llenando la pantalla, a la sombra, sin reflejo y con la bolsa estirada. Si sale mal, tocá **↻ Girar y leer de nuevo** o tomá otra foto.
   - Si la guía ya estaba en la lista, sale un aviso en rojo para que no la repitás.
   - La primera vez tarda un poco más porque baja el lector de texto (unos MB). Después queda guardado en el celular.
   - Lo que no lea, lo escribís a mano en el mismo cuadro. En **Ver texto leído** está todo lo que la app alcanzó a leer.
2. **Plantilla de Excel:** tocá **Bajar plantilla de Excel**, llenala (un paquete por fila) y subila con **Subir Excel / CSV**.
3. **Copiar y pegar:** seleccioná las filas en Excel o Google Sheets, copiá y pegá en el cuadro **Importar lista** > **Agregar a la lista**.
4. **A mano:** **Agregar un paquete a mano**.

Columnas: `nombre`, `telefono`, `direccion`, `ubicacion`, `guia`, `nota`.

- **Teléfono:** los 8 dígitos. La app agrega el +506.
- **Ubicación:** pegá el link completo que manda el cliente (`https://maps.google.com/?q=...`), un link de Waze o las coordenadas (`9.99,-84.11`). Debajo sale en verde **✓ Coordenadas detectadas**. Los links cortos tipo `maps.app.goo.gl` no se leen: abrilos primero y copiá el link largo.
- Cada paquete muestra **● Ubicación lista** o **○ Falta ubicación**.

### Día de entrega (pestaña **Entrega**)

1. Tocá **Entrega** en la barra de abajo (entre *Ruta* y *Soporte*).
2. Tocá **📂 Cargar ruta** y elegí el Excel del día, por ejemplo **Ruta 2026-11-01.xlsx** (en iPhone está en la app *Archivos*, carpeta *RutaFacilCR*). Sirve la ruta de cualquier día: una ruta se reparte en varios días (desde la 1.67.4 no hay aviso de fecha).
3. La pantalla queda en dos partes: **arriba el mapa** con las paradas numeradas en el orden de la ruta y la línea del recorrido; **abajo la lista** de paradas.
4. Tocá una parada para verla en el mapa (se pone naranja y se acerca). Tocá un pin del mapa para bajar a esa parada.
5. En cada parada los botones van en tres filas: **Waze · Maps · WhatsApp**, luego el tiempo estimado y por último **Evidencia · Co-out · Entregado**. **🚗 Waze** o **🗺️ Maps** te llevan al punto, **WhatsApp** abre el chat del cliente y **📸 Evidencia** abre la prueba de entrega (fotos y firma) si el paquete está en tu lista. **✓ Entregado** marca la parada como entregada sin evidencia: el círculo del número y el pin del mapa se ponen grises, y el mismo paquete queda como **entregado** en *Paquetes* (lo busca por guía, teléfono o nombre). Esto también pasa con las paradas que marcaste antes o desde otro aparato, apenas abrís la app. Desde la 1.33.0 también se guarda **la hora y el lugar** (GPS) donde tocaste Entregado; en *Paquetes* sale "✓ Entregado fecha · 📍 dónde" con link al mapa. Para tener fotos y firma, usá **📸 Evidencia**. Si lo tocaste sin querer, usá **↩ Deshacer**.
6. **Paradas con "?" (sin ubicación):** a la par del nombre sale lo que dice la columna ubicación del Excel: **Co-out** (cuando dice "Aplicacion"), "no respode" o **Vacío**. Tocá esa etiqueta para pegar el link de Google Maps o Waze (o las coordenadas). Si lo dejás vacío, tocás el punto en el mapa. La parada entra a la ruta con número y se reordena desde donde estás. Todas las paradas tienen el botón **📲 Co-out**, que abre la app Co-out del iPhone. Hay que prepararlo una sola vez: abrí la app **Atajos**, tocá **+**, agregá la acción **Abrir app**, elegí **Co-out** y ponele de nombre al atajo **Co-out**, tal cual. La primera vez el iPhone pregunta si dejás que RutaFácil abra Atajos: tocá *Abrir*. Las rutas cargadas antes de la 1.25.0 dicen "Sin dato" hasta que las volvás a cargar.
7. **🔍 Buscar cliente** (debajo del resumen, arriba del mapa): escribí parte del nombre, por ejemplo "daniel lopez" (no importan las tildes), el teléfono o la guía. Te lleva a esa parada: la marca en naranja, centra el mapa y baja la lista hasta ella. Si hay varias que coinciden, sale 1/2 y con **Buscar** (Enter) pasás a la siguiente.
8. **⏱ Ruta** (a la derecha de *Estás aquí*): tiempo estimado de lo que te falta. Suma el manejo por calle desde donde estás hasta la última parada más 3 a 5 min por entrega (llegar, buscar el paquete, entregar y tomar la evidencia). También muestra los km aproximados por calle y la línea **Inicio … · fin …**: inicio es la hora actual y fin es a qué hora terminarías si salís en ese momento. Baja conforme vas entregando.
6. Las paradas **sin ubicación** van al final, sin pin.
7. **📍 Ordenar desde aquí:** toma tu ubicación (punto azul en el mapa) y reordena las paradas que faltan desde donde estás, por la ruta más corta y respetando el horario del cliente si lo tenés. Las entregadas pasan al final. Podés tocarlo otra vez a media ruta.
   A la par de **📸 Evidencia** ves cuánto te falta para llegar a ese cliente desde donde estás (por ejemplo 🚗 ~8 min · 2,1 km). Se calcula por calle (gratis, con OSRM) y, si eso falla, en línea recta. No incluye tráfico, así que puede diferir un poco de Waze; para el tiempo con tráfico abrí Waze. Desde la 1.20.1 la ruta **se ordena sola** desde tu punto apenas el celular te ubica (al cargarla o al abrir *Entrega*), así que la parada 1 es por donde conviene empezar. El orden se calcula con el tiempo real por calle (si hay internet), así que respeta calles sin salida, ríos y vías de una sola dirección. Ojo: la app busca el recorrido más corto **completo**, no solo la parada más cercana; a veces conviene empezar por un extremo para no devolverse.
8. Si el GPS no funciona (pasa en iPhone si Safari no tiene permiso), tocá **🎯 Elegir en el mapa** y luego tocá en el mapa el punto donde estás. Para dar permiso: *Ajustes > Privacidad y seguridad > Localización > Sitios web de Safari > Al usar la app*.

La ruta cargada se guarda en tu cuenta (sale el aviso *Ruta subida a la nube ☁️*): si la cargás en la PC, aparece también en el teléfono al abrir *Entrega* (los dos aparatos deben tener la versión 1.19.1 o más nueva; mirá el pie y tocá *Actualizar* si hace falta).

### Los mismos paquetes en el teléfono y en la PC

Desde la versión 1.18.0 la lista se guarda en tu cuenta. Si entrás con tu número y PIN en el teléfono y en la PC, ves los mismos paquetes, y lo que cambiás en uno aparece en el otro en menos de un minuto (o al volver a la app). Abajo, en el pie, dice **☁️ al día** cuando está sincronizado. Si dice **☁️ sin activar**, falta que el administrador corra `supabase.sql`; si dice **sin conexión**, tocalo para reintentar.

- La primera vez, el aparato que ya tiene paquetes los sube; en el otro aparato aparecen solos.
- Las fotos de evidencia no se copian: se ven en el teléfono donde se tomaron y quedan respaldadas en Supabase.
- Si no hay internet, la app sigue funcionando y sincroniza cuando vuelve la señal.

### Día antes: avisar a los clientes (pestaña **Mensajes**)

1. Arriba revisá **tu nombre** y el **día de entrega**. Debajo sale la lista de clientes.
2. En cada cliente tocá **Abrir WhatsApp** > **Enviar** > volvé a la app.
3. **Primer mensaje, sin links:** *"Hola Sofía, soy Victor, le llevo su paquete de Temu el viernes. ¿A qué hora le queda bien recibirlo? Si puede, mándeme su ubicación por aquí 📍 ¡Gracias!"*
4. *(Hasta la 1.88.0)* **Cuando el cliente conteste**, en ese cliente elegí **2. Formulario** (arriba del texto) y tocá **Abrir WhatsApp**. Le llega un segundo mensaje corto: *"Gracias Sofía. Para no fallarle con la entrega, ¿me ayuda marcando aquí su hora y las señas de la casa? Es 1 minuto: …"*. Como ya habló con vos, confía más en el link.
5. En el formulario el cliente marca horario y señas. Al enviarlo ve *¡Listo, gracias!* con el aviso **🪪 Recuerde que para la entrega debe presentar la cédula.** Para la ubicación, lo principal es **mandarla por WhatsApp** (clip 📎 > Ubicación); también puede pegar un link o usar el GPS.
6. Lo que llene **entra solo** a la app (revisa cada minuto, o tocá **Revisar respuestas ahora**) y queda **Confirmado** con 🕓 horario y 🏠 señas.
7. **Cuando el cliente responde por el chat (lo más común):** en WhatsApp mantené presionado su mensaje (la hora, la ubicación o los dos seleccionados) > **Copiar**. En la app tocá **📋 Pegar respuesta** en ese cliente. La app saca sola la **hora** y la **ubicación** y lo deja **Confirmado**. Si el iPhone pregunta "Permitir pegar", tocá **Permitir**. Si la ubicación no se puede copiar del chat, abrila, tocá **Compartir** > **Copiar** y volvé a tocar **📋 Pegar respuesta**.

   **Si el cliente manda un negocio o lugar (1.82.0, lo nuevo):** sale la ventana **📍 Falta la ubicación** (1.84.1: ya no trae el botón para pedírsela otra vez al cliente, porque si ya la mandó le molesta):
   - **Sacarla vos con Waze:** en WhatsApp tocá la tarjeta del lugar y elegí **Waze**; en Waze tocá **Compartir** > **Copiar**; volvé a la app y tocá **📋 Pegar respuesta**. El link de Waze trae el punto exacto.
   - Si no podés usar Waze, **🎯 Marcar a mano en el mapa** abre solo el mapa: acercalo a donde muestra la tarjeta de WhatsApp y tocá el punto (desde la 1.85.2 ya no busca el nombre ni muestra lista de lugares).

   **Historial (1.81.0 a 1.81.5):** en iPhone, cuando el cliente escoge un lugar de la lista (por ejemplo *Aby al grill*) en vez de *Enviar mi ubicación actual*, al copiar sale solo el nombre y una página web, sin coordenadas. Ahora la app lo detecta y abre **🎯 Marcar en el mapa**: busca el nombre del lugar (o al menos la zona, por ejemplo San José), vos tocás el punto exacto y **Usar este punto**. También podés abrir el mapa a mano con el botón **🎯 Marcar en el mapa** en la ventana de Pegar respuesta. Desde la 1.81.1 busca primero lo que pegaste (nombre del negocio y dirección), aunque el paquete ya tuviera ubicación. Si lo encuentra, deja el pin puesto: revisá que esté bien y tocá **Usar este punto**. Si no, el mapa queda cerca de la dirección o la ciudad y vos tocás el punto. Desde la 1.81.2, si tenés la clave de 🚦 Tráfico (TomTom, gratis), busca el negocio ahí primero, porque TomTom conoce muchos más negocios. Arriba del mapa hay un buscador: si no lo encuentra, escribí el barrio o una calle que se vea en la tarjeta de WhatsApp (por ejemplo *Calle 21, Cristo Rey*) y tocá **🔍 Buscar**, o acercá el mapa y tocá el punto. Desde la 1.81.4 te muestra una **lista de hasta 6 lugares** con ese nombre, cada uno con su barrio o cantón, provincia y a cuántos km queda de tu zona (el centro de tus otros paquetes). Desde la 1.81.5 solo deja el pin puesto si el nombre coincide y está a 30 km o menos; si no, no marca nada y escogés vos de la lista o tocás el punto (los negocios pequeños casi nunca están en los mapas). Sirve para entregas fuera de la GAM. **Truco para la ubicación exacta:** tocá la tarjeta en WhatsApp, abrila en **Waze**, tocá **Compartir** > **Copiar** y pegá ese link en **📋 Pegar respuesta**: el link de Waze sí trae las coordenadas. Si alguno quedó mal puesto, volvé a copiar la tarjeta, tocá **📋 Pegar respuesta** y marcá el punto correcto. Lo mejor sigue siendo pedirle al cliente: 📎 > **Ubicación** > **Enviar mi ubicación actual**.

**Elegir qué mensaje mandar:** cada cliente tiene arriba los botones **1. Coordinar**, **2. Formulario**, **3. En camino**, **4. Comprensión** y **5. Horario extendido** (desde la 1.89.0 son cuatro: **1. Coordinar**, **2. En camino**, **3. Comprensión** y **4. Horario extendido**; *Formulario* se quitó).

- **4. Comprensión:** para el cliente que pregunta por su paquete mientras vas manejando: *"Hola 😊 Ana - Entiendo su preocupación, su paquete es importante para nosotros…"*.
- **5. Horario extendido:** para ofrecer entregar hoy de 5:00 p. m. a 9:00 p. m.: *"¡Hola! 😊 Ana - Debido al alto volumen de paquetes de TEMU recibidos…"*.
- Los dos usan el primer nombre del cliente y se pueden cambiar en **✏️ Editar textos de los mensajes**.
 El que está en oscuro es el que se va a mandar: la vista previa, **Abrir WhatsApp** y **Copiar** usan ese mensaje. La app propone sola el siguiente (después del primero, el formulario), pero podés tocar cualquiera.

**Aviso de la cédula:** los mensajes *1. Coordinar* y *3. Voy en camino* terminan con *Recuerde que para la entrega debe presentar la cédula.* Se puede quitar o cambiar en **✏️ Editar textos de los mensajes**.

**Guardar contactos del día:** en *Mensajes*, arriba, tocá **📇 Guardar contactos del día**. Baja un archivo con todos los clientes con el nombre **TM-Nombre-pedido** (el pedido es la guía; si no tiene guía queda *TM-Nombre*). Así, cuando te contesten, WhatsApp muestra quién es. El prefijo *TM* se puede cambiar en la casilla **Prefijo**.
- **iPhone:** la app muestra primero los pasos y luego el menú de compartir. **No toqués *Contactos* ni la vista previa** (el iPhone solo guarda el primero). Lo más fácil: elegí **Mail**, mandátelo a tu correo y abrí el adjunto > **Agregar todos los contactos** > **Crear contactos nuevos**. También sirve **Guardar en Archivos** y abrirlo desde la app **Archivos**.
- **Android:** abrí el archivo descargado y elegí **Contactos** para importarlos.
- Los nombres salen bien escritos aunque el escáner los haya leído con mayúsculas raras (*Chavarría*, no *ChavarríA*) o con un guion al inicio.
- Si un cliente tiene varios paquetes con el mismo teléfono, queda un solo contacto con las guías juntas (*TM-Sofía-PO1/PO2*).

**Bajar Excel del día:** en *Mensajes*, el botón **📊 Bajar Excel del día** baja la plantilla de Excel llena con todos los clientes: nombre, teléfono, dirección, ubicación, guía, nota, **fecha ingreso** (el día en que se agregó el cliente a la app) y **contacto** (*TM-Nombre-pedido*). Sirve de respaldo y se puede volver a cargar en *Paquetes > Importar*.
- **En iPhone:** se abre el menú de compartir. Elegí **Guardar en Archivos** > **En mi iPhone** > carpeta **RutaFacilCR** (la primera vez creala con el ícono de carpeta nueva) > **Guardar**. Después el iPhone propone esa misma carpeta. El Excel se ve en la app **Archivos** (y se abre con Numbers o Excel). Los clientes que ya estaban antes de la versión 1.17.0 quedan con la fecha del día en que se actualizó la app.

**Buscar un cliente:** arriba de la lista hay un buscador. Sirve por nombre, guía o los últimos dígitos del teléfono, para saber de quién es un número que te escribe.

**Si WhatsApp abre con un texto viejo:** WhatsApp guarda el borrador de un mensaje que no se envió y a veces lo muestra en vez del nuevo. Borrá ese texto en el chat, volvé a la app y tocá **Abrir WhatsApp** otra vez.

Los textos de los tres mensajes se editan al final de **Mensajes**, en **✏️ Editar textos de los mensajes** (viene cerrado para que no estorbe).

**Para que los clientes confíen más:**
- Usá **WhatsApp Business** con foto de perfil, nombre (ej. "Victor · Entregas Temu") y descripción.
- El link solo se manda a quien ya contestó, y la vista previa en WhatsApp es sobria: solo el link, sin tarjeta ni logo. (Los mensajes que ya se mandaron antes pueden seguir mostrando la tarjeta; los nuevos salen sin ella.)
- Con un dominio propio el link se vería más corto y confiable (pendiente de decidir).

Variables que podés usar en los mensajes: `{nombre}` `{guia}` `{direccion}` `{fecha}` `{yo}` `{eta}` `{formulario}` (este último va en el mensaje del formulario). Si cambiás el mensaje y quitás `{formulario}`, la app agrega el link del formulario al final sola. El cuadro del mensaje crece para mostrar el texto completo.

### Día de entrega (pestaña **Ruta**)

1. **Punto de salida:** pegá las coordenadas o el link de donde salís, o tocá **📍 Usar mi ubicación actual** (pone tu ubicación y la hora de ahora). En Google Maps, dejá el dedo presionado sobre el lugar y copiá los números.
2. **Hora de salida:** a qué hora arrancás (ej. 8:00 am).
3. Elegí si incluir **todos** o **solo confirmados**, y si volver al punto de salida.
4. Tocá **Calcular mejor ruta**. Con 70 paquetes tarda unos segundos.
   - La app ordena las paradas para manejar lo menos posible **y llegar dentro del horario** que confirmó cada cliente (🕓). Entiende cosas como *8 a 10 am*, *2 a 4 pm*, *4 pm*, *en la tarde*, *después de las 3* o *cualquier hora*.
   - Cada parada muestra la **hora aproximada de llegada**. Si llegás antes de su horario dice cuánto esperar; si quedaría tarde sale **⚠ Llegarías … tarde**. Arriba dice a qué hora terminás.
   - Si salen ⚠: salí más temprano, avisale al cliente o pasá el paquete a otro día.
   - **A media ruta** (por ejemplo, si alguien no estaba): tocá **📍 Usar mi ubicación actual** y **Calcular mejor ruta** otra vez. Reordena solo lo que falta, desde donde estás y con la hora de ahora.
5. **Iniciar ruta** abre todo el recorrido en Google Maps. Con más de 10 paradas sale en **Tramo 1, Tramo 2…**
6. En cada parada:
   - **Waze** / **Maps**: navegar a esa casa.
   - **Voy en camino**: WhatsApp con la hora aproximada de llegada.
   - **Entregado** o **No se pudo** al terminar.
7. Los paquetes sin ubicación salen aparte, en un aviso amarillo.

Los km y tiempos son aproximados. Google Maps o Waze dan el tiempo real con tránsito.

### Prueba de entrega (al tocar **Entregado**)

Cada vez que marcás un paquete como **Entregado** se abre la pantalla **Prueba de entrega**:

1. La app toma sola la **fecha y hora** y tu **ubicación GPS** (con su precisión en metros).
2. Tocá **📷 Tomar foto** al menos **3 veces**. Sugerencia: el paquete en la puerta, la fachada y el paquete en manos de quien recibe.
3. Cada foto lleva un **sello** con fecha, hora, cliente, guía y coordenadas.
4. **Firma:** escribí el nombre de quien recibe y pedile que firme con el dedo en el recuadro blanco (**Borrar firma** si sale mal). Si no quiere firmar, marcá **No quiso firmar**: queda anotado.
5. Tocá **Confirmar entrega**. Si falta algo (3 fotos, la firma o "No quiso firmar", o la ubicación), la app te dice qué falta y te lleva a esa parte; arriba del botón también sale en rojo. Si el GPS no se pudo obtener, la app pregunta si querés confirmar **sin GPS**.

La evidencia se guarda **en el celular** y se **sube a Supabase** como respaldo. En la lista vas a ver *📷 3 fotos · fecha · 📍 ±m · ☁️ respaldada* (o *⏳ sin subir* si no había internet: se sube sola después). Tocá **Ver evidencia** para ver las fotos y el punto en el mapa.

**Activar la ubicación en tu iPhone (una sola vez):** *Ajustes > Privacidad y seguridad > Localización* (encendida) *> Sitios web de Safari > Al usar la app* y activá *Ubicación exacta*.

**Espacio:** cada entrega con 3 fotos ocupa ~0,4 MB. El plan gratis de Supabase (1 GB) alcanza para unas 2.500 entregas. Las fotos ya respaldadas se borran solas del celular a los 7 días (siguen en Supabase).

**Ver los respaldos en la PC:** en Supabase, **Storage > evidencias** (fotos por fecha) y **Table Editor > entregas** (fecha, hora, GPS y lista de fotos).

### Recorrido de hoy

En la pestaña **Ruta**, abajo, aparece **Recorrido de hoy** en cuanto hacés la primera entrega: un mapa con cada entrega numerada (1, 2, 3…) en el orden en que la hiciste, la hora de cada una y los km aproximados. **Abrir en Google Maps** muestra el mismo recorrido allá. Se arma con el GPS de cada prueba de entrega, así que marca los puntos de entrega, no cada calle que recorriste (una página web no puede seguir el GPS con el celular bloqueado).

### Al terminar el día

**Paquetes** > **Vaciar lista** (tocá dos veces para confirmar). Antes, revisá que todas las evidencias digan **☁️ respaldada**: al vaciar la lista, la evidencia queda en Supabase.

---

## 3. Estados de un paquete

Cada etiqueta lleva ícono, nombre y color (1.79.0; círculos de color desde la 1.84.0), así se distingue aunque no se vean bien los colores:

| Etiqueta | Color | Significa |
|---|---|---|
| 🟡 Pendiente | Amarillo | Todavía no confirma. |
| 🔵 Confirmado | Azul | Confirmó por WhatsApp o llenó el formulario: va en la ruta. |
| 🟠 No responde | Naranja claro | Le escribiste y no contestó. |
| 🟢 Entregado | Verde | Listo. La tarjeta queda gris, pero se lee completa y sus botones se pueden tocar. |
| 🔴 No se entregó | Rojo | Intentaste y no se pudo. |
| ⚪ Devuelto | Gris | Volvió al almacén. Para que vuelva a la ruta, tocá el botón naranja **↪ Regresar a Ruta**. |

Tocá la etiqueta de color para pasar al siguiente estado.

Desde la 1.79.0 los botones son más grandes (44 px, cómodos para el dedo; en Mensajes desde la 1.84.0, igual que las etiquetas de estado) y los naranja son más intensos para leerse bien al sol. Si un botón muestra una ruedita (por ejemplo **Confirmar entrega**, **Usar esta respuesta**, **Guardar contactos** o **Bajar Excel**), está trabajando: esperá a que termine; mientras tanto no se puede tocar dos veces. Si se ve gris con borde punteado, está desactivado. Cuando algo sale bien, abajo aparece un aviso oscuro con borde naranja que lo confirma.

---

## 4. Problemas comunes

**¿No ves la versión nueva?** Cuando se publica un cambio, la app muestra abajo *Hay una versión nueva · **Actualizar***: tocalo. Si no sale, cerrá la app por completo y abrila otra vez. GitHub puede tardar hasta 10 minutos en entregar la versión nueva.

**Ayuda:** tocá **Soporte** (el botón con audífonos arriba, en el encabezado, o *Soporte* al final de la pantalla). Ahí podés escribirnos por WhatsApp al **6270-0666** (el mensaje ya lleva tu versión de la app) y ver los **videos** de cómo se usa cada parte:

1. Entrar y conocer la app (crear cuenta, código de recuperación, activación, las 4 pestañas y Soporte)
2. Cargar los paquetes (Escanear, Importar el Excel, Agregar a mano, contadores y buscador)
3. Mensajes por WhatsApp (los 5 mensajes, Abrir WhatsApp, Pegar respuesta, 4. Comprensión y 5. Horario extendido)
4. La ruta del día (Cargar ruta, mapa, vehículo, Ordenar desde aquí, Iniciar entregas, Waze, en camino y Tráfico)
5. Entregar con prueba (Evidencia con 3 fotos y firma, Hold, Devolver y Finalizar)
6. Cierres y reportes (reporte PDF, Guías por fecha de recibido y Vaciar lista)

Los videos se regrabaron con la versión 1.74 (antes eran de la 1.9 y mostraban pantallas viejas). En los videos el mapa sale con fondo liso: en tu celular se ven las calles.

**¿Qué versión tengo?** Bajá hasta el final de cualquier pestaña: dice *RutaFácil CR · versión 1.75.1* (o la que tengás). Se lee **mayor.menor.corrección**: el primer número cambia con cambios grandes, el segundo con funciones nuevas y el tercero con arreglos.


**¿Veo los colores o el ícono viejo?** El celular guarda la versión anterior. Cerrá la app por completo (deslizala hacia arriba) y abrila de nuevo; al final de la pestaña tiene que decir la versión nueva (ej. *versión 1.8.1*). Si el ícono sigue viejo, borrá el acceso directo y agregalo otra vez desde https://rutafacilcr.github.io/.


| Problema | Qué hacer |
|---|---|
| "Número o PIN incorrecto" | Revisá el número (8 dígitos) y el PIN. Si es tu primera vez, tocá **Crear cuenta**. Si no recordás el PIN, pedile uno nuevo al administrador. |
| "Falta un ajuste en Supabase" | Avisale al administrador: tiene que apagar *Confirm email* (ver manual técnico). |
| "Esta cuenta está en otro teléfono" | Tu cuenta ya está aprobada en otro celular. Si cambiaste de teléfono, avisale al administrador para que apruebe este. |
| "La cuenta se pasó a otro teléfono" | El administrador aprobó otro celular y este se cerró. Si fue un error, escribile. |
| "Tu cuenta espera activación" o "Tu mensualidad venció" | Pagá por SINPE Móvil con el detalle que dice la pantalla, avisale al administrador y tocá **Revisar de nuevo**. |
| "No se pudo revisar tu cuenta" | No hay internet. Si la cuenta se revisó bien en los últimos 3 días, la app abre igual. |
| No abre WhatsApp | Revisá que el teléfono tenga 8 dígitos. Si dice "Teléfono inválido", corregilo con **Editar**. |
| El mensaje sale desde otro número | WhatsApp usa la cuenta abierta en ese celular. |
| La ubicación no se detecta | Usá el link largo o las coordenadas, no el link corto. |
| El cliente no pudo usar "Estoy en mi casa" | El formulario le explica cómo dar permiso de ubicación. Si no puede, que toque **Prefiero mandarla por WhatsApp** y la mande desde el chat. |
| Sale "No se pudo revisar (código …)" o "No se pudo enviar (código …)" | Mandale una captura del mensaje con el código al técnico: indica la causa exacta. |
| "Confirmar entrega" no hace nada | Leé el aviso en rojo arriba del botón: faltan fotos (mínimo 3), la firma o la ubicación. Si la ubicación está bloqueada, activala en Ajustes (ver *Prueba de entrega*) o confirmá sin GPS. |
| La evidencia dice "⏳ sin subir" | No había internet. Se sube sola cada minuto con la app abierta, o tocá **Revisar respuestas ahora**. |
| El escáner no lee la etiqueta | Acercá el celular, quitá el reflejo, estirá la bolsa y probá **↻ Girar y leer de nuevo**. Si dice que no pudo cargar el lector, revisá el internet. Siempre podés llenar a mano. |
| "No encontré hora ni ubicación" | Lo que copiaste no traía ninguna de las dos. Copiá el mensaje con la hora o el link de la ubicación. |
| No llegan las respuestas | Revisá el internet y tocá **Revisar respuestas ahora**. El cliente tiene que tocar **Enviar** en el formulario. |
| Desapareció mi lista | Abriste la app en otro navegador o desde Safari en vez del ícono. |
| El link viejo (victormenav…/RutafacilCR) no abre | La app se mudó a https://rutafacilcr.github.io/. Instalá el ícono de nuevo desde ahí. |

---

## 5. Para el administrador

El panel está en https://rutafacilcr.github.io/admin.html (o **Panel**, al final de la app, si tu cuenta es de administrador).

| Para | Hacé esto |
|---|---|
| Activar a alguien que pagó | **Registrar pago**: monto, días que cubre (30) y referencia del SINPE. Si ya estaba al día, los días se suman al vencimiento. |
| Dar prueba gratis | **Dar 14 días de prueba** (solo en cuentas sin activar). |
| Aprobar un cambio de celular | En la cuenta sale el aviso naranja *Pide usar otro teléfono*. Aprobalo solo si la persona te confirmó que cambió de celular; si no, **Rechazar**: probablemente le pasó el PIN a alguien. |
| Cortar el acceso | **Suspender**. Funciona de inmediato. **Reactivar** lo devuelve. |
| PIN olvidado | **PIN nuevo** genera uno al azar; copiá el mensaje y mandáselo por WhatsApp. |
| Ver quién atender | Filtro **Por atender** (cuentas sin activar y cambios de teléfono) y **Vencen en 5 días**. |
| Liberar espacio de fotos | **Fotos de entrega** > **Calcular espacio usado** y **Borrar** las de más de 30 días. |
| Ver cuánto queda del plan gratis (1.74) | **Uso del plan gratis**: una barra para la base (500 MB) y otra para las fotos (1 GB), y una tabla con lo que ocupa cada cuenta. Si una barra se pone roja (80 %), bajá los días de fotos. |
| Decidir qué fotos van a la nube (1.74) | **Fotos de entrega** > **Fotos en la nube**: *Ninguna* (de fábrica: quedan 30 días en el celular), *1 foto chica + firma* (alcanza gratis para unos 20 mensajeros) o *Las 3 fotos + firma*; y **Días en la nube** (21; 0 = no se borran). **Guardar fotos.** Cada app lo toma en 15 minutos y borra sola sus fotos vencidas una vez al día. |
| Cuánto tiempo se guardan los cierres (1.74) | **Uso del plan gratis** > **Guardar cierres … días** (15 de fábrica; 0 = siempre). Cada mensajero borra los suyos vencidos al tocar Vaciar lista. **El respaldo son los PDF:** en *Cierres* la app avisa cuántos días se guardan y marca en rojo las fechas que se borran en 3 días o menos. |
| Avisos del Panel (1.75.2) | **Registrar pago** pide monto, días y referencia en un solo aviso. **PIN nuevo** muestra el PIN y después el mensaje con botón **Copiar**. **Suspender**, **Liberar teléfono**, **Nombre**, **Borrar fotos** y los días de cierres también preguntan con el aviso de RutaFácil. Para no hacer nada, **Cancelar** o tocar afuera. |
| Número alterno (1.76) | En **Ajustes > Tu número alterno** poné tu otro teléfono (ej. el personal) y tocá **Guardar número**. Desde ese momento podés entrar a la app y al Panel con ese número **y tu mismo PIN**: es la misma cuenta, ves exactamente lo mismo. Para quitarlo, dejá el campo vacío y guardá. Si dice *ese número ya tiene su propia cuenta*, primero hay que borrar esa cuenta (ver manual técnico). Solo existe para el administrador; los mensajeros siguen con un número por cuenta. |
| PIN en el Panel (1.74) | El Panel pide tu PIN de nuevo si pasaron 12 horas. La app del celular no. |
| Código de recuperación (1.74) | En **Movimientos recientes** salen *Sacó código*, *Código incorrecto* y *Usó su código*. Si ves muchos *incorrecto* de alguien, avisale: alguien está probando su número. |

**Avisos:** cuando alguien crea cuenta (o pide usar otro teléfono) te llega un WhatsApp y un correo con su nombre y número. Se configuran una vez en **Ajustes > Avisos cuando alguien crea cuenta** (pasos en el manual técnico) y con **Mandarme una prueba** revisás que lleguen.

**Avisarle al repartidor:** al tocar **Registrar pago**, **Dar 14 días de prueba** o **Reactivar**, abajo sale **Avisarle por WhatsApp** con el mensaje ya escrito (*tu cuenta ya está activa hasta el…*). Tocalo y en WhatsApp solo tocás Enviar. Aunque no le escribás, si la persona tiene la app abierta en la pantalla de espera, se le abre sola en menos de un minuto.

En **Ajustes** van los números SINPE que ven los repartidores (uno o dos, separados por coma: *6270 0666, 8820 2220*; desde la 1.76.1), el precio, los días de gracia y el interruptor **Exigir cuenta activa** (ver manual técnico).



### Devolver un paquete al almacén (1.29.0)

En *Paquetes*, cada paquete tiene el botón **↩ Devuelto**. Usalo cuando el paquete no se va a entregar y vuelve al almacén, por ejemplo porque no tiene dirección. Queda con la etiqueta gris *Devuelto*, ya no entra en *Calcular mejor ruta* y arriba se cuenta en **devueltos**. Si te equivocaste, tocá **↪ Quitar devuelto** y vuelve al estado que tenía.


### Orden de la lista de Paquetes (1.30.0)

Arriba salen los paquetes que faltan (pendientes, confirmados, sin respuesta), en el orden en que los agregaste. Los **entregados** bajan al final y los **devueltos** quedan de últimos.


### Unir una parada escribiendo el número (1.48.1)

En *Ruta*, en una parada sin unir tocá **🔗 Unir a paquete** y escribí el número del paquete (por ejemplo **62**). Si el paquete tiene ubicación, la parada pasa a pin rojo y entra al mapa.

### Ruta, mapa y lista siempre iguales (1.48.0)

- El número de cada parada (tarjeta, pin y 📋 Lista) es siempre el del paquete unido. Si la parada no está unida a ningún paquete sale **–** y el botón **🔗 Unir a paquete**.
- Las paradas **entregadas** y las **devueltas** van en gris al final, no entran en la línea azul del mapa ni en el tiempo total, y dicen "✓ entregado" o "↩ devuelto".
- Las de **Hold** van después de las pendientes, en la lista, en el mapa y en la 📋 Lista.
- Si usás la app en el celular y en la PC, la ruta que tocaste de último manda, y nunca se pierde una entrega marcada en cualquiera de los dos.

### La ruta no cambia sola (1.47.2)

La ruta solo cambia cuando vos lo hacés: al cargar el archivo, al ordenar, con Hold, Quitar, Agregar o Poner en la ruta, o al **editar** un paquete (si tiene ubicación y no estaba en la ruta, entra). La app ya no mete sola paquetes de la lista ni cambia una parada por otro cliente con un nombre parecido. Si una parada no se une a su paquete, usá **🔗 Unir a paquete** o **📍 Poner en la ruta**.

### Dejar una parada para el final: Hold (1.47.0)

Si un cliente no está o te pide pasar más tarde, en su parada de *Ruta* tocá **⏸ Hold** (a la izquierda de ✓ Entregado, desde 1.47.1). La parada se va al final de la ruta y ahí se queda aunque reordenes. En el mapa su pin se pone **amarillo** (1.48.2). El botón cambia a **▶ Quitar hold** en amarillo; tocalo para devolverla a la ruta normal (se reordena desde donde estás).

### Lista de la ruta en orden (1.46.0)

En *Ruta*, tocá **📋 Lista** (a la par de 🎯 Elegir en el mapa). Sale la ruta en el orden en que vas a entregar, con el número fijo de cada paquete, el nombre y el teléfono, por ejemplo:

> 1. #13 Suyapa · 88169570
> 2. #62 Patricia · 88881111

Al final van las paradas sin ubicación y las ya entregadas. Podés tomarle captura, tocar **📋 Copiar** o **📤 Compartir** para mandarla por WhatsApp.

### Ubicación en grados (1.45.3)

En la ubicación de un paquete podés pegar:

- El link de WhatsApp o de Waze.
- Las coordenadas en decimal (9.906806, -84.062528).
- Las coordenadas en grados como las copia Google Maps (9°54'24.5"N 84°03'45.1"W). La W también puede venir como O.

### Poner en la ruta un paquete que sigue con "?" (1.45.2)

Si un paquete ya tiene ubicación en *Paquetes* pero en *Ruta* sigue con el **?** amarillo, en su tarjeta de *Paquetes* aparece **📍 Poner en la ruta**. Tocalo: la parada toma la ubicación, se vuelve pin rojo con el mismo número del paquete y la ruta se reordena desde donde estás. Si el paquete está como *Devuelto*, primero tocá **↪ Quitar devuelto**.

### Paquetes sin ubicación en rojo (1.45.1)

En *Paquetes*, los paquetes pendientes a los que les falta la ubicación (o que tienen una que la app no puede leer) se ven con el **borde rojo**. Así sabés rápido a quién pedirle la ubicación. Los entregados y devueltos no se marcan.

### Buscar un paquete (1.45.0)

En *Paquetes*, debajo de "Lista del día", escribí en **🔍 Buscar**:

- **Nombre:** una o varias palabras, con o sin tildes (por ejemplo "ana grisela").
- **Teléfono:** 3 o más dígitos (por ejemplo los últimos 4).
- **Guía:** una parte del código.
- **Número de paquete:** el número exacto (por ejemplo 13).

Para ver toda la lista otra vez, borrá lo que escribiste.

### Galería junto al escáner (1.44.3)

En *Paquetes*, a la par de **📷 Escanear etiquetas** está **🖼️ Galería**, para elegir fotos de etiquetas que ya tenés en el celular.

### Mensajes sin cambios (1.44.1)

Los botones de *Mensajes* se ven igual que antes; el cambio de botones fue solo en *Paquetes* y en *Ruta*.

### Contador "Sin 📍" (1.52.2)

En el resumen de arriba de *Paquetes*, el contador de paquetes pendientes sin ubicación ahora dice **Sin 📍**.

### Mensajes: entregados abajo (1.52.1)

En *Mensajes*, cuando un paquete se entrega, su cliente se pone en gris con el número tachado y baja al final de la lista. Arriba quedan los que todavía faltan por entregar. Desde la 1.52.4, los que están en **Hold** en *Ruta* también salen en gris con "⏸ hold", justo después de los pendientes. Después van los entregados y de últimos los devueltos. Sus botones siguen funcionando.

### Mensaje para coordinar (1.51.1)

El mensaje **Coordinar** de *Mensajes* ahora dice:

> Hola Ana, soy Victor, tenemos un paquete de *TEMU* a su nombre y nos gustaría coordinar la entrega para el martes, 3 de noviembre.
>
> Nos puede enviar la ubicación por acá para agregarlo a la ruta. Una vez que tengamos la ubicación, nos contactamos con usted para la hora.

(Ortografía corregida en la 1.52.3.)

El nombre del cliente, tu nombre y la fecha de entrega se llenan solos. Si lo cambiás en la plantilla de Mensajes, la app respeta tu cambio.

### Botones de cada parada en Ruta (1.44.0)

- Primera línea (desde 1.44.5): el tiempo estimado (🚗 minutos y km), **🚗 Waze** (naranja) y **WhatsApp** (verde), repartidos a lo ancho y alineados con la línea de abajo (1.44.2).
- Segunda línea: **🗑️ Quitar**, **🗺️ Maps**, **📸 Evidencia** y **📲 Co-out**.
- Tercera línea, centrado: **✓ Entregado** en negro. Cuando ya está entregada sale **↩ Deshacer**.

### Avisar que vas en camino (1.43.0)

En *Ruta*, el botón **WhatsApp** de cada parada abre el chat del cliente con este mensaje ya escrito:

> Estamos en camino, en aprox 11 min, le estaremos entregando su paquete, *RECUERDE* presentar su Cédula, en la entrega

Desde la 1.48.5 el mensaje es: "Estamos en camino, le estaremos entregando su paquete, en 11 min", seguido de *IMPORTANTE* (mostrar la cédula para verificar la etiqueta) y la POLÍTICA DE ENTREGA (si nadie puede recibirlo, vuelve a bodega para reprogramar). Versión anterior (1.48.4):

> Política de entrega
> - Mostrar su cédula a la hora de recibir el paquete.
> - Si previo se había coordinado la entrega y se llega y no se logra la entrega, el paquete será devuelvo a bodega reprogramar.

El tiempo es el mismo 🚗 que ves en la parada. Si todavía no hay GPS o la parada no tiene ubicación, el mensaje va sin el tiempo. Solo tenés que tocar enviar en WhatsApp.

### Quitar una parada de la ruta (1.42.0)

Si una parada está repetida o no va (por ejemplo, una que salió con texto raro del escáner), tocá **🗑️ Quitar** en su tarjeta de *Ruta* y confirmá. La parada sale de la ruta, pero el paquete sigue en *Paquetes* y la app no lo vuelve a meter sola. Si después sí querés llevarlo, en *Paquetes* tocá **➕ Agregar a la ruta**.

Si el paquete en realidad ya se entregó, mejor tocá **✓ Entregado**: así queda marcado también en *Paquetes*.

### Botones de cada paquete (1.41.2)

Desde la 1.41.2 los botones quedan siempre en dos líneas:

- Primera: **📋 Pegar respuesta**, **Editar** y **📷 Escáner**.
- Segunda: **Borrar**, **↩ Devuelto** y **WhatsApp**.

Para ir con Waze o Maps usá la pestaña *Ruta*.

#### Antes (1.41.0)

En *Paquetes*, cada tarjeta trae en este orden: **📋 Pegar respuesta**, **Editar**, **Waze** (si tiene ubicación), **Borrar** (antes *Quitar*), **↩ Devuelto**, **📷 Escáner** y **WhatsApp** justo debajo de Escáner (1.41.1). El botón **Maps** ya no sale en *Paquetes*; en *Ruta* sigue igual.


### Corregir un paquete mal escaneado (1.31.0)

En *Paquetes*, tocá **📷 Escáner** (antes *Etiqueta*) en el paquete que quedó mal. Se abre la cámara: tomale foto a la etiqueta otra vez. La app vuelve a leer guía, nombre, teléfono y dirección; lo que no logre leer se queda con el dato que ya tenía. Revisá, corregí a mano si hace falta y tocá **Guardar corrección**. Se actualiza ese mismo paquete, sin crear uno nuevo, y conserva su estado, su ubicación y su evidencia.


### WhatsApp desde Paquetes (1.32.0)

Debajo de **📷 Escáner** está el botón verde **WhatsApp**, que abre el chat con ese cliente (sin mensaje escrito). Si el paquete no tiene teléfono válido, el botón no aparece.


### Cambios de teléfono llegan a Entrega (1.34.0)

Si corregís el teléfono de un paquete en *Paquetes* (con **Editar** o **📷 Escáner**), la parada de ese cliente en *Entrega* se actualiza sola con el número nuevo, y el botón WhatsApp ya abre el chat correcto. También se actualizan el nombre y la guía. Desde la 1.35.1, cada vez que abrís la app las paradas toman el teléfono que está en *Paquetes*, aunque lo hayas corregido antes.


### Orden de la lista en Entrega (1.35.0)

Arriba salen las paradas que faltan, en el orden de la ruta; después las que no tienen ubicación (con el "?" en amarillo). Las que ya entregaste bajan solas al final, en gris.


### Pestañas desde la 1.36.0

Abajo quedan **Paquetes, Mensajes, Ruta y Soporte**. La pestaña **Ruta** es la que antes se llamaba *Entrega*: cargás el Excel de la ruta, ves el mapa y entregás. La pestaña vieja de *Ruta* ("Calcular mejor ruta") se quitó. Donde este manual dice *Entrega*, ahora es **Ruta**.


### La ubicación del paquete pasa a la Ruta (1.37.0)

Cuando un cliente te manda su ubicación y la ponés en *Paquetes* (con **📋 Pegar respuesta** o **Editar**), su parada en **Ruta** se actualiza sola. Si estaba con el **?** amarillo, pasa a pin rojo con número, aparece en el mapa y la ruta se reordena desde donde estás. Lo mismo pasa al abrir la app con ubicaciones que agregaste antes.


### 🔗 Unir a paquete (1.37.1)

Si en **Ruta** una parada muestra **🔗 Unir a paquete**, la app no encontró su paquete en *Paquetes* (por ejemplo, porque el nombre o la guía quedaron distintos). Tocalo, escribí parte del nombre, la guía o el teléfono como está en *Paquetes* y elegilo. Desde ese momento la parada toma el teléfono (para WhatsApp) y la ubicación de ese paquete, y si estaba con **?** entra al mapa. Los links de Waze para compartir (waze.com/ul/…) ya cuentan como ubicación.


### Ver y cambiar el paquete de una parada (1.37.2)

En las paradas con **?**, la etiqueta **🔗 Nombre · teléfono** muestra con qué paquete de *Paquetes* está unida. Si es el equivocado (por ejemplo, un paquete repetido con el número viejo), tocala y elegí el correcto. Queda fijo y la parada toma su teléfono y su ubicación.


### Paquetes manda (1.37.3)

Lo que corrijás en *Paquetes* (nombre, teléfono o ubicación) se copia solo a la parada de ese cliente en **Ruta**, para todos los clientes. No hace falta volver a cargar el Excel.


### Número del paquete (1.38.0)

Cada paquete tiene un **número fijo**: el que tenía en la lista, y los nuevos toman el siguiente. Ese mismo número sale en *Paquetes*, en *Mensajes* y en el pin y la tarjeta de **Ruta**, para que coincida con tu codificación. No cambia al ordenar la lista, al quitar otros paquetes, al editarlo, al reescanearlo ni al sincronizar con la PC. Si quitás un paquete, su número no se vuelve a usar. En la ruta el recorrido sigue el mejor orden, así que los números no van seguidos (por ejemplo 13, 4, 27…). Si vaciás la lista, se empieza otra vez desde 1.


### ¿Está en la ruta? (1.38.1)

En *Paquetes*, debajo del teléfono, cada paquete dice:
- **🗺️ En la ruta**: ya tiene su parada; si dice *(sin ubicación)*, la parada sigue con **?**.
- **➕ Agregar a la ruta**: tiene ubicación pero no está en la ruta cargada. Tocalo y entra al mapa.
- **No está en la ruta**: no tiene ubicación o ya se entregó.

Si aparece en rojo **⚠ No reconozco esta ubicación**, el link que pegaste no trae coordenadas (pasa con los links cortos de Google tipo maps.app.goo.gl). Pedile al cliente que comparta la ubicación por WhatsApp o pegá un link de Waze o de Google Maps con números.


### Unión automática (1.39.0)

No tenés que unir nada a mano: si corregís en *Paquetes* el nombre, el teléfono o la ubicación de un cliente, su parada en **Ruta** se actualiza sola. Si tenía **?**, pasa a pin rojo y entra al mapa. Esto funciona aunque el nombre esté escrito un poco diferente o le hayas cambiado el teléfono. Si un paquete con ubicación no estaba en la ruta, se agrega solo. El botón **🔗** queda solo para casos raros.


### Entregados tachados (1.40.0)

> Desde la **1.73.0** el número de los entregados en *Paquetes* y *Mensajes* ya no va tachado: solo en gris. Desde la **1.73.1** tampoco en *Ruta*: los entregados en el mapa y en la lista quedan en gris, sin tachar.

Cuando tocás **✓ Entregado** en *Ruta*, el número del paquete queda tachado y en gris, y la parada baja al final de la lista. En *Paquetes* el número también sale tachado, la tarjeta entera se ve apagada en gris (1.40.1) y el paquete pasa con los entregados. Sus botones siguen sirviendo por si hay que corregir algo. Si te equivocaste, **↩ Deshacer** lo devuelve.

### Si algo no responde (1.67.5)

Si la pantalla quedó agrandada o corrida hacia un lado, pellizcá con dos dedos para achicarla. Desde la 1.70.1 ya no debería pasar al tocar un campo.

Si arriba sale un **aviso rojo "Error en la app…"**, tomale captura y mandala a soporte; tocalo para cerrarlo. En computadora, para cargar la última versión apretá **Ctrl + Shift + R** (Windows) o **Cmd + Shift + R** (Mac).

### Avisos de confirmar (1.69.0)

Cuando la app pide confirmar algo, sale un cuadro en el centro de la pantalla con el detalle y dos botones (desde la 1.69.5): **Cancelar** y la acción (por ejemplo **Borrar**, **Quitar**, **Vaciar y cerrar**, **Guardar**). Si la acción borra o desactiva, el botón sale en rojo. Tocar fuera de la hoja también cancela.

### Ruta por calles (1.68.0)

La línea azul del mapa en *Ruta* va por las calles, desde donde estás y por las paradas pendientes en orden. Tarda unos segundos en aparecer; mientras tanto (o sin internet) se ve en línea recta.

### Vaciar lista (1.67.0)

En *Paquetes*, el primer botón **🧹 Vaciar lista** (orden desde la 1.67.1: Vaciar lista, Agregar a mano, Importar, Escanear) cierra la ruta: pide confirmar, te dice cuántos paquetes se guardan y te avisa si todavía hay sin entregar ni devolver. Al aceptar guarda todo en la base y deja la app limpia.

### Paradas en el mismo lugar (1.66.4)

Si dos o más clientes están en el mismo punto, sus pines salen un poco corridos, en abanico, para que se vean todos. El de adelante es el pendiente; los grises (entregados) quedan detrás.

### Regresar a Ruta (1.69.8)

En un paquete devuelto, **↪ Regresar a Ruta** pide confirmar: *Si regresa a Ruta, el paquete se agregará a la ruta de entrega y se activa en Paquetes*. Al aceptar queda pendiente y en la ruta (si no tiene ubicación, te avisa para que se la pongás).

### Paquete devuelto (1.66.2)

Un paquete **devuelto** queda gris y sin botones en *Paquetes* y *Mensajes*, igual que en *Ruta*. Solo queda la etiqueta roja **⛔ Devuelto** y **↪ Quitar devuelto** para reactivarlo.

### Paquete para devolver (1.66.0)

> Desde la 1.87.0 la parada ya no queda en *Ruta*: sale de la ruta y el paquete sigue en *Paquetes* con ⛔ Devolver.

Cuando marcás **⛔ Devolver** en *Ruta*, ese paquete queda gris y sin botones en *Paquetes*, *Mensajes* y *Ruta*. Solo queda la etiqueta roja **⛔ Devolver** y el botón **↩ Quitar devolver**. Si hay que reactivarlo, tocá **↩ Quitar devolver** en cualquiera de las tres pantallas y confirmá: vuelve a estar activo en todas.

### Escanear, Importar y Agregar a mano (1.65.0)

Debajo de los contadores hay tres botones: **✍️ Agregar a mano**, **📥 Importar** y **📷 Escanear** (en ese orden desde la 1.66.1). Cada uno abre su pantalla con **← Regresar**. **Editar** en un paquete abre la pantalla de *Agregar a mano* con sus datos; al guardar volvés a la lista.

### Escanear e Importar (1.64.0)

Debajo de los contadores de *Paquetes* hay dos botones pequeños: **📷 Escanear etiquetas** y **📥 Importar lista**. Al tocar uno se abre su pantalla; **← Regresar** te devuelve a la lista. Al pegar filas y tocar *Agregar a la lista* regresa solo.

### Todo está conectado (1.63.0)

*Paquetes*, *Mensajes* y *Ruta* usan el mismo paquete:
- **Editar** (nombre, teléfono, dirección, ubicación, guía, nota) cambia los tres. Al cambiar el **teléfono**, todos los botones de WhatsApp (Paquetes, 1. Coordinar, Mensajes y las paradas de Ruta) usan el número nuevo, también en tus otros aparatos. Antes de guardar te muestra qué cambia y pide confirmar.
- **Borrar** pide confirmar y quita el paquete de los tres, también su parada en la ruta.
- **✓ Entregado**, **⏸ Hold** y **⛔ Devolver** en *Ruta* se ven en *Paquetes* y *Mensajes*. Si cambiás el estado de un entregado en *Paquetes*, su parada vuelve a pendiente.
- La ubicación que ponés en *Ruta* queda también en el paquete.

### Promedios y cierre (1.62.0)

- El reporte trae **Promedio por entrega**: minutos y km por paquete entregado. Con **▶ Iniciar** y **■ Finalizar** cada día, el promedio es más real porque cuenta desde la salida hasta el final.
- **Vaciar lista** deja la app totalmente limpia (paquetes, ruta y jornada); todo queda guardado en el cierre. Si te vuelven a dar un paquete de una ruta cerrada, cargalo de nuevo: toma la fecha de ese día y arranca otra vez su plazo de entrega.

### Paquete agregado a mano (1.61.0)

Si al revisar encontrás un paquete con datos malos y lo borrás y lo volvés a agregar (o lo editás) otro día, en el formulario está **Pertenece a**. Ya viene elegida la ruta en curso (por ejemplo *Entregas del 2 de noviembre*), así el paquete sale en el reporte de esa ruta. Si es de otra, elegila en la lista.

### Entregas del día (1.60.0)

Los paquetes que te dan un día (por ejemplo 70 el 2 de noviembre) forman las **Entregas del 2 de noviembre**. Tenés varios días para entregarlos: los que entregués el 2 salen con fecha de entrega 2, los del 3 con fecha 3, y así. Todos quedan en el mismo reporte *Entregas del 2 de noviembre* en *Cierres*. Hacé **Vaciar lista** cuando terminés todos.

### Iniciar y Finalizar entregas (1.59.0)

Arriba de *Ruta* está la barra de la jornada:
1. Al salir a repartir tocá **▶ Iniciar entregas**: guarda la hora y tu ubicación.
2. Al terminar el día tocá **■ Finalizar** (pide confirmar): guarda la hora y dónde terminaste.
3. Si finalizaste antes de tiempo, tocá **▶ Seguir entregando**.

Con eso el reporte mide la primera entrega desde la salida (sale como *desde inicio:* en *Tiempo desde anterior*; antes de la 1.75.1 salía con un ▶ que el PDF mostraba como «%¶»), suma los km de la última entrega al punto final y las *Horas invertidas* son de Iniciar a Finalizar. Dale permiso de ubicación a la app para que guarde los puntos.

**La ruta queda fija (1.72.0).** Desde que tocás **▶ Iniciar entregas** hasta **■ Finalizar**, el orden de las paradas no cambia solo: si la ruta dice 1, 3, 2, 4, así se queda aunque te movás, agregués paquetes o pongás alguno en Hold. Los paquetes nuevos van al final de la ruta y el que sale de Hold vuelve a su puesto. Si querés reordenar, tocá **📍 Ordenar desde aquí** o **🎯 Elegir en el mapa**; la app te pregunta antes.

### Cómo se calculan horas y km del reporte (1.58.0)

- La **primera entrega del día** es el inicio (dice *Inicio* en la tabla).
- Cada entrega siguiente mide **tiempo** y **km** desde la entrega anterior del mismo día. Se ven en las columnas *Tiempo desde anterior* y *Km desde anterior*.
- **Horas invertidas** y **Km recorridos** son la suma de esos tramos. Si un reporte tiene entregas de dos días, cada día arranca de nuevo.
- Los **devueltos** no suman horas ni km.
- La hora de entrega es la de la evidencia (📸) o la del toque en **✓ Entregado**. Los km son en línea recta ×1,35 (aproximado), desde el GPS de la entrega o la ubicación del cliente.
- Para que cuadre, marcá cada entrega en el momento en que la hacés.

### Etiqueta de devueltos (1.56.0)

Un paquete devuelto muestra la etiqueta gris **⛔ Devuelto** (igual a la de **⛔ Devolver**), en *Paquetes*, *Mensajes* y *Ruta*.

### Botón Coordinar en Paquetes (1.53.0)

En cada tarjeta de *Paquetes*, a la par del nombre, está **1. Coordinar**: abre WhatsApp con el primer mensaje listo. Después de abrirlo sale **1. Coordinar ✓**. Si sale gris, el teléfono no es válido: corregilo con **Editar**. Los entregados y devueltos muestran su estado en vez del botón. El estado (Confirmado, No responde…) se sigue viendo en *Mensajes*.

### Contadores (1.52.0)

Arriba de *Paquetes* hay cinco cuadros: **Recibidos** (todos), **Entregados**, **Hold** (pendientes en Hold en la ruta), **Devueltos** (devueltos y ⛔ Devolver) y **Sin ubicación** (pendientes que no tienen ubicación ni en el paquete ni en la ruta). Un link corto de Google Maps (`maps.app.goo.gl`) no cuenta como ubicación.

### Cierre del día (1.51.0)

Al terminar, en *Paquetes* tocá **Vaciar lista** y otra vez para confirmar (**¿Cerrar el día? Tocá otra vez**). La app guarda en la nube todos los paquetes y la ruta con la fecha y hora del cierre, y deja *Paquetes* y *Ruta* vacías para cargar la ruta nueva. Si no hay internet, avisa y **no borra nada**: probá de nuevo cuando tengás señal.

El globito de **Paquetes** (abajo) muestra cuántos **faltan por entregar**; no cuenta entregados, devueltos ni los marcados ⛔ Devolver.

### Devolver (1.50.0)

En *Ruta*, cada parada tiene **⛔ Devolver** a la par de **⏸ Hold** y **✓ Entregado**. Al tocarlo (y confirmar), la parada se queda en la ruta pero **desactivada**: gris, sin botones, fuera del orden y del tiempo de la ruta. En *Paquetes*, la tarjeta del paquete muestra la etiqueta **⛔ Devolver**. Si fue un error, tocá **↩ Quitar devolver** en la parada.

En *Paquetes*, desde la 1.53.2, la lista va en este orden: primero los **activos**, después los que están en **Hold**, luego los **devueltos** (y ⛔ Devolver) y al final los **entregados** en gris.

Desde la 1.53.1, la etiqueta **⛔ Devolver** de *Paquetes* también se puede tocar: primero pregunta *¿Ya devolviste el paquete al almacén?* → **Aceptar** lo marca como **devuelto** (cuenta en Devueltos y la parada queda "↩ devuelto"). Si tocás **Cancelar**, pregunta si querés **quitar la marca Devolver** para que vuelva a estar activo en la ruta.

### Diagnóstico para soporte (1.39.1)

Si una parada no toma los datos de su paquete, abrí **Soporte** y tocá **🧪 Copiar diagnóstico de la ruta**. Se copia un texto con las paradas sin ubicación, el paquete al que está unida cada una y los paquetes con ubicación que no están en la ruta. Pegalo en el chat de soporte.

Desde la 1.39.2 el botón se llama **🧪 Ver diagnóstico de la ruta** y muestra el texto en pantalla. Tomale captura (si es largo, bajá y tomá varias) o tocá **📤 Compartir** para mandarlo por WhatsApp. **📋 Copiar** sigue disponible.


### Reporte PDF (1.54.0)

En **Cierres** aparece una lista de reportes, uno por cada **fecha de recibido** de los paquetes (la fecha en que los escaneaste o los ingresaste), con cuántos se recibieron, entregaron y devolvieron. Tocá **📄 PDF** en la fecha que querés. Desde la 1.57.0 también salen las fechas de listas que ya vaciaste, porque se leen de los cierres guardados en la base (necesita internet). Se baja un PDF horizontal con los paquetes **entregados** y **devueltos** recibidos ese día, con estas columnas (más *Tiempo* y *Km desde anterior* desde la 1.58.0): No. paquete, No. guía / pedido, No. teléfono, Nombre (desde la 1.54.2; antes era "teléfono 2"), Estado, Fecha recibido, Fecha entrega y Hora entrega. En iPhone se abre el menú de compartir: elegí **Guardar en Archivos**. La hora de entrega es la del momento en que tocaste **✓ Entregado** en *Ruta* (o la de la evidencia). Desde la 1.56.3 se corrigen solas las entregas que habían quedado todas con la misma hora. Desde la 1.56.1 las filas van ordenadas por **fecha y hora de entrega** (o de devolución), de la más vieja a la más nueva; los que no tienen hora quedan al final. Arriba trae un encabezado con: **Fecha** y debajo **Mensajero** (el nombre de *Tu nombre* en ajustes), **Paquetes recibidos**, **entregados** y **devueltos** (uno debajo del otro, a la derecha), **Km recorridos** y **Horas invertidas**. Desde la 1.58.0 los km y las horas se calculan por tramos entre entregas seguidas, y desde la 1.59.0 con ▶ Iniciar / ■ Finalizar (ver esas secciones). El encabezado también trae la **Fecha de recibido** de ese grupo.


### Vehículo (1.55.0)

En **Ruta**, a la par de **📋 Lista**, hay tres botones: **🏍 moto**, **🚙 carro** y **🚐 buseta**. Tocá el que vas a usar; queda marcado en naranja y se guarda (desde la 1.69.2 viene marcado el 🚙 carro; antes la moto). No cambia los tiempos, los km ni el orden de la ruta. Desde la 1.56.4, el ícono elegido va en el WhatsApp de "en camino", justo después de la palabra *camino* (por ejemplo "Estamos en camino 🏍️, le estaremos entregando…"), tanto en *Ruta* como en el mensaje 3 de *Mensajes*.


### Arriba de Ruta (1.67.6)

En la primera línea de *Ruta* están **📂 Cargar ruta**, el nombre de la ruta, **📍 Ordenar desde aquí** y, a la derecha, **📍 Estás aquí (±m)** (tu GPS). Debajo va **▶ Iniciar entregas**. En la tercera línea, a la izquierda, el resumen de la ruta (⏱ tiempo, km, inicio y fin; 1.67.7) y a la derecha **🎯 Elegir en el mapa** (para ordenar desde otro punto, útil en la computadora o si el GPS falla), **📋 Lista** y el vehículo (desde la 1.67.8 el vehículo va junto al resumen).


### Detalles de pantalla (1.63.1 a 1.67.8)

- **1.63.1 y 1.63.2:** al editar un paquete, su parada en *Ruta* también toma la nota, la dirección, la guía y el teléfono. El WhatsApp de *Ruta* usa siempre el teléfono del paquete.
- **1.66.1 y 1.67.1:** en *Paquetes* los botones grandes van en este orden: Vaciar lista, Agregar a mano, Importar y Escanear.
- **1.66.3:** en el mapa, el pin de una parada pendiente queda encima del pin gris de una entregada.
- **1.67.2:** en *Paquetes* el buscador va primero y **Lista del día** debajo (1.69.1: el título se quitó).
- **1.67.3:** la barra de abajo va en el orden Paquetes, Cierres, Mensajes y Ruta.
- **1.67.4:** en *Ruta* ya no sale el aviso "no es la de hoy ni la de mañana", porque una ruta se puede repartir en varios días.
- **1.67.8:** los vehículos 🏍️ 🚙 🚐 van a la derecha del resumen de tiempo y km, y **Elegir en el mapa** y **Lista** quedan debajo.


### Sin paradas repetidas (1.69.7)

Un paquete tiene **una sola parada** en *Ruta*. Si tocás **➕ Agregar a la ruta** y ya estaba, la app avisa "ya está en la ruta" y no agrega otra. Si quedaron repetidas de antes, al abrir la app se quitan solas (se queda la que ya se entregó o la que tiene ubicación) y sale un aviso con cuántas se quitaron.


### Eliminar o quitar (1.69.9)

- **Eliminar** (en *Paquetes*) borra el paquete de la lista, de *Mensajes* y de *Ruta*. Pide confirmar y no se puede deshacer.
- **🗑️ Quitar** (en *Ruta*) solo saca la parada de la ruta. El paquete sigue en *Paquetes* y en *Mensajes*, y se puede volver a meter con **➕ Agregar a la ruta**.


### Tráfico en vivo (1.70.0)

El tiempo a la **próxima parada** puede tomar en cuenta el tráfico de ese momento (presas, accidentes, cierres). Es gratis.

**Activarlo (una sola vez):**
1. Entrá a **developer.tomtom.com** y creá una cuenta. Es gratis y no pide tarjeta.
2. Abrí **Keys** (o *API Keys*) y copiá la clave.
3. En *Ruta*, tocá **🚦 Tráfico** y pegá la clave. El botón se pone verde y dice **🚦 Tráfico en vivo**.

**Cómo se ve:** la próxima parada muestra **🚦 ~10 min (+5 tráfico)**: 10 minutos con el tráfico de ahora, 5 de ellos por el tráfico. Se actualiza cada 2 minutos o cuando avanzás 300 m. Las demás paradas siguen con 🚗 (estimado sin tráfico). El WhatsApp de "en camino" de esa parada manda ese tiempo.

Tocá el botón otra vez para apagarlo o encenderlo. Si dice **"revisar clave"**, tocá y pegá la clave de nuevo. El plan gratis permite 2.500 consultas al día y la app usa unas 300 en un día largo.


### Guía en la tarjeta (1.70.2)

En *Paquetes*, debajo del nombre, la tarjeta muestra el teléfono y la guía con su etiqueta: **Tel. 62700667** (1.70.3; desde la 1.70.4 dice "Tel.") y **Guía: 29293393**.


### Ícono de Escanear (1.70.5)

**Escanear** y **Escáner** se reconocen por el ícono de **código de barras** (antes era una cámara).


### Botones de regresar en naranja (1.70.6)

**↪ Regresar a Ruta**, **↩ Quitar devolver** y **← Regresar** van en naranja con letra blanca: aunque la tarjeta esté gris, ese botón sí se puede tocar (corregido en la 1.70.7). Desde la 1.70.9 van a la **derecha**, a mano del pulgar.


### En la ruta a la par de la ubicación (1.70.8)

En la tarjeta de *Paquetes*, la línea del teléfono dice por ejemplo: **Tel. 62700667 · Guía: 29293393 · ● Ubicación lista · 🗺️ En la ruta**.


### Reporte de guías por fecha de recibido (1.71.0, 1.72.3)

En **Cierres**, debajo de *Reporte de entregas*, está **Guías por fecha de recibido**. Hay una línea por cada fecha en que recibiste paquetes (por ejemplo **🧾 Guías · Paquetes recibidos 31/10/2026 · 25 entregado(s)**). Tocá **📄 PDF** para bajar un PDF horizontal con **Nombre, Tel., Guía, Dirección y Hora entrega** (1.73.3) de los paquetes de esa fecha que ya entregaste. Adentro van agrupados por día de entrega (**Entregados 02/11/2026**, **Entregados 03/11/2026**), en el orden en que se entregaron. Arriba dice el mensajero, la fecha de recibido y cuántos paquetes son. La fecha de recibido es la de **Pertenece a** en cada paquete (se cambia con ✏️ Editar).


### Voy en camino: WhatsApp y después Waze (1.78.0)

En **Ruta**, tocá **WhatsApp** en la parada a la que vas: se abre el mensaje "Estamos en camino…" con el tiempo estimado. Mandalo y volvé a RutaFácil: sale un aviso **¿Ya le avisaste?** con el botón naranja **🚗 Abrir Waze** para esa misma parada, sin tener que buscarla en la lista. Si no vas a salir todavía, tocá **Ahora no**. El aviso solo sale si volvés dentro de 15 minutos. El celular no deja abrir WhatsApp y Waze de un solo toque, por eso queda ese último toque.

### Pestañas más rápidas (1.77.0)

Al tocar **Paquetes**, **Cierres**, **Mensajes** o **Ruta**, el botón se pone naranja y la pantalla cambia de una vez. Si tenés muchos paquetes, la lista puede terminar de aparecer un instante después; podés empezar a usarla normal. No cambia nada de lo que ves ni de cómo funciona.

### Paquetes devueltos más fáciles de leer (1.76.2)

Cuando un paquete está **⛔ Devuelto** (o marcado **⛔ Devolver**), la tarjeta queda gris pero el nombre, la dirección, el teléfono y la guía se leen completos. Los botones de ese paquete (*Editar*, *Escáner*, *Eliminar*, *WhatsApp*, *Pegar respuesta*) se ven con **borde punteado** y no se pueden tocar. El único que se toca es el naranja **↪ Regresar a Ruta** (o **↩ Quitar devolver**). También se lee mejor el nombre de la pestaña en la que estás y el botón **🧹 Vaciar lista**, en tema claro y oscuro.
