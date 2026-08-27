<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SGJE — Dashboard Administrativo</title>

    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
            <a href="index.php" class="nav-item active"><i data-lucide="layout-dashboard"></i> <span>Dashboard</span></a>
            <a href="aprendices.php" class="nav-item"><i data-lucide="users"></i> <span>Aprendices</span></a>
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
            <h1>Panel de Control</h1>
            <div style="display:flex;align-items:center;gap:12px;">
                <!-- Campana de notificaciones -->
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
            </div>
        </header>

        <div class="container">
            
            <div class="upload-strip" id="uploadSection">
                <div style="display: flex; align-items: center; gap: 16px;">
                    <div class="upload-icon"><i data-lucide="file-up"></i></div>
                    <div class="upload-info">
                        <h2>Actualización de Datos</h2>
                        <p>Sube el reporte de SOFIA Plus para sincronizar los juicios evaluativos.</p>
                    </div>
                </div>
                <form id="uploadForm" action="upload.php" method="POST" enctype="multipart/form-data" style="display: flex; gap: 12px; align-items: center;">
                    <input type="file" name="archivo" id="archivo" accept=".csv,.xlsx,.xls" style="display: none;">
                    <label for="archivo" id="fileLabel" class="btn btn-outline" style="cursor: pointer; min-width: 180px; text-align: center;">Seleccionar reporte</label>
                    <button type="submit" class="btn btn-primary">Procesar</button>
                </form>
            </div>

            <div class="card">
                <div class="card-header">Filtros de Búsqueda</div>
                <div class="card-body">
                    <form id="filtersForm" class="filters-grid">
                        <div class="form-group">
                            <label>Número de Ficha</label>
                            <input type="text" name="ficha" id="ficha" class="form-control" placeholder="Ej: 2501234">
                        </div>
                        <div class="form-group">
                            <label>Estado Aprendiz</label>
                            <select name="estado" id="estado" class="form-control">
                                <option value="">Todos</option>
                                <option value="EN FORMACIÓN">En Formación</option>
                                <option value="RETIRO VOLUNTARIO">Retiro Voluntario</option>
                                <option value="TRASLADADO">Trasladado</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Juicio</label>
                            <select name="juicio" id="juicio" class="form-control">
                                <option value="">Todos</option>
                                <option value="APROBADO">Aprobado</option>
                                <option value="POR EVALUAR">Por Evaluar</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <button type="submit" class="btn btn-primary" style="width: 100%;">Aplicar Filtros</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-val" id="totalAprendices">—</div>
                    <div class="stat-lbl">Aprendices</div>
                </div>
                <div class="stat-card">
                    <div class="stat-val" id="juiciosAprobados">—</div>
                    <div class="stat-lbl">Aprobados</div>
                </div>
                <div class="stat-card">
                    <div class="stat-val" id="juiciosPorEvaluar">—</div>
                    <div class="stat-lbl">Pendientes</div>
                </div>
                <div class="stat-card">
                    <div class="stat-val" id="avanceGeneral">—%</div>
                    <div class="stat-lbl">Avance General</div>
                </div>
            </div>

            <div class="charts-grid">
                <div class="card">
                    <div class="card-header">Distribución por Estado</div>
                    <div class="card-body"><div class="chart-wrap"><canvas id="chartEstados"></canvas></div></div>
                </div>
                <div class="card">
                    <div class="card-header">Cumplimiento de Juicios</div>
                    <div class="card-body"><div class="chart-wrap"><canvas id="chartJuicios"></canvas></div></div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">Detalle de Registros</div>
                <div class="table-container">
                    <table id="dataTable">
                        <thead>
                            <tr>
                                <th>Aprendiz</th>
                                <th>Ficha</th>
                                <th>Competencia</th>
                                <th>Resultado</th>
                                <th>Juicio</th>
                                <th>Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td colspan="6" style="text-align: center; padding: 40px; color: #94a3b8;">Sin datos registrados</td></tr>
                        </tbody>
                    </table>
                </div>
                <div id="tablePagination" class="pagination-bar"></div>
            </div>

        </div>
    </main>

    <script src="js/main.js"></script>
    <script>
        lucide.createIcons();

        // ── Campana de notificaciones ────────────────────────────────────────
        (async function initCampana() {
            try {
                const data = await fetch('api_analytics.php?action=alertas').then(r => r.json());
                const badge = document.getElementById('notifBadge');
                const bell  = document.getElementById('notifBellBtn');
                const list  = document.getElementById('notifList');
                const total = document.getElementById('notifTotal');

                if (data.total > 0) {
                    badge.style.display = 'flex';
                    badge.textContent   = data.total > 99 ? '99+' : data.total;
                    document.getElementById('bellIcon').style.color = '#dc2626';
                }
                total.textContent = `${data.total} alerta${data.total === 1 ? '' : 's'}`;

                if (!data.alertas || !data.alertas.length) {
                    list.innerHTML = `<div style="padding:40px 20px;text-align:center;color:#64748b;font-size:13px;">Sin alertas activas.</div>`;
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
        document.addEventListener('click', e => {
            const wrap = document.getElementById('notifWrap');
            const p    = document.getElementById('notifPanel');
            if (wrap && !wrap.contains(e.target)) {
                p.classList.remove('open');
            }
        });

        async function confirmReset() {
            const { isConfirmed } = await Swal.fire({
                title: '¿Limpiar sistema?',
                text: "Se eliminarán todos los aprendices y juicios.",
                icon: 'warning', showCancelButton: true,
                confirmButtonColor: '#ef4444', confirmButtonText: 'Sí, borrar todo'
            });
            if(isConfirmed) {
                const res = await fetch('api.php?action=delete_all').then(r => r.json());
                if(res.success) location.reload();
            }
        }
        document.getElementById('archivo').addEventListener('change', e => {
            document.getElementById('fileLabel').textContent = e.target.files.length ? e.target.files[0].name : 'Seleccionar reporte';
        });
    </script>
</body>
</html>
