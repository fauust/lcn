<?php
$host = 'localhost';
$db   = 'TestingBasics';
$user = 'augustin';
$pass = 'password';
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$opt = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];
$pdo = new PDO($dsn, $user, $pass, $opt);

$sql = "SELECT * FROM TestingBasics.users";
$stmt = $pdo->query($sql);
$answer = $stmt->fetchAll();

foreach ($answer as $row) {
    echo $row['name'] . "\n" . $row['email'] . "\n";
}