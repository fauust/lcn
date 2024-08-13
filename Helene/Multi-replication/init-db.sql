CREATE DATABASE IF NOT EXISTS mydb;
USE mydb;

CREATE TABLE IF NOT EXISTS contacts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    email VARCHAR(100) NOT NULL
);

INSERT INTO contacts (name, age, email) VALUES
    ('Alice', 30, 'alice@example.com'),
    ('Bob', 25, 'bob@example.com'),
    ('Charlie', 35, 'charlie@example.com'),
    ('Diana', 28, 'diana@example.com');
