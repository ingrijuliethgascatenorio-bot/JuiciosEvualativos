<?php
error_reporting(E_ALL); 
ini_set('display_errors', 1);
ini_set('memory_limit', '1024M');

require 'db.php';
require 'vendor/autoload.php';

use PhpOffice\PhpSpreadsheet\IOFactory;

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
    exit;
}

if (!isset($_FILES['archivo']) || $_FILES['archivo']['error'] !== UPLOAD_ERR_OK) {
    echo json_encode(['success' => false, 'message' => 'Error al subir el archivo.']);
    exit;
}

$fileTmpPath = $_FILES['archivo']['tmp_name'];
$fileName = $_FILES['archivo']['name'];
$extension = strtolower(pathinfo($fileName, PATHINFO_EXTENSION));

if (!in_array($extension, ['csv', 'xlsx', 'xls'])) {
    echo json_encode(['success' => false, 'message' => 'El archivo debe ser un CSV, XLSX o XLS']);
    exit;
}

try {
    // Leer el archivo excel o CSV
    $spreadsheet = IOFactory::load($fileTmpPath);
    $sheet = $spreadsheet->getActiveSheet();
    $rows = $sheet->toArray(); // Array 2D
    
    if(count($rows) <= 1) {
        echo json_encode(['success' => false, 'message' => 'El archivo está vacío o solo tiene la fila de encabezado']);
        exit;
    }
    
    $headerRowIndex = 0;
    $colMap = [];
    
    // Variables globales extraídas de la cabecera (metadata)
    $global_ficha = '0';
    $global_cod_programa = '';
    $global_nom_programa = 'PROGRAMA GENERICO';
    
    // Buscar la verdadera fila de encabezados y la metadata en toda la matriz (primeras 20 filas)
    for ($r = 0; $r < min(20, count($rows)); $r++) {
        $headers = $rows[$r];
        
        for ($c = 0; $c < count($headers); $c++) {
            $cellText = strtoupper(trim((string)($headers[$c] ?? '')));
            if ($cellText === '') continue;
            
            // Buscar el valor en la celda siguiente
            $nextVal = '';
            for ($k = $c + 1; $k < count($headers); $k++) {
                if (trim((string)$headers[$k]) !== '') {
                    $nextVal = trim((string)$headers[$k]);
                    break;
                }
            }

            if (strpos($cellText, 'FICHA') !== false && $global_ficha === '0') $global_ficha = $nextVal;
            if (($cellText === 'CÓDIGO:' || $cellText === 'CODIGO:') && $global_cod_programa === '') $global_cod_programa = $nextVal;
            if (strpos($cellText, 'DENOMINA') !== false) $global_nom_programa = $nextVal;
        }

        $tempMap = [];
        for($c = 0; $c < count($headers); $c++) {
            // Reemplazar saltos de línea con espacios para facilitar la búsqueda
            $headerName = strtoupper(trim(str_replace(["\r", "\n"], ' ', (string)$headers[$c])));
            
            if(strpos($headerName, 'TIPO') !== false && strpos($headerName, 'DOC') !== false) {
                if(!isset($tempMap['tipo_doc'])) $tempMap['tipo_doc'] = $c;
            }
            elseif(strpos($headerName, 'NÚMERO') !== false || strpos($headerName, 'NUMERO') !== false || strpos($headerName, 'DOCUMENTO') !== false) {
                if(!isset($tempMap['num_doc'])) $tempMap['num_doc'] = $c;
            }
            elseif((strpos($headerName, 'NOMBRE') !== false || strpos($headerName, 'NOMBRES') !== false) && strpos($headerName, 'PROGRAMA') === false && strpos($headerName, 'COMPETENCIA') === false) {
                if(!isset($tempMap['nombres'])) $tempMap['nombres'] = $c;
            }
            elseif(strpos($headerName, 'APELLIDO') !== false) {
                if(!isset($tempMap['apellidos'])) $tempMap['apellidos'] = $c;
            }
            elseif(strpos($headerName, 'ESTADO') !== false) {
                if(!isset($tempMap['estado'])) $tempMap['estado'] = $c;
            }
            elseif(strpos($headerName, 'COMPETENCIA') !== false) {
                if(!isset($tempMap['nom_comp'])) $tempMap['nom_comp'] = $c;
            }
            elseif(strpos($headerName, 'RESULTADO') !== false) {
                if(!isset($tempMap['nom_resul'])) $tempMap['nom_resul'] = $c;
            }
            elseif(strpos($headerName, 'JUICIO') !== false) {
                // SOFIA tiene 3 columnas que dicen "JUICIO": Juicio Evaluativo, Funcionario que registró el juicio, y Fecha de evaluación del juicio
                if(strpos($headerName, 'FECHA') !== false || strpos($headerName, 'HORA') !== false) {
                    if(!isset($tempMap['fecha_hora'])) $tempMap['fecha_hora'] = $c;
                } elseif(strpos($headerName, 'FUNCIONARIO') !== false || strpos($headerName, 'REGISTRÓ') !== false || strpos($headerName, 'REGISTRO') !== false) {
                    if(!isset($tempMap['nom_instructor'])) $tempMap['nom_instructor'] = $c;
                } else {
                    if(!isset($tempMap['juicio'])) $tempMap['juicio'] = $c;
                }
            }
            elseif(strpos($headerName, 'FUNCIONARIO') !== false || strpos($headerName, 'INSTRUCTOR') !== false) {
                if(!isset($tempMap['nom_instructor'])) $tempMap['nom_instructor'] = $c;
            }
            elseif(strpos($headerName, 'FECHA') !== false && (strpos($headerName, 'HORA') !== false || strpos($headerName, 'EVALUACION') !== false)) {
                if(!isset($tempMap['fecha_hora'])) $tempMap['fecha_hora'] = $c;
            }
        }
        
        // Si encontramos al menos 3 columnas clave, asumimos que esta es la fila de encabezados
        if (isset($tempMap['nombres']) || isset($tempMap['num_doc']) || isset($tempMap['estado']) || isset($tempMap['juicio'])) {
            if (count($tempMap) >= 3) {
                $colMap = $tempMap;
                $headerRowIndex = $r;
                break;
            }
        }
    }

    $pdo->beginTransaction();
    
    $processed = 0;
    
    // Extracción segura
    function getCol($data, $map, $key, $default = '') {
        return isset($map[$key]) && isset($data[$map[$key]]) ? trim((string)$data[$map[$key]]) : $default;
    }
    
    // Función para separar código y nombre ("12345 - Nombre de prueba" -> ["12345", "Nombre de prueba"])
    function splitCodeName($string) {
        $parts = explode('-', $string, 2);
        if (count($parts) == 2) {
            return [trim($parts[0]), trim($parts[1])];
        }
        return ['', trim($string)];
    }

    // Comenzar a leer desde la fila siguiente al encabezado detectado
    for ($i = $headerRowIndex + 1; $i < count($rows); $i++) {
        $data = $rows[$i];
        
        // Extracción
        $tipo_doc = strtoupper(getCol($data, $colMap, 'tipo_doc', 'CC'));
        $num_doc = getCol($data, $colMap, 'num_doc');
        $nombres = getCol($data, $colMap, 'nombres', 'SIN NOMBRE');
        $apellidos = getCol($data, $colMap, 'apellidos', '');
        $estado_nombre = strtoupper(getCol($data, $colMap, 'estado', 'EN FORMACIÓN'));
        
        // Ficha
        $ficha = $global_ficha;
        if($ficha === '' || !is_numeric($ficha)) $ficha = '0';
        
        // Programa
        $nom_programa = $global_nom_programa;
        $cod_programa = $global_cod_programa;
        if($cod_programa === '' || !is_numeric($cod_programa)) $cod_programa = abs(crc32($nom_programa) % 2000000000);

        // Competencia viene junta: "36180 - Enrique Low..."
        $raw_comp = getCol($data, $colMap, 'nom_comp', 'COMPETENCIA DESCONOCIDA');
        list($cod_comp, $nom_comp) = splitCodeName($raw_comp);
        if($cod_comp === '' || !is_numeric($cod_comp)) $cod_comp = abs(crc32($nom_comp) % 2000000000);

        // Resultado viene junto: "593147 - 02 ESTABLECER..."
        $raw_resul = getCol($data, $colMap, 'nom_resul', 'RESULTADO DESCONOCIDO');
        list($cod_resul, $nom_resul) = splitCodeName($raw_resul);
        if($cod_resul === '' || !is_numeric($cod_resul)) $cod_resul = abs(crc32($nom_resul) % 2000000000);

        // Juicio evaluativo (SOFIA pone un '-' cuando es POR EVALUAR)
        $juicio = strtoupper(getCol($data, $colMap, 'juicio', 'POR EVALUAR'));
        if ($juicio === '-' || empty($juicio)) $juicio = 'POR EVALUAR';
        
        // Validación estricta para evitar que fechas o nombres se filtren como juicios
        if (!in_array($juicio, ['APROBADO', 'POR EVALUAR', 'NO APROBADO'])) {
            $juicio = 'POR EVALUAR';
        }
        
        // Instructor viene a veces junto: "CC 123456 - JUAN PEREZ"
        $raw_instructor = getCol($data, $colMap, 'nom_instructor', 'SIN ASIGNAR');
        list($doc_instructor_tmp, $nom_instructor_tmp) = splitCodeName($raw_instructor);
        $doc_instructor = ($doc_instructor_tmp !== '') ? preg_replace('/[^0-9]/', '', $doc_instructor_tmp) : '000000000';
        $nom_instructor = ($nom_instructor_tmp !== '') ? $nom_instructor_tmp : $raw_instructor;
        if(empty($doc_instructor)) $doc_instructor = '000000000';

        $raw_fecha = getCol($data, $colMap, 'fecha_hora', '');
        $fecha_hora = date('Y-m-d H:i:s');
        if (!empty($raw_fecha) && $raw_fecha !== '-') {
            // Limpiar pm, am, a, p al final
            $clean_fecha = preg_replace('/(?i)\s*pm|\s*am|\s*a|\s*p$/', '', trim($raw_fecha));
            // Cambiar punto por dos puntos en la hora
            $clean_fecha = preg_replace('/(\d{1,2})\.(\d{2})/', '$1:$2', $clean_fecha);
            
            if (preg_match('/(\d{1,2})\/(\d{1,2})\/(\d{4})\s*(.*)/', $clean_fecha, $m)) {
                $time = trim($m[4]);
                if (empty($time)) $time = '00:00:00';
                elseif (strlen($time) == 5) $time .= ':00'; // 18:02 -> 18:02:00
                $fecha_hora = $m[3] . '-' . str_pad($m[2], 2, '0', STR_PAD_LEFT) . '-' . str_pad($m[1], 2, '0', STR_PAD_LEFT) . ' ' . $time;
            } else if (is_numeric($raw_fecha)) {
                $fecha_hora = \PhpOffice\PhpSpreadsheet\Shared\Date::excelToDateTimeObject($raw_fecha)->format('Y-m-d H:i:s');
            }
        }
        
        // Validaciones estrictas: Si la fila no tiene documento de aprendiz, ignorarla
        if(empty($num_doc) || $num_doc === '') continue;

        // Limpieza extra para el estado (ej. "En Formación" -> "EN FORMACIÓN")
        if($estado_nombre == 'EN FORMACION') $estado_nombre = 'EN FORMACIÓN';

        // 1. Programa
        $stmt = $pdo->prepare("INSERT INTO programas (codigo_programa, nombre_programa, version, modalidad) VALUES (?, ?, '1.0', 'PRESENCIAL') ON CONFLICT (codigo_programa) DO NOTHING");
        $stmt->execute([(int)$cod_programa, $nom_programa]);

        // 2. Ficha
        $stmt = $pdo->prepare("INSERT INTO fichas (numero_ficha, codigo_programa, estado_ficha) VALUES (?, ?, 'ACTIVA') ON CONFLICT (numero_ficha) DO NOTHING");
        $stmt->execute([(int)$ficha, (int)$cod_programa]);

        // 3. Estado
        $stmt = $pdo->prepare("SELECT id_estado FROM estados WHERE nombre = ?");
        $stmt->execute([$estado_nombre]);
        $estado_id = $stmt->fetchColumn();
        if (!$estado_id) {
            $stmt = $pdo->prepare("INSERT INTO estados (nombre) VALUES (?) RETURNING id_estado");
            $stmt->execute([$estado_nombre]);
            $estado_id = $stmt->fetchColumn();
        }

        // 4. Aprendiz (Actualizar nombres si antes decia SIN NOMBRE o si cambia la ficha)
        $stmt = $pdo->prepare("INSERT INTO aprendices (numero_documento, tipo_documento, nombres, apellidos, id_estado, numero_ficha) VALUES (?, ?, ?, ?, ?, ?) ON CONFLICT (numero_documento) DO UPDATE SET id_estado = EXCLUDED.id_estado, nombres = EXCLUDED.nombres, apellidos = EXCLUDED.apellidos, numero_ficha = EXCLUDED.numero_ficha");
        $stmt->execute([$num_doc, $tipo_doc, $nombres, $apellidos, $estado_id, (int)$ficha]);

        // 5. Competencia
        $stmt = $pdo->prepare("INSERT INTO competencias (codigo_comp, nombre_comp, codigo_programa) VALUES (?, ?, ?) ON CONFLICT (codigo_comp) DO NOTHING");
        $stmt->execute([(int)$cod_comp, $nom_comp, (int)$cod_programa]);

        // 6. Resultado
        $stmt = $pdo->prepare("INSERT INTO resultados (codigo_resul, nombre_resultado, codigo_comp) VALUES (?, ?, ?) ON CONFLICT (codigo_resul) DO NOTHING");
        $stmt->execute([(int)$cod_resul, $nom_resul, (int)$cod_comp]);

        // 7. Instructor
        $stmt = $pdo->prepare("INSERT INTO instructores (num_documento, nombres_apellidos, cargo) VALUES (?, ?, 'Instructor') ON CONFLICT (num_documento) DO NOTHING");
        $stmt->execute([$doc_instructor, $nom_instructor]);

        // 8. Juicio
        $stmt = $pdo->prepare("SELECT id_juicio_cat FROM juicios_catalogo WHERE descripcion = ?");
        $stmt->execute([$juicio]);
        $juicio_id = $stmt->fetchColumn();
        if (!$juicio_id) {
            $stmt = $pdo->prepare("INSERT INTO juicios_catalogo (descripcion) VALUES (?) RETURNING id_juicio_cat");
            $stmt->execute([$juicio]);
            $juicio_id = $stmt->fetchColumn();
        }

        // 9. Matricula_Resultados
        $stmt = $pdo->prepare("INSERT INTO matricula_resultados (num_documento_aprendiz, codigo_resul, id_juicio_cat, num_documento_instructor, fecha_registro) 
                               VALUES (?, ?, ?, ?, ?) 
                               ON CONFLICT (num_documento_aprendiz, codigo_resul) 
                               DO UPDATE SET id_juicio_cat = EXCLUDED.id_juicio_cat, num_documento_instructor = EXCLUDED.num_documento_instructor, fecha_registro = EXCLUDED.fecha_registro");
        $stmt->execute([$num_doc, (int)$cod_resul, $juicio_id, $doc_instructor, $fecha_hora]);
        
        $processed++;
    }
    
    $pdo->commit();
    $debugInfo = "Mapeo usado: " . json_encode($colMap) . " | Ficha Detectada: $global_ficha | Filas procesadas: $processed";
    echo json_encode(['success' => true, 'message' => "Archivo procesado exitosamente. Se actualizaron los nombres. $debugInfo"]);
    
} catch (Exception $e) {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    echo json_encode(['success' => false, 'message' => 'Error al procesar el archivo: ' . $e->getMessage()]);
}
?>
