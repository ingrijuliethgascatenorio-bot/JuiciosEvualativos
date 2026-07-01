<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SGJE — Centro de Alertas</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <link rel="stylesheet" href="css/analytics.css">
    <style>
        /* ── Alertas page específico ── */
        .alertas-page-header {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 28px; flex-wrap: wrap; gap: 16px;
        }
        .alertas-kpi-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 28px;
        }
        .alerta-kpi {
            background: #fff; border-radius: var(--radius);
            border: 1px solid var(--border); padding: 20px 20px 18px;
            display: flex; align-items: center; gap: 14px;
            box-shadow: var(--shadow);
        }
        .alerta-kpi-icon {
            width: 44px; height: 44px; border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 20px; flex-shrink: 0;
        }
        .alerta-kpi-icon.total   { background: var(--blue-bg); }
        .alerta-kpi-icon.critica { background: var(--red-bg); }
        .alerta-kpi-icon.warning { background: var(--yellow-bg); }
        .alerta-kpi-icon.info    { background: #f0fdf4; }
        .alerta-kpi-num  { font-size: 30px; font-weight: 800; line-height: 1; }
        .alerta-kpi-num.total   { color: var(--primary); }
        .alerta-kpi-num.critica { color: var(--red); }
        .alerta-kpi-num.warning { color: var(--yellow); }
        .alerta-kpi-num.info    { color: var(--green); }
        .alerta-kpi-lbl { font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--text-muted); margin-top: 3px; }

        /* Filtros */
        .filtros-bar {
            background: #fff; border-radius: var(--radius);
            border: 1px solid var(--border); padding: 16px 20px;
            display: flex; gap: 12px; align-items: center; flex-wrap: wrap;
            margin-bottom: 20px; box-shadow: var(--shadow);
        }
        .filtro-btn {
            padding: 6px 16px; border-radius: 8px;
            border: 1.5px solid var(--border);
            font-family: inherit; font-size: 12px; font-weight: 600;
            cursor: pointer; background: #fff; color: var(--text-muted);
            transition: all .2s; display: flex; align-items: center; gap: 6px;
        }
        .filtro-btn.active        { background: var(--text-main); color: #fff; border-color: var(--text-main); }
        .filtro-btn.active.critica { background: var(--red);    border-color: var(--red); }
        .filtro-btn.active.warning { background: var(--yellow); border-color: var(--yellow); }
        .filtro-btn.active.info    { background: var(--green);  border-color: var(--green); }
        .filtro-sep { width: 1px; height: 24px; background: var(--border); }
        .filtros-bar select { border: 1.5px solid var(--border); border-radius: 8px; padding: 6px 12px; font-family: inherit; font-size: 12px; font-weight: 600; color: var(--text-muted); background: #fff; cursor: pointer; outline: none; }
        .filtros-bar select:focus { border-color: var(--primary); }

        /* Lista de alertas grande */
        .alertas-lista {
            display: flex; flex-direction: column; gap: 10px;
        }
        .alerta-card {
            background: #fff; border-radius: var(--radius);
            border: 1px solid var(--border);
            border-left: 4px solid var(--border);
            padding: 18px 20px;
            display: flex; align-items: flex-start; gap: 14px;
            box-shadow: var(--shadow);
            transition: transform .15s, box-shadow .15s;
        }
        .alerta-card:hover { transform: translateX(2px); box-shadow: 0 4px 12px rgba(0,0,0,.08); }
        .alerta-card.critical { border-left-color: var(--red); background: #fff8f8; }
        .alerta-card.warning  { border-left-color: var(--yellow); background: #fffdf0; }
        .alerta-card.info     { border-left-color: var(--primary); background: var(--blue-bg); }

        .alerta-card-icon {
            width: 40px; height: 40px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 18px; flex-shrink: 0; margin-top: 1px;
        }
        .alerta-card.critical .alerta-card-icon { background: var(--red-bg); }
        .alerta-card.warning  .alerta-card-icon { background: var(--yellow-bg); }
        .alerta-card.info     .alerta-card-icon { background: #dbeafe; }

        .alerta-card-body { flex: 1; min-width: 0; }
        .alerta-card-tipo {
            font-size: 10px; font-weight: 700; text-transform: uppercase;
            letter-spacing: .07em; margin-bottom: 4px;
        }
        .alerta-card.critical .alerta-card-tipo { color: var(--red); }
        .alerta-card.warning  .alerta-card-tipo { color: var(--yellow); }
        .alerta-card.info     .alerta-card-tipo { color: var(--primary); }

        .alerta-card-msg { font-size: 14px; font-weight: 500; color: var(--text-main); line-height: 1.5; }
        .alerta-card-action {
            flex-shrink: 0; align-self: center;
            color: var(--primary); font-size: 12px; font-weight: 700;
            text-decoration: none; white-space: nowrap;
            padding: 6px 14px; border-radius: 8px;
            border: 1.5px solid var(--primary);
            transition: all .2s;
        }
        .alerta-card-action:hover { background: var(--primary); color: #fff; }

        .alertas-empty {
            text-align: center; padding: 80px 40px;
            background: #fff; border-radius: var(--radius);
            border: 1px solid var(--border); box-shadow: var(--shadow);
            color: var(--text-muted);
        }
        .alertas-empty-icon { font-size: 48px; margin-bottom: 16px; }
        .alertas-empty h3 { font-size: 18px; color: var(--text-main); margin-bottom: 8px; }

        /* Pagination */
        .pagination-container { display: flex; align-items: center; justify-content: flex-end; gap: 8px; margin-top: 20px; }
        .page-btn { width: 36px; height: 36px; border-radius: 8px; border: 1px solid var(--border); background: #fff; color: var(--text-main); font-weight: 600; font-size: 14px; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.2s; font-family: inherit; }
        .page-btn:hover:not(:disabled) { border-color: #cbd5e1; background: #f8fafc; }
        .page-btn:disabled { opacity: 0.5; cursor: not-allowed; }
        .page-btn.active { background: var(--sidebar-bg); color: #fff; border-color: var(--sidebar-bg); }
        .page-info { font-size: 13px; color: var(--text-muted); font-weight: 500; margin-left: 12px; }

        #loadingState { text-align:center; padding:60px; color:var(--text-muted); }

        @media (max-width: 900px) {
            .alertas-kpi-row { grid-template-columns: repeat(2,1fr); }
        }
        @media (max-width: 600px) {
            .alertas-kpi-row { grid-template-columns: 1fr 1fr; }
            .alerta-card-action { display: none; }
        }
    </style>
</head>
<body>

<!-- ═══════════════════════ SIDEBAR ═══════════════════════ -->
<aside class="sidebar">
    <div class="sidebar-header">
        <div class="logo-box"><i data-lucide="bar-chart-3"></i></div>
        <span class="brand-name">SGJE</span>
    </div>
    <nav class="sidebar-nav">
        <div class="nav-label">Menú Principal</div>
        <a href="index.php" class="nav-item"><i data-lucide="layout-dashboard"></i> <span>Dashboard</span></a>
        <a href="aprendices.php" class="nav-item"><i data-lucide="users"></i> <span>Aprendices</span></a>
        <a href="analisis.php" class="nav-item"><i data-lucide="search"></i> <span>Análisis Proyecto</span></a>
        <a href="analytics.php" class="nav-item"><i data-lucide="brain-circuit"></i> <span>Inteligencia</span></a>
        <a href="alertas.php" class="nav-item active"><i data-lucide="bell-ring"></i> <span>Alertas</span></a>
        <div class="nav-label">Sistema</div>
        <a href="#" onclick="confirmReset()" class="nav-item" style="color: #ef4444;"><i data-lucide="trash-2"></i> <span>Limpiar Todo</span></a>
    </nav>
</aside>

<!-- ═══════════════════════ MAIN ═══════════════════════════ -->
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
            <div class="notif-wrap" id="notifWrap">
                <button class="notif-bell" id="notifBellBtn" onclick="toggleNotifPanel()" aria-label="Notificaciones">
                    <i data-lucide="bell"></i>
                    <span class="notif-badge" id="notifBadge" style="display:none;">0</span>
                </button>
                <div class="notif-panel" id="notifPanel">
                    <div class="notif-panel-header">
                        <span>Notificaciones</span>
                        <span class="notif-panel-total" id="notifTotal">—</span>
                    </div>
                    <div class="notif-panel-list" id="notifList">
                        <div class="loading-msg">Cargando…</div>
                    </div>
                    <div class="notif-panel-footer">
                        <a href="alertas.php">Ver todas las alertas →</a>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <div class="analytics-container">

        <!-- KPIs -->
        <div class="alertas-kpi-row" id="alertasKpi">
            <div class="alerta-kpi"><div class="alerta-kpi-icon total"><i data-lucide="bell" style="width:20px;height:20px;color:var(--primary);"></i></div><div><div class="alerta-kpi-num total" id="kpiTotal">—</div><div class="alerta-kpi-lbl">Total Alertas</div></div></div>
            <div class="alerta-kpi"><div class="alerta-kpi-icon critica"><i data-lucide="shield-alert" style="width:20px;height:20px;color:var(--red);"></i></div><div><div class="alerta-kpi-num critica" id="kpiCritica">—</div><div class="alerta-kpi-lbl">Críticas</div></div></div>
            <div class="alerta-kpi"><div class="alerta-kpi-icon warning"><i data-lucide="alert-triangle" style="width:20px;height:20px;color:var(--yellow);"></i></div><div><div class="alerta-kpi-num warning" id="kpiWarning">—</div><div class="alerta-kpi-lbl">Advertencias</div></div></div>
            <div class="alerta-kpi"><div class="alerta-kpi-icon info"><i data-lucide="info" style="width:20px;height:20px;color:var(--green);"></i></div><div><div class="alerta-kpi-num info" id="kpiInfo">—</div><div class="alerta-kpi-lbl">Informativas</div></div></div>
        </div>

        <!-- Filtros -->
        <div class="filtros-bar">
            <button class="filtro-btn active" data-filtro="todos" onclick="filtrar('todos',this)">Todas</button>
            <button class="filtro-btn critica" data-filtro="CRITICAL" onclick="filtrar('CRITICAL',this)">Críticas</button>
            <button class="filtro-btn warning" data-filtro="WARNING" onclick="filtrar('WARNING',this)">Advertencias</button>
            <div class="filtro-sep"></div>
            <button class="filtro-btn" data-filtro="RIESGO_ALTO"       onclick="filtrar('RIESGO_ALTO',this)">Riesgo Alto</button>
            <button class="filtro-btn" data-filtro="COMPETENCIA_ROJA"  onclick="filtrar('COMPETENCIA_ROJA',this)">Competencia Roja</button>
            <button class="filtro-btn" data-filtro="FICHA_BAJO_AVANCE" onclick="filtrar('FICHA_BAJO_AVANCE',this)">Ficha Bajo Avance</button>
        </div>

        <!-- Lista -->
        <div id="alertasLista">
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
let currentData = [];

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
            <div class="alerta-card ${cls}">
                <div class="alerta-card-icon" style="display:flex;align-items:center;justify-content:center;">${iconSvg}</div>
                <div class="alerta-card-body">
                    <div class="alerta-card-tipo">${tipo} · ${a.entidad}</div>
                    <div class="alerta-card-msg">${a.mensaje}</div>
                </div>
                <a href="${href}" class="alerta-card-action">${label}</a>
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
