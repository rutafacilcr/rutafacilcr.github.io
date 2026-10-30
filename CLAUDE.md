# Reglas del proyecto RutaFácil CR

- Todo en español de Costa Rica (voseo en la app del repartidor, usted en el formulario del cliente).
- **Cada cambio se documenta en el mismo commit**, pensando en cuatro públicos:
  1. Quien visita el repositorio → `README.md`
  2. Usuario → `docs/manual-usuario.md`
  3. Técnico (hosting, Supabase, configuración) → `docs/manual-tecnico.md`
  4. Programador y diseño → `docs/manual-programador.md`
  Además, una línea en `CHANGELOG.md`.
- Sin build ni frameworks: HTML/CSS/JS plano. Se publica con push a `main` (GitHub Pages).
- La URL pública: https://rutafacilcr.github.io/
- Nunca poner en el repositorio la llave secret/service_role ni la contraseña de la base de Supabase.
- Cuentas: `auth.js` se carga en toda página del repartidor o del administrador; las reglas de acceso viven en `supabase.sql` (funciones `rf_*`). Cualquier función nueva que lea o escriba datos del repartidor debe llamar `rf_exigir_licencia()`.
