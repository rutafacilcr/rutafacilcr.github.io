<p align="center"><img src="icon-192.png" width="96" alt="Ícono de RutaFácil CR"></p>

# RutaFácil CR

Herramienta web para repartidores de paquetes en Costa Rica. Cargás la lista de entregas del día, le mandás a cada cliente un WhatsApp con el mensaje ya escrito, el cliente confirma su horario y ubicación en un formulario (que le recuerda presentar la cédula), y la app arma la ruta más corta.

**Usar la app:** https://rutafacilcr.github.io/

## Qué hace

Al marcar un paquete como entregado en *Ruta*, su número queda tachado y baja al final de la lista; en *Paquetes* su tarjeta se ve en gris.

En *Ruta*, el botón WhatsApp de cada parada abre el chat con el aviso "Estamos en camino" y el tiempo estimado. También se puede quitar una parada repetida con **🗑️ Quitar**; el paquete sigue en *Paquetes*.

En *Ruta*, **📋 Lista** da la ruta en orden con el número de cada paquete para copiar o compartir. En *Paquetes* hay un buscador por nombre, teléfono, guía o número. En *Cierres*, **📄 Bajar reporte PDF** descarga un reporte horizontal de entregados y devueltos, con un encabezado de fecha, mensajero, recibidos, entregados, devueltos, km y horas. La lista de *Paquetes* va ordenada: activos, Hold, devueltos y al final los entregados en gris. Un paquete marcado **⛔ Devolver** en *Ruta* muestra esa etiqueta en *Paquetes*; al tocarla se confirma como devuelto (o se quita la marca).

La app se maneja con cuatro pestañas en la barra de abajo (**Paquetes**, **Mensajes**, **Ruta** y **Cierres**) y el botón **Soporte** arriba, en el encabezado.

| Paso | Qué resuelve |
|---|---|
| **1. Paquetes** | Escanea la etiqueta de cada paquete con la cámara (guía por código de barras; nombre (con tildes bien escritas), teléfono y dirección por lectura de texto, gratis y dentro del celular). También importa desde Excel, CSV o copiando y pegando, o se agrega a mano. Acepta links de Google Maps / Waze y saca las coordenadas solo. |
| **2. Mensajes** | Un botón por cliente abre WhatsApp con el mensaje de coordinación listo. El primer mensaje es corto, sin links y recuerda presentar la cédula: el cliente responde por el mismo chat. A quien ya contestó se le puede mandar aparte un formulario corto (en WhatsApp sale solo el link, sin tarjeta de vista previa), y el día de entrega el aviso de "voy en camino" (que recuerda presentar la cédula): en cada cliente se elige cuál de los mensajes mandar. Los mensajes van con tu nombre (sale de la cuenta y se puede cambiar). Con un toque guarda a todos los clientes del día en los contactos del celular como *TM-Nombre-pedido*, también baja un Excel del día (la misma plantilla, llena, con fecha de ingreso; en iPhone se guarda en *Archivos*), y hay un buscador por nombre, guía o teléfono. |
| **Nube** | La lista de paquetes y la ruta del día se guardan en la cuenta: las mismas en el teléfono y en la PC. |
| **3. Respuestas** | Con un toque (*📋 Pegar respuesta*) la app saca la hora y la ubicación de lo que el cliente respondió por WhatsApp y lo marca *Confirmado*. Lo que llena en el formulario entra solo. |
| **4. Ruta** (antes *Entrega*) | Carga el Excel *Ruta AAAA-MM-DD* y divide la pantalla: arriba el mapa con las paradas numeradas en orden, abajo la lista; cada parada abre Waze o Google Maps y la prueba de entrega (botón Evidencia) o la marca como entregada (botón Entregado, que la pone en gris). Muestra tu punto actual y, apenas te ubica, reordena sola las paradas que faltan desde donde estás, con el tiempo aproximado hasta cada cliente y el tiempo y los km de toda la ruta; tiene lupa para buscar un cliente. Marcar una parada como entregada también actualiza el paquete en la lista, y un paquete se puede marcar como devuelto al almacén o volver a escanear su etiqueta para corregirlo. |
| **5. Prueba de entrega** | Al marcar *Entregado* guarda ubicación GPS, fecha, hora, mínimo 3 fotos con sello y la **firma con el dedo** de quien recibe (si falta algo, la app dice qué; si el GPS falla, se puede confirmar sin él); se respalda en Supabase. En *Ruta*, el **recorrido del día** muestra las entregas numeradas en un mapa. |

Funciona desde el celular, se puede instalar como ícono en la pantalla de inicio y no necesita servidor propio.

## Cuentas

Desde la versión 1.7.0 cada repartidor entra con **su número de teléfono y un PIN de 6 números**. La cuenta queda atada a un solo celular: si alguien la abre en otro, el administrador tiene que aprobar el cambio. El administrador activa, renueva (pagos por SINPE Móvil) o suspende cuentas desde el **panel** (`admin.html`). Así la app no se puede pasar entre compañeros ni usar sin una cuenta al día.

Cuando alguien crea cuenta, al administrador le llega un **WhatsApp y un correo** (servicios gratis). Al activarla, el panel deja listo el mensaje de WhatsApp para avisarle al repartidor, y en la app del repartidor el botón gris *Esperando activación* se pone naranja (*Cuenta habilitada · Entrar*) en menos de un minuto.

## Cierre del día

**Vaciar lista** guarda en la base todos los paquetes y la ruta con la fecha del cierre (tabla `rf_cierres`) y deja la app lista para una ruta nueva.

## Soporte

Dentro de la app, el botón **Soporte** (ícono de audífonos) abre WhatsApp con soporte (+506 6270-0666) y los videos de cómo se usa. También trae **🧪 Ver diagnóstico de la ruta**, que muestra en pantalla cómo están unidas las paradas con sus paquetes para mandarlo a soporte (captura o Compartir).

## Documentación

- [Manual de usuario](docs/manual-usuario.md): cómo usar la app día a día.
- [Manual técnico](docs/manual-tecnico.md): publicación, Supabase, configuración y mantenimiento.
- [Manual de programador y diseño](docs/manual-programador.md): estructura del código, datos, seguridad y sistema visual.
- [Historial de cambios](CHANGELOG.md)

## Archivos principales

| Archivo | Para qué es |
|---|---|
| `index.html` | La app del repartidor (todo en un archivo). |
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

Paleta *Grafito y naranja* con el logo **pin con paquete**. Marca propia: la app no usa logos de Temu ni de otras empresas.

## Estado

Versión piloto en uso por el autor, con cuentas de usuario listas para venderla por suscripción. Hecha en HTML, CSS y JavaScript sin frameworks, publicada con GitHub Pages y Supabase (plan gratis).

© 2026. InfolinkCR todos los derechos reservados.
