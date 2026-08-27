<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SGJE — Gestión de Aprendices</title>

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
            <a href="aprendices.php" class="nav-item active"><i data-lucide="users"></i> <span>Aprendices</span></a>
            <a href="analisis.php" class="nav-item"><i data-lucide="search"></i> <span>Análisis</span></a>
            <a href="analytics.php" class="nav-item"><i data-lucide="brain-circuit"></i> <span>Analytics</span></a>
            <a href="alertas.php" class="nav-item"><i data-lucide="bell-ring"></i> <span>Alertas</span></a>
            <a href="index.php#uploadSection" class="nav-item"><i data-lucide="file-up"></i> <span>Carga Masiva</span></a>
            <div class="nav-label">Sistema</div>
            <a href="#" onclick="confirmReset()" class="nav-item" style="color: #ef4444;"><i data-lucide="trash-2"></i> <span>Limpiar Todo</span></a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <h1>Gestión de Aprendices</h1>
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
            
            <div class="card" style="margin-bottom: 8px;">
                <div class="card-header">Filtrar Aprendices</div>
                <div class="card-body">
                    <form id="aprendicesFilters" class="filters-grid">
                        <div class="filter-group">
                            <label>Ficha</label>
                            <div style="display:flex; gap:8px;">
                                <select id="ficha" name="ficha" class="filter-control">
                                    <option value="">Todas las fichas</option>
                                </select>
                                <button type="button" onclick="confirmDeleteFicha()" class="btn btn-danger" style="padding: 10px; width: 42px; height: 42px;" title="Eliminar ficha"><i data-lucide="trash-2" style="width: 16px; height: 16px;"></i></button>
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
                        <div class="filter-group" style="grid-column: span 2;">
                            <label>Buscar por nombre o documento</label>
                            <input type="text" id="search" name="search" class="filter-control" placeholder="Ej: 1000123456 o Juan Perez...">
                        </div>
                    </form>
                </div>
            </div>

            <div class="card">
                <div class="card-header">Listado de Aprendices</div>
                <div class="table-container">
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
                            <tr><td colspan="6" style="text-align: center; padding: 40px; color: #94a3b8;">Cargando aprendices...</td></tr>
                        </tbody>
                    </table>
                </div>
                <div id="paginationContainer" class="pagination-container"></div>
            </div>

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
                    const cleanState = (ap.estado || '').toLowerCase().replace(/ /g, '-');
                    const clsAvance = pct >= 80 ? 'verde' : pct >= 50 ? 'amarillo' : 'rojo';
                    tr.innerHTML = `
                        <td>
                            <div class="table-avatar-wrap">
                                <div class="table-avatar">${initials}</div>
                                <div class="table-user-name">${ap.nombres} ${ap.apellidos}</div>
                            </div>
                        </td>
                        <td style="font-family: 'JetBrains Mono'; font-size:13px;">${ap.numero_documento}</td>
                        <td>${ap.numero_ficha}</td>
                        <td><span class="status-pill ${cleanState}">${ap.estado}</span></td>
                        <td>
                            <div class="progress-cell">
                                <div class="progress-bar-wrap">
                                    <div class="progress-bar ${clsAvance}" style="width:${pct}%"></div>
                                </div>
                                <span class="progress-num" style="color:var(--${clsAvance === 'verde' ? 'success' : clsAvance === 'amarillo' ? 'warning' : 'danger'});">${pct}%</span>
                            </div>
                        </td>
                        <td><a href="detalle.php?documento=${ap.numero_documento}" class="table-link">Ver Perfil</a></td>
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
