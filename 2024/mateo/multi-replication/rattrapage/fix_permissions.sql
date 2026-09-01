-- Autoriser la connexion root depuis n'importe quel hôte
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY 'password1234';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
