<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SGJE — Comparador Evolutivo de Cortes</title>

    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://unpkg.com/lucide@latest"></script>

    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/analytics.css">
    <style>
        .diff-badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 3px 8px;
            border-radius: 9999px;
            font-size: 11px;
            font-weight: 700;
            font-family: 'JetBrains Mono', monospace;
        }
        .diff-pos { background: #dcfce7; color: #15803d; }
        .diff-neg { background: #fee2e2; color: #b91c1c; }
        .diff-zero { background: #f1f5f9; color: #64748b; }

        .tabs-header {
            display: flex;
            gap: 8px;
            border-bottom: 2px solid var(--border-color, #e2e8f0);
            margin-bottom: 20px;
        }
        .tab-btn {
            padding: 10px 18px;
            border: none;
            background: transparent;
            font-size: 14px;
            font-weight: 600;
            color: var(--text-muted, #64748b);
            cursor: pointer;
            border-bottom: 2px solid transparent;
            margin-bottom: -2px;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .tab-btn:hover {
            color: var(--primary, #0284c7);
        }
        .tab-btn.active {
            color: var(--primary, #0284c7);
            border-bottom-color: var(--primary, #0284c7);
        }

        .tab-content { display: none; }
        .tab-content.active { display: block; }

        .banner-estancamiento {
            background: #fffbeb;
            border: 1px solid #fef3c7;
            border-left: 4px solid #f59e0b;
            padding: 14px 18px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
            color: #92400e;
            font-size: 13px;
        }
        .banner-avance {
            background: #f0fdf4;
            border: 1px solid #dcfce7;
            border-left: 4px solid #22c55e;
            padding: 14px 18px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
            color: #166534;
            font-size: 13px;
        }

        .compare-bar-wrap {
            display: flex;
            flex-direction: column;
            gap: 4px;
            width: 100%;
        }
        .compare-bar-row {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 11px;
        }
        .compare-bar-track {
            flex: 1;
            height: 7px;
            background: #e2e8f0;
            border-radius: 4px;
            overflow: hidden;
        }
        .compare-bar-fill {
            height: 100%;
            border-radius: 4px;
            transition: width 0.4s ease;
        }

        .filter-pill-btn {
            border: 1px solid #e2e8f0;
            background: #fff;
            padding: 6px 14px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 500;
            cursor: pointer;
            color: #475569;
            transition: all 0.2s;
        }
        .filter-pill-btn:hover {
            border-color: var(--primary, #0284c7);
            color: var(--primary, #0284c7);
        }
        .filter-pill-btn.active {
            background: var(--primary, #0284c7);
            color: #fff;
            border-color: var(--primary, #0284c7);
        }
    </style>
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
            <a href="comparador.php" class="nav-item active"><i data-lucide="git-compare"></i> <span>Comparador</span></a>
            <a href="alertas.php" class="nav-item"><i data-lucide="bell-ring"></i> <span>Alertas</span></a>
            <a href="index.php#uploadSection" class="nav-item"><i data-lucide="file-up"></i> <span>Carga Masiva</span></a>
            <div class="nav-label">Sistema</div>
            <a href="#" onclick="confirmReset()" class="nav-item" style="color: #ef4444;"><i data-lucide="trash-2"></i> <span>Limpiar Todo</span></a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <h1>Comparador Evolutivo entre Cortes</h1>
            <div class="topbar-actions">
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

        <div class="container" style="max-width: 1400px; padding: 24px;">

            <!-- Selector de Ficha y Fechas de Comparación -->
            <div class="card" style="margin-bottom: 24px;">
                <div class="card-header" style="display:flex; justify-content:space-between; align-items:center;">
                    <span>Selección de Ficha y Fechas a Comparar</span>
                    <span id="labelDiasTranscurridos" style="font-size:12px; font-weight:600; color:var(--primary, #0284c7);"></span>
                </div>
                <div class="card-body">
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)) 120px; gap: 16px; align-items: flex-end;">
                        <div class="form-group" style="margin:0;">
                            <label for="selectFicha" style="font-size:13px; font-weight:600; color:#475569; margin-bottom:6px; display:block;">Ficha de Caracterización</label>
                            <select id="selectFicha" class="form-control" onchange="onFichaSelected()">
                                <option value="">Cargando fichas...</option>
                            </select>
                        </div>
                        <div class="form-group" style="margin:0;">
                            <label for="selectCorteA" style="font-size:13px; font-weight:600; color:#475569; margin-bottom:6px; display:block;">Corte Base (Anterior)</label>
                            <select id="selectCorteA" class="form-control">
                                <option value="">Selecciona fecha A</option>
                            </select>
                        </div>
                        <div class="form-group" style="margin:0;">
                            <label for="selectCorteB" style="font-size:13px; font-weight:600; color:#475569; margin-bottom:6px; display:block;">Corte Comparación (Posterior)</label>
                            <select id="selectCorteB" class="form-control">
                                <option value="">Selecciona fecha B</option>
                            </select>
                        </div>
                        <div>
                            <button id="btnComparar" class="btn btn-primary" onclick="ejecutarComparacion()" style="width:100%; height:42px; display:flex; align-items:center; justify-content:center; gap:8px;">
                                <i data-lucide="git-compare" style="width:16px; height:16px;"></i> Comparar
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Banner de Ritmo / Estancamiento -->
            <div id="bannerAlerta" style="display:none;"></div>

            <!-- KPIs de Diferencia -->
            <div id="kpiContainer" class="stats-grid" style="display:none; margin-bottom:24px;">
                <div class="stat-card">
                    <div class="stat-val" id="kpiAvanceDiff" style="display:flex; align-items:center; justify-content:center; gap:8px;">—</div>
                    <div class="stat-lbl">Variación Avance Global</div>
                    <div id="kpiAvanceDetalle" style="font-size:11px; color:#64748b; margin-top:4px;">—</div>
                </div>
                <div class="stat-card">
                    <div class="stat-val" id="kpiAprobadosNuevos" style="color:#16a34a;">—</div>
                    <div class="stat-lbl">Juicios Nuevos Aprobados</div>
                    <div id="kpiAprobadosDetalle" style="font-size:11px; color:#64748b; margin-top:4px;">—</div>
                </div>
                <div class="stat-card">
                    <div class="stat-val" id="kpiMejoraron" style="color:#0284c7;">—</div>
                    <div class="stat-lbl">Aprendices con Progreso</div>
                    <div id="kpiSalieronRiesgo" style="font-size:11px; color:#64748b; margin-top:4px;">—</div>
                </div>
                <div class="stat-card">
                    <div class="stat-val" id="kpiDias">0</div>
                    <div class="stat-lbl">Días Transcurridos</div>
                    <div id="kpiRitmoTexto" style="font-size:11px; color:#64748b; margin-top:4px;">—</div>
                </div>
            </div>

            <!-- Pestañas de Detalle Comparativo -->
            <div id="tabsContainer" class="card" style="display:none;">
                <div class="card-body">
                    <div class="tabs-header">
                        <button class="tab-btn active" onclick="cambiarTab('tabAprendices')">
                            <i data-lucide="users" style="width:16px;height:16px;"></i> Evolución de Aprendices (<span id="countTabAp">0</span>)
                        </button>
                        <button class="tab-btn" onclick="cambiarTab('tabCompetencias')">
                            <i data-lucide="book-open" style="width:16px;height:16px;"></i> Evolución por Competencia (<span id="countTabComp">0</span>)
                        </button>
                        <button class="tab-btn" onclick="cambiarTab('tabBitacora')">
                            <i data-lucide="file-check-2" style="width:16px;height:16px;"></i> Juicios Aprobados Recientes (<span id="countTabNuevos">0</span>)
                        </button>
                    </div>

                    <!-- TAB 1: APRENDICES -->
                    <div id="tabAprendices" class="tab-content active">
                        <div style="display:flex; flex-wrap:wrap; justify-content:space-between; align-items:center; gap:12px; margin-bottom:16px;">
                            <div style="display:flex; gap:8px; flex-wrap:wrap;">
                                <button class="filter-pill-btn active" onclick="filtrarAprendices('TODOS', this)">Todos</button>
                                <button class="filter-pill-btn" onclick="filtrarAprendices('MEJORARON', this)">Solo los que progresaron</button>
                                <button class="filter-pill-btn" onclick="filtrarAprendices('SALIERON_RIESGO', this)">Salieron de Riesgo Alto</button>
                                <button class="filter-pill-btn" onclick="filtrarAprendices('SIN_CAMBIO', this)">Sin avance</button>
                            </div>
                            <div style="width:280px;">
                                <input type="text" id="searchAprendiz" class="form-control" placeholder="Buscar por aprendiz o doc..." oninput="filtrarAprendicesTabla()">
                            </div>
                        </div>

                        <div class="table-container">
                            <table id="tablaAprendices">
                                <thead>
                                    <tr>
                                        <th>Aprendiz</th>
                                        <th>Documento</th>
                                        <th style="text-align:center;">Corte Base (A)</th>
                                        <th style="text-align:center;">Corte Posterior (B)</th>
                                        <th style="text-align:center;">Juicios Nuevos</th>
                                        <th style="text-align:center;">Δ Avance</th>
                                        <th>Evolución de Riesgo</th>
                                    </tr>
                                </thead>
                                <tbody id="tbodyAprendices">
                                    <tr><td colspan="7" style="text-align:center; padding:30px; color:#94a3b8;">Cargando aprendices...</td></tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- TAB 2: COMPETENCIAS -->
                    <div id="tabCompetencias" class="tab-content">
                        <div class="table-container">
                            <table id="tablaCompetencias">
                                <thead>
                                    <tr>
                                        <th>Competencia</th>
                                        <th style="width:260px;">Comparación Visual (% A vs % B)</th>
                                        <th style="text-align:center;">Aprobados A</th>
                                        <th style="text-align:center;">Aprobados B</th>
                                        <th style="text-align:center;">Δ Nuevos</th>
                                        <th style="text-align:center;">Δ %</th>
                                    </tr>
                                </thead>
                                <tbody id="tbodyCompetencias">
                                    <tr><td colspan="6" style="text-align:center; padding:30px; color:#94a3b8;">Cargando competencias...</td></tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- TAB 3: BITÁCORA DE NUEVOS JUICIOS -->
                    <div id="tabBitacora" class="tab-content">
                        <div style="margin-bottom:12px; font-size:13px; color:#64748b;">
                            Resultados de aprendizaje que estaban pendientes en el Corte Base y fueron aprobados en el Corte Posterior:
                        </div>
                        <div class="table-container">
                            <table id="tablaBitacora">
                                <thead>
                                    <tr>
                                        <th>Aprendiz</th>
                                        <th>Competencia</th>
                                        <th>Resultado de Aprendizaje</th>
                                        <th>Instructor Evaluador</th>
                                        <th>Fecha de Juicio</th>
                                    </tr>
                                </thead>
                                <tbody id="tbodyBitacora">
                                    <tr><td colspan="5" style="text-align:center; padding:30px; color:#94a3b8;">No hay juicios nuevos registrados.</td></tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Estado Vacío Inicial -->
            <div id="emptyInitial" style="text-align:center; padding:60px 20px; background:#fff; border-radius:12px; border:1px solid #e2e8f0;">
                <div style="width:60px; height:60px; background:#eff6ff; border-radius:50%; display:flex; align-items:center; justify-content:center; margin:0 auto 16px; color:#0284c7;">
                    <i data-lucide="git-compare" style="width:32px; height:32px;"></i>
                </div>
                <h3 style="font-size:18px; font-weight:700; color:#1e293b; margin-bottom:8px;">Comparador Evolutivo de Cortes</h3>
                <p style="color:#64748b; font-size:14px; max-width:550px; margin:0 auto 20px;">
                    Selecciona una ficha y dos fechas de corte distintas para contrastar el avance, verificar juicios recién aprobados y detectar estancamientos en el grupo.
                </p>
            </div>

        </div>
    </main>

    <script>
        lucide.createIcons();

        let datosComparacion = null;
        let filtroAprendizActual = 'TODOS';

        function formatDate(str) {
            if (!str || str.length < 10) return str || '';
            const meses = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
            const parts = str.substring(0, 10).split('-');
            if (parts.length === 3) {
                const m = parseInt(parts[1], 10) - 1;
                return `${parts[2]} ${meses[m] || parts[1]} ${parts[0]}`;
            }
            return str;
        }

        async function cargarFichas() {
            const selectF = document.getElementById('selectFicha');
            try {
                const res = await fetch('api.php?action=get_fichas').then(r => r.json());
                selectF.innerHTML = '';
                if (!res || !res.length) {
                    selectF.innerHTML = '<option value="">Sin fichas disponibles</option>';
                    return;
                }
                selectF.innerHTML = '<option value="">Selecciona una ficha</option>';
                res.forEach(f => {
                    const opt = document.createElement('option');
                    opt.value = f.numero_ficha;
                    opt.textContent = `Ficha ${f.numero_ficha} — ${f.nombre_programa || ''}`;
                    selectF.appendChild(opt);
                });

                // Auto-seleccionar si viene de query param o contexto
                const urlParams = new URLSearchParams(window.location.search);
                const fichaUrl = urlParams.get('ficha');
                if (fichaUrl) {
                    selectF.value = fichaUrl;
                    await onFichaSelected();
                } else {
                    const rawCtx = sessionStorage.getItem('sgje_nav_context');
                    if (rawCtx) {
                        try {
                            const ctx = JSON.parse(rawCtx);
                            if (ctx.ficha) {
                                selectF.value = ctx.ficha;
                                await onFichaSelected();
                            }
                        } catch(_) {}
                    }
                }
            } catch(e) {
                selectF.innerHTML = '<option value="">Error cargando fichas</option>';
            }
        }

        async function onFichaSelected() {
            const ficha = document.getElementById('selectFicha').value;
            const selA = document.getElementById('selectCorteA');
            const selB = document.getElementById('selectCorteB');

            if (!ficha) {
                selA.innerHTML = '<option value="">Selecciona fecha A</option>';
                selB.innerHTML = '<option value="">Selecciona fecha B</option>';
                return;
            }

            selA.innerHTML = '<option value="">Cargando fechas...</option>';
            selB.innerHTML = '<option value="">Cargando fechas...</option>';

            try {
                const res = await fetch(`api.php?action=get_fechas_ficha&ficha=${encodeURIComponent(ficha)}`).then(r => r.json());
                const fechas = res.fechas || [];

                if (fechas.length < 2) {
                    selA.innerHTML = '<option value="">Menos de 2 cortes registrados</option>';
                    selB.innerHTML = '<option value="">Menos de 2 cortes registrados</option>';
                    Swal.fire({
                        icon: 'info',
                        title: 'Solo 1 corte disponible',
                        text: 'Esta ficha tiene un único corte. Para realizar una comparativa evolutiva, importa un nuevo reporte de fecha diferente.',
                        confirmButtonColor: '#0284c7'
                    });
                    return;
                }

                selA.innerHTML = '';
                selB.innerHTML = '';

                // Orden cronológico: fechas viene desc (más reciente primero)
                fechas.forEach((f, idx) => {
                    const optA = document.createElement('option');
                    optA.value = f;
                    optA.textContent = `${formatDate(f)}${idx === fechas.length - 1 ? ' (Corte más antiguo)' : ''}`;
                    selA.appendChild(optA);

                    const optB = document.createElement('option');
                    optB.value = f;
                    optB.textContent = `${formatDate(f)}${idx === 0 ? ' (Corte más reciente)' : ''}`;
                    selB.appendChild(optB);
                });

                // Por defecto: A es el corte anterior (penúltimo o último), B es el más reciente (índice 0)
                selB.selectedIndex = 0; // Más reciente
                selA.selectedIndex = Math.min(1, fechas.length - 1); // Anterior

                // Auto-ejecutar comparación
                await ejecutarComparacion();

            } catch(e) {
                selA.innerHTML = '<option value="">Error</option>';
                selB.innerHTML = '<option value="">Error</option>';
            }
        }

        async function ejecutarComparacion() {
            const ficha = document.getElementById('selectFicha').value;
            const fechaA = document.getElementById('selectCorteA').value;
            const fechaB = document.getElementById('selectCorteB').value;

            if (!ficha) {
                Swal.fire('Atención', 'Selecciona una ficha de caracterización.', 'warning');
                return;
            }
            if (!fechaA || !fechaB) {
                Swal.fire('Atención', 'Selecciona las dos fechas de corte a comparar.', 'warning');
                return;
            }
            if (fechaA === fechaB) {
                Swal.fire('Fechas idénticas', 'Debes seleccionar dos fechas de corte diferentes para observar la evolución.', 'info');
                return;
            }

            const btn = document.getElementById('btnComparar');
            btn.disabled = true;
            btn.innerHTML = 'Comparando...';

            try {
                const res = await fetch(`api_analytics.php?action=comparar_cortes&ficha=${encodeURIComponent(ficha)}&corte_a=${encodeURIComponent(fechaA)}&corte_b=${encodeURIComponent(fechaB)}`).then(r => r.json());

                if (res.error) {
                    Swal.fire('Aviso', res.error, 'info');
                    return;
                }

                datosComparacion = res;
                renderizarComparacion(res);

            } catch(e) {
                Swal.fire('Error', 'No se pudo generar la comparativa de cortes.', 'error');
            } finally {
                btn.disabled = false;
                btn.innerHTML = '<i data-lucide="git-compare" style="width:16px; height:16px;"></i> Comparar';
                lucide.createIcons();
            }
        }

        function renderizarComparacion(data) {
            document.getElementById('emptyInitial').style.display = 'none';
            document.getElementById('kpiContainer').style.display = 'grid';
            document.getElementById('tabsContainer').style.display = 'block';

            const diff = data.resumen_diferencial;
            const cA = data.corte_base;
            const cB = data.corte_comparacion;

            document.getElementById('labelDiasTranscurridos').textContent = `Período: ${formatDate(cA.fecha_reporte)} ➔ ${formatDate(cB.fecha_reporte)} (${diff.dias_transcurridos} días)`;

            // 1. Banner
            const banner = document.getElementById('bannerAlerta');
            if (diff.es_estancado) {
                banner.className = 'banner-estancamiento';
                banner.style.display = 'flex';
                banner.innerHTML = `
                    <i data-lucide="alert-triangle" style="width:20px;height:20px;flex-shrink:0;"></i>
                    <div>
                        <strong>Alerta de Estancamiento Académico:</strong> Han transcurrido <strong>${diff.dias_transcurridos} días</strong> entre ambos cortes y se registraron <strong>0 juicios aprobados nuevos</strong>. Se recomienda verificar con el equipo de instructores.
                    </div>`;
            } else if (diff.diff_aprobados > 0) {
                banner.className = 'banner-avance';
                banner.style.display = 'flex';
                banner.innerHTML = `
                    <i data-lucide="check-circle" style="width:20px;height:20px;flex-shrink:0;"></i>
                    <div>
                        <strong>Progreso Positivo:</strong> Se aprobaron <strong>${diff.diff_aprobados} juicios evaluativos nuevos</strong> (+${diff.diff_avance}% de avance) y <strong>${diff.aprendices_mejoraron} aprendices</strong> aumentaron su porcentaje de formación.
                    </div>`;
            } else {
                banner.style.display = 'none';
            }

            // 2. KPIs
            const kpiAvance = document.getElementById('kpiAvanceDiff');
            const signAvance = diff.diff_avance > 0 ? `+${diff.diff_avance}%` : `${diff.diff_avance}%`;
            const colorAvance = diff.diff_avance > 0 ? '#16a34a' : diff.diff_avance < 0 ? '#dc2626' : '#64748b';
            kpiAvance.innerHTML = `<span style="color:${colorAvance}">${signAvance}</span>`;
            document.getElementById('kpiAvanceDetalle').textContent = `${cA.porcentaje_avance}% ➔ ${cB.porcentaje_avance}%`;

            document.getElementById('kpiAprobadosNuevos').textContent = diff.diff_aprobados > 0 ? `+${diff.diff_aprobados}` : `${diff.diff_aprobados}`;
            document.getElementById('kpiAprobadosDetalle').textContent = `${cA.total_aprobados} ➔ ${cB.total_aprobados} aprobados`;

            document.getElementById('kpiMejoraron').textContent = diff.aprendices_mejoraron;
            document.getElementById('kpiSalieronRiesgo').textContent = `${diff.aprendices_salieron_riesgo} salieron de Riesgo Alto`;

            document.getElementById('kpiDias').textContent = diff.dias_transcurridos;
            const ritmo = diff.dias_transcurridos > 0 && diff.diff_aprobados > 0
                ? `${Math.round((diff.diff_aprobados / diff.dias_transcurridos) * 7)} juicios/sem`
                : 'Sin registros nuevos';
            document.getElementById('kpiRitmoTexto').textContent = ritmo;

            // Counts en tabs
            document.getElementById('countTabAp').textContent = data.aprendices.length;
            document.getElementById('countTabComp').textContent = data.competencias.length;
            document.getElementById('countTabNuevos').textContent = data.bitacora_nuevos.length;

            renderTablaAprendices(data.aprendices);
            renderTablaCompetencias(data.competencias);
            renderTablaBitacora(data.bitacora_nuevos);

            lucide.createIcons();
        }

        function renderTablaAprendices(aprendices) {
            const tbody = document.getElementById('tbodyAprendices');
            if (!aprendices.length) {
                tbody.innerHTML = '<tr><td colspan="7" style="text-align:center; padding:30px; color:#94a3b8;">No hay aprendices registrados en este filtro.</td></tr>';
                return;
            }

            tbody.innerHTML = aprendices.map(ap => {
                const diffBadge = ap.diff_juicios > 0 
                    ? `<span class="diff-badge diff-pos">+${ap.diff_juicios}</span>` 
                    : ap.diff_juicios < 0 ? `<span class="diff-badge diff-neg">${ap.diff_juicios}</span>` 
                    : `<span class="diff-badge diff-zero">0</span>`;

                const diffPctBadge = ap.diff_pct > 0 
                    ? `<span class="diff-badge diff-pos">+${ap.diff_pct}%</span>` 
                    : ap.diff_pct < 0 ? `<span class="diff-badge diff-neg">${ap.diff_pct}%</span>` 
                    : `<span class="diff-badge diff-zero">0%</span>`;

                let riesgoLabel = '';
                if (ap.salio_de_riesgo) {
                    riesgoLabel = `<span class="diff-badge diff-pos">★ Salió de Riesgo</span> (${ap.riesgo_a} ➔ ${ap.riesgo_b})`;
                } else {
                    const clsRiesgo = ap.riesgo_b === 'ALTO' ? 'color:#dc2626; font-weight:700;' : ap.riesgo_b === 'MEDIO' ? 'color:#d97706; font-weight:600;' : 'color:#16a34a; font-weight:600;';
                    riesgoLabel = `<span style="${clsRiesgo}">${ap.riesgo_b}</span>`;
                }

                return `
                <tr>
                    <td>
                        <div style="font-weight:600; color:var(--text-main); font-size:13px;">${escapeHtml(ap.nombre_completo)}</div>
                    </td>
                    <td><span style="font-family:'JetBrains Mono'; font-size:12px; color:#64748b;">${escapeHtml(ap.documento)}</span></td>
                    <td style="text-align:center;">
                        <span style="font-weight:600;">${ap.aprobados_a}</span> <span style="font-size:11px; color:#94a3b8;">(${ap.avance_a}%)</span>
                    </td>
                    <td style="text-align:center;">
                        <span style="font-weight:600; color:var(--primary);">${ap.aprobados_b}</span> <span style="font-size:11px; color:#94a3b8;">(${ap.avance_b}%)</span>
                    </td>
                    <td style="text-align:center;">${diffBadge}</td>
                    <td style="text-align:center;">${diffPctBadge}</td>
                    <td>${riesgoLabel}</td>
                </tr>`;
            }).join('');
        }

        function renderTablaCompetencias(competencias) {
            const tbody = document.getElementById('tbodyCompetencias');
            if (!competencias.length) {
                tbody.innerHTML = '<tr><td colspan="6" style="text-align:center; padding:30px; color:#94a3b8;">Sin competencias registradas.</td></tr>';
                return;
            }

            tbody.innerHTML = competencias.map(cp => {
                const diffBadge = cp.diff_juicios > 0 
                    ? `<span class="diff-badge diff-pos">+${cp.diff_juicios}</span>` 
                    : cp.diff_juicios < 0 ? `<span class="diff-badge diff-neg">${cp.diff_juicios}</span>` 
                    : `<span class="diff-badge diff-zero">0</span>`;

                const diffPctBadge = cp.diff_pct > 0 
                    ? `<span class="diff-badge diff-pos">+${cp.diff_pct}%</span>` 
                    : cp.diff_pct < 0 ? `<span class="diff-badge diff-neg">${cp.diff_pct}%</span>` 
                    : `<span class="diff-badge diff-zero">0%</span>`;

                return `
                <tr>
                    <td>
                        <div style="font-weight:600; color:var(--text-main); font-size:13px;">${escapeHtml(cp.nombre_comp)}</div>
                        <div style="font-size:11px; color:#94a3b8;">Cód. ${cp.codigo_comp}</div>
                    </td>
                    <td>
                        <div class="compare-bar-wrap">
                            <div class="compare-bar-row">
                                <span style="width:25px; color:#64748b;">A:</span>
                                <div class="compare-bar-track"><div class="compare-bar-fill" style="width:${cp.pct_a}%; background:#94a3b8;"></div></div>
                                <span style="width:36px; text-align:right; font-weight:600; color:#64748b;">${cp.pct_a}%</span>
                            </div>
                            <div class="compare-bar-row">
                                <span style="width:25px; color:var(--primary); font-weight:700;">B:</span>
                                <div class="compare-bar-track"><div class="compare-bar-fill" style="width:${cp.pct_b}%; background:var(--primary);"></div></div>
                                <span style="width:36px; text-align:right; font-weight:700; color:var(--primary);">${cp.pct_b}%</span>
                            </div>
                        </div>
                    </td>
                    <td style="text-align:center; font-weight:600;">${cp.aprobados_a}</td>
                    <td style="text-align:center; font-weight:700; color:var(--primary);">${cp.aprobados_b}</td>
                    <td style="text-align:center;">${diffBadge}</td>
                    <td style="text-align:center;">${diffPctBadge}</td>
                </tr>`;
            }).join('');
        }

        function renderTablaBitacora(bitacora) {
            const tbody = document.getElementById('tbodyBitacora');
            if (!bitacora.length) {
                tbody.innerHTML = '<tr><td colspan="5" style="text-align:center; padding:30px; color:#94a3b8;">No se registraron nuevos juicios evaluativos entre estas dos fechas.</td></tr>';
                return;
            }

            tbody.innerHTML = bitacora.map(b => `
                <tr>
                    <td>
                        <div style="font-weight:600; font-size:13px; color:var(--text-main);">${escapeHtml(b.nombres)} ${escapeHtml(b.apellidos)}</div>
                        <div style="font-size:11px; color:#94a3b8; font-family:'JetBrains Mono';">${escapeHtml(b.numero_documento)}</div>
                    </td>
                    <td><div style="font-size:12px; color:var(--text-main);">${escapeHtml(b.nombre_comp)}</div></td>
                    <td><div style="font-size:12px; color:#475569;">${escapeHtml(b.nombre_resultado)}</div></td>
                    <td><div style="font-size:12px; color:#64748b;">${escapeHtml(b.instructor)}</div></td>
                    <td><div style="font-size:12px; color:#64748b;">${b.fecha_registro ? b.fecha_registro.substring(0, 10) : '-'}</div></td>
                </tr>
            `).join('');
        }

        function cambiarTab(tabId) {
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));

            const activeBtn = Array.from(document.querySelectorAll('.tab-btn')).find(b => b.getAttribute('onclick').includes(tabId));
            if (activeBtn) activeBtn.classList.add('active');

            const target = document.getElementById(tabId);
            if (target) target.classList.add('active');
        }

        function filtrarAprendices(tipo, btn) {
            filtroAprendizActual = tipo;
            document.querySelectorAll('.filter-pill-btn').forEach(b => b.classList.remove('active'));
            if (btn) btn.classList.add('active');
            filtrarAprendicesTabla();
        }

        function filtrarAprendicesTabla() {
            if (!datosComparacion || !datosComparacion.aprendices) return;
            const query = (document.getElementById('searchAprendiz').value || '').trim().toLowerCase();

            let lista = datosComparacion.aprendices;

            if (filtroAprendizActual === 'MEJORARON') {
                lista = lista.filter(a => a.diff_juicios > 0);
            } else if (filtroAprendizActual === 'SALIERON_RIESGO') {
                lista = lista.filter(a => a.salio_de_riesgo);
            } else if (filtroAprendizActual === 'SIN_CAMBIO') {
                lista = lista.filter(a => a.diff_juicios === 0);
            }

            if (query) {
                lista = lista.filter(a => a.nombre_completo.toLowerCase().includes(query) || a.documento.includes(query));
            }

            renderTablaAprendices(lista);
        }

        function escapeHtml(str) {
            if (!str) return '';
            return String(str)
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/"/g, "&quot;");
        }

        document.addEventListener('DOMContentLoaded', () => {
            cargarFichas();
        });
    </script>
</body>
</html>
