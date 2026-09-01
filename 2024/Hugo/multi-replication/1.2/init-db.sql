USE mydb;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    age INT
);

CREATE TABLE cubes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE favorite_cube (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    cube_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (cube_id) REFERENCES cubes(id)
);

-- Insertion des utilisateurs
INSERT INTO users (name, email, age) VALUES
('Axel', 'axel.poty@minecraft.com', 9),
('Eddy', 'eddy.vernet@minecraft.com', 11);

-- Insertion des cubes
INSERT INTO cubes (name) VALUES
('Storage'),
('Reactor'),
('Lava');

-- Insertion des cubes favoris
INSERT INTO favorite_cube (user_id, cube_id) VALUES
(1, 1),  -- Axel aime Storage
(1, 2),  -- Axel aime Reactor
(2, 3);  -- Eddy aime Lava
