<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SGJE — Centro de Alertas</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/analytics.css">
</head>
<body>

    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="logo-box"><i data-lucide="bar-chart-3"></i></div>
            <div>
                <span class="brand-name">SGJE</span>
                <span class="sidebar-desc">Juicios Evaluativos</span>
            </div>
        </div>
        <nav class="sidebar-nav">
            <div class="nav-label">Menú Principal</div>
            <a href="index.php" class="nav-item"><i data-lucide="layout-dashboard"></i> <span>Dashboard</span></a>
            <a href="aprendices.php" class="nav-item"><i data-lucide="users"></i> <span>Aprendices</span></a>
            <a href="analisis.php" class="nav-item"><i data-lucide="search"></i> <span>Análisis</span></a>
            <a href="analytics.php" class="nav-item"><i data-lucide="brain-circuit"></i> <span>Analytics</span></a>
            <a href="alertas.php" class="nav-item active"><i data-lucide="bell-ring"></i> <span>Alertas</span></a>
            <a href="index.php#uploadSection" class="nav-item"><i data-lucide="file-up"></i> <span>Carga Masiva</span></a>
            <div class="nav-label">Sistema</div>
            <a href="#" onclick="confirmReset()" class="nav-item" style="color: #ef4444;"><i data-lucide="trash-2"></i> <span>Limpiar Todo</span></a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <h1>Centro de Alertas</h1>
            <div class="topbar-actions">
                <select id="filtroFichaAlertas" class="form-control" style="width:180px;" onchange="cargarAlertas()">
                    <option value="">Todas las fichas</option>
                </select>
                <button onclick="cargarAlertas()" class="btn btn-primary">
                    <i data-lucide="refresh-cw" style="width:14px;height:14px;"></i> Actualizar
                </button>
                <!-- Campana -->
                <div class="notif-wrap-global" id="notifWrap">
                    <button class="notif-bell-btn-global" id="notifBellBtn" onclick="toggleNotifPanel()" aria-label="Notificaciones">
                        <i data-lucide="bell" id="bellIcon"></i>
                        <span class="notif-badge-global" id="notifBadge" style="display:none;">0</span>
                    </button>
                    <div class="notif-panel-global" id="notifPanel">
                        <div class="notif-panel-header-global">
                            <span>Notificaciones</span>
                            <span class="notif-panel-total-global" id="notifTotal">—</span>
                        </div>
                        <div class="notif-panel-list-global" id="notifList">
                            <div class="loading-msg">Cargando…</div>
                        </div>
                        <div class="notif-ver-todas">
                            <a href="alertas.php">Ver todas las alertas →</a>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <div class="container" style="display: flex; flex-direction: column; gap: 24px;">

            <!-- KPIs -->
            <div class="kpi-grid" id="alertasKpi">
                <div class="kpi-card kpi-total">
                    <div class="kpi-num" id="kpiTotal">—</div>
                    <div class="kpi-label">Total Alertas</div>
                    <div class="kpi-sub">Centro de alertas</div>
                </div>
                <div class="kpi-card kpi-alto">
                    <div class="kpi-num" id="kpiCritica">—</div>
                    <div class="kpi-label">Críticas</div>
                    <div class="kpi-sub">Acción urgente requerida</div>
                </div>
                <div class="kpi-card kpi-warning">
                    <div class="kpi-num" id="kpiWarning">—</div>
                    <div class="kpi-label">Advertencias</div>
                    <div class="kpi-sub">Atención recomendada</div>
                </div>
                <div class="kpi-card kpi-info">
                    <div class="kpi-num" id="kpiInfo">—</div>
                    <div class="kpi-label">Informativas</div>
                    <div class="kpi-sub">Seguimiento preventivo</div>
                </div>
            </div>

            <!-- Filtros -->
            <div class="card" style="margin-bottom: 0;">
                <div class="card-body" style="padding: 16px 20px;">
                    <div class="risk-filter-row" style="margin-bottom: 0; align-items: center;">
                        <button class="risk-btn active" data-filtro="todos" onclick="filtrar('todos',this)">Todas</button>
                        <button class="risk-btn btn-alto" data-filtro="CRITICAL" onclick="filtrar('CRITICAL',this)">Críticas</button>
                        <button class="risk-btn btn-medio" data-filtro="WARNING" onclick="filtrar('WARNING',this)">Advertencias</button>
                        <div style="width: 1px; height: 24px; background: var(--border); margin: 0 8px;"></div>
                        <button class="risk-btn" data-filtro="RIESGO_ALTO"       onclick="filtrar('RIESGO_ALTO',this)">Riesgo Alto</button>
                        <button class="risk-btn" data-filtro="COMPETENCIA_ROJA"  onclick="filtrar('COMPETENCIA_ROJA',this)">Competencia Roja</button>
                        <button class="risk-btn" data-filtro="FICHA_BAJO_AVANCE" onclick="filtrar('FICHA_BAJO_AVANCE',this)">Ficha Bajo Avance</button>
                    </div>
                </div>
            </div>

            <!-- Lista -->
            <div id="alertasLista" style="display: flex; flex-direction: column; gap: 12px;">
                <div id="loadingState" class="loading-msg">Cargando alertas…</div>
            </div>
            <div id="paginationContainer" class="pagination-container"></div>
        </div>
    </main>

