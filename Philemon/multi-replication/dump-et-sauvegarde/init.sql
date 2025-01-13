CREATE TABLE IF NOT EXISTS table1 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS table2 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL
);

INSERT INTO table1 (name, description) VALUES
('Lorem Ipsum', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
('Dolor Sit', 'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.');

INSERT INTO table2 (title, content) VALUES
('Lorem Ipsum', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
('Dolor Sit', 'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.');