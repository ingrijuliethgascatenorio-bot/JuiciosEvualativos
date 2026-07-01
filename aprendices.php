<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SGJE — Gestión de Aprendices</title>

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

        /* Main */
        .main-content { flex: 1; margin-left: 260px; display: flex; flex-direction: column; }
        .topbar { background: #fff; padding: 24px 40px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 900; }
        .topbar h1 { font-size: 22px; font-weight: 700; color: var(--text-main); }
        .container { padding: 40px; width: 100%; max-width: 1400px; margin: 0 auto; }
        .filters-card { background: #fff; border-radius: var(--radius); border: 1px solid var(--border); padding: 24px; margin-bottom: 32px; box-shadow: var(--card-shadow); }
        .filters-grid { display: flex; gap: 20px; align-items: flex-end; flex-wrap: wrap; }
        .filter-group { display: flex; flex-direction: column; gap: 8px; flex: 1; min-width: 150px; }
        .filter-group label { font-size: 11px; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.05em; }
        .filter-control { background: #fff; border: 1.5px solid var(--border); border-radius: 10px; padding: 10px 14px; font-size: 14px; font-family: inherit; outline: none; transition: border-color 0.2s; color: var(--text-main); width: 100%; }
        .filter-control:focus { border-color: var(--primary); }

        /* Table Card */
        .table-card { background: #fff; border-radius: var(--radius); border: 1px solid var(--border); overflow: hidden; box-shadow: var(--card-shadow); }
        table { width: 100%; border-collapse: collapse; }
        th { background: #f8faff; padding: 16px 24px; text-align: left; font-size: 11px; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 1px solid var(--border); }
        td { padding: 20px 24px; border-bottom: 1px solid var(--border); font-size: 14px; color: #475569; }
        tr:last-child td { border-bottom: none; }

        .avatar { width: 36px; height: 36px; border-radius: 50%; background: #eff6ff; color: #2563eb; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 12px; }
        .status-pill { padding: 6px 12px; border-radius: 99px; font-size: 11px; font-weight: 700; background: #eff6ff; color: #3b82f6; text-transform: uppercase; }
        .btn-link { color: #2563eb; text-decoration: none; font-weight: 600; font-size: 13px; transition: color 0.2s; }
        .btn-link:hover { color: #1d4ed8; text-decoration: underline; }

        .delete-btn { width: 36px; height: 36px; background: #fff; border: 1.5px solid #fee2e2; border-radius: 10px; color: #ef4444; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.2s; }
        .delete-btn:hover { background: #ef4444; color: #fff; }
        .delete-btn i { width: 16px; height: 16px; }

        /* Pagination */
        .pagination-container { display: flex; align-items: center; justify-content: flex-end; gap: 8px; margin-top: 20px; }
        .page-btn { width: 36px; height: 36px; border-radius: 8px; border: 1px solid var(--border); background: #fff; color: var(--text-main); font-weight: 600; font-size: 14px; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.2s; font-family: inherit; }
        .page-btn:hover:not(:disabled) { border-color: #cbd5e1; background: #f8fafc; }
        .page-btn:disabled { opacity: 0.5; cursor: not-allowed; }
        .page-btn.active { background: var(--sidebar-bg); color: #fff; border-color: var(--sidebar-bg); }
        .page-info { font-size: 13px; color: var(--text-muted); font-weight: 500; margin-left: 12px; }

        @media (max-width: 1100px) {
            .sidebar { width: 80px; }
            .brand-name, .nav-item span, .nav-label { display: none; }
            .main-content { margin-left: 80px; }
            .nav-item { justify-content: center; margin: 4px 8px; }
        }
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
        <a href="aprendices.php" class="nav-item active"><i data-lucide="users"></i> <span>Aprendices</span></a>
        <a href="analisis.php" class="nav-item"><i data-lucide="search"></i> <span>Análisis Proyecto</span></a>
        <a href="analytics.php" class="nav-item"><i data-lucide="brain-circuit"></i> <span>Inteligencia</span></a>
        <a href="alertas.php" class="nav-item"><i data-lucide="bell-ring"></i> <span>Alertas</span></a>
        <div class="nav-label">Sistema</div>
        <a href="#" onclick="confirmReset()" class="nav-item" style="color: #ef4444;"><i data-lucide="trash-2"></i> <span>Limpiar Todo</span></a>
    </nav>
</aside>

    <main class="main-content">
        <header class="topbar">
            <h1>Gestión de Aprendices</h1>
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
                <form id="aprendicesFilters" class="filters-grid">
                    <div class="filter-group">
                        <label>Ficha</label>
                        <div style="display:flex; gap:8px;">
                            <select id="ficha" name="ficha" class="filter-control">
                                <option value="">Todas las fichas</option>
                            </select>
                            <button type="button" onclick="confirmDeleteFicha()" class="delete-btn" title="Eliminar ficha"><i data-lucide="trash-2"></i></button>
                        </div>
                    </div>
                    <div class="filter-group">
                        <label>Estado</label>
                        <select id="estado" name="estado" class="filter-control">
                            <option value="">Todos</option>
                            <option value="EN FORMACIÓN">En Formación</option>
                            <option value="RETIRO VOLUNTARIO">Retirado</option>
                            <option value="TRASLADADO">Trasladado</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label>Juicio</label>
                        <select id="juicio" name="juicio" class="filter-control">
                            <option value="">Todos</option>
                            <option value="APROBADO">Aprobado</option>
                            <option value="POR EVALUAR">Por Evaluar</option>
                        </select>
                    </div>
                    <div class="filter-group" style="flex: 2;">
                        <label>Buscar por nombre o documento</label>
                        <input type="text" id="search" name="search" class="filter-control" placeholder="Ej: 1000123456 o Juan Perez...">
                    </div>
                </form>
            </div>

            <div class="table-card">
                <table id="aprendicesTable">
                    <thead>
                        <tr>
                            <th>Aprendiz</th>
                            <th>Documento</th>
                            <th>Ficha</th>
                            <th>Estado</th>
                            <th>Avance</th>
                            <th>Acción</th>
                        </tr>
                    </thead>
                    <tbody id="tableBody">
                        <tr><td colspan="6" style="text-align: center; padding: 60px; color: #94a3b8;">Cargando aprendices...</td></tr>
                    </tbody>
                </table>
            </div>
            
            <div id="paginationContainer" class="pagination-container"></div>

        </div>
    </main>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const filtersForm = document.getElementById('aprendicesFilters');
            const tableBody = document.getElementById('tableBody');

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

            async function loadFichas() {
                try {
                    const res = await fetch('api.php?action=get_fichas');
                    const fichas = await res.json();
                    const select = document.getElementById('ficha');
                    fichas.forEach(f => {
                        const opt = document.createElement('option');
                        opt.value = f.numero_ficha;
                        opt.textContent = `Ficha ${f.numero_ficha}`;
                        select.appendChild(opt);
                    });
                } catch(e) {}
            }

            let currentData = [];
            let currentPage = 1;
            const itemsPerPage = 10;

            async function fetchData() {
                const formData = new FormData(filtersForm);
                const params = new URLSearchParams(formData).toString();
                tableBody.innerHTML = '<tr><td colspan="6" style="text-align: center; padding: 40px; color: #94a3b8;">Buscando aprendices...</td></tr>';
                document.getElementById('paginationContainer').innerHTML = '';
                
                try {
                    const res = await fetch(`api.php?action=get_all_aprendices&${params}`);
                    currentData = await res.json();
                    currentPage = 1;
                    renderTable();
                } catch(e) {
                    tableBody.innerHTML = '<tr><td colspan="6" style="text-align: center; color: #ef4444;">Error al cargar datos</td></tr>';
                }
            }

            function renderTable() {
                if(currentData.length === 0) {
                    tableBody.innerHTML = '<tr><td colspan="6" style="text-align: center; padding: 40px;">No se encontraron resultados</td></tr>';
                    document.getElementById('paginationContainer').innerHTML = '';
                    return;
                }
                
                const total = currentData.length;
                const start = (currentPage - 1) * itemsPerPage;
                const end = start + itemsPerPage;
                const pageData = currentData.slice(start, end);
                
                tableBody.innerHTML = '';
                pageData.forEach(ap => {
                    const tr = document.createElement('tr');
                    const initials = ((ap.nombres||'?')[0]+(ap.apellidos||'?')[0]).toUpperCase();
                    const pct = ap.total > 0 ? ((ap.aprobados / ap.total) * 100).toFixed(2) : 0;
                    tr.innerHTML = `
                        <td>
                            <div style="display:flex; align-items:center; gap:12px;">
                                <div class="avatar">${initials}</div>
                                <div style="font-weight:600; color:var(--text-main);">${ap.nombres} ${ap.apellidos}</div>
                            </div>
                        </td>
                        <td style="font-family: 'JetBrains Mono'; font-size:13px;">${ap.numero_documento}</td>
                        <td>${ap.numero_ficha}</td>
                        <td><span class="status-pill">${ap.estado}</span></td>
                        <td>
                            <div style="display:flex; align-items:center; gap:8px;">
                                <div style="width:60px; height:6px; background:#f1f5f9; border-radius:10px; overflow:hidden;">
                                    <div style="width:${pct}%; height:100%; background:#2563eb;"></div>
                                </div>
                                <span style="font-size:12px; font-weight:700; color:var(--text-main);">${pct}%</span>
                            </div>
                        </td>
                        <td><a href="detalle.php?documento=${ap.numero_documento}" class="btn-link">Ver Perfil →</a></td>
                    `;
                    tableBody.appendChild(tr);
                });
                
                renderPagination(total);
            }

            function renderPagination(total) {
                const container = document.getElementById('paginationContainer');
                if (total <= itemsPerPage) {
                    container.innerHTML = '';
                    return;
                }
                const totalPages = Math.ceil(total / itemsPerPage);
                let html = `<button class="page-btn" ${currentPage === 1 ? 'disabled' : ''} onclick="goToPage(${currentPage - 1})">‹</button>`;
                
                // Show max 5 pages around current
                let startPage = Math.max(1, currentPage - 2);
                let endPage = Math.min(totalPages, startPage + 4);
                if (endPage - startPage < 4) startPage = Math.max(1, endPage - 4);
                
                for (let i = startPage; i <= endPage; i++) {
                    html += `<button class="page-btn ${currentPage === i ? 'active' : ''}" onclick="goToPage(${i})">${i}</button>`;
                }
                html += `<button class="page-btn" ${currentPage === totalPages ? 'disabled' : ''} onclick="goToPage(${currentPage + 1})">›</button>`;
                
                const startItem = (currentPage - 1) * itemsPerPage + 1;
                const endItem = Math.min(currentPage * itemsPerPage, total);
                html += `<div class="page-info">${startItem}-${endItem} de ${total}</div>`;
                
                container.innerHTML = html;
            }

            window.goToPage = function(p) {
                currentPage = p;
                renderTable();
            }

            filtersForm.addEventListener('change', fetchData);
            document.getElementById('search').addEventListener('input', () => {
                clearTimeout(this.st);
                this.st = setTimeout(fetchData, 400);
            });


            loadFichas();
            fetchData();
            lucide.createIcons();
        });

        async function confirmDeleteFicha() {
            const f = document.getElementById('ficha').value;
            if(!f) { Swal.fire('Atención', 'Selecciona una ficha para eliminar', 'info'); return; }
            const { isConfirmed } = await Swal.fire({
                title: '¿Eliminar ficha?',
                text: `Se borrarán todos los datos de la ficha ${f}.`,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#ef4444',
                confirmButtonText: 'Sí, eliminar'
            });
            if(isConfirmed) {
                const res = await fetch(`api.php?action=delete_ficha&ficha=${f}`).then(r => r.json());
                if(res.success) Swal.fire('Éxito', res.message, 'success').then(() => location.reload());
            }
        }
    </script>
</body>
</html>
