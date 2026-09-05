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
    function parseFechaCorte($raw): ?string {
        if ($raw === null) return null;
        if ($raw instanceof \DateTimeInterface) {
            return $raw->format('Y-m-d');
        }
        $raw = trim((string)$raw);
        if ($raw === '' || $raw === '-') return null;

        // Formato DD/MM/YYYY o DD-MM-YYYY
        if (preg_match('/(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})/', $raw, $m)) {
            return sprintf('%04d-%02d-%02d', (int)$m[3], (int)$m[2], (int)$m[1]);
        }

        // Formato YYYY/MM/DD o YYYY-MM-DD
        if (preg_match('/(\d{4})[\/\-](\d{1,2})[\/\-](\d{1,2})/', $raw, $m)) {
            return sprintf('%04d-%02d-%02d', (int)$m[1], (int)$m[2], (int)$m[3]);
        }

        // Formato con mes en texto en español (ej: "01 de Septiembre de 2026", "22-abr-2025")
        $mesesEs = [
            'ENE' => 1, 'FEB' => 2, 'MAR' => 3, 'ABR' => 4, 'MAY' => 5, 'JUN' => 6,
            'JUL' => 7, 'AGO' => 8, 'SEP' => 9, 'SET' => 9, 'OCT' => 10, 'NOV' => 11, 'DIC' => 12,
            'ENERO' => 1, 'FEBRERO' => 2, 'MARZO' => 3, 'ABRIL' => 4, 'MAYO' => 5, 'JUNIO' => 6,
            'JULIO' => 7, 'AGOSTO' => 8, 'SEPTIEMBRE' => 9, 'SETIEMBRE' => 9, 'OCTUBRE' => 10, 'NOVIEMBRE' => 11, 'DICIEMBRE' => 12
        ];
        if (preg_match('/(\d{1,2})\s*(?:de|\-)?\s*([a-zA-ZáéíóúÁÉÍÓÚ]+)\s*(?:de|\-)?\s*(\d{4})/i', $raw, $m)) {
            $mesKey = strtoupper(normalizarTexto($m[2]));
            if (isset($mesesEs[$mesKey])) {
                return sprintf('%04d-%02d-%02d', (int)$m[3], (int)$mesesEs[$mesKey], (int)$m[1]);
            }
        }

        // Serial Excel numérico
        if (is_numeric($raw) && (float)$raw > 1000) {
            try {
                return Date::excelToDateTimeObject($raw)->format('Y-m-d');
            } catch (\Exception $e) {
                return null;
            }
        }

        return null;
    }
}

