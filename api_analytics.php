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
// 6. COMPARADOR EVOLUTIVO ENTRE CORTES (TIME-TRAVEL / DIFF)
// ══════════════════════════════════════════════════════════════════════════════
function getComparacionCortes(PDO $pdo, string $ficha, string $fechaA, string $fechaB): array {
    if ($ficha === '') {
        return ['error' => 'Debe especificar el número de ficha para comparar cortes.'];
    }

    $numFicha = (int)$ficha;

    // Obtener todos los cortes exitosos de esta ficha ordenados descendentemente
    $stmtCortes = $pdo->prepare("
        SELECT id, fecha_reporte, fecha_importacion, nombre_archivo
        FROM historial_importaciones
        WHERE numero_ficha = :ficha AND estado = 'EXITOSO'
        ORDER BY fecha_reporte DESC, fecha_importacion DESC
    ");
    $stmtCortes->execute([':ficha' => $numFicha]);
    $todosCortes = $stmtCortes->fetchAll(PDO::FETCH_ASSOC);

    if (empty($todosCortes)) {
        return ['error' => 'No existen cortes registrados para esta ficha.'];
    }

    if (count($todosCortes) < 2 && ($fechaA === '' || $fechaB === '')) {
        return [
            'error' => 'Se requieren al menos dos fechas de corte distintas para generar el análisis comparativo.',
            'total_cortes' => count($todosCortes),
            'cortes_disponibles' => $todosCortes
        ];
    }

    // Resolver corte A y B
    $corteA = null;
    $corteB = null;

    if ($fechaA !== '') {
        foreach ($todosCortes as $c) {
            if ($c['fecha_reporte'] === $fechaA || (string)$c['id'] === $fechaA) {
                $corteA = $c;
                break;
            }
        }
    }
    if ($fechaB !== '') {
        foreach ($todosCortes as $c) {
            if ($c['fecha_reporte'] === $fechaB || (string)$c['id'] === $fechaB) {
                $corteB = $c;
                break;
            }
        }
    }

    // Si no se pasaron fechas o alguna no coincidió, tomar por defecto los 2 últimos cortes
    if (!$corteB) {
        $corteB = $todosCortes[0]; // Más reciente
    }
    if (!$corteA) {
        $corteA = isset($todosCortes[1]) ? $todosCortes[1] : $todosCortes[0]; // Anterior
    }

    // Asegurar que Corte A sea cronológicamente el anterior y Corte B el posterior
    if ($corteA['fecha_reporte'] > $corteB['fecha_reporte']) {
        $temp = $corteA;
        $corteA = $corteB;
        $corteB = $temp;
    }

    $idA = (int)$corteA['id'];
    $idB = (int)$corteB['id'];

    // Días transcurridos
    $dtA = new DateTime($corteA['fecha_reporte']);
    $dtB = new DateTime($corteB['fecha_reporte']);
    $diasTranscurridos = $dtA->diff($dtB)->days;

    // Métricas Ficha para Corte A
    $stmtStatsA = $pdo->prepare("
        SELECT 
            COUNT(DISTINCT a.numero_documento)                                         AS total_aprendices,
            COUNT(mr.id)                                                               AS total_asignaciones,
            COUNT(mr.id) FILTER (WHERE jc.descripcion = 'APROBADO')                   AS total_aprobados,
            COUNT(mr.id) FILTER (WHERE jc.descripcion = 'POR EVALUAR')                AS total_pendientes
        FROM fichas f
        JOIN aprendices a ON a.numero_ficha = f.numero_ficha
        LEFT JOIN corte_aprendices ca ON ca.id_importacion = :id_corte AND ca.numero_documento = a.numero_documento
        JOIN estados e ON e.id_estado = a.id_estado
        LEFT JOIN matricula_resultados mr ON mr.num_documento_aprendiz = a.numero_documento AND mr.id_importacion = :id_corte
        LEFT JOIN juicios_catalogo jc ON jc.id_juicio_cat = mr.id_juicio_cat
        WHERE f.numero_ficha = :ficha
          AND COALESCE(ca.id_estado, a.id_estado) NOT IN (SELECT id_estado FROM estados WHERE nombre IN ('RETIRO VOLUNTARIO', 'CANCELADO', 'TRASLADADO', 'APLAZADO'))
    ");
    $stmtStatsA->execute([':id_corte' => $idA, ':ficha' => $numFicha]);
    $resA = $stmtStatsA->fetch(PDO::FETCH_ASSOC) ?: [];

    // Métricas Ficha para Corte B
    $stmtStatsB = $pdo->prepare("
        SELECT 
            COUNT(DISTINCT a.numero_documento)                                         AS total_aprendices,
            COUNT(mr.id)                                                               AS total_asignaciones,
            COUNT(mr.id) FILTER (WHERE jc.descripcion = 'APROBADO')                   AS total_aprobados,
            COUNT(mr.id) FILTER (WHERE jc.descripcion = 'POR EVALUAR')                AS total_pendientes
        FROM fichas f
        JOIN aprendices a ON a.numero_ficha = f.numero_ficha
        LEFT JOIN corte_aprendices ca ON ca.id_importacion = :id_corte AND ca.numero_documento = a.numero_documento
        JOIN estados e ON e.id_estado = a.id_estado
        LEFT JOIN matricula_resultados mr ON mr.num_documento_aprendiz = a.numero_documento AND mr.id_importacion = :id_corte
        LEFT JOIN juicios_catalogo jc ON jc.id_juicio_cat = mr.id_juicio_cat
        WHERE f.numero_ficha = :ficha
          AND COALESCE(ca.id_estado, a.id_estado) NOT IN (SELECT id_estado FROM estados WHERE nombre IN ('RETIRO VOLUNTARIO', 'CANCELADO', 'TRASLADADO', 'APLAZADO'))
    ");
    $stmtStatsB->execute([':id_corte' => $idB, ':ficha' => $numFicha]);
    $resB = $stmtStatsB->fetch(PDO::FETCH_ASSOC) ?: [];

    $asigA = (int)($resA['total_asignaciones'] ?? 0);
    $aprobA = (int)($resA['total_aprobados'] ?? 0);
    $pendA = (int)($resA['total_pendientes'] ?? 0);
    $pctAvanceA = $asigA > 0 ? round(($aprobA / $asigA) * 100, 2) : 0.0;

    $asigB = (int)($resB['total_asignaciones'] ?? 0);
    $aprobB = (int)($resB['total_aprobados'] ?? 0);
    $pendB = (int)($resB['total_pendientes'] ?? 0);
    $pctAvanceB = $asigB > 0 ? round(($aprobB / $asigB) * 100, 2) : 0.0;

    $diffAprobados = $aprobB - $aprobA;
    $diffPendientes = $pendB - $pendA;
    $diffAvance = round($pctAvanceB - $pctAvanceA, 2);

    $esEstancado = ($diffAprobados <= 0 && $diasTranscurridos >= 15);

    // Evolución por Aprendiz
    $sqlAprendices = "
        SELECT 
            a.numero_documento,
            a.nombres,
            a.apellidos,
            COUNT(mr_a.id)                                                AS asig_a,
            COUNT(mr_a.id) FILTER (WHERE jc_a.descripcion = 'APROBADO')   AS aprob_a,
            COUNT(mr_a.id) FILTER (WHERE jc_a.descripcion = 'POR EVALUAR') AS pend_a,
            COUNT(mr_b.id)                                                AS asig_b,
            COUNT(mr_b.id) FILTER (WHERE jc_b.descripcion = 'APROBADO')   AS aprob_b,
            COUNT(mr_b.id) FILTER (WHERE jc_b.descripcion = 'POR EVALUAR') AS pend_b
        FROM aprendices a
        LEFT JOIN corte_aprendices ca_b ON ca_b.id_importacion = :id_b AND ca_b.numero_documento = a.numero_documento
        LEFT JOIN matricula_resultados mr_a ON mr_a.num_documento_aprendiz = a.numero_documento AND mr_a.id_importacion = :id_a
        LEFT JOIN juicios_catalogo jc_a ON jc_a.id_juicio_cat = mr_a.id_juicio_cat
        LEFT JOIN matricula_resultados mr_b ON mr_b.num_documento_aprendiz = a.numero_documento AND mr_b.id_importacion = :id_b
        LEFT JOIN juicios_catalogo jc_b ON jc_b.id_juicio_cat = mr_b.id_juicio_cat
        WHERE a.numero_ficha = :ficha
          AND COALESCE(ca_b.id_estado, a.id_estado) NOT IN (SELECT id_estado FROM estados WHERE nombre IN ('RETIRO VOLUNTARIO', 'CANCELADO', 'TRASLADADO', 'APLAZADO'))
        GROUP BY a.numero_documento, a.nombres, a.apellidos
        ORDER BY (COUNT(mr_b.id) FILTER (WHERE jc_b.descripcion = 'APROBADO') - COUNT(mr_a.id) FILTER (WHERE jc_a.descripcion = 'APROBADO')) DESC, a.apellidos, a.nombres
    ";
    $stmtAp = $pdo->prepare($sqlAprendices);
    $stmtAp->execute([':ficha' => $numFicha, ':id_a' => $idA, ':id_b' => $idB]);
    $filasAp = $stmtAp->fetchAll(PDO::FETCH_ASSOC);

    $aprendicesEvolucion = [];
    $totalMejoraron = 0;
    $totalSalieronRiesgo = 0;

    foreach ($filasAp as $ap) {
        $totA = (int)$ap['asig_a'];
        $apA = (int)$ap['aprob_a'];
        $peA = (int)$ap['pend_a'];
        $pctA = $totA > 0 ? round(($apA / $totA) * 100, 1) : 0.0;
        $riesgoA = nivelRiesgo($peA);

        $totB = (int)$ap['asig_b'];
        $apB = (int)$ap['aprob_b'];
        $peB = (int)$ap['pend_b'];
        $pctB = $totB > 0 ? round(($apB / $totB) * 100, 1) : 0.0;
        $riesgoB = nivelRiesgo($peB);

        $diffJuicios = $apB - $apA;
        $diffPct = round($pctB - $pctA, 1);

        if ($diffJuicios > 0) $totalMejoraron++;
        $salioDeRiesgo = ($riesgoA === 'ALTO' && $riesgoB !== 'ALTO');
        if ($salioDeRiesgo) $totalSalieronRiesgo++;

        $aprendicesEvolucion[] = [
            'documento'        => $ap['numero_documento'],
            'nombres'          => $ap['nombres'],
            'apellidos'        => $ap['apellidos'],
            'nombre_completo'  => trim($ap['nombres'] . ' ' . $ap['apellidos']),
            'aprobados_a'      => $apA,
            'pendientes_a'     => $peA,
            'avance_a'         => $pctA,
            'riesgo_a'         => $riesgoA,
            'aprobados_b'      => $apB,
            'pendientes_b'     => $peB,
            'avance_b'         => $pctB,
            'riesgo_b'         => $riesgoB,
            'diff_juicios'     => $diffJuicios,
            'diff_pct'         => $diffPct,
            'salio_de_riesgo'  => $salioDeRiesgo
        ];
    }

    // Evolución por Competencia
    $sqlComp = "
        SELECT 
            c.codigo_comp,
            c.nombre_comp,
            COUNT(mr_a.id)                                                AS asig_a,
            COUNT(mr_a.id) FILTER (WHERE jc_a.descripcion = 'APROBADO')   AS aprob_a,
            COUNT(mr_b.id)                                                AS asig_b,
            COUNT(mr_b.id) FILTER (WHERE jc_b.descripcion = 'APROBADO')   AS aprob_b
        FROM competencias c
        JOIN resultados r ON r.codigo_comp = c.codigo_comp
        JOIN aprendices a ON a.numero_ficha = :ficha
        LEFT JOIN matricula_resultados mr_a ON mr_a.codigo_resul = r.codigo_resul AND mr_a.num_documento_aprendiz = a.numero_documento AND mr_a.id_importacion = :id_a
        LEFT JOIN juicios_catalogo jc_a ON jc_a.id_juicio_cat = mr_a.id_juicio_cat
        LEFT JOIN matricula_resultados mr_b ON mr_b.codigo_resul = r.codigo_resul AND mr_b.num_documento_aprendiz = a.numero_documento AND mr_b.id_importacion = :id_b
        LEFT JOIN juicios_catalogo jc_b ON jc_b.id_juicio_cat = mr_b.id_juicio_cat
        GROUP BY c.codigo_comp, c.nombre_comp
        HAVING COUNT(mr_a.id) > 0 OR COUNT(mr_b.id) > 0
        ORDER BY (COUNT(mr_b.id) FILTER (WHERE jc_b.descripcion = 'APROBADO') - COUNT(mr_a.id) FILTER (WHERE jc_a.descripcion = 'APROBADO')) DESC, c.nombre_comp
    ";
    $stmtCmp = $pdo->prepare($sqlComp);
    $stmtCmp->execute([':ficha' => $numFicha, ':id_a' => $idA, ':id_b' => $idB]);
    $filasComp = $stmtCmp->fetchAll(PDO::FETCH_ASSOC);

    $competenciasEvolucion = [];
    foreach ($filasComp as $cp) {
        $totCa = (int)$cp['asig_a'];
        $apCa = (int)$cp['aprob_a'];
        $pctCa = $totCa > 0 ? round(($apCa / $totCa) * 100, 1) : 0.0;

        $totCb = (int)$cp['asig_b'];
        $apCb = (int)$cp['aprob_b'];
        $pctCb = $totCb > 0 ? round(($apCb / $totCb) * 100, 1) : 0.0;

        $competenciasEvolucion[] = [
            'codigo_comp'   => (int)$cp['codigo_comp'],
            'nombre_comp'   => $cp['nombre_comp'],
            'aprobados_a'   => $apCa,
            'pct_a'         => $pctCa,
            'aprobados_b'   => $apCb,
            'pct_b'         => $pctCb,
            'diff_juicios'  => $apCb - $apCa,
            'diff_pct'      => round($pctCb - $pctCa, 1),
            'estado_b'      => semaforo($pctCb)
        ];
    }

    // Bitácora de Nuevos Juicios Aprobados (específicamente qué se aprobó en B que no estaba en A)
    $sqlNuevos = "
        SELECT 
            a.numero_documento,
            a.nombres,
            a.apellidos,
            c.nombre_comp,
            r.nombre_resultado,
            mr_b.fecha_registro,
            COALESCE(i.nombres_apellidos, 'Sin instructor') as instructor
        FROM matricula_resultados mr_b
        JOIN juicios_catalogo jc_b ON mr_b.id_juicio_cat = jc_b.id_juicio_cat AND jc_b.descripcion = 'APROBADO'
        JOIN aprendices a ON a.numero_documento = mr_b.num_documento_aprendiz
        JOIN resultados r ON r.codigo_resul = mr_b.codigo_resul
        JOIN competencias c ON c.codigo_comp = r.codigo_comp
        LEFT JOIN instructores i ON i.num_documento = mr_b.num_documento_instructor
        LEFT JOIN matricula_resultados mr_a ON mr_a.id_importacion = :id_a 
             AND mr_a.num_documento_aprendiz = mr_b.num_documento_aprendiz 
             AND mr_a.codigo_resul = mr_b.codigo_resul
        LEFT JOIN juicios_catalogo jc_a ON mr_a.id_juicio_cat = jc_a.id_juicio_cat
        WHERE mr_b.id_importacion = :id_b
          AND a.numero_ficha = :ficha
          AND (mr_a.id IS NULL OR jc_a.descripcion != 'APROBADO')
        ORDER BY c.nombre_comp, a.apellidos, a.nombres
        LIMIT 250
    ";
    $stmtNuevos = $pdo->prepare($sqlNuevos);
    $stmtNuevos->execute([':ficha' => $numFicha, ':id_a' => $idA, ':id_b' => $idB]);
    $nuevosAprobadosLog = $stmtNuevos->fetchAll(PDO::FETCH_ASSOC);

    return [
        'success'              => true,
        'ficha'                => $numFicha,
        'corte_base'           => [
            'id'             => $idA,
            'fecha_reporte'  => $corteA['fecha_reporte'],
            'nombre_archivo' => $corteA['nombre_archivo'],
            'total_aprobados'=> $aprobA,
            'total_pendientes'=> $pendA,
            'porcentaje_avance'=> $pctAvanceA
        ],
        'corte_comparacion'    => [
            'id'             => $idB,
            'fecha_reporte'  => $corteB['fecha_reporte'],
            'nombre_archivo' => $corteB['nombre_archivo'],
            'total_aprobados'=> $aprobB,
            'total_pendientes'=> $pendB,
            'porcentaje_avance'=> $pctAvanceB
        ],
        'resumen_diferencial'  => [
            'dias_transcurridos'    => $diasTranscurridos,
            'diff_aprobados'        => $diffAprobados,
            'diff_pendientes'       => $diffPendientes,
            'diff_avance'           => $diffAvance,
            'es_estancado'          => $esEstancado,
            'total_aprendices'      => count($aprendicesEvolucion),
            'aprendices_mejoraron'  => $totalMejoraron,
            'aprendices_salieron_riesgo' => $totalSalieronRiesgo
        ],
        'cortes_disponibles'   => $todosCortes,
        'aprendices'           => $aprendicesEvolucion,
        'competencias'         => $competenciasEvolucion,
        'bitacora_nuevos'      => $nuevosAprobadosLog
    ];
}

// ══════════════════════════════════════════════════════════════════════════════
// ROUTER
// ══════════════════════════════════════════════════════════════════════════════
try {
    switch ($action) {

        case 'comparar_cortes':
            $fechaA = trim($_GET['corte_a'] ?? $_GET['fecha_a'] ?? '');
            $fechaB = trim($_GET['corte_b'] ?? $_GET['fecha_b'] ?? '');
            jsonOk(getComparacionCortes($pdo, $ficha, $fechaA, $fechaB));

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