# Historial de cambios

Versiones con formato **mayor.menor.corrección** (desde la 1.6.2). Antes se usaban etiquetas por fecha; equivalencias:

| Versión | Etiqueta vieja | Qué trajo |
|---|---|---|
| 1.0.0 | v29-oct-a … f | App base: paquetes, mensajes, ruta, formulario, mensaje corto sin link |
| 1.1.0 | v29-oct-g | Formulario como segundo mensaje |
| 1.2.0 | v29-oct-h | Prueba de entrega (GPS, fotos, Supabase) |
| 1.3.0 | v29-oct-i | Pegar respuesta |
| 1.3.1 | v29-oct-j | Fotos más livianas y limpieza local |
| 1.4.0 | v29-oct-k | Escanear etiquetas |
| 1.5.0 | v29-oct-l | Ruta con horarios |
| 1.6.0 | v30-oct-a | Dirección nueva, paleta grafito y naranja, logo |
| 1.6.1 | v30-oct-b | Pestañas abajo |
| 1.7.0 | — | Cuentas con número + PIN, un teléfono por cuenta y panel del administrador |
| 1.7.1 | — | Mensajes más claros al entrar |
| 1.8.0 | — | Botón de Soporte con WhatsApp y videos de ayuda |
| 1.8.1 | — | Soporte por WhatsApp en la pantalla de entrar |
| 1.8.3 | — | Ícono de audífonos (call center) en Soporte |
| 1.10.0 | — | Avisos de cuentas nuevas por WhatsApp y correo; aviso de activación al repartidor |
| 1.12.0 | — | Botón *Esperando activación* que se habilita al activar la cuenta |
| 1.12.1 | — | *Crear cuenta* con los campos en blanco |
| 1.12.2 | — | *Crear cuenta* subrayado en la pantalla de entrar |

