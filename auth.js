// RutaFácil CR · cuentas (Fase 1a): entrada con número + PIN y un teléfono por cuenta.
// Se carga después de config.js. Si config.js no tiene Supabase, no hace nada y la app abre normal.
// Expone window.RF_AUTH: { on, listo (promesa con la cuenta), cuenta, headers(), rpc(), revisar(), salir() }.
// Página de administración: definir window.RF_AUTH_ADMIN = true antes de cargar este archivo.
(function(){
const C=window.RF_CONFIG||{};
const ON=!!(C.supabaseUrl&&C.supabaseAnonKey);
const BASE=ON?C.supabaseUrl.replace(/\/$/,''):'';
const ADMIN=!!window.RF_AUTH_ADMIN;
const KS='rutafacil-sesion',KD='rutafacil-dispositivo',KC='rutafacil-cuenta',KA='rutafacil-pin-at';
const ADMIN_HORAS=12;                     // 1.74.0: el Panel vuelve a pedir el PIN si pasaron 12 horas desde la última vez
const DOMINIO='rutafacilcr.github.io';   // correo interno: <8 dígitos>@rutafacilcr.github.io (nunca se le manda nada)
const OFFLINE_DIAS=3;                     // sin internet, la app abre con la última revisión buena hasta 3 días
const REVISAR_MIN=15;
const SOPORTE=String(C.soporte||'62700666').replace(/\D/g,'');   // WhatsApp de soporte (config.js: soporte)

const ls={get(k){try{return JSON.parse(localStorage.getItem(k))}catch(e){return null}},
  set(k,v){try{localStorage.setItem(k,JSON.stringify(v))}catch(e){}},del(k){try{localStorage.removeItem(k)}catch(e){}}};
let ses=ls.get(KS),dev=ls.get(KD),cuenta=null,abierta=false,esperando=false,ultimaRev=0;
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
#rfGate input::placeholder{color:var(--muted,#6b6560);opacity:.45}
#rfGate input:focus{outline:2px solid var(--accent,#f26b1d);outline-offset:1px}
#rfGate .rfbtn{font:inherit;font-weight:700;font-size:16px;padding:13px 16px;border-radius:10px;border:1px solid var(--line,#e2dfdc);background:var(--surface,#fff);color:inherit;cursor:pointer;text-align:center;text-decoration:none}
#rfGate .rfbtn.pri{background:var(--accent,#f26b1d);color:var(--accent-ink,#fff);border-color:transparent}
#rfGate .rfbtn:disabled{opacity:.6}
#rfGate .rfbtn.rfespera{background:var(--line,#e2dfdc);color:var(--muted,#6b6560);border-color:transparent;opacity:1;cursor:default}
#rfGate .rflink{background:none;border:0;color:var(--accent,#f26b1d);font:inherit;font-weight:600;cursor:pointer;padding:6px 0;text-align:left;text-decoration:underline;text-underline-offset:2px}
#rfGate p .rflink{padding:0;font-size:inherit}
#rfGate .rfmsg{background:var(--surface,#fff);border:1px solid var(--line,#e2dfdc);border-radius:12px;padding:14px 16px;display:flex;flex-direction:column;gap:8px}
#rfGate .rferr{color:var(--bad,#b03a3a);font-weight:600;min-height:1.2em}
#rfGate .rfmuted{color:var(--muted,#6b6560);font-size:14px}
#rfGate .rfpago{font-family:var(--f-mono,monospace);font-size:15px}
#rfGate .rflisto{border-color:var(--ok,#2f8a4e);background:var(--ok-bg,#e3f3e8)}
.rfcuenta a{color:inherit;text-decoration:underline;cursor:pointer}
.rfcuenta a.rfcod{white-space:nowrap}
.rfadlg{position:fixed;inset:0;z-index:10000;background:rgba(20,22,26,.5);-webkit-backdrop-filter:blur(6px);backdrop-filter:blur(6px);display:grid;place-items:center;padding:20px;opacity:0;transition:opacity .18s;font-family:var(--f-body,system-ui,sans-serif)}
.rfadlg.on{opacity:1}
.rfadlg-box{width:min(360px,100%);max-height:calc(100dvh - 40px);overflow:auto;background:var(--surface,#fff);color:var(--ink,#1c1917);border-radius:20px;padding:22px 20px 16px;box-shadow:0 20px 60px rgba(0,0,0,.28),0 2px 8px rgba(0,0,0,.08);transform:scale(.94);transition:transform .2s cubic-bezier(.2,.9,.3,1.2)}
.rfadlg.on .rfadlg-box{transform:scale(1)}
.rfadlg-top{display:flex;gap:12px;align-items:center;margin-bottom:10px}
.rfadlg-ico{flex:none;width:44px;height:44px;border-radius:50%;display:grid;place-items:center;font-size:21px;background:rgba(242,107,29,.12)}
.rfadlg-ico.mal{background:rgba(192,57,43,.12)}
.rfadlg h3{margin:0;font-size:17px;line-height:1.3}
.rfadlg p{margin:0 0 6px;font-size:14px;line-height:1.5;color:var(--muted,#6b6560)}
.rfadlg-btns{display:flex;justify-content:flex-end;gap:8px;margin-top:16px;flex-wrap:wrap}
.rfadlg-btns button{font:inherit;font-size:15px;font-weight:700;padding:10px 16px;border-radius:10px;border:1px solid var(--line,#e2dfdc);background:var(--surface,#fff);color:var(--ink,#1c1917);cursor:pointer}
.rfadlg-btns .rfadlg-si{background:var(--accent,#f26b1d);border-color:transparent;color:#fff}
.rfadlg-btns button:focus-visible{outline:2px solid var(--accent,#f26b1d);outline-offset:2px}`;

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
// 1.75.0: qué es la app, para quien llega sin cuenta (no se muestra en el panel del administrador)
const intro=ADMIN?'':`<div class="rfmsg"><p><b>Ordená tus entregas del día desde el celular.</b> Cargás los paquetes, avisás a cada cliente por WhatsApp y salís con la ruta más corta. Para mensajeros en Costa Rica.</p><p class="rfmuted"><a href="conoce.html" style="color:var(--accent,#f26b1d);font-weight:600">Ver cómo funciona</a> · <a href="privacidad.html" style="color:var(--accent,#f26b1d);font-weight:600">Privacidad</a></p></div>`;
const pagar=c=>c&&c.sinpe?`<p>Pagá <b>${colones(c.precio)}</b> por SINPE Móvil al <b class="rfpago">${esc(c.sinpe)}</b> con el detalle <b class="rfpago">RF ${esc(c.telefono)}</b> y avisale al administrador.</p>`:`<p>Escribile al administrador para activarla.</p>`;

function vEntrar(err){
  vista(`${intro}<h2>Entrar</h2>
  <form id="rfForm" class="rfbox" style="gap:14px" novalidate>
    <label>Tu número de teléfono<input id="rfTel" inputmode="numeric" autocomplete="username" placeholder="8888 1234" maxlength="12" required></label>
    <label>PIN de 6 números<input id="rfPin" type="password" inputmode="numeric" autocomplete="current-password" maxlength="6" placeholder="••••••" required></label>
    <p class="rferr" id="rfErr" role="alert">${esc(err||'')}</p>
    <button class="rfbtn pri" id="rfOk">Entrar</button>
  </form>
  <p class="rfmuted">¿No tenés cuenta? <button class="rflink" id="rfCrear">Crear cuenta</button></p>
  <p class="rfmuted">¿Olvidaste el PIN? <button class="rflink" id="rfOlvido">Usá tu código de recuperación</button> o pedile uno nuevo al administrador.</p>${ayuda}`);
  body.querySelector('#rfCrear').onclick=()=>vCrear();
  body.querySelector('#rfOlvido').onclick=()=>vRecuperar();
  body.querySelector('#rfForm').onsubmit=async e=>{
    e.preventDefault();const t=tel8(body.querySelector('#rfTel').value),pin=body.querySelector('#rfPin').value.trim(),er=body.querySelector('#rfErr'),b=body.querySelector('#rfOk');
    if(t.length!==8){er.textContent='Escribí tu número de 8 dígitos';return}
    if(!/^\d{6}$/.test(pin)){er.textContent='El PIN tiene 6 números';return}
    b.disabled=true;b.textContent='Entrando…';er.textContent='';
    try{guardar(await authReq('token?grant_type=password',{email:t+'@'+DOMINIO,password:pin}));ls.set(KA,Date.now());await revisar(true)}
    catch(x){b.disabled=false;b.textContent='Entrar';er.textContent=/confirm/i.test(x.message+x.code)?'Tu cuenta existe, pero falta un ajuste en Supabase (desactivar "Confirm email"). Avisale al administrador.':x.status===400?'Número o PIN incorrecto. Si es tu primera vez, tocá Crear cuenta.':'No se pudo entrar: '+x.message}
  };
}
function vCrear(){
  vista(`${intro}<h2>Crear cuenta</h2>
  <form id="rfForm" class="rfbox" style="gap:14px" novalidate>
    <label>Tu nombre (así lo ven tus clientes)<input id="rfNom" autocomplete="off" maxlength="60" required></label>
    <label>Tu número de WhatsApp<input id="rfTel" inputmode="numeric" autocomplete="off" maxlength="12" required></label>
    <label>Elegí un PIN de 6 números<input id="rfPin" type="password" inputmode="numeric" autocomplete="new-password" maxlength="6" required></label>
    <label>Repetí el PIN<input id="rfPin2" type="password" inputmode="numeric" autocomplete="new-password" maxlength="6" required></label>
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
      guardar(j);ls.set(KA,Date.now());await mostrarCodigoNuevo(()=>revisar(true));
    }catch(x){b.disabled=false;b.textContent='Crear cuenta';
      er.textContent=/already|registered|exists/i.test(x.message+x.code)?'Ese número ya tiene cuenta. Entrá con tu PIN.':'No se pudo crear la cuenta: '+x.message}
  };
}
function vEstado(c){
  let h;
  if(ADMIN&&c.rol!=='admin')h=`<h2>Solo para el administrador</h2><p>Esta página es para administrar las cuentas.</p><a class="rfbtn" href="./">Ir a la app</a>`;
  else if(c.dispositivo==='pendiente')h=`<h2>Esta cuenta está en otro teléfono</h2><p>Cada cuenta funciona en un solo teléfono.</p><p><b>¿Cambiaste de celular?</b> Usá tu <b>código de recuperación</b> y entrás de una vez (el celular anterior se cierra).</p><button class="rfbtn pri" id="rfUsarCod">Usar código de recuperación</button><p class="rfmuted">Si no tenés el código, ya le avisamos al administrador: lo aprueba normalmente el mismo día. Escribile por WhatsApp para que sea más rápido. Cuando lo apruebe, esta pantalla se abre sola.</p>${contacto(c)}`;
  else if(c.dispositivo==='cerrado')h=`<h2>La cuenta se pasó a otro teléfono</h2><p>Este teléfono se cerró porque la cuenta se aprobó en otro. Si fue un error, escribile al administrador.</p>${contacto(c)}`;
  else if(c.estado==='suspendido')h=`<h2>Cuenta suspendida</h2><p>Escribile al administrador para saber más.</p>${contacto(c)}`;
  else if(c.estado==='pendiente')h=`<h2>Hola, ${esc((c.nombre||'').split(' ')[0])}</h2><p>Tu cuenta está creada y espera activación. Cuando la activemos, el botón de abajo se pone naranja y te avisamos por WhatsApp.</p>${pagar(c)}${contacto(c)}`;
  else h=`<h2>Tu mensualidad venció</h2><p>Venció el ${fecha(c.vence_en)}.</p>${pagar(c)}${contacto(c)}`;
  // Pendiente, vencida o teléfono por aprobar: depende del administrador. El botón queda gris y la app
  // revisa sola cada minuto; al activarse se pone naranja (vListo).
  const espera=!ADMIN&&(c.dispositivo==='pendiente'||(c.dispositivo==='ok'&&c.estado!=='suspendido'));
  esperando=espera;
  vista(`<div class="rfmsg">${h}</div>${espera
    ?`<button class="rfbtn rfespera" disabled>⏳ ${c.dispositivo==='pendiente'?'Esperando aprobación':'Esperando activación'}</button><p class="rfmuted" style="text-align:center">Se revisa sola cada minuto.</p>`
    :'<button class="rfbtn pri" id="rfRev">Revisar de nuevo</button>'}<button class="rflink" id="rfSalir">Salir de la cuenta</button>`);
  const rv=body.querySelector('#rfRev');if(rv)rv.onclick=()=>revisar(true);
  const uc=body.querySelector('#rfUsarCod');if(uc)uc.onclick=()=>vRecuperar(c.telefono,true);
  body.querySelector('#rfSalir').onclick=()=>salir();
}
// ---------- Código de recuperación (1.74.0) ----------
// Sirve para poner un PIN nuevo y para pasar la cuenta a otro celular sin esperar al administrador (rf_recuperar).
function vCodigo(cod,seguir){
  vista(`<div class="rfmsg rflisto"><h2>🔑 Tu código de recuperación</h2>
  <p class="rfpago" style="font-size:24px;font-weight:700;letter-spacing:1px;text-align:center;margin:6px 0">${esc(cod)}</p>
  <p><b>Tomale captura o anotalo.</b> Con tu número y este código podés poner un PIN nuevo o pasar la cuenta a otro celular sin esperar al administrador.</p>
  <p class="rfmuted">No se lo des a nadie: con él se puede entrar a tu cuenta. Se usa una sola vez; al usarlo te damos uno nuevo.</p></div>
  <button class="rfbtn" id="rfCopiar">Copiar código</button><button class="rfbtn pri" id="rfGuardado">Ya lo guardé</button>`);
  body.querySelector('#rfCopiar').onclick=e=>{try{navigator.clipboard.writeText(cod);e.target.textContent='✓ Copiado'}catch(x){}};
  body.querySelector('#rfGuardado').onclick=()=>seguir();
}
async function mostrarCodigoNuevo(seguir){
  try{await rpc('rf_mi_cuenta',{p_dispositivo:dev});const r=await rpc('rf_codigo_nuevo');if(r&&r.codigo){vCodigo(r.codigo,seguir);return}}catch(e){}
  seguir();   // base sin la función nueva: sigue como antes
}
function vRecuperar(tel,cambio){
  vista(`<h2>${cambio?'Pasar la cuenta a este celular':'Recuperar el PIN'}</h2>
  <form id="rfForm" class="rfbox" style="gap:14px" novalidate>
    <label>Tu número de teléfono<input id="rfTel" inputmode="numeric" autocomplete="username" maxlength="12" value="${esc(tel||'')}" required></label>
    <label>Código de recuperación<input id="rfCod" autocomplete="off" autocapitalize="characters" maxlength="16" placeholder="XXXX-XXXX-XXXX" required></label>
    <label>${cambio?'Tu PIN (o uno nuevo)':'PIN nuevo de 6 números'}<input id="rfPin" type="password" inputmode="numeric" autocomplete="new-password" maxlength="6" required></label>
    <label>Repetí el PIN<input id="rfPin2" type="password" inputmode="numeric" autocomplete="new-password" maxlength="6" required></label>
    <p class="rfmuted">${cambio?'La cuenta queda en este celular y el anterior se cierra.':'Si estás en un celular nuevo, la cuenta pasa a este y el anterior se cierra.'}</p>
    <p class="rferr" id="rfErr" role="alert"></p>
    <button class="rfbtn pri" id="rfOk">${cambio?'Pasar la cuenta':'Cambiar PIN y entrar'}</button>
  </form>
  <p class="rfmuted">¿No tenés el código? Pedile al administrador un PIN nuevo por WhatsApp.</p>
  <button class="rflink" id="rfVolver">Volver</button>${ayuda}`);
  body.querySelector('#rfVolver').onclick=()=>cambio&&ses?revisar(true):vEntrar();
  body.querySelector('#rfForm').onsubmit=async e=>{
    e.preventDefault();const q=s=>body.querySelector(s);const t=tel8(q('#rfTel').value),cod=q('#rfCod').value.trim(),pin=q('#rfPin').value.trim(),er=q('#rfErr'),b=q('#rfOk');
    if(t.length!==8){er.textContent='Escribí tu número de 8 dígitos';return}
    if(cod.replace(/[^A-Za-z0-9]/g,'').length!==12){er.textContent='El código tiene 12 letras y números';return}
    if(!/^\d{6}$/.test(pin)){er.textContent='El PIN tiene que ser de 6 números';return}
    if(/^(\d)\1{5}$/.test(pin)||pin==='123456'||pin==='654321'){er.textContent='Ese PIN es muy fácil de adivinar';return}
    if(pin!==q('#rfPin2').value.trim()){er.textContent='Los dos PIN no coinciden';return}
    b.disabled=true;b.textContent='Revisando…';er.textContent='';
    try{const r=await rpc('rf_recuperar',{p_telefono:t,p_codigo:cod,p_pin:pin,p_dispositivo:dev});
      if(!r||!r.ok){b.disabled=false;b.textContent=cambio?'Pasar la cuenta':'Cambiar PIN y entrar';er.textContent=(r&&r.error)||'Número o código incorrecto';return}
      guardar(await authReq('token?grant_type=password',{email:t+'@'+DOMINIO,password:pin}));ls.set(KA,Date.now());
      vCodigo(r.codigo,()=>revisar(true));
    }catch(x){b.disabled=false;b.textContent=cambio?'Pasar la cuenta':'Cambiar PIN y entrar';
      er.textContent=x.status===404?'Esta opción todavía no está activa. Pedile un PIN nuevo al administrador.':(x.message||'No se pudo')}
  };
}
// Panel: si pasaron ADMIN_HORAS desde el último PIN, se vuelve a pedir (la sesión del celular sigue igual).
function vPinAdmin(c){
  vista(`<h2>Poné tu PIN de nuevo</h2><p class="rfmuted">Por seguridad, el panel pide el PIN cada ${ADMIN_HORAS} horas.</p>
  <form id="rfForm" class="rfbox" style="gap:14px" novalidate>
    <label>PIN de 6 números<input id="rfPin" type="password" inputmode="numeric" autocomplete="current-password" maxlength="6" required></label>
    <p class="rferr" id="rfErr" role="alert"></p><button class="rfbtn pri" id="rfOk">Entrar al panel</button></form>
  <button class="rflink" id="rfSalir">Salir de la cuenta</button>`);
  body.querySelector('#rfSalir').onclick=()=>salir();
  body.querySelector('#rfForm').onsubmit=async e=>{e.preventDefault();const pin=body.querySelector('#rfPin').value.trim(),er=body.querySelector('#rfErr');
    try{guardar(await authReq('token?grant_type=password',{email:tel8(c.telefono)+'@'+DOMINIO,password:pin}));ls.set(KA,Date.now());abrir(c)}
    catch(x){er.textContent=x.status===400?'PIN incorrecto':'No se pudo: '+x.message}};
}
// 1.75.1: diálogo propio (en vez del confirm/alert del navegador), con el estilo de la app:
// ícono, título, explicación y botones a la derecha (el principal naranja con letra blanca). si='' = solo un botón.
function dialogo({ico='❔',titulo,texto='',si='Aceptar',no='Cancelar',mal=false}){return new Promise(fin=>{
  const w=document.createElement('div');w.className='rfadlg';
  w.innerHTML=`<div class="rfadlg-box" role="alertdialog" aria-modal="true" aria-labelledby="rfadlgT"><div class="rfadlg-top"><div class="rfadlg-ico${mal?' mal':''}" aria-hidden="true">${ico}</div><h3 id="rfadlgT">${esc(titulo)}</h3></div>${texto?`<p>${texto}</p>`:''}<div class="rfadlg-btns">${no?`<button type="button" class="rfadlg-no">${esc(no)}</button>`:''}<button type="button" class="rfadlg-si">${esc(si)}</button></div></div>`;
  const cerrar=v=>{document.removeEventListener('keydown',tec);w.classList.remove('on');setTimeout(()=>w.remove(),180);fin(v)};
  const tec=e=>{if(e.key==='Escape')cerrar(false)};document.addEventListener('keydown',tec);
  w.onclick=e=>{if(e.target===w)cerrar(false)};w.querySelector('.rfadlg-si').onclick=()=>cerrar(true);const n=w.querySelector('.rfadlg-no');if(n)n.onclick=()=>cerrar(false);
  document.body.appendChild(w);requestAnimationFrame(()=>w.classList.add('on'));
})}
function vListo(c){
  vista(`<div class="rfmsg rflisto"><h2>✅ Cuenta habilitada</h2><p>¡Listo, ${esc((c.nombre||'').split(' ')[0])}! Tu cuenta ya está activa${c.vence_en?' hasta el '+fecha(c.vence_en):''}.</p></div><button class="rfbtn pri" id="rfEntrar">Entrar</button>`);
  body.querySelector('#rfEntrar').onclick=()=>{esperando=false;abrir(c)};
}
function vError(msg){
  vista(`<div class="rfmsg"><h2>No se pudo revisar tu cuenta</h2><p>${esc(msg)}</p><p class="rfmuted">Revisá que tengás internet.</p></div>${ayuda}<button class="rfbtn pri" id="rfRev">Intentar de nuevo</button><button class="rflink" id="rfSalir">Salir de la cuenta</button>`);
  body.querySelector('#rfRev').onclick=()=>revisar(true);body.querySelector('#rfSalir').onclick=()=>salir();
}

// ---------- Estado de la cuenta ----------
const sirve=c=>!!c&&c.activo&&c.dispositivo==='ok'&&(!ADMIN||c.rol==='admin');
function abrir(c,aviso){
  if(ADMIN&&c&&c.rol==='admin'&&Date.now()-(ls.get(KA)||0)>ADMIN_HORAS*36e5){abierta=false;vPinAdmin(c);return}
  cuenta=c;abierta=true;document.documentElement.classList.remove('rf-bloq');if(gate)gate.hidden=true;
  pie(c,aviso);soltar(c);document.dispatchEvent(new CustomEvent('rf-cuenta',{detail:c}));
}
function pie(c,aviso){
  const f=document.querySelector('.appver');if(!f)return;
  let s=f.querySelector('.rfcuenta');if(!s){s=document.createElement('span');s.className='rfcuenta';f.appendChild(s)}
  if(!c){s.innerHTML=aviso?`<br>${esc(aviso)}`:'';return}
  const venc=c.rol==='admin'?'':c.en_gracia?` · <b style="color:var(--bad)">venció el ${fecha(c.vence_en)}, pagá para no perder acceso</b>`:c.vence_en?` · al día hasta el ${fecha(c.vence_en)}`:'';
  s.innerHTML=`<br>Cuenta de ${esc(c.nombre)}${venc} · ${c.rol==='admin'&&!ADMIN?'<a href="admin.html">Panel</a> · ':''}<a id="rfCodPie" class="rfcod">🔑 Código de recuperación</a> · <a id="rfSalirPie">Salir</a>`;
  s.querySelector('#rfSalirPie').onclick=async()=>{if(await dialogo({ico:'🚪',titulo:'¿Salir de la cuenta?',texto:'Para volver a entrar en este teléfono vas a necesitar tu número y tu PIN. Tus paquetes quedan guardados en la nube.',si:'Salir'}))salir()};
  s.querySelector('#rfCodPie').onclick=async()=>{
    if(!await dialogo({ico:'🔑',titulo:'Código de recuperación',texto:'Te damos un código de 12 letras para <b>poner un PIN nuevo</b> o <b>pasar la cuenta a otro celular</b> sin esperar al administrador.<br><br>Si ya tenías uno, el anterior deja de servir.',si:'Sacar código'}))return;
    try{const r=await rpc('rf_codigo_nuevo');if(r&&r.codigo){abierta=false;vCodigo(r.codigo,()=>abrir(cuenta||c))}}
    catch(e){dialogo({ico:'⚠️',mal:true,titulo:'No se pudo sacar el código',texto:esc(e.status===404?'Falta actualizar la base de datos (supabase.sql 1.74.0). Avisale al administrador.':e.message||'Revisá que tengás internet.'),si:'Entendido',no:''})}};
}
async function revisar(manual){
  if(!ON)return;
  ultimaRev=Date.now();
  if(!ses){vEntrar();return}
  if(manual&&!abierta&&body)vista(`<p class="rfmuted">Revisando tu cuenta…</p>`);
  try{
    const c=await rpc('rf_mi_cuenta',{p_dispositivo:dev});
    ls.set(KC,{c,at:Date.now()});
    if(sirve(c)){if(esperando&&!abierta)vListo(c);else abrir(c)}else{abierta=false;vEstado(c)}
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
// Mientras la cuenta espera activación (o aprobación del teléfono), se revisa cada minuto: al activarla, la app abre sola.
setInterval(()=>{if(!document.hidden&&ses&&!abierta)revisar()},60000);
document.addEventListener('visibilitychange',()=>{if(!document.hidden&&ses&&(!abierta||Date.now()-ultimaRev>5*60000))revisar()});
})();
