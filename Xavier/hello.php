<?php
// Include the database connection file
include_once("hello_config.php");

// Fetch contacts (in descending order)
$result = mysqli_query($mysqli, "SELECT * FROM contacts ORDER BY id DESC");

?>