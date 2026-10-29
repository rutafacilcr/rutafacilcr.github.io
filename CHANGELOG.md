# Historial de cambios

## 2026-10-29
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
