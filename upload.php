<?php
error_reporting(E_ALL);
ini_set('display_errors', 0);
ini_set('memory_limit', '1024M');
set_time_limit(300);

require __DIR__ . '/db.php';
require __DIR__ . '/vendor/autoload.php';

use PhpOffice\PhpSpreadsheet\IOFactory;
use PhpOffice\PhpSpreadsheet\Shared\Date;

if (!headers_sent()) {
    header('Content-Type: application/json; charset=utf-8');
}

// ─────────────────────────────────────────────────────────────────────────────
// FUNCIONES AUXILIARES DE NORMALIZACIÓN Y PARSEO
// ─────────────────────────────────────────────────────────────────────────────

if (!function_exists('normalizarTexto')) {
    function normalizarTexto(string $str): string {
        $str = mb_strtoupper(trim($str), 'UTF-8');
        $unwanted = [
            'Á'=>'A','É'=>'E','Í'=>'I','Ó'=>'O','Ú'=>'U',
            'À'=>'A','È'=>'E','Ì'=>'I','Ò'=>'O','Ù'=>'U',
            'Ä'=>'A','Ë'=>'E','Ï'=>'I','Ö'=>'O','Ü'=>'U'
        ];
        $str = strtr($str, $unwanted);
        $str = preg_replace('/\s+/', ' ', $str);
        return trim($str);
    }
}

if (!function_exists('parseFecha')) {
    function parseFecha(?string $raw): ?string {
        if ($raw === null) return null;
        $raw = trim($raw);
        if ($raw === '' || $raw === '-') return null;
        
        $clean = preg_replace('/(?i)\s*pm|\s*am|\s*a|\s*p$/', '', $raw);
        $clean = preg_replace('/(\d{1,2})\.(\d{2})/', '$1:$2', $clean);
        
        if (preg_match('/^(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})\s*(.*)$/', $clean, $m)) {
            $time = trim($m[4]);
            if (empty($time)) $time = '00:00:00';
            elseif (strlen($time) == 5) $time .= ':00';
            return sprintf('%04d-%02d-%02d %s', $m[3], $m[2], $m[1], $time);
        }
        
        if (preg_match('/^(\d{4})[\/\-](\d{1,2})[\/\-](\d{1,2})\s*(.*)$/', $clean, $m)) {
            $time = trim($m[4]);
            if (empty($time)) $time = '00:00:00';
            elseif (strlen($time) == 5) $time .= ':00';
            return sprintf('%04d-%02d-%02d %s', $m[1], $m[2], $m[3], $time);
        }
        
        if (is_numeric($raw)) {
            try {
                return Date::excelToDateTimeObject($raw)->format('Y-m-d H:i:s');
            } catch (Exception $e) {
                return null;
            }
        }
        
        return null;
    }
}

if (!function_exists('parseFechaCorte')) {
    function parseFechaCorte(?string $raw): ?string {
        if ($raw === null) return null;
        $raw = trim($raw);
        if ($raw === '' || $raw === '-') return null;
        
        if (preg_match('/^(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})/', $raw, $m)) {
            return sprintf('%04d-%02d-%02d', $m[3], $m[2], $m[1]);
        }
        if (preg_match('/^(\d{4})[\/\-](\d{1,2})[\/\-](\d{1,2})/', $raw, $m)) {
            return sprintf('%04d-%02d-%02d', $m[1], $m[2], $m[3]);
        }
        if (is_numeric($raw)) {
            try {
                return Date::excelToDateTimeObject($raw)->format('Y-m-d');
            } catch (Exception $e) {
                return null;
            }
        }
        return null;
    }
}

if (!function_exists('splitCodeName')) {
    function splitCodeName(string $string): array {
        $parts = explode('-', $string, 2);
        if (count($parts) == 2) {
            return [trim($parts[0]), trim($parts[1])];
        }
        return ['', trim($string)];
    }
}

if (!function_exists('getCol')) {
    function getCol(array $data, array $map, string $key, string $default = ''): string {
        return isset($map[$key]) && isset($data[$map[$key]]) ? trim((string)$data[$map[$key]]) : $default;
    }
}

if (!function_exists('normalizarNumeroFicha')) {
    function normalizarNumeroFicha($val): string {
        if ($val === null) return '';
        $str = trim((string)$val);
        if (strpos($str, '.') !== false) {
            $parts = explode('.', $str);
            $str = $parts[0];
        }
        $clean = preg_replace('/[^0-9]/', '', $str);
        $clean = ltrim($clean, '0');
        return $clean !== '' ? $clean : '';
    }
}

if (!function_exists('normalizarDocumentoAprendiz')) {
    function normalizarDocumentoAprendiz($val): string {
        if ($val === null) return '';
        $str = trim((string)$val);
        if (strpos($str, '.') !== false) {
            $parts = explode('.', $str);
            $str = $parts[0];
        }
        return strtoupper(trim(preg_replace('/[^0-9A-Za-z]/', '', $str)));
    }
}

