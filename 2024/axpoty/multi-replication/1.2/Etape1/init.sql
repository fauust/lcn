-- Init file for the database (for testing purposes)

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    user_id INTEGER NOT NULL
);

-- Populate the database with some data

INSERT INTO users (username, email, password) VALUES ('user1', '[email protected]', 'password1');
INSERT INTO users (username, email, password) VALUES ('user2', '[email protected]', 'password2');
INSERT INTO users (username, email, password) VALUES ('user3', '[email protected]', 'password3');

INSERT INTO posts (title, content, user_id) VALUES ('Post 1', 'Content of post 1', 1);
INSERT INTO posts (title, content, user_id) VALUES ('Post 2', 'Content of post 2', 2);
