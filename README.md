<p align="center"><img src="icon-192.png" width="96" alt="Ícono de RutaFácil CR"></p>

# RutaFácil CR

Herramienta web para repartidores de paquetes en Costa Rica. Cargás la lista de entregas del día, le mandás a cada cliente un WhatsApp con el mensaje ya escrito, el cliente confirma su horario y ubicación en un formulario, y la app arma la ruta más corta.

**Usar la app:** https://rutafacilcr.github.io/

## Qué hace

| Paso | Qué resuelve |
|---|---|
| **1. Paquetes** | Escanea la etiqueta de cada paquete con la cámara (guía por código de barras; nombre, teléfono y dirección por lectura de texto, gratis y dentro del celular). También importa desde Excel, CSV o copiando y pegando, o se agrega a mano. Acepta links de Google Maps / Waze y saca las coordenadas solo. |
| **2. Mensajes** | Un botón por cliente abre WhatsApp con el mensaje de coordinación listo. El primer mensaje es corto y sin links: el cliente responde por el mismo chat. A quien ya contestó se le puede mandar aparte un formulario corto. |
| **3. Respuestas** | Con un toque (*📋 Pegar respuesta*) la app saca la hora y la ubicación de lo que el cliente respondió por WhatsApp y lo marca *Confirmado*. Lo que llena en el formulario entra solo. |
| **5. Prueba de entrega** | Al marcar *Entregado* guarda ubicación GPS, fecha, hora y mínimo 3 fotos con sello; se respalda en Supabase. |
| **4. Ruta** | Ordena las paradas para recorrer la menor distancia respetando el horario que confirmó cada cliente, da la hora estimada de llegada a cada casa, abre la ruta en Google Maps y cada parada en Waze, y manda el aviso de "voy en camino". |

Funciona desde el celular, se puede instalar como ícono en la pantalla de inicio y no necesita servidor propio.

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
| `config.js` | Dirección y llave pública de Supabase. |
| `supabase.sql` | Crea la tabla y las funciones del formulario en Supabase. |
| `plantilla-paquetes.xlsx` | Plantilla de Excel para la lista de paquetes. |
| `manifest.json`, `*.png` | Ícono y datos para instalar la app en el celular. |

## Estado

Versión piloto en uso por el autor. Hecha en HTML, CSS y JavaScript sin frameworks, publicada con GitHub Pages y Supabase (plan gratis).