if (!function_exists('recalcularMetricasFicha')) {
    function recalcularMetricasFicha(PDO $pdo, int $numeroFicha): array {
        $sql = "
            SELECT
                COUNT(DISTINCT a.numero_documento)                                         AS total_aprendices,
                COUNT(mr.id)                                                               AS total_asignaciones,
                COUNT(mr.id) FILTER (WHERE jc.descripcion = 'APROBADO')                   AS total_aprobados,
                COUNT(mr.id) FILTER (WHERE jc.descripcion = 'POR EVALUAR')                AS total_pendientes,
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
            JOIN aprendices a ON a.numero_ficha = f.numero_ficha
            JOIN estados e ON e.id_estado = a.id_estado
            LEFT JOIN (
                matricula_resultados mr
                JOIN juicios_catalogo jc ON jc.id_juicio_cat = mr.id_juicio_cat
                JOIN resultados r ON mr.codigo_resul = r.codigo_resul
                JOIN competencias c ON r.codigo_comp = c.codigo_comp
            ) ON mr.num_documento_aprendiz = a.numero_documento AND c.codigo_programa = f.codigo_programa
            WHERE f.numero_ficha = :ficha
              AND e.nombre NOT IN ('RETIRO VOLUNTARIO', 'CANCELADO', 'TRASLADADO', 'APLAZADO')
            GROUP BY f.numero_ficha
        ";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([':ficha' => $numeroFicha]);
        $res = $stmt->fetch(PDO::FETCH_ASSOC);

        $avance = $res ? (float)$res['porcentaje_avance'] : 0.0;
        $aprobacion = $res ? (float)$res['porcentaje_aprobacion'] : 0.0;

        $update = $pdo->prepare("
            UPDATE fichas 
            SET porcentaje_avance = :avance, porcentaje_aprobacion = :aprobacion 
            WHERE numero_ficha = :ficha
        ");
        $update->execute([
            ':avance' => $avance,
            ':aprobacion' => $aprobacion,
            ':ficha' => $numeroFicha
        ]);

        return [
            'porcentaje_avance' => $avance,
            'porcentaje_aprobacion' => $aprobacion,
            'total_aprendices' => $res ? (int)$res['total_aprendices'] : 0,
            'total_asignaciones' => $res ? (int)$res['total_asignaciones'] : 0,
            'total_aprobados' => $res ? (int)$res['total_aprobados'] : 0,
            'total_pendientes' => $res ? (int)$res['total_pendientes'] : 0
        ];
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// PROCESAMIENTO DE PETICIÓN
// ─────────────────────────────────────────────────────────────────────────────

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {
    if (php_sapi_name() === 'cli' && empty($_FILES)) {
        return;
    }
    echo json_encode(['success' => false, 'message' => 'Método no permitido. Use POST.']);
    return;
}

if (!isset($_FILES['archivo']) || $_FILES['archivo']['error'] !== UPLOAD_ERR_OK) {
    $errCode = $_FILES['archivo']['error'] ?? 'desconocido';
    echo json_encode(['success' => false, 'message' => "Error al subir el archivo (código: $errCode)."]);
    return;
}

$fileTmpPath = $_FILES['archivo']['tmp_name'];
$fileName = $_FILES['archivo']['name'];
$extension = strtolower(pathinfo($fileName, PATHINFO_EXTENSION));

if (!in_array($extension, ['csv', 'xlsx', 'xls'])) {
    echo json_encode(['success' => false, 'message' => 'El archivo debe ser un CSV, XLSX o XLS.']);
    return;
}

try {
    // 1. Calcular Hash SHA-256 antes del procesamiento completo
    $fileHash = hash_file('sha256', $fileTmpPath);
    if (!$fileHash) {
        throw new Exception('No se pudo calcular el hash de verificación del archivo.');
    }

    // 2. Cargar el archivo Excel
    $spreadsheet = IOFactory::load($fileTmpPath);
    $sheet = $spreadsheet->getActiveSheet();
    $rows = $sheet->toArray();

    if (count($rows) <= 1) {
        echo json_encode(['success' => false, 'message' => 'El archivo está vacío o solo contiene encabezados.']);
        return;
    }

    // 3. Extracción de metadatos de la cabecera (inicializados en null)
    $meta = [
        'fecha_reporte' => null,
        'ficha' => null,
        'cod_programa' => null,
        'version' => null,
        'nom_programa' => null,
        'estado_ficha' => null,
        'fecha_inicio' => null,
        'fecha_fin' => null,
        'modalidad' => null,
        'regional' => null,
        'centro' => null,
    ];

    $headerRowIndex = null;
    $colMap = [];

    for ($r = 0; $r < min(20, count($rows)); $r++) {
        $headers = $rows[$r];
        
        for ($c = 0; $c < count($headers); $c++) {
            $cellText = normalizarTexto((string)($headers[$c] ?? ''));
            if ($cellText === '') continue;

            $nextVal = '';
            for ($k = $c + 1; $k < count($headers); $k++) {
                if (trim((string)$headers[$k]) !== '') {
                    $nextVal = trim((string)$headers[$k]);
                    break;
                }
            }

            if (preg_match('/FECHA\s+DEL\s+REPORTE/i', $cellText) && $meta['fecha_reporte'] === null) {
                $meta['fecha_reporte'] = parseFechaCorte($nextVal) ?: parseFechaCorte($cellText);
            }
            if (preg_match('/FICHA\s+DE\s+CARACTERIZACI[OÓ]N/i', $cellText) && !preg_match('/ESTADO/i', $cellText) && $meta['ficha'] === null) {
                if (preg_match('/FICHA\s+DE\s+CARACTERIZACI[OÓ]N[:\s]*(\d+)/i', $cellText, $mF)) {
                    $meta['ficha'] = normalizarNumeroFicha($mF[1]);
                } else {
                    $meta['ficha'] = normalizarNumeroFicha($nextVal);
                }
            }
            if (preg_match('/C[OÓ][DG]IGO/i', $cellText) && $meta['cod_programa'] === null) {
                if (preg_match('/C[OÓ][DG]IGO[:\s]*(\d+)/i', $cellText, $mC)) {
                    $meta['cod_programa'] = normalizarNumeroFicha($mC[1]);
                } else {
                    $meta['cod_programa'] = normalizarNumeroFicha($nextVal);
                }
            }
            if (preg_match('/VERSI[OÓ]N/i', $cellText) && $meta['version'] === null) {
                $meta['version'] = $nextVal;
            }
            if (preg_match('/DENOMINACI[OÓ]N/i', $cellText) && $meta['nom_programa'] === null) {
                $meta['nom_programa'] = $nextVal;
            }
            if (preg_match('/ESTADO\s+DE\s+LA\s+FICHA/i', $cellText) && $meta['estado_ficha'] === null) {
                $meta['estado_ficha'] = $nextVal;
            }
            if (preg_match('/FECHA\s+INICIO/i', $cellText) && $meta['fecha_inicio'] === null) {
                $meta['fecha_inicio'] = parseFechaCorte($nextVal);
            }
            if (preg_match('/FECHA\s+FIN/i', $cellText) && $meta['fecha_fin'] === null) {
                $meta['fecha_fin'] = parseFechaCorte($nextVal);
            }
            if (preg_match('/MODALIDAD/i', $cellText) && $meta['modalidad'] === null) {
                $meta['modalidad'] = $nextVal;
            }
            if (preg_match('/REGIONAL/i', $cellText) && $meta['regional'] === null) {
                $meta['regional'] = $nextVal;
            }
            if (preg_match('/CENTRO\s+DE\s+FORMACI[OÓ]N/i', $cellText) && $meta['centro'] === null) {
                $meta['centro'] = $nextVal;
            }
        }

        // Búsqueda de la fila de encabezados de la tabla de juicios
        $tempMap = [];
        for ($c = 0; $c < count($headers); $c++) {
            $headerName = normalizarTexto((string)$headers[$c]);

            if (strpos($headerName, 'TIPO') !== false && strpos($headerName, 'DOC') !== false) {
                if (!isset($tempMap['tipo_doc'])) $tempMap['tipo_doc'] = $c;
            } elseif (strpos($headerName, 'NUMERO') !== false && strpos($headerName, 'DOC') !== false) {
                if (!isset($tempMap['num_doc'])) $tempMap['num_doc'] = $c;
            } elseif (strpos($headerName, 'DOCUMENTO') !== false && !isset($tempMap['num_doc'])) {
                $tempMap['num_doc'] = $c;
            } elseif (strpos($headerName, 'NOMBRE') !== false && strpos($headerName, 'PROGRAMA') === false && strpos($headerName, 'COMPETENCIA') === false) {
                if (!isset($tempMap['nombres'])) $tempMap['nombres'] = $c;
            } elseif (strpos($headerName, 'APELLIDO') !== false) {
                if (!isset($tempMap['apellidos'])) $tempMap['apellidos'] = $c;
            } elseif (strpos($headerName, 'ESTADO') !== false && strpos($headerName, 'FICHA') === false) {
                if (!isset($tempMap['estado'])) $tempMap['estado'] = $c;
            } elseif (strpos($headerName, 'COMPETENCIA') !== false) {
                if (!isset($tempMap['nom_comp'])) $tempMap['nom_comp'] = $c;
            } elseif (strpos($headerName, 'RESULTADO') !== false) {
                if (!isset($tempMap['nom_resul'])) $tempMap['nom_resul'] = $c;
            } elseif (strpos($headerName, 'JUICIO') !== false) {
                if (strpos($headerName, 'FECHA') !== false || strpos($headerName, 'HORA') !== false) {
                    if (!isset($tempMap['fecha_hora'])) $tempMap['fecha_hora'] = $c;
                } elseif (strpos($headerName, 'FUNCIONARIO') !== false || strpos($headerName, 'REGISTR') !== false) {
                    if (!isset($tempMap['nom_instructor'])) $tempMap['nom_instructor'] = $c;
                } else {
                    if (!isset($tempMap['juicio'])) $tempMap['juicio'] = $c;
                }
            } elseif (strpos($headerName, 'FUNCIONARIO') !== false || strpos($headerName, 'INSTRUCTOR') !== false) {
                if (!isset($tempMap['nom_instructor'])) $tempMap['nom_instructor'] = $c;
            } elseif (strpos($headerName, 'FECHA') !== false && (strpos($headerName, 'HORA') !== false || strpos($headerName, 'EVALUACION') !== false)) {
                if (!isset($tempMap['fecha_hora'])) $tempMap['fecha_hora'] = $c;
            }
        }

        if (isset($tempMap['num_doc']) && isset($tempMap['nom_comp']) && isset($tempMap['nom_resul']) && isset($tempMap['juicio'])) {
            $colMap = $tempMap;
            $headerRowIndex = $r;
            break;
        }
    }

    // 4. Validaciones obligatorias de la cabecera
    if (empty($meta['ficha']) || !is_numeric($meta['ficha'])) {
        throw new Exception('No se pudo detectar el número de Ficha de Caracterización en el archivo.');
    }
    $ficha = (int)$meta['ficha'];

    if (empty($meta['fecha_reporte'])) {
        throw new Exception('No se pudo detectar una Fecha del Reporte válida en el archivo.');
    }
    $fecha_reporte = $meta['fecha_reporte'];

    if (empty($meta['cod_programa']) || !is_numeric($meta['cod_programa'])) {
        throw new Exception('No se pudo detectar el Código del Programa en el archivo.');
    }
    $cod_programa = (int)$meta['cod_programa'];
    $nom_programa = $meta['nom_programa'] ?: 'PROGRAMA DE FORMACION';
    $version = $meta['version'] ?: '01';
    $modalidad = $meta['modalidad'] ?: 'PRESENCIAL';
    $estado_ficha = $meta['estado_ficha'] ?: 'EN EJECUCION';
    $fecha_inicio = $meta['fecha_inicio'];
    $fecha_fin = $meta['fecha_fin'];

    if ($headerRowIndex === null) {
        throw new Exception('No se encontró la fila de encabezados de la tabla de juicios evaluativos.');
    }

    // 5. Verificación de duplicado exacto por SHA-256 e Historial
    $stmt_dup = $pdo->prepare("SELECT * FROM historial_importaciones WHERE hash_archivo = :hash AND estado = 'EXITOSO' LIMIT 1");
    $stmt_dup->execute([':hash' => $fileHash]);
    $dupRow = $stmt_dup->fetch(PDO::FETCH_ASSOC);

    if ($dupRow) {
        if ((int)$dupRow['numero_ficha'] === $ficha) {
            $resumenOriginal = [
                'ficha'                     => (int)$dupRow['numero_ficha'],
                'fecha_reporte'             => $dupRow['fecha_reporte'],
                'fecha_importacion_original'=> $dupRow['fecha_importacion'],
                'total_filas'               => (int)$dupRow['total_filas'],
                'nuevos'                    => (int)$dupRow['registros_nuevos'],
                'registros_nuevos'          => (int)$dupRow['registros_nuevos'],
                'actualizados'              => (int)$dupRow['registros_actualizados'],
                'registros_actualizados'    => (int)$dupRow['registros_actualizados'],
                'sin_cambios'               => (int)$dupRow['registros_sin_cambios'],
                'registros_sin_cambios'     => (int)$dupRow['registros_sin_cambios'],
                'omitidos'                  => (int)$dupRow['registros_omitidos'],
                'registros_omitidos'        => (int)$dupRow['registros_omitidos'],
                'conflictos'                => (int)$dupRow['registros_conflicto'],
                'registros_conflicto'       => (int)$dupRow['registros_conflicto']
            ];
            echo json_encode([
                'success'            => true,
                'duplicado_archivo'  => true,
                'modo'               => 'DUPLICADO_DETECTADO',
                'modo_procesamiento' => 'DUPLICADO_DETECTADO',
                'message'            => "Este archivo ya fue importado exitosamente para la ficha $ficha.",
                'resumen'            => $resumenOriginal,
                'summary'            => $resumenOriginal,
                'advertencias'       => [],
                'warnings'           => []
            ], JSON_UNESCAPED_UNICODE);
            return;
        } else {
            throw new Exception("Conflicto de integridad: El archivo ya fue registrado previamente para la ficha {$dupRow['numero_ficha']}, diferente a la ficha detectada ($ficha).");
        }
    }

    // 6. Determinación de Modo de Importación según fecha_reporte en BD
    $stmt_f_actual = $pdo->prepare("SELECT fecha_reporte, estado_ficha FROM fichas WHERE numero_ficha = ?");
    $stmt_f_actual->execute([$ficha]);
    $fichaActual = $stmt_f_actual->fetch(PDO::FETCH_ASSOC);

    $modo = 'ESTÁNDAR';
    $fecha_bd = $fichaActual ? $fichaActual['fecha_reporte'] : null;

    if ($fecha_bd) {
        if ($fecha_reporte < $fecha_bd) {
            $modo = 'SELECTIVO_HISTÓRICO';
        }
    }

    // 7. Iniciar Transacción Atómica
    $pdo->beginTransaction();

    // 8. Upsert Programa (Identidad estrictamente codigo_programa)
    $stmt_prog = $pdo->prepare("
        INSERT INTO programas (codigo_programa, nombre_programa, version, modalidad)
        VALUES (?, ?, ?, ?)
        ON CONFLICT (codigo_programa) 
        DO UPDATE SET 
            nombre_programa = EXCLUDED.nombre_programa,
            version = EXCLUDED.version,
            modalidad = EXCLUDED.modalidad
    ");
    $stmt_prog->execute([$cod_programa, $nom_programa, $version, $modalidad]);

    // 9. Upsert Ficha
    if (!$fichaActual) {
        $stmt_ins_f = $pdo->prepare("
            INSERT INTO fichas (numero_ficha, codigo_programa, fecha_inicio, fecha_fin, estado_ficha, fecha_reporte)
            VALUES (?, ?, ?, ?, ?, ?)
        ");
        $stmt_ins_f->execute([$ficha, $cod_programa, $fecha_inicio, $fecha_fin, $estado_ficha, $fecha_reporte]);
    } else {
        if ($modo === 'SELECTIVO_HISTÓRICO') {
            $stmt_upd_f = $pdo->prepare("
                UPDATE fichas SET 
                    codigo_programa = ?,
                    fecha_inicio = COALESCE(fecha_inicio, ?),
                    fecha_fin = COALESCE(fecha_fin, ?),
                    estado_ficha = COALESCE(?, estado_ficha)
                WHERE numero_ficha = ?
            ");
            $stmt_upd_f->execute([$cod_programa, $fecha_inicio, $fecha_fin, $estado_ficha, $ficha]);
        } else {
            $stmt_upd_f = $pdo->prepare("
                UPDATE fichas SET 
                    codigo_programa = ?,
                    fecha_inicio = COALESCE(?, fecha_inicio),
                    fecha_fin = COALESCE(?, fecha_fin),
                    estado_ficha = ?,
                    fecha_reporte = ?
                WHERE numero_ficha = ?
            ");
            $stmt_upd_f->execute([$cod_programa, $fecha_inicio, $fecha_fin, $estado_ficha, $fecha_reporte, $ficha]);
        }
    }

    // 10. Pre-carga y Validación de Catálogos
    $cache_juicios = [];
    $res_j = $pdo->query("SELECT id_juicio_cat, UPPER(descripcion) as desc FROM juicios_catalogo")->fetchAll(PDO::FETCH_ASSOC);
    foreach ($res_j as $row_j) {
        $cache_juicios[$row_j['desc']] = (int)$row_j['id_juicio_cat'];
    }
    if (!isset($cache_juicios['APROBADO']) || !isset($cache_juicios['POR EVALUAR'])) {
        throw new Exception("El catálogo de juicios evaluativos no contiene las entradas obligatorias 'APROBADO' y/o 'POR EVALUAR'.");
    }

    $cache_estados = [];
    $res_est = $pdo->query("SELECT id_estado, UPPER(nombre) as nom FROM estados")->fetchAll(PDO::FETCH_ASSOC);
    foreach ($res_est as $row_est) {
        $cache_estados[$row_est['nom']] = (int)$row_est['id_estado'];
    }

    // Pre-cargar aprendices de la base de datos para protección de ficha
    $cache_aprendices_db = [];
    $res_ap = $pdo->query("SELECT numero_documento, numero_ficha, id_estado, nombres, apellidos FROM aprendices")->fetchAll(PDO::FETCH_ASSOC);
    foreach ($res_ap as $row_ap) {
        $docNorm = normalizarDocumentoAprendiz($row_ap['numero_documento']);
        $cache_aprendices_db[$docNorm] = [
            'raw_doc'      => $row_ap['numero_documento'],
            'numero_ficha' => normalizarNumeroFicha($row_ap['numero_ficha']),
            'id_estado'    => (int)$row_ap['id_estado'],
            'nombres'      => $row_ap['nombres'],
            'apellidos'    => $row_ap['apellidos'],
        ];
    }

    // Pre-cargar juicios existentes de esta ficha
    $cache_matriculas = [];
    $stmt_mat_ficha = $pdo->prepare("
        SELECT mr.id, mr.num_documento_aprendiz, mr.codigo_resul, mr.id_juicio_cat, 
               UPPER(jc.descripcion) as juicio_nombre, mr.fecha_registro, mr.num_documento_instructor
        FROM matricula_resultados mr
        JOIN aprendices a ON mr.num_documento_aprendiz = a.numero_documento
        JOIN juicios_catalogo jc ON mr.id_juicio_cat = jc.id_juicio_cat
        WHERE a.numero_ficha = ?
    ");
    $stmt_mat_ficha->execute([$ficha]);
    while ($mRow = $stmt_mat_ficha->fetch(PDO::FETCH_ASSOC)) {
        $doc = normalizarDocumentoAprendiz($mRow['num_documento_aprendiz']);
        $res = (int)$mRow['codigo_resul'];
        $cache_matriculas[$doc][$res] = [
            'id'            => (int)$mRow['id'],
            'id_juicio_cat' => (int)$mRow['id_juicio_cat'],
            'juicio_nombre' => $mRow['juicio_nombre'],
            'fecha_registro'=> $mRow['fecha_registro'],
            'instructor'    => $mRow['num_documento_instructor']
        ];
    }

    // Caches para relaciones estructurales programa/competencia/resultado (sin inventar códigos)
    $cache_comp_programa = []; // [cod_comp => codigo_programa]
    $res_cp = $pdo->query("SELECT codigo_comp, codigo_programa FROM competencias")->fetchAll(PDO::FETCH_ASSOC);
    foreach ($res_cp as $row_cp) {
        $cache_comp_programa[(int)$row_cp['codigo_comp']] = (int)$row_cp['codigo_programa'];
    }

    $cache_comp_por_nombre = []; // [nombre_comp => codigo_comp]
    $res_cn = $pdo->query("SELECT codigo_comp, UPPER(TRIM(nombre_comp)) as nom, codigo_programa FROM competencias")->fetchAll(PDO::FETCH_ASSOC);
    foreach ($res_cn as $row_cn) {
        $cache_comp_por_nombre[$row_cn['nom']][$row_cn['codigo_programa']] = (int)$row_cn['codigo_comp'];
    }

    $cache_resul_comp = []; // [codigo_resul => codigo_comp]
    $res_rc = $pdo->query("SELECT codigo_resul, codigo_comp FROM resultados")->fetchAll(PDO::FETCH_ASSOC);
    foreach ($res_rc as $row_rc) {
        $cache_resul_comp[(int)$row_rc['codigo_resul']] = (int)$row_rc['codigo_comp'];
    }

    $cache_resul_por_nombre = []; // [codigo_comp => [nombre_resul => codigo_resul]]
    $res_rn = $pdo->query("SELECT codigo_resul, UPPER(TRIM(nombre_resultado)) as nom, codigo_comp FROM resultados")->fetchAll(PDO::FETCH_ASSOC);
    foreach ($res_rn as $row_rn) {
        $cache_resul_por_nombre[(int)$row_rn['codigo_comp']][$row_rn['nom']] = (int)$row_rn['codigo_resul'];
    }

    $cache_instructores = [];

    // Sentencias preparadas
    $stmt_ins_estado = $pdo->prepare("INSERT INTO estados (nombre) VALUES (?) RETURNING id_estado");
    $stmt_ins_aprendiz = $pdo->prepare("INSERT INTO aprendices (numero_documento, tipo_documento, nombres, apellidos, id_estado, numero_ficha) VALUES (?, ?, ?, ?, ?, ?)");
    $stmt_upd_aprendiz = $pdo->prepare("UPDATE aprendices SET tipo_documento = ?, nombres = ?, apellidos = ?, id_estado = ? WHERE numero_documento = ?");
    $stmt_comp = $pdo->prepare("INSERT INTO competencias (codigo_comp, nombre_comp, codigo_programa) VALUES (?, ?, ?)");
    $stmt_res = $pdo->prepare("INSERT INTO resultados (codigo_resul, nombre_resultado, codigo_comp) VALUES (?, ?, ?)");
    $stmt_inst = $pdo->prepare("INSERT INTO instructores (num_documento, nombres_apellidos, cargo) VALUES (?, ?, 'Instructor') ON CONFLICT (num_documento) DO NOTHING");
    $stmt_ins_mat = $pdo->prepare("INSERT INTO matricula_resultados (num_documento_aprendiz, codigo_resul, id_juicio_cat, num_documento_instructor, fecha_registro) VALUES (?, ?, ?, ?, ?)");
    $stmt_upd_mat = $pdo->prepare("UPDATE matricula_resultados SET id_juicio_cat = ?, num_documento_instructor = ?, fecha_registro = ? WHERE id = ?");

    // Contadores del resumen
    $contadores = [
        'nuevos'       => 0,
        'actualizados' => 0,
        'sin_cambios'  => 0,
        'omitidos'     => 0,
        'conflictos'   => 0,
        'total'        => 0
    ];
    $advertencias = [];
    $aprendicesConflictoRegistrados = [];

    // 11. Bucle de Procesamiento Fila por Fila
    for ($i = $headerRowIndex + 1; $i < count($rows); $i++) {
        $data = $rows[$i];

        $num_doc = normalizarDocumentoAprendiz(getCol($data, $colMap, 'num_doc'));
        if (empty($num_doc)) continue;

        $contadores['total']++;

        $tipo_doc = strtoupper(getCol($data, $colMap, 'tipo_doc', 'CC'));
        $nombres = getCol($data, $colMap, 'nombres', 'SIN NOMBRE');
        $apellidos = getCol($data, $colMap, 'apellidos', '');
        $estado_nombre = normalizarTexto(getCol($data, $colMap, 'estado', 'EN FORMACION'));
        if ($estado_nombre === 'EN FORMACION') $estado_nombre = 'EN FORMACIÓN';

        // 11.A. Validación del Estado del Aprendiz
        if (!isset($cache_estados[$estado_nombre])) {
            $stmt_ins_estado->execute([$estado_nombre]);
            $estado_id = (int)$stmt_ins_estado->fetchColumn();
            $cache_estados[$estado_nombre] = $estado_id;
        } else {
            $estado_id = $cache_estados[$estado_nombre];
        }

        $ficha_archivo_norm = normalizarNumeroFicha($ficha);

        // 11.B. Protección de Aprendices contra reasignación
        if (isset($cache_aprendices_db[$num_doc])) {
            $appDb = $cache_aprendices_db[$num_doc];
            $ficha_db_norm = normalizarNumeroFicha($appDb['numero_ficha']);

            // Solo existe conflicto real si la ficha en BD existe, la ficha del archivo existe, y NO son iguales
            // El estado del aprendiz (activo, retirado, cancelado, etc.) NO determina conflicto de pertenencia
            if ($ficha_db_norm !== '' && $ficha_archivo_norm !== '' && $ficha_db_norm !== $ficha_archivo_norm) {
                $contadores['conflictos']++;
                if (!isset($aprendicesConflictoRegistrados[$num_doc])) {
                    $advertencias[] = "El aprendiz $num_doc pertenece a otra ficha ($ficha_db_norm) y no fue reasignado.";
                    $aprendicesConflictoRegistrados[$num_doc] = true;
                }
                continue; // No procesar juicios para este aprendiz en esta ficha
            } else {
                // Misma ficha: actualizar datos personales o estado si cambiaron
                $rawDocTarget = $appDb['raw_doc'] ?? $num_doc;
                if ($appDb['nombres'] !== $nombres || $appDb['apellidos'] !== $apellidos || $appDb['id_estado'] !== $estado_id) {
                    $stmt_upd_aprendiz->execute([$tipo_doc, $nombres, $apellidos, $estado_id, $rawDocTarget]);
                    $cache_aprendices_db[$num_doc]['nombres'] = $nombres;
                    $cache_aprendices_db[$num_doc]['apellidos'] = $apellidos;
                    $cache_aprendices_db[$num_doc]['id_estado'] = $estado_id;
                }
            }
        } else {
            $stmt_ins_aprendiz->execute([$num_doc, $tipo_doc, $nombres, $apellidos, $estado_id, (int)$ficha]);
            $cache_aprendices_db[$num_doc] = [
                'raw_doc'      => $num_doc,
                'numero_ficha' => $ficha_archivo_norm,
                'id_estado'    => $estado_id,
                'nombres'      => $nombres,
                'apellidos'    => $apellidos
            ];
        }

        // 11.C. Competencia (Sin crc32, validando relación con el programa)
        $raw_comp = getCol($data, $colMap, 'nom_comp', '');
        if (empty($raw_comp)) {
            $contadores['conflictos']++;
            $advertencias[] = "Competencia vacía para el aprendiz $num_doc. Fila omitida.";
            continue;
        }
        list($cod_comp_str, $nom_comp) = splitCodeName($raw_comp);
        $cod_comp = null;
        if (is_numeric($cod_comp_str)) {
            $cod_comp = (int)$cod_comp_str;
        } else {
            $nom_comp_clean = normalizarTexto($nom_comp);
            if (isset($cache_comp_por_nombre[$nom_comp_clean][$cod_programa])) {
                $cod_comp = $cache_comp_por_nombre[$nom_comp_clean][$cod_programa];
            }
        }

        if ($cod_comp === null) {
            $contadores['conflictos']++;
            $advertencias[] = "No se pudo resolver el código numérico para la competencia '$nom_comp'. Fila omitida.";
            continue;
        }

        // Validar que la competencia pertenece al programa de la ficha
        if (isset($cache_comp_programa[$cod_comp])) {
            $prog_comp = $cache_comp_programa[$cod_comp];
            if ($prog_comp !== $cod_programa) {
                $contadores['conflictos']++;
                $advertencias[] = "La competencia $cod_comp está asociada al programa $prog_comp y no al programa $cod_programa de la ficha. Conflicto estructural.";
                continue;
            }
        } else {
            // Competencia no existe en BD: insertarla vinculada a este programa
            $stmt_comp->execute([$cod_comp, $nom_comp, $cod_programa]);
            $cache_comp_programa[$cod_comp] = $cod_programa;
            $cache_comp_por_nombre[normalizarTexto($nom_comp)][$cod_programa] = $cod_comp;
        }

        // 11.D. Resultado de Aprendizaje (Sin crc32, validando relación con la competencia)
        $raw_resul = getCol($data, $colMap, 'nom_resul', '');
        if (empty($raw_resul)) {
            $contadores['conflictos']++;
            $advertencias[] = "Resultado de aprendizaje vacío para el aprendiz $num_doc. Fila omitida.";
            continue;
        }
        list($cod_resul_str, $nom_resul) = splitCodeName($raw_resul);
        $cod_resul = null;
        if (is_numeric($cod_resul_str)) {
            $cod_resul = (int)$cod_resul_str;
        } else {
            $nom_resul_clean = normalizarTexto($nom_resul);
            if (isset($cache_resul_por_nombre[$cod_comp][$nom_resul_clean])) {
                $cod_resul = $cache_resul_por_nombre[$cod_comp][$nom_resul_clean];
            }
        }

        if ($cod_resul === null) {
            $contadores['conflictos']++;
            $advertencias[] = "No se pudo resolver el código numérico para el resultado '$nom_resul'. Fila omitida.";
            continue;
        }

        // Validar que el resultado pertenece a esta competencia
        if (isset($cache_resul_comp[$cod_resul])) {
            $comp_resul = $cache_resul_comp[$cod_resul];
            if ($comp_resul !== $cod_comp) {
                $contadores['conflictos']++;
                $advertencias[] = "El resultado $cod_resul está asignado a la competencia $comp_resul y no a $cod_comp. Conflicto estructural.";
                continue;
            }
        } else {
            // Resultado no existe en BD: insertarlo vinculado a esta competencia
            $stmt_res->execute([$cod_resul, $nom_resul, $cod_comp]);
            $cache_resul_comp[$cod_resul] = $cod_comp;
            $cache_resul_por_nombre[$cod_comp][normalizarTexto($nom_resul)] = $cod_resul;
        }

        // 11.E. Instructor
        $raw_instructor = getCol($data, $colMap, 'nom_instructor', 'SIN ASIGNAR');
        list($doc_inst_tmp, $nom_inst_tmp) = splitCodeName($raw_instructor);
        $doc_instructor = ($doc_inst_tmp !== '') ? preg_replace('/[^0-9]/', '', $doc_inst_tmp) : '000000000';
        $nom_instructor = ($nom_inst_tmp !== '') ? $nom_inst_tmp : $raw_instructor;
        if (empty($doc_instructor)) $doc_instructor = '000000000';

        if (!isset($cache_instructores[$doc_instructor])) {
            $stmt_inst->execute([$doc_instructor, $nom_instructor]);
            $cache_instructores[$doc_instructor] = true;
        }

        // 11.F. Juicio Evaluativo y Fecha Real
        $raw_juicio = normalizarTexto(getCol($data, $colMap, 'juicio', 'POR EVALUAR'));
        if ($raw_juicio === '-' || empty($raw_juicio)) $raw_juicio = 'POR EVALUAR';
        if (!in_array($raw_juicio, ['APROBADO', 'POR EVALUAR', 'NO APROBADO'])) {
            $raw_juicio = 'POR EVALUAR';
        }

        $juicio_id = $cache_juicios[$raw_juicio] ?? $cache_juicios['POR EVALUAR'];
        $raw_fecha = getCol($data, $colMap, 'fecha_hora', '');
        $fecha_juicio = parseFecha($raw_fecha); // Puede ser string 'Y-m-d H:i:s' o NULL (NUNCA now())

        // 11.G. Evaluación de Juicio en Base de Datos (Idempotencia y Cronología)
        if (!isset($cache_matriculas[$num_doc][$cod_resul])) {
            $fecha_a_guardar = $fecha_juicio;
            if ($fecha_a_guardar === null && $raw_juicio === 'APROBADO') {
                $fecha_a_guardar = $fecha_reporte . ' 00:00:00';
            }

            $stmt_ins_mat->execute([$num_doc, $cod_resul, $juicio_id, $doc_instructor, $fecha_a_guardar]);
            $cache_matriculas[$num_doc][$cod_resul] = [
                'id'             => (int)$pdo->lastInsertId('matricula_resultados_id_seq'),
                'id_juicio_cat'  => $juicio_id,
                'juicio_nombre'  => $raw_juicio,
                'fecha_registro' => $fecha_a_guardar,
                'instructor'     => $doc_instructor
            ];
            $contadores['nuevos']++;

        } else {
            $actual = $cache_matriculas[$num_doc][$cod_resul];
            $actual_id = $actual['id'];
            $actual_juicio = $actual['juicio_nombre'];
            $actual_fecha = $actual['fecha_registro'];

            // Caso 1: Intentar degradar APROBADO a POR EVALUAR
            if ($actual_juicio === 'APROBADO' && $raw_juicio === 'POR EVALUAR') {
                $contadores['omitidos']++;
            }
            // Caso 2: Progresión legítima de POR EVALUAR a APROBADO
            elseif ($actual_juicio === 'POR EVALUAR' && $raw_juicio === 'APROBADO') {
                $fecha_final = $fecha_juicio ?? ($fecha_reporte . ' 00:00:00');
                $stmt_upd_mat->execute([$juicio_id, $doc_instructor, $fecha_final, $actual_id]);
                $cache_matriculas[$num_doc][$cod_resul]['id_juicio_cat'] = $juicio_id;
                $cache_matriculas[$num_doc][$cod_resul]['juicio_nombre'] = $raw_juicio;
                $cache_matriculas[$num_doc][$cod_resul]['fecha_registro'] = $fecha_final;
                $cache_matriculas[$num_doc][$cod_resul]['instructor'] = $doc_instructor;
                $contadores['actualizados']++;
            }
            // Caso 3: Ambos son APROBADO (actualización de fecha o instructor)
            elseif ($actual_juicio === 'APROBADO' && $raw_juicio === 'APROBADO') {
                if ($fecha_juicio !== null && $actual_fecha !== null) {
                    if ($fecha_juicio > $actual_fecha) {
                        $stmt_upd_mat->execute([$juicio_id, $doc_instructor, $fecha_juicio, $actual_id]);
                        $cache_matriculas[$num_doc][$cod_resul]['fecha_registro'] = $fecha_juicio;
                        $cache_matriculas[$num_doc][$cod_resul]['instructor'] = $doc_instructor;
                        $contadores['actualizados']++;
                    } else {
                        $contadores['omitidos']++;
                    }
                } elseif ($fecha_juicio !== null && $actual_fecha === null) {
                    $stmt_upd_mat->execute([$juicio_id, $doc_instructor, $fecha_juicio, $actual_id]);
                    $cache_matriculas[$num_doc][$cod_resul]['fecha_registro'] = $fecha_juicio;
                    $cache_matriculas[$num_doc][$cod_resul]['instructor'] = $doc_instructor;
                    $contadores['actualizados']++;
                } else {
                    $contadores['sin_cambios']++;
                }
            }
            // Caso 4: Ambos son POR EVALUAR
            else {
                $contadores['sin_cambios']++;
            }
        }
    }

    // 12. Recalcular Métricas de la Ficha
    $metricas = recalcularMetricasFicha($pdo, $ficha);

    // 13. Registrar en historial_importaciones
    $stmt_hist = $pdo->prepare("
        INSERT INTO historial_importaciones (
            numero_ficha, fecha_reporte, nombre_archivo, hash_archivo,
            total_filas, registros_nuevos, registros_actualizados, registros_sin_cambios,
            registros_omitidos, registros_conflicto, modo_procesamiento, estado, mensaje
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'EXITOSO', ?)
    ");
    $msgHistorial = "Procesamiento $modo completado exitosamente.";
    $stmt_hist->execute([
        $ficha, $fecha_reporte, $fileName, $fileHash,
        $contadores['total'], $contadores['nuevos'], $contadores['actualizados'], $contadores['sin_cambios'],
        $contadores['omitidos'], $contadores['conflictos'], $modo, $msgHistorial
    ]);

    // 14. Confirmar Transacción
    $pdo->commit();

    // 15. Devolver Respuesta JSON Compatible
    $msgUsuario = ($modo === 'SELECTIVO_HISTÓRICO')
        ? "Archivo histórico (corte $fecha_reporte) procesado selectivamente: se incorporaron registros faltantes sin afectar información reciente."
        : "Importación completada exitosamente para la ficha $ficha (corte: $fecha_reporte).";

    $resumenObj = [
        'ficha'                  => $ficha,
        'fecha_reporte'          => $fecha_reporte,
        'total_filas'            => $contadores['total'],
        'nuevos'                 => $contadores['nuevos'],
        'registros_nuevos'       => $contadores['nuevos'],
        'actualizados'           => $contadores['actualizados'],
        'registros_actualizados' => $contadores['actualizados'],
        'sin_cambios'            => $contadores['sin_cambios'],
        'registros_sin_cambios'  => $contadores['sin_cambios'],
        'omitidos'               => $contadores['omitidos'],
        'registros_omitidos'     => $contadores['omitidos'],
        'conflictos'             => $contadores['conflictos'],
        'registros_conflicto'    => $contadores['conflictos'],
        'avance_general'         => $metricas['porcentaje_avance'] . '%'
    ];

    echo json_encode([
        'success'            => true,
        'duplicado_archivo'  => false,
        'modo'               => $modo,
        'modo_procesamiento' => $modo,
        'message'            => $msgUsuario,
        'resumen'            => $resumenObj,
        'summary'            => $resumenObj,
        'advertencias'       => array_slice($advertencias, 0, 15),
        'warnings'           => array_slice($advertencias, 0, 15)
    ], JSON_UNESCAPED_UNICODE);

} catch (Exception $e) {
    if (isset($pdo) && $pdo->inTransaction()) {
        $pdo->rollBack();
    }
    echo json_encode([
        'success' => false,
        'message' => 'Error al procesar el archivo: ' . $e->getMessage()
    ], JSON_UNESCAPED_UNICODE);
}
