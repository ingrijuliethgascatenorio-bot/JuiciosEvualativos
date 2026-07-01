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
$ficha  = $_GET['ficha']  ?? '';

// ── Helpers ──────────────────────────────────────────────────────────────────

/**
 * Construye la cláusula WHERE y devuelve [string_where, array_params]
 * Filtra por ficha y excluye retirados por defecto.
 */
function buildWhere(string $ficha, string $alias = 'a'): array {
    $where  = ["e.nombre != 'RETIRO VOLUNTARIO'"];
    $params = [];

    if ($ficha !== '') {
        $where[]  = "{$alias}.numero_ficha = :ficha";
        $params[':ficha'] = $ficha;
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
function getRiesgoAcademico(PDO $pdo, string $ficha): array {
    [$where, $params] = buildWhere($ficha);

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
                    / COUNT(mr.id)) * 100, 1
                )
            END AS porcentaje_avance
        FROM aprendices a
        JOIN estados e ON a.id_estado = e.id_estado
        LEFT JOIN matricula_resultados mr
               ON mr.num_documento_aprendiz = a.numero_documento
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
function getRanking(PDO $pdo, string $ficha): array {
    [$where, $params] = buildWhere($ficha);

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
                    / COUNT(mr.id)) * 100, 1
                )
            END AS porcentaje_avance
        FROM aprendices a
        JOIN estados e ON a.id_estado = e.id_estado
        LEFT JOIN matricula_resultados mr
               ON mr.num_documento_aprendiz = a.numero_documento
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
function getSemaforoCompetencias(PDO $pdo, string $ficha): array {
    $where  = [];
    $params = [];

    if ($ficha !== '') {
        $where[]          = 'f.numero_ficha = :ficha';
        $params[':ficha'] = $ficha;
    }

    $whereClause = $where ? 'WHERE ' . implode(' AND ', $where) : '';

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
                    / COUNT(mr.id)) * 100, 1
                )
            END AS porcentaje_aprobacion
        FROM competencias c
        JOIN resultados r ON r.codigo_comp = c.codigo_comp
        LEFT JOIN matricula_resultados mr ON mr.codigo_resul = r.codigo_resul
        LEFT JOIN aprendices a  ON a.numero_documento = mr.num_documento_aprendiz
        LEFT JOIN juicios_catalogo jc ON jc.id_juicio_cat = mr.id_juicio_cat
        LEFT JOIN fichas f ON f.numero_ficha = a.numero_ficha
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
function getAlertas(PDO $pdo, string $ficha): array {
    $alertas = [];

    // ── Alertas riesgo ALTO ───────────────────────────────────────────────────
    [$where, $params] = buildWhere($ficha);

    $sql = "
        SELECT
            a.numero_documento,
            a.nombres,
            a.apellidos,
            a.numero_ficha,
            COUNT(mr.id) FILTER (WHERE jc.descripcion = 'POR EVALUAR') AS pendientes
        FROM aprendices a
        JOIN estados e ON a.id_estado = e.id_estado
        LEFT JOIN matricula_resultados mr
               ON mr.num_documento_aprendiz = a.numero_documento
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
    $semaforo = getSemaforoCompetencias($pdo, $ficha);
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
    $estadisticas = getEstadisticasFicha($pdo, $ficha);
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
function getEstadisticasFicha(PDO $pdo, string $ficha): array {
    $where  = [];
    $params = [];

    if ($ficha !== '') {
        $where[]          = 'f.numero_ficha = :ficha';
        $params[':ficha'] = $ficha;
    }

    $whereClause = $where ? 'WHERE ' . implode(' AND ', $where) : '';

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
                    / COUNT(mr.id)) * 100, 1
                )
            END AS porcentaje_avance,
            CASE
                WHEN COUNT(DISTINCT a.numero_documento) = 0 THEN 0
                ELSE ROUND(
                    (COUNT(DISTINCT CASE WHEN jc.descripcion = 'APROBADO'
                        THEN a.numero_documento END)::numeric
                    / COUNT(DISTINCT a.numero_documento)) * 100, 1
                )
            END AS porcentaje_aprobacion
        FROM fichas f
        JOIN programas p ON p.codigo_programa = f.codigo_programa
        JOIN aprendices a ON a.numero_ficha = f.numero_ficha
        LEFT JOIN matricula_resultados mr
               ON mr.num_documento_aprendiz = a.numero_documento
        LEFT JOIN juicios_catalogo jc ON jc.id_juicio_cat = mr.id_juicio_cat
        $whereClause
        GROUP BY f.numero_ficha, p.nombre_programa
        ORDER BY f.numero_ficha
    ";

    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);

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
            jsonOk(getRiesgoAcademico($pdo, $ficha));

        case 'ranking':
            jsonOk(getRanking($pdo, $ficha));

        case 'semaforo_competencias':
            jsonOk(getSemaforoCompetencias($pdo, $ficha));

        case 'alertas':
            jsonOk(getAlertas($pdo, $ficha));

        case 'estadisticas_ficha':
            jsonOk(getEstadisticasFicha($pdo, $ficha));

        case 'inteligencia':
        default:
            // Dashboard completo en una sola llamada
            jsonOk([
                'generado_en'       => date('c'),
                'riesgo_academico'  => getRiesgoAcademico($pdo, $ficha),
                'ranking'           => getRanking($pdo, $ficha),
                'semaforo'          => getSemaforoCompetencias($pdo, $ficha),
                'alertas'           => getAlertas($pdo, $ficha),
                'estadisticas_ficha'=> getEstadisticasFicha($pdo, $ficha),
            ]);
    }
} catch (PDOException $e) {
    jsonError('Error de base de datos: ' . $e->getMessage());
} catch (Exception $e) {
    jsonError('Error del servidor: ' . $e->getMessage());
}
