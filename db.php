<?php

$env = file_exists(__DIR__ . '/.env')
    ? parse_ini_file(__DIR__ . '/.env')
    : [];

$host = getenv('DB_HOST') ?: ($env['DB_HOST'] ?? 'localhost');
$db   = getenv('DB_NAME') ?: ($env['DB_NAME'] ?? 'juicio_evaluativo');
$user = getenv('DB_USER') ?: ($env['DB_USER'] ?? 'tu-usuario');
$pass = getenv('DB_PASS') ?: ($env['DB_PASS'] ?? 'tu-contraseña');
$port = getenv('DB_PORT') ?: ($env['DB_PORT'] ?? '5432');

try {
    $sslmode = getenv('DB_SSLMODE') ?: ($env['DB_SSLMODE'] ?? 'require');
    $dsn = "pgsql:host=$host;port=$port;dbname=$db;sslmode=$sslmode";

    // Detectar si es un host de Neon y agregar el endpoint ID para clientes antiguos sin soporte SNI
    if (strpos($host, 'neon.tech') !== false) {
        $parts = explode('.', $host);
        $endpoint = $parts[0];
        $dsn .= ";options=endpoint=$endpoint";
    }

    $pdo = new PDO(
        $dsn,
        $user,
        $pass,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_EMULATE_PREPARES => true,
        ]
    );

} catch (PDOException $e) {
    die("Error de conexión a la base de datos: " . $e->getMessage());
}
?>