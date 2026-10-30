# Historial de cambios

Versiones con formato **mayor.menor.corrección** (desde la 1.6.2). Antes se usaban etiquetas por fecha; equivalencias:

| Versión | Etiqueta vieja | Qué trajo |
|---|---|---|
| 1.0.0 | v29-oct-a … f | App base: paquetes, mensajes, ruta, formulario, mensaje corto sin link |
| 1.1.0 | v29-oct-g | Formulario como segundo mensaje |
| 1.2.0 | v29-oct-h | Prueba de entrega (GPS, fotos, Supabase) |
| 1.3.0 | v29-oct-i | Pegar respuesta |
| 1.3.1 | v29-oct-j | Fotos más livianas y limpieza local |
| 1.4.0 | v29-oct-k | Escanear etiquetas |
| 1.5.0 | v29-oct-l | Ruta con horarios |
| 1.6.0 | v30-oct-a | Dirección nueva, paleta grafito y naranja, logo |
| 1.6.1 | v30-oct-b | Pestañas abajo |
| 1.7.0 | — | Cuentas con número + PIN, un teléfono por cuenta y panel del administrador |
| 1.7.1 | — | Mensajes más claros al entrar |
| 1.8.0 | — | Botón de Soporte con WhatsApp y videos de ayuda |
| 1.8.1 | — | Soporte por WhatsApp en la pantalla de entrar |
| 1.8.3 | — | Ícono de audífonos (call center) en Soporte |
| 1.10.0 | — | Avisos de cuentas nuevas por WhatsApp y correo; aviso de activación al repartidor |
| 1.12.0 | — | Botón *Esperando activación* que se habilita al activar la cuenta |
| 1.12.1 | — | *Crear cuenta* con los campos en blanco |
| 1.12.2 | — | *Crear cuenta* subrayado en la pantalla de entrar |

