<!DOCTYPE html>
<html>
<head>
    <title>Cours PHP / MySQL</title>
    <meta charset="utf-8">
</head>
<body>
<h1>Bases de données MySQL</h1>
<?php
$servername = 'localhost';
$username = 'eddy';
$password = 'eddy';

//On établit la connexion
$PDO = new PDO(`mysql:host=$servername,dbname=toto, $username, $password`);

$name = $PDO->query('SELECT name FROM characters WHERE name = "Toto"');
$last_name = $PDO->query('SELECT last_name FROM characters WHERE name = "Toto"');
$age  = $PDO->query('SELECT age FROM characters WHERE name = "Toto"');
?>
<?php console.log("marc") ?>
<span>
    Bonjour, je m'appelle <?=$name?> <?=$last_name?> et j'ai <?=$age?> ans !
</span>
<?php console.log("name ::", $name) ?>
<?php console.log("name ::", $last_name) ?>
<?php console.log("name ::", $age) ?>
</body>
</html>