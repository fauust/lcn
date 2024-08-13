CREATE DATABASE IF NOT EXISTS wordpress;

CREATE TABLE IF NOT EXISTS wordpress.users (
  id INT PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100),
  gender VARCHAR  (10)
 );

INSERT INTO wordpress.users (id,name, email, gender) VALUES
(11,'Alice', 'alice@example.com', 'Female'),
(12,'Bob', 'bob@example.com', 'Male'),
(2, 'Kinde', 'jkinde1@goodreads.com', 'Male'),
(1, 'Klehn', 'lklehn0@nih.gov', 'Male'),
(3, 'Dondon', 'ldondon2@bloglines.com', 'Bigender'),
(4, 'Weepers', 'pweepers3@diigo.com', 'Female'),
(5, 'Hauxwell', 'mhauxwell4@berkeley.edu', 'Female'),
(6, 'Wyles', 'bwyles5@amazon.co.jp', 'Female'),
(7, 'Stoakes', 'gstoakes6@globo.com', 'Male'),
(8, 'McInally', 'mmcinally7@rakuten.co.jp', 'Female'),
(9, 'Janaszkiewicz', 'ljanaszkiewicz8@google.it', 'Male'),
(10, 'Landsbury', 'mlandsbury9@lycos.com', 'Female');