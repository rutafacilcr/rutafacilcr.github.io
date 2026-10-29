<p align="center"><img src="icon-192.png" width="96" alt="Ícono de RutaFácil CR"></p>

# RutaFácil CR

Herramienta web para repartidores de paquetes en Costa Rica. Cargás la lista de entregas del día, le mandás a cada cliente un WhatsApp con el mensaje ya escrito, el cliente confirma su horario y ubicación en un formulario, y la app arma la ruta más corta.

**Usar la app:** https://victormenav.github.io/RutafacilCR/

## Qué hace

| Paso | Qué resuelve |
|---|---|
| **1. Paquetes** | Importa la lista desde Excel, CSV o copiando y pegando. También se puede agregar a mano. Acepta links de Google Maps / Waze y saca las coordenadas solo. |
| **2. Mensajes** | Un botón por cliente abre WhatsApp con el mensaje de coordinación listo. El primer mensaje es corto y sin links: el cliente responde por el mismo chat. A quien ya contestó se le puede mandar aparte un formulario corto. |
| **3. Respuestas** | Lo que el cliente llena en el formulario entra solo a la app y lo marca *Confirmado*; la ubicación que manda por WhatsApp se pega en la app. |
| **4. Ruta** | Ordena las paradas para recorrer la menor distancia, abre la ruta en Google Maps y cada parada en Waze, y manda el aviso de "voy en camino". |

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
