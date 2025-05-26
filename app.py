from flask import Flask, request, jsonify
import mysql.connector
import hashlib

app = Flask(_name_)

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

if _name_ == '_main_':
    app.run(debug=True)