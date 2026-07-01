<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SGJE — Analítica Académica</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <link rel="stylesheet" href="css/analytics.css">
</head>
<body>

<!-- ═══════════════════ SIDEBAR (igual al resto del proyecto) ═══════════════ -->
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
        <a href="analytics.php" class="nav-item active"><i data-lucide="brain-circuit"></i> <span>Inteligencia</span></a>
        <a href="alertas.php" class="nav-item"><i data-lucide="bell-ring"></i> <span>Alertas</span></a>
        <div class="nav-label">Sistema</div>
        <a href="#" onclick="confirmReset()" class="nav-item" style="color: #ef4444;"><i data-lucide="trash-2"></i> <span>Limpiar Todo</span></a>
    </nav>
</aside>

<!-- ═══════════════════════════ MAIN CONTENT ══════════════════════════════════ -->
<main class="main-content">
    <header class="topbar">
        <h1>Inteligencia Académica</h1>
        <div class="topbar-actions">
            <select id="filtroFicha" class="form-control" style="width:180px;" onchange="cargarTodo()">
                <option value="">Todas las fichas</option>
            </select>
            <button onclick="cargarTodo()" class="btn btn-primary">
                <i data-lucide="refresh-cw" style="width:14px;height:14px;"></i> Actualizar
            </button>
            <!-- Campana de notificaciones -->
            <div class="notif-wrap" id="notifWrap">
                <button class="notif-bell" id="notifBellBtn" onclick="toggleNotifPanel()" aria-label="Notificaciones">
                    <i data-lucide="bell"></i>
                    <span class="notif-badge" id="notifBadge" style="display:none;">0</span>
                </button>
                <div class="notif-panel" id="notifPanel">
                    <div class="notif-panel-header">
                        <span>🔔 Notificaciones</span>
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

        <!-- ── FILA 1: KPI Cards (Riesgo académico) ───────────────────────── -->
        <section class="section-block">
            <div class="section-title">
                <i data-lucide="shield-alert"></i>
                Riesgo Académico
            </div>
            <div class="kpi-grid" id="kpiRiesgo">
                <div class="kpi-card skeleton"></div>
                <div class="kpi-card skeleton"></div>
                <div class="kpi-card skeleton"></div>
                <div class="kpi-card skeleton"></div>
            </div>
        </section>

        <!-- ── FILA 2: Semáforo + Ranking ─────────────────────────────────── -->
        <div class="two-col-grid">

            <!-- Semáforo de Competencias -->
            <section class="section-block">
                <div class="section-title">
                    <i data-lucide="traffic-cone"></i>
                    Semáforo de Competencias
                </div>
                <div class="semaforo-resumen" id="semaforoResumen">
                    <div class="sem-badge sem-verde"><span id="semVerde">—</span> Verde</div>
                    <div class="sem-badge sem-amarillo"><span id="semAmarillo">—</span> Amarillo</div>
                    <div class="sem-badge sem-rojo"><span id="semRojo">—</span> Rojo</div>
                </div>
                <div class="semaforo-list" id="semaforoList">
                    <div class="loading-msg">Cargando competencias…</div>
                </div>
            </section>

            <!-- Ranking de aprendices -->
            <section class="section-block">
                <div class="section-title">
                    <i data-lucide="trophy"></i>
                    Ranking de Aprendices
                </div>
                <div class="ranking-tabs">
                    <button class="rtab active" onclick="switchRanking('top', this)">Top 10</button>
                    <button class="rtab" onclick="switchRanking('bajo', this)">Menor Avance</button>
                </div>
                <div id="rankingTop" class="ranking-list"></div>
                <div id="rankingBajo" class="ranking-list" style="display:none;"></div>
            </section>

        </div>


        <!-- ── FILA 4: Estadísticas por ficha ─────────────────────────────── -->
        <section class="section-block">
            <div class="section-title">
                <i data-lucide="folder-open"></i>
                Estadísticas por Ficha
            </div>
            <div class="table-container">
                <table id="tablaFichas">
                    <thead>
                        <tr>
                            <th>Ficha</th>
                            <th>Programa</th>
                            <th>Aprendices</th>
                            <th>Aprobados</th>
                            <th>Pendientes</th>
                            <th>Avance</th>
                            <th>Aprobación</th>
                        </tr>
                    </thead>
                    <tbody id="tablaFichasBody">
                        <tr><td colspan="7" class="td-empty">Cargando…</td></tr>
                    </tbody>
                </table>
            </div>
            <div id="paginFichas" style="display:flex;align-items:center;justify-content:flex-end;gap:8px;margin-top:16px;"></div>
        </section>

        <!-- ── FILA 5: Tabla de riesgo detallada ──────────────────────────── -->
        <section class="section-block">
            <div class="section-title">
                <i data-lucide="users"></i>
                Detalle de Riesgo por Aprendiz
            </div>
            <div class="risk-filter-row">
                <button class="risk-btn active" onclick="filtrarRiesgo('todos', this)">Todos</button>
                <button class="risk-btn btn-bajo" onclick="filtrarRiesgo('BAJO', this)">Bajo</button>
                <button class="risk-btn btn-medio" onclick="filtrarRiesgo('MEDIO', this)">Medio</button>
                <button class="risk-btn btn-alto" onclick="filtrarRiesgo('ALTO', this)">Alto</button>
            </div>
            <div class="table-container">
                <table id="tablaRiesgo">
                    <thead>
                        <tr>
                            <th>Aprendiz</th>
                            <th>Ficha</th>
                            <th>Total</th>
                            <th>Aprobados</th>
                            <th>Pendientes</th>
                            <th>Avance</th>
                            <th>Riesgo</th>
                            <th>Perfil</th>
                        </tr>
                    </thead>
                    <tbody id="tablaRiesgoBody">
                        <tr><td colspan="8" class="td-empty">Cargando…</td></tr>
                    </tbody>
                </table>
            </div>
            <div id="paginRiesgo" style="display:flex;align-items:center;justify-content:flex-end;gap:8px;margin-top:16px;"></div>
        </section>

    </div><!-- /.analytics-container -->
</main>

<script src="js/analytics.js"></script>
<script>
    lucide.createIcons();

    async function confirmReset() {
        const { isConfirmed } = await Swal.fire({
            title: '¿Limpiar sistema?',
            text: "Se eliminarán todos los aprendices y juicios.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#ef4444',
            confirmButtonText: 'Sí, borrar todo'
        });
        if (isConfirmed) {
            const res = await fetch('api.php?action=delete_all').then(r => r.json());
            if (res.success) window.location.href = 'index.php';
        }
    }

    // Cierra el panel al hacer click fuera
    document.addEventListener('click', (e) => {
        const wrap  = document.getElementById('notifWrap');
        const panel = document.getElementById('notifPanel');
        if (wrap && !wrap.contains(e.target)) panel.classList.remove('open');
    });
</script>
</body>
</html>
