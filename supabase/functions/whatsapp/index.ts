// RutaFácil CR · WhatsApp oficial (API de Meta) · 1.112.0
// Edge Function de Supabase. Hace dos trabajos:
//  1. POST desde la app (con la sesión del repartidor): manda la plantilla "Pedir ubicación"
//     a los paquetes que llegan y registra cada envío con rf_wa_registrar.
//  2. Webhook de Meta: GET para verificar y POST con estados (entregado/leído/falló) y con lo
//     que el cliente contesta (ubicación o texto). Lo guarda con rf_wa_entrante.
// Se despliega con "Verify JWT" APAGADO (Meta no manda sesión); la función revisa la sesión ella misma.
//
// Secretos (Supabase > Edge Functions > Secrets). NUNCA van en el repositorio:
//   WA_TOKEN      token permanente de Meta (usuario del sistema)
//   WA_PHONE_ID   "Phone number ID" del número oficial
//   WA_APP_SECRET "App secret" de la app de Meta (para revisar la firma del webhook)
//   WA_VERIFY     palabra cualquiera; la misma se pone en Meta al configurar el webhook
//   WA_PLANTILLA  (opcional) nombre de la plantilla; de fábrica pedir_ubicacion
//   WA_IDIOMA     (opcional) idioma de la plantilla; de fábrica es
//   WA_CONTACTO   (opcional) número para hablar con el mensajero, p. ej. 6270-0666. Si está, al cliente que
//                 escribe texto se le contesta una vez cada 12 h: "Gracias… escríbanos al WhatsApp 6270-0666".
// SUPABASE_URL, SUPABASE_ANON_KEY y SUPABASE_SERVICE_ROLE_KEY los pone Supabase solo.

const env = (k: string, d = "") => Deno.env.get(k) ?? d;
const SB = env("SUPABASE_URL").replace(/\/$/, "");
const GRAPH = `https://graph.facebook.com/${env("WA_GRAPH_VERSION", "v23.0")}`;
const MAX_TANDA = 100;

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, apikey, content-type, x-client-info",
  "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
};
const json = (b: unknown, s = 200) =>
  new Response(JSON.stringify(b), { status: s, headers: { ...CORS, "Content-Type": "application/json" } });

async function rpc(fn: string, args: unknown, headers: Record<string, string>) {
  const r = await fetch(`${SB}/rest/v1/rpc/${fn}`, {
    method: "POST",
    headers: { ...headers, "Content-Type": "application/json" },
    body: JSON.stringify(args),
  });
  const t = await r.text();
  let j: any = null;
  try { j = t ? JSON.parse(t) : null; } catch { /* texto */ }
  if (!r.ok) throw new Error(String((j && (j.message || j.msg)) || t || r.status).replace(/^RF_\w+:\s*/, "").slice(0, 200));
  return j;
}
const servicio = () => {
  const k = env("SUPABASE_SERVICE_ROLE_KEY");
  return { apikey: k, Authorization: `Bearer ${k}` };
};

// Meta no acepta saltos de línea, tabs ni más de 4 espacios seguidos en un parámetro, ni parámetros vacíos.
const param = (s: unknown) => {
  const t = String(s ?? "").replace(/[\n\r\t]+/g, " ").replace(/ {4,}/g, "   ").trim().slice(0, 60);
  return { type: "text", text: t || "-" };
};

