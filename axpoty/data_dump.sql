USE vm_app
-- Define the new user's details
SET @name = 'John Doe';
SET @email = 'johndoe@example.com';
SET @password = '$2y$10$eW5iKds8.FkJz8vWkWQZFOZT./Qp5e4xjq9UzxXhtK1ZvqGg1pu5S';
SET @created_at = NOW();

-- Insert the new user into the users table
INSERT INTO users (name, email, password, created_at)
VALUES (@name, @email, @password, @created_at);
