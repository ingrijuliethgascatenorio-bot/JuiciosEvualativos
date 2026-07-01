<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SGJE — Análisis de Proyecto</title>

    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://unpkg.com/lucide@latest"></script>

    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --bg: #f1f5f9;
            --sidebar-bg: #0f172a;
            --primary: #2563eb;
            --primary-light: #eff6ff;
            --border: #e2e8f0;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --radius: 12px;
            --card-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
        }

        body { font-family: 'Outfit', sans-serif; background: var(--bg); display: flex; min-height: 100vh; color: var(--text-main); }
        .sidebar { width: 260px; background: var(--sidebar-bg); color: #fff; position: fixed; height: 100vh; display: flex; flex-direction: column; z-index: 1000; box-shadow: 4px 0 10px rgba(0,0,0,0.05); }
        .sidebar-header { padding: 32px 24px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid rgba(255,255,255,0.05); margin-bottom: 12px; }
        .logo-box { width: 36px; height: 36px; background: var(--primary); border-radius: 8px; display: flex; align-items: center; justify-content: center; color: #fff; }
        .brand-name { font-weight: 700; font-size: 20px; letter-spacing: -0.5px; color: #f8fafc; }
        
        .nav-label { font-size: 11px; font-weight: 600; color: #475569; text-transform: uppercase; letter-spacing: 0.1em; padding: 24px 24px 12px; }
        .nav-item { display: flex; align-items: center; gap: 12px; padding: 14px 24px; color: #94a3b8; text-decoration: none; font-weight: 500; transition: all 0.3s; margin: 0 12px; border-radius: 12px; }
        .nav-item:hover { background: #1e293b; color: #fff; }
        .nav-item.active { background: var(--primary); color: #fff; box-shadow: 0 4px 6px -1px rgba(37,99,235,0.2); }
        .nav-item i { width: 18px; height: 18px; }

        .main-content { flex: 1; margin-left: 260px; display: flex; flex-direction: column; }
        .topbar { background: #fff; padding: 24px 40px; border-bottom: 1px solid var(--border); position: sticky; top: 0; z-index: 900; }
        .topbar h1 { font-size: 22px; font-weight: 700; color: var(--text-main); }

        .container { padding: 40px; width: 100%; max-width: 1400px; margin: 0 auto; display: flex; flex-direction: column; gap: 32px; }

        .filters-card { background: #fff; border-radius: var(--radius); border: 1px solid var(--border); padding: 24px; display: flex; gap: 20px; align-items: flex-end; box-shadow: var(--card-shadow); }
        .filter-group { display: flex; flex-direction: column; gap: 8px; flex: 1; }
        .filter-group label { font-size: 11px; font-weight: 700; color: #94a3b8; text-transform: uppercase; }
        .filter-control { border: 1.5px solid var(--border); padding: 10px 14px; border-radius: 10px; font-family: inherit; font-size: 14px; outline: none; transition: border-color 0.2s; }
        .filter-control:focus { border-color: var(--primary); }

        .stats-row { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 24px; margin-bottom: 12px; }
        .stat-card { background: #fff; padding: 32px 24px; border-radius: var(--radius); border: 1px solid var(--border); text-align: center; box-shadow: var(--card-shadow); display: flex; flex-direction: column; align-items: center; justify-content: center; }
        .stat-val { font-size: 36px; font-weight: 800; color: var(--primary); line-height: 1; margin-bottom: 8px; }
        .stat-lbl { font-size: 11px; color: #94a3b8; text-transform: uppercase; font-weight: 700; letter-spacing: 0.1em; }
        .comp-card { background: #fff; border-radius: var(--radius); border: 1px solid var(--border); overflow: hidden; margin-bottom: 32px; box-shadow: var(--card-shadow); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); border-left: 4px solid var(--primary); }
        .comp-card:hover { transform: translateY(-4px); box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1); }
        .comp-header { padding: 24px; background: #fff; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: flex-start; gap: 16px; }
        .comp-title-box { display: flex; gap: 12px; }
        .comp-icon { width: 40px; height: 40px; background: var(--primary-light); color: var(--primary); border-radius: 10px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
        .comp-name { font-weight: 700; font-size: 15px; color: var(--text-main); line-height: 1.4; }
        
        .comp-pill { font-size: 11px; background: #f1f5f9; color: #475569; padding: 6px 14px; border-radius: 99px; font-weight: 700; border: 1px solid var(--border); white-space: nowrap; }
        
        table { width: 100%; border-collapse: collapse; }
        .clickable-row { cursor: pointer; transition: all 0.2s; border-bottom: 1px solid #f8fafc; }
        .clickable-row:hover { background: #f8faff; }
        .clickable-row:last-child { border-bottom: none; }
        
        .res-name { font-weight: 500; font-size: 13.5px; color: #334155; padding: 18px 24px; }
        .res-progress { padding: 18px 24px; }
        .res-stats { padding: 18px 24px; text-align: right; font-weight: 700; color: var(--text-main); font-size: 14px; }

        .progress-box { display: flex; align-items: center; gap: 12px; }
        .progress-bar { flex: 1; height: 8px; background: #f1f5f9; border-radius: 99px; overflow: hidden; }
        .progress-fill { height: 100%; background: linear-gradient(90deg, var(--primary), #60a5fa); transition: width 0.8s ease; }
        .progress-box span { font-size: 12px; font-weight: 700; color: var(--primary); min-width: 35px; }

        .expansion-row td { padding: 0 !important; }
        .expansion-content { background: #f8faff; padding: 24px; border-top: 1px solid #f1f5f9; border-bottom: 1px solid #f1f5f9; animation: slideDown 0.3s ease-out; }
        @keyframes slideDown { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }

        .apprentice-avatar { width: 32px; height: 32px; border-radius: 50%; background: #eff6ff; color: #2563eb; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 11px; }

        /* Pagination */
        .pagination-container { display: flex; align-items: center; justify-content: flex-end; gap: 8px; margin-top: 24px; }
        .page-btn { width: 36px; height: 36px; border-radius: 8px; border: 1px solid var(--border); background: #fff; color: var(--text-main); font-weight: 600; font-size: 14px; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.2s; font-family: inherit; }
        .page-btn:hover:not(:disabled) { border-color: #cbd5e1; background: #f8fafc; }
        .page-btn:disabled { opacity: 0.5; cursor: not-allowed; }
        .page-btn.active { background: #0f172a; color: #fff; border-color: #0f172a; }
        .page-info { font-size: 13px; color: var(--text-muted); font-weight: 500; margin-left: 12px; }

        @media (max-width: 1024px) { .sidebar { width: 80px; } .brand-name, .nav-item span, .nav-label { display: none; } .main-content { margin-left: 80px; } }
    </style>
</head>
<body>

    <aside class="sidebar">
    <div class="sidebar-header">
        <div class="logo-box"><i data-lucide="bar-chart-3"></i></div>
        <span class="brand-name">SGJE</span>
    </div>
    <nav class="sidebar-nav">
        <div class="nav-label">Menú Principal</div>
        <a href="index.php" class="nav-item"><i data-lucide="layout-dashboard"></i> <span>Dashboard</span></a>
        <a href="aprendices.php" class="nav-item"><i data-lucide="users"></i> <span>Aprendices</span></a>
        <a href="analisis.php" class="nav-item active"><i data-lucide="search"></i> <span>Análisis Proyecto</span></a>
        <a href="analytics.php" class="nav-item"><i data-lucide="brain-circuit"></i> <span>Inteligencia</span></a>
        <a href="alertas.php" class="nav-item"><i data-lucide="bell-ring"></i> <span>Alertas</span></a>
        <div class="nav-label">Sistema</div>
        <a href="#" onclick="confirmReset()" class="nav-item" style="color: #ef4444;"><i data-lucide="trash-2"></i> <span>Limpiar Todo</span></a>
    </nav>
</aside>

    <main class="main-content">
        <header class="topbar">
            <h1>Análisis de Proyecto</h1>
            <div id="notifWrap" style="position:relative;">
                <button onclick="toggleNotifPanel()" id="notifBellBtn" aria-label="Notificaciones"
                    style="width:38px;height:38px;border-radius:50%;background:#f1f5f9;border:1.5px solid #e2e8f0;display:flex;align-items:center;justify-content:center;cursor:pointer;position:relative;transition:all .2s;font-family:inherit;">
                    <i data-lucide="bell" id="bellIcon" style="width:18px;height:18px;color:#1e293b;"></i>
                    <span id="notifBadge" style="display:none;position:absolute;top:-4px;right:-4px;background:#dc2626;color:#fff;font-size:10px;font-weight:800;min-width:18px;height:18px;padding:0 4px;border-radius:99px;border:2px solid #fff;align-items:center;justify-content:center;line-height:1;">0</span>
                </button>
                <div id="notifPanel" style="position:absolute;top:calc(100% + 10px);right:0;width:360px;max-width:90vw;background:#fff;border-radius:14px;border:1px solid #e2e8f0;box-shadow:0 12px 28px rgba(0,0,0,.15);z-index:2000;opacity:0;visibility:hidden;transform:translateY(-8px) scale(.98);transition:opacity .18s,transform .18s,visibility .18s;overflow:hidden;">
                    <div style="padding:14px 18px;font-weight:700;font-size:15px;color:#1e293b;border-bottom:1px solid #e2e8f0;display:flex;align-items:center;justify-content:space-between;">
                        <span>Notificaciones</span>
                        <span id="notifTotal" style="font-size:11px;font-weight:600;color:#64748b;background:#f1f5f9;padding:3px 9px;border-radius:99px;">—</span>
                    </div>
                    <div id="notifList" style="max-height:380px;overflow-y:auto;">
                        <div style="text-align:center;padding:30px;color:#64748b;font-size:13px;">Cargando…</div>
                    </div>
                    <div style="padding:12px 18px;text-align:center;border-top:1px solid #e2e8f0;background:#f8fafc;">
                        <a href="alertas.php" style="color:#2563eb;font-weight:600;font-size:13px;text-decoration:none;">Ver todas las alertas →</a>
                    </div>
                </div>
            </div>
        </header>
        <div class="container">
            <div class="filters-card">
                <div class="filter-group" style="flex:1;">
                    <label>Ficha</label>
                    <select id="fichaFilter" class="filter-control"><option value="">Todas las fichas</option></select>
                </div>
                <div class="filter-group" style="flex:1;">
                    <label>Código de Competencia</label>
                    <input type="text" id="compFilter" class="filter-control" placeholder="Cód. competencia">
                </div>
                <div class="filter-group" style="flex:2;">
                    <label>Buscar Competencia o Resultado</label>
                    <input type="text" id="searchInput" class="filter-control" placeholder="Escribe para buscar...">
                </div>
            </div>
            <div class="stats-row">
                <div class="stat-card"><div class="stat-val" id="countComp">—</div><div class="stat-lbl">Competencias</div></div>
                <div class="stat-card"><div class="stat-val" id="countResul">—</div><div class="stat-lbl">Resultados</div></div>
                <div class="stat-card"><div class="stat-val" id="avgProgress">—%</div><div class="stat-lbl">Avance Global</div></div>
            </div>
            <div id="analysisContainer"></div>
            <div id="paginationContainer" class="pagination-container"></div>
        </div>
    </main>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const container = document.getElementById('analysisContainer');
            const fichaFilter = document.getElementById('fichaFilter');
            const searchInput = document.getElementById('searchInput');
            let fullData = [];
            let filteredData = [];
            let currentPage = 1;
            const itemsPerPage = 5;

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
                const competencia = document.getElementById('compFilter').value;
                container.innerHTML = '<div style="text-align:center; padding:60px;">Cargando análisis...</div>';
                const res = await fetch(`api.php?action=get_project_analysis&ficha=${ficha}&competencia=${competencia}`).then(r => r.json());
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
                        rows += `<tr class="clickable-row" onclick="toggleApprentices(this, '${res.codigo_resul}', '${res.nombre}')">
                            <td class="res-name">${res.nombre}</td>
                            <td class="res-progress">
                                <div class="progress-box">
                                    <div class="progress-bar"><div class="progress-fill" style="width:${pct}%"></div></div>
                                    <span>${pct}%</span>
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

                try {
                    const res = await fetch(`api.php?action=get_result_apprentices&codigo_resul=${codigo}&ficha=${ficha}`).then(r => r.json());
                    if (!res.length) {
                        content.innerHTML = '<div style="color:#94a3b8; font-size:13px;">No hay aprendices aprobados para este resultado.</div>';
                        return;
                    }
                    let html = '<div style="display:grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap:12px;">';
                    res.forEach(ap => {
                        const initials = (ap.nombres[0] + ap.apellidos[0]).toUpperCase();
                        html += `
                            <div style="display:flex; align-items:center; gap:10px; background:#fff; padding:10px; border-radius:10px; border:1px solid #e2e8f0; box-shadow:0 1px 2px rgba(0,0,0,0.05);">
                                <div class="apprentice-avatar" style="width:28px; height:28px; font-size:10px;">${initials}</div>
                                <div>
                                    <div style="font-weight:600; font-size:13px; color:var(--text-main); line-height:1.2;">${ap.nombres} ${ap.apellidos}</div>
                                    <div style="font-size:10px; color:#94a3b8;">${ap.numero_documento}</div>
                                </div>
                            </div>`;
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

            fichaFilter.addEventListener('change', loadAnalysis);
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

            loadFichas(); loadAnalysis();
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
                        list.innerHTML = `<div style="padding:40px 20px;text-align:center;color:#64748b;font-size:13px;">Sin alertas activas.</div>`;
                        return;
                    }
                    list.innerHTML = data.alertas.slice(0,10).map(a => {
                        const iconSvg = a.nivel === 'CRITICAL' 
                            ? `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#dc2626" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M20 13c0 5-3.5 7.5-7.66 9.7a1 1 0 0 1-.68 0C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.8 17 5 19 5a1 1 0 0 1 1 1z"/><path d="M12 8v4"/><path d="M12 16h.01"/></svg>`
                            : `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#d97706" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>`;
                        return `
                        <div style="display:flex;gap:12px;align-items:flex-start;padding:12px 18px;border-bottom:1px solid #f1f5f9;cursor:default;">
                            <div style="width:36px;height:36px;border-radius:50%;background:${a.nivel==='CRITICAL'?'#fef2f2':'#fffbeb'};display:flex;align-items:center;justify-content:center;flex-shrink:0;">${iconSvg}</div>
                            <div style="flex:1;min-width:0;">
                                <div style="font-size:13px;color:#1e293b;font-weight:500;line-height:1.45;">${a.mensaje}</div>
                                <div style="font-size:11px;color:#64748b;margin-top:3px;text-transform:uppercase;font-weight:600;">${a.tipo.replace(/_/g,' ')}</div>
                            </div>
                        </div>`;
                    }).join('');
                    if (data.alertas.length > 10)
                        list.innerHTML += `<div style="padding:12px;text-align:center;"><a href="alertas.php" style="color:#2563eb;font-weight:600;font-size:12px;text-decoration:none;">Ver ${data.alertas.length-10} alertas más →</a></div>`;
                } catch(_) {}
            })();

            function toggleNotifPanel() {
                const p = document.getElementById('notifPanel');
                const open = p.style.opacity === '1';
                p.style.opacity    = open ? '0'      : '1';
                p.style.visibility = open ? 'hidden' : 'visible';
                p.style.transform  = open ? 'translateY(-8px) scale(.98)' : 'translateY(0) scale(1)';
            }
            window.toggleNotifPanel = toggleNotifPanel;
            document.addEventListener('click', e => {
                const wrap = document.getElementById('notifWrap');
                const p    = document.getElementById('notifPanel');
                if (wrap && !wrap.contains(e.target)) {
                    p.style.opacity='0'; p.style.visibility='hidden';
                    p.style.transform='translateY(-8px) scale(.98)';
                }
            });
        });
    </script>
</body>
</html>
