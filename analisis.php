<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SGJE — Análisis de Proyecto</title>

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
            <a href="analisis.php" class="nav-item active"><i data-lucide="search"></i> <span>Análisis</span></a>
            <a href="analytics.php" class="nav-item"><i data-lucide="brain-circuit"></i> <span>Analytics</span></a>
            <a href="alertas.php" class="nav-item"><i data-lucide="bell-ring"></i> <span>Alertas</span></a>
            <a href="index.php#uploadSection" class="nav-item"><i data-lucide="file-up"></i> <span>Carga Masiva</span></a>
            <div class="nav-label">Sistema</div>
            <a href="#" onclick="confirmReset()" class="nav-item" style="color: #ef4444;"><i data-lucide="trash-2"></i> <span>Limpiar Todo</span></a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <h1>Análisis de Proyecto</h1>
            <div class="notif-wrap-global" id="notifWrap">
                <button onclick="toggleNotifPanel()" id="notifBellBtn" aria-label="Notificaciones" class="notif-bell-btn-global">
                    <i data-lucide="bell" id="bellIcon"></i>
                    <span id="notifBadge" class="notif-badge-global" style="display:none;">0</span>
                </button>
                <div id="notifPanel" class="notif-panel-global">
                    <div class="notif-panel-header-global">
                        <span>Notificaciones</span>
                        <span id="notifTotal" class="notif-panel-total-global">—</span>
                    </div>
                    <div id="notifList" class="notif-panel-list-global">
                        <div class="loading-msg">Cargando…</div>
                    </div>
                    <div class="notif-ver-todas">
                        <a href="alertas.php">Ver todas las alertas →</a>
                    </div>
                </div>
            </div>
        </header>
        <div class="container">
            <div class="card">
                <div class="card-header">Filtros de Análisis</div>
                <div class="card-body">
                    <div class="filters-grid">
                        <div class="filter-group">
                            <label>Ficha</label>
                            <select id="fichaFilter" class="filter-control"><option value="">Todas las fichas</option></select>
                        </div>
                        <div class="filter-group">
                            <label>Corte / Fecha del reporte</label>
                            <select id="fechaFilter" class="filter-control" disabled><option value="">Seleccione una ficha para consultar los cortes</option></select>
                        </div>
                        <div class="filter-group">
                            <label>Código de Competencia</label>
                            <input type="text" id="compFilter" class="filter-control" placeholder="Cód. competencia">
                        </div>
                        <div class="filter-group">
                            <label>Buscar Competencia o Resultado</label>
                            <input type="text" id="searchInput" class="filter-control" placeholder="Escribe para buscar...">
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-val" id="countComp">—</div>
                    <div class="stat-lbl">Competencias</div>
                </div>
                <div class="stat-card">
                    <div class="stat-val" id="countResul">—</div>
                    <div class="stat-lbl">Resultados</div>
                </div>
                <div class="stat-card" style="grid-column: span 2;">
                    <div class="stat-val" id="avgProgress">—%</div>
                    <div class="stat-lbl">Avance Global del Proyecto</div>
                </div>
            </div>
            <div id="analysisContainer"></div>
            <div id="paginationContainer" class="pagination-container"></div>
        </div>
    </main>

    <script>
        document.addEventListener('DOMContentLoaded', async () => {
            const container = document.getElementById('analysisContainer');
            const fichaFilter = document.getElementById('fichaFilter');
            const fechaFilter = document.getElementById('fechaFilter');
            const searchInput = document.getElementById('searchInput');
            let fullData = [];
            let filteredData = [];
            let currentPage = 1;
            const itemsPerPage = 5;

            function formatDateDisplay(dateStr) {
                if (!dateStr || dateStr.length < 10) return dateStr || '';
                const meses = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
                const parts = dateStr.substring(0, 10).split('-');
                if (parts.length === 3) {
                    const m = parseInt(parts[1], 10) - 1;
                    return `${parts[2]} ${meses[m] || parts[1]} ${parts[0]}`;
                }
                return dateStr;
            }

            const CONTEXTO_CORTE_KEY = 'sgje_contexto_corte';

            function guardarContextoCorte(ficha, fecha_reporte, seccionOrigen = 'analisis.php') {
                try {
                    const payload = {
                        ficha: ficha ? String(ficha) : '',
                        fecha_reporte: fecha_reporte ? String(fecha_reporte) : '',
                        seccionOrigen: seccionOrigen
                    };
                    sessionStorage.setItem(CONTEXTO_CORTE_KEY, JSON.stringify(payload));
                } catch (e) {
                    console.warn('No se pudo guardar contexto en sessionStorage:', e);
                }
            }

            function obtenerContextoCorte() {
                try {
                    const raw = sessionStorage.getItem(CONTEXTO_CORTE_KEY);
                    if (raw) return JSON.parse(raw);
                } catch (e) {
                    console.warn('No se pudo leer contexto de sessionStorage:', e);
                }
                return null;
            }

            async function actualizarFechasAnalisis(ficha, seleccionada = '') {
                if (!ficha) {
                    fechaFilter.disabled = true;
                    fechaFilter.innerHTML = '<option value="">Seleccione una ficha para consultar los cortes</option>';
                    return '';
                }

                fechaFilter.disabled = true;
                fechaFilter.innerHTML = '<option value="">Cargando cortes...</option>';

                try {
                    const res = await fetch(`api.php?action=get_fechas_ficha&ficha=${encodeURIComponent(ficha)}`).then(r => r.json());
                    if (Array.isArray(res) && res.length > 0) {
                        fechaFilter.innerHTML = '';
                        const fechaExiste = seleccionada && res.some(c => c.fecha_reporte === seleccionada);
                        const fechaElegida = fechaExiste ? seleccionada : res[0].fecha_reporte;

                        res.forEach((c, idx) => {
                            const opt = document.createElement('option');
                            opt.value = c.fecha_reporte;
                            opt.textContent = idx === 0 
                                ? `${formatDateDisplay(c.fecha_reporte)} — Último corte` 
                                : formatDateDisplay(c.fecha_reporte);
                            if (c.fecha_reporte === fechaElegida) opt.selected = true;
                            fechaFilter.appendChild(opt);
                        });

                        fechaFilter.value = fechaElegida;
                        fechaFilter.disabled = false;
                        return fechaElegida;
                    } else {
                        fechaFilter.innerHTML = '<option value="">Sin cortes registrados</option>';
                        fechaFilter.disabled = true;
                        return '';
                    }
                } catch(e) {
                    console.error('Error cargando fechas:', e);
                    fechaFilter.innerHTML = '<option value="">Error al cargar cortes</option>';
                    fechaFilter.disabled = true;
                    return '';
                }
            }

            async function loadFichas() {
                const res = await fetch('api.php?action=get_fichas').then(r => r.json());
                res.forEach(f => {
                    const opt = document.createElement('option');
                    opt.value = f.numero_ficha;
                    opt.textContent = `Ficha ${f.numero_ficha}`;
                    fichaFilter.appendChild(opt);
                });
            }

            async function loadAnalysis() {
                const ficha = fichaFilter.value;
                const fecha = fechaFilter ? fechaFilter.value : '';
                const competencia = document.getElementById('compFilter').value;
                container.innerHTML = '<div style="text-align:center; padding:60px;">Cargando análisis...</div>';
                const res = await fetch(`api.php?action=get_project_analysis&ficha=${encodeURIComponent(ficha)}&fecha_reporte=${encodeURIComponent(fecha)}&competencia=${encodeURIComponent(competencia)}`).then(r => r.json());
                fullData = res;
                filteredData = res;
                currentPage = 1;
                renderPage();
                updateStats(res);
            }

            function renderPage() {
                const data = filteredData.length > 0 || fullData.length === 0 ? filteredData : fullData;
                renderWithPagination(data);
            }

            function renderWithPagination(data) {
                if(!data.length) { container.innerHTML = '<div style="text-align:center; padding:40px;">No hay datos</div>'; document.getElementById('paginationContainer').innerHTML = ''; return; }
                const total = data.length;
                const start = (currentPage - 1) * itemsPerPage;
                const end = start + itemsPerPage;
                const pageData = data.slice(start, end);
                container.innerHTML = '';
                pageData.forEach(comp => {
                    let rows = '';
                    let conAvance = 0;
                    comp.resultados.forEach(res => {
                        if (res.aprobados > 0) conAvance++;
                        const pct = res.total > 0 ? Math.round((res.aprobados/res.total)*100) : 0;
                        const clsProg = pct >= 80 ? 'verde' : pct >= 50 ? 'amarillo' : 'rojo';
                        rows += `<tr class="clickable-row" onclick="toggleApprentices(this, '${res.codigo_resul}', '${res.nombre}')">
                            <td class="res-name">${res.nombre}</td>
                            <td class="res-progress">
                                <div class="progress-cell">
                                    <div class="progress-bar-wrap">
                                        <div class="progress-bar ${clsProg}" style="width:${pct}%"></div>
                                    </div>
                                    <span class="progress-num" style="color:var(--${clsProg === 'verde' ? 'success' : clsProg === 'amarillo' ? 'warning' : 'danger'});">${pct}%</span>
                                </div>
                            </td>
                            <td class="res-stats">${res.aprobados}/${res.total}</td>
                        </tr>`;
                    });
                    const card = document.createElement('div');
                    card.className = 'comp-card';
                    card.innerHTML = `
                        <div class="comp-header">
                            <div class="comp-title-box">
                                <div class="comp-icon"><i data-lucide="book-open"></i></div>
                                <div class="comp-name">${comp.nombre}</div>
                            </div>
                            <span class="comp-pill">${comp.resultados.length} Resultados (${conAvance} con Avance)</span>
                        </div>
                        <table>${rows}</table>`;
                    container.appendChild(card);
                });
                lucide.createIcons();
                renderPagination(total, data);
            }

            function renderPagination(total, data) {
                const container2 = document.getElementById('paginationContainer');
                if (total <= itemsPerPage) {
                    container2.innerHTML = '';
                    return;
                }
                const totalPages = Math.ceil(total / itemsPerPage);
                let html = `<button class="page-btn" ${currentPage === 1 ? 'disabled' : ''} onclick="goToPageA(${currentPage - 1})">&#8249;</button>`;
                
                let startPage = Math.max(1, currentPage - 2);
                let endPage = Math.min(totalPages, startPage + 4);
                if (endPage - startPage < 4) startPage = Math.max(1, endPage - 4);
                
                for (let i = startPage; i <= endPage; i++) {
                    html += `<button class="page-btn ${currentPage === i ? 'active' : ''}" onclick="goToPageA(${i})">${i}</button>`;
                }
                html += `<button class="page-btn" ${currentPage === totalPages ? 'disabled' : ''} onclick="goToPageA(${currentPage + 1})">&#8250;</button>`;
                
                const startItem = (currentPage - 1) * itemsPerPage + 1;
                const endItem = Math.min(currentPage * itemsPerPage, total);
                html += `<div class="page-info">${startItem}-${endItem} de ${total}</div>`;
                container2.innerHTML = html;
            }

            window.goToPageA = function(p) {
                currentPage = p;
                const data = filteredData.length > 0 || fullData.length === 0 ? filteredData : fullData;
                renderWithPagination(data);
            }

            window.toggleApprentices = async (row, codigo, nombre) => {
                const nextRow = row.nextElementSibling;
                if (nextRow && nextRow.classList.contains('expansion-row')) {
                    nextRow.remove();
                    return;
                }

                // Close other expansions if any (optional, but cleaner)
                // document.querySelectorAll('.expansion-row').forEach(r => r.remove());

                const expansionRow = document.createElement('tr');
                expansionRow.className = 'expansion-row';
                expansionRow.innerHTML = `<td colspan="3"><div class="expansion-content">Cargando aprendices...</div></td>`;
                row.after(expansionRow);

                const content = expansionRow.querySelector('.expansion-content');
                const ficha = fichaFilter.value;
                const fecha = fechaFilter ? fechaFilter.value : '';

                try {
                    const res = await fetch(`api.php?action=get_result_apprentices&codigo_resul=${codigo}&ficha=${encodeURIComponent(ficha)}&fecha_reporte=${encodeURIComponent(fecha)}`).then(r => r.json());
                    if (!res.length) {
                        content.innerHTML = '<div style="color:#94a3b8; font-size:13px;">No hay aprendices aprobados para este resultado.</div>';
                        return;
                    }
                    let html = '<div style="display:grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap:12px;">';
                    res.forEach(ap => {
                        const initials = (ap.nombres[0] + ap.apellidos[0]).toUpperCase();
                        const detalleUrl = `detalle.php?documento=${encodeURIComponent(ap.numero_documento)}&ficha=${encodeURIComponent(ficha)}&fecha_reporte=${encodeURIComponent(fecha)}&from=analisis.php`;
                        html += `
                            <a href="${detalleUrl}" style="text-decoration:none; color:inherit; display:flex; align-items:center; gap:10px; background:#fff; padding:10px; border-radius:10px; border:1px solid #e2e8f0; box-shadow:0 1px 2px rgba(0,0,0,0.05); transition:all 0.2s;" onmouseover="this.style.borderColor='var(--primary)'" onmouseout="this.style.borderColor='#e2e8f0'">
                                <div class="apprentice-avatar" style="width:28px; height:28px; font-size:10px;">${initials}</div>
                                <div style="flex:1; min-width:0;">
                                    <div style="font-weight:600; font-size:13px; color:var(--text-main); line-height:1.2; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">${ap.nombres} ${ap.apellidos}</div>
                                    <div style="font-size:10px; color:#94a3b8;">${ap.numero_documento}</div>
                                </div>
                                <span style="font-size:11px; color:var(--primary); font-weight:600;">Ver →</span>
                            </a>`;
                    });
                    html += '</div>';
                    content.innerHTML = `<div style="margin-bottom:12px; font-weight:700; font-size:11px; color:var(--primary); text-transform:uppercase; letter-spacing:0.05em;">Aprendices que ya aprobaron:</div>` + html;
                } catch(e) {
                    content.innerHTML = '<div style="color:#ef4444; font-size:13px;">Error al cargar la lista.</div>';
                }
            }

            function updateStats(data) {
                let totalRes = 0, sumPct = 0;
                data.forEach(c => {
                    totalRes += c.resultados.length;
                    c.resultados.forEach(r => { if(r.total > 0) sumPct += (r.aprobados/r.total); });
                });
                document.getElementById('countComp').textContent = data.length;
                document.getElementById('countResul').textContent = totalRes;
                document.getElementById('avgProgress').textContent = totalRes > 0 ? Math.round((sumPct/totalRes)*100)+'%' : '0%';
            }

            fichaFilter.addEventListener('change', async () => {
                const fichaVal = fichaFilter.value;
                if (fechaFilter) {
                    fechaFilter.disabled = true;
                    fechaFilter.innerHTML = '<option value="">Cargando cortes...</option>';
                }
                const fechaCargada = await actualizarFechasAnalisis(fichaVal);
                guardarContextoCorte(fichaVal, fechaCargada || '', 'analisis.php');
                await loadAnalysis();
            });

            fechaFilter.addEventListener('change', async () => {
                guardarContextoCorte(fichaFilter.value, fechaFilter.value, 'analisis.php');
                await loadAnalysis();
            });

            document.getElementById('compFilter').addEventListener('input', () => {
                clearTimeout(this.ct);
                this.ct = setTimeout(loadAnalysis, 500);
            });
            searchInput.addEventListener('input', () => {
                const term = searchInput.value.toLowerCase();
                const filtered = fullData.filter(c => c.nombre.toLowerCase().includes(term) || c.resultados.some(r => r.nombre.toLowerCase().includes(term)));
                filteredData = filtered;
                currentPage = 1;
                renderPage();
            });

            // REGLA 4: Inicialización con prioridad de contexto
            await loadFichas();
            const urlParams = new URLSearchParams(window.location.search);
            const ctx = obtenerContextoCorte();

            let fichaInicial = '';
            if (urlParams.has('ficha')) {
                fichaInicial = urlParams.get('ficha') || '';
            } else if (ctx && ctx.ficha) {
                fichaInicial = ctx.ficha;
            }

            let fechaInicial = '';
            if (urlParams.has('fecha_reporte')) {
                fechaInicial = urlParams.get('fecha_reporte') || '';
            } else if (ctx && ctx.fecha_reporte && (!fichaInicial || ctx.ficha === fichaInicial)) {
                fechaInicial = ctx.fecha_reporte;
            }

            if (fichaInicial && fichaFilter) {
                if (!Array.from(fichaFilter.options).some(o => o.value === String(fichaInicial))) {
                    const opt = document.createElement('option');
                    opt.value = fichaInicial;
                    opt.textContent = `Ficha ${fichaInicial}`;
                    fichaFilter.appendChild(opt);
                }
                fichaFilter.value = fichaInicial;
                const fechaFinal = await actualizarFechasAnalisis(fichaInicial, fechaInicial);
                guardarContextoCorte(fichaInicial, fechaFinal || '', 'analisis.php');
            } else {
                await actualizarFechasAnalisis('');
            }

            await loadAnalysis();
            lucide.createIcons();

            // Campana
            (async function() {
                try {
                    const data = await fetch('api_analytics.php?action=alertas').then(r => r.json());
                    const badge = document.getElementById('notifBadge');
                    if (data.total > 0) {
                        badge.style.display = 'flex';
                        badge.textContent   = data.total > 99 ? '99+' : data.total;
                        document.getElementById('bellIcon').style.color = '#dc2626';
                    }
                    document.getElementById('notifTotal').textContent = `${data.total} alerta${data.total===1?'':'s'}`;
                    const list = document.getElementById('notifList');
                    if (!data.alertas || !data.alertas.length) {
                        list.innerHTML = `<div class="notif-empty">Sin alertas activas.</div>`;
                        return;
                    }
                    list.innerHTML = data.alertas.slice(0,10).map(a => {
                        const iconSvg = a.nivel === 'CRITICAL' 
                            ? `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#dc2626" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M20 13c0 5-3.5 7.5-7.66 9.7a1 1 0 0 1-.68 0C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.8 17 5 19 5a1 1 0 0 1 1 1z"/><path d="M12 8v4"/><path d="M12 16h.01"/></svg>`
                            : `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#d97706" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>`;
                        const cls = a.nivel === 'CRITICAL' ? 'critical' : 'warning';
                        return `
                        <div class="notif-item ${cls}">
                            <div class="notif-item-icon">${iconSvg}</div>
                            <div class="notif-item-body">
                                <div class="notif-item-msg">${a.mensaje}</div>
                                <div class="notif-item-meta">${a.tipo.replace(/_/g,' ')}</div>
                            </div>
                        </div>`;
                    }).join('');
                    if (data.alertas.length > 10) {
                        list.innerHTML += `
                        <div class="notif-ver-todas">
                            <a href="alertas.php">Ver ${data.alertas.length-10} alertas más →</a>
                        </div>`;
                    }
                } catch(_) {}
            })();

            function toggleNotifPanel() {
                document.getElementById('notifPanel').classList.toggle('open');
            }
            window.toggleNotifPanel = toggleNotifPanel;
            document.addEventListener('click', e => {
                const wrap = document.getElementById('notifWrap');
                const p    = document.getElementById('notifPanel');
                if (wrap && !wrap.contains(e.target)) {
                    p.classList.remove('open');
                }
            });
        });
    </script>
</body>
</html>
