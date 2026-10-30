<p align="center"><img src="icon-192.png" width="96" alt="Ícono de RutaFácil CR"></p>

# RutaFácil CR

Herramienta web para repartidores de paquetes en Costa Rica. Cargás la lista de entregas del día, le mandás a cada cliente un WhatsApp con el mensaje ya escrito, el cliente confirma su horario y ubicación en un formulario, y la app arma la ruta más corta.

**Usar la app:** https://rutafacilcr.github.io/

## Qué hace

La app se maneja con tres pestañas en la barra de abajo (**Paquetes**, **Mensajes** y **Ruta**) más el botón **Soporte**.

| Paso | Qué resuelve |
|---|---|
| **1. Paquetes** | Escanea la etiqueta de cada paquete con la cámara (guía por código de barras; nombre, teléfono y dirección por lectura de texto, gratis y dentro del celular). También importa desde Excel, CSV o copiando y pegando, o se agrega a mano. Acepta links de Google Maps / Waze y saca las coordenadas solo. |
| **2. Mensajes** | Un botón por cliente abre WhatsApp con el mensaje de coordinación listo. El primer mensaje es corto y sin links: el cliente responde por el mismo chat. A quien ya contestó se le puede mandar aparte un formulario corto. |
| **3. Respuestas** | Con un toque (*📋 Pegar respuesta*) la app saca la hora y la ubicación de lo que el cliente respondió por WhatsApp y lo marca *Confirmado*. Lo que llena en el formulario entra solo. |
| **5. Prueba de entrega** | Al marcar *Entregado* guarda ubicación GPS, fecha, hora, mínimo 3 fotos con sello y la **firma con el dedo** de quien recibe; se respalda en Supabase. En *Ruta*, el **recorrido del día** muestra las entregas numeradas en un mapa. |
| **4. Ruta** | Ordena las paradas para recorrer la menor distancia respetando el horario que confirmó cada cliente, da la hora estimada de llegada a cada casa, abre la ruta en Google Maps y cada parada en Waze, y manda el aviso de "voy en camino". |

Funciona desde el celular, se puede instalar como ícono en la pantalla de inicio y no necesita servidor propio.

## Cuentas

Desde la versión 1.7.0 cada repartidor entra con **su número de teléfono y un PIN de 6 números**. La cuenta queda atada a un solo celular: si alguien la abre en otro, el administrador tiene que aprobar el cambio. El administrador activa, renueva (pagos por SINPE Móvil) o suspende cuentas desde el **panel** (`admin.html`). Así la app no se puede pasar entre compañeros ni usar sin una cuenta al día.

Cuando alguien crea cuenta, al administrador le llega un **WhatsApp y un correo** (servicios gratis). Al activarla, el panel deja listo el mensaje de WhatsApp para avisarle al repartidor, y en la app del repartidor el botón gris *Esperando activación* se pone naranja (*Cuenta habilitada · Entrar*) en menos de un minuto.

## Soporte

Dentro de la app, el botón **Soporte** (ícono de audífonos) abre WhatsApp con soporte (+506 6270-0666) y los videos de cómo se usa.

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
