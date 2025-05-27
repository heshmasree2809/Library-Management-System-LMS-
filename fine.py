from flask import Flask, request, jsonify
import mysql.connector
from datetime import datetime, timedelta

app = Flask(__name__)

# Connect to MySQL
db = mysql.connector.connect(
    host="localhost",
    user="your_username",
    password="your_password",
    database="library_db"
)
cursor = db.cursor(dictionary=True)

# Issue Book
@app.route('/issue', methods=['POST'])
def issue_book():
    data = request.get_json()
    user_id = data['user_id']
    book_id = data['book_id']
    issue_date = datetime.today().date()

    cursor.execute(
        "INSERT INTO issued_books (user_id, book_id, issue_date) VALUES (%s, %s, %s)",
        (user_id, book_id, issue_date)
    )
    db.commit()
    return jsonify({"message": "Book issued successfully"}), 201

# Return Book & Calculate Penalty
@app.route('/return', methods=['POST'])
def return_book():
    data = request.get_json()
    user_id = data['user_id']
    book_id = data['book_id']
    return_date = datetime.today().date()

    cursor.execute(
        "SELECT * FROM issued_books WHERE user_id = %s AND book_id = %s AND return_date IS NULL",
        (user_id, book_id)
    )
    record = cursor.fetchone()

    if not record:
        return jsonify({"error": "Book not found or already returned"}), 404

    issue_date = record['issue_date']
    days_used = (return_date - issue_date).days
    penalty = 0

    if days_used > 10:
        penalty = (days_used - 10) * 5

    cursor.execute(
        "UPDATE issued_books SET return_date = %s, penalty = %s WHERE id = %s",
        (return_date, penalty, record['id'])
    )
    db.commit()

    return jsonify({
        "message": "Book returned successfully",
        "days_used": days_used,
        "penalty": penalty
    }), 200

if __name__ == '__main__':
    app.run(debug=True)