## 2026-10-30
- **1.12.2:** en la pantalla de entrar, *¿No tenés cuenta? **Crear cuenta*** se ve como enlace subrayado, igual que *Escribinos por WhatsApp*. Los demás enlaces de esa pantalla también van subrayados.
- **1.12.1:** en *Crear cuenta* los campos salen en blanco (sin el ejemplo "Victor Mena" / "8888 1234", que parecía ya escrito) y sin autocompletar; los textos de ejemplo de *Entrar* se ven más claros.
- **1.12.0 · Espera de activación:** en la pantalla de cuenta pendiente, vencida o con teléfono por aprobar, el botón *Revisar de nuevo* pasa a ser gris y deshabilitado (*⏳ Esperando activación*). La app revisa sola cada minuto y, cuando el administrador activa la cuenta, muestra *✅ Cuenta habilitada* con el botón naranja **Entrar**.
- **1.11.1:** el botón *Cerrar* de Soporte pasa arriba, junto al título, compacto y con el mismo estilo que *Guardar ajustes*.
- **1.11.0:** aviso *Hay una versión nueva · Actualizar* cuando se publica un cambio y el celular sigue con la versión vieja en caché.
- **1.10.4:** el botón *Cerrar* de Soporte queda pequeño y centrado (tamaño de *Guardar ajustes*), siempre visible abajo.
- **1.10.3:** el botón *Cerrar* de Soporte pasa a naranja con texto blanco en negrita, igual que *Guardar ajustes* del panel.
- **1.10.2:** el botón *Cerrar* de Soporte queda fijo abajo, siempre a la vista aunque haya muchos videos.
- **1.10.1:** el botón *Cerrar* de Soporte ahora es un botón grafito de ancho completo, bien visible.
- **Videos de ayuda:** seis videos cortos (menos de 1 min c/u, verticales, con voz y subtítulos) en `videos/` y listados en `videos.json`, para *Soporte > Videos*: entrar, cargar paquetes, mensajes, pegar respuesta, ruta y prueba de entrega.
- **1.10.0 · Avisos de cuentas:** cuando alguien crea cuenta o pide usar otro teléfono, al administrador le llega un WhatsApp (CallMeBot) y un correo (Resend), los dos gratis, configurables en *Panel > Ajustes*. Al activar, renovar o reactivar, el panel ofrece *Avisarle por WhatsApp* con el mensaje listo. La pantalla de espera del repartidor revisa cada minuto y la app se abre sola al activarse. Hay que volver a correr `supabase.sql`.
- **1.9.0:** *Soporte* pasa a la barra de abajo, a la par de *Ruta*, con el ícono de audífonos; sale del encabezado.
- **1.8.3:** el botón de Soporte y los enlaces de ayuda de la pantalla de entrar llevan un ícono de audífonos con micrófono (estilo call center) en vez de ❓.
- **1.8.2:** arreglo de diseño: en *Paquetes*, la línea de evidencia (📷 fotos · Ver evidencia) ya no aprieta la tarjeta del paquete.
- **1.8.1:** la pantalla de entrar, crear cuenta y los avisos de cuenta llevan el enlace *¿Necesitás ayuda? Escribinos por WhatsApp* al soporte (6270 0666, se puede cambiar con `soporte` en `config.js`). Los botones de contacto de cuenta vencida, suspendida o teléfono pendiente también van a ese número.
- **1.8.0 · Soporte:** botón *❓ Soporte* arriba (y en el pie) con WhatsApp directo al 6270-0666 y los videos de cómo se usa la app (lista en `videos.json`).
- **1.7.1:** al entrar, si el número no tiene cuenta la app sugiere *Crear cuenta*, y si la cuenta no está confirmada dice que falta apagar *Confirm email* en Supabase (antes decía solo "Número o PIN incorrecto").
- **1.7.0 · Cuentas (Fase 1a):** la app pide entrar con número de teléfono y PIN de 6 números (`auth.js`). Cada cuenta funciona en un solo celular: otro teléfono queda esperando aprobación y, al aprobarlo, el anterior se cierra. Pantallas de cuenta sin activar, vencida, suspendida y teléfono pendiente, con los datos para pagar por SINPE Móvil. El nombre de la cuenta firma los mensajes. Sin internet abre hasta 3 días con la última revisión. Nuevo **panel del administrador** (`admin.html`): cuentas, pagos, prueba de 14 días, suspender, aprobar teléfonos, PIN nuevo, ajustes y borrado de fotos viejas para no pasarse del plan gratis. En Supabase (`supabase.sql`): tablas `rf_ajustes`, `rf_perfiles`, `rf_pagos`, `rf_eventos`; con **Exigir cuenta activa**, `leer_respuestas`, `registrar_entrega` y la subida de fotos solo responden a una cuenta al día desde su teléfono aprobado. Requiere correr de nuevo `supabase.sql` y apagar *Confirm email* en Supabase (ver manual técnico).
- **1.6.2:** la versión sale del encabezado y pasa al final de la app con numeración profesional (mayor.menor.corrección).
- **Pestañas abajo (v30-oct-b):** *Paquetes*, *Mensajes* y *Ruta* pasan a una barra fija abajo, con ícono y sin números, como una app. Un globito naranja muestra cuántos paquetes hay.
- **Nuevo diseño (v30-oct-a):** paleta *Grafito y naranja* y títulos sin mayúsculas en la app y el formulario. Nuevo logo: pin con paquete en grafito y naranja; íconos de app 192, 512, maskable y iPhone, y logo en el encabezado.
- **Nueva dirección:** la app se mudó a la organización de GitHub *rutafacilcr* y ahora vive en https://rutafacilcr.github.io/ (sin el nombre del dueño en el link). El link viejo deja de funcionar y la lista del celular arranca vacía en la dirección nueva.

## 2026-10-29
- **Ruta con horarios (v29-oct-l):** la ruta respeta el horario que confirmó cada cliente (8 a 10 am, 2 a 4 pm, en la tarde, después de las 3…). Nueva *Hora de salida*, hora estimada de llegada por parada, aviso ⚠ si alguna quedaría fuera de horario y botón *Usar mi ubicación actual* para recalcular a media ruta. Optimización con 2-opt y reubicación de tramos, probada con 70 paradas.
- **Escanear etiquetas (v29-oct-k):** en *Paquetes*, foto a la etiqueta (o varias fotos de la galería): la guía sale del código de barras y nombre, teléfono y dirección se leen con OCR gratis dentro del celular (Tesseract.js). Se revisa y se guarda en serie; avisa si la guía ya está en la lista. La foto se endereza sola y no se guarda.
- **Ahorro de espacio (v29-oct-j):** fotos de evidencia a 1024 px (~100–150 KB). Las fotos ya respaldadas se borran del celular a los 7 días. Consulta SQL para ver el espacio usado.
- **📋 Pegar respuesta (v29-oct-i):** un botón por cliente lee lo copiado de WhatsApp, saca hora y ubicación (incluso pines de lugar, buscándolos en OpenStreetMap) y lo marca Confirmado, sin abrir Editar.
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
