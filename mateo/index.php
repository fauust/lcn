<?php

$servername = "localhost";
$username = "mateo-nicoud";
$password = "123";
$dbname = "laraveldb";

// Création de la co
$conn = new mysqli($servername, $username, $password, $dbname);

// Vérification de la co
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Préparation et exécution de la requête SQL
$sql = "SELECT utilisateur, permission FROM permissions";
$result = $conn->query($sql);

// Vérification du résultat
if ($result->num_rows > 0) {
    // Tableau pour stocker les permissions par utilisateur
    $permissions = array();

    // Récupération des données dans le tableau $permissions
    while($row = $result->fetch_assoc()) {
        $user = $row["utilisateur"];
        $permission = $row["permission"];
        $permissions[$user][] = $permission;
    }

    // Affichage des permissions pour chaque utilisateur
    foreach ($permissions as $user => $user_permissions) {
        echo "Permissions pour l'utilisateur '$user':\n";
        foreach ($user_permissions as $permission) {
            echo "- $permission\n";
        }
    }
} else {
    echo "Aucune permission enregistrée.\n";
}

// Fermeture de la co
$conn->close();
?>
