<p align="center"><img src="icon-192.png" width="96" alt="Ícono de RutaFácil CR"></p>

# RutaFácil CR

Herramienta web para repartidores de paquetes en Costa Rica. Cargás la lista de entregas del día, le mandás a cada cliente un WhatsApp con el mensaje ya escrito, el cliente confirma su horario y ubicación en un formulario (que le recuerda presentar la cédula), y la app arma la ruta más corta.

**Usar la app:** https://rutafacilcr.github.io/ · **Cómo funciona (sin cuenta):** https://rutafacilcr.github.io/conoce.html · **Privacidad:** https://rutafacilcr.github.io/privacidad.html

## Qué hace

La app se maneja con cuatro pestañas en la barra de abajo: **Paquetes**, **Cierres**, **Mensajes** y **Ruta**. El botón **Soporte** está arriba, en el encabezado.

- **Paquetes:**
  - Cinco contadores: Recibidos, Entregados, Hold, Devueltos y Sin 📍.
  - Cuatro botones grandes: 🧹 Vaciar lista, Agregar a mano, Importar y Escanear.
  - Un buscador por nombre, teléfono, guía o número.
  - Las tarjetas van en orden: activos, Hold, devueltos y al final los entregados en gris.
  - Los paquetes ⛔ Devolver y ⛔ Devuelto quedan desactivados, con un solo botón para quitar la marca.
- **Ruta:**
  - Mapa con la línea por calles reales (OSRM, gratis).
  - Ordenar desde tu GPS o desde un punto del mapa.
  - ▶ Iniciar / ■ Finalizar entregas para el reporte. Desde ▶ Iniciar el orden de la ruta queda fijo (solo cambia si lo reordenás a mano).
  - Vehículo 🏍️ 🚙 🚐 (carro por defecto), que va en el WhatsApp "Estamos en camino 🏍️…".
  - 📋 Lista en orden. Las paradas entregadas quedan en gris (sin tachar) en el mapa y la lista.
  - 🚦 Tráfico en vivo para la próxima parada (TomTom, plan gratis con clave propia).
  - En cada parada: Hold, ⛔ Devolver y ✓ Entregado. ✓ Entregado guarda la fecha y la hora reales.
- **Cierres** (solo reportes que ya funcionan; sin avisos de "Próximamente"):
  - Un reporte PDF horizontal por cada grupo de *Entregas del …* (el día en que se recibieron los paquetes), también de listas ya vaciadas.
  - Trae fecha, mensajero, km y horas por tramos, promedio por entrega, y recibidos, entregados y devueltos.
  - Las filas van ordenadas por fecha y hora de entrega.
  - También hay un PDF **Guías** por cada fecha de recibido, con nombre, teléfono, guía, dirección y hora de entrega, agrupado por fecha de recibido.
- **Mensajes:**
  - Coordinar, Formulario, Voy en camino (con el ícono del vehículo), Comprensión y Horario extendido (5 a 9 p. m.).
  - Los clientes van en el mismo orden que en Ruta; los cerrados o en Hold quedan en gris al final.

