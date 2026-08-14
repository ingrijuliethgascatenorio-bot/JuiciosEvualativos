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

    $pdo = new PDO(
        $dsn,
        $user,
        $pass,
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );

} catch (PDOException $e) {
    die("Error de conexión a la base de datos: " . $e->getMessage());
}
?>