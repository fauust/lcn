# Vérification que la base de données n'est pas accessible depuis le HOST

```
# Récupération de l'IP du container Mariadb :
$> docker network inspect dockercompose_wp_db-network
...
        "Containers": {
            "07617ff64a82618028b8f7d53be64053a669ccc7dd3fa4d7c5a530c9b61fca04": {
                "Name": "mydb",
                "EndpointID": "09fc8e....",
                "MacAddress": "02:42:ac:13:00:03",
                "IPv4Address": "172.19.0.3/16",
                "IPv6Address": ""
            },

# telnet sur le container Mariadb depuis le host :
$> telnet 172.19.0.3 3306

==> ça devrait refuser la connexion, mais non :


❯ telnet 172.18.0.2 3306
Trying 172.18.0.2...
Connected to 172.18.0.2.
Escape character is '^]'.
Z
11.4.2-MariaDB-ubu2404Yfr,#f\{tS&_.f:.u&Wdmysql_native_password

