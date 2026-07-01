/**
 * SGJE — Analítica Académica · analytics.js
 * Consume api_analytics.php y renderiza todos los componentes del dashboard
 */

// ── Estado global ─────────────────────────────────────────────────────────────
let datosRiesgo        = [];   // todos los aprendices con nivel_riesgo
let datosFichas        = [];   // todas las fichas
let filtroRiesgoActual = 'todos';

// Paginación
const ITEMS_PER_PAGE = 10;
let paginaFichas  = 1;
let paginaRiesgo  = 1;

// ══════════════════════════════════════════════════════════════════════════════
// CARGA PRINCIPAL
// ══════════════════════════════════════════════════════════════════════════════
document.addEventListener('DOMContentLoaded', () => {
    cargarFichas();
    cargarTodo();
});

async function cargarTodo() {
    const ficha = document.getElementById('filtroFicha')?.value ?? '';
    const url   = `api_analytics.php?action=inteligencia&ficha=${encodeURIComponent(ficha)}`;

    try {
        const res  = await fetch(url);
        const data = await res.json();

        if (data.error) {
            mostrarError(data.error);
            return;
        }

        renderKpiRiesgo(data.riesgo_academico);
        renderSemaforo(data.semaforo);
        renderRanking(data.ranking);
        renderAlertas(data.alertas);
        datosFichas = data.estadisticas_ficha;
        paginaFichas = 1;
        renderTablaFichas();
        datosRiesgo = data.riesgo_academico.aprendices;
        paginaRiesgo = 1;
        aplicarFiltroRiesgo();

        // Reinicializar iconos de Lucide tras el renderizado dinámico
        if (window.lucide) lucide.createIcons();

    } catch (err) {
        mostrarError('No se pudo conectar con el servidor.');
        console.error(err);
    }
}

// ── Carga el select de fichas ─────────────────────────────────────────────────
async function cargarFichas() {
    try {
        const fichas = await fetch('api.php?action=get_fichas').then(r => r.json());
        const sel = document.getElementById('filtroFicha');
        fichas.forEach(f => {
            const opt = document.createElement('option');
            opt.value = f.numero_ficha;
            opt.textContent = `Ficha ${f.numero_ficha}`;
            sel.appendChild(opt);
        });
    } catch (_) {}
}

// ══════════════════════════════════════════════════════════════════════════════
// 1. KPI RIESGO ACADÉMICO
// ══════════════════════════════════════════════════════════════════════════════
function renderKpiRiesgo(data) {
    const { resumen } = data;
    document.getElementById('kpiRiesgo').innerHTML = `
        <div class="kpi-card kpi-total">
            <div class="kpi-num">${resumen.total_aprendices}</div>
            <div class="kpi-label">Total Aprendices</div>
            <div class="kpi-sub">Con matrícula activa</div>
        </div>
        <div class="kpi-card kpi-bajo">
            <div class="kpi-num">${resumen.total_bajo}</div>
            <div class="kpi-label" style="color:var(--green);">Riesgo Bajo</div>
            <div class="kpi-sub">0 pendientes</div>
        </div>
        <div class="kpi-card kpi-medio">
            <div class="kpi-num">${resumen.total_medio}</div>
            <div class="kpi-label" style="color:var(--yellow);">Riesgo Medio</div>
            <div class="kpi-sub">1 – 5 pendientes</div>
        </div>
        <div class="kpi-card kpi-alto">
            <div class="kpi-num">${resumen.total_alto}</div>
            <div class="kpi-label" style="color:var(--red);">Riesgo Alto</div>
            <div class="kpi-sub">Más de 5 pendientes</div>
        </div>
    `;
}

// ══════════════════════════════════════════════════════════════════════════════
// 2. SEMÁFORO DE COMPETENCIAS
// ══════════════════════════════════════════════════════════════════════════════
function renderSemaforo(data) {
    const { resumen, competencias } = data;

    document.getElementById('semVerde').textContent    = resumen.total_verdes;
    document.getElementById('semAmarillo').textContent = resumen.total_amarillos;
    document.getElementById('semRojo').textContent     = resumen.total_rojos;

    const list = document.getElementById('semaforoList');
    if (!competencias.length) {
        list.innerHTML = '<div class="loading-msg">Sin competencias registradas.</div>';
        return;
    }

    list.innerHTML = competencias.map(c => {
        const cls = c.estado.toLowerCase();
        return `
        <div class="sem-row">
            <div class="sem-dot ${cls}"></div>
            <div class="sem-nombre" title="${c.nombre_comp}">
                ${truncar(c.nombre_comp, 45)}
            </div>
            <div class="sem-bar-wrap">
                <div class="sem-bar ${cls}" style="width:${c.porcentaje_aprobacion}%"></div>
            </div>
            <div class="sem-pct ${cls}">${c.porcentaje_aprobacion}%</div>
        </div>`;
    }).join('');
}