async function graph(path: string, body: unknown) {
  const r = await fetch(`${GRAPH}/${path}`, {
    method: "POST",
    headers: { Authorization: `Bearer ${env("WA_TOKEN")}`, "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
  const j: any = await r.json().catch(() => ({}));
  if (!r.ok) throw new Error((j.error && (j.error.error_user_msg || j.error.message)) || `Meta ${r.status}`);
  return j;
}

// ---------- 1. Envío desde la app ----------
async function enviar(req: Request) {
  const auth = req.headers.get("authorization") || "";
  const apikey = req.headers.get("apikey") || env("SUPABASE_ANON_KEY");
  if (!auth.startsWith("Bearer ")) return json({ error: "Entrá con tu cuenta" }, 401);
  if (!env("WA_TOKEN") || !env("WA_PHONE_ID")) return json({ error: "Falta configurar el WhatsApp oficial (WA_TOKEN / WA_PHONE_ID)" }, 503);
  const user = { apikey, Authorization: auth };

  // Licencia al día + cuenta habilitada (rf_wa_puede llama rf_exigir_licencia)
  try {
    if (!(await rpc("rf_wa_puede", {}, user))) return json({ error: "Esta cuenta no tiene WhatsApp oficial" }, 403);
  } catch (e) {
    return json({ error: (e as Error).message }, 403);
  }

  const body: any = await req.json().catch(() => ({}));
  if (body.accion === "probar") return json({ ok: true });
  const lista = Array.isArray(body.paquetes) ? body.paquetes.slice(0, MAX_TANDA) : [];
  if (!lista.length) return json({ error: "No llegaron paquetes" }, 400);

  const plantilla = env("WA_PLANTILLA", "pedir_ubicacion"), idioma = env("WA_IDIOMA", "es");
  const res: any[] = [];
  // de 5 en 5 para no pasar el límite de Meta
  for (let i = 0; i < lista.length; i += 5) {
    await Promise.all(lista.slice(i, i + 5).map(async (p: any) => {
      const tel = String(p.tel || "").replace(/\D/g, "");
      const fila: any = { paquete_id: String(p.id || ""), tel, wamid: "", error: "" };
      try {
        if (!/^\d{10,15}$/.test(tel)) throw new Error("Teléfono inválido");
        const j = await graph(`${env("WA_PHONE_ID")}/messages`, {
          messaging_product: "whatsapp",
          to: tel,
          type: "template",
          template: {
            name: plantilla,
            language: { code: idioma },
            components: [{ type: "body", parameters: [param(p.nombre), param(p.guia), param(body.fecha)] }],
          },
        });
        fila.wamid = j.messages?.[0]?.id || "";
        if (!fila.wamid) fila.error = "Meta no devolvió id";
      } catch (e) {
        fila.error = (e as Error).message;
      }
      res.push(fila);
    }));
  }
  try {
    await rpc("rf_wa_registrar", { p_filas: res }, user);
  } catch (e) {
    return json({ resultados: res, aviso: "Se mandaron pero no se pudieron guardar: " + (e as Error).message });
  }
  return json({ resultados: res });
}

// ---------- 2. Webhook de Meta ----------
async function firmaOk(req: Request, raw: string) {
  const secreto = env("WA_APP_SECRET");
  const firma = req.headers.get("x-hub-signature-256") || "";
  if (!secreto || !firma.startsWith("sha256=")) return false;
  const key = await crypto.subtle.importKey("raw", new TextEncoder().encode(secreto), { name: "HMAC", hash: "SHA-256" }, false, ["sign"]);
  const sig = new Uint8Array(await crypto.subtle.sign("HMAC", key, new TextEncoder().encode(raw)));
  const hex = [...sig].map((b) => b.toString(16).padStart(2, "0")).join("");
  const otra = firma.slice(7);
  if (otra.length !== hex.length) return false;
  let d = 0;
  for (let i = 0; i < hex.length; i++) d |= hex.charCodeAt(i) ^ otra.charCodeAt(i);
  return d === 0;
}

async function webhook(req: Request) {
  const raw = await req.text();
  if (!(await firmaOk(req, raw))) return new Response("firma inválida", { status: 401 });
  const b: any = JSON.parse(raw || "{}");
  const S = servicio();
  const base = { p_tipo: "", p_wamid: null, p_tel: null, p_estado: null, p_texto: null, p_lat: null, p_lng: null, p_error: null };
  for (const entry of b.entry || []) for (const ch of entry.changes || []) {
    const v = ch.value || {};
    for (const s of v.statuses || []) {
      const err = s.errors?.[0];
      await rpc("rf_wa_entrante", { ...base, p_tipo: "estado", p_wamid: s.id, p_estado: s.status, p_error: err ? `${err.code} ${err.title || err.message || ""}`.trim() : null }, S).catch(() => {});
    }
    for (const m of v.messages || []) {
      let texto: string | null = null, lat: number | null = null, lng: number | null = null;
      if (m.type === "location" && m.location) { lat = +m.location.latitude; lng = +m.location.longitude; }
      else if (m.type === "text") texto = m.text?.body ?? null;
      else if (m.type === "button") texto = m.button?.text ?? null;
      else if (m.type === "interactive") texto = m.interactive?.button_reply?.title ?? m.interactive?.list_reply?.title ?? null;
      else texto = `[${m.type}]`;
      const responder = await rpc("rf_wa_entrante", { ...base, p_tipo: "mensaje", p_tel: m.from, p_texto: texto, p_lat: lat, p_lng: lng }, S).catch(() => false);
      const contacto = env("WA_CONTACTO");
      if (lat != null) {
        await graph(`${env("WA_PHONE_ID")}/messages`, { messaging_product: "whatsapp", to: m.from, type: "text",
          text: { body: "¡Gracias! Recibimos su ubicación ✅. Lo asignaremos a la ruta y le avisamos." } }).catch(() => {});
      } else if (responder && contacto) {
        await graph(`${env("WA_PHONE_ID")}/messages`, { messaging_product: "whatsapp", to: m.from, type: "text",
          text: { body: `¡Gracias por responder! Si nos puede compartir su ubicación por aquí, la agregamos a la ruta 📍. Para cualquier consulta escríbanos al WhatsApp ${contacto}.` } }).catch(() => {});
      }
    }
  }
  return new Response("ok");
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  const url = new URL(req.url);
  if (req.method === "GET") {
    // Meta verifica el webhook una vez
    if (url.searchParams.get("hub.mode") === "subscribe" && url.searchParams.get("hub.verify_token") === env("WA_VERIFY") && env("WA_VERIFY"))
      return new Response(url.searchParams.get("hub.challenge") || "");
    return new Response("RutaFácil WhatsApp", { status: 200 });
  }
  if (req.method !== "POST") return new Response("método no permitido", { status: 405 });
  if (req.headers.get("x-hub-signature-256")) return webhook(req);
  try { return await enviar(req); } catch (e) { return json({ error: (e as Error).message }, 500); }
});
