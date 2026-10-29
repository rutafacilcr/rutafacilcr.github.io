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
3. El mensaje lleva un **link al formulario** donde el cliente marca:
   - Horario en que puede recibir.
   - Su ubicación (botón **Usar mi ubicación actual** o pegando un link).
   - Señas de la casa y quién recibe.
4. Las respuestas **entran solas** (la app revisa cada minuto, o tocá **Revisar respuestas ahora**). El cliente queda **Confirmado** con 🕓 horario y 🏠 señas.
5. Si alguien contesta por WhatsApp en vez del formulario, marcá a mano **Confirmó** o **No responde**.

Variables que podés usar en los mensajes: `{nombre}` `{guia}` `{direccion}` `{fecha}` `{yo}` `{eta}` `{formulario}`. Si cambiás el mensaje, dejá `{formulario}` para que siga yendo el link.

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

### Al terminar el día

**1 Paquetes** > **Vaciar lista** (tocá dos veces para confirmar).

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
| No llegan las respuestas | Revisá el internet y tocá **Revisar respuestas ahora**. El cliente tiene que tocar **Enviar** en el formulario. |
| Desapareció mi lista | Abriste la app en otro navegador o desde Safari en vez del ícono. |
| El link da error 404 | Escribilo con mayúsculas: `RutafacilCR`. |
