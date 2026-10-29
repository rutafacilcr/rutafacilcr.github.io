# Historial de cambios

## 2026-10-29
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
