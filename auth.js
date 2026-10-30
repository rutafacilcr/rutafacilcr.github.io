// RutaFácil CR · cuentas (Fase 1a): entrada con número + PIN y un teléfono por cuenta.
// Se carga después de config.js. Si config.js no tiene Supabase, no hace nada y la app abre normal.
// Expone window.RF_AUTH: { on, listo (promesa con la cuenta), cuenta, headers(), rpc(), revisar(), salir() }.
// Página de administración: definir window.RF_AUTH_ADMIN = true antes de cargar este archivo.
(function(){
const C=window.RF_CONFIG||{};
const ON=!!(C.supabaseUrl&&C.supabaseAnonKey);
const BASE=ON?C.supabaseUrl.replace(/\/$/,''):'';
const ADMIN=!!window.RF_AUTH_ADMIN;
const KS='rutafacil-sesion',KD='rutafacil-dispositivo',KC='rutafacil-cuenta';
const DOMINIO='rutafacilcr.github.io';   // correo interno: <8 dígitos>@rutafacilcr.github.io (nunca se le manda nada)
const OFFLINE_DIAS=3;                     // sin internet, la app abre con la última revisión buena hasta 3 días
const REVISAR_MIN=15;
const SOPORTE=String(C.soporte||'62700666').replace(/\D/g,'');   // WhatsApp de soporte (config.js: soporte)

const ls={get(k){try{return JSON.parse(localStorage.getItem(k))}catch(e){return null}},
  set(k,v){try{localStorage.setItem(k,JSON.stringify(v))}catch(e){}},del(k){try{localStorage.removeItem(k)}catch(e){}}};
let ses=ls.get(KS),dev=ls.get(KD),cuenta=null,abierta=false,ultimaRev=0;
if(!dev){const a=new Uint8Array(16);crypto.getRandomValues(a);dev=[...a].map(x=>x.toString(16).padStart(2,'0')).join('');ls.set(KD,dev)}
const tel8=t=>{let d=String(t||'').replace(/\D/g,'');if(d.length===11&&d.startsWith('506'))d=d.slice(3);return d};
const esc=s=>String(s??'').replace(/[&<>"]/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]));
const colones=n=>'₡'+Number(n||0).toLocaleString('es-CR');
const fecha=d=>d?new Date(d).toLocaleDateString('es-CR',{day:'numeric',month:'long',year:'numeric'}):'';

let soltar;const listo=new Promise(r=>soltar=r);

// ---------- Supabase Auth y RPC por REST (sin librerías) ----------
async function authReq(path,body,tk){
  const r=await fetch(BASE+'/auth/v1/'+path,{method:'POST',headers:{apikey:C.supabaseAnonKey,'Content-Type':'application/json',...(tk?{Authorization:'Bearer '+tk}:{})},body:JSON.stringify(body||{})});
  const j=await r.json().catch(()=>({}));
  if(!r.ok){const e=new Error(j.msg||j.error_description||j.message||('error '+r.status));e.code=j.error_code||j.code||j.error||'';e.status=r.status;throw e}
  return j;
}
function guardar(j){ses={access_token:j.access_token,refresh_token:j.refresh_token,expires_at:j.expires_at||Math.floor(Date.now()/1000)+(j.expires_in||3600)};ls.set(KS,ses)}
let renovando=null;
async function token(){
  if(!ses)return null;
  if(ses.expires_at*1000-60000>Date.now())return ses.access_token;
  if(!renovando)renovando=authReq('token?grant_type=refresh_token',{refresh_token:ses.refresh_token}).then(guardar)
    .catch(e=>{if(e.status&&e.status<500){ses=null;ls.del(KS)}throw e}).finally(()=>renovando=null);
  await renovando;return ses&&ses.access_token;
}
async function headers(){
  if(!ON)return {};
  let t=null;try{t=await token()}catch(e){}
  if(t)return {apikey:C.supabaseAnonKey,Authorization:'Bearer '+t};
  return {apikey:C.supabaseAnonKey,...(C.supabaseAnonKey.startsWith('eyJ')?{Authorization:'Bearer '+C.supabaseAnonKey}:{})};
}
async function rpc(fn,args){
  const r=await fetch(BASE+'/rest/v1/rpc/'+fn,{method:'POST',headers:{...(await headers()),'Content-Type':'application/json'},body:JSON.stringify(args||{})});
  const txt=await r.text();let j=null;try{j=txt?JSON.parse(txt):null}catch(e){}
  if(!r.ok){const e=new Error(String((j&&(j.message||j.msg))||txt||('error '+r.status)).replace(/^RF_\w+:\s*/,'').slice(0,160));e.status=r.status;e.code=(j&&j.code)||'';throw e}
  return j;
}

// ---------- Pantalla de entrada ----------
const CSS=`html.rf-bloq body>*:not(#rfGate){display:none!important}
#rfGate{position:fixed;inset:0;z-index:9999;background:var(--bg,#f5f5f4);color:var(--ink,#1c1917);overflow:auto;font-family:var(--f-body,system-ui,sans-serif);display:flex;justify-content:center;padding:max(32px,env(safe-area-inset-top)) 16px 32px}
#rfGate[hidden]{display:none}
#rfGate .rfbox{width:100%;max-width:400px;display:flex;flex-direction:column;gap:14px}
#rfGate .rflogo{display:flex;gap:12px;align-items:center;margin-bottom:8px}
#rfGate .rflogo img{width:48px;height:48px;border-radius:12px}
#rfGate h1{font-size:22px;margin:0}#rfGate h1 span{color:var(--accent,#f26b1d)}
#rfGate h2{font-size:18px;margin:4px 0 0}
#rfGate p{margin:0;line-height:1.45}
#rfGate label{display:flex;flex-direction:column;gap:6px;font-weight:600;font-size:14px}
#rfGate input{font:inherit;font-size:17px;padding:12px 14px;border:1px solid var(--line,#e2dfdc);border-radius:10px;background:var(--surface,#fff);color:inherit}
#rfGate input:focus{outline:2px solid var(--accent,#f26b1d);outline-offset:1px}
#rfGate .rfbtn{font:inherit;font-weight:700;font-size:16px;padding:13px 16px;border-radius:10px;border:1px solid var(--line,#e2dfdc);background:var(--surface,#fff);color:inherit;cursor:pointer;text-align:center;text-decoration:none}
#rfGate .rfbtn.pri{background:var(--accent,#f26b1d);color:var(--accent-ink,#fff);border-color:transparent}
#rfGate .rfbtn:disabled{opacity:.6}
#rfGate .rflink{background:none;border:0;color:var(--accent,#f26b1d);font:inherit;font-weight:600;cursor:pointer;padding:6px 0;text-align:left}
#rfGate .rfmsg{background:var(--surface,#fff);border:1px solid var(--line,#e2dfdc);border-radius:12px;padding:14px 16px;display:flex;flex-direction:column;gap:8px}
#rfGate .rferr{color:var(--bad,#b03a3a);font-weight:600;min-height:1.2em}
#rfGate .rfmuted{color:var(--muted,#6b6560);font-size:14px}
#rfGate .rfpago{font-family:var(--f-mono,monospace);font-size:15px}
.rfcuenta a{color:inherit;text-decoration:underline;cursor:pointer}`;

let gate,body;
function montar(){
  if(gate)return;
  const st=document.createElement('style');st.textContent=CSS;document.head.appendChild(st);
  gate=document.createElement('div');gate.id='rfGate';gate.setAttribute('role','dialog');gate.setAttribute('aria-modal','true');gate.setAttribute('aria-labelledby','rfTitulo');
  gate.innerHTML=`<div class="rfbox"><div class="rflogo"><img src="icon-192.png" alt=""><h1 id="rfTitulo">Ruta<span>Fácil</span> CR</h1></div><div id="rfBody" class="rfbox" style="gap:14px"></div></div>`;
  document.body.appendChild(gate);body=gate.querySelector('#rfBody');
}
function bloquear(){document.documentElement.classList.add('rf-bloq');if(document.body){montar();gate.hidden=false}}
function vista(html){bloquear();body.innerHTML=html;const f=body.querySelector('input');if(f&&!('ontouchstart' in window))f.focus()}
const waSoporte=t=>`https://wa.me/506${SOPORTE}?text=${encodeURIComponent(t||'Hola, necesito ayuda con RutaFácil')}`;
const contacto=()=>`<a class="rfbtn" href="${waSoporte()}" target="_blank" rel="noopener"><svg style="vertical-align:-3px" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M4 14v-2a8 8 0 0 1 16 0v2"/><rect x="2.5" y="13" width="4" height="6" rx="1.5"/><rect x="17.5" y="13" width="4" height="6" rx="1.5"/><path d="M19.5 19c0 1.7-1.8 2.5-4.5 2.5h-2"/></svg> Escribir a soporte por WhatsApp</a>`;
const ayuda=`<p class="rfmuted"><svg style="vertical-align:-3px" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M4 14v-2a8 8 0 0 1 16 0v2"/><rect x="2.5" y="13" width="4" height="6" rx="1.5"/><rect x="17.5" y="13" width="4" height="6" rx="1.5"/><path d="M19.5 19c0 1.7-1.8 2.5-4.5 2.5h-2"/></svg> ¿Necesitás ayuda? <a href="${waSoporte()}" target="_blank" rel="noopener" style="color:var(--accent,#f26b1d);font-weight:600">Escribinos por WhatsApp al ${SOPORTE.replace(/(\d{4})(\d{4})/,'$1 $2')}</a></p>`;
const pagar=c=>c&&c.sinpe?`<p>Pagá <b>${colones(c.precio)}</b> por SINPE Móvil al <b class="rfpago">${esc(c.sinpe)}</b> con el detalle <b class="rfpago">RF ${esc(c.telefono)}</b> y avisale al administrador.</p>`:`<p>Escribile al administrador para activarla.</p>`;

function vEntrar(err){
  vista(`<h2>Entrar</h2>
  <form id="rfForm" class="rfbox" style="gap:14px" novalidate>
    <label>Tu número de teléfono<input id="rfTel" inputmode="numeric" autocomplete="username" placeholder="8888 1234" maxlength="12" required></label>
    <label>PIN de 6 números<input id="rfPin" type="password" inputmode="numeric" autocomplete="current-password" maxlength="6" placeholder="••••••" required></label>
    <p class="rferr" id="rfErr" role="alert">${esc(err||'')}</p>
    <button class="rfbtn pri" id="rfOk">Entrar</button>
  </form>
  <button class="rflink" id="rfCrear">¿No tenés cuenta? Crear cuenta</button>
  <p class="rfmuted">¿Olvidaste el PIN? Pedile uno nuevo al administrador.</p>${ayuda}`);
  body.querySelector('#rfCrear').onclick=()=>vCrear();
  body.querySelector('#rfForm').onsubmit=async e=>{
    e.preventDefault();const t=tel8(body.querySelector('#rfTel').value),pin=body.querySelector('#rfPin').value.trim(),er=body.querySelector('#rfErr'),b=body.querySelector('#rfOk');
    if(t.length!==8){er.textContent='Escribí tu número de 8 dígitos';return}
    if(!/^\d{6}$/.test(pin)){er.textContent='El PIN tiene 6 números';return}
    b.disabled=true;b.textContent='Entrando…';er.textContent='';
    try{guardar(await authReq('token?grant_type=password',{email:t+'@'+DOMINIO,password:pin}));await revisar(true)}
    catch(x){b.disabled=false;b.textContent='Entrar';er.textContent=/confirm/i.test(x.message+x.code)?'Tu cuenta existe, pero falta un ajuste en Supabase (desactivar "Confirm email"). Avisale al administrador.':x.status===400?'Número o PIN incorrecto. Si es tu primera vez, tocá Crear cuenta.':'No se pudo entrar: '+x.message}
  };
}
function vCrear(){
  vista(`<h2>Crear cuenta</h2>
  <form id="rfForm" class="rfbox" style="gap:14px" novalidate>
    <label>Tu nombre (así lo ven tus clientes)<input id="rfNom" autocomplete="name" maxlength="60" placeholder="Victor Mena" required></label>
    <label>Tu número de WhatsApp<input id="rfTel" inputmode="numeric" autocomplete="username" placeholder="8888 1234" maxlength="12" required></label>
    <label>Elegí un PIN de 6 números<input id="rfPin" type="password" inputmode="numeric" autocomplete="new-password" maxlength="6" placeholder="••••••" required></label>
    <label>Repetí el PIN<input id="rfPin2" type="password" inputmode="numeric" autocomplete="new-password" maxlength="6" placeholder="••••••" required></label>
    <p class="rfmuted">La cuenta es personal y queda en este teléfono. Si la abrís en otro, el administrador tiene que aprobar el cambio.</p>
    <p class="rferr" id="rfErr" role="alert"></p>
    <button class="rfbtn pri" id="rfOk">Crear cuenta</button>
  </form>
  <button class="rflink" id="rfVolver">Ya tengo cuenta: entrar</button>${ayuda}`);
  body.querySelector('#rfVolver').onclick=()=>vEntrar();
  body.querySelector('#rfForm').onsubmit=async e=>{
    e.preventDefault();const q=s=>body.querySelector(s);const nom=q('#rfNom').value.trim(),t=tel8(q('#rfTel').value),pin=q('#rfPin').value.trim(),er=q('#rfErr'),b=q('#rfOk');
    if(nom.length<3){er.textContent='Escribí tu nombre';return}
    if(t.length!==8){er.textContent='Escribí tu número de 8 dígitos';return}
    if(!/^\d{6}$/.test(pin)){er.textContent='El PIN tiene que ser de 6 números';return}
    if(/^(\d)\1{5}$/.test(pin)||pin==='123456'||pin==='654321'){er.textContent='Ese PIN es muy fácil de adivinar';return}
    if(pin!==q('#rfPin2').value.trim()){er.textContent='Los dos PIN no coinciden';return}
    b.disabled=true;b.textContent='Creando…';er.textContent='';
    try{
      const j=await authReq('signup',{email:t+'@'+DOMINIO,password:pin,data:{nombre:nom,telefono:t}});
      if(!j.access_token){b.disabled=false;b.textContent='Crear cuenta';er.textContent='La cuenta se creó, pero falta un ajuste en Supabase (desactivar "Confirm email"). Avisale al administrador.';return}
      guardar(j);await revisar(true);
    }catch(x){b.disabled=false;b.textContent='Crear cuenta';
      er.textContent=/already|registered|exists/i.test(x.message+x.code)?'Ese número ya tiene cuenta. Entrá con tu PIN.':'No se pudo crear la cuenta: '+x.message}
  };
}
function vEstado(c){
  let h;
  if(ADMIN&&c.rol!=='admin')h=`<h2>Solo para el administrador</h2><p>Esta página es para administrar las cuentas.</p><a class="rfbtn" href="./">Ir a la app</a>`;
  else if(c.dispositivo==='pendiente')h=`<h2>Esta cuenta está en otro teléfono</h2><p>Cada cuenta funciona en un solo teléfono. Ya le avisamos al administrador: cuando apruebe el cambio, tocá <b>Revisar de nuevo</b>.</p>${contacto(c)}`;
  else if(c.dispositivo==='cerrado')h=`<h2>La cuenta se pasó a otro teléfono</h2><p>Este teléfono se cerró porque la cuenta se aprobó en otro. Si fue un error, escribile al administrador.</p>${contacto(c)}`;
  else if(c.estado==='suspendido')h=`<h2>Cuenta suspendida</h2><p>Escribile al administrador para saber más.</p>${contacto(c)}`;
  else if(c.estado==='pendiente')h=`<h2>Hola, ${esc((c.nombre||'').split(' ')[0])}</h2><p>Tu cuenta está creada y espera activación.</p>${pagar(c)}${contacto(c)}`;
  else h=`<h2>Tu mensualidad venció</h2><p>Venció el ${fecha(c.vence_en)}.</p>${pagar(c)}${contacto(c)}`;
  vista(`<div class="rfmsg">${h}</div><button class="rfbtn pri" id="rfRev">Revisar de nuevo</button><button class="rflink" id="rfSalir">Salir de la cuenta</button>`);
  body.querySelector('#rfRev').onclick=()=>revisar(true);
  body.querySelector('#rfSalir').onclick=()=>salir();
}
function vError(msg){
  vista(`<div class="rfmsg"><h2>No se pudo revisar tu cuenta</h2><p>${esc(msg)}</p><p class="rfmuted">Revisá que tengás internet.</p></div>${ayuda}<button class="rfbtn pri" id="rfRev">Intentar de nuevo</button><button class="rflink" id="rfSalir">Salir de la cuenta</button>`);
  body.querySelector('#rfRev').onclick=()=>revisar(true);body.querySelector('#rfSalir').onclick=()=>salir();
}

// ---------- Estado de la cuenta ----------
const sirve=c=>!!c&&c.activo&&c.dispositivo==='ok'&&(!ADMIN||c.rol==='admin');
function abrir(c,aviso){
  cuenta=c;abierta=true;document.documentElement.classList.remove('rf-bloq');if(gate)gate.hidden=true;
  pie(c,aviso);soltar(c);document.dispatchEvent(new CustomEvent('rf-cuenta',{detail:c}));
}
function pie(c,aviso){
  const f=document.querySelector('.appver');if(!f)return;
  let s=f.querySelector('.rfcuenta');if(!s){s=document.createElement('span');s.className='rfcuenta';f.appendChild(s)}
  if(!c){s.innerHTML=aviso?`<br>${esc(aviso)}`:'';return}
  const venc=c.rol==='admin'?'':c.en_gracia?` · <b style="color:var(--bad)">venció el ${fecha(c.vence_en)}, pagá para no perder acceso</b>`:c.vence_en?` · al día hasta el ${fecha(c.vence_en)}`:'';
  s.innerHTML=`<br>Cuenta de ${esc(c.nombre)}${venc} · ${c.rol==='admin'&&!ADMIN?'<a href="admin.html">Panel</a> · ':''}<a id="rfSalirPie">Salir</a>`;
  s.querySelector('#rfSalirPie').onclick=()=>{if(confirm('¿Salir de la cuenta en este teléfono?'))salir()};
}
async function revisar(manual){
  if(!ON)return;
  ultimaRev=Date.now();
  if(!ses){vEntrar();return}
  if(manual&&!abierta&&body)vista(`<p class="rfmuted">Revisando tu cuenta…</p>`);
  try{
    const c=await rpc('rf_mi_cuenta',{p_dispositivo:dev});
    ls.set(KC,{c,at:Date.now()});
    if(sirve(c))abrir(c);else{abierta=false;vEstado(c)}
  }catch(e){
    if(e.status===404||e.code==='PGRST202'){abrir(null,'Cuentas sin activar en Supabase (falta correr supabase.sql).');return}
    if(e.status===401||e.code==='PGRST301'||/sin sesión|JWT/i.test(e.message)){ses=null;ls.del(KS);ls.del(KC);abierta=false;vEntrar('Tu sesión venció. Entrá de nuevo.');return}
    const k=ls.get(KC);
    if(k&&sirve(k.c)&&Date.now()-k.at<OFFLINE_DIAS*864e5){if(!abierta)abrir(k.c);return}
    abierta=false;vError(e.message||'Sin conexión');
  }
}
async function salir(){
  const t=ses&&ses.access_token;ses=null;cuenta=null;abierta=false;ls.del(KS);ls.del(KC);
  if(t)authReq('logout',{},t).catch(()=>{});
  const f=document.querySelector('.appver .rfcuenta');if(f)f.innerHTML='';
  vEntrar();
}

window.RF_AUTH={on:ON,listo,headers,rpc,revisar,salir,get cuenta(){return cuenta},dispositivo:dev};

if(!ON){soltar(null);return}
// Con una revisión buena reciente la app abre de una vez (también sin internet) y se confirma por detrás.
const k=ls.get(KC);const rapido=ses&&k&&sirve(k.c)&&Date.now()-k.at<OFFLINE_DIAS*864e5;
if(!rapido)document.documentElement.classList.add('rf-bloq');
const arrancar=()=>{montar();if(rapido){abrir(k.c);revisar()}else{vista(`<p class="rfmuted">Revisando tu cuenta…</p>`);revisar()}};
if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',arrancar);else arrancar();
setInterval(()=>{if(!document.hidden&&ses)revisar()},REVISAR_MIN*60000);
document.addEventListener('visibilitychange',()=>{if(!document.hidden&&ses&&Date.now()-ultimaRev>5*60000)revisar()});
})();
