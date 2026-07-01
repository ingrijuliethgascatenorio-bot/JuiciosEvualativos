<?php
require 'db.php';

$documento = $_GET['documento'] ?? '';

if (empty($documento)) {
    die("Documento no especificado.");
}

$stmt = $pdo->prepare("SELECT a.numero_documento, a.nombres, a.apellidos, a.numero_ficha, e.nombre as estado
                       FROM aprendices a
                       JOIN estados e ON a.id_estado = e.id_estado
                       WHERE a.numero_documento = :doc LIMIT 1");
$stmt->execute([':doc' => $documento]);
$aprendiz = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$aprendiz) {
    die("Aprendiz no encontrado.");
}

$stmt_detalles = $pdo->prepare("SELECT c.nombre_comp, r.nombre_resultado, jc.descripcion as juicio,
                                       mr.fecha_registro, i.nombres_apellidos as funcionario
                                FROM matricula_resultados mr
                                JOIN resultados r ON mr.codigo_resul = r.codigo_resul
                                JOIN competencias c ON r.codigo_comp = c.codigo_comp
                                JOIN juicios_catalogo jc ON mr.id_juicio_cat = jc.id_juicio_cat
                                LEFT JOIN instructores i ON mr.num_documento_instructor = i.num_documento
                                WHERE mr.num_documento_aprendiz = :doc
                                ORDER BY c.nombre_comp");
$stmt_detalles->execute([':doc' => $documento]);
$detalles = $stmt_detalles->fetchAll(PDO::FETCH_ASSOC);

?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle del Aprendiz - SGJE</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
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
        
        .sidebar { width: 260px; background: var(--sidebar-bg); color: #fff; position: fixed; height: 100vh; display: flex; flex-direction: column; z-index: 1000; }
        .sidebar-header { padding: 32px 24px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid #1e293b; margin-bottom: 12px; }
        .logo-box { width: 36px; height: 36px; background: var(--primary); border-radius: 8px; display: flex; align-items: center; justify-content: center; color: #fff; }
        .brand-name { font-weight: 700; font-size: 20px; letter-spacing: -0.5px; color: #f8fafc; }
        
        .nav-label { font-size: 11px; font-weight: 600; color: #475569; text-transform: uppercase; letter-spacing: 0.1em; padding: 24px 24px 12px; }
        .nav-item { display: flex; align-items: center; gap: 12px; padding: 14px 24px; color: #94a3b8; text-decoration: none; font-weight: 500; transition: all 0.3s; margin: 0 12px; border-radius: 12px; }
        .nav-item:hover { background: #1e293b; color: #fff; }
        .nav-item.active { background: var(--primary); color: #fff; }
        .nav-item i { width: 18px; height: 18px; }

        .main-content { flex: 1; margin-left: 260px; display: flex; flex-direction: column; }
        .topbar { background: #fff; padding: 24px 40px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 900; }
        .topbar h1 { font-size: 22px; font-weight: 700; color: var(--text-main); }

        .container { padding: 40px; width: 100%; max-width: 1400px; margin: 0 auto; display: flex; flex-direction: column; gap: 32px; }

        .glass-panel { background: #fff; border-radius: var(--radius); border: 1px solid var(--border); padding: 24px; box-shadow: var(--card-shadow); }
        .stat-card { text-align: center; }
        .stat-value { font-size: 32px; font-weight: 800; line-height: 1.2; }
        .stat-label { font-size: 11px; color: var(--text-muted); text-transform: uppercase; font-weight: 700; margin-top: 4px; }

        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 24px; }
        
        .filters-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; }
        .form-group label { display: block; font-size: 11px; font-weight: 700; color: #94a3b8; margin-bottom: 8px; text-transform: uppercase; }
        .form-control { width: 100%; border: 1.5px solid var(--border); padding: 10px 14px; border-radius: 10px; font-family: inherit; font-size: 14px; outline: none; transition: all 0.2s; }
        .form-control:focus { border-color: var(--primary); box-shadow: 0 0 0 3px var(--primary-light); }

        .table-container { overflow-x: auto; border-radius: var(--radius); border: 1px solid var(--border); background: #fff; box-shadow: var(--card-shadow); }
        table { width: 100%; border-collapse: collapse; }
        th { background: #f8faff; padding: 16px 24px; text-align: left; font-size: 11px; font-weight: 700; color: #94a3b8; text-transform: uppercase; border-bottom: 1px solid var(--border); }
        td { padding: 16px 24px; border-bottom: 1px solid var(--border); font-size: 13px; color: #475569; }

        .badge { padding: 4px 10px; border-radius: 99px; font-size: 11px; font-weight: 700; text-transform: uppercase; }
        .aprobado { background: #ecfdf5; color: #059669; }
        .por-evaluar { background: #fffbeb; color: #d97706; }
        .no-aprobado { background: #fef2f2; color: #dc2626; }

        .btn { padding: 10px 24px; border-radius: 10px; border: 1.5px solid var(--border); font-weight: 700; cursor: pointer; text-decoration: none; color: var(--text-main); font-size: 14px; transition: all 0.2s; display: inline-flex; align-items: center; gap: 8px; }
        .btn:hover { background: #f8fafc; border-color: #cbd5e1; }

        /* Pagination */
        .pagination-container { display: flex; align-items: center; justify-content: flex-end; gap: 8px; margin-top: 16px; }
        .page-btn { width: 36px; height: 36px; border-radius: 8px; border: 1px solid var(--border); background: #fff; color: var(--text-main); font-weight: 600; font-size: 14px; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.2s; font-family: inherit; }
        .page-btn:hover:not(:disabled) { border-color: #cbd5e1; background: #f8fafc; }
        .page-btn:disabled { opacity: 0.4; cursor: not-allowed; }
        .page-btn.active { background: var(--sidebar-bg); color: #fff; border-color: var(--sidebar-bg); }
        .page-info { font-size: 13px; color: var(--text-muted); font-weight: 500; margin-left: 12px; }
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
        <a href="analisis.php" class="nav-item"><i data-lucide="search"></i> <span>Análisis Proyecto</span></a>
        <a href="analytics.php" class="nav-item"><i data-lucide="brain-circuit"></i> <span>Inteligencia</span></a>
        <a href="alertas.php" class="nav-item"><i data-lucide="bell-ring"></i> <span>Alertas</span></a>
        <div class="nav-label">Sistema</div>
        <a href="#" onclick="confirmReset()" class="nav-item" style="color: #ef4444;"><i data-lucide="trash-2"></i> <span>Limpiar Todo</span></a>
    </nav>
</aside>

    <main class="main-content">
        <header class="topbar">
            <h1>Perfil del Aprendiz</h1>
            <a href="aprendices.php" class="btn"><i data-lucide="arrow-left"></i> Volver</a>
        </header>

        <div class="container">
            <section class="glass-panel" style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <h2 style="margin: 0; color: var(--primary); font-size: 24px; font-weight: 800;"><?= htmlspecialchars($aprendiz['nombres'] . ' ' . $aprendiz['apellidos']) ?></h2>
                    <p style="margin-top: 8px; color: var(--text-muted); font-size: 14px;">
                        <strong>Documento:</strong> <?= htmlspecialchars($aprendiz['numero_documento']) ?> | 
                        <strong>Ficha:</strong> <?= htmlspecialchars($aprendiz['numero_ficha']) ?> | 
                        <strong>Estado:</strong> <span class="badge aprobado" style="background: var(--primary-light); color: var(--primary);"><?= htmlspecialchars($aprendiz['estado']) ?></span>
                    </p>
                </div>
            </section>

<?php
$total_aprobados = 0;
$total_por_evaluar = 0;
$total_no_aprobados = 0;
foreach($detalles as $row) {
    if ($row['juicio'] === 'APROBADO') $total_aprobados++;
    else if ($row['juicio'] === 'POR EVALUAR') $total_por_evaluar++;
    else if ($row['juicio'] === 'NO APROBADO') $total_no_aprobados++;
}
$total_evaluaciones = count($detalles);
$avance_aprendiz = $total_evaluaciones > 0 ? round(($total_aprobados / $total_evaluaciones) * 100, 2) : 0;
?>
        <div class="stats-grid" style="margin-top: 1.5rem;">
            <div class="glass-panel stat-card" style="margin-bottom: 0;">
                <div class="stat-value" style="color: var(--success);"><?= $total_aprobados ?></div>
                <div class="stat-label">Aprobados</div>
            </div>
            <div class="glass-panel stat-card" style="margin-bottom: 0;">
                <div class="stat-value" style="color: var(--warning);"><?= $total_por_evaluar ?></div>
                <div class="stat-label">Faltan (Por Evaluar)</div>
            </div>
            <div class="glass-panel stat-card" style="margin-bottom: 0;">
                <div class="stat-value" style="color: var(--danger);"><?= $total_no_aprobados ?></div>
                <div class="stat-label">No Aprobados</div>
            </div>
            <div class="glass-panel stat-card" style="margin-bottom: 0;">
                <div class="stat-value" style="color: var(--primary-color);"><?= $avance_aprendiz ?>%</div>
                <div class="stat-label">Avance del Aprendiz</div>
            </div>
        </div>

        <section class="glass-panel" style="margin-top: 1rem;">
            <h3 style="margin-top: 0; margin-bottom: 1rem;">Filtrar Resultados</h3>
            <div class="filters-grid">
                <div class="form-group">
                    <label for="filterCompetencia">Competencia</label>
                    <input type="text" id="filterCompetencia" class="form-control" placeholder="Buscar competencia..." onkeyup="filterDetails()">
                </div>
                <div class="form-group">
                    <label for="filterResultado">Resultado</label>
                    <input type="text" id="filterResultado" class="form-control" placeholder="Buscar resultado..." onkeyup="filterDetails()">
                </div>
                <div class="form-group">
                    <label for="filterFuncionario">Funcionario</label>
                    <input type="text" id="filterFuncionario" class="form-control" placeholder="Buscar funcionario..." onkeyup="filterDetails()">
                </div>
                <div class="form-group">
                    <label for="filterJuicio">Juicio Evaluativo</label>
                    <select id="filterJuicio" class="form-control" onchange="filterDetails()">
                        <option value="">Todos</option>
                        <option value="aprobado">Aprobado</option>
                        <option value="por evaluar">Por Evaluar</option>
                        <option value="no aprobado">No Aprobado</option>
                    </select>
                </div>
            </div>
        </section>

        <section class="glass-panel">
            <h3 style="margin-top: 0;">Historial de Evaluaciones</h3>
            <div class="table-container">
                <table id="detallesTable">
                    <thead>
                        <tr>
                            <th>Competencia</th>
                            <th>Resultado de Aprendizaje</th>
                            <th>Juicio</th>
                            <th>Funcionario</th>
                            <th>Fecha y Hora</th>
                        </tr>
                    </thead>
                    <tbody id="detallesTableBody">
                        <tr><td colspan="5" style="text-align: center; padding: 40px; color: #94a3b8;">Cargando...</td></tr>
                    </tbody>
                </table>
            </div>
            <div id="paginationContainer" class="pagination-container"></div>
        </section>
    <script>
    lucide.createIcons();

    const todasLasEvaluaciones = <?= json_encode($detalles) ?>;
    let filteredEvaluaciones = [...todasLasEvaluaciones];
    let currentPage = 1;
    const itemsPerPage = 10;

    function renderTable() {
        const tbody = document.getElementById('detallesTableBody');
        const container = document.getElementById('paginationContainer');
        if (!tbody) return;

        if (!filteredEvaluaciones.length) {
            tbody.innerHTML = '<tr><td colspan="5" style="text-align: center; padding: 40px; color: #94a3b8;">No se encontraron registros.</td></tr>';
            if (container) container.innerHTML = '';
            return;
        }

        const total = filteredEvaluaciones.length;
        const start = (currentPage - 1) * itemsPerPage;
        const pageData = filteredEvaluaciones.slice(start, start + itemsPerPage);

        tbody.innerHTML = pageData.map(row => {
            let badgeClass = '';
            if (row.juicio === 'APROBADO') badgeClass = 'aprobado';
            else if (row.juicio === 'POR EVALUAR') badgeClass = 'por-evaluar';
            else badgeClass = 'no-aprobado';

            let fechaFormat = row.fecha_registro || '-';
            if (fechaFormat && fechaFormat.length > 10) {
                fechaFormat = fechaFormat.substring(0, 10);
            }

            return `
            <tr>
                <td class="col-comp">${escapeHtml(row.nombre_comp)}</td>
                <td class="col-resul">${escapeHtml(row.nombre_resultado)}</td>
                <td><span class="badge ${badgeClass}">${escapeHtml(row.juicio)}</span></td>
                <td class="col-func">${escapeHtml(row.funcionario || '-')}</td>
                <td>${escapeHtml(fechaFormat)}</td>
            </tr>`;
        }).join('');

        renderPagination(total);
    }

    function renderPagination(total) {
        const container = document.getElementById('paginationContainer');
        if (!container) return;
        if (total <= itemsPerPage) {
            container.innerHTML = '';
            return;
        }

        const totalPages = Math.ceil(total / itemsPerPage);
        let startPage = Math.max(1, currentPage - 2);
        let endPage = Math.min(totalPages, startPage + 4);
        if (endPage - startPage < 4) startPage = Math.max(1, endPage - 4);

        let html = `<button class="page-btn" ${currentPage === 1 ? 'disabled' : ''} onclick="goToPage(${currentPage - 1})">‹</button>`;
        for (let i = startPage; i <= endPage; i++) {
            html += `<button class="page-btn ${currentPage === i ? 'active' : ''}" onclick="goToPage(${i})">${i}</button>`;
        }
        html += `<button class="page-btn" ${currentPage === totalPages ? 'disabled' : ''} onclick="goToPage(${currentPage + 1})">›</button>`;
        
        const from = (currentPage - 1) * itemsPerPage + 1;
        const to = Math.min(currentPage * itemsPerPage, total);
        html += `<div class="page-info">${from}-${to} de ${total}</div>`;

        container.innerHTML = html;
    }

    window.goToPage = function(p) {
        currentPage = p;
        renderTable();
    };

    function filterDetails() {
        const comp = document.getElementById('filterCompetencia').value.toLowerCase();
        const resul = document.getElementById('filterResultado').value.toLowerCase();
        const func = document.getElementById('filterFuncionario').value.toLowerCase();
        const juicio = document.getElementById('filterJuicio').value.toLowerCase();

        filteredEvaluaciones = todasLasEvaluaciones.filter(row => {
            const textComp = (row.nombre_comp || '').toLowerCase();
            const textResul = (row.nombre_resultado || '').toLowerCase();
            const textFunc = (row.funcionario || '').toLowerCase();
            const textJuicio = (row.juicio || '').toLowerCase();

            return textComp.includes(comp) &&
                   textResul.includes(resul) &&
                   textFunc.includes(func) &&
                   (juicio === '' || textJuicio === juicio);
        });

        currentPage = 1;
        renderTable();
    }

    function escapeHtml(str) {
        if (!str) return '';
        return str
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");
    }

    // Inicializar tabla
    renderTable();
    </script>
</body>
</html>

