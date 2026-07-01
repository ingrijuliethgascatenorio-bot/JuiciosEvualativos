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
            if (el) el.textContent = val;
        };
        set('totalAprendices',  data.totalAprendices);
        set('juiciosAprobados', data.juiciosAprobados);
        set('juiciosPorEvaluar', data.juiciosPorEvaluar);
        set('avanceGeneral',    data.avanceGeneral + '%');
    }

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

        tbody.innerHTML = pageData.map(row => {
            const badge    = row.juicio === 'APROBADO' ? 'aprobado' : 'por-evaluar';
            const initials = ((row.nombres || '?')[0] + (row.apellidos || '?')[0]).toUpperCase();
            const comp     = (row.nombre_comp     || '').substring(0, 32) + (row.nombre_comp?.length     > 32 ? '...' : '');
            const result   = (row.nombre_resultado || '').substring(0, 32) + (row.nombre_resultado?.length > 32 ? '...' : '');

            return `
            <tr>
                <td>
                    <div style="display:flex;align-items:center;gap:12px;">
                        <div style="width:34px;height:34px;border-radius:50%;background:#eff6ff;color:#2563eb;
                            display:flex;align-items:center;justify-content:center;font-weight:700;font-size:11px;flex-shrink:0;">
                            ${initials}
                        </div>
                        <div>
                            <div style="font-weight:600;color:#0f172a;">${row.nombres} ${row.apellidos}</div>
                            <div style="font-size:11px;color:#94a3b8;font-family:monospace;">${row.numero_documento}</div>
                        </div>
                    </div>
                </td>
                <td style="font-weight:500;">${row.numero_ficha}</td>
                <td title="${row.nombre_comp || ''}">${comp}</td>
                <td title="${row.nombre_resultado || ''}">${result}</td>
                <td><span class="badge ${badge}">${row.juicio || 'N/A'}</span></td>
                <td>
                    <a href="detalle.php?documento=${row.numero_documento}"
                       style="color:#2563eb;font-weight:600;text-decoration:none;font-size:12px;">
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

        try {
            if (chartEstadosInstance) chartEstadosInstance.destroy();
            chartEstadosInstance = new Chart(canvasE.getContext('2d'), {
                type: 'doughnut',
                data: {
                    labels: data.estadosData.map(e => e.nombre),
                    datasets: [{
                        data: data.estadosData.map(e => Number(e.count)),
                        backgroundColor: ['#2563eb', '#059669', '#d97706', '#dc2626', '#7c3aed'],
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
                        }
                    }
                }
            });

            if (chartJuiciosInstance) chartJuiciosInstance.destroy();
            chartJuiciosInstance = new Chart(canvasJ.getContext('2d'), {
                type: 'bar',
                data: {
                    labels: ['Aprobados', 'Pendientes'],
                    datasets: [{
                        data: [Number(data.juiciosAprobados), Number(data.juiciosPorEvaluar)],
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
            Swal.fire({ title: 'Actualizando base de datos...', allowOutsideClick: false, didOpen: () => Swal.showLoading() });
            try {
                const res    = await fetch('upload.php', { method: 'POST', body: new FormData(uploadForm) });
                const result = await res.json();
                if (result.success) {
                    Swal.fire('Actualizado', result.message, 'success');
                    loadDashboardData();
                } else {
                    Swal.fire('Error', result.message, 'error');
                }
            } catch (err) {
                Swal.fire('Error', 'Error de conexión', 'error');
            }
        });
    }

    // ── Inicio ────────────────────────────────────────────────────────────────
    loadDashboardData();
});