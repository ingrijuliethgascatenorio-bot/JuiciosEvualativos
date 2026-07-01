# Sistema de Gestión de Juicios Evaluativos (SGJE)

El **Sistema de Gestión de Juicios Evaluativos (SGJE)** es una plataforma web administrativa diseñada para el seguimiento y análisis de los resultados de aprendizaje de los aprendices. Permite visualizar estados de formación, gestionar resultados, monitorear competencias y evaluar el riesgo académico mediante paneles de inteligencia y alertas automatizadas.

## 🚀 Características Principales

- **Dashboard Principal:** Vista unificada del estado general, total de aprendices, juicios evaluativos y accesos rápidos.
- **Gestión de Aprendices:** Listado completo con filtros avanzados (ficha, estado, juicio) y búsqueda rápida. Paginación en el cliente para un rendimiento óptimo.
- **Análisis de Proyectos:** Seguimiento detallado del avance por fichas, fases y resultados de aprendizaje.
- **Inteligencia Académica (Analytics):**
  - Indicadores clave de rendimiento (KPIs).
  - Semáforo de competencias (verde, amarillo, rojo).
  - Ranking de aprendices (Top 10 y Menor Avance).
  - Análisis de riesgo académico (Bajo, Medio, Alto).
- **Centro de Alertas:** Sistema de notificaciones automatizadas que detecta aprendices con resultados pendientes, competencias en riesgo y fichas con bajo avance.
- **Carga Masiva:** Importación de datos desde archivos Excel (.xlsx) y CSV.

## 🛠️ Tecnologías y Arquitectura

- **Frontend:** HTML5, Vanilla JavaScript, CSS3 (con variables CSS). Iconografía proporcionada por [Lucide Icons](https://lucide.dev/).
- **Backend:** PHP (PDO) con arquitectura de API RESTful ligera (`api.php`, `api_analytics.php`).
- **Base de Datos:** PostgreSQL(Estructura relacional: aprendices, fichas, competencias, resultados, juicios).
- **Librerías de Terceros:**
  - `phpoffice/phpspreadsheet` (Lectura de archivos Excel/CSV).
  - `SweetAlert2` (Modales y confirmaciones).
  - `Chart.js` (Gráficos estadísticos).

## 📂 Estructura del Proyecto

```text
/
├── index.php             # Dashboard principal
├── aprendices.php        # Listado y gestión de aprendices
├── detalle.php           # Perfil detallado de un aprendiz específico
├── analisis.php          # Panel de análisis de proyectos y fases
├── analytics.php         # Dashboard de inteligencia académica y KPIs
├── alertas.php           # Centro completo de alertas y notificaciones
├── upload.php            # Procesamiento de subida de archivos masivos
├── api.php               # API principal de datos (CRUD y filtros)
├── api_analytics.php     # API especializada para métricas e inteligencia
├── db.php                # Conexión PDO a la base de datos
├── css/                  # Hojas de estilo estructuradas (style.css, analytics.css)
├── js/                   # Lógica frontend (main.js, analytics.js)
├── vendor/               # Dependencias de Composer (PhpSpreadsheet)
└── README.md             # Documentación del proyecto
```

## ⚙️ Requisitos de Instalación

1. **Servidor Web:** Apache, Nginx o servidor de desarrollo PHP integrado.
2. **PHP:** Versión 8.0 o superior (extensiones necesarias: `pdo_mysql`, `zip`, `gd`, `xml`).
3. **Base de Datos:** Servidor PostgreSQL.
4. **Composer:** Para gestionar las dependencias de PHP.

## 📦 Instalación y Configuración

1. **Clonar o descargar** el repositorio en el directorio del servidor web (ej. `htdocs` o `www`).
2. **Instalar dependencias de Composer:**
   Abre una terminal en la raíz del proyecto y ejecuta:
   ```bash
   composer install
   ```
3. **Configurar la Base de Datos:**
   - Asegúrate de tener tu servidor de base de datos en ejecución.
   - Revisa y ajusta las credenciales de conexión en el archivo `db.php` si es necesario (por defecto suele ser `localhost`, usuario `root` y sin contraseña en entornos locales de XAMPP).
4. **Iniciar la aplicación:**
   Accede a la aplicación desde tu navegador a través de `http://localhost/tu-carpeta/index.php` (o usa el servidor interno de PHP `php -S localhost:8000`).

