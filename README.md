Library Management System(LMS)

Project Description:
A Library Management System is designed to automate and streamline the operations of a library, enhancing efficiency in managing book inventories, user transactions, and cataloging. The system typically includes functionalities such as:
User Management: Registration and authentication of users (students, faculty, staff).
Book Management: Cataloging, searching, and categorizing books.
Transaction Management: Issuing and returning books, tracking due dates, and managing fines.
Reporting: Generating reports on book availability, user activity, and overdue items.
The system aims to reduce manual work, minimize errors, and provide a user-friendly interface for both library staff and patrons.


Project Code:
App.py
from flask import Flask, request, jsonify
import mysql.connector
import hashlib

app = Flask(__name__)

def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="", 
        database="library_db"
    )
# Register
@app.route('/register', methods=['POST'])
def register():
    data = request.json
    username = data['username']
    email = data['email']
    password = hashlib.sha256(data['password'].encode()).hexdigest()
    role = data.get('role', 'user')

    conn = get_connection()
    cursor = conn.cursor()
    try:
        cursor.execute(
            "INSERT INTO users (username, email, password, role) VALUES (%s, %s, %s, %s)", 
            (username, email, password, role)
        )
        conn.commit()
        return jsonify({'message': 'User registered successfully'}), 201
    except mysql.connector.IntegrityError as e:
        if "Duplicate entry" in str(e):
            return jsonify({'error': 'Username or email already exists'}), 400
        else:
            return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()


# Login
@app.route('/login', methods=['POST'])
def login():
    data = request.json
    username = data['username']
    password = hashlib.sha256(data['password'].encode()).hexdigest()
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM users WHERE username=%s AND password=%s", (username, password))
    user = cursor.fetchone()
    cursor.close()
    conn.close()
    if user:
        return jsonify({'message': 'Login successful', 'user': user}), 200
    else:
        return jsonify({'error': 'Invalid credentials'}), 401

# Add Book (Librarian only)
@app.route('/add_book', methods=['POST'])
def add_book():
    data = request.json
    title = data['title']
    author = data['author']

    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO books (title, author) VALUES (%s, %s)", (title, author))
    conn.commit()
    cursor.close()
    conn.close()

    return jsonify({'message': 'Book added successfully'}), 201

# Search Book
@app.route('/search_books', methods=['GET'])
def search_books():
    keyword = request.args.get('q', '')

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM books WHERE title LIKE %s OR author LIKE %s", 
                   (f'%{keyword}%', f'%{keyword}%'))
    books = cursor.fetchall()
    cursor.close()
    conn.close()

    return jsonify(books)

# Issue Book
@app.route('/issue_book', methods=['POST'])
def issue_book():
    data = request.json
    user_id = data['user_id']
    book_id = data['book_id']

    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT status FROM book1 WHERE id = %s", (book_id,))
    status = cursor.fetchone()

    if status and status[0] == 'available':
        cursor.execute("UPDATE book1 SET status = 'issued' WHERE id = %s", (book_id,))
        result = {'message': 'Book issued successfully'}
    else:
        result = {'error': 'Book not available'}

    cursor.close()
    conn.close()
    return jsonify(result)

# Return Book
@app.route('/return_book', methods=['POST'])
def return_book():
    data = request.json
    user_id = data['user_id']
    book_id = data['book_id']

    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("UPDATE book1 SET status = 'available' WHERE book_id = %s", (book_id,))

    conn.commit()
    cursor.close()
    conn.close()

    return jsonify({'message': 'Book returned successfully'})

if __name__ == '__main__':
    app.run(debug=True)


Registration.html:
<!DOCTYPE html>
<html>
<head>
    <title>Library System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f2f2f2;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 400px;
            background: #fff;
            margin: 60px auto;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }
        h2 {
            text-align: center;
            margin-bottom: 25px;
        }
        input, select, button {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }
        button {
            background-color: #007BFF;
            color: white;
            font-weight: bold;
            border: none;
        }
        button:hover {
            background-color: #0056b3;
        }
        nav {
            text-align: center;
            margin-bottom: 20px;
        }
        nav a {
            margin: 0 8px;
            color: #007BFF;
            text-decoration: none;
            font-weight: bold;
        }
        nav a:hover {
            text-decoration: underline;
        }
        section {
            display: none;
        }
        section:target {
            display: block;
        }
        #home:target ~ #home,
        body:not(:target) #login {
            display: block;
        }
    </style>
