<?php
// db.php
$host = 'localhost';
$db = 'juicio_evaluativo';
$user = 'postgres'; // Replace with your PostgreSQL user
$pass = '071121'; // Replace with your PostgreSQL password
$port = '5432';

try {
    $dsn = "pgsql:host=$host;port=$port;dbname=$db";
    $pdo = new PDO($dsn, $user, $pass, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
} catch (PDOException $e) {
    die("Error de conexión a la base de datos: " . $e->getMessage());
}
?>