// ══════════════════════════════════════════════════════════════════════════════
// 3. RANKING
// ══════════════════════════════════════════════════════════════════════════════
function renderRanking(data) {
    renderRankingList('rankingTop',  data.top10);
    renderRankingList('rankingBajo', data.menor_avance);
}

function renderRankingList(id, lista) {
    const el = document.getElementById(id);
    if (!lista.length) {
        el.innerHTML = '<div class="loading-msg">Sin datos.</div>';
        return;
    }

    el.innerHTML = lista.map((a, i) => {
        const posCls = i === 0 ? 'gold' : i === 1 ? 'silver' : i === 2 ? 'bronze' : '';
        const iniciales = ((a.nombres?.[0] ?? '?') + (a.apellidos?.[0] ?? '?')).toUpperCase();
        return `
        <div class="ranking-row">
            <div class="rank-pos ${posCls}">${a.posicion}</div>
            <div style="width:32px;height:32px;border-radius:50%;background:#eff6ff;
                color:#2563eb;display:flex;align-items:center;justify-content:center;
                font-weight:700;font-size:11px;flex-shrink:0;">${iniciales}</div>
            <div style="flex:1;min-width:0;">
                <div class="rank-name">${a.nombres} ${a.apellidos}</div>
                <div class="rank-ficha">Ficha ${a.numero_ficha} · ${a.aprobados}/${a.total_resultados} RA</div>
            </div>
            <div class="rank-pct">${a.porcentaje_avance}%</div>
        </div>`;
    }).join('');
}

function switchRanking(tipo, btn) {
    document.querySelectorAll('.rtab').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    document.getElementById('rankingTop').style.display  = tipo === 'top'  ? 'flex' : 'none';
    document.getElementById('rankingBajo').style.display = tipo === 'bajo' ? 'flex' : 'none';
}

// ══════════════════════════════════════════════════════════════════════════════
// 4. ALERTAS (sección completa + campana de notificaciones)
// ══════════════════════════════════════════════════════════════════════════════
function renderAlertas(data) {
    const badge = document.getElementById('alertaBadge');
    if (badge) badge.textContent = data.total;

    // ── Sección completa de abajo ───────────────────────────────────────────
    const el = document.getElementById('alertasList');
    if (el) {
        if (!data.alertas.length) {
            el.innerHTML = `<div class="alerta-empty">Sin alertas activas. Todo en orden.</div>`;
        } else {
            el.innerHTML = `<div class="alertas-grid">` +
                data.alertas.map(a => {
                    const iconSvg = a.nivel === 'CRITICAL' 
                        ? `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#dc2626" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M20 13c0 5-3.5 7.5-7.66 9.7a1 1 0 0 1-.68 0C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.8 17 5 19 5a1 1 0 0 1 1 1z"/><path d="M12 8v4"/><path d="M12 16h.01"/></svg>`
                        : `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#d97706" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>`;
                    return `
                    <div class="alerta-row ${a.nivel.toLowerCase()}">
                        <div class="alerta-icon" style="display:flex;align-items:center;justify-content:center;">${iconSvg}</div>
                        <div>
                            <div class="alerta-tipo">${a.tipo.replace(/_/g,' ')} · ${a.entidad}</div>
                            <div class="alerta-msg">${a.mensaje}</div>
                        </div>
                    </div>`;
                }).join('') +
                `</div>`;
        }
    }

    // ── Campana de notificaciones (estilo Facebook) ─────────────────────────
    renderNotifBell(data);
}

