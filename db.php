<?php
// db.php
$env = parse_ini_file(__DIR__ . '/.env');

$host = $env['DB_HOST'] ?? 'localhost';
$db   = $env['DB_NAME'] ?? 'juicio_evaluativo';
$user = $env['DB_USER'] ?? 'tu-usuario'; 
$pass = $env['DB_PASS'] ?? 'tu-contraseña';
$port = $env['DB_PORT'] ?? 'tu-puerto';
try {
    $dsn = "pgsql:host=$host;port=$port;dbname=$db";
    $pdo = new PDO($dsn, $user, $pass, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
} catch (PDOException $e) {
    die("Error de conexión a la base de datos: " . $e->getMessage());
}
?>
