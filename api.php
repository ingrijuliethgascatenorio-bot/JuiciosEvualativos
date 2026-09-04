<?php
require 'db.php';

header('Content-Type: application/json');

$action = $_GET['action'] ?? 'get_dashboard';

// Acciones que borran datos: requieren la clave admin definida en .env (ADMIN_TOKEN)
$accionesProtegidas = ['delete_all', 'delete_ficha'];
if (in_array($action, $accionesProtegidas, true)) {
    $tokenEsperado = $env['ADMIN_TOKEN'] ?? '';
    $tokenRecibido = $_GET['token'] ?? ($_SERVER['HTTP_X_ADMIN_TOKEN'] ?? '');

    if ($tokenEsperado === '' || !hash_equals($tokenEsperado, $tokenRecibido)) {
        http_response_code(403);
        echo json_encode(['success' => false, 'message' => 'No autorizado: falta o es incorrecta la clave de administrador.']);
        exit;
    }
}

// Estados que se excluyen de las estadísticas de avance (no del conteo por estado del chart)
const ESTADOS_INACTIVOS_SQL = "e.nombre NOT IN ('RETIRO VOLUNTARIO', 'CANCELADO', 'TRASLADADO', 'APLAZADO')";

if ($action === 'get_dashboard') {
    $ficha = trim($_GET['ficha'] ?? '');
    $estado = trim($_GET['estado'] ?? '');
    $juicio = trim($_GET['juicio'] ?? '');
    $competencia = trim($_GET['competencia'] ?? '');
    $documento = trim($_GET['documento'] ?? '');

    // Este filtro aplica a los conteos de avance (total, aprobados, por evaluar, tabla),
    // pero NO al chart de estados (stmt4), que debe seguir mostrando a todos, incluidos
    // retirados/cancelados/trasladados/aplazados.
    $where = [ESTADOS_INACTIVOS_SQL];
    $params = [];

    if ($ficha !== '') {
        $where[] = "a.numero_ficha = :ficha";
        $params[':ficha'] = $ficha;
    }
    if ($estado !== '') {
        $where[] = "e.nombre = :estado";
        $params[':estado'] = $estado;
    }
    if ($juicio !== '') {
        $where[] = "jc.descripcion = :juicio";
        $params[':juicio'] = $juicio;
    }
    if ($competencia !== '') {
        $where[] = "c.codigo_comp = :competencia";
        $params[':competencia'] = $competencia;
    }
    if ($documento !== '') {
        $where[] = "a.numero_documento = :documento";
        $params[':documento'] = $documento;
    }

    $whereClause = count($where) > 0 ? "WHERE " . implode(" AND ", $where) : "";
    $limitClause = "LIMIT 500"; // Restauramos el límite normal para ver a todos los aprendices

    // Where del chart de estados: usa los mismos filtros del usuario (ficha/juicio/etc.)
    // pero SIN excluir a los inactivos, porque este chart es justamente el que reporta
    // cuántos hay en cada estado (incluidos retirados, cancelados, etc.).
    $whereChart = array_values(array_filter($where, fn($cond) => $cond !== ESTADOS_INACTIVOS_SQL));
    $whereClauseChart = count($whereChart) > 0 ? "WHERE " . implode(" AND ", $whereChart) : "";

    // 1. Total Aprendices
    $stmt = $pdo->prepare("SELECT COUNT(DISTINCT a.numero_documento) as total FROM aprendices a 
                           JOIN fichas f ON a.numero_ficha = f.numero_ficha
                           LEFT JOIN estados e ON a.id_estado = e.id_estado 
                           LEFT JOIN matricula_resultados mr ON a.numero_documento = mr.num_documento_aprendiz
                           LEFT JOIN juicios_catalogo jc ON mr.id_juicio_cat = jc.id_juicio_cat
                           LEFT JOIN resultados r ON mr.codigo_resul = r.codigo_resul
                           LEFT JOIN competencias c ON r.codigo_comp = c.codigo_comp AND c.codigo_programa = f.codigo_programa
                           $whereClause");
    $stmt->execute($params);
    $totalAprendices = (int)($stmt->fetch(PDO::FETCH_ASSOC)['total'] ?? 0);

    // 2. Juicios Aprobados
    $stmt2 = $pdo->prepare("SELECT COUNT(*) as total FROM matricula_resultados mr
                            JOIN aprendices a ON mr.num_documento_aprendiz = a.numero_documento
                            JOIN fichas f ON a.numero_ficha = f.numero_ficha
                            LEFT JOIN estados e ON a.id_estado = e.id_estado
                            JOIN juicios_catalogo jc ON mr.id_juicio_cat = jc.id_juicio_cat
                            JOIN resultados r ON mr.codigo_resul = r.codigo_resul
                            JOIN competencias c ON r.codigo_comp = c.codigo_comp AND c.codigo_programa = f.codigo_programa
                            $whereClause " . ($whereClause ? "AND jc.descripcion = 'APROBADO'" : "WHERE jc.descripcion = 'APROBADO'"));
    $stmt2->execute($params);
    $juiciosAprobados = (int)($stmt2->fetch(PDO::FETCH_ASSOC)['total'] ?? 0);

    // 3. Juicios Por Evaluar
    $stmt3 = $pdo->prepare("SELECT COUNT(*) as total FROM matricula_resultados mr
                            JOIN aprendices a ON mr.num_documento_aprendiz = a.numero_documento
                            JOIN fichas f ON a.numero_ficha = f.numero_ficha
                            LEFT JOIN estados e ON a.id_estado = e.id_estado
                            JOIN juicios_catalogo jc ON mr.id_juicio_cat = jc.id_juicio_cat
                            JOIN resultados r ON mr.codigo_resul = r.codigo_resul
                            JOIN competencias c ON r.codigo_comp = c.codigo_comp AND c.codigo_programa = f.codigo_programa
                            $whereClause " . ($whereClause ? "AND jc.descripcion = 'POR EVALUAR'" : "WHERE jc.descripcion = 'POR EVALUAR'"));
    $stmt3->execute($params);
    $juiciosPorEvaluar = (int)($stmt3->fetch(PDO::FETCH_ASSOC)['total'] ?? 0);

    // Avance General %
    $totalJuicios = $juiciosAprobados + $juiciosPorEvaluar;
    $avanceGeneral = $totalJuicios > 0 ? round(($juiciosAprobados / $totalJuicios) * 100, 2) : 0;

    // Estados para Chart
    $stmt4 = $pdo->prepare("SELECT e.nombre, COUNT(DISTINCT a.numero_documento) as count 
                            FROM aprendices a 
                            JOIN estados e ON a.id_estado = e.id_estado 
                            LEFT JOIN matricula_resultados mr ON a.numero_documento = mr.num_documento_aprendiz
                            LEFT JOIN juicios_catalogo jc ON mr.id_juicio_cat = jc.id_juicio_cat
                            LEFT JOIN resultados r ON mr.codigo_resul = r.codigo_resul
                            LEFT JOIN competencias c ON r.codigo_comp = c.codigo_comp
                            $whereClauseChart
                            GROUP BY e.nombre");
    $stmt4->execute($params);
    $estadosData = $stmt4->fetchAll(PDO::FETCH_ASSOC);

    // Tabla de Detalles (Un resumen por aprendiz)
    $stmt5 = $pdo->prepare("SELECT DISTINCT ON (a.numero_documento) 
                                   a.numero_documento, a.nombres, a.apellidos, a.numero_ficha, e.nombre as estado, 
                                   c.nombre_comp, r.nombre_resultado, jc.descripcion as juicio
                            FROM aprendices a
                            JOIN fichas f ON a.numero_ficha = f.numero_ficha
                            JOIN estados e ON a.id_estado = e.id_estado
                            LEFT JOIN matricula_resultados mr ON a.numero_documento = mr.num_documento_aprendiz
                            LEFT JOIN resultados r ON mr.codigo_resul = r.codigo_resul
                            LEFT JOIN competencias c ON r.codigo_comp = c.codigo_comp AND c.codigo_programa = f.codigo_programa
                            LEFT JOIN juicios_catalogo jc ON mr.id_juicio_cat = jc.id_juicio_cat
                            $whereClause 
                            ORDER BY a.numero_documento, c.nombre_comp 
                            $limitClause");
    $stmt5->execute($params);
    $tablaData = $stmt5->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        'totalAprendices' => $totalAprendices,
        'juiciosAprobados' => $juiciosAprobados,
        'juiciosPorEvaluar' => $juiciosPorEvaluar,
        'avanceGeneral' => $avanceGeneral,
        'estadosData' => $estadosData,
        'tablaData' => $tablaData
    ]);
    exit;
}

if ($action === 'get_project_analysis') {
    $ficha = $_GET['ficha'] ?? '';

    $where = [ESTADOS_INACTIVOS_SQL];
    $params = [];

    if ($ficha !== '') {
        $where[] = "f.numero_ficha = :ficha";
        $params[':ficha'] = $ficha;
    }

    $competencia = $_GET['competencia'] ?? '';
    if ($competencia !== '') {
        $where[] = "(c.codigo_comp::text LIKE :comp OR c.nombre_comp ILIKE :comp)";
        $params[':comp'] = "%$competencia%";
    }

    $whereClause = count($where) > 0 ? "WHERE " . implode(" AND ", $where) : "";

    // Nueva consulta optimizada: Solo une resultados con aprendices de fichas que pertenecen al programa del resultado
    $sql = "SELECT 
                c.codigo_comp, 
                c.nombre_comp, 
                r.codigo_resul, 
                r.nombre_resultado,
                COUNT(DISTINCT a.numero_documento) as total_aprendices,
                SUM(CASE WHEN jc.descripcion = 'APROBADO' THEN 1 ELSE 0 END) as aprobados,
                SUM(CASE WHEN jc.descripcion = 'POR EVALUAR' THEN 1 ELSE 0 END) as por_evaluar,
                SUM(CASE WHEN jc.descripcion = 'NO APROBADO' THEN 1 ELSE 0 END) as no_aprobados
            FROM competencias c
            JOIN resultados r ON c.codigo_comp = r.codigo_comp
            JOIN fichas f ON f.codigo_programa = c.codigo_programa
            JOIN aprendices a ON a.numero_ficha = f.numero_ficha
            JOIN estados e ON a.id_estado = e.id_estado
            LEFT JOIN matricula_resultados mr ON mr.codigo_resul = r.codigo_resul AND mr.num_documento_aprendiz = a.numero_documento
            LEFT JOIN juicios_catalogo jc ON mr.id_juicio_cat = jc.id_juicio_cat
            $whereClause
            GROUP BY c.codigo_comp, c.nombre_comp, r.codigo_resul, r.nombre_resultado
            ORDER BY c.nombre_comp, r.nombre_resultado";
    
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    $analysisData = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Agrupar por competencia para facilitar el renderizado
    $groupedData = [];
    foreach ($analysisData as $row) {
        $compId = $row['codigo_comp'];
        if (!isset($groupedData[$compId])) {
            $groupedData[$compId] = [
                'nombre' => $row['nombre_comp'],
                'resultados' => []
            ];
        }
        $groupedData[$compId]['resultados'][] = [
            'codigo_resul' => $row['codigo_resul'],
            'nombre' => $row['nombre_resultado'],
            'total' => $row['total_aprendices'],
            'aprobados' => $row['aprobados'],
            'por_evaluar' => $row['por_evaluar'],
            'no_aprobados' => $row['no_aprobados']
        ];
    }

    echo json_encode(array_values($groupedData));
    exit;
}

if ($action === 'delete_all') {
    try {
        $pdo->beginTransaction();
        $pdo->exec("DELETE FROM matricula_resultados");
        $pdo->exec("DELETE FROM aprendices");
        $pdo->exec("DELETE FROM fichas");
        $pdo->exec("DELETE FROM resultados");
        $pdo->exec("DELETE FROM competencias");
        $pdo->exec("DELETE FROM programas");
        // No borramos estados ni juicios_catalogo porque son maestros básicos
        $pdo->commit();
        echo json_encode(['success' => true, 'message' => 'Toda la información ha sido eliminada correctamente.']);
    } catch (Exception $e) {
        if ($pdo->inTransaction()) $pdo->rollBack();
        echo json_encode(['success' => false, 'message' => 'Error al eliminar: ' . $e->getMessage()]);
    }
    exit;
}

if ($action === 'delete_ficha') {
    $ficha = $_GET['ficha'] ?? '';
    if ($ficha === '') {
        echo json_encode(['success' => false, 'message' => 'Debe especificar una ficha.']);
        exit;
    }

    try {
        $pdo->beginTransaction();
        // 1. Borrar juicios de los aprendices de esa ficha
        $pdo->prepare("DELETE FROM matricula_resultados WHERE num_documento_aprendiz IN (SELECT numero_documento FROM aprendices WHERE numero_ficha = ?)")->execute([$ficha]);
        // 2. Borrar aprendices de esa ficha
        $pdo->prepare("DELETE FROM aprendices WHERE numero_ficha = ?")->execute([$ficha]);
        // 3. Borrar la ficha
        $pdo->prepare("DELETE FROM fichas WHERE numero_ficha = ?")->execute([$ficha]);
        
        $pdo->commit();
        echo json_encode(['success' => true, 'message' => "La ficha $ficha y sus datos relacionados han sido eliminados."]);
    } catch (Exception $e) {
        if ($pdo->inTransaction()) $pdo->rollBack();
        echo json_encode(['success' => false, 'message' => 'Error al eliminar la ficha: ' . $e->getMessage()]);
    }
    exit;
}

if ($action === 'get_fichas') {
    try {
        $stmt = $pdo->query("SELECT numero_ficha FROM fichas ORDER BY numero_ficha ASC");
        $fichas = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($fichas);
    } catch (Exception $e) {
        echo json_encode([]);
    }
    exit;
}

if ($action === 'get_all_aprendices') {
    $ficha = $_GET['ficha'] ?? '';
    $estado = $_GET['estado'] ?? '';
    $juicio = $_GET['juicio'] ?? '';
    $competencia = $_GET['competencia'] ?? '';
    $search = $_GET['search'] ?? '';

    $where = [];
    $params = [];

    if ($ficha !== '') {
        $where[] = "a.numero_ficha = :ficha";
        $params[':ficha'] = $ficha;
    }
    if ($estado !== '') {
        $where[] = "e.nombre = :estado";
        $params[':estado'] = $estado;
    }
    if ($juicio !== '') {
        $where[] = "jc.descripcion = :juicio";
        $params[':juicio'] = $juicio;
    }
    if ($competencia !== '') {
        $where[] = "c.codigo_comp = :competencia";
        $params[':competencia'] = $competencia;
    }
    if ($search !== '') {
        $where[] = "(a.numero_documento LIKE :search OR a.nombres LIKE :search OR a.apellidos LIKE :search)";
        $params[':search'] = "%$search%";
    }

    $whereClause = count($where) > 0 ? "WHERE " . implode(" AND ", $where) : "";

    $sql = "SELECT * FROM (
                SELECT DISTINCT ON (a.numero_documento) 
                       a.numero_documento, a.nombres, a.apellidos, a.numero_ficha, e.nombre as estado,
                       (SELECT COUNT(*) FROM matricula_resultados mr2 
                        JOIN juicios_catalogo jc2 ON mr2.id_juicio_cat = jc2.id_juicio_cat 
                        WHERE mr2.num_documento_aprendiz = a.numero_documento AND jc2.descripcion = 'APROBADO') as aprobados,
                       (SELECT COUNT(*) FROM matricula_resultados mr3 
                        WHERE mr3.num_documento_aprendiz = a.numero_documento) as total
                FROM aprendices a
                JOIN estados e ON a.id_estado = e.id_estado
                LEFT JOIN matricula_resultados mr ON mr.num_documento_aprendiz = a.numero_documento
                LEFT JOIN juicios_catalogo jc ON jc.id_juicio_cat = mr.id_juicio_cat
                LEFT JOIN resultados r ON mr.codigo_resul = r.codigo_resul
                LEFT JOIN competencias c ON r.codigo_comp = c.codigo_comp
                $whereClause
                ORDER BY a.numero_documento
            ) sub
            ORDER BY sub.nombres ASC";
    
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    $aprendices = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode($aprendices);
    exit;
}

if ($action === 'get_result_apprentices') {
    $codigo_resul = $_GET['codigo_resul'] ?? '';
    $ficha = $_GET['ficha'] ?? '';

    if ($codigo_resul === '') {
        echo json_encode([]);
        exit;
    }

    $where = ["mr.codigo_resul = :resul", "jc.descripcion = 'APROBADO'"];
    $params = [':resul' => $codigo_resul];

    if ($ficha !== '') {
        $where[] = "a.numero_ficha = :ficha";
        $params[':ficha'] = $ficha;
    }

    $whereClause = "WHERE " . implode(" AND ", $where);

    $sql = "SELECT a.numero_documento, a.nombres, a.apellidos, a.numero_ficha
            FROM aprendices a
            JOIN matricula_resultados mr ON a.numero_documento = mr.num_documento_aprendiz
            JOIN juicios_catalogo jc ON mr.id_juicio_cat = jc.id_juicio_cat
            $whereClause
            ORDER BY a.nombres ASC";
    
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
    exit;
}
?>