| Paso | Qué resuelve |
|---|---|
| **1. Paquetes** | Escanea la etiqueta de cada paquete con la cámara (guía por código de barras; nombre (con tildes bien escritas), teléfono y dirección por lectura de texto, gratis y dentro del celular). También importa desde Excel, CSV o copiando y pegando, o se agrega a mano. Acepta links de Google Maps / Waze y saca las coordenadas solo. |
| **2. Mensajes** | Un botón por cliente abre WhatsApp con el mensaje de coordinación listo. El primer mensaje es corto, sin links y recuerda presentar la cédula: el cliente responde por el mismo chat. A quien ya contestó se le puede mandar aparte un formulario corto (en WhatsApp sale solo el link, sin tarjeta de vista previa), y el día de entrega el aviso de "voy en camino" (que recuerda presentar la cédula): en cada cliente se elige cuál de los mensajes mandar. Los mensajes van con tu nombre (sale de la cuenta y se puede cambiar). Con un toque guarda a todos los clientes del día en los contactos del celular como *TM-Nombre-pedido*, también baja un Excel del día (la misma plantilla, llena, con fecha de ingreso; en iPhone se guarda en *Archivos*), y hay un buscador por nombre, guía o teléfono. |
| **Nube** | La lista de paquetes y la ruta del día se guardan en la cuenta: las mismas en el teléfono y en la PC. |
| **3. Respuestas** | Con un toque (*📋 Pegar respuesta*) la app saca la hora y la ubicación de lo que el cliente respondió por WhatsApp y lo marca *Confirmado*. Lo que llena en el formulario entra solo. |
| **Cierres** | Reportes PDF por día de recibido, con horas, km y promedios; incluye los cierres guardados en la base al vaciar la lista. |
| **4. Ruta** (antes *Entrega*) | Carga el Excel *Ruta AAAA-MM-DD* y divide la pantalla: arriba el mapa con las paradas numeradas en orden, abajo la lista; cada parada abre Waze o Google Maps y la prueba de entrega (botón Evidencia) o la marca como entregada (botón Entregado, que la pone en gris). Muestra tu punto actual y, apenas te ubica, reordena sola las paradas que faltan desde donde estás (hasta que tocás ▶ Iniciar entregas: ahí el orden queda fijo), con el tiempo aproximado hasta cada cliente y el tiempo y los km de toda la ruta; tiene lupa para buscar un cliente. Marcar una parada como entregada también actualiza el paquete en la lista, y un paquete se puede marcar como devuelto al almacén o volver a escanear su etiqueta para corregirlo. |
| **5. Prueba de entrega** | Al marcar *Entregado* guarda ubicación GPS, fecha, hora, mínimo 3 fotos con sello y la **firma con el dedo** de quien recibe (si falta algo, la app dice qué; si el GPS falla, se puede confirmar sin él); se respalda en Supabase. En *Ruta*, el **recorrido del día** muestra las entregas numeradas en un mapa. |

Funciona desde el celular, se puede instalar como ícono en la pantalla de inicio y no necesita servidor propio.

## Cuentas

Desde la versión 1.7.0 cada repartidor entra con **su número de teléfono y un PIN de 6 números**. La cuenta queda atada a un solo celular: si alguien la abre en otro, el administrador tiene que aprobar el cambio. El administrador activa, renueva (pagos por SINPE Móvil) o suspende cuentas desde el **panel** (`admin.html`). Así la app no se puede pasar entre compañeros ni usar sin una cuenta al día.

Cuando alguien crea cuenta, al administrador le llega un **WhatsApp y un correo** (servicios gratis). Al activarla, el panel deja listo el mensaje de WhatsApp para avisarle al repartidor, y en la app del repartidor el botón gris *Esperando activación* se pone naranja (*Cuenta habilitada · Entrar*) en menos de un minuto.

## Varios mensajeros (1.74.0)

La app está preparada para unas **150 cuentas a la vez** en el plan gratis de Supabase (con las fotos de entrega guardadas en el celular):

- **Nada se mezcla entre cuentas.** Paquetes, rutas, cierres, respuestas de clientes y fotos quedan amarrados a la cuenta que los creó; la base no le entrega a una cuenta datos de otra. Si en un mismo celular entra otra cuenta, la app aparta los datos de la anterior y abre los de la nueva.
- **Gasta poco del plan gratis.** La revisión de cada minuto solo baja lo que cambió.
- **Fotos de entrega a la medida del plan gratis:** de fábrica quedan en el celular; el administrador puede subir *1 foto chica + firma* o las 3 fotos, y elegir cuántos días se guardan en la nube.
- **Cierres por 15 días** (se cambia en el Panel).
- **Código de recuperación** (enlace 🔑 al final de la app, con su propio aviso explicativo): cada mensajero puede poner un PIN nuevo o pasar su cuenta a otro celular sin esperar al administrador. Cinco intentos fallidos bloquean ese número 30 minutos. El Panel pide el PIN cada 12 horas.
- Listas grandes (cientos de paquetes) abren rápido también en celulares sencillos.
- **Voy en camino (1.78.0):** en Ruta, después de mandar el WhatsApp de una parada, al volver a la app sale «🚗 Abrir Waze» para esa misma parada.
- **Pestañas al instante (1.77.0):** Paquetes, Cierres, Mensajes y Ruta cambian apenas se tocan, aun con muchos paquetes.
- **Avisos propios (1.75.2):** ni la app ni el Panel usan los cuadros grises del navegador; toda pregunta o dato que se pide sale en un aviso de RutaFácil con botones a la derecha (el principal naranja).
- **Mejor contraste (1.76.2):** los paquetes devueltos se leen completos (sus botones siguen desactivados), y la pestaña seleccionada y «Vaciar lista» se leen bien en tema claro y oscuro, según la revisión de Lighthouse.
- **Uno o dos números SINPE (1.76.1):** el administrador puede poner dos números para recibir la mensualidad y el mensajero ve los dos.
- **Número alterno del administrador (1.76.0):** el administrador puede entrar a su misma cuenta con un segundo número de teléfono (y el mismo PIN), configurado en el Panel.
- El Panel muestra **cuánto se usa** del plan gratis (base y fotos) y cuánto ocupa cada cuenta.

