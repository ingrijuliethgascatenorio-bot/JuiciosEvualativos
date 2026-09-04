<?php
/**
 * SGJE — Migración: Historial de Cortes y Versionado por Fecha de Reporte
 * Archivo: migrate_historial_cortes.php
 *
 * Características:
 * - 100% No destructivo (sin DROP TABLE ni TRUNCATE).
 * - Idempotente y re-ejecutable.
 * - Detecta restricciones reales por catálogo de PostgreSQL (pg_constraint).
 * - Vincula de forma segura los registros existentes en matricula_resultados
 *   sin dejar registros huérfanos.
 */

require __DIR__ . '/db.php';

echo "═══════════════════════════════════════════════════════════════════════\n";
echo "       MIGRACIÓN DE BASE DE DATOS: HISTORIAL DE CORTES (SGJE)          \n";
echo "═══════════════════════════════════════════════════════════════════════\n\n";

try {
    $pdo->beginTransaction();

    // ── PASO 1: Agregar columnas a matricula_resultados ──────────────────────────
    echo "[PASO 1] Verificando / agregando columnas a matricula_resultados...\n";
    $pdo->exec("
        ALTER TABLE matricula_resultados 
            ADD COLUMN IF NOT EXISTS id_importacion INTEGER REFERENCES historial_importaciones(id) ON DELETE CASCADE,
            ADD COLUMN IF NOT EXISTS fecha_reporte DATE,
            ADD COLUMN IF NOT EXISTS numero_ficha INTEGER;
    ");
    echo "  ✓ Columnas (id_importacion, fecha_reporte, numero_ficha) listas.\n";

    // ── PASO 2: Crear tabla corte_aprendices ─────────────────────────────────────
    echo "\n[PASO 2] Verificando / creando tabla corte_aprendices...\n";
    $pdo->exec("
        CREATE TABLE IF NOT EXISTS corte_aprendices (
            id_importacion INTEGER NOT NULL REFERENCES historial_importaciones(id) ON DELETE CASCADE,
            numero_documento VARCHAR(50) NOT NULL REFERENCES aprendices(numero_documento) ON DELETE CASCADE,
            id_estado INTEGER REFERENCES estados(id_estado),
            PRIMARY KEY (id_importacion, numero_documento)
        );
    ");
    echo "  ✓ Tabla corte_aprendices lista.\n";

    // ── PASO 3: Migrar registros existentes sin corte ────────────────────────────
    echo "\n[PASO 3] Vinculando datos existentes en matricula_resultados...\n";
    $stmtHuerfanos = $pdo->query("
        SELECT COUNT(mr.id) as cant_huerfanos
        FROM matricula_resultados mr
        WHERE mr.id_importacion IS NULL
    ");
    $cantHuerfanos = (int)$stmtHuerfanos->fetchColumn();

    if ($cantHuerfanos > 0) {
        echo "  ℹ Se encontraron $cantHuerfanos registros en matricula_resultados sin corte asignado.\n";

        // Obtener fichas involucradas
        $stmtFichas = $pdo->query("
            SELECT DISTINCT a.numero_ficha
            FROM matricula_resultados mr
            JOIN aprendices a ON a.numero_documento = mr.num_documento_aprendiz
            WHERE mr.id_importacion IS NULL AND a.numero_ficha IS NOT NULL
        ");
        $fichasInvolucradas = $stmtFichas->fetchAll(PDO::FETCH_COLUMN);

        foreach ($fichasInvolucradas as $numFicha) {
            $numFicha = (int)$numFicha;

            // 1. Buscar si ya existe un corte EXITOSO en historial_importaciones para esta ficha
            $stmtCorte = $pdo->prepare("
                SELECT id, fecha_reporte
                FROM historial_importaciones
                WHERE numero_ficha = :ficha AND estado = 'EXITOSO'
                ORDER BY fecha_reporte DESC, fecha_importacion DESC
                LIMIT 1
            ");
            $stmtCorte->execute([':ficha' => $numFicha]);
            $corte = $stmtCorte->fetch(PDO::FETCH_ASSOC);

            if ($corte) {
                $idImportacion = (int)$corte['id'];
                $fechaReporte = $corte['fecha_reporte'];
            } else {
                // 2. Si no existe en historial_importaciones, determinar fecha de corte base
                $stmtFechaFicha = $pdo->prepare("SELECT fecha_reporte FROM fichas WHERE numero_ficha = :ficha");
                $stmtFechaFicha->execute([':ficha' => $numFicha]);
                $fechaReporte = $stmtFechaFicha->fetchColumn();

                if (!$fechaReporte) {
                    // Si fichas.fecha_reporte es null, tomar fecha_registro más reciente de sus juicios
                    $stmtMaxJuicio = $pdo->prepare("
                        SELECT MAX(mr.fecha_registro)
                        FROM matricula_resultados mr
                        JOIN aprendices a ON a.numero_documento = mr.num_documento_aprendiz
                        WHERE a.numero_ficha = :ficha
                    ");
                    $stmtMaxJuicio->execute([':ficha' => $numFicha]);
                    $maxFechaReg = $stmtMaxJuicio->fetchColumn();
                    $fechaReporte = $maxFechaReg ? substr($maxFechaReg, 0, 10) : date('Y-m-d');
                }

                // Crear registro de corte base en historial_importaciones
                $hashBase = 'CORTE_BASE_' . $numFicha . '_' . str_replace('-', '', $fechaReporte);
                $stmtInsCorte = $pdo->prepare("
                    INSERT INTO historial_importaciones (
                        numero_ficha, fecha_reporte, fecha_importacion, nombre_archivo, hash_archivo,
                        modo_procesamiento, estado, mensaje
                    ) VALUES (
                        :ficha, :fecha_rep, NOW(), :archivo, :hash, 'CORTE_BASE_MIGRACION', 'EXITOSO', 'Corte base generado en migración de datos existentes'
                    ) RETURNING id
                ");
                $stmtInsCorte->execute([
                    ':ficha'     => $numFicha,
                    ':fecha_rep' => $fechaReporte,
                    ':archivo'   => 'corte_base_ficha_' . $numFicha . '.xlsx',
                    ':hash'      => $hashBase
                ]);
                $idImportacion = (int)$stmtInsCorte->fetchColumn();
            }

            // 3. Vincular los registros de matricula_resultados de esta ficha a este corte
            $stmtUpdMat = $pdo->prepare("
                UPDATE matricula_resultados mr
                SET id_importacion = :id_imp,
                    fecha_reporte  = :fecha_rep,
                    numero_ficha   = :ficha
                FROM aprendices a
                WHERE mr.num_documento_aprendiz = a.numero_documento
                  AND a.numero_ficha = :ficha
                  AND mr.id_importacion IS NULL
            ");
            $stmtUpdMat->execute([
                ':id_imp'    => $idImportacion,
                ':fecha_rep' => $fechaReporte,
                ':ficha'     => $numFicha
            ]);

            // 4. Poblar corte_aprendices para este corte
            $stmtInsCorteAp = $pdo->prepare("
                INSERT INTO corte_aprendices (id_importacion, numero_documento, id_estado)
                SELECT :id_imp, a.numero_documento, a.id_estado
                FROM aprendices a
                WHERE a.numero_ficha = :ficha
                ON CONFLICT (id_importacion, numero_documento) DO NOTHING
            ");
            $stmtInsCorteAp->execute([
                ':id_imp' => $idImportacion,
                ':ficha'  => $numFicha
            ]);

            echo "  ✓ Ficha $numFicha vinculada al corte #$idImportacion (Fecha: $fechaReporte).\n";
        }
    } else {
        echo "  ✓ Todos los registros existentes ya cuentan con id_importacion asignado.\n";
    }

    // ── PASO 4: Actualizar restricción UNIQUE en matricula_resultados ─────────────
    echo "\n[PASO 4] Ajustando restricción UNIQUE para soportar versiones históricas...\n";
    // Buscar el nombre real de cualquier restricción única que abarque exclusivamente (num_documento_aprendiz, codigo_resul)
    $stmtFindKey = $pdo->query("
        SELECT c.conname
        FROM pg_constraint c
        JOIN pg_class t ON t.oid = c.conrelid
        JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE t.relname = 'matricula_resultados'
          AND c.contype = 'u'
          AND (
              SELECT array_agg(a.attname ORDER BY k.n)
              FROM unnest(c.conkey) WITH ORDINALITY k(attnum, n)
              JOIN pg_attribute a ON a.attnum = k.attnum AND a.attrelid = t.oid
          ) = ARRAY['num_documento_aprendiz'::name, 'codigo_resul'::name]
    ");
    $oldKeyNames = $stmtFindKey->fetchAll(PDO::FETCH_COLUMN);

    foreach ($oldKeyNames as $oldKey) {
        $pdo->exec("ALTER TABLE matricula_resultados DROP CONSTRAINT IF EXISTS \"$oldKey\"");
        echo "  ✓ Restricción anterior eliminada: $oldKey\n";
    }

    // Verificar si ya existe la restricción de corte
    $stmtHasNewKey = $pdo->query("
        SELECT c.conname
        FROM pg_constraint c
        JOIN pg_class t ON t.oid = c.conrelid
        WHERE t.relname = 'matricula_resultados'
          AND c.contype = 'u'
          AND c.conname = 'matricula_resultados_corte_aprendiz_resul_key'
    ");
    if (!$stmtHasNewKey->fetchColumn()) {
        $pdo->exec("
            ALTER TABLE matricula_resultados 
            ADD CONSTRAINT matricula_resultados_corte_aprendiz_resul_key 
            UNIQUE (id_importacion, num_documento_aprendiz, codigo_resul)
        ");
        echo "  ✓ Nueva restricción UNIQUE creada: (id_importacion, num_documento_aprendiz, codigo_resul)\n";
    } else {
        echo "  ✓ La nueva restricción UNIQUE (id_importacion, num_documento_aprendiz, codigo_resul) ya existe.\n";
    }

    // ── PASO 5: Crear índices optimizados ────────────────────────────────────────
    echo "\n[PASO 5] Creando índices de optimización...\n";
    $pdo->exec("CREATE INDEX IF NOT EXISTS idx_mat_res_importacion ON matricula_resultados (id_importacion);");
    $pdo->exec("CREATE INDEX IF NOT EXISTS idx_mat_res_ficha_fecha ON matricula_resultados (numero_ficha, fecha_reporte);");
    $pdo->exec("CREATE INDEX IF NOT EXISTS idx_hist_ficha_fecha ON historial_importaciones (numero_ficha, fecha_reporte DESC);");
    $pdo->exec("CREATE INDEX IF NOT EXISTS idx_corte_ap_estado ON corte_aprendices (id_importacion, id_estado);");
    echo "  ✓ Índices idx_mat_res_importacion, idx_mat_res_ficha_fecha, idx_hist_ficha_fecha, idx_corte_ap_estado creados.\n";

    $pdo->commit();
    echo "\n═══════════════════════════════════════════════════════════════════════\n";
    echo "         MIGRACIÓN COMPLETADA SATISFACTORIAMENTE (100%)                \n";
    echo "═══════════════════════════════════════════════════════════════════════\n";

} catch (Exception $e) {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    echo "\n[ERROR CRÍTICO] La migración falló y se aplicó ROLLBACK: " . $e->getMessage() . "\n";
    exit(1);
}
