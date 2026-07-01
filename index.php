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

        /* Sidebar */
        .sidebar { width: 260px; background: var(--sidebar-bg); color: #fff; position: fixed; height: 100vh; display: flex; flex-direction: column; z-index: 1000; }
        .sidebar-header { padding: 32px 24px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid #1e293b; margin-bottom: 12px; }
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

        .container { padding: 40px; width: 100%; max-width: 1400px; margin: 0 auto; display: flex; flex-direction: column; gap: 32px; }

        /* Cards */
        .card { background: #fff; border-radius: var(--radius); border: 1px solid var(--border); box-shadow: var(--card-shadow); }
        .card-header { padding: 16px 24px; border-bottom: 1px solid var(--border); font-weight: 600; font-size: 14px; color: var(--text-main); display: flex; align-items: center; gap: 8px; }
        .card-body { padding: 24px; }

        .upload-strip {
            background: #fff;
            border-radius: var(--radius);
            padding: 24px;
            display: flex;
            align-items: center;
            gap: 20px;
            border: 1px solid var(--border);
            box-shadow: var(--card-shadow);
        }
        .upload-icon { width: 48px; height: 48px; background: var(--primary-light); color: var(--primary); border-radius: 12px; display: flex; align-items: center; justify-content: center; }

        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 24px; }
        .stat-card { background: #fff; padding: 32px 24px; border-radius: var(--radius); border: 1px solid var(--border); box-shadow: var(--card-shadow); text-align: center; display: flex; flex-direction: column; align-items: center; justify-content: center; }
        .stat-val { font-size: 36px; font-weight: 800; color: var(--primary); line-height: 1; margin-bottom: 8px; }
        .stat-lbl { font-size: 11px; color: #94a3b8; text-transform: uppercase; font-weight: 700; letter-spacing: 0.1em; }

        .filters-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 20px; align-items: flex-end; }
        .form-group label { display: block; font-size: 11px; font-weight: 700; color: #94a3b8; margin-bottom: 8px; text-transform: uppercase; }
        .form-control { width: 100%; border: 1.5px solid var(--border); padding: 10px 14px; border-radius: 10px; font-family: inherit; font-size: 14px; outline: none; }
        .form-control:focus { border-color: var(--primary); }

        .btn { padding: 10px 24px; border-radius: 10px; border: none; font-weight: 700; cursor: pointer; font-family: inherit; transition: all 0.2s; font-size: 14px; }
        .btn-primary { background: var(--primary); color: #fff; }
        .btn-primary:hover { background: #1d4ed8; }
        .btn-outline { background: #fff; color: var(--text-main); border: 1.5px solid var(--border); }
        .btn-outline:hover { background: #f8fafc; border-color: #cbd5e1; }

        /* Pagination */
        .pagination-bar { display: flex; align-items: center; justify-content: flex-end; gap: 8px; padding: 16px 24px; border-top: 1px solid var(--border); }
        .page-btn { width: 36px; height: 36px; border-radius: 8px; border: 1px solid var(--border); background: #fff; color: var(--text-main); font-weight: 600; font-size: 14px; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.2s; font-family: inherit; }
        .page-btn:hover:not([disabled]) { border-color: #cbd5e1; background: #f8fafc; }
        .page-btn[disabled] { opacity: 0.4; cursor: not-allowed; }
        .page-btn.active { background: var(--sidebar-bg); color: #fff; border-color: var(--sidebar-bg); }
        .page-info { font-size: 13px; color: var(--text-muted); font-weight: 500; margin-left: 8px; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #f8faff; padding: 16px 24px; text-align: left; font-size: 11px; font-weight: 700; color: #94a3b8; text-transform: uppercase; border-bottom: 1px solid var(--border); }
        td { padding: 16px 24px; border-bottom: 1px solid var(--border); font-size: 13px; }

        .badge { padding: 4px 10px; border-radius: 99px; font-size: 11px; font-weight: 700; text-transform: uppercase; }
        .aprobado { background: #ecfdf5; color: #059669; }
        .por-evaluar { background: #fffbeb; color: #d97706; }

        .charts-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }
        .chart-wrap { height: 260px; position: relative; }

        @media (max-width: 1024px) {
            .sidebar { width: 80px; }
            .brand-name, .nav-item span:last-child, .nav-label { display: none; }
            .main-content { margin-left: 80px; }
            .charts-grid { grid-template-columns: 1fr; }
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
        <a href="index.php" class="nav-item active"><i data-lucide="layout-dashboard"></i> <span>Dashboard</span></a>
        <a href="aprendices.php" class="nav-item"><i data-lucide="users"></i> <span>Aprendices</span></a>
        <a href="analisis.php" class="nav-item"><i data-lucide="search"></i> <span>Análisis Proyecto</span></a>
        <a href="analytics.php" class="nav-item"><i data-lucide="brain-circuit"></i> <span>Inteligencia</span></a>
        <a href="alertas.php" class="nav-item"><i data-lucide="bell-ring"></i> <span>Alertas</span></a>
        <div class="nav-label">Sistema</div>
        <a href="#" onclick="confirmReset()" class="nav-item" style="color: #ef4444;"><i data-lucide="trash-2"></i> <span>Limpiar Todo</span></a>
    </nav>
</aside>

    <main class="main-content">
        <header class="topbar">
            <h1>Panel de Control</h1>
            <div style="display:flex;align-items:center;gap:12px;">
                <!-- Campana de notificaciones -->
                <div class="notif-wrap-global" id="notifWrap" style="position:relative;">
                    <button onclick="toggleNotifPanel()" id="notifBellBtn" aria-label="Notificaciones"
                        style="width:38px;height:38px;border-radius:50%;background:#f1f5f9;border:1.5px solid #e2e8f0;display:flex;align-items:center;justify-content:center;cursor:pointer;position:relative;transition:all .2s;font-family:inherit;">
                        <i data-lucide="bell" style="width:18px;height:18px;color:#1e293b;" id="bellIcon"></i>
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
            </div>
        </header>

        <div class="container">
            
            <div class="upload-strip">
                <div class="upload-icon"><i data-lucide="file-up"></i></div>
                <div style="flex: 1;">
                    <h2 style="font-size: 16px; font-weight: 700; color: var(--text-main);">Actualización de Datos</h2>
                    <p style="font-size: 13px; color: var(--text-muted);">Sube el reporte de SOFIA Plus para sincronizar los juicios evaluativos.</p>
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
                <div class="table-container" style="overflow-x:auto;">
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
                    return `
                    <div style="display:flex;gap:12px;align-items:flex-start;padding:12px 18px;border-bottom:1px solid #f1f5f9;cursor:default;">
                        <div style="width:36px;height:36px;border-radius:50%;background:${a.nivel==='CRITICAL'?'#fef2f2':'#fffbeb'};display:flex;align-items:center;justify-content:center;flex-shrink:0;">${iconSvg}</div>
                        <div style="flex:1;min-width:0;">
                            <div style="font-size:13px;color:#1e293b;font-weight:500;line-height:1.45;">${a.mensaje}</div>
                            <div style="font-size:11px;color:#64748b;margin-top:3px;text-transform:uppercase;font-weight:600;">${a.tipo.replace(/_/g,' ')}</div>
                        </div>
                    </div>`;
                }).join('');
                if (data.alertas.length > 10) {
                    list.innerHTML += `<div style="padding:12px;text-align:center;"><a href="alertas.php" style="color:#2563eb;font-weight:600;font-size:12px;text-decoration:none;">Ver ${data.alertas.length-10} alertas más →</a></div>`;
                }
            } catch(_) {}
        })();

        function toggleNotifPanel() {
            const p = document.getElementById('notifPanel');
            const open = p.style.opacity === '1';
            p.style.opacity    = open ? '0'       : '1';
            p.style.visibility = open ? 'hidden'  : 'visible';
            p.style.transform  = open ? 'translateY(-8px) scale(.98)' : 'translateY(0) scale(1)';
        }
        document.addEventListener('click', e => {
            const wrap = document.getElementById('notifWrap');
            const p    = document.getElementById('notifPanel');
            if (wrap && !wrap.contains(e.target)) {
                p.style.opacity = '0'; p.style.visibility = 'hidden';
                p.style.transform = 'translateY(-8px) scale(.98)';
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