function renderNotifBell(data) {
    const badge  = document.getElementById('notifBadge');
    const bell   = document.getElementById('notifBellBtn');
    const list   = document.getElementById('notifList');
    const total  = document.getElementById('notifTotal');

    if (!badge) return; // no está en esta página

    if (data.total > 0) {
        badge.style.display = 'flex';
        badge.textContent   = data.total > 99 ? '99+' : data.total;
        bell.classList.add('has-alerts');
    } else {
        badge.style.display = 'none';
        bell.classList.remove('has-alerts');
    }

    total.textContent = `${data.total} alerta${data.total === 1 ? '' : 's'}`;

    // Lista del panel: máximo 10, con link "ver más" si hay más
    if (!data.alertas.length) {
        list.innerHTML = `<div class="notif-empty">Sin alertas activas.<br>Todo está en orden.</div>`;
        return;
    }

    const primeras10 = data.alertas.slice(0, 10);
    list.innerHTML = primeras10.map(a => {
        const iconSvg = a.nivel === 'CRITICAL' 
            ? `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#dc2626" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M20 13c0 5-3.5 7.5-7.66 9.7a1 1 0 0 1-.68 0C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.8 17 5 19 5a1 1 0 0 1 1 1z"/><path d="M12 8v4"/><path d="M12 16h.01"/></svg>`
            : `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#d97706" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>`;
        return `
        <div class="notif-item ${a.nivel.toLowerCase()}">
            <div class="notif-item-icon" style="display:flex;align-items:center;justify-content:center;">${iconSvg}</div>
            <div class="notif-item-body">
                <div class="notif-item-msg">${a.mensaje}</div>
                <div class="notif-item-meta">${a.tipo.replace(/_/g,' ')}</div>
            </div>
        </div>`;
    }).join('');

    if (data.alertas.length > 10) {
        list.innerHTML += `
        <div class="notif-ver-todas">
            <a href="alertas.php">Ver ${data.alertas.length - 10} alertas más →</a>
        </div>`;
    }
}

function toggleNotifPanel() {
    document.getElementById('notifPanel').classList.toggle('open');
}

function cerrarNotifPanel() {
    document.getElementById('notifPanel').classList.remove('open');
}

// ══════════════════════════════════════════════════════════════════════════════
// 5. ESTADÍSTICAS POR FICHA
// ══════════════════════════════════════════════════════════════════════════════
function renderTablaFichas() {
    const fichas = datosFichas;
    const tbody = document.getElementById('tablaFichasBody');
    if (!fichas.length) {
        tbody.innerHTML = '<tr><td colspan="7" class="td-empty">Sin fichas registradas.</td></tr>';
        document.getElementById('paginFichas').innerHTML = '';
        return;
    }
    const total = fichas.length;
    const start = (paginaFichas - 1) * ITEMS_PER_PAGE;
    const pageData = fichas.slice(start, start + ITEMS_PER_PAGE);

    tbody.innerHTML = pageData.map(f => {
        const clsAvance = colorPct(f.porcentaje_avance);
        const clsApro   = colorPct(f.porcentaje_aprobacion);
        return `
        <tr>
            <td><strong>${f.numero_ficha}</strong></td>
            <td style="max-width:220px;" title="${f.nombre_programa}">${truncar(f.nombre_programa, 40)}</td>
            <td style="text-align:center;">${f.total_aprendices}</td>
            <td style="text-align:center; color:var(--green); font-weight:600;">${f.total_aprobados}</td>
            <td style="text-align:center; color:var(--yellow); font-weight:600;">${f.total_pendientes}</td>
            <td>${barraProgreso(f.porcentaje_avance, clsAvance)}</td>
            <td>${barraProgreso(f.porcentaje_aprobacion, clsApro)}</td>
        </tr>`;
    }).join('');

    buildPagination('paginFichas', total, paginaFichas, (p) => { paginaFichas = p; renderTablaFichas(); });
}

// ══════════════════════════════════════════════════════════════════════════════
// 6. TABLA DETALLE DE RIESGO
// ══════════════════════════════════════════════════════════════════════════════
function renderTablaRiesgo(aprendices) {
    datosRiesgo = aprendices;
    paginaRiesgo = 1;
    aplicarFiltroRiesgo();
}