<script>
let todasLasAlertas = [];
let filtroActual = 'todos';
let currentPage = 1;
const itemsPerPage = 10;

document.addEventListener('DOMContentLoaded', () => {
    lucide.createIcons();
    cargarFichas();
    cargarAlertas();

    // Cerrar panel al click fuera
    document.addEventListener('click', e => {
        const wrap = document.getElementById('notifWrap');
        if (wrap && !wrap.contains(e.target)) {
            document.getElementById('notifPanel').classList.remove('open');
        }
    });
});

async function cargarFichas() {
    try {
        const fichas = await fetch('api.php?action=get_fichas').then(r => r.json());
        const sel = document.getElementById('filtroFichaAlertas');
        fichas.forEach(f => {
            const o = document.createElement('option');
            o.value = f.numero_ficha;
            o.textContent = `Ficha ${f.numero_ficha}`;
            sel.appendChild(o);
        });
    } catch(_) {}
}

async function cargarAlertas() {
    const ficha = document.getElementById('filtroFichaAlertas').value;
    document.getElementById('alertasLista').innerHTML = '<div class="loading-msg" style="padding:60px;">Cargando alertas…</div>';

    try {
        const data = await fetch(`api_analytics.php?action=alertas&ficha=${encodeURIComponent(ficha)}`).then(r => r.json());
        todasLasAlertas = data.alertas || [];

        // KPIs
        document.getElementById('kpiTotal').textContent   = data.total    ?? 0;
        document.getElementById('kpiCritica').textContent = data.criticas  ?? 0;
        document.getElementById('kpiWarning').textContent = data.warnings  ?? 0;
        document.getElementById('kpiInfo').textContent    = data.info ?? (data.total - (data.criticas||0) - (data.warnings||0));

        // Campana
        renderCampana(data);

        aplicarFiltro();
    } catch(e) {
        document.getElementById('alertasLista').innerHTML = '<div class="loading-msg" style="color:var(--red);">Error al cargar alertas.</div>';
    }
}

function filtrar(tipo, btn) {
    filtroActual = tipo;
    document.querySelectorAll('.filtro-btn').forEach(b => {
        b.classList.remove('active');
        // Restaurar clase de color correcta
        if (b.dataset.filtro === 'CRITICAL') b.classList.add('critica');
        else if (b.dataset.filtro === 'WARNING') b.classList.add('warning');
    });
    btn.classList.add('active');
    aplicarFiltro();
}

function aplicarFiltro() {
    const lista = filtroActual === 'todos'
        ? todasLasAlertas
        : todasLasAlertas.filter(a =>
            a.nivel === filtroActual || a.tipo === filtroActual
          );
    currentData = lista;
    currentPage = 1;
    renderLista();
}