</head>
<body>

<!-- Navigation -->
<nav>
    <a href="#register">Register</a>
    <a href="#login">Login</a>
    <a href="#dashboard">Dashboard</a>
</nav>

<!-- Register -->
<section id="register">
    <div class="container">
        <h2>Register</h2>
        <form>
            <input type="text" placeholder="Username" required>
            <input type="email" placeholder="Email" required>
            <input type="password" placeholder="Password" required>
            <select>
                <option value="user">User</option>
                <option value="librarian">Librarian</option>
            </select>
            <button type="submit">Register</button>
        </form>
    </div>
</section>

<!-- Login -->
<section id="login">
    <div class="container">
        <h2>Login</h2>
        <form>
            <input type="text" placeholder="Username" required>
            <input type="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>
    </div>
</section>

<!-- Dashboard -->
<section id="dashboard">
    <div class="container">
        <h2>Dashboard</h2>
        <a href="#addbook">Add Book</a><br>
        <a href="#searchbook">Search Book</a><br>
        <a href="#issuebook">Issue Book</a><br>
        <a href="#returnbook">Return Book</a>
    </div>
</section>

<!-- Add Book -->
<section id="addbook">
    <div class="container">
        <h2>Add Book</h2>
        <form>
            <input type="text" placeholder="Title" required>
            <input type="text" placeholder="Author" required>
            <button type="submit">Add Book</button>
        </form>
    </div>
</section>

<!-- Search Book -->
<section id="searchbook">
    <div class="container">
        <h2>Search Book</h2>
        <form>
            <input type="text" placeholder="Search by title or author" required>
            <button type="submit">Search</button>
        </form>
    </div>
</section>

<!-- Issue Book -->
<section id="issuebook">
    <div class="container">
        <h2>Issue Book</h2>
        <form>
            <input type="number" placeholder="User ID" required>
            <input type="number" placeholder="Book ID" required>
            <button type="submit">Issue</button>
        </form>
    </div>
</section>

<!-- Return Book -->
<section id="returnbook">
    <div class="container">
        <h2>Return Book</h2>
        <form>
            <input type="number" placeholder="User ID" required>
            <input type="number" placeholder="Book ID" required>
            <button type="submit">Return</button>
        </form>
    </div>
</section>

</body>
</html>


MySQL database:
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


Key Technologies:
The choice of technologies for an LMS can vary based on the project's scope and requirements. Commonly used technologies include:
Programming Languages: Java, PHP, Python, C#
Database Management Systems: MySQL, PostgreSQL, SQLite
Web Technologies: HTML, CSS, JavaScript
Frameworks: Django (Python)

Additional Tools:
Barcode/RFID Integration: For book tracking and inventory management.
QR Code Scanning: Facilitates book check-in and check-out processes.
Mobile App Integration: Enhances accessibility for users on the go.


Output:
Upon successful implementation, the LMS should provide:
Automated Book Transactions: Streamlined process for issuing and returning books.
Real-Time Inventory Tracking: Up-to-date information on book availability.
User Activity Monitoring: Logs of user interactions and transactions.
Reports and Analytics: Insights into library usage, popular books, and overdue items.
Enhanced User Experience: Intuitive interfaces for both staff and patrons.


Further Research and Development
To advance the capabilities of an LMS, consider exploring the following areas:
Integration with RFID Technology: Implementing RFID can automate check-in/check-out processes and improve inventory management. Libraries have used RFID to replace barcodes on items, allowing for simultaneous scanning of multiple books and reducing staff workload.
Mobile Application Development: Developing mobile apps for iOS and Android platforms can provide users with convenient access to library services, such as book reservations and notifications.
Artificial Intelligence (AI) for Recommendation Systems: Utilizing AI to suggest books to users based on their borrowing history and preferences can enhance user engagement.
Cloud-Based Solutions: Adopting cloud technologies can offer scalable storage solutions and remote access to the LMS, facilitating better data management and accessibility.
Advanced Reporting and Analytics: Implementing advanced data analytics can provide deeper insights into library operations, helping in decision-making processes.