## 2026-11-02
- **1.67.0 · Vaciar lista como botón:** en *Paquetes* hay un cuarto botón de sistema, **🧹 Vaciar lista** (en rojo), junto a Agregar a mano, Importar y Escanear. Pide confirmar, dice cuántos paquetes se guardan y avisa si quedan sin entregar ni devolver; después hace el mismo cierre de siempre. Se quitó el botón pequeño de la línea *Lista del día*.
- **1.66.4 · Pines juntos en abanico:** si varias paradas están en el mismo lugar (a menos de ~15 m), cada pin se corre un poco hacia la derecha para que se vea su borde. Las pendientes quedan primero y las entregadas o devueltas al final.
- **1.66.3 · Pines pendientes encima:** en el mapa de *Ruta*, cuando dos paradas están en el mismo lugar, el pin de la pendiente queda encima del gris de la entregada (antes la entregada podía tapar a la pendiente y parecía desactivada). Orden: seleccionada, pendientes, Hold, cerradas.
- **1.66.2 · Devueltos desactivados:** los paquetes **devueltos** también se ven grises y sin botones en *Paquetes* y *Mensajes*, con la etiqueta roja **⛔ Devuelto** y el botón activo **↪ Quitar devuelto** (pide confirmar y lo reactiva en las tres pantallas).
- **1.66.1 · Orden de botones:** en *Paquetes* quedan **Agregar a mano**, **Importar** y **Escanear**.
- **1.66.0 · Devolver desactiva la tarjeta:** un paquete marcado **⛔ Devolver** se ve gris y sin botones en *Paquetes*, *Mensajes* y *Ruta*; abajo queda la etiqueta **⛔ Devolver** en rojo y el botón activo **↩ Quitar devolver**. Al quitarlo (pide confirmar) el paquete vuelve a estar activo en las tres pantallas.
- **1.65.0 · Botones de sistema:** en *Paquetes*, **Escanear**, **Importar** y **Agregar a mano** son tres botones estilo iPhone (relleno gris, esquinas redondeadas, ícono arriba). *Agregar a mano* también se abre en su propia pantalla con **← Regresar**; *Editar* usa esa misma pantalla y al guardar vuelve a la lista.
- **1.64.0 · Paquetes más limpio:** *Escanear etiquetas* e *Importar lista* pasan a dos botones pequeños debajo de los contadores. Al tocar uno se abre solo ese panel, con **← Regresar** arriba. Después de *Agregar a la lista* regresa solo.
- **1.63.2 · Teléfono seguro en Ruta:** el WhatsApp de cada parada usa el teléfono del paquete (el que se editó en *Paquetes*). La sincronización copia el teléfono siempre que cambie, también si quedó vacío o mal escrito (antes, en otro aparato, la parada podía seguir con el número viejo y mandar el mensaje a la persona equivocada). El número anterior se guarda para seguir reconociendo la parada.
- **1.63.1 · Ruta toma todos los datos del paquete:** al editar en *Paquetes*, la parada de *Ruta* ahora también cambia **nota**, **dirección** y **guía** (antes solo nombre, teléfono y ubicación, y la nota se quedaba con la del Excel de la ruta). Las rutas ya cargadas se corrigen solas al abrirlas.
- **1.63.0 · Datos relacionados y cuidado al borrar:** (1) **Borrar** un paquete pide confirmar y también quita su parada de *Ruta* (antes quedaba una parada suelta). (2) Si un paquete entregado se cambia a otro estado en *Paquetes*, su parada en *Ruta* vuelve a pendiente (antes la ruta lo volvía a marcar entregado). Devuelto o Devolver quitan el Hold de la parada. (3) La ubicación que se pone en *Ruta* (link o tocando el mapa) también queda en el paquete si no tenía. (4) Piden confirmación: borrar, marcar o quitar devuelto, cambiar el estado de un entregado o devuelto, y **Editar** muestra los datos que cambian (antes → después) antes de guardar.
- **1.62.0 · Promedios y cierre limpio:** el reporte trae **Promedio por entrega** (minutos y km por paquete entregado) y **Días de entrega**; en *Cierres* sale también el promedio. **Vaciar lista** borra además la jornada (▶ Iniciar / ■ Finalizar), que ya queda guardada en el cierre: la app arranca totalmente limpia. Un paquete que vuelvan a dar se carga de nuevo con la fecha de ese día.
- **1.61.0 · Paquete a mano en su ruta:** *Agregar un paquete a mano* y *Editar* tienen **Pertenece a**: por defecto las *Entregas del …* con más paquetes en la lista (la ruta en curso), aunque se agregue otro día. Así un paquete corregido o vuelto a agregar sigue en el reporte de su ruta. Se puede elegir otra fecha de la lista u hoy.
- **1.60.0 · Entregas del día:** en *Cierres* y en el PDF cada grupo se llama **Entregas del 2 de noviembre** (el día en que se recibieron los paquetes), aunque se entreguen en los días siguientes; cada fila sigue con su fecha y hora real de entrega. El archivo se llama `entregas-del-AAAA-MM-DD.pdf`.
- **1.59.0 · Iniciar y Finalizar entregas:** en *Ruta* hay **▶ Iniciar entregas** y **■ Finalizar**, que guardan la hora y el GPS de salida y de cierre del día (se sincronizan y van en el cierre). En el reporte, la primera entrega mide tiempo y km desde el inicio (sale con ▶), se suma el tramo de la última entrega al punto final y las *Horas invertidas* del día son fin − inicio. **▶ Seguir entregando** borra la hora de fin si se finalizó antes de tiempo. Sin Iniciar/Finalizar, el reporte sigue como en la 1.58.0.
- **1.58.0 · Reporte por tramos:** horas y km del reporte se calculan entre entregas seguidas: la primera entrega del día es el **Inicio** y cada entrega siguiente mide el tiempo y los km desde la anterior del mismo día. *Horas invertidas* y *Km recorridos* son la suma de esos tramos. Antes las horas iban de la primera a la última marca del grupo (sumaba días distintos y la hora en que se marcaban los devueltos) y los km arrancaban en el punto desde donde se ordenó la ruta. El PDF trae dos columnas nuevas: **Tiempo desde anterior** y **Km desde anterior**. Los devueltos no cuentan en horas ni km.
- **1.57.0 · Reportes por fecha de recibido:** en *Cierres* hay una lista con un reporte por cada fecha en que se recibieron paquetes (también de listas ya vaciadas, leídas de los cierres guardados); cada uno con su **📄 PDF** y la **Fecha de recibido** en el encabezado.
- **1.56.4 · Vehículo en el mensaje:** el WhatsApp de "en camino" (en *Ruta* y en *Mensajes*) lleva después de la palabra "camino" el ícono del vehículo elegido en *Ruta*: 🏍️, 🚙 o 🚐.
- **1.56.3 · Hora real de entrega:** si una parada se marcaba ✓ Entregado antes de estar unida a su paquete, al unirse el paquete quedaba con la hora de ese momento (varias entregas con la misma hora). Ahora toma la hora del toque y corrige las que ya estaban mal; el reporte usa esa hora.
- **1.56.2 · Encabezado en columna:** en el reporte PDF, Paquetes recibidos, entregados y devueltos quedan uno debajo del otro a la derecha, y Mensajero va debajo de Fecha.
- **1.56.1 · Reporte por hora:** las filas del reporte PDF van ordenadas por fecha y hora de entrega (o devolución), de la más vieja a la más nueva.
- **1.56.0 · Etiqueta de devueltos:** los paquetes devueltos llevan la misma etiqueta gris con ⛔ que *Devolver*, pero dice **⛔ Devuelto** (en *Paquetes*, *Mensajes* y *Ruta*). Tocarla en *Paquetes* o *Mensajes* sigue cambiando el estado.
- **1.55.0 · Vehículo en Ruta:** a la par de 📋 Lista hay tres botones 🏍 🚙 🚐 para elegir moto, carro o buseta (uno a la vez, se guarda). Todavía no cambian tiempos ni ruta. Corrige los km del reporte, que sumaban dos veces el extra por calles.
- **1.54.2 · Reporte con nombre:** la columna "No. teléfono 2" se cambia por **Nombre** del cliente y en el encabezado "Paquetes devueltos" queda debajo de "Paquetes entregados".
- **1.54.1 · Encabezado del reporte:** el PDF trae arriba fecha, mensajero, paquetes recibidos, entregados y devueltos, km recorridos (aprox.) y horas invertidas.
- **1.54.0 · Reporte PDF:** en *Cierres*, **📄 Bajar reporte PDF** arma un PDF horizontal con los entregados y devueltos de la lista: No. paquete, No. guía / pedido, No. teléfono, No. teléfono 2, Estado, Fecha recibido, Fecha entrega y Hora entrega.
- **1.53.2 · Orden en Paquetes:** primero los activos, luego los que están en Hold, después los devueltos (y ⛔ Devolver) y al final los entregados en gris.
- **1.53.1 · ⛔ Devolver se puede tocar:** en *Paquetes*, la etiqueta **⛔ Devolver** (puesta desde *Ruta*) ahora es un botón: al tocarlo pregunta si ya se devolvió y lo marca como **devuelto**; si no, ofrece quitar la marca.
- **1.53.0 · Coordinar en Paquetes:** en la tarjeta de *Paquetes*, el estado (Pendiente, Confirmado, No responde…) se cambia por el botón **1. Coordinar**, que abre WhatsApp con el mensaje de coordinar y lo marca como enviado (✓). Entregados y devueltos siguen mostrando su estado. Sin teléfono válido el botón sale gris.
- **1.52.4 · Hold en Mensajes:** en *Mensajes*, los clientes cuya parada está en Hold en *Ruta* también salen en gris con "⏸ hold", después de los pendientes y antes de los entregados.
- **1.52.3 · Ortografía de Coordinar:** el mensaje Coordinar queda corregido (gustaría, puede, agregarlo, ubicación, contactamos y comas).
- **1.52.2 · "Sin 📍":** en el resumen de *Paquetes* el contador "Sin ubicación" dice **Sin 📍**.
- **1.52.1 · Mensajes ordenados:** en *Mensajes*, los clientes con paquete entregado se ven en gris (número tachado) y bajan; al final van los devueltos. Arriba quedan los que faltan.
- **1.52.0 · Contadores de Paquetes:** arriba de *Paquetes* salen **Recibidos, Entregados, Hold, Devueltos y Sin ubicación**. Cada paquete cuenta en un solo grupo: *Devueltos* suma los devueltos y los ⛔ Devolver; *Hold* son los pendientes cuya parada está en Hold; *Sin ubicación* son solo los pendientes sin coordenadas ni en el paquete ni en su parada de la ruta (antes contaba también entregados y devueltos, y paquetes que sí tenían ubicación en la ruta).
- **1.51.1 · Nuevo mensaje Coordinar:** el mensaje "Coordinar" de *Mensajes* pasa al texto nuevo de Victor (paquete de *TEMU*, pedir la ubicación por WhatsApp y después coordinar la hora). Se pone una sola vez; si después lo editás en Mensajes, se respeta.
- **1.51.0 · Cierre del día y globito de pendientes:** (1) **Vaciar lista** (dos toques) ahora es un cierre: guarda en la base (`rf_cierres`) todos los paquetes y la ruta con la fecha del cierre y después vacía *Paquetes* y *Ruta* para empezar una ruta nueva. Si no se puede guardar (sin internet), no borra nada. Requiere correr de nuevo `supabase.sql`. (2) El globito de *Paquetes* cuenta solo los que faltan por entregar (sin entregados, devueltos ni los marcados ⛔ Devolver).
- **1.50.1 · Devolver junto al estado:** en *Paquetes*, la etiqueta **⛔ Devolver** queda siempre a la par del estado (Pendiente, Confirmado…); si el nombre es largo, bajan juntas.
- **1.50.0 · Devolver:** en *Ruta*, a la par de **⏸ Hold** y **✓ Entregado**, está **⛔ Devolver**. La parada queda en la ruta pero desactivada (gris, sin botones, fuera del orden, la línea y el tiempo) y en *Paquetes* la tarjeta lleva la etiqueta **⛔ Devolver**. **↩ Quitar devolver** la reactiva.
- **1.49.0 · Soporte arriba y pestaña Cierres:** el botón **🎧 Soporte** pasa al encabezado, a la par del día de entrega. En su lugar, en la barra de abajo, queda la pestaña nueva **Cierres** (por ahora vacía; su contenido viene en próximas versiones).
- **1.48.5 · Nuevo mensaje "en camino":** texto nuevo de Victor con *IMPORTANTE* (cédula) y POLÍTICA DE ENTREGA; el tiempo estimado de la parada va después de "en".
- **1.48.4 · Mensaje "en camino" con política:** el WhatsApp de cada parada en *Ruta* agrega la "Política de entrega" (cédula y devolución a bodega si no se logra la entrega).
- **1.48.3 · Hold amarillo también seleccionada:** el pin de una parada en Hold sigue amarillo aunque la toqués (antes se ponía naranja al seleccionarla).
- **1.48.2 · Hold en amarillo:** en el mapa de *Ruta*, el pin de una parada en Hold sale amarillo.
- **1.48.1 · Unir por número:** en *Ruta*, **🔗 Unir a paquete** acepta el número del paquete (por ejemplo 62).
- **1.48.0 · Ruta consistente:** tarjetas, pines, línea del mapa, 📋 Lista, tiempo total y orden salen de la misma regla. (1) Una parada solo toma número, estado y datos de un paquete si la unión es segura (a mano, guía, mismo nombre o teléfono); antes una coincidencia floja podía mostrar el número o el "entregado" de otro cliente. Sin paquete unido muestra "–" en vez de un número inventado. (2) Los paquetes **devueltos** salen de la ruta igual que los entregados (gris, al final, fuera de la línea y del total) y dicen "↩ devuelto". (3) Sincronización: si dos aparatos cambian la ruta, gana la que se tocó a mano más recientemente y de la otra solo se rescatan las entregas; un aparato atrasado ya no revive paradas ni deshace el orden.
- **1.47.2 · Ruta sin cambios solos:** la app ya no agrega sola a la ruta paquetes de la lista (metía paquetes de otros días) ni une paradas a paquetes por palabras sueltas del nombre (cambiaba paradas por otros clientes). Una sola vez quita de la ruta las paradas que había agregado sola y no se entregaron. Una parada solo toma datos de su paquete si coinciden guía, nombre o teléfono, o si se unió a mano. Al **editar** un paquete con ubicación que no está en la ruta, sí se agrega.
- **1.47.1 · Hold a la izquierda:** el botón **⏸ Hold** queda a la izquierda de **✓ Entregado**.
- **1.47.0 · Hold:** en *Ruta*, a la par de **✓ Entregado** está **⏸ Hold**: la parada pasa al final de la ruta (antes de las sin ubicación y las entregadas) y ahí se queda aunque la ruta se reordene. **▶ Quitar hold** (amarillo) la devuelve y reordena.
- **1.46.0 · Lista de la ruta:** en *Ruta*, **📋 Lista** muestra la ruta en el orden de entrega con el número de cada paquete (1. #13 Suyapa · teléfono…). Se puede tomar captura, copiar o compartir por WhatsApp.
- **1.45.3 · Coordenadas en grados:** la ubicación también se puede pegar como la copia Google Maps en grados, minutos y segundos (9°54'24.5"N 84°03'45.1"W).
- **1.45.2 · Poner en la ruta:** si un paquete tiene ubicación pero su parada en *Ruta* sigue con el "?" amarillo, en *Paquetes* sale **📍 Poner en la ruta**. Le pasa la ubicación a esa parada, que queda unida al paquete y se vuelve pin rojo, con el mismo número.
- **1.45.1 · Sin ubicación en rojo:** en *Paquetes*, la tarjeta de un paquete pendiente sin ubicación (o con una que no se puede leer) tiene el borde rojo.
- **1.45.0 · Buscar en Paquetes:** arriba de la lista hay un buscador 🔍 por nombre (sin importar tildes), teléfono (3 o más dígitos), guía o número de paquete.
- **1.44.5 · Tiempo arriba:** en cada parada de *Ruta*, el tiempo estimado pasa a la primera línea (tiempo · 🚗 Waze · WhatsApp) y 🗺️ Maps a la segunda (🗑️ Quitar · Maps · 📸 Evidencia · 📲 Co-out).
- **1.44.4 · Maps y Waze:** en cada parada de *Ruta* la primera línea queda 🗺️ Maps · 🚗 Waze · WhatsApp.
- **1.44.3 · Galería a la par:** en *Paquetes*, el botón **🖼️ Galería** (antes "Elegir fotos de la galería") queda en la misma línea que **📷 Escanear etiquetas**.
- **1.44.2 · Ruta alineada:** en cada parada, Waze, Maps y WhatsApp se reparten a lo ancho, así WhatsApp termina alineado con Co-out y Maps queda al centro.
- **1.44.1 · Mensajes como antes:** el estilo nuevo de los botones de *Paquetes* (1.41.2) se había pasado a *Mensajes*; ahora solo aplica en *Paquetes* y *Mensajes* queda igual que en la 1.40.
- **1.44.0 · Botones de Ruta:** cada parada trae tres líneas. Arriba 🚗 Waze, 🗺️ Maps y WhatsApp (verde). En medio 🗑️ Quitar, el tiempo estimado, 📸 Evidencia y 📲 Co-out. Abajo, centrado, **✓ Entregado** en negro (o ↩ Deshacer).
- **1.43.0 · WhatsApp "en camino":** en *Ruta*, el botón **WhatsApp** de cada parada abre el chat con el mensaje "Estamos en camino, en aprox [tiempo estimado], le estaremos entregando su paquete, *RECUERDE* presentar su Cédula, en la entrega". Si la parada no tiene tiempo estimado, va sin esa parte.
- **1.42.0 · Quitar parada:** en *Ruta*, cada parada trae **🗑️ Quitar** (pide confirmación). La parada sale de la ruta, el paquete sigue en *Paquetes* y ya no se vuelve a agregar solo; con **➕ Agregar a la ruta** en *Paquetes* vuelve.
- **1.41.2 · Botones en dos líneas:** en *Paquetes*, primera línea 📋 Pegar respuesta · Editar · 📷 Escáner; segunda Borrar · ↩ Devuelto · WhatsApp. Siempre en dos líneas a todo el ancho de la tarjeta; Waze sale de *Paquetes* (sigue en *Ruta*).
- **1.41.1 · WhatsApp bajo Escáner:** en *Paquetes*, el botón **WhatsApp** queda siempre justo debajo de **📷 Escáner**.
- **1.41.0 · Botones de Paquetes:** sin **Maps**; nuevo orden: Pegar respuesta, Editar, Waze, **Borrar** (antes Quitar), **↩ Devuelto**, **📷 Escáner** (antes Etiqueta) y WhatsApp debajo.
- **1.40.1 · Entregados en gris:** en *Paquetes*, la tarjeta de un paquete entregado se ve apagada en gris (los botones siguen sirviendo para corregir).
- **1.40.0 · Número tachado:** al tocar **✓ Entregado** en *Ruta*, el número del paquete sale tachado (en la tarjeta, el pin y en *Paquetes*) y la parada baja al final de la lista.
- **1.39.2 · Diagnóstico en pantalla:** en iPhone no se podía pegar el diagnóstico. Ahora **🧪 Ver diagnóstico de la ruta** lo muestra en pantalla para tomarle captura, con botones **📤 Compartir** (WhatsApp, Notas…) y **📋 Copiar**.

## 2026-11-01
- **1.39.1 · Diagnóstico:** en *Soporte*, el botón **🧪 Copiar diagnóstico de la ruta** copia un texto que muestra cómo están unidas las paradas sin ubicación con sus paquetes, para mandarlo a soporte.
- **1.39.0 · Paquetes y Ruta siempre unidos:** si una parada no encuentra su paquete (nombre escrito distinto y teléfono cambiado), se une al paquete libre que comparte palabras del nombre o el mismo número escrito. La app recuerda los teléfonos anteriores de cada paquete. Los paquetes con ubicación que no tienen parada se agregan solos a la ruta. Así, al corregir nombre, teléfono o ubicación en *Paquetes*, la parada pasa a pin rojo y entra al mapa sin tocar nada.
- **1.38.2 · El número nunca cambia:** el número de cada paquete queda guardado aparte (también en la nube) y no cambia al ordenar, quitar, editar, reescanear ni sincronizar. Al quitar un paquete su número no se vuelve a usar. Solo **Vaciar lista** (o reemplazar la lista al importar) empieza otra vez desde 1.
- **1.38.1 · Paquetes dice si está en la ruta:** cada paquete muestra "🗺️ En la ruta" o, si tiene ubicación y no está, el botón **➕ Agregar a la ruta**. Si la ubicación que se pegó no se puede leer (por ejemplo un link corto maps.app.goo.gl), lo avisa en rojo.
- **1.38.0 · Número fijo del paquete:** cada paquete tiene un número fijo (su posición en la lista; los nuevos toman el siguiente) y se ve igual en *Paquetes*, *Mensajes* y en el pin y la tarjeta de *Ruta*. El orden de la ruta no cambia, solo el número que se muestra.
- **1.37.3 · Paquetes manda en todo:** para cualquier paquete, si le cambiás el nombre, el teléfono o la ubicación en *Paquetes*, su parada en *Ruta* toma los mismos datos. La unión entre parada y paquete se mantiene aunque cambien todos esos datos.
- **1.37.2 · Paquete correcto para cada parada:** si hay dos paquetes parecidos (por ejemplo, uno repetido con el teléfono viejo), la parada se une al que más coincide y tiene ubicación, no al primero que encuentra. Las paradas sin ubicación muestran a qué paquete están unidas (🔗 nombre · teléfono), y al tocarlo se puede cambiar.
- **1.37.1 · Unir parada y paquete:** la app reconoce también los links de Waze para compartir (waze.com/ul/h…) como ubicación. Encuentra el paquete aunque el nombre tenga apellidos de más. Si una parada no está unida a ningún paquete, muestra **🔗 Unir a paquete** para unirla a mano; desde ahí toma el teléfono y la ubicación del paquete.
- **1.37.0 · Ubicación de Paquetes a Ruta:** si un paquete recibe o cambia su ubicación en *Paquetes* (Pegar respuesta, Editar), su parada en *Ruta* la toma sola. Si era un "?" amarillo, pasa a pin rojo con número, entra al mapa y la ruta se reordena desde donde estás. También aplica al abrir la app.
- **1.36.0 · Una sola pestaña de ruta:** se quitó la pestaña vieja *Ruta* (calcular mejor ruta a mano) y la pestaña *Entrega* ahora se llama **Ruta**. Pestañas: Paquetes, Mensajes, Ruta y Soporte.
- **1.35.1 · Teléfono al día en Entrega:** al abrir la app, cada parada toma el teléfono que tiene su paquete en *Paquetes* (por guía o nombre), aunque el número se haya corregido antes de la 1.34.
- **1.35.0 · Entregadas al final:** en *Entrega*, las paradas ya entregadas bajan totalmente al final de la lista; arriba quedan las pendientes en orden de ruta y luego las que no tienen ubicación. El "?" de las paradas sin ubicación ahora es amarillo.
- **1.34.0 · Teléfono también en Entrega:** al cambiar el teléfono de un paquete en *Paquetes* (Editar o 📷 Etiqueta), su parada en *Entrega* toma el número nuevo, y con él el WhatsApp. También copia el nombre y la guía. Se sincroniza.
- **1.33.0 · Hora y lugar del Entregado:** al tocar **✓ Entregado** en *Entrega* se guarda la hora y la ubicación GPS de ese momento. Se ven en la parada y en el paquete, con link al mapa.
- **1.32.0 · WhatsApp en Paquetes:** cada paquete con teléfono tiene un botón **WhatsApp** a la par de Quitar, que abre el chat del cliente sin mensaje.
- **1.31.0 · Corregir etiqueta:** cada paquete en *Paquetes* tiene el botón **📷 Etiqueta** para volver a escanear su etiqueta si se leyó mal. Corrige ese mismo paquete (no agrega otro); lo que no se lea se queda como estaba.
- **1.30.0 · Paquetes ordenados:** la lista de *Paquetes* muestra primero los que faltan; los entregados van al final y los devueltos de últimos.
- **1.29.1 · Entregado llega a Paquetes:** las paradas marcadas como entregadas antes de la 1.28, o desde otro aparato, ahora también pasan su paquete a *Entregado* al abrir la app. La guía se compara sin importar si el escáner leyó O en vez de 0 (JCROO… = JCR00…).
- **1.29.0 · Devuelto:** en *Paquetes*, el botón **↩ Devuelto** marca el paquete como devuelto al almacén (por ejemplo, si no tiene dirección). Sale del cálculo de ruta y se cuenta aparte; **↪ Quitar devuelto** lo regresa al estado que tenía.
- **1.28.0 · Entregado también en Paquetes:** al tocar **✓ Entregado** en *Entrega*, el mismo paquete (por guía, teléfono o nombre) queda como entregado en *Paquetes* y se sincroniza. **↩ Deshacer** lo devuelve al estado que tenía.
- **1.27.1 · Derechos:** debajo del pie de la app y del Panel, en letra pequeña: "© 2026. InfolinkCR todos los derechos reservados."
- **1.27.0 · Lupa en Entrega:** debajo del resumen de la ruta (arriba del mapa) hay un buscador. Escribís parte del nombre (sin importar tildes), el teléfono o la guía y te lleva a esa parada en el mapa y en la lista; Enter pasa a la siguiente si hay varias.
- **1.26.4 · Botones ordenados:** cada parada muestra en la primera fila Waze, Maps y WhatsApp; en la segunda el tiempo estimado; en la tercera Evidencia, Co-out y Entregado, en una sola línea.
- **1.26.3 · Co-out en todas:** el botón **📲 Co-out** sale en todas las paradas de *Entrega*, junto a WhatsApp.
- **1.26.2 · Etiqueta sin recargar:** si la ruta se cargó antes de la 1.25.0, la etiqueta toma lo que dice la ubicación del paquete en *Paquetes* (por ejemplo "Aplicacion" = Co-out).
- **1.26.1 · Co-out sin recargar:** el botón **📲 Co-out** también sale en las paradas sin ubicación de una ruta cargada antes de la 1.25.0 (que dicen "Sin dato"), sin tener que volver a cargar el Excel.
- **1.26.0 · Botón Co-out:** en las paradas Co-out, el botón **📲 Co-out** abre la app Co-out del iPhone por medio de un atajo (app Atajos) llamado "Co-out".
- **1.25.0 · Etiqueta de ubicación:** las paradas sin ubicación ("?") muestran a la par del nombre lo que dice la columna ubicación del archivo ("Co-out" en vez de "Aplicacion", "no respode", "Vacío"). Al tocar la etiqueta podés pegar el link o las coordenadas, o tocar el punto en el mapa; la parada entra a la ruta y se reordena.
- **1.24.3 · Inicio y fin:** el resumen de la ruta muestra la hora de inicio (la hora actual, se refresca cada minuto) y la hora estimada de fin.
- **1.24.2 · Fin desde ahora:** se quitó la hora de salida fija de la 1.24.1. La hora de fin vuelve a contarse desde la hora actual y dice "Si salís ya: terminás …".
- **1.24.0 · Tiempo y km de toda la ruta:** en *Entrega*, a la derecha de "Estás aquí", se muestra el tiempo estimado de la ruta completa: desde tu punto, por cada parada pendiente y hasta la última, por calle, más 3 a 5 min por entrega. También los km por calle y la hora en que terminarías. Se recalcula al entregar o al moverte.
- **1.23.0 · Botón Entregado:** en cada parada de *Entrega*, entre Evidencia y el tiempo estimado. Al tocarlo, el número y el pin se ponen grises; con **↩ Deshacer** vuelve a pendiente.
- **1.22.1 · Botón Evidencia:** en *Entrega*, el botón **✓ Entregar** ahora dice **📸 Evidencia**.
- **1.22.0 · Ruta ordenada por calle:** al ordenar en *Entrega* (sola o con el botón) se usan los tiempos reales por calle de OSRM entre todas las paradas, no la línea recta. Si OSRM no responde en 8 segundos, se ordena con la línea recta como antes.
- **1.21.1 · Tiempo más real:** el tiempo junto a Entregar ahora se calcula por calle con OSRM (gratis); si no responde, se estima en línea recta. En ciudad se cuenta mínimo 18 km/h y 1 minuto para arrancar y parquear, para acercarse a lo que da Waze.
- **1.21.0 · Tiempo hasta cada cliente:** en *Entrega*, a la par de **✓ Entregar** sale el tiempo y la distancia aproximados desde donde estás (🚗 ~8 min · 2,1 km). Se actualiza con el GPS.
- **1.20.1 · Se ordena sola desde tu punto:** al cargar la ruta o abrir *Entrega*, la primera vez que llega el GPS la ruta se reordena sola desde donde estás (si no se había ordenado ya desde cerca de ahí, a menos de 800 m). Antes la línea azul unía tu punto con la parada 1 del archivo aunque no fuera la más cercana.
- **1.20.0 · Ordenar desde aquí:** en *Entrega*, el mapa muestra tu punto actual (azul) y **📍 Ordenar desde aquí** reordena las paradas que faltan desde donde estás. Si el GPS falla, **🎯 Elegir en el mapa** deja tocar el punto de partida.
- **1.19.5:** arreglo de la ruta que no llegaba al celular: si la nube estaba en la misma versión pero sin la ruta, la laptop no la volvía a subir. Ahora la sube sola al abrir, al cargar la ruta (avisa *Ruta subida a la nube*) y al tocar ☁️; el celular baja lo último al abrir *Entrega*.
- **1.19.4:** la frase de la cédula agregada a los mensajes se sube a la nube y otro aparato con el texto viejo ya no la borra.
- **1.19.3:** el mensaje *Coordinar* también termina con *Recuerde que para la entrega debe presentar la cédula* (se agrega solo al texto guardado).
- **1.19.2:** *Entrega* acepta la ruta de hoy o la de mañana sin marcarla en rojo; tocar ☁️ en el pie dice qué tiene la nube (versión, paquetes y ruta).
- **1.19.1:** arreglo de la nube: la ruta cargada en la PC no llegaba al celular porque el celular, con cambios propios pendientes, la pisaba. Ahora se mezcla parte por parte y nada se pierde.
- **1.19.0 · Pestaña Entrega:** nueva pestaña entre *Ruta* y *Soporte*. Carga el Excel de la ruta del día (*Ruta AAAA-MM-DD.xlsx*) y muestra arriba el mapa con las paradas numeradas en orden y abajo la lista; tocar una parada la ubica en el mapa y tiene botones de Waze, Google Maps, WhatsApp y Entregar.
- **1.18.4:** el mensaje *Voy en camino* también recuerda presentar la cédula (se agrega solo al texto guardado; se puede editar).
- **1.18.3:** al confirmar el formulario, el cliente ve el aviso *Recuerde que para la entrega debe presentar la cédula*.
- **1.18.2:** en iPhone, *Guardar contactos del día* muestra primero los pasos para guardarlos todos (por Mail o Archivos) y avisa que no se toque *Contactos* en el menú, porque así solo entra el primero.

## 2026-10-31
- **1.18.1:** el pie muestra el estado de la nube (*al día*, *sin activar: falta correr supabase.sql*, *sin conexión*) y se toca para sincronizar.
- **1.18.0 · Lista en la nube:** los paquetes y los textos de los mensajes se guardan en la cuenta (Supabase) y se ven iguales en el teléfono y en la PC. Lo nuevo y lo borrado en un aparato pasa al otro. Hay que volver a correr `supabase.sql` (tabla `rf_listas`, funciones `rf_lista_leer` y `rf_lista_guardar`).
- **1.17.1:** en iPhone, *Bajar Excel del día* abre el menú de compartir para guardarlo en *Archivos* en la carpeta *RutaFacilCR*, con los pasos en pantalla.
- **1.17.0 · Excel del día:** en *Mensajes*, **📊 Bajar Excel del día** baja la plantilla de paquetes llena con todos los clientes, más las columnas *fecha ingreso* (cuándo se agregó cada cliente) y *contacto* (*TM-Nombre-pedido*). Los nombres en contactos y Excel ya no cambian *de*/*del* a mayúscula.
- **1.16.2:** nombres con tildes bien escritos (antes el escáner dejaba *ChavarríA*, *GéNesis*, *BriceñO*) y sin guion al inicio (*TM--Juan*). Los nombres ya guardados se corrigen solos al abrir la app.
- **1.16.1:** en iPhone, *Guardar contactos del día* abre el menú de compartir para guardar el archivo en *Archivos* y agregar todos de una vez (Safari solo agregaba el primero).
- **1.16.0 · Contactos del día:** en *Mensajes*, **📇 Guardar contactos del día** baja un `.vcf` con todos los clientes como *TM-Nombre-pedido* (prefijo editable) para importarlos de una vez en iPhone o Android. Nuevo buscador de clientes por nombre, guía o teléfono.
- **1.15.4:** *Confirmar entrega* ya no queda gris sin explicación: al tocarlo dice qué falta (fotos, firma o ubicación) y lleva a esa parte. Si el GPS no responde, permite confirmar sin GPS. Errores al guardar se muestran en pantalla.
- **1.15.3:** el link del formulario sale en WhatsApp sin tarjeta de vista previa (sin logo ni título), solo el texto con el link.
- **1.15.2:** la vista previa del formulario en WhatsApp sale sin logo, solo con el título *RutaFácil · Su entrega*.
- **1.15.1:** la vista previa del formulario en WhatsApp muestra el logo pequeño al lado del título en vez de una portada grande (`og-mini.png`, 160 px).
- **1.15.0 · Mensajes más limpia:** arriba quedan solo el nombre y el día de entrega, y luego la lista de clientes. Los textos de los mensajes pasan al final, plegados en *✏️ Editar textos de los mensajes*. Se quita el cuadro *Cómo funciona* (la explicación queda en una línea arriba).
- **1.14.1:** en *Mensajes* se puede escribir *Tu nombre* (antes quedaba bloqueado con el nombre de la cuenta y en iPhone no salía el teclado). Si se borra, vuelve el nombre de la cuenta.
- **1.14.0 · Elegir el mensaje:** en *Mensajes*, cada cliente tiene botones **1. Coordinar · 2. Formulario · 3. En camino** para elegir cuál mandar; la vista previa, *Abrir WhatsApp* y *Copiar* usan el elegido. Antes *Abrir WhatsApp* siempre mandaba el primero. Se quita el botón aparte *📝 Mandar formulario*.

## 2026-10-30
- **1.13.0 · Firma y recorrido:** la prueba de entrega pide la **firma con el dedo** y el nombre de quien recibe (o marcar "No quiso firmar"); la firma se sube con las fotos. En *Ruta*, **Recorrido de hoy**: mapa (OpenStreetMap) con las entregas numeradas en el orden en que se hicieron y botón para abrirlo en Google Maps. Requiere volver a correr `supabase.sql` para guardar quién recibe.
- **Base de datos (para la firma de entrega):** `entregas.recibe` (quién recibe) y `registrar_entrega(…, p_recibe)`. La firma se guarda como foto `_firma.jpg`. Hay que volver a correr `supabase.sql`.
- **1.12.2:** en la pantalla de entrar, *¿No tenés cuenta? **Crear cuenta*** se ve como enlace subrayado, igual que *Escribinos por WhatsApp*. Los demás enlaces de esa pantalla también van subrayados.
- **1.12.1:** en *Crear cuenta* los campos salen en blanco (sin el ejemplo "Victor Mena" / "8888 1234", que parecía ya escrito) y sin autocompletar; los textos de ejemplo de *Entrar* se ven más claros.
- **1.12.0 · Espera de activación:** en la pantalla de cuenta pendiente, vencida o con teléfono por aprobar, el botón *Revisar de nuevo* pasa a ser gris y deshabilitado (*⏳ Esperando activación*). La app revisa sola cada minuto y, cuando el administrador activa la cuenta, muestra *✅ Cuenta habilitada* con el botón naranja **Entrar**.
- **1.11.1:** el botón *Cerrar* de Soporte pasa arriba, junto al título, compacto y con el mismo estilo que *Guardar ajustes*.
- **1.11.0:** aviso *Hay una versión nueva · Actualizar* cuando se publica un cambio y el celular sigue con la versión vieja en caché.
- **1.10.4:** el botón *Cerrar* de Soporte queda pequeño y centrado (tamaño de *Guardar ajustes*), siempre visible abajo.
- **1.10.3:** el botón *Cerrar* de Soporte pasa a naranja con texto blanco en negrita, igual que *Guardar ajustes* del panel.
- **1.10.2:** el botón *Cerrar* de Soporte queda fijo abajo, siempre a la vista aunque haya muchos videos.
- **1.10.1:** el botón *Cerrar* de Soporte ahora es un botón grafito de ancho completo, bien visible.
- **Videos de ayuda:** seis videos cortos (menos de 1 min c/u, verticales, con voz y subtítulos) en `videos/` y listados en `videos.json`, para *Soporte > Videos*: entrar, cargar paquetes, mensajes, pegar respuesta, ruta y prueba de entrega.
- **1.10.0 · Avisos de cuentas:** cuando alguien crea cuenta o pide usar otro teléfono, al administrador le llega un WhatsApp (CallMeBot) y un correo (Resend), los dos gratis, configurables en *Panel > Ajustes*. Al activar, renovar o reactivar, el panel ofrece *Avisarle por WhatsApp* con el mensaje listo. La pantalla de espera del repartidor revisa cada minuto y la app se abre sola al activarse. Hay que volver a correr `supabase.sql`.
- **1.9.0:** *Soporte* pasa a la barra de abajo, a la par de *Ruta*, con el ícono de audífonos; sale del encabezado.
- **1.8.3:** el botón de Soporte y los enlaces de ayuda de la pantalla de entrar llevan un ícono de audífonos con micrófono (estilo call center) en vez de ❓.
- **1.8.2:** arreglo de diseño: en *Paquetes*, la línea de evidencia (📷 fotos · Ver evidencia) ya no aprieta la tarjeta del paquete.
- **1.8.1:** la pantalla de entrar, crear cuenta y los avisos de cuenta llevan el enlace *¿Necesitás ayuda? Escribinos por WhatsApp* al soporte (6270 0666, se puede cambiar con `soporte` en `config.js`). Los botones de contacto de cuenta vencida, suspendida o teléfono pendiente también van a ese número.
- **1.8.0 · Soporte:** botón *❓ Soporte* arriba (y en el pie) con WhatsApp directo al 6270-0666 y los videos de cómo se usa la app (lista en `videos.json`).
- **1.7.1:** al entrar, si el número no tiene cuenta la app sugiere *Crear cuenta*, y si la cuenta no está confirmada dice que falta apagar *Confirm email* en Supabase (antes decía solo "Número o PIN incorrecto").
- **1.7.0 · Cuentas (Fase 1a):** la app pide entrar con número de teléfono y PIN de 6 números (`auth.js`). Cada cuenta funciona en un solo celular: otro teléfono queda esperando aprobación y, al aprobarlo, el anterior se cierra. Pantallas de cuenta sin activar, vencida, suspendida y teléfono pendiente, con los datos para pagar por SINPE Móvil. El nombre de la cuenta firma los mensajes. Sin internet abre hasta 3 días con la última revisión. Nuevo **panel del administrador** (`admin.html`): cuentas, pagos, prueba de 14 días, suspender, aprobar teléfonos, PIN nuevo, ajustes y borrado de fotos viejas para no pasarse del plan gratis. En Supabase (`supabase.sql`): tablas `rf_ajustes`, `rf_perfiles`, `rf_pagos`, `rf_eventos`; con **Exigir cuenta activa**, `leer_respuestas`, `registrar_entrega` y la subida de fotos solo responden a una cuenta al día desde su teléfono aprobado. Requiere correr de nuevo `supabase.sql` y apagar *Confirm email* en Supabase (ver manual técnico).
- **1.6.2:** la versión sale del encabezado y pasa al final de la app con numeración profesional (mayor.menor.corrección).
- **Pestañas abajo (v30-oct-b):** *Paquetes*, *Mensajes* y *Ruta* pasan a una barra fija abajo, con ícono y sin números, como una app. Un globito naranja muestra cuántos paquetes hay.
- **Nuevo diseño (v30-oct-a):** paleta *Grafito y naranja* y títulos sin mayúsculas en la app y el formulario. Nuevo logo: pin con paquete en grafito y naranja; íconos de app 192, 512, maskable y iPhone, y logo en el encabezado.
- **Nueva dirección:** la app se mudó a la organización de GitHub *rutafacilcr* y ahora vive en https://rutafacilcr.github.io/ (sin el nombre del dueño en el link). El link viejo deja de funcionar y la lista del celular arranca vacía en la dirección nueva.

## 2026-10-29
- **Ruta con horarios (v29-oct-l):** la ruta respeta el horario que confirmó cada cliente (8 a 10 am, 2 a 4 pm, en la tarde, después de las 3…). Nueva *Hora de salida*, hora estimada de llegada por parada, aviso ⚠ si alguna quedaría fuera de horario y botón *Usar mi ubicación actual* para recalcular a media ruta. Optimización con 2-opt y reubicación de tramos, probada con 70 paradas.
- **Escanear etiquetas (v29-oct-k):** en *Paquetes*, foto a la etiqueta (o varias fotos de la galería): la guía sale del código de barras y nombre, teléfono y dirección se leen con OCR gratis dentro del celular (Tesseract.js). Se revisa y se guarda en serie; avisa si la guía ya está en la lista. La foto se endereza sola y no se guarda.
- **Ahorro de espacio (v29-oct-j):** fotos de evidencia a 1024 px (~100–150 KB). Las fotos ya respaldadas se borran del celular a los 7 días. Consulta SQL para ver el espacio usado.
- **📋 Pegar respuesta (v29-oct-i):** un botón por cliente lee lo copiado de WhatsApp, saca hora y ubicación (incluso pines de lugar, buscándolos en OpenStreetMap) y lo marca Confirmado, sin abrir Editar.
- **Prueba de entrega (v29-oct-h):** al marcar *Entregado* la app captura GPS, fecha y hora y exige mínimo 3 fotos con sello. Se guarda en el celular y se sube a Supabase (tabla `entregas`, Storage `evidencias`). Requiere correr de nuevo `supabase.sql`.
- **Formulario en dos pasos (v29-oct-g):** el primer mensaje sigue sin links; el formulario se manda aparte con el botón *📝 Mandar formulario* a quien ya contestó. Vista previa sobria sin textos de "no pide pagos". En el formulario, la ubicación por WhatsApp va primero y el GPS queda como opción secundaria.
- **Sin links (v29-oct-f):** el mensaje nunca lleva el link del formulario, aunque esté guardado de antes. Se quita la casilla y el panel de respuestas. `entrega.html` y Supabase quedan sin uso.
- **Mensaje simple por defecto (v29-oct-e):** corto, cercano y sin links; el cliente responde hora y ubicación por WhatsApp. El link del formulario pasa a ser opcional (casilla *Agregar al mensaje el link del formulario*).
- **Formulario:** cuando el iPhone bloquea la ubicación, la ayuda recomienda primero mandarla por WhatsApp y da los pasos correctos de iOS. Más espacio al final para que la barra de Safari no tape el texto.
- **Corrección:** en WhatsApp desaparecía el signo "+" del mensaje; ahora dice "toque el clip 📎 (o el signo de más)". Se quitan espacios sobrantes en la fecha.
- **Versión visible** en el encabezado de la app (`v29-oct-c`) para confirmar que el celular tiene la última versión.
- **Diagnóstico:** los errores al enviar o revisar respuestas muestran el código del servidor.
- **Más confianza en el mensaje:** el cliente puede responder por el mismo chat (hora y ubicación de WhatsApp) o usar el formulario. El mensaje aclara que no pide pagos ni datos bancarios. Link más corto (`…/RutafacilCR/entrega?t=…`) y vista previa con el ícono de RutaFácil.
- **Ubicación más fácil en el formulario:** botón "Prefiero mandarla por WhatsApp", reintento del GPS con ubicación aproximada y ayuda específica cuando el teléfono bloquea el permiso. El formulario pasó a `entrega.html`; `f.html` redirige los links viejos.
- **Corrección:** el link del formulario siempre va en el mensaje, aunque la plantilla guardada no tenga `{formulario}`. Los cuadros de mensaje crecen para mostrar todo el texto (antes se veía cortado en iPhone).
- **Documentación:** README para GitHub, manual de usuario, manual técnico y manual de programador y diseño (`docs/`).
- **Formulario del cliente activado** con Supabase (proyecto RutaFacil). Con llaves `sb_publishable_` se envía solo el header `apikey`.
- **Formulario para clientes** (`f.html`): horario, señas, quién recibe y ubicación (GPS o link). Cada mensaje de WhatsApp lleva un link único por paquete y las respuestas entran solas a la app (`supabase.sql`, `config.js`).
- **Ícono de la app** para la pantalla de inicio (iPhone y Android) y `manifest.json`.
- **Ubicación:** se puede pegar el link completo de Google Maps o Waze y la app deja solo las coordenadas.
- **Corrección:** link de GitHub Pages con mayúsculas (`RutafacilCR`).
- **Publicación** en GitHub Pages con plantilla de Excel `plantilla-paquetes.xlsx`.

## 2026-10-28
- Primera versión: importar paquetes, mensajes de WhatsApp con texto listo, ruta optimizada con Google Maps y Waze.
