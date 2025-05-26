CREATE DATABASE library_db;

USE library_db;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE,
    password VARCHAR(100),
    role ENUM('user', 'librarian')
);
ALTER TABLE books
ADD COLUMN status ENUM('available', 'issued') DEFAULT 'available';

CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    author VARCHAR(100),
    status ENUM('available', 'issued') DEFAULT 'available'
);

CREATE TABLE transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    book_id INT,
    type ENUM('issue', 'return'),
    date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(book_id) REFERENCES books(id)
);

CREATE TABLE fines (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(10,2),
    status ENUM('unpaid', 'paid') DEFAULT 'unpaid',
    FOREIGN KEY(user_id) REFERENCES users(id)
);
USE library_db;
ALTER TABLE users
ADD COLUMN email VARCHAR(100) UNIQUE;
ALTER TABLE users
ADD COLUMN role ENUM('user', 'librarian') DEFAULT 'user';
select * from books;
select * from transactions;
select * from users;