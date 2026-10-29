# RutaFácil CR

App para coordinar entregas de paquetes: cargás la lista del día, mandás el mensaje de WhatsApp a cada cliente y te arma la ruta más corta.

**Abrir la app:** https://victormenav.github.io/RutafacilCR/

## Archivos

- `index.html`: la app completa. No necesita servidor ni base de datos.
- `plantilla-paquetes.xlsx`: plantilla de Excel para la lista de paquetes (columnas `nombre, telefono, direccion, ubicacion, guia, nota`).

## Uso rápido

1. **Paquetes:** subí la plantilla llena o pegá las filas copiadas de Excel / Google Sheets.
2. **Mensajes:** tocá *Abrir WhatsApp* en cada cliente y enviá. Marcá *Confirmó* o *No responde*.
3. **Ruta:** poné el punto de salida y tocá *Calcular mejor ruta*. Abrí la ruta en Google Maps o cada parada en Waze.

Los datos se guardan en el navegador del celular donde usás la app.

## Formulario para clientes (opcional)

Cada mensaje de WhatsApp puede llevar un link (`f.html`) donde el cliente marca su horario, sus señas y su ubicación. Las respuestas entran solas a la app.

Configuración (una sola vez):
1. Crear un proyecto gratis en https://supabase.com.
2. En **SQL Editor**, pegar y ejecutar todo `supabase.sql`.
3. En **Project Settings > API**, copiar la **Project URL** y la **anon public key** dentro de `config.js`.

Mientras `config.js` esté vacío, la app funciona igual que antes, sin formulario.
