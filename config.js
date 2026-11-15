// Datos públicos del proyecto de Supabase (Project Settings > API).
// La llave publishable/anon es pública por diseño: la seguridad la dan las funciones de supabase.sql.
window.RF_CONFIG = {
  supabaseUrl: 'https://mdomcfdmqzgtmnvcfzrs.supabase.co',
  supabaseAnonKey: 'sb_publishable_7HjkIAd0_j9cGCp2CWgExA_7NQKPNkg',
  // 1.112.0: WhatsApp oficial (API de Meta). Ponerlo en true cuando la Edge Function `whatsapp` esté lista (ver manual técnico).
  whatsappApi: false
};
