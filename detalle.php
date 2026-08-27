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
            <a href="alertas.php" class="nav-item"><i data-lucide="bell-ring"></i> <span>Alertas</span></a>
            <a href="index.php#uploadSection" class="nav-item"><i data-lucide="file-up"></i> <span>Carga Masiva</span></a>
            <div class="nav-label">Sistema</div>
            <a href="#" onclick="confirmReset()" class="nav-item" style="color: #ef4444;"><i data-lucide="trash-2"></i> <span>Limpiar Todo</span></a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <h1>Perfil del Aprendiz</h1>
            <a href="aprendices.php" class="btn btn-outline"><i data-lucide="arrow-left"></i> Volver</a>
        </header>

        <div class="container">
            <section class="card" style="padding: 24px;">
                <div style="display: flex; align-items: center; gap: 20px;">
                    <div style="width: 54px; height: 54px; border-radius: 50%; background: var(--primary-light); color: var(--primary); display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 18px; flex-shrink: 0;">
                        <?= strtoupper($aprendiz['nombres'][0] . $aprendiz['apellidos'][0]) ?>
                    </div>
                    <div>
                        <h2 style="color: var(--text-main); font-size: 20px; font-weight: 700; margin: 0;"><?= htmlspecialchars($aprendiz['nombres'] . ' ' . $aprendiz['apellidos']) ?></h2>
                        <p style="margin-top: 6px; color: var(--text-muted); font-size: 13px;">
                            <strong>Documento:</strong> <?= htmlspecialchars($aprendiz['numero_documento']) ?> &nbsp;•&nbsp; 
                            <strong>Ficha:</strong> <?= htmlspecialchars($aprendiz['numero_ficha']) ?> &nbsp;•&nbsp; 
                            <strong>Estado:</strong> <span class="badge aprobado"><?= htmlspecialchars($aprendiz['estado']) ?></span>
                        </p>
                    </div>
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
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-val" style="color: var(--success);"><?= $total_aprobados ?></div>
                <div class="stat-lbl">Aprobados</div>
            </div>
            <div class="stat-card">
                <div class="stat-val" style="color: var(--warning);"><?= $total_por_evaluar ?></div>
                <div class="stat-lbl">Pendientes</div>
            </div>
            <div class="stat-card">
                <div class="stat-val" style="color: var(--danger);"><?= $total_no_aprobados ?></div>
                <div class="stat-lbl">No Aprobados</div>
            </div>
            <div class="stat-card">
                <div class="stat-val" style="color: var(--primary);"><?= $avance_aprendiz ?>%</div>
                <div class="stat-lbl">Avance General</div>
            </div>
        </div>

        <section class="card">
            <div class="card-header">Filtrar Resultados</div>
            <div class="card-body">
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
        </div>
    </section>

        <section class="card">
            <div class="card-header">Historial de Evaluaciones</div>
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