function filtrarRiesgo(nivel, btn) {
    filtroRiesgoActual = nivel;
    document.querySelectorAll('.risk-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    paginaRiesgo = 1;
    aplicarFiltroRiesgo();
}

function aplicarFiltroRiesgo() {
    const lista = filtroRiesgoActual === 'todos'
        ? datosRiesgo
        : datosRiesgo.filter(a => a.nivel_riesgo === filtroRiesgoActual);

    const tbody = document.getElementById('tablaRiesgoBody');
    if (!lista.length) {
        tbody.innerHTML = `<tr><td colspan="8" class="td-empty">Sin aprendices en este nivel.</td></tr>`;
        document.getElementById('paginRiesgo').innerHTML = '';
        return;
    }

    const total = lista.length;
    const start = (paginaRiesgo - 1) * ITEMS_PER_PAGE;
    const pageData = lista.slice(start, start + ITEMS_PER_PAGE);

    tbody.innerHTML = pageData.map(a => {
        const iniciales = ((a.nombres?.[0] ?? '?') + (a.apellidos?.[0] ?? '?')).toUpperCase();
        const cls = colorPct(a.porcentaje_avance);
        return `
        <tr>
            <td>
                <div style="display:flex;align-items:center;gap:10px;">
                    <div style="width:32px;height:32px;border-radius:50%;background:#eff6ff;
                        color:#2563eb;display:flex;align-items:center;justify-content:center;
                        font-weight:700;font-size:11px;flex-shrink:0;">${iniciales}</div>
                    <div>
                        <div style="font-weight:600;">${a.nombres} ${a.apellidos}</div>
                        <div style="font-size:11px;color:#94a3b8;font-family:'JetBrains Mono',monospace;">${a.numero_documento}</div>
                    </div>
                </div>
            </td>
            <td>${a.numero_ficha}</td>
            <td style="text-align:center;">${a.total_resultados}</td>
            <td style="text-align:center;color:var(--green);font-weight:600;">${a.aprobados}</td>
            <td style="text-align:center;color:var(--yellow);font-weight:600;">${a.pendientes}</td>
            <td>${barraProgreso(a.porcentaje_avance, cls)}</td>
            <td><span class="badge-riesgo riesgo-${a.nivel_riesgo}">${a.nivel_riesgo}</span></td>
            <td>
                <a href="detalle.php?documento=${a.numero_documento}"
                   style="color:var(--primary);font-weight:600;text-decoration:none;font-size:12px;">
                   Ver →
                </a>
            </td>
        </tr>`;
    }).join('');

    buildPagination('paginRiesgo', total, paginaRiesgo, (p) => { paginaRiesgo = p; aplicarFiltroRiesgo(); });
}

// Helper: construye paginación genérica
function buildPagination(containerId, total, currentPage, onPage) {
    const container = document.getElementById(containerId);
    if (!container) return;
    if (total <= ITEMS_PER_PAGE) { container.innerHTML = ''; return; }
    const totalPages = Math.ceil(total / ITEMS_PER_PAGE);
    let startPage = Math.max(1, currentPage - 2);
    let endPage = Math.min(totalPages, startPage + 4);
    if (endPage - startPage < 4) startPage = Math.max(1, endPage - 4);

    let btns = `<button class="page-btn-a" ${currentPage===1?'disabled':''} onclick="(${onPage.toString()})(${currentPage-1})">‹</button>`;
    for (let i = startPage; i <= endPage; i++) {
        btns += `<button class="page-btn-a ${currentPage===i?'active':''}" onclick="(${onPage.toString()})(${i})">${i}</button>`;
    }
    btns += `<button class="page-btn-a" ${currentPage===totalPages?'disabled':''} onclick="(${onPage.toString()})(${currentPage+1})">›</button>`;
    const s = (currentPage-1)*ITEMS_PER_PAGE+1;
    const e = Math.min(currentPage*ITEMS_PER_PAGE, total);
    btns += `<div class="page-info-a">${s}-${e} de ${total}</div>`;
    container.innerHTML = btns;
}

// ══════════════════════════════════════════════════════════════════════════════
// HELPERS
// ══════════════════════════════════════════════════════════════════════════════
function colorPct(pct) {
    if (pct >= 80) return 'verde';
    if (pct >= 50) return 'amarillo';
    return 'rojo';
}

function barraProgreso(pct, cls) {
    return `
    <div class="progress-cell">
        <div class="progress-bar-wrap">
            <div class="progress-bar ${cls}" style="width:${pct}%"></div>
        </div>
        <span class="progress-num" style="color:var(--${cls === 'verde' ? 'green' : cls === 'amarillo' ? 'yellow' : 'red'})">
            ${pct}%
        </span>
    </div>`;
}

function truncar(str, n) {
    return str && str.length > n ? str.substring(0, n) + '…' : (str ?? '');
}

function mostrarError(msg) {
    document.getElementById('kpiRiesgo').innerHTML =
        `<div style="grid-column:1/-1;padding:20px;color:#dc2626;text-align:center;">
            Error: ${msg}
        </div>`;
}