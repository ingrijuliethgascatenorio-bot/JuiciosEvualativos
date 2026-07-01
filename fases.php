<?php require 'db.php'; ?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SGJE — Fases del Proyecto Formativo</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --bg: #f1f5f9;
            --sidebar-bg: #0f172a;
            --primary: #2563eb;
            --primary-light: #eff6ff;
            --border: #e2e8f0;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --radius: 12px;
            --card-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
            --success: #059669;
            --success-light: #ecfdf5;
            --warning: #d97706;
            --warning-light: #fffbeb;
        }
        body { font-family: 'Outfit', sans-serif; background: var(--bg); display: flex; min-height: 100vh; color: var(--text-main); }

        /* ── Sidebar ── */
        .sidebar { width: 260px; background: var(--sidebar-bg); color: #fff; position: fixed; height: 100vh; display: flex; flex-direction: column; z-index: 1000; }
        .sidebar-header { padding: 32px 24px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid #1e293b; margin-bottom: 12px; }
        .logo-box { width: 36px; height: 36px; background: var(--primary); border-radius: 8px; display: flex; align-items: center; justify-content: center; color: #fff; }
        .brand-name { font-weight: 700; font-size: 20px; letter-spacing: -0.5px; color: #f8fafc; }
        .nav-label { font-size: 11px; font-weight: 600; color: #475569; text-transform: uppercase; letter-spacing: 0.1em; padding: 24px 24px 12px; }
        .nav-item { display: flex; align-items: center; gap: 12px; padding: 14px 24px; color: #94a3b8; text-decoration: none; font-weight: 500; transition: all 0.3s; margin: 0 12px; border-radius: 12px; }
        .nav-item:hover { background: #1e293b; color: #fff; }
        .nav-item.active { background: var(--primary); color: #fff; box-shadow: 0 4px 6px -1px rgba(37,99,235,0.2); }
        .nav-item i { width: 18px; height: 18px; }

        /* ── Layout ── */
        .main-content { flex: 1; margin-left: 260px; display: flex; flex-direction: column; }
        .topbar { background: #fff; padding: 24px 40px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 900; }
        .topbar h1 { font-size: 22px; font-weight: 700; color: var(--text-main); }
        .container { padding: 40px; width: 100%; max-width: 1400px; margin: 0 auto; display: flex; flex-direction: column; gap: 32px; }

        /* ── Cards ── */
        .card { background: #fff; border-radius: var(--radius); border: 1px solid var(--border); box-shadow: var(--card-shadow); }
        .card-header { padding: 16px 24px; border-bottom: 1px solid var(--border); font-weight: 600; font-size: 14px; color: var(--text-main); display: flex; align-items: center; justify-content: space-between; gap: 8px; }
        .card-header-left { display: flex; align-items: center; gap: 8px; }
        .card-body { padding: 24px; }

        /* ── Filters ── */
        .filters-row { display: flex; gap: 16px; align-items: flex-end; flex-wrap: wrap; }
        .fg { display: flex; flex-direction: column; gap: 6px; }
        .fg label { font-size: 11px; font-weight: 700; color: #94a3b8; text-transform: uppercase; }
        .form-control { border: 1.5px solid var(--border); padding: 10px 14px; border-radius: 10px; font-family: inherit; font-size: 14px; outline: none; transition: border-color 0.2s; min-width: 180px; }
        .form-control:focus { border-color: var(--primary); }

        /* ── Buttons ── */
        .btn { padding: 10px 20px; border-radius: 10px; border: none; font-weight: 700; cursor: pointer; font-family: inherit; font-size: 13px; display: inline-flex; align-items: center; gap: 7px; transition: all 0.2s; }
        .btn-primary { background: var(--primary); color: #fff; }
        .btn-primary:hover { background: #1d4ed8; }
        .btn-success { background: var(--success); color: #fff; }
        .btn-success:hover { background: #047857; }
        .btn-outline { background: #fff; color: var(--text-main); border: 1.5px solid var(--border); }
        .btn-outline:hover { background: #f8fafc; }
        .btn-danger { background: #fee2e2; color: #991b1b; }
        .btn-danger:hover { background: #fecaca; }
        .btn-sm { padding: 6px 12px; font-size: 12px; }
        .btn-icon { padding: 7px; border-radius: 8px; border: 1.5px solid var(--border); background: #fff; cursor: pointer; color: var(--text-muted); display: inline-flex; align-items: center; justify-content: center; transition: all 0.2s; }
        .btn-icon:hover { background: #f1f5f9; color: var(--primary); border-color: var(--primary); }
        .btn-icon.danger:hover { background: #fee2e2; color: #dc2626; border-color: #dc2626; }

        /* ── Fase cards ── */
        .fases-list { display: flex; flex-direction: column; gap: 20px; }
        .fase-card { background: #fff; border-radius: var(--radius); border: 1px solid var(--border); box-shadow: var(--card-shadow); overflow: hidden; transition: all 0.3s; border-left: 4px solid var(--primary); }
        .fase-card:hover { box-shadow: 0 8px 20px -4px rgba(0,0,0,0.12); }
        .fase-header { padding: 20px 24px; display: flex; align-items: center; justify-content: space-between; gap: 12px; cursor: pointer; }
        .fase-header-left { display: flex; align-items: center; gap: 14px; }
        .fase-badge { width: 34px; height: 34px; background: var(--primary-light); color: var(--primary); border-radius: 10px; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 14px; flex-shrink: 0; }
        .fase-title { font-weight: 700; font-size: 15px; color: var(--text-main); }
        .fase-desc { font-size: 12px; color: var(--text-muted); margin-top: 2px; }
        .fase-actions { display: flex; align-items: center; gap: 8px; }
        .fase-pill { font-size: 11px; background: #f1f5f9; color: #475569; padding: 5px 12px; border-radius: 99px; font-weight: 700; border: 1px solid var(--border); white-space: nowrap; }

        /* ── Actividades dentro de fase ── */
        .actividades-body { border-top: 1px solid var(--border); padding: 16px 24px 20px; background: #fafbff; }
        .actividad-item { background: #fff; border: 1px solid var(--border); border-radius: 10px; padding: 14px 18px; margin-bottom: 12px; }
        .actividad-item:last-child { margin-bottom: 0; }
        .actividad-header { display: flex; align-items: center; justify-content: space-between; gap: 10px; }
        .actividad-title { font-weight: 600; font-size: 13.5px; color: var(--text-main); }
        .actividad-desc { font-size: 12px; color: var(--text-muted); margin-top: 3px; }
        .actividad-actions { display: flex; align-items: center; gap: 6px; }

        /* ── Resultados vinculados ── */
        .resultados-vinculados { margin-top: 12px; padding-top: 12px; border-top: 1px dashed var(--border); }
        .rv-title { font-size: 11px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; margin-bottom: 8px; }
        .rv-chips { display: flex; flex-wrap: wrap; gap: 6px; }
        .rv-chip { font-size: 11px; background: var(--primary-light); color: var(--primary); padding: 4px 10px; border-radius: 99px; font-weight: 600; border: 1px solid #bfdbfe; display: flex; align-items: center; gap: 5px; }
        .rv-chip button { background: none; border: none; cursor: pointer; color: #93c5fd; padding: 0; display: flex; align-items: center; font-size: 12px; transition: color 0.2s; }
        .rv-chip button:hover { color: #1d4ed8; }
        .no-results { font-size: 12px; color: #94a3b8; font-style: italic; }

        /* ── Add buttons inside fase ── */
        .add-actividad-btn { width: 100%; padding: 10px; border: 1.5px dashed #cbd5e1; border-radius: 10px; background: none; color: #94a3b8; font-family: inherit; font-size: 13px; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 7px; transition: all 0.2s; margin-top: 4px; }
        .add-actividad-btn:hover { border-color: var(--primary); color: var(--primary); background: var(--primary-light); }

        /* ── Modal ── */
        .modal-backdrop { position: fixed; inset: 0; background: rgba(15,23,42,0.45); z-index: 2000; display: none; align-items: center; justify-content: center; }
        .modal-backdrop.open { display: flex; }
        .modal { background: #fff; border-radius: 16px; width: 100%; max-width: 560px; box-shadow: 0 25px 50px -12px rgba(0,0,0,0.25); animation: modalIn 0.25s ease; overflow: hidden; }
        @keyframes modalIn { from { opacity:0; transform: scale(0.95) translateY(-8px); } to { opacity:1; transform: scale(1) translateY(0); } }
        .modal-header { padding: 20px 24px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; }
        .modal-title { font-weight: 700; font-size: 16px; color: var(--text-main); }
        .modal-close { background: none; border: none; cursor: pointer; color: var(--text-muted); padding: 4px; border-radius: 6px; display: flex; }
        .modal-close:hover { color: var(--text-main); background: #f1f5f9; }
        .modal-body { padding: 24px; display: flex; flex-direction: column; gap: 16px; }
        .modal-footer { padding: 16px 24px; border-top: 1px solid var(--border); display: flex; gap: 10px; justify-content: flex-end; }
        .field-group { display: flex; flex-direction: column; gap: 6px; }
        .field-group label { font-size: 12px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; }
        .field-group input, .field-group textarea, .field-group select { border: 1.5px solid var(--border); padding: 10px 14px; border-radius: 10px; font-family: inherit; font-size: 14px; outline: none; transition: border-color 0.2s; resize: vertical; }
        .field-group input:focus, .field-group textarea:focus, .field-group select:focus { border-color: var(--primary); }

        /* ── Empty state ── */
        .empty-state { text-align: center; padding: 60px 24px; color: var(--text-muted); }
        .empty-state i { width: 48px; height: 48px; margin-bottom: 16px; opacity: 0.3; }
        .empty-state p { font-size: 14px; margin-bottom: 20px; }

        /* ── Progress bar ── */
        .progress-box { display: flex; align-items: center; gap: 10px; }
        .progress-bar { flex: 1; height: 6px; background: #f1f5f9; border-radius: 99px; overflow: hidden; min-width: 80px; }
        .progress-fill { height: 100%; background: linear-gradient(90deg, var(--primary), #60a5fa); transition: width 0.8s ease; }
        .progress-pct { font-size: 12px; font-weight: 700; color: var(--primary); min-width: 36px; }

        @media (max-width: 1024px) {
            .sidebar { width: 80px; }
            .brand-name, .nav-item span:last-child, .nav-label { display: none; }
            .main-content { margin-left: 80px; }
        }
    </style>
</head>
<body>

<aside class="sidebar">
    <div class="sidebar-header">
        <div class="logo-box"><i data-lucide="bar-chart-3"></i></div>
        <span class="brand-name">SGJE</span>
    </div>
    <nav class="sidebar-nav">
        <div class="nav-label">Menú Principal</div>
        <a href="index.php" class="nav-item"><i data-lucide="layout-dashboard"></i> <span>Dashboard</span></a>
        <a href="aprendices.php" class="nav-item"><i data-lucide="users"></i> <span>Aprendices</span></a>
        <a href="analisis.php" class="nav-item"><i data-lucide="search"></i> <span>Análisis Proyecto</span></a>
        <a href="analytics.php" class="nav-item"><i data-lucide="brain-circuit"></i> <span>Inteligencia</span></a>
        <a href="alertas.php" class="nav-item"><i data-lucide="bell-ring"></i> <span>Alertas</span></a>
        <div class="nav-label">Sistema</div>
        <a href="#" onclick="confirmReset()" class="nav-item" style="color: #ef4444;"><i data-lucide="trash-2"></i> <span>Limpiar Todo</span></a>
    </nav>
</aside>

<div class="main-content">
    <div class="topbar">
        <h1><i data-lucide="layers" style="width:20px;height:20px;display:inline;vertical-align:middle;margin-right:8px;"></i>Fases del Proyecto Formativo</h1>
        <button class="btn btn-primary" onclick="openModalFase()">
            <i data-lucide="plus" style="width:15px;height:15px;"></i> Nueva Fase
        </button>
    </div>

    <div class="container">

        <!-- Filtro programa -->
        <div class="card">
            <div class="card-body">
                <div class="filters-row">
                    <div class="fg">
                        <label>Programa</label>
                        <select class="form-control" id="selectPrograma" onchange="loadFases()">
                            <option value="">— Todos los programas —</option>
                        </select>
                    </div>
                    <div style="margin-left:auto; display:flex; align-items:center; gap:8px;">
                        <span id="statFases" style="font-size:13px; color:var(--text-muted);"></span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Lista de fases -->
        <div id="fasesList" class="fases-list">
            <div class="empty-state">
                <i data-lucide="layers"></i>
                <p>Cargando fases...</p>
            </div>
        </div>

    </div>
</div>

<!-- ── Modal: Crear/Editar Fase ── -->
<div class="modal-backdrop" id="modalFase">
    <div class="modal">
        <div class="modal-header">
            <span class="modal-title" id="modalFaseTitulo">Nueva Fase</span>
            <button class="modal-close" onclick="closeModal('modalFase')"><i data-lucide="x" style="width:18px;height:18px;"></i></button>
        </div>
        <div class="modal-body">
            <input type="hidden" id="faseId">
            <div class="field-group">
                <label>Programa *</label>
                <select class="form-control" id="faseProgramaId" required></select>
            </div>
            <div class="field-group">
                <label>Nombre de la fase *</label>
                <input type="text" id="faseNombre" placeholder="Ej: Fase 1 – Diagnóstico" required>
            </div>
            <div class="field-group">
                <label>Descripción</label>
                <textarea id="faseDescripcion" rows="2" placeholder="Descripción opcional de la fase..."></textarea>
            </div>
            <div class="field-group">
                <label>Orden</label>
                <input type="number" id="faseOrden" value="1" min="1">
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn btn-outline" onclick="closeModal('modalFase')">Cancelar</button>
            <button class="btn btn-primary" onclick="saveFase()"><i data-lucide="save" style="width:14px;height:14px;"></i> Guardar</button>
        </div>
    </div>
</div>

<!-- ── Modal: Crear/Editar Actividad ── -->
<div class="modal-backdrop" id="modalActividad">
    <div class="modal">
        <div class="modal-header">
            <span class="modal-title" id="modalActTitulo">Nueva Actividad</span>
            <button class="modal-close" onclick="closeModal('modalActividad')"><i data-lucide="x" style="width:18px;height:18px;"></i></button>
        </div>
        <div class="modal-body">
            <input type="hidden" id="actividadId">
            <input type="hidden" id="actividadFaseId">
            <div class="field-group">
                <label>Nombre de la actividad *</label>
                <input type="text" id="actNombre" placeholder="Ej: Actividad 1 – Levantamiento de información" required>
            </div>
            <div class="field-group">
                <label>Descripción</label>
                <textarea id="actDescripcion" rows="2" placeholder="Descripción opcional..."></textarea>
            </div>
            <div class="field-group">
                <label>Orden</label>
                <input type="number" id="actOrden" value="1" min="1">
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn btn-outline" onclick="closeModal('modalActividad')">Cancelar</button>
            <button class="btn btn-primary" onclick="saveActividad()"><i data-lucide="save" style="width:14px;height:14px;"></i> Guardar</button>
        </div>
    </div>
</div>

<!-- ── Modal: Vincular Resultados ── -->
<div class="modal-backdrop" id="modalVincular">
    <div class="modal" style="max-width:640px;">
        <div class="modal-header">
            <span class="modal-title">Vincular Resultados de Aprendizaje</span>
            <button class="modal-close" onclick="closeModal('modalVincular')"><i data-lucide="x" style="width:18px;height:18px;"></i></button>
        </div>
        <div class="modal-body" style="max-height:420px; overflow-y:auto;" id="modalVincularBody">
            Cargando...
        </div>
        <div class="modal-footer">
            <button class="btn btn-outline" onclick="closeModal('modalVincular')">Cerrar</button>
            <button class="btn btn-success" onclick="saveVinculos()"><i data-lucide="link" style="width:14px;height:14px;"></i> Guardar Vínculos</button>
        </div>
    </div>
</div>

<script>
let currentVinculoActividadId = null;
let currentVinculoProgramaId = null;
let programas = [];

// ── Bootstrap ──
document.addEventListener('DOMContentLoaded', () => {
    loadProgramas();
    lucide.createIcons();
});

async function loadProgramas() {
    const res = await fetch('api_fases.php?action=get_programas').then(r => r.json());
    programas = res;
    const sel = document.getElementById('selectPrograma');
    const selFase = document.getElementById('faseProgramaId');
    sel.innerHTML = '<option value="">— Todos los programas —</option>';
    selFase.innerHTML = '<option value="">Seleccione un programa</option>';
    res.forEach(p => {
        sel.innerHTML += `<option value="${p.codigo_programa}">${p.nombre_programa}</option>`;
        selFase.innerHTML += `<option value="${p.codigo_programa}">${p.nombre_programa}</option>`;
    });
    loadFases();
}

async function loadFases() {
    const programa = document.getElementById('selectPrograma').value;
    const url = `api_fases.php?action=get_fases${programa ? '&programa='+programa : ''}`;
    const fases = await fetch(url).then(r => r.json());

    const container = document.getElementById('fasesList');
    document.getElementById('statFases').textContent = `${fases.length} fase${fases.length !== 1 ? 's' : ''}`;

    if (!fases.length) {
        container.innerHTML = `<div class="empty-state">
            <i data-lucide="layers"></i>
            <p>No hay fases creadas aún. Haz clic en <strong>Nueva Fase</strong> para comenzar.</p>
        </div>`;
        lucide.createIcons();
        return;
    }

    container.innerHTML = fases.map(fase => renderFase(fase)).join('');
    lucide.createIcons();
}

function renderFase(fase) {
    const totalActs = fase.actividades ? fase.actividades.length : 0;
    const totalAprobados = fase.actividades ? fase.actividades.reduce((s, a) => s + (a.stats ? parseInt(a.stats.aprobados) : 0), 0) : 0;
    const totalResultados = fase.actividades ? fase.actividades.reduce((s, a) => s + (a.resultados ? a.resultados.length : 0), 0) : 0;
    const totalAprendices = fase.stats ? parseInt(fase.stats.total_aprendices) : 0;
    const pct = totalResultados > 0 ? Math.round((totalAprobados / Math.max(totalResultados, 1)) * 100) : 0;

    let actsHtml = '';
    if (fase.actividades && fase.actividades.length > 0) {
        actsHtml = fase.actividades.map(act => renderActividad(act, fase)).join('');
    }

    return `
    <div class="fase-card" id="fase-${fase.id_fase}">
        <div class="fase-header" onclick="toggleFase(${fase.id_fase})">
            <div class="fase-header-left">
                <div class="fase-badge">${fase.orden}</div>
                <div>
                    <div class="fase-title">${escHtml(fase.nombre_fase)}</div>
                    ${fase.descripcion ? `<div class="fase-desc">${escHtml(fase.descripcion)}</div>` : ''}
                </div>
            </div>
            <div class="fase-actions">
                <div class="progress-box" style="min-width:160px;">
                    <div class="progress-bar"><div class="progress-fill" style="width:${pct}%"></div></div>
                    <span class="progress-pct">${pct}%</span>
                </div>
                <span class="fase-pill">${totalActs} actividad${totalActs !== 1 ? 'es' : ''}</span>
                <button class="btn-icon" onclick="event.stopPropagation(); openModalFase(${JSON.stringify(fase).replace(/"/g,'&quot;')})" title="Editar fase">
                    <i data-lucide="pencil" style="width:14px;height:14px;"></i>
                </button>
                <button class="btn-icon danger" onclick="event.stopPropagation(); deleteFase(${fase.id_fase})" title="Eliminar fase">
                    <i data-lucide="trash-2" style="width:14px;height:14px;"></i>
                </button>
                <i data-lucide="chevron-down" style="width:16px;height:16px;color:var(--text-muted);" id="chevron-${fase.id_fase}"></i>
            </div>
        </div>
        <div class="actividades-body" id="acts-${fase.id_fase}" style="display:none;">
            ${actsHtml}
            <button class="add-actividad-btn" onclick="openModalActividad(${fase.id_fase})">
                <i data-lucide="plus-circle" style="width:15px;height:15px;"></i> Agregar Actividad
            </button>
        </div>
    </div>`;
}

function renderActividad(act, fase) {
    const chips = act.resultados && act.resultados.length > 0
        ? act.resultados.map(r => `
            <div class="rv-chip">
                <span>${escHtml(r.nombre_resultado.substring(0, 60))}${r.nombre_resultado.length > 60 ? '…' : ''}</span>
                <button onclick="desvincularResultado(${act.id_actividad}, ${r.codigo_resul})" title="Quitar vínculo">
                    <i data-lucide="x" style="width:11px;height:11px;"></i>
                </button>
            </div>`).join('')
        : `<span class="no-results">Sin resultados vinculados</span>`;

    return `
    <div class="actividad-item" id="act-${act.id_actividad}">
        <div class="actividad-header">
            <div>
                <div class="actividad-title">${escHtml(act.nombre_actividad)}</div>
                ${act.descripcion ? `<div class="actividad-desc">${escHtml(act.descripcion)}</div>` : ''}
            </div>
            <div class="actividad-actions">
                <button class="btn btn-outline btn-sm" onclick="openModalVincular(${act.id_actividad}, ${fase.codigo_programa})">
                    <i data-lucide="link" style="width:13px;height:13px;"></i> Vincular
                </button>
                <button class="btn-icon" onclick="openModalActividad(${fase.id_fase}, ${JSON.stringify(act).replace(/"/g,'&quot;')})" title="Editar actividad">
                    <i data-lucide="pencil" style="width:13px;height:13px;"></i>
                </button>
                <button class="btn-icon danger" onclick="deleteActividad(${act.id_actividad})" title="Eliminar actividad">
                    <i data-lucide="trash-2" style="width:13px;height:13px;"></i>
                </button>
            </div>
        </div>
        <div class="resultados-vinculados">
            <div class="rv-title">Resultados de aprendizaje vinculados</div>
            <div class="rv-chips">${chips}</div>
        </div>
    </div>`;
}

// ── Expandir/colapsar fase ──
function toggleFase(id) {
    const body = document.getElementById(`acts-${id}`);
    const chevron = document.getElementById(`chevron-${id}`);
    const open = body.style.display !== 'none';
    body.style.display = open ? 'none' : 'block';
    chevron.style.transform = open ? '' : 'rotate(180deg)';
    lucide.createIcons();
}

// ── Modal Fase ──
function openModalFase(fase = null) {
    document.getElementById('faseId').value = fase ? fase.id_fase : '';
    document.getElementById('faseNombre').value = fase ? fase.nombre_fase : '';
    document.getElementById('faseDescripcion').value = fase ? (fase.descripcion || '') : '';
    document.getElementById('faseOrden').value = fase ? fase.orden : 1;
    document.getElementById('faseProgramaId').value = fase ? fase.codigo_programa : '';
    document.getElementById('modalFaseTitulo').textContent = fase ? 'Editar Fase' : 'Nueva Fase';
    document.getElementById('modalFase').classList.add('open');
    lucide.createIcons();
}

async function saveFase() {
    const id = document.getElementById('faseId').value;
    const nombre = document.getElementById('faseNombre').value.trim();
    const desc = document.getElementById('faseDescripcion').value.trim();
    const orden = document.getElementById('faseOrden').value;
    const programa = document.getElementById('faseProgramaId').value;

    if (!nombre || !programa) { Swal.fire('Atención', 'El nombre y el programa son obligatorios.', 'warning'); return; }

    const body = new FormData();
    body.append('action', id ? 'update_fase' : 'create_fase');
    if (id) body.append('id_fase', id);
    body.append('nombre_fase', nombre);
    body.append('descripcion', desc);
    body.append('orden', orden);
    body.append('codigo_programa', programa);

    const res = await fetch('api_fases.php', { method: 'POST', body }).then(r => r.json());
    if (res.success) {
        closeModal('modalFase');
        loadFases();
        Swal.fire({ icon: 'success', title: 'Guardado', text: res.message, timer: 1800, showConfirmButton: false });
    } else {
        Swal.fire('Error', res.message, 'error');
    }
}

async function deleteFase(id) {
    const conf = await Swal.fire({ title: '¿Eliminar fase?', text: 'Se eliminarán también todas sus actividades y vínculos.', icon: 'warning', showCancelButton: true, confirmButtonText: 'Sí, eliminar', cancelButtonText: 'Cancelar', confirmButtonColor: '#dc2626' });
    if (!conf.isConfirmed) return;
    const res = await fetch(`api_fases.php?action=delete_fase&id_fase=${id}`).then(r => r.json());
    if (res.success) { loadFases(); Swal.fire({ icon: 'success', title: 'Eliminado', timer: 1500, showConfirmButton: false }); }
    else Swal.fire('Error', res.message, 'error');
}

// ── Modal Actividad ──
function openModalActividad(idFase, act = null) {
    document.getElementById('actividadFaseId').value = idFase;
    document.getElementById('actividadId').value = act ? act.id_actividad : '';
    document.getElementById('actNombre').value = act ? act.nombre_actividad : '';
    document.getElementById('actDescripcion').value = act ? (act.descripcion || '') : '';
    document.getElementById('actOrden').value = act ? act.orden : 1;
    document.getElementById('modalActTitulo').textContent = act ? 'Editar Actividad' : 'Nueva Actividad';
    document.getElementById('modalActividad').classList.add('open');
    lucide.createIcons();
}

async function saveActividad() {
    const id = document.getElementById('actividadId').value;
    const idFase = document.getElementById('actividadFaseId').value;
    const nombre = document.getElementById('actNombre').value.trim();
    const desc = document.getElementById('actDescripcion').value.trim();
    const orden = document.getElementById('actOrden').value;

    if (!nombre) { Swal.fire('Atención', 'El nombre de la actividad es obligatorio.', 'warning'); return; }

    const body = new FormData();
    body.append('action', id ? 'update_actividad' : 'create_actividad');
    if (id) body.append('id_actividad', id);
    body.append('id_fase', idFase);
    body.append('nombre_actividad', nombre);
    body.append('descripcion', desc);
    body.append('orden', orden);

    const res = await fetch('api_fases.php', { method: 'POST', body }).then(r => r.json());
    if (res.success) {
        closeModal('modalActividad');
        loadFases();
        Swal.fire({ icon: 'success', title: 'Guardado', text: res.message, timer: 1500, showConfirmButton: false });
    } else {
        Swal.fire('Error', res.message, 'error');
    }
}

async function deleteActividad(id) {
    const conf = await Swal.fire({ title: '¿Eliminar actividad?', text: 'Se eliminarán sus vínculos con resultados.', icon: 'warning', showCancelButton: true, confirmButtonText: 'Sí, eliminar', cancelButtonText: 'Cancelar', confirmButtonColor: '#dc2626' });
    if (!conf.isConfirmed) return;
    const res = await fetch(`api_fases.php?action=delete_actividad&id_actividad=${id}`).then(r => r.json());
    if (res.success) { loadFases(); }
    else Swal.fire('Error', res.message, 'error');
}

// ── Modal Vincular Resultados ──
async function openModalVincular(idActividad, idPrograma) {
    currentVinculoActividadId = idActividad;
    currentVinculoProgramaId = idPrograma;

    document.getElementById('modalVincularBody').innerHTML = '<p style="text-align:center; color:var(--text-muted); padding:20px;">Cargando resultados...</p>';
    document.getElementById('modalVincular').classList.add('open');

    const [competencias, vinculados] = await Promise.all([
        fetch(`api_fases.php?action=get_resultados_programa&programa=${idPrograma}`).then(r => r.json()),
        fetch(`api_fases.php?action=get_vinculados&id_actividad=${idActividad}`).then(r => r.json())
    ]);

    const vinculadosSet = new Set(vinculados.map(v => v.codigo_resul));

    let html = '';
    competencias.forEach(comp => {
        html += `<div style="margin-bottom:16px;">
            <div style="font-size:12px;font-weight:700;color:var(--text-muted);text-transform:uppercase;margin-bottom:8px;padding-bottom:6px;border-bottom:1px solid var(--border);">${escHtml(comp.nombre_comp)}</div>`;
        comp.resultados.forEach(r => {
            const checked = vinculadosSet.has(r.codigo_resul) ? 'checked' : '';
            html += `<label style="display:flex;align-items:flex-start;gap:10px;padding:8px;border-radius:8px;cursor:pointer;transition:background 0.15s;" onmouseover="this.style.background='#f8faff'" onmouseout="this.style.background=''">
                <input type="checkbox" value="${r.codigo_resul}" ${checked} style="margin-top:2px;accent-color:var(--primary);cursor:pointer;">
                <span style="font-size:13px;color:var(--text-main);line-height:1.4;">${escHtml(r.nombre_resultado)}</span>
            </label>`;
        });
        html += `</div>`;
    });

    document.getElementById('modalVincularBody').innerHTML = html || '<p style="color:var(--text-muted);font-size:13px;">No hay resultados disponibles para este programa.</p>';
    lucide.createIcons();
}

async function saveVinculos() {
    const checkboxes = document.querySelectorAll('#modalVincularBody input[type=checkbox]');
    const seleccionados = Array.from(checkboxes).filter(c => c.checked).map(c => parseInt(c.value));

    const body = new FormData();
    body.append('action', 'save_vinculos');
    body.append('id_actividad', currentVinculoActividadId);
    body.append('resultados', JSON.stringify(seleccionados));

    const res = await fetch('api_fases.php', { method: 'POST', body }).then(r => r.json());
    if (res.success) {
        closeModal('modalVincular');
        loadFases();
        Swal.fire({ icon: 'success', title: 'Vínculos guardados', timer: 1500, showConfirmButton: false });
    } else {
        Swal.fire('Error', res.message, 'error');
    }
}

async function desvincularResultado(idActividad, codigoResul) {
    const body = new FormData();
    body.append('action', 'desvincular_resultado');
    body.append('id_actividad', idActividad);
    body.append('codigo_resul', codigoResul);
    const res = await fetch('api_fases.php', { method: 'POST', body }).then(r => r.json());
    if (res.success) loadFases();
}

function closeModal(id) { document.getElementById(id).classList.remove('open'); }

function confirmReset() {
    Swal.fire({ title: '¿Limpiar TODO?', text: 'Esta acción eliminará todos los datos del sistema.', icon: 'warning', showCancelButton: true, confirmButtonText: 'Sí, limpiar', cancelButtonText: 'Cancelar', confirmButtonColor: '#dc2626' })
    .then(r => { if (r.isConfirmed) fetch('api.php?action=delete_all').then(() => window.location.href = 'index.php'); });
}

function escHtml(str) {
    if (!str) return '';
    return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}
</script>

</body>
</html>
