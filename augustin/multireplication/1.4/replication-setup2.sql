-- Drop existing replication user and test database if they exist
DROP USER IF EXISTS 'repl'@'%';
DROP DATABASE IF EXISTS test_repl;
-- Create replication user
CREATE USER IF NOT EXISTS 'repl'@'%' IDENTIFIED BY 'repl_pass';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';
FLUSH PRIVILEGES;

-- Create a test database and table to verify replication
CREATE DATABASE IF NOT EXISTS test_repl;
USE test_repl;
CREATE TABLE IF NOT EXISTS hello (
  id INT AUTO_INCREMENT PRIMARY KEY,
  msg VARCHAR(100)
);
INSERT INTO hello (msg) VALUES ('Hello from 02!');

-- STOP SLAVE;
-- RESET SLAVE ALL;
-- CHANGE MASTER TO MASTER_HOST='sql-primary01', MASTER_USER='repl', MASTER_PASSWORD='repl_pass', MASTER_PORT=3306, MASTER_USE_GTID=slave_pos;