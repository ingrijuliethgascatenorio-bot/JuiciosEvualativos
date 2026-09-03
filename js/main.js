/**
 * SGJE — Dashboard Principal · main.js
 * Gestiona la carga de datos, gráficas y paginación de la tabla principal.
 */

document.addEventListener('DOMContentLoaded', () => {

    // ── Referencias DOM ───────────────────────────────────────────────────────
    const filtersForm  = document.getElementById('filtersForm');
    const uploadForm   = document.getElementById('uploadForm');
    const tbody        = document.querySelector('#dataTable tbody');
    const paginBar     = document.getElementById('tablePagination');

    // ── Estado de gráficas ────────────────────────────────────────────────────
    let chartEstadosInstance = null;
    let chartJuiciosInstance = null;

    // ── Estado de paginación ──────────────────────────────────────────────────
    const ITEMS_PER_PAGE = 10;
    let allRows    = [];
    let currentPage = 1;

    // ═════════════════════════════════════════════════════════════════════════
    // CARGA PRINCIPAL
    // ═════════════════════════════════════════════════════════════════════════
    async function loadDashboardData() {
        if (filtersForm) {
            const urlParams = new URLSearchParams(window.location.search);
            const fInput = document.getElementById('ficha');
            const eInput = document.getElementById('estado');
            const jInput = document.getElementById('juicio');

            if (urlParams.has('ficha') && fInput && !fInput.value) fInput.value = urlParams.get('ficha');
            if (urlParams.has('estado') && eInput && !eInput.value) eInput.value = urlParams.get('estado');
            if (urlParams.has('juicio') && jInput && !jInput.value) jInput.value = urlParams.get('juicio');
        }

        const params = filtersForm
            ? new URLSearchParams(new FormData(filtersForm)).toString()
            : '';

        try {
            const res  = await fetch(`api.php?action=get_dashboard&${params}`);
            const data = await res.json();

            updateStats(data);
            updateCharts(data);

            allRows     = data.tablaData || [];
            currentPage = 1;
            renderTablePage();

        } catch (err) {
            console.error('Error cargando dashboard:', err);
        }
    }

    // ═════════════════════════════════════════════════════════════════════════
    // ESTADÍSTICAS
    // ═════════════════════════════════════════════════════════════════════════
    function updateStats(data) {
        const set = (id, val) => {
            const el = document.getElementById(id);
            if (el) el.textContent = (val !== undefined && val !== null) ? val : '—';
        };
        set('totalAprendices',  data.totalAprendices ?? 0);
        set('juiciosAprobados', data.juiciosAprobados ?? 0);
        set('juiciosPorEvaluar', data.juiciosPorEvaluar ?? 0);
        
        const avance = (data.avanceGeneral !== undefined && data.avanceGeneral !== null)
            ? Number(data.avanceGeneral).toFixed(2) + '%'
            : '0%';
        set('avanceGeneral', avance);
    }

    // Guardar contexto para navegación hacia detalle.php
    window.guardarContextoDashboard = function() {
        const ctx = {
            seccionOrigen: 'index.php',
            ficha: document.getElementById('ficha')?.value || '',
            estado: document.getElementById('estado')?.value || '',
            juicio: document.getElementById('juicio')?.value || ''
        };
        sessionStorage.setItem('sgje_nav_context', JSON.stringify(ctx));
    };

    // ═════════════════════════════════════════════════════════════════════════
    // TABLA CON PAGINACIÓN
    // ═════════════════════════════════════════════════════════════════════════
    function renderTablePage() {
        if (!tbody) return;

        if (!allRows.length) {
            tbody.innerHTML = '<tr><td colspan="6" style="text-align:center;padding:40px;color:#94a3b8;">No se encontraron registros</td></tr>';
            paginBar.innerHTML = '';
            return;
        }

        const total    = allRows.length;
        const start    = (currentPage - 1) * ITEMS_PER_PAGE;
        const pageData = allRows.slice(start, start + ITEMS_PER_PAGE);

        const fVal = document.getElementById('ficha')?.value || '';
        const eVal = document.getElementById('estado')?.value || '';
        const jVal = document.getElementById('juicio')?.value || '';

        tbody.innerHTML = pageData.map(row => {
            const badge    = row.juicio === 'APROBADO' ? 'aprobado' : 'por-evaluar';
            const initials = ((row.nombres || '?')[0] + (row.apellidos || '?')[0]).toUpperCase();
            const comp     = (row.nombre_comp     || '').substring(0, 32) + (row.nombre_comp?.length     > 32 ? '...' : '');
            const result   = (row.nombre_resultado || '').substring(0, 32) + (row.nombre_resultado?.length > 32 ? '...' : '');

            const queryParams = new URLSearchParams({
                documento: row.numero_documento,
                from: 'index.php',
                ...(fVal ? { ficha: fVal } : {}),
                ...(eVal ? { estado: eVal } : {}),
                ...(jVal ? { juicio: jVal } : {})
            }).toString();

            return `
            <tr>
                <td>
                    <div class="table-avatar-wrap">
                        <div class="table-avatar">
                            ${initials}
                        </div>
                        <div class="table-user-info">
                            <div class="table-user-name">${row.nombres} ${row.apellidos}</div>
                            <div class="table-user-sub">${row.numero_documento}</div>
                        </div>
                    </div>
                </td>
                <td style="font-weight: 500;">${row.numero_ficha}</td>
                <td title="${row.nombre_comp || ''}">${comp}</td>
                <td title="${row.nombre_resultado || ''}">${result}</td>
                <td><span class="badge ${badge}">${row.juicio || 'N/A'}</span></td>
                <td>
                    <a href="detalle.php?${queryParams}" onclick="guardarContextoDashboard()" class="table-link">
                        Ver Perfil
                    </a>
                </td>
            </tr>`;
        }).join('');

        renderPagination(total);
    }

    function renderPagination(total) {
        if (!paginBar) return;
        if (total <= ITEMS_PER_PAGE) { paginBar.innerHTML = ''; return; }

        const totalPages = Math.ceil(total / ITEMS_PER_PAGE);
        let startPage    = Math.max(1, currentPage - 2);
        let endPage      = Math.min(totalPages, startPage + 4);
        if (endPage - startPage < 4) startPage = Math.max(1, endPage - 4);

        let html = `<button class="page-btn" ${currentPage === 1 ? 'disabled' : ''} 
                        onclick="dashGoTo(${currentPage - 1})">&#8249;</button>`;

        for (let i = startPage; i <= endPage; i++) {
            html += `<button class="page-btn ${currentPage === i ? 'active' : ''}"
                         onclick="dashGoTo(${i})">${i}</button>`;
        }

        html += `<button class="page-btn" ${currentPage === totalPages ? 'disabled' : ''} 
                     onclick="dashGoTo(${currentPage + 1})">&#8250;</button>`;

        const from = (currentPage - 1) * ITEMS_PER_PAGE + 1;
        const to   = Math.min(currentPage * ITEMS_PER_PAGE, total);
        html += `<span class="page-info">${from}-${to} de ${total}</span>`;

        paginBar.innerHTML = html;
    }

    // Función global para los botones de paginación generados dinámicamente
    window.dashGoTo = function (page) {
        currentPage = page;
        renderTablePage();
    };

    // ═════════════════════════════════════════════════════════════════════════
    // GRÁFICAS
    // ═════════════════════════════════════════════════════════════════════════
    function updateCharts(data) {
        const canvasE = document.getElementById('chartEstados');
        const canvasJ = document.getElementById('chartJuicios');
        if (!canvasE || !canvasJ) return;

        if (typeof Chart === 'undefined') {
            console.warn('Chart.js no está disponible.');
            return;
        }

        try {
            const estados = Array.isArray(data.estadosData) ? data.estadosData : [];
            const labelsEstados = estados.map(e => e.nombre);
            const dataEstados = estados.map(e => Number(e.count || 0));
            const tieneDatosEstados = dataEstados.some(v => v > 0);

            if (chartEstadosInstance) chartEstadosInstance.destroy();
            chartEstadosInstance = new Chart(canvasE.getContext('2d'), {
                type: 'doughnut',
                data: {
                    labels: tieneDatosEstados ? labelsEstados : ['Sin datos'],
                    datasets: [{
                        data: tieneDatosEstados ? dataEstados : [1],
                        backgroundColor: tieneDatosEstados 
                            ? ['#2563eb', '#059669', '#d97706', '#dc2626', '#7c3aed', '#0284c7', '#9333ea'] 
                            : ['#e2e8f0'],
                        borderWidth: 0
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    cutout: '75%',
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: { boxWidth: 10, usePointStyle: true, font: { family: 'Outfit', size: 11 } }
                        },
                        tooltip: {
                            enabled: tieneDatosEstados
                        }
                    }
                }
            });

            const aprobados = Number(data.juiciosAprobados) || 0;
            const pendientes = Number(data.juiciosPorEvaluar) || 0;

            if (chartJuiciosInstance) chartJuiciosInstance.destroy();
            chartJuiciosInstance = new Chart(canvasJ.getContext('2d'), {
                type: 'bar',
                data: {
                    labels: ['Aprobados', 'Pendientes'],
                    datasets: [{
                        data: [aprobados, pendientes],
                        backgroundColor: ['#059669', '#d97706'],
                        borderRadius: 8
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: { beginAtZero: true, grid: { display: false } },
                        x: { grid: { display: false } }
                    }
                }
            });

        } catch (e) {
            console.error('Error gráficas:', e);
        }
    }

    // ═════════════════════════════════════════════════════════════════════════
    // EVENTOS
    // ═════════════════════════════════════════════════════════════════════════
    if (filtersForm) {
        filtersForm.addEventListener('submit', e => {
            e.preventDefault();
            currentPage = 1;
            loadDashboardData();
        });
    }

    if (uploadForm) {
        uploadForm.addEventListener('submit', async e => {
            e.preventDefault();
            const fileInput = document.getElementById('archivo');
            if (!fileInput || !fileInput.files.length) {
                Swal.fire('Atención', 'Por favor selecciona un archivo de reporte.', 'warning');
                return;
            }

            Swal.fire({ 
                title: 'Procesando archivo...', 
                html: 'Analizando información, detectando fechas y sincronizando juicios evaluativos...',
                allowOutsideClick: false, 
                didOpen: () => Swal.showLoading() 
            });

            try {
                const res    = await fetch('upload.php', { method: 'POST', body: new FormData(uploadForm) });
                const result = await res.json();
                
                if (result.success) {
                    if (result.duplicado_archivo) {
                        Swal.fire({
                            icon: 'info',
                            title: 'Archivo ya importado',
                            html: `
                                <p style="margin-bottom: 12px; color: #475569;">Este archivo ya fue importado exitosamente. No se realizaron cambios redundantes.</p>
                                <div style="text-align: left; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 12px; font-size: 13px;">
                                    <div><strong>Ficha:</strong> ${result.resumen?.ficha || '—'}</div>
                                    <div><strong>Fecha de corte:</strong> ${result.resumen?.fecha_reporte || '—'}</div>
                                    <div><strong>Filas en reporte:</strong> ${result.resumen?.total_filas || 0}</div>
                                </div>
                            `
                        });
                    } else {
                        const r = result.resumen || {};
                        const esHistorico = result.modo === 'SELECTIVO_HISTÓRICO';
                        const badgeModo = esHistorico 
                            ? '<span style="background:#fef3c7;color:#92400e;padding:2px 8px;border-radius:6px;font-size:12px;font-weight:600;">SELECTIVO HISTÓRICO</span>'
                            : '<span style="background:#dcfce7;color:#166534;padding:2px 8px;border-radius:6px;font-size:12px;font-weight:600;">ESTÁNDAR</span>';
                        
                        let avisoHistorico = esHistorico
                            ? `<div style="background:#fffbeb;border:1px solid #fef3c7;color:#92400e;padding:10px;border-radius:8px;margin-bottom:12px;font-size:12px;text-align:left;">
                                 ⚠️ <strong>Atención:</strong> El archivo tiene una fecha anterior a la última registrada en la ficha. Se procesó de forma selectiva y no destructiva, protegiendo registros más recientes.
                               </div>`
                            : '';

                        let avisoConflictos = (r.conflictos > 0)
                            ? `<div style="background:#fee2e2;border:1px solid #fca5a5;color:#991b1b;padding:8px;border-radius:6px;margin-top:10px;font-size:12px;text-align:left;">
                                 ⚠️ <strong>Conflictos detectados:</strong> ${r.conflictos} fila(s) correspondían a aprendices asociados a otra ficha y no fueron reasignados.
                               </div>`
                            : '';

                        Swal.fire({
                            icon: esHistorico ? 'warning' : 'success',
                            title: esHistorico ? 'Procesado Selectivo' : 'Importación Exitosa',
                            html: `
                                ${avisoHistorico}
                                <div style="text-align: left; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 14px; font-size: 13px; line-height: 1.6;">
                                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;border-bottom:1px solid #e2e8f0;padding-bottom:6px;">
                                        <span><strong>Ficha:</strong> ${r.ficha || '—'}</span>
                                        ${badgeModo}
                                    </div>
                                    <div><strong>Fecha del Reporte:</strong> ${r.fecha_reporte || '—'}</div>
                                    <div><strong>Total Procesados:</strong> ${r.total_filas || 0}</div>
                                    <hr style="border:none;border-top:1px dashed #cbd5e1;margin:8px 0;">
                                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:6px;">
                                        <div>🟢 <strong>Nuevos:</strong> ${r.nuevos || 0}</div>
                                        <div>🔵 <strong>Actualizados:</strong> ${r.actualizados || 0}</div>
                                        <div>⚪ <strong>Sin cambios:</strong> ${r.sin_cambios || 0}</div>
                                        <div>🟡 <strong>Omitidos:</strong> ${r.omitidos || 0}</div>
                                    </div>
                                    ${(r.conflictos > 0) ? `<div style="margin-top:4px;color:#dc2626;">🔴 <strong>Conflictos:</strong> ${r.conflictos}</div>` : ''}
                                    <div style="margin-top:8px;padding-top:6px;border-top:1px solid #e2e8f0;">
                                        <strong>Avance General Ficha:</strong> <span style="font-weight:700;color:#2563eb;">${r.avance_general || '—'}</span>
                                    </div>
                                </div>
                                ${avisoConflictos}
                            `
                        });
                    }

                    // Limpiar input file
                    uploadForm.reset();
                    const fileLabel = document.getElementById('fileLabel');
                    if (fileLabel) fileLabel.textContent = 'Seleccionar reporte';

                    loadDashboardData();
                } else {
                    Swal.fire('Error', result.message || 'Error al procesar el archivo.', 'error');
                }
            } catch (err) {
                Swal.fire('Error', 'Error de conexión o fallo interno del servidor.', 'error');
            }
        });
    }

    // ── Inicio ────────────────────────────────────────────────────────────────
    loadDashboardData();
});