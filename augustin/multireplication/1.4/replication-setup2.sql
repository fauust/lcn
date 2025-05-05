-- Drop existing replication user and test database if they exist
DROP USER IF EXISTS 'repl'@'%';
DROP USER IF EXISTS 'mariadb_backup'@'%';
DROP DATABASE IF EXISTS test_repl;
-- Create replication user
CREATE USER IF NOT EXISTS 'mariadb_backup'@'%' IDENTIFIED BY 'mypassword';
GRANT RELOAD, PROCESS, LOCK TABLES, REPLICATION CLIENT ON *.* TO 'mariadb_backup'@'%';
FLUSH PRIVILEGES;
CREATE USER IF NOT EXISTS 'repl'@'%' IDENTIFIED BY 'repl_pass';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';
FLUSH PRIVILEGES;