if (!function_exists('obtenerMetadatosReporteExcel')) {
    function obtenerMetadatosReporteExcel($spreadsheet): array {
        $sheet = $spreadsheet->getActiveSheet();
        $rows = $sheet->toArray();

        $meta = [
            'numero_ficha'  => null,
            'fecha_reporte' => null,
            'cod_programa'  => null,
            'version'       => null,
            'nom_programa'  => null,
            'estado_ficha'  => null,
            'fecha_inicio'  => null,
            'fecha_fin'     => null,
            'modalidad'     => null,
            'regional'      => null,
            'centro'        => null,
        ];

        $maxRows = min(30, count($rows));

        for ($r = 0; $r < $maxRows; $r++) {
            $headers = $rows[$r];
            $colCount = count($headers);

            for ($c = 0; $c < $colCount; $c++) {
                $rawCell = $headers[$c];
                if ($rawCell === null) continue;
                $cellText = normalizarTexto((string)$rawCell);
                if ($cellText === '') continue;

                // Buscar el siguiente valor no vacío en la misma fila
                $nextVal = '';
                $nextColIdx = -1;
                for ($k = $c + 1; $k < $colCount; $k++) {
                    if ($headers[$k] !== null && trim((string)$headers[$k]) !== '') {
                        $nextVal = trim((string)$headers[$k]);
                        $nextColIdx = $k;
                        break;
                    }
                }

                // 1. FECHA DEL REPORTE / CORTE (Extraída directamente del Excel)
                if ($meta['fecha_reporte'] === null) {
                    if (
                        preg_match('/FECHA\s*(?:DEL\s*|DE\s*)?REPORTE/i', $cellText) ||
                        preg_match('/FECHA\s*(?:DE\s*)?CORTE/i', $cellText) ||
                        preg_match('/(?:^|\s)CORTE[:\s]/i', $cellText) ||
                        preg_match('/GENERADO\s*EL/i', $cellText) ||
                        preg_match('/FECHA\s*(?:DE\s*)?GENERACI[OÓ]N/i', $cellText) ||
                        preg_match('/FECHA\s*(?:DE\s*)?EMISI[OÓ]N/i', $cellText)
                    ) {
                        $fCandidate = parseFechaCorte($nextVal);
                        if (!$fCandidate) {
                            $fCandidate = parseFechaCorte($rawCell);
                        }
                        if (!$fCandidate && $nextColIdx !== -1) {
                            try {
                                $cellCoord = \PhpOffice\PhpSpreadsheet\Cell\Coordinate::stringFromColumnIndex($nextColIdx + 1) . ($r + 1);
                                $cellObj = $sheet->getCell($cellCoord);
                                if ($cellObj && Date::isDateTime($cellObj)) {
                                    $fCandidate = Date::excelToDateTimeObject($cellObj->getValue())->format('Y-m-d');
                                }
                            } catch (\Exception $e) {}
                        }
                        if ($fCandidate) {
                            $meta['fecha_reporte'] = $fCandidate;
                        }
                    }
                }

                // 2. FICHA DE CARACTERIZACIÓN (Extraída directamente del Excel)
                if ($meta['numero_ficha'] === null) {
                    if (
                        preg_match('/FICHA\s*DE\s*CARACTERIZACI[OÓ]N/i', $cellText) ||
                        preg_match('/N[UÚ]MERO\s*DE\s*FICHA/i', $cellText) ||
                        preg_match('/NO\.?\s*FICHA/i', $cellText) ||
                        (preg_match('/^FICHA[:\s]/i', $cellText) && !preg_match('/ESTADO/i', $cellText))
                    ) {
                        if (preg_match('/(\d{5,})/i', $cellText, $mF)) {
                            $meta['numero_ficha'] = normalizarNumeroFicha($mF[1]);
                        } elseif ($nextVal !== '' && preg_match('/(\d{5,})/i', $nextVal, $mF)) {
                            $meta['numero_ficha'] = normalizarNumeroFicha($mF[1]);
                        }
                    }
                }

                // 3. CÓDIGO DE PROGRAMA
                if ($meta['cod_programa'] === null && preg_match('/C[OÓ][DG]IGO/i', $cellText) && !preg_match('/COMP|RESUL/i', $cellText)) {
                    if (preg_match('/(\d{4,})/i', $cellText, $mC)) {
                        $meta['cod_programa'] = normalizarNumeroFicha($mC[1]);
                    } elseif ($nextVal !== '' && preg_match('/(\d{4,})/i', $nextVal, $mC)) {
                        $meta['cod_programa'] = normalizarNumeroFicha($mC[1]);
                    }
                }

                // 4. VERSIÓN
                if ($meta['version'] === null && preg_match('/VERSI[OÓ]N/i', $cellText)) {
                    $meta['version'] = $nextVal ?: '01';
                }

                // 5. DENOMINACIÓN / NOMBRE DEL PROGRAMA
                if ($meta['nom_programa'] === null && (preg_match('/DENOMINACI[OÓ]N/i', $cellText) || preg_match('/PROGRAMA\s*DE\s*FORMACI[OÓ]N/i', $cellText))) {
                    $meta['nom_programa'] = $nextVal;
                }

                // 6. ESTADO DE LA FICHA
                if ($meta['estado_ficha'] === null && preg_match('/ESTADO\s+DE\s+LA\s+FICHA/i', $cellText)) {
                    $meta['estado_ficha'] = $nextVal ?: 'EN EJECUCION';
                }

                // 7. FECHA INICIO
                if ($meta['fecha_inicio'] === null && preg_match('/FECHA\s+INICIO/i', $cellText)) {
                    $meta['fecha_inicio'] = parseFechaCorte($nextVal);
                }

                // 8. FECHA FIN
                if ($meta['fecha_fin'] === null && preg_match('/FECHA\s+FIN/i', $cellText)) {
                    $meta['fecha_fin'] = parseFechaCorte($nextVal);
                }

                // 9. MODALIDAD
                if ($meta['modalidad'] === null && preg_match('/MODALIDAD/i', $cellText)) {
                    $meta['modalidad'] = $nextVal ?: 'PRESENCIAL';
                }

                // 10. REGIONAL
                if ($meta['regional'] === null && preg_match('/REGIONAL/i', $cellText)) {
                    $meta['regional'] = $nextVal;
                }

                // 11. CENTRO
                if ($meta['centro'] === null && preg_match('/CENTRO\s+DE\s+FORMACI[OÓ]N/i', $cellText)) {
                    $meta['centro'] = $nextVal;
                }
            }
        }

        return $meta;
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
    function recalcularMetricasFicha(PDO $pdo, int $numeroFicha, ?int $idImportacion = null): array {
        if ($idImportacion === null) {
            $stmtLatest = $pdo->prepare("
                SELECT id 
                FROM historial_importaciones 
                WHERE numero_ficha = :ficha AND estado = 'EXITOSO' 
                ORDER BY fecha_reporte DESC, fecha_importacion DESC 
                LIMIT 1
            ");
            $stmtLatest->execute([':ficha' => $numeroFicha]);
            $idImportacion = (int)$stmtLatest->fetchColumn() ?: null;
        }

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
            ) ON mr.num_documento_aprendiz = a.numero_documento 
             AND (:id_imp::int IS NULL OR mr.id_importacion = :id_imp)
            WHERE f.numero_ficha = :ficha
              AND e.nombre NOT IN ('RETIRO VOLUNTARIO', 'CANCELADO', 'TRASLADADO', 'APLAZADO')
            GROUP BY f.numero_ficha
        ";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([':ficha' => $numeroFicha, ':id_imp' => $idImportacion]);
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
    $inicioProceso = microtime(true);
    $tiempos = [];
    $marcarTiempo = function(string $fase) use (&$tiempos, $inicioProceso) {
        $tiempos[$fase] = round((microtime(true) - $inicioProceso) * 1000, 2);
    };

    // 1. Calcular Hash SHA-256 antes del procesamiento completo
    $fileHash = hash_file('sha256', $fileTmpPath);
    if (!$fileHash) {
        throw new Exception('No se pudo calcular el hash de verificación del archivo.');
    }
    $marcarTiempo('HASH_SHA256');

    // 2. Cargar el archivo Excel con lectura eficiente de solo datos
    $reader = IOFactory::createReaderForFile($fileTmpPath);
    $reader->setReadDataOnly(true);
    $spreadsheet = $reader->load($fileTmpPath);
    $sheet = $spreadsheet->getActiveSheet();
    $rows = $sheet->toArray();
    $marcarTiempo('LECTURA_EXCEL');

    if (count($rows) <= 1) {
        echo json_encode(['success' => false, 'message' => 'El archivo está vacío o solo contiene encabezados.']);
        return;
    }

    // 3. Extracción de metadatos de la cabecera directamente desde el Excel
    $meta = obtenerMetadatosReporteExcel($spreadsheet);
    $marcarTiempo('EXTRACCION_METADATOS');

    // 4. Validaciones obligatorias de la cabecera (Ficha y Fecha extraídas exclusivamente del archivo)
    if (empty($meta['numero_ficha']) || !is_numeric($meta['numero_ficha'])) {
        throw new Exception('No se pudo detectar el número de Ficha de Caracterización en el archivo Excel.');
    }
    $ficha = (int)$meta['numero_ficha'];

    if (empty($meta['fecha_reporte'])) {
        throw new Exception('No se pudo detectar una Fecha del Reporte o Corte válida en el archivo Excel.');
    }
    $fecha_reporte = $meta['fecha_reporte'];

    if (empty($meta['cod_programa']) || !is_numeric($meta['cod_programa'])) {
        throw new Exception('No se pudo detectar el Código del Programa en el archivo Excel.');
    }
    $cod_programa = (int)$meta['cod_programa'];
    $nom_programa = $meta['nom_programa'] ?: 'PROGRAMA DE FORMACION';
    $version = $meta['version'] ?: '01';
    $modalidad = $meta['modalidad'] ?: 'PRESENCIAL';
    $estado_ficha = $meta['estado_ficha'] ?: 'EN EJECUCION';
    $fecha_inicio = $meta['fecha_inicio'];
    $fecha_fin = $meta['fecha_fin'];

    // Búsqueda de la fila de encabezados de la tabla de juicios evaluativos
    $headerRowIndex = null;
    $colMap = [];

    for ($r = 0; $r < min(30, count($rows)); $r++) {
        $headers = $rows[$r];
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
            } elseif (strpos($headerName, 'CODIGO') !== false && strpos($headerName, 'COMP') !== false) {
                $tempMap['cod_comp'] = $c;
            } elseif (strpos($headerName, 'COMPETENCIA') !== false) {
                if (!isset($tempMap['nom_comp'])) $tempMap['nom_comp'] = $c;
            } elseif (strpos($headerName, 'CODIGO') !== false && strpos($headerName, 'RESUL') !== false) {
                $tempMap['cod_resul'] = $c;
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

    // 7.1. Upsert Programa (Identidad estrictamente codigo_programa)
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

    // 7.2. Upsert Ficha (Debe existir antes de historial_importaciones por FK)
    if (!$fichaActual) {
        $stmt_ins_f = $pdo->prepare("
            INSERT INTO fichas (numero_ficha, codigo_programa, fecha_inicio, fecha_fin, estado_ficha, fecha_reporte)
            VALUES (?, ?, ?, ?, ?, ?)
        ");
        $stmt_ins_f->execute([$ficha, $cod_programa, $fecha_inicio, $fecha_fin, $estado_ficha, $fecha_reporte]);
    } else {
        // Solo actualizar fecha_reporte en fichas si la fecha importada es igual o más reciente
        $debeActualizarFechaFicha = (!$fecha_bd || $fecha_reporte >= $fecha_bd);
        $nuevaFechaFicha = $debeActualizarFechaFicha ? $fecha_reporte : $fecha_bd;

        $stmt_upd_f = $pdo->prepare("
            UPDATE fichas SET 
                codigo_programa = ?,
                fecha_inicio = COALESCE(?, fecha_inicio),
                fecha_fin = COALESCE(?, fecha_fin),
                estado_ficha = ?,
                fecha_reporte = ?
            WHERE numero_ficha = ?
        ");
        $stmt_upd_f->execute([$cod_programa, $fecha_inicio, $fecha_fin, $estado_ficha, $nuevaFechaFicha, $ficha]);
    }

    // 7.3. Crear o resolver corte histórico en historial_importaciones
    $stmt_corte_fecha = $pdo->prepare("
        SELECT id, hash_archivo, nombre_archivo 
        FROM historial_importaciones 
        WHERE numero_ficha = :ficha AND fecha_reporte = :fecha 
        ORDER BY id DESC LIMIT 1
    ");
    $stmt_corte_fecha->execute([':ficha' => $ficha, ':fecha' => $fecha_reporte]);
    $corteExistenteFecha = $stmt_corte_fecha->fetch(PDO::FETCH_ASSOC);

    if ($corteExistenteFecha) {
        // CASO D: Misma ficha + misma fecha + archivo diferente (actualizar corte de esta fecha)
        $id_importacion = (int)$corteExistenteFecha['id'];
        $modo = 'ACTUALIZACION_CORTE';

        // Limpiar únicamente los juicios y estados de ESTE corte específico para sobreescribirlo limpiamente
        $pdo->prepare("DELETE FROM matricula_resultados WHERE id_importacion = ?")->execute([$id_importacion]);
        $pdo->prepare("DELETE FROM corte_aprendices WHERE id_importacion = ?")->execute([$id_importacion]);

        $pdo->prepare("
            UPDATE historial_importaciones 
            SET nombre_archivo = ?, hash_archivo = ?, fecha_importacion = NOW(), modo_procesamiento = ?, estado = 'PROCESANDO', mensaje = 'Actualizando corte existente'
            WHERE id = ?
        ")->execute([$fileName, $fileHash, $modo, $id_importacion]);
    } else {
        // CASO A / B: Nuevo corte histórico para esta fecha
        $modo = ($fecha_bd && $fecha_reporte < $fecha_bd) ? 'CORTE_HISTORICO_ANTERIOR' : 'NUEVO_CORTE';
        $stmt_crear_corte = $pdo->prepare("
            INSERT INTO historial_importaciones (
                numero_ficha, fecha_reporte, fecha_importacion, nombre_archivo, hash_archivo,
                modo_procesamiento, estado, mensaje
            ) VALUES (?, ?, NOW(), ?, ?, ?, 'PROCESANDO', 'Importando nuevo corte')
            RETURNING id
        ");
        $stmt_crear_corte->execute([$ficha, $fecha_reporte, $fileName, $fileHash, $modo]);
        $id_importacion = (int)$stmt_crear_corte->fetchColumn();
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

    // Pre-cargar juicios existentes de ESTE corte específico (para Caso D)
    $cache_matriculas = [];
    $stmt_mat_ficha = $pdo->prepare("
        SELECT mr.id, mr.num_documento_aprendiz, mr.codigo_resul, mr.id_juicio_cat, 
               UPPER(jc.descripcion) as juicio_nombre, mr.fecha_registro, mr.num_documento_instructor
        FROM matricula_resultados mr
        JOIN juicios_catalogo jc ON mr.id_juicio_cat = jc.id_juicio_cat
        WHERE mr.id_importacion = ?
    ");
    $stmt_mat_ficha->execute([$id_importacion]);
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
    $stmt_upd_aprendiz = $pdo->prepare("UPDATE aprendices SET tipo_documento = ?, nombres = ?, apellidos = ?, id_estado = ?, numero_ficha = ? WHERE numero_documento = ?");
    $stmt_ins_corte_ap = $pdo->prepare("INSERT INTO corte_aprendices (id_importacion, numero_documento, id_estado) VALUES (?, ?, ?) ON CONFLICT (id_importacion, numero_documento) DO UPDATE SET id_estado = EXCLUDED.id_estado");
    $stmt_comp = $pdo->prepare("INSERT INTO competencias (codigo_comp, nombre_comp, codigo_programa) VALUES (?, ?, ?) ON CONFLICT (codigo_comp) DO UPDATE SET nombre_comp = EXCLUDED.nombre_comp");
    $stmt_res = $pdo->prepare("INSERT INTO resultados (codigo_resul, nombre_resultado, codigo_comp) VALUES (?, ?, ?) ON CONFLICT (codigo_resul) DO UPDATE SET nombre_resultado = EXCLUDED.nombre_resultado");
    $stmt_inst = $pdo->prepare("INSERT INTO instructores (num_documento, nombres_apellidos, cargo) VALUES (?, ?, 'Instructor') ON CONFLICT (num_documento) DO NOTHING");
    $stmt_ins_mat = $pdo->prepare("INSERT INTO matricula_resultados (id_importacion, fecha_reporte, numero_ficha, num_documento_aprendiz, codigo_resul, id_juicio_cat, num_documento_instructor, fecha_registro) VALUES (?, ?, ?, ?, ?, ?, ?, ?) ON CONFLICT (id_importacion, num_documento_aprendiz, codigo_resul) DO UPDATE SET id_juicio_cat = EXCLUDED.id_juicio_cat, num_documento_instructor = EXCLUDED.num_documento_instructor, fecha_registro = EXCLUDED.fecha_registro");
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

    // Lotes optimizados para evitar miles de viajes de red (evita Error 504)
    $batchMatriculas = [];
    $flushBatchMatriculas = function() use (&$batchMatriculas, $pdo) {
        if (empty($batchMatriculas)) return;
        $placeholders = [];
        $params = [];
        foreach ($batchMatriculas as $row) {
            $placeholders[] = "(?, ?, ?, ?, ?, ?, ?, ?)";
            foreach ($row as $val) {
                $params[] = $val;
            }
        }
        $sqlBatch = "INSERT INTO matricula_resultados (id_importacion, fecha_reporte, numero_ficha, num_documento_aprendiz, codigo_resul, id_juicio_cat, num_documento_instructor, fecha_registro) VALUES " . implode(", ", $placeholders) . " ON CONFLICT (id_importacion, num_documento_aprendiz, codigo_resul) DO UPDATE SET id_juicio_cat = EXCLUDED.id_juicio_cat, num_documento_instructor = EXCLUDED.num_documento_instructor, fecha_registro = EXCLUDED.fecha_registro";
        $pdo->prepare($sqlBatch)->execute($params);
        $batchMatriculas = [];
    };

    $corteAprendicesBatch = [];

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

        // 11.B. Registro / Actualización del Aprendiz para la ficha del reporte
        if (isset($cache_aprendices_db[$num_doc])) {
            $appDb = $cache_aprendices_db[$num_doc];
            $rawDocTarget = $appDb['raw_doc'] ?? $num_doc;
            if ($appDb['nombres'] !== $nombres || $appDb['apellidos'] !== $apellidos || $appDb['id_estado'] !== $estado_id || ($appDb['numero_ficha'] ?? '') !== $ficha_archivo_norm) {
                $stmt_upd_aprendiz->execute([$tipo_doc, $nombres, $apellidos, $estado_id, (int)$ficha, $rawDocTarget]);
                $cache_aprendices_db[$num_doc]['nombres'] = $nombres;
                $cache_aprendices_db[$num_doc]['apellidos'] = $apellidos;
                $cache_aprendices_db[$num_doc]['id_estado'] = $estado_id;
                $cache_aprendices_db[$num_doc]['numero_ficha'] = $ficha_archivo_norm;
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

        // Acumular estado del aprendiz para este corte (se insertará en un solo lote al final)
        $corteAprendicesBatch[$num_doc] = $estado_id;

        // 11.C. Competencia (Soporta transversales y específicas)
        $raw_comp = getCol($data, $colMap, 'nom_comp', '');
        if (empty($raw_comp)) {
            $contadores['conflictos']++;
            $advertencias[] = "Competencia vacía para el aprendiz $num_doc. Fila omitida.";
            continue;
        }
        $raw_cod_comp = getCol($data, $colMap, 'cod_comp', '');
        list($cod_comp_str, $nom_comp) = splitCodeName($raw_comp);
        $cod_comp = null;
        if (is_numeric($raw_cod_comp) && (int)$raw_cod_comp > 0) {
            $cod_comp = (int)$raw_cod_comp;
        } elseif (is_numeric($cod_comp_str) && (int)$cod_comp_str > 0) {
            $cod_comp = (int)$cod_comp_str;
        } elseif (is_numeric($raw_comp) && (int)$raw_comp > 0) {
            $cod_comp = (int)$raw_comp;
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

        if (!isset($cache_comp_programa[$cod_comp])) {
            $stmt_comp->execute([$cod_comp, $nom_comp, $cod_programa]);
            $cache_comp_programa[$cod_comp] = $cod_programa;
            $cache_comp_por_nombre[normalizarTexto($nom_comp)][$cod_programa] = $cod_comp;
        }

        // 11.D. Resultado de Aprendizaje
        $raw_resul = getCol($data, $colMap, 'nom_resul', '');
        if (empty($raw_resul)) {
            $contadores['conflictos']++;
            $advertencias[] = "Resultado de aprendizaje vacío para el aprendiz $num_doc. Fila omitida.";
            continue;
        }
        $raw_cod_resul = getCol($data, $colMap, 'cod_resul', '');
        list($cod_resul_str, $nom_resul) = splitCodeName($raw_resul);
        $cod_resul = null;
        if (is_numeric($raw_cod_resul) && (int)$raw_cod_resul > 0) {
            $cod_resul = (int)$raw_cod_resul;
        } elseif (is_numeric($cod_resul_str) && (int)$cod_resul_str > 0) {
            $cod_resul = (int)$cod_resul_str;
        } elseif (is_numeric($raw_resul) && (int)$raw_resul > 0) {
            $cod_resul = (int)$raw_resul;
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

        if (!isset($cache_resul_comp[$cod_resul])) {
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
        $fecha_juicio = parseFecha($raw_fecha);

        // 11.G. Evaluación de Juicio en Base de Datos (Idempotencia y Cronología)
        if (!isset($cache_matriculas[$num_doc][$cod_resul])) {
            $fecha_a_guardar = $fecha_juicio;
            if ($fecha_a_guardar === null && $raw_juicio === 'APROBADO') {
                $fecha_a_guardar = $fecha_reporte . ' 00:00:00';
            }

            // Acumular en lote para inserción masiva optimizada
            $batchMatriculas[] = [$id_importacion, $fecha_reporte, (int)$ficha, $num_doc, $cod_resul, $juicio_id, $doc_instructor, $fecha_a_guardar];
            $cache_matriculas[$num_doc][$cod_resul] = [
                'id'             => 0,
                'id_juicio_cat'  => $juicio_id,
                'juicio_nombre'  => $raw_juicio,
                'fecha_registro' => $fecha_a_guardar,
                'instructor'     => $doc_instructor
            ];
            $contadores['nuevos']++;

            if (count($batchMatriculas) >= 200) {
                $flushBatchMatriculas();
            }

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

    // Vaciar juicios restantes en lote
    $flushBatchMatriculas();

    // Guardar en un solo lote optimizado todos los estados del corte en corte_aprendices
    if (!empty($corteAprendicesBatch)) {
        $cortePlaces = [];
        $corteParams = [];
        foreach ($corteAprendicesBatch as $cDoc => $cEstId) {
            $cortePlaces[] = "(?, ?, ?)";
            $corteParams[] = $id_importacion;
            $corteParams[] = $cDoc;
            $corteParams[] = $cEstId;
        }
        $sqlBatchCorte = "INSERT INTO corte_aprendices (id_importacion, numero_documento, id_estado) VALUES " . implode(", ", $cortePlaces) . " ON CONFLICT (id_importacion, numero_documento) DO UPDATE SET id_estado = EXCLUDED.id_estado";
        $pdo->prepare($sqlBatchCorte)->execute($corteParams);
    }
    $marcarTiempo('PROCESAMIENTO_FILAS_Y_LOTES');

    // 12. Actualizar registro en historial_importaciones con métricas finales del corte
    $stmt_upd_hist = $pdo->prepare("
        UPDATE historial_importaciones SET
            total_filas = ?, registros_nuevos = ?, registros_actualizados = ?, registros_sin_cambios = ?,
            registros_omitidos = ?, registros_conflicto = ?, modo_procesamiento = ?, estado = 'EXITOSO', mensaje = ?
        WHERE id = ?
    ");
    $msgHistorial = "Procesamiento $modo completado exitosamente.";
    $stmt_upd_hist->execute([
        $contadores['total'], $contadores['nuevos'], $contadores['actualizados'], $contadores['sin_cambios'],
        $contadores['omitidos'], $contadores['conflictos'], $modo, $msgHistorial, $id_importacion
    ]);

    // 13. Recalcular Métricas de la Ficha para este corte
    $metricas = recalcularMetricasFicha($pdo, $ficha, $id_importacion);

    // 14. Confirmar Transacción
    $pdo->commit();
    $marcarTiempo('COMMIT');
    $marcarTiempo('TOTAL_PROCESO');

    // 15. Devolver Respuesta JSON Compatible
    $msgUsuario = ($modo === 'SELECTIVO_HISTÓRICO')
        ? "Archivo histórico (corte $fecha_reporte) procesado selectivamente: se incorporaron registros faltantes sin afectar información reciente."
        : "Importación completada exitosamente para la ficha $ficha (corte: $fecha_reporte).";

    $resumenObj = [
        'id_importacion'         => $id_importacion,
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
        'avance_general'         => $metricas['porcentaje_avance'] . '%',
        'tiempos_ms'             => $tiempos
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