function renderLista() {
    const el = document.getElementById('alertasLista');
    if (!currentData.length) {
        el.innerHTML = `
        <div class="alertas-empty">
            <div class="alertas-empty-icon"><i data-lucide="check-circle" style="width:40px;height:40px;color:#059669;"></i></div>
            <h3>Sin alertas en esta categoría</h3>
            <p>Todo está en orden para el filtro seleccionado.</p>
        </div>`;
        document.getElementById('paginationContainer').innerHTML = '';
        lucide.createIcons();
        return;
    }

    const total = currentData.length;
    const start = (currentPage - 1) * itemsPerPage;
    const end   = start + itemsPerPage;
    const pageData = currentData.slice(start, end);

    el.innerHTML = `<div class="alertas-lista">` +
        pageData.map(a => {
            const cls  = a.nivel.toLowerCase();
            const tipo = a.tipo.replace(/_/g, ' ');
            const href = a.tipo === 'RIESGO_ALTO'
                ? `detalle.php?documento=${a.entidad_id}`
                : `analytics.php`;
            const label = a.tipo === 'RIESGO_ALTO' ? 'Ver aprendiz →' : 'Ver detalle →';
            const iconSvg = a.nivel === 'CRITICAL'
                ? `<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#dc2626" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M20 13c0 5-3.5 7.5-7.66 9.7a1 1 0 0 1-.68 0C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.8 17 5 19 5a1 1 0 0 1 1 1z"/><path d="M12 8v4"/><path d="M12 16h.01"/></svg>`
                : `<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#d97706" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>`;
            return `
            <div class="alerta-row ${cls}" style="width: 100%; display: flex; align-items: center; justify-content: space-between; border-left-width: 4px;">
                <div style="display: flex; gap: 16px; align-items: flex-start;">
                    <div class="alerta-icon" style="display:flex;align-items:center;justify-content:center; flex-shrink: 0; width: 40px; height: 40px; border-radius: 10px; background: var(--${cls === 'critical' ? 'danger-light' : cls === 'warning' ? 'warning-light' : 'info-light'});">${iconSvg}</div>
                    <div>
                        <div class="alerta-tipo" style="color: var(--${cls === 'critical' ? 'danger' : cls === 'warning' ? 'warning' : 'info'});">${tipo} · ${a.entidad}</div>
                        <div class="alerta-msg">${a.mensaje}</div>
                    </div>
                </div>
                <a href="${href}" class="btn btn-outline" style="font-size: 12px; padding: 6px 14px; white-space: nowrap; margin-left: 16px;">${label}</a>
            </div>`;
        }).join('') +
    `</div>`;

    // Paginación
    const container = document.getElementById('paginationContainer');
    if (total <= itemsPerPage) { container.innerHTML = ''; return; }
    const totalPages = Math.ceil(total / itemsPerPage);
    let startPage = Math.max(1, currentPage - 2);
    let endPage   = Math.min(totalPages, startPage + 4);
    if (endPage - startPage < 4) startPage = Math.max(1, endPage - 4);
    let html = `<button class="page-btn" ${currentPage===1?'disabled':''} onclick="goToPage(${currentPage-1})">‹</button>`;
    for (let i = startPage; i <= endPage; i++)
        html += `<button class="page-btn ${currentPage===i?'active':''}" onclick="goToPage(${i})">${i}</button>`;
    html += `<button class="page-btn" ${currentPage===totalPages?'disabled':''} onclick="goToPage(${currentPage+1})">›</button>`;
    html += `<div class="page-info">${(currentPage-1)*itemsPerPage+1}-${Math.min(currentPage*itemsPerPage,total)} de ${total}</div>`;
    container.innerHTML = html;
}

// ── Campana de notificaciones ─────────────────────────────────────────────────
function renderCampana(data) {
    const badge  = document.getElementById('notifBadge');
    const bell   = document.getElementById('notifBellBtn');
    const list   = document.getElementById('notifList');
    const total  = document.getElementById('notifTotal');

    if (data.total > 0) {
        badge.style.display = 'flex';
        badge.textContent   = data.total > 99 ? '99+' : data.total;
        bell.classList.add('has-alerts');
    } else {
        badge.style.display = 'none';
        bell.classList.remove('has-alerts');
    }

    total.textContent = `${data.total} alerta${data.total === 1 ? '' : 's'}`;

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

function goToPage(p) {
    currentPage = p;
    renderLista();
}

async function confirmReset() {
    const { isConfirmed } = await Swal.fire({
        title: '¿Limpiar sistema?',
        text: "Se eliminarán todos los aprendices y juicios.",
        icon: 'warning', showCancelButton: true,
        confirmButtonColor: '#ef4444', confirmButtonText: 'Sí, borrar todo'
    });
    if (isConfirmed) {
        const res = await fetch('api.php?action=delete_all').then(r => r.json());
        if (res.success) window.location.href = 'index.php';
    }
}
</script>
</body>
</html>
