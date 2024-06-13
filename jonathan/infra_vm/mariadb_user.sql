CREATE USER 'jon'@'localhost' IDENTIFIED BY 'toto';

CREATE DATABASE IF NOT EXISTS vm_app_db;

GRANT ALL PRIVILEGES ON vm_app_db.* TO 'jon'@'localhost';

FLUSH PRIVILEGES;

insert into users (name, email, password) values ('jon', 'jonathan.luscap@le-campus-numerique.fr', 'toto');
