<?php
// Basic connection settings
$databaseHost = 'localhost';
$databaseUsername = 'xav';
$databasePassword = '1234';
$databaseName = 'db_xav';

// Connect to the database
$mysqli = mysqli_connect($databaseHost, $databaseUsername, $databasePassword, $databaseName);