# Manual de usuario · RutaFácil CR

Guía para el repartidor. No hace falta saber de computadoras.

**Link de la app:** https://rutafacilcr.github.io/

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

### Tu cuenta

La app pide entrar con **tu número de teléfono** y un **PIN de 6 números**.

1. **Crear cuenta** (solo la primera vez): tocá *¿No tenés cuenta? Crear cuenta*, escribí tu nombre (así te ven los clientes en los mensajes), tu número de WhatsApp y elegí un PIN (los campos salen en blanco). No uses PIN fáciles como 111111 o 123456.
2. **Activación:** la cuenta queda *esperando activación*. Pagá la mensualidad por **SINPE Móvil** al número que muestra la pantalla, con el detalle **RF + tu número** (ej. *RF 88887777*), y avisale al administrador por WhatsApp. Cuando la active, tocá **Revisar de nuevo**.
3. **Los días siguientes** la app abre sola. Si te pide entrar, poné tu número y PIN.

Reglas de la cuenta:

- **Es personal y funciona en un solo teléfono.** Si entrás en otro celular, ese queda *esperando aprobación* hasta que el administrador lo apruebe; cuando lo aprueba, el teléfono anterior se cierra.
- **Tu nombre** en los mensajes sale de la cuenta, pero lo podés cambiar en *Mensajes* (por ejemplo, solo el primer nombre). Si borrás el campo, vuelve el nombre de la cuenta.
- **Sin internet** la app sigue abriendo hasta 3 días con la última revisión.
- **Mensualidad:** al final de la app dice *al día hasta el …*. Si vence, tenés unos días de gracia (lo dice en rojo) y después la app se bloquea hasta que pagués.
- **¿Olvidaste el PIN?** Pedile uno nuevo al administrador por WhatsApp.
- **¿Necesitás ayuda?** En la pantalla de entrar está el enlace *Escribinos por WhatsApp* (soporte: 6270 0666).
- **Salir:** al final de la app, **Salir**. Tu lista de paquetes se queda en el celular.

---


**Mientras esperás la activación** el botón de abajo está gris y dice *⏳ Esperando activación*. No tenés que tocar nada: la app revisa sola cada minuto. Cuando el administrador activa tu cuenta, sale *✅ Cuenta habilitada* y el botón se pone naranja: tocá **Entrar**.

## 2. Rutina diaria

La app tiene cuatro pestañas en la **barra de abajo**: **Paquetes** (📦, con un globito que dice cuántos hay), **Mensajes** (💬), **Ruta** y **Cierres** (por ahora vacía). El botón **Soporte** (🎧) que abre la ayuda está **arriba**, en el encabezado, a la par del día de entrega. La pestaña en la que estás se marca en naranja.

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
2. Tocá **📂 Cargar ruta** y elegí el Excel del día, por ejemplo **Ruta 2026-11-01.xlsx** (en iPhone está en la app *Archivos*, carpeta *RutaFacilCR*). Vale la ruta de hoy o la de mañana (se arma el día antes); si es de otro día, la app lo avisa en rojo.
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
4. **Cuando el cliente conteste**, en ese cliente elegí **2. Formulario** (arriba del texto) y tocá **Abrir WhatsApp**. Le llega un segundo mensaje corto: *"Gracias Sofía. Para no fallarle con la entrega, ¿me ayuda marcando aquí su hora y las señas de la casa? Es 1 minuto: …"*. Como ya habló con vos, confía más en el link.
5. En el formulario el cliente marca horario y señas. Al enviarlo ve *¡Listo, gracias!* con el aviso **🪪 Recuerde que para la entrega debe presentar la cédula.** Para la ubicación, lo principal es **mandarla por WhatsApp** (clip 📎 > Ubicación); también puede pegar un link o usar el GPS.
6. Lo que llene **entra solo** a la app (revisa cada minuto, o tocá **Revisar respuestas ahora**) y queda **Confirmado** con 🕓 horario y 🏠 señas.
7. **Cuando el cliente responde por el chat (lo más común):** en WhatsApp mantené presionado su mensaje (la hora, la ubicación o los dos seleccionados) > **Copiar**. En la app tocá **📋 Pegar respuesta** en ese cliente. La app saca sola la **hora** y la **ubicación** y lo deja **Confirmado**. Si el iPhone pregunta "Permitir pegar", tocá **Permitir**. Si la ubicación no se puede copiar del chat, abrila, tocá **Compartir** > **Copiar** y volvé a tocar **📋 Pegar respuesta**.

**Elegir qué mensaje mandar:** cada cliente tiene arriba los botones **1. Coordinar**, **2. Formulario** y **3. En camino** (sin Supabase solo salen *1. Coordinar* y *2. En camino*). El que está en oscuro es el que se va a mandar: la vista previa, **Abrir WhatsApp** y **Copiar** usan ese mensaje. La app propone sola el siguiente (después del primero, el formulario), pero podés tocar cualquiera.

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

| Estado | Significa |
|---|---|
| Pendiente | Todavía no confirma. |
| Confirmado | Confirmó por WhatsApp o llenó el formulario. |
| No responde | Le escribiste y no contestó. |
| Entregado | Listo. |
| No se entregó | Intentaste y no se pudo. |

Tocá la etiqueta de color para pasar al siguiente estado.

---

## 4. Problemas comunes

**¿No ves la versión nueva?** Cuando se publica un cambio, la app muestra abajo *Hay una versión nueva · **Actualizar***: tocalo. Si no sale, cerrá la app por completo y abrila otra vez. GitHub puede tardar hasta 10 minutos en entregar la versión nueva.

**Ayuda:** tocá **Soporte** (el botón con audífonos arriba, en el encabezado, o *Soporte* al final de la pantalla). Ahí podés escribirnos por WhatsApp al **6270-0666** (el mensaje ya lleva tu versión de la app) y ver los **videos** de cómo se usa cada parte:

1. Entrar a la app (crear cuenta, número y PIN, soporte)
2. Cargar los paquetes (escanear etiquetas, subir el Excel)
3. Avisar por WhatsApp (mensaje y formulario)
4. Pegar la respuesta del cliente
5. Armar la ruta (horarios, Google Maps y Waze, voy en camino)
6. Prueba de entrega (GPS y 3 fotos)

**¿Qué versión tengo?** Bajá hasta el final de cualquier pestaña: dice *RutaFácil CR · versión 1.8.1*. Se lee **mayor.menor.corrección**: el primer número cambia con cambios grandes, el segundo con funciones nuevas y el tercero con arreglos.


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

**Avisos:** cuando alguien crea cuenta (o pide usar otro teléfono) te llega un WhatsApp y un correo con su nombre y número. Se configuran una vez en **Ajustes > Avisos cuando alguien crea cuenta** (pasos en el manual técnico) y con **Mandarme una prueba** revisás que lleguen.

**Avisarle al repartidor:** al tocar **Registrar pago**, **Dar 14 días de prueba** o **Reactivar**, abajo sale **Avisarle por WhatsApp** con el mensaje ya escrito (*tu cuenta ya está activa hasta el…*). Tocalo y en WhatsApp solo tocás Enviar. Aunque no le escribás, si la persona tiene la app abierta en la pantalla de espera, se le abre sola en menos de un minuto.

En **Ajustes** van el número SINPE que ven los repartidores, el precio, los días de gracia y el interruptor **Exigir cuenta activa** (ver manual técnico).



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

Cuando tocás **✓ Entregado** en *Ruta*, el número del paquete queda tachado y en gris, y la parada baja al final de la lista. En *Paquetes* el número también sale tachado, la tarjeta entera se ve apagada en gris (1.40.1) y el paquete pasa con los entregados. Sus botones siguen sirviendo por si hay que corregir algo. Si te equivocaste, **↩ Deshacer** lo devuelve.

### Entregas del día (1.60.0)

Los paquetes que te dan un día (por ejemplo 70 el 2 de noviembre) forman las **Entregas del 2 de noviembre**. Tenés varios días para entregarlos: los que entregués el 2 salen con fecha de entrega 2, los del 3 con fecha 3, y así. Todos quedan en el mismo reporte *Entregas del 2 de noviembre* en *Cierres*. Hacé **Vaciar lista** cuando terminés todos.

### Iniciar y Finalizar entregas (1.59.0)

Arriba de *Ruta* está la barra de la jornada:
1. Al salir a repartir tocá **▶ Iniciar entregas**: guarda la hora y tu ubicación.
2. Al terminar el día tocá **■ Finalizar** (pide confirmar): guarda la hora y dónde terminaste.
3. Si finalizaste antes de tiempo, tocá **▶ Seguir entregando**.

Con eso el reporte mide la primera entrega desde la salida (sale con ▶ en *Tiempo desde anterior*), suma los km de la última entrega al punto final y las *Horas invertidas* son de Iniciar a Finalizar. Dale permiso de ubicación a la app para que guarde los puntos.

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

En **Cierres** aparece una lista de reportes, uno por cada **fecha de recibido** de los paquetes (la fecha en que los escaneaste o los ingresaste), con cuántos se recibieron, entregaron y devolvieron. Tocá **📄 PDF** en la fecha que querés. Desde la 1.57.0 también salen las fechas de listas que ya vaciaste, porque se leen de los cierres guardados en la base (necesita internet). Se baja un PDF horizontal con los paquetes **entregados** y **devueltos** recibidos ese día, con estas columnas: No. paquete, No. guía / pedido, No. teléfono, Nombre (desde la 1.54.2; antes era "teléfono 2"), Estado, Fecha recibido, Fecha entrega y Hora entrega. En iPhone se abre el menú de compartir: elegí **Guardar en Archivos**. La hora de entrega es la del momento en que tocaste **✓ Entregado** en *Ruta* (o la de la evidencia). Desde la 1.56.3 se corrigen solas las entregas que habían quedado todas con la misma hora. Desde la 1.56.1 las filas van ordenadas por **fecha y hora de entrega** (o de devolución), de la más vieja a la más nueva; los que no tienen hora quedan al final. Arriba trae un encabezado con: **Fecha** y debajo **Mensajero** (el nombre de *Tu nombre* en ajustes), **Paquetes recibidos**, **entregados** y **devueltos** (uno debajo del otro, a la derecha), **Km recorridos** y **Horas invertidas**. Los km son aproximados: la distancia entre el inicio de la ruta y cada entrega, en el orden en que entregaste, más un 35 % por las calles. Las horas van de la primera a la última entrega o devolución. El encabezado también trae la **Fecha de recibido** de ese grupo.


### Vehículo (1.55.0)

En **Ruta**, a la par de **📋 Lista**, hay tres botones: **🏍 moto**, **🚙 carro** y **🚐 buseta**. Tocá el que vas a usar; queda marcado en naranja y se guarda (moto viene marcado al inicio). No cambia los tiempos, los km ni el orden de la ruta. Desde la 1.56.4, el ícono elegido va en el WhatsApp de "en camino", justo después de la palabra *camino* (por ejemplo "Estamos en camino 🏍️, le estaremos entregando…"), tanto en *Ruta* como en el mensaje 3 de *Mensajes*.
