<?php
/**
 * SGJE — API de Analítica Académica
 * Archivo: api_analytics.php
 *
 * Acciones disponibles (GET ?action=...):
 *   riesgo_academico     → Clasificación BAJO/MEDIO/ALTO por pendientes
 *   ranking              → Top 10 y menor avance
 *   semaforo_competencias→ Verde/Amarillo/Rojo por % aprobación
 *   alertas              → Centro de alertas automáticas
 *   estadisticas_ficha   → KPIs por número de ficha
 *   inteligencia         → Todo en una sola llamada (dashboard completo)
 */

require 'db.php';
header('Content-Type: application/json; charset=utf-8');

$action = $_GET['action'] ?? 'inteligencia';
$ficha  = trim($_GET['ficha']  ?? '');
$fecha_reporte = trim($_GET['fecha_reporte'] ?? '');

// ── Manejo seguro de base de datos vacía (ej. tras delete_all) ───────────────
try {
    $hayFichas = (int)$pdo->query("SELECT COUNT(*) FROM fichas")->fetchColumn();
} catch (Exception $e) {
    $hayFichas = 0;
}

if ($hayFichas === 0) {
    switch ($action) {
        case 'alertas':
            jsonOk(['total' => 0, 'criticas' => 0, 'warnings' => 0, 'alertas' => []]);
        case 'riesgo_academico':
            jsonOk(['resumen' => ['total_aprendices' => 0, 'total_bajo' => 0, 'total_medio' => 0, 'total_alto' => 0], 'aprendices' => []]);
        case 'ranking':
            jsonOk(['top10' => [], 'menor_avance' => []]);
        case 'semaforo_competencias':
            jsonOk(['resumen' => ['total_verdes' => 0, 'total_amarillos' => 0, 'total_rojos' => 0], 'competencias' => []]);
        case 'estadisticas_ficha':
            jsonOk([]);
        case 'inteligencia':
        default:
            jsonOk([
                'generado_en'        => date('c'),
                'id_importacion'     => null,
                'fecha_reporte'      => '',
                'riesgo_academico'   => ['resumen' => ['total_aprendices' => 0, 'total_bajo' => 0, 'total_medio' => 0, 'total_alto' => 0], 'aprendices' => []],
                'ranking'            => ['top10' => [], 'menor_avance' => []],
                'semaforo'           => ['resumen' => ['total_verdes' => 0, 'total_amarillos' => 0, 'total_rojos' => 0], 'competencias' => []],
                'alertas'            => ['total' => 0, 'criticas' => 0, 'warnings' => 0, 'alertas' => []],
                'estadisticas_ficha' => []
            ]);
    }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

function resolverCorte(PDO $pdo, string $ficha, string $fecha_reporte = ''): ?int {
    if ($ficha === '') return null;
    if ($fecha_reporte !== '') {
        $stmt = $pdo->prepare("SELECT id FROM historial_importaciones WHERE numero_ficha = :ficha AND fecha_reporte = :fecha AND estado = 'EXITOSO' ORDER BY id DESC LIMIT 1");
        $stmt->execute([':ficha' => (int)$ficha, ':fecha' => $fecha_reporte]);
    } else {
        $stmt = $pdo->prepare("SELECT id FROM historial_importaciones WHERE numero_ficha = :ficha AND estado = 'EXITOSO' ORDER BY fecha_reporte DESC, fecha_importacion DESC LIMIT 1");
        $stmt->execute([':ficha' => (int)$ficha]);
    }
    $val = $stmt->fetchColumn();
    return $val !== false ? (int)$val : null;
}

$id_corte = resolverCorte($pdo, $ficha, $fecha_reporte);

/**
 * Condición SQL que excluye a los aprendices que ya no están activos
 * (retirados, cancelados, trasladados, aplazados) de las estadísticas de avance.
 */
function estadoActivoCondicion(): string {
    return "COALESCE(e_corte.nombre, e.nombre) NOT IN ('RETIRO VOLUNTARIO', 'CANCELADO', 'TRASLADADO', 'APLAZADO')";
}

/**
 * Construye la cláusula WHERE y devuelve [string_where, array_params]
 * Filtra por ficha y excluye a los inactivos por defecto.
 */
function buildWhere(string $ficha, ?int $idCorte, string $alias = 'a'): array {
    $where  = [estadoActivoCondicion()];
    $params = [':id_corte' => $idCorte];

    if ($ficha !== '') {
        $where[]  = "{$alias}.numero_ficha = :ficha";
        $params[':ficha'] = (int)$ficha;
    }

    return ['WHERE ' . implode(' AND ', $where), $params];
}

function nivelRiesgo(int $pendientes): string {
    if ($pendientes === 0)  return 'BAJO';
    if ($pendientes <= 5)   return 'MEDIO';
    return 'ALTO';
}

function semaforo(float $pct): string {
    if ($pct >= 80) return 'VERDE';
    if ($pct >= 50) return 'AMARILLO';
    return 'ROJO';
}

function jsonOk(mixed $data): void {
    echo json_encode($data, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
    exit;
}

function jsonError(string $msg): void {
    http_response_code(500);
    echo json_encode(['error' => $msg], JSON_UNESCAPED_UNICODE);
    exit;
}

// ══════════════════════════════════════════════════════════════════════════════
// 1. RIESGO ACADÉMICO
// ══════════════════════════════════════════════════════════════════════════════
function getRiesgoAcademico(PDO $pdo, string $ficha, ?int $idCorte): array {
    [$where, $params] = buildWhere($ficha, $idCorte);

    $sql = "
        SELECT
            a.numero_documento,
            a.nombres,
            a.apellidos,
            a.numero_ficha,
            COUNT(mr.id)                                                AS total_resultados,
            COUNT(mr.id) FILTER (WHERE jc.descripcion = 'APROBADO')    AS aprobados,
            COUNT(mr.id) FILTER (WHERE jc.descripcion = 'POR EVALUAR') AS pendientes,
            CASE
                WHEN COUNT(mr.id) = 0 THEN 0
                ELSE ROUND(
                    (COUNT(mr.id) FILTER (WHERE jc.descripcion = 'APROBADO')::numeric
                    / COUNT(mr.id)) * 100, 2
                )
            END AS porcentaje_avance
        FROM aprendices a
        JOIN fichas f ON a.numero_ficha = f.numero_ficha
        JOIN estados e ON a.id_estado = e.id_estado
        LEFT JOIN corte_aprendices ca ON ca.id_importacion = :id_corte AND ca.numero_documento = a.numero_documento
        LEFT JOIN estados e_corte ON e_corte.id_estado = ca.id_estado
        LEFT JOIN matricula_resultados mr
               ON mr.num_documento_aprendiz = a.numero_documento AND (:id_corte::int IS NULL OR mr.id_importacion = :id_corte)
        LEFT JOIN juicios_catalogo jc
               ON jc.id_juicio_cat = mr.id_juicio_cat
        $where
        GROUP BY a.numero_documento, a.nombres, a.apellidos, a.numero_ficha
        ORDER BY pendientes DESC, porcentaje_avance ASC
    ";

    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $aprendices = array_map(function ($r) {
        $pendientes = (int)$r['pendientes'];
        return [
            'numero_documento'  => $r['numero_documento'],
            'nombres'           => $r['nombres'],
            'apellidos'         => $r['apellidos'],
            'numero_ficha'      => (int)$r['numero_ficha'],
            'total_resultados'  => (int)$r['total_resultados'],
            'aprobados'         => (int)$r['aprobados'],
            'pendientes'        => $pendientes,
            'porcentaje_avance' => (float)$r['porcentaje_avance'],
            'nivel_riesgo'      => nivelRiesgo($pendientes),
        ];
    }, $rows);

    $resumen = [
        'total_aprendices' => count($aprendices),
        'total_bajo'   => count(array_filter($aprendices, fn($a) => $a['nivel_riesgo'] === 'BAJO')),
        'total_medio'  => count(array_filter($aprendices, fn($a) => $a['nivel_riesgo'] === 'MEDIO')),
        'total_alto'   => count(array_filter($aprendices, fn($a) => $a['nivel_riesgo'] === 'ALTO')),
    ];

    return ['resumen' => $resumen, 'aprendices' => $aprendices];
}

// ══════════════════════════════════════════════════════════════════════════════
// 2. RANKING DE APRENDICES
// ══════════════════════════════════════════════════════════════════════════════
function getRanking(PDO $pdo, string $ficha, ?int $idCorte): array {
    [$where, $params] = buildWhere($ficha, $idCorte);

    $sql = "
        SELECT
            a.numero_documento,
            a.nombres,
            a.apellidos,
            a.numero_ficha,
            COUNT(mr.id)                                              AS total_resultados,
            COUNT(mr.id) FILTER (WHERE jc.descripcion = 'APROBADO')  AS aprobados,
            CASE
                WHEN COUNT(mr.id) = 0 THEN 0
                ELSE ROUND(
                    (COUNT(mr.id) FILTER (WHERE jc.descripcion = 'APROBADO')::numeric
                    / COUNT(mr.id)) * 100, 2
                )
            END AS porcentaje_avance
        FROM aprendices a
        JOIN fichas f ON a.numero_ficha = f.numero_ficha
        JOIN estados e ON a.id_estado = e.id_estado
        LEFT JOIN corte_aprendices ca ON ca.id_importacion = :id_corte AND ca.numero_documento = a.numero_documento
        LEFT JOIN estados e_corte ON e_corte.id_estado = ca.id_estado
        LEFT JOIN matricula_resultados mr
               ON mr.num_documento_aprendiz = a.numero_documento AND (:id_corte::int IS NULL OR mr.id_importacion = :id_corte)
        LEFT JOIN juicios_catalogo jc
               ON jc.id_juicio_cat = mr.id_juicio_cat
        $where
        GROUP BY a.numero_documento, a.nombres, a.apellidos, a.numero_ficha
        ORDER BY porcentaje_avance DESC, aprobados DESC
    ";

    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $map = function ($r, $pos) {
        return [
            'posicion'          => $pos + 1,
            'numero_documento'  => $r['numero_documento'],
            'nombres'           => $r['nombres'],
            'apellidos'         => $r['apellidos'],
            'numero_ficha'      => (int)$r['numero_ficha'],
            'total_resultados'  => (int)$r['total_resultados'],
            'aprobados'         => (int)$r['aprobados'],
            'porcentaje_avance' => (float)$r['porcentaje_avance'],
        ];
    };

    $top10     = array_map($map, array_slice($rows, 0, 10),     array_keys(array_slice($rows, 0, 10)));
    $menorRows = array_reverse($rows);
    $menorAvance = array_map($map, array_slice($menorRows, 0, 10), array_keys(array_slice($menorRows, 0, 10)));

    return ['top10' => $top10, 'menor_avance' => $menorAvance];
}

// ══════════════════════════════════════════════════════════════════════════════
// 3. SEMÁFORO DE COMPETENCIAS
// ══════════════════════════════════════════════════════════════════════════════
function getSemaforoCompetencias(PDO $pdo, string $ficha, ?int $idCorte): array {
    $where  = [estadoActivoCondicion()];
    $params = [];

    if ($idCorte !== null) {
        $where[] = "mr.id_importacion = :id_corte";
        $params[':id_corte'] = $idCorte;
    } elseif ($ficha !== '') {
        $where[] = 'a.numero_ficha = :ficha';
        $params[':ficha'] = (int)$ficha;
    }

    $whereClause = 'WHERE ' . implode(' AND ', $where);

    $sql = "
        SELECT
            c.codigo_comp,
            c.nombre_comp,
            COUNT(mr.id)                                             AS total_resultados,
            COUNT(mr.id) FILTER (WHERE jc.descripcion = 'APROBADO') AS aprobados,
            CASE
                WHEN COUNT(mr.id) = 0 THEN 0
                ELSE ROUND(
                    (COUNT(mr.id) FILTER (WHERE jc.descripcion = 'APROBADO')::numeric
                    / COUNT(mr.id)) * 100, 2
                )
            END AS porcentaje_aprobacion
        FROM matricula_resultados mr
        JOIN resultados r ON mr.codigo_resul = r.codigo_resul
        JOIN competencias c ON r.codigo_comp = c.codigo_comp
        JOIN aprendices a ON a.numero_documento = mr.num_documento_aprendiz
        LEFT JOIN corte_aprendices ca ON ca.id_importacion = mr.id_importacion AND ca.numero_documento = a.numero_documento
        LEFT JOIN estados e_corte ON e_corte.id_estado = ca.id_estado
        JOIN estados e ON a.id_estado = e.id_estado
        JOIN juicios_catalogo jc ON jc.id_juicio_cat = mr.id_juicio_cat
        $whereClause
        GROUP BY c.codigo_comp, c.nombre_comp
        ORDER BY porcentaje_aprobacion ASC
    ";

    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $competencias = array_map(function ($r) {
        $pct = (float)$r['porcentaje_aprobacion'];
        return [
            'codigo_comp'          => (int)$r['codigo_comp'],
            'nombre_comp'          => $r['nombre_comp'],
            'total_resultados'     => (int)$r['total_resultados'],
            'aprobados'            => (int)$r['aprobados'],
            'porcentaje_aprobacion'=> $pct,
            'estado'               => semaforo($pct),
        ];
    }, $rows);

    $resumen = [
        'total_verdes'    => count(array_filter($competencias, fn($c) => $c['estado'] === 'VERDE')),
        'total_amarillos' => count(array_filter($competencias, fn($c) => $c['estado'] === 'AMARILLO')),
        'total_rojos'     => count(array_filter($competencias, fn($c) => $c['estado'] === 'ROJO')),
    ];

    return ['resumen' => $resumen, 'competencias' => $competencias];
}

// ══════════════════════════════════════════════════════════════════════════════
// 4. CENTRO DE ALERTAS
// ══════════════════════════════════════════════════════════════════════════════
function getAlertas(PDO $pdo, string $ficha, ?int $idCorte): array {
    $alertas = [];

    // ── Alertas riesgo ALTO ───────────────────────────────────────────────────
    [$where, $params] = buildWhere($ficha, $idCorte);

    $sql = "
        SELECT
            a.numero_documento,
            a.nombres,
            a.apellidos,
            a.numero_ficha,
            COUNT(mr.id) FILTER (WHERE jc.descripcion = 'POR EVALUAR') AS pendientes
        FROM aprendices a
        JOIN estados e ON a.id_estado = e.id_estado
        LEFT JOIN corte_aprendices ca ON ca.id_importacion = :id_corte AND ca.numero_documento = a.numero_documento
        LEFT JOIN estados e_corte ON e_corte.id_estado = ca.id_estado
        LEFT JOIN matricula_resultados mr
               ON mr.num_documento_aprendiz = a.numero_documento AND (:id_corte::int IS NULL OR mr.id_importacion = :id_corte)
        LEFT JOIN juicios_catalogo jc ON jc.id_juicio_cat = mr.id_juicio_cat
        $where
        GROUP BY a.numero_documento, a.nombres, a.apellidos, a.numero_ficha
        HAVING COUNT(mr.id) FILTER (WHERE jc.descripcion = 'POR EVALUAR') > 5
        ORDER BY pendientes DESC
    ";
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    foreach ($stmt->fetchAll(PDO::FETCH_ASSOC) as $r) {
        $alertas[] = [
            'tipo'       => 'RIESGO_ALTO',
            'nivel'      => 'CRITICAL',
            'mensaje'    => "Aprendiz {$r['nombres']} {$r['apellidos']} (Ficha {$r['numero_ficha']}) tiene {$r['pendientes']} resultados pendientes.",
            'entidad_id' => $r['numero_documento'],
            'entidad'    => 'APRENDIZ',
        ];
    }

    // ── Alertas competencias ROJO ─────────────────────────────────────────────
    $semaforo = getSemaforoCompetencias($pdo, $ficha, $idCorte);
    foreach ($semaforo['competencias'] as $c) {
        if ($c['estado'] === 'ROJO') {
            $alertas[] = [
                'tipo'       => 'COMPETENCIA_ROJA',
                'nivel'      => 'WARNING',
                'mensaje'    => "Competencia \"{$c['nombre_comp']}\" tiene {$c['porcentaje_aprobacion']}% de aprobación.",
                'entidad_id' => (string)$c['codigo_comp'],
                'entidad'    => 'COMPETENCIA',
            ];
        }
    }

    // ── Alertas fichas con bajo avance ────────────────────────────────────────
    $estadisticas = getEstadisticasFicha($pdo, $ficha, $idCorte);
    foreach ($estadisticas as $f) {
        if ($f['porcentaje_avance'] < 40 && $f['total_asignaciones'] > 0) {
            $alertas[] = [
                'tipo'       => 'FICHA_BAJO_AVANCE',
                'nivel'      => 'WARNING',
                'mensaje'    => "Ficha {$f['numero_ficha']} ({$f['nombre_programa']}) tiene solo {$f['porcentaje_avance']}% de avance general.",
                'entidad_id' => (string)$f['numero_ficha'],
                'entidad'    => 'FICHA',
            ];
        }
    }

    $criticas = count(array_filter($alertas, fn($a) => $a['nivel'] === 'CRITICAL'));
    $warnings = count(array_filter($alertas, fn($a) => $a['nivel'] === 'WARNING'));

    return [
        'total'    => count($alertas),
        'criticas' => $criticas,
        'warnings' => $warnings,
        'alertas'  => $alertas,
    ];
}

// ══════════════════════════════════════════════════════════════════════════════
// 5. ESTADÍSTICAS POR FICHA
// ══════════════════════════════════════════════════════════════════════════════
function getEstadisticasFicha(PDO $pdo, string $ficha, ?int $idCorte): array {
    if ($idCorte !== null && $ficha !== '') {
        $sql = "
            SELECT
                f.numero_ficha,
                p.nombre_programa,
                COUNT(DISTINCT a.numero_documento)                            AS total_aprendices,
                COUNT(mr.id)                                                  AS total_asignaciones,
                COUNT(mr.id) FILTER (WHERE jc.descripcion = 'APROBADO')      AS total_aprobados,
                COUNT(mr.id) FILTER (WHERE jc.descripcion = 'POR EVALUAR')   AS total_pendientes,
                CASE
                    WHEN COUNT(mr.id) = 0 THEN 0
                    ELSE ROUND(
                        (COUNT(mr.id) FILTER (WHERE jc.descripcion = 'APROBADO')::numeric
                        / COUNT(mr.id)) * 100, 2
                    )
                END AS porcentaje_avance,
                CASE
                    WHEN COUNT(DISTINCT a.numero_documento) = 0 THEN 0
                    ELSE ROUND(
                        (COUNT(DISTINCT CASE WHEN jc.descripcion = 'APROBADO'
                            THEN a.numero_documento END)::numeric
                        / COUNT(DISTINCT a.numero_documento)) * 100, 2
                    )
                END AS porcentaje_aprobacion
            FROM fichas f
            JOIN programas p ON p.codigo_programa = f.codigo_programa
            JOIN aprendices a ON a.numero_ficha = f.numero_ficha
            JOIN estados e ON e.id_estado = a.id_estado
            LEFT JOIN corte_aprendices ca ON ca.id_importacion = :id_corte AND ca.numero_documento = a.numero_documento
            LEFT JOIN estados e_corte ON e_corte.id_estado = ca.id_estado
            LEFT JOIN matricula_resultados mr ON mr.num_documento_aprendiz = a.numero_documento AND mr.id_importacion = :id_corte
            LEFT JOIN juicios_catalogo jc ON jc.id_juicio_cat = mr.id_juicio_cat
            WHERE f.numero_ficha = :ficha
              AND COALESCE(e_corte.nombre, e.nombre) NOT IN ('RETIRO VOLUNTARIO', 'CANCELADO', 'TRASLADADO', 'APLAZADO')
            GROUP BY f.numero_ficha, p.nombre_programa
            ORDER BY f.numero_ficha
        ";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([':ficha' => (int)$ficha, ':id_corte' => $idCorte]);
    } else {
        $where  = ["e.nombre NOT IN ('RETIRO VOLUNTARIO', 'CANCELADO', 'TRASLADADO', 'APLAZADO')"];
        $params = [];

        if ($ficha !== '') {
            $where[]          = 'f.numero_ficha = :ficha';
            $params[':ficha'] = (int)$ficha;
        }

        $whereClause = 'WHERE ' . implode(' AND ', $where);

        $sql = "
            SELECT
                f.numero_ficha,
                p.nombre_programa,
                COUNT(DISTINCT a.numero_documento)                            AS total_aprendices,
                COUNT(mr.id)                                                  AS total_asignaciones,
                COUNT(mr.id) FILTER (WHERE jc.descripcion = 'APROBADO')      AS total_aprobados,
                COUNT(mr.id) FILTER (WHERE jc.descripcion = 'POR EVALUAR')   AS total_pendientes,
                CASE
                    WHEN COUNT(mr.id) = 0 THEN 0
                    ELSE ROUND(
                        (COUNT(mr.id) FILTER (WHERE jc.descripcion = 'APROBADO')::numeric
                        / COUNT(mr.id)) * 100, 2
                    )
                END AS porcentaje_avance,
                CASE
                    WHEN COUNT(DISTINCT a.numero_documento) = 0 THEN 0
                    ELSE ROUND(
                        (COUNT(DISTINCT CASE WHEN jc.descripcion = 'APROBADO'
                            THEN a.numero_documento END)::numeric
                        / COUNT(DISTINCT a.numero_documento)) * 100, 2
                    )
                END AS porcentaje_aprobacion
            FROM fichas f
            JOIN programas p ON p.codigo_programa = f.codigo_programa
            JOIN aprendices a ON a.numero_ficha = f.numero_ficha
            JOIN estados e ON e.id_estado = a.id_estado
            LEFT JOIN matricula_resultados mr ON mr.num_documento_aprendiz = a.numero_documento
            LEFT JOIN juicios_catalogo jc ON jc.id_juicio_cat = mr.id_juicio_cat
            $whereClause
            GROUP BY f.numero_ficha, p.nombre_programa
            ORDER BY f.numero_ficha
        ";
        $stmt = $pdo->prepare($sql);
        $stmt->execute($params);
    }

    return array_map(fn($r) => [
        'numero_ficha'         => (int)$r['numero_ficha'],
        'nombre_programa'      => $r['nombre_programa'],
        'total_aprendices'     => (int)$r['total_aprendices'],
        'total_asignaciones'   => (int)$r['total_asignaciones'],
        'total_aprobados'      => (int)$r['total_aprobados'],
        'total_pendientes'     => (int)$r['total_pendientes'],
        'porcentaje_avance'    => (float)$r['porcentaje_avance'],
        'porcentaje_aprobacion'=> (float)$r['porcentaje_aprobacion'],
    ], $stmt->fetchAll(PDO::FETCH_ASSOC));
}

// ══════════════════════════════════════════════════════════════════════════════
// ROUTER
// ══════════════════════════════════════════════════════════════════════════════
try {
    switch ($action) {

        case 'riesgo_academico':
            jsonOk(getRiesgoAcademico($pdo, $ficha, $id_corte));

        case 'ranking':
            jsonOk(getRanking($pdo, $ficha, $id_corte));

        case 'semaforo_competencias':
            jsonOk(getSemaforoCompetencias($pdo, $ficha, $id_corte));

        case 'alertas':
            jsonOk(getAlertas($pdo, $ficha, $id_corte));

        case 'estadisticas_ficha':
            jsonOk(getEstadisticasFicha($pdo, $ficha, $id_corte));

        case 'inteligencia':
        default:
            jsonOk([
                'generado_en'       => date('c'),
                'id_importacion'    => $id_corte,
                'fecha_reporte'     => $fecha_reporte,
                'riesgo_academico'  => getRiesgoAcademico($pdo, $ficha, $id_corte),
                'ranking'           => getRanking($pdo, $ficha, $id_corte),
                'semaforo'          => getSemaforoCompetencias($pdo, $ficha, $id_corte),
                'alertas'           => getAlertas($pdo, $ficha, $id_corte),
                'estadisticas_ficha'=> getEstadisticasFicha($pdo, $ficha, $id_corte),
            ]);
    }
} catch (PDOException $e) {
    jsonError('Error de base de datos: ' . $e->getMessage());
} catch (Exception $e) {
    jsonError('Error del servidor: ' . $e->getMessage());
}