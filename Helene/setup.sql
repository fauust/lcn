-- setup.sql


-- Create User with password
CREATE USER '${MDB_USER}'@'localhost' IDENTIFIED BY '${MDB_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO '${MDB_USER}'@'localhost';

-- Apply Changes
FLUSH PRIVILEGES;