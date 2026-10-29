# Manual de usuario · RutaFácil CR

Guía para el repartidor. No hace falta saber de computadoras.

**Link de la app:** https://victormenav.github.io/RutafacilCR/

---

## 1. Antes de empezar

- Usá la app en el **mismo celular** donde tenés WhatsApp con el número que les escribe a los clientes. Los mensajes salen de la cuenta de WhatsApp abierta en ese celular.
- Recomendado: usar **WhatsApp Business**. Es gratis y los clientes confían más.
- La lista se guarda **en ese celular**. Si abrís la app en otro teléfono o en la PC, no vas a ver la misma lista.

### Instalar el ícono

- **iPhone (Safari):** abrí el link > botón **Compartir** > **Agregar a pantalla de inicio** > **Agregar**.
- **Android (Chrome):** abrí el link > menú **⋮** > **Agregar a la pantalla principal** (o **Instalar app**).

Después abrí siempre la app desde el ícono **RutaFácil**. En iPhone, el ícono guarda sus datos aparte de Safari.

---

## 2. Rutina diaria

### Día antes: cargar paquetes (pestaña **1 Paquetes**)

La primera vez vas a ver datos de ejemplo: tocá **Borrar ejemplo**.

Tenés tres formas de cargar:

1. **Plantilla de Excel:** tocá **Bajar plantilla de Excel**, llenala (un paquete por fila) y subila con **Subir Excel / CSV**.
2. **Copiar y pegar:** seleccioná las filas en Excel o Google Sheets, copiá y pegá en el cuadro **Importar lista** > **Agregar a la lista**.
3. **A mano:** **Agregar un paquete a mano**.

Columnas: `nombre`, `telefono`, `direccion`, `ubicacion`, `guia`, `nota`.

- **Teléfono:** los 8 dígitos. La app agrega el +506.
- **Ubicación:** pegá el link completo que manda el cliente (`https://maps.google.com/?q=...`), un link de Waze o las coordenadas (`9.99,-84.11`). Debajo sale en verde **✓ Coordenadas detectadas**. Los links cortos tipo `maps.app.goo.gl` no se leen: abrilos primero y copiá el link largo.
- Cada paquete muestra **● Ubicación lista** o **○ Falta ubicación**.

### Día antes: avisar a los clientes (pestaña **2 Mensajes**)

1. Poné **tu nombre** y revisá el texto del mensaje (se puede editar).
2. En cada cliente tocá **Abrir WhatsApp** > **Enviar** > volvé a la app.
3. **Primer mensaje, sin links:** *"Hola Sofía, soy Victor, le llevo su paquete de Temu el viernes. ¿A qué hora le queda bien recibirlo? Si puede, mándeme su ubicación por aquí 📍 ¡Gracias!"*
4. **Cuando el cliente conteste**, tocá **📝 Mandar formulario** en ese cliente. Le llega un segundo mensaje corto: *"Gracias Sofía. Para no fallarle con la entrega, ¿me ayuda marcando aquí su hora y las señas de la casa? Es 1 minuto: …"*. Como ya habló con vos, confía más en el link.
5. En el formulario el cliente marca horario y señas. Para la ubicación, lo principal es **mandarla por WhatsApp** (clip 📎 > Ubicación); también puede pegar un link o usar el GPS.
6. Lo que llene **entra solo** a la app (revisa cada minuto, o tocá **Revisar respuestas ahora**) y queda **Confirmado** con 🕓 horario y 🏠 señas.
7. **Cuando el cliente responde por el chat (lo más común):** en WhatsApp mantené presionado su mensaje (la hora, la ubicación o los dos seleccionados) > **Copiar**. En la app tocá **📋 Pegar respuesta** en ese cliente. La app saca sola la **hora** y la **ubicación** y lo deja **Confirmado**. Si el iPhone pregunta "Permitir pegar", tocá **Permitir**. Si la ubicación no se puede copiar del chat, abrila, tocá **Compartir** > **Copiar** y volvé a tocar **📋 Pegar respuesta**.

Los tres mensajes (primer mensaje, formulario y "voy en camino") se pueden editar en **2 Mensajes**.

**Para que los clientes confíen más:**
- Usá **WhatsApp Business** con foto de perfil, nombre (ej. "Victor · Entregas Temu") y descripción.
- El link solo se manda a quien ya contestó, y la vista previa en WhatsApp es sobria: "RutaFácil · Su entrega" con el ícono.
- Con un dominio propio el link se vería más corto y confiable (pendiente de decidir).

Variables que podés usar en los mensajes: `{nombre}` `{guia}` `{direccion}` `{fecha}` `{yo}` `{eta}` `{formulario}` (este último va en el mensaje del formulario). Si cambiás el mensaje y quitás `{formulario}`, la app agrega el link del formulario al final sola. El cuadro del mensaje crece para mostrar el texto completo.

### Día de entrega (pestaña **3 Ruta**)

1. **Punto de salida:** pegá las coordenadas o el link de donde salís. En Google Maps, dejá el dedo presionado sobre el lugar y copiá los números.
2. Elegí si incluir **todos** o **solo confirmados**, y si volver al punto de salida.
3. Tocá **Calcular mejor ruta**.
4. **Iniciar ruta** abre todo el recorrido en Google Maps. Con más de 10 paradas sale en **Tramo 1, Tramo 2…**
5. En cada parada:
   - **Waze** / **Maps**: navegar a esa casa.
   - **Voy en camino**: WhatsApp con la hora aproximada de llegada.
   - **Entregado** o **No se pudo** al terminar.
6. Los paquetes sin ubicación salen aparte, en un aviso amarillo.

Los km y tiempos son aproximados. Google Maps o Waze dan el tiempo real con tránsito.

### Prueba de entrega (al tocar **Entregado**)

Cada vez que marcás un paquete como **Entregado** se abre la pantalla **Prueba de entrega**:

1. La app toma sola la **fecha y hora** y tu **ubicación GPS** (con su precisión en metros).
2. Tocá **📷 Tomar foto** al menos **3 veces**. Sugerencia: el paquete en la puerta, la fachada y el paquete en manos de quien recibe.
3. Cada foto lleva un **sello** con fecha, hora, cliente, guía y coordenadas.
4. **Confirmar entrega** solo se activa con 3 fotos y la ubicación.

La evidencia se guarda **en el celular** y se **sube a Supabase** como respaldo. En la lista vas a ver *📷 3 fotos · fecha · 📍 ±m · ☁️ respaldada* (o *⏳ sin subir* si no había internet: se sube sola después). Tocá **Ver evidencia** para ver las fotos y el punto en el mapa.

**Activar la ubicación en tu iPhone (una sola vez):** *Ajustes > Privacidad y seguridad > Localización* (encendida) *> Sitios web de Safari > Al usar la app* y activá *Ubicación exacta*.

**Espacio:** cada entrega con 3 fotos ocupa ~0,4 MB. El plan gratis de Supabase (1 GB) alcanza para unas 2.500 entregas. Las fotos ya respaldadas se borran solas del celular a los 7 días (siguen en Supabase).

**Ver los respaldos en la PC:** en Supabase, **Storage > evidencias** (fotos por fecha) y **Table Editor > entregas** (fecha, hora, GPS y lista de fotos).

### Al terminar el día

**1 Paquetes** > **Vaciar lista** (tocá dos veces para confirmar). Antes, revisá que todas las evidencias digan **☁️ respaldada**: al vaciar la lista, la evidencia queda en Supabase.

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

| Problema | Qué hacer |
|---|---|
| No abre WhatsApp | Revisá que el teléfono tenga 8 dígitos. Si dice "Teléfono inválido", corregilo con **Editar**. |
| El mensaje sale desde otro número | WhatsApp usa la cuenta abierta en ese celular. |
| La ubicación no se detecta | Usá el link largo o las coordenadas, no el link corto. |
| El cliente no pudo usar "Estoy en mi casa" | El formulario le explica cómo dar permiso de ubicación. Si no puede, que toque **Prefiero mandarla por WhatsApp** y la mande desde el chat. |
| Sale "No se pudo revisar (código …)" o "No se pudo enviar (código …)" | Mandale una captura del mensaje con el código al técnico: indica la causa exacta. |
| "Confirmar entrega" no se activa | Faltan fotos (mínimo 3) o la ubicación. Si dice que la ubicación está bloqueada, activala en Ajustes (ver *Prueba de entrega*). |
| La evidencia dice "⏳ sin subir" | No había internet. Se sube sola cada minuto con la app abierta, o tocá **Revisar respuestas ahora**. |
| "No encontré hora ni ubicación" | Lo que copiaste no traía ninguna de las dos. Copiá el mensaje con la hora o el link de la ubicación. |
| No llegan las respuestas | Revisá el internet y tocá **Revisar respuestas ahora**. El cliente tiene que tocar **Enviar** en el formulario. |
| Desapareció mi lista | Abriste la app en otro navegador o desde Safari en vez del ícono. |
| El link da error 404 | Escribilo con mayúsculas: `RutafacilCR`. |
