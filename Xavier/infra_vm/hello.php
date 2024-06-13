<?php

// Connection settings
$databaseHost = 'localhost';
$databaseUsername = 'xav';
$databasePassword = '1234';
$databaseName = 'db_xav';
//echo "Connecting to database $databaseName on $databaseHost as $databaseUsername";

// Connect to the database
$mysqli = mysqli_connect($databaseHost, $databaseUsername, $databasePassword, $databaseName);

// Fetch contacts (in descending order)
$result = mysqli_query($mysqli, "SELECT * FROM contacts ORDER BY id DESC");
?>

<html>
<head>
    <title>MariaDB Contacts</title>
    <link rel="stylesheet" href="styles.css" />
</head>
<body>
<h1>Contacts</h1>
<table>
    <tr>
        <th>Prénom</th>
        <th>Age</th>
<!--        <td><a class="button" href="add.php">Add Contact</a></td>-->
    </tr>
    <?php
    // Print contacts
    while($res = mysqli_fetch_array($result)) {
        echo "<tr>";
        echo "<td>".$res['name']."</td>";
        echo "<td>".$res['age']."</td>";
//        echo "<td><a href=\"edit.php?id=$res[id]\">Edit</a> | <a href=\"delete.php?id=$res[id]\" onClick=\"return confirm('Are you sure you want to delete this contact?')\">Delete</a></td>";
    }
    ?>
</table>
</body>
</html>