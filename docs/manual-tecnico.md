# Manual técnico · RutaFácil CR

Cómo está montada la app, cómo se publica y cómo se mantiene.

## 1. Arquitectura

```
Celular del repartidor                 Celular del cliente
┌──────────────────────┐               ┌──────────────────┐
│ index.html (app)     │               │ entrega.html     │
│ datos: localStorage  │               │ (formulario)     │
└──────┬───────────────┘               └────────┬─────────┘
       │ leer_respuestas(tokens)                │ enviar_respuesta(token, ...)
       ▼                                        ▼
            ┌───────────────────────────────────────┐
            │ Supabase (Postgres + API REST)         │
            │ tabla respuestas + 2 funciones RPC     │
            └───────────────────────────────────────┘
Hosting de los archivos: GitHub Pages (repo victormenav/RutafacilCR, rama main)
Servicios externos sin cuenta: wa.me (WhatsApp), Google Maps, Waze
```

- No hay servidor propio. Todo el código corre en el navegador.
- La lista de paquetes vive en `localStorage` del navegador (clave `rutafacil-cr-v1`).
- En Supabase se guardan las respuestas del formulario y las **pruebas de entrega** (tabla `entregas` + fotos en Storage, carpeta `evidencias`).
- Las fotos de evidencia también quedan en el celular (IndexedDB `rutafacil-evidencias`).

## 2. Publicación (GitHub Pages)

- Repositorio: https://github.com/victormenav/RutafacilCR
- Pages: **Settings > Pages > Deploy from a branch > main / (root)**.
- URL pública: https://victormenav.github.io/RutafacilCR/ (**sensible a mayúsculas**).
- Cada push a `main` dispara el workflow automático *pages-build-deployment* (1 a 2 minutos). Se revisa en la pestaña **Actions**.
- Los celulares pueden tener la versión anterior en caché. Cerrar y volver a abrir la app la actualiza.

## 3. Supabase

| Dato | Valor |
|---|---|
| Organización | RutaFacilCR (plan Free) |
| Proyecto | RutaFacil |
| Región | West US (Oregon), us-west-2 |
| URL | `https://mdomcfdmqzgtmnvcfzrs.supabase.co` |
| Llave usada por la app | publishable (`sb_publishable_…`), en `config.js` |

### Instalación desde cero

1. Crear proyecto en https://supabase.com. Seguridad recomendada: Data API **activada**, "Automatically expose new tables" **desactivada**, RLS automático **activado**.
2. **SQL Editor** > pegar todo `supabase.sql` > **Run** → "Success. No rows returned". El script se puede volver a correr sin problema.
3. Copiar URL y llave publishable/anon en `config.js` y hacer push.

### Llaves

- **publishable / anon:** pública, va en `config.js`. No da acceso a la tabla, solo permite llamar las dos funciones.
- **secret / service_role** y **contraseña de la base:** nunca van en el repositorio ni se comparten. Las guarda el dueño del proyecto.
- Con llaves `sb_publishable_` la app manda solo el header `apikey`. Con llaves JWT antiguas (`eyJ…`) manda además `Authorization: Bearer`.

### Prueba de entrega (Storage)

- `supabase.sql` crea la tabla `entregas`, la función `registrar_entrega` y el bucket **privado** `evidencias` (solo JPEG, máx. 2 MB por foto).
- La app solo puede **subir** fotos (política `rutafacil subir evidencias`). Verlas o descargarlas se hace desde el panel: **Storage > evidencias**. Las fotos se guardan como `AAAA-MM-DD/<guia>_<id>_<n>.jpg`.
- Cada foto pesa ~150–300 KB (1280 px, JPEG 72 %). Con 1 GB de Storage gratis alcanza para unas 1.000 entregas con 3 fotos.

### Límites del plan gratis

500 MB de base de datos y pausa automática del proyecto tras ~1 semana sin uso. Si se pausa, el formulario deja de guardar: entrar al panel y tocar **Restore**. Cada respuesta ocupa menos de 1 KB.

### Consultas útiles (SQL Editor)

```sql
-- Últimas respuestas
select guia, horario, senas, recibe, lat, lng, updated_at
from respuestas order by updated_at desc limit 50;

-- Entregas con evidencia de un día
select guia, cliente, entregado_en, lat, lng, precision_m, fotos
from entregas where entregado_en::date = '2026-10-30' order by entregado_en;

-- Borrar respuestas de más de 30 días
delete from respuestas where updated_at < now() - interval '30 days';
```

## 4. Configuración (`config.js`)

```js
window.RF_CONFIG = {
  supabaseUrl: 'https://<proyecto>.supabase.co',
  supabaseAnonKey: '<llave publishable o anon>'
};
```

Si los dos valores están vacíos, la app funciona sin formulario: los mensajes no llevan link y no aparece el panel de respuestas.

## 5. Dependencias externas

| Recurso | Uso | Si falla |
|---|---|---|
| cdnjs `xlsx 0.18.5` | Leer Excel/CSV subido | Se puede pegar la lista. |
| Google Fonts | Tipografías | Usa fuentes del sistema. |
| `wa.me` | Abrir WhatsApp con texto | Botón **Copiar texto**. |
| Google Maps / Waze | Navegación | Se pueden copiar las coordenadas. |
| Geolocalización del navegador | Botón "Estoy en mi casa" del formulario | El cliente la manda por WhatsApp o pega un link. Requiere HTTPS (GitHub Pages ya lo da). En iPhone depende de *Ajustes > Privacidad y seguridad > Localización > Sitios web de Safari* y del permiso por sitio en Safari (*aA > Configuración del sitio web > Ubicación*), también dentro del navegador de WhatsApp. |

## 6. Mantenimiento

- **Versión visible:** el encabezado de la app muestra la versión (ej. `v29-oct-c`). Al publicar un cambio se actualiza ese texto en `index.html`, así se puede confirmar si un celular tiene la versión nueva.

- **Cambiar textos o mensajes por defecto:** `index.html`, constantes `DEF_COORD`, `DEF_COORD_F` y `DEF_CAMINO`.
- **Cambiar horarios del formulario:** `entrega.html`, arreglo `SLOTS`.
- **Links viejos** (`f.html?…`) redirigen a `entrega.html`. No borrar `f.html` mientras haya mensajes viejos circulando.
- **Respaldo:** el repositorio es el respaldo del código. La tabla `respuestas` es temporal (se puede limpiar).
- Cada cambio se anota en `CHANGELOG.md` y en el manual que corresponda.

## 7. Plan futuro (no implementado)

Login por teléfono, licencias por suscripción y un dispositivo por cuenta, en el **mismo** proyecto de Supabase (tablas propuestas: `perfiles`, `dispositivos`, `pagos`). La columna `respuestas.owner_id` ya existe para ligar respuestas a cada repartidor cuando haya login.
