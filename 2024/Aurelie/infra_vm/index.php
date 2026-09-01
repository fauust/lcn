<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Contacts</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h1>Liste des Contacts</h1>
    <?php
    $servername = "localhost";
    $username = "aurelie";
    $password = "campus";
    $dbname = "contacts_db";

    // Connection database
    $conn = new mysqli($servername, $username, $password, $dbname);

    // check connection
    if ($conn->connect_error) {
        die("La connection a échoué: " . $conn->connect_error);
    }

    // get contacts
    $sql = "SELECT id, nom, prenom, address, code_postal, ville FROM contacts";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        // show contacts
        echo "<table>";
        echo "<tr><th>ID</th><th>Nom</th><th>Prénom</th><th>Address</th><th>Code Postal</th><th>Ville</th></tr>";
        while($row = $result->fetch_assoc()) {
            echo "<tr>";
            echo "<td>" . $row["id"]. "</td>";
            echo "<td>" . $row["nom"]. "</td>";
            echo "<td>" . $row["prenom"]. "</td>";
            echo "<td>" . $row["address"]. "</td>";
            echo "<td>" . $row["code_postal"]. "</td>";
            echo "<td>" . $row["ville"]. "</td>";
            echo "</tr>";
        }
        echo "</table>";
    } else {
        echo "<p>Aucun résultat trouvé</p>";
    }

    $conn->close();
    ?>
</body>
</html>