## Cierre del día

**🧹 Vaciar lista** (en *Paquetes*) guarda en la base todos los paquetes, la ruta y la jornada con la fecha del cierre (tabla `rf_cierres`) y deja la app limpia para una ruta nueva. Esos cierres siguen saliendo en los reportes de *Cierres*.

## Soporte

Dentro de la app, el botón **Soporte** (ícono de audífonos) abre WhatsApp con soporte (+506 6270-0666) y seis videos cortos de cómo se usa (grabados con la versión 1.74: entrar, paquetes, mensajes, ruta, entregar y cierres). También trae **🧪 Ver diagnóstico de la ruta**, que muestra en pantalla cómo están unidas las paradas con sus paquetes para mandarlo a soporte (captura o Compartir).

## Documentación

- [Manual de usuario](docs/manual-usuario.md): cómo usar la app día a día.
- [Manual técnico](docs/manual-tecnico.md): publicación, Supabase, configuración y mantenimiento.
- [Manual de programador y diseño](docs/manual-programador.md): estructura del código, datos, seguridad y sistema visual.
- [Historial de cambios](CHANGELOG.md)

## Archivos principales

| Archivo | Para qué es |
|---|---|
| `index.html` | La app del repartidor (todo en un archivo). |
| `conoce.html` | Página pública: qué es la app, para quién, beneficios, capturas y videos con datos de ejemplo, preguntas frecuentes. No pide cuenta. |
| `privacidad.html` | Política de privacidad: datos que se guardan, para qué, dónde, cuánto tiempo, baja y recuperación de la cuenta. |
| `img/` | Capturas de la app con datos de ejemplo para `conoce.html`. |
| `entrega.html` | Formulario que llena el cliente (se manda en un segundo mensaje). |
| `f.html` | Redirige links viejos a `entrega.html`. |
| `auth.js` | Cuentas: pantalla de entrada (número + PIN), un teléfono por cuenta y estado de la mensualidad. |
| `admin.html` | Panel del administrador: cuentas, pagos, cambios de teléfono, ajustes y limpieza de fotos. |
| `videos.json`, `videos/` | Lista de videos de ayuda que muestra el botón Soporte. |
| `config.js` | Dirección y llave pública de Supabase. |
| `supabase.sql` | Crea en Supabase las cuentas, el formulario, las pruebas de entrega y sus reglas de acceso. |
| `plantilla-paquetes.xlsx` | Plantilla de Excel para la lista de paquetes. |
| `manifest.json`, `logo.svg`, `*.png` | Logo (pin con paquete) e íconos para instalar la app en el celular. |

## Diseño

Paleta *Grafito y naranja* con el logo **pin con paquete**. Desde la 1.79.0 cumple WCAG 2.2 AA (Lighthouse de accesibilidad 100): botones naranja más intensos para leerse al sol, botones de 44 px para usar con el dedo en la calle y estados de entrega con ícono, texto y color. Marca propia: la app no usa logos de Temu ni de otras empresas.

## Estado

Versión piloto en uso por el autor, con cuentas de usuario listas para venderla por suscripción. Hecha en HTML, CSS y JavaScript sin frameworks, publicada con GitHub Pages y Supabase (plan gratis).

© 2026. InfolinkCR todos los derechos reservados.
