CREATE USER 'jon'@'localhost' IDENTIFIED BY 'toto';

CREATE DATABASE IF NOT EXISTS vm_app_db;

GRANT ALL PRIVILEGES ON vm_app_db.* TO 'jon'@'localhost';

FLUSH PRIVILEGES;
