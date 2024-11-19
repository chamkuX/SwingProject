from flask import Flask, jsonify
import sqlite3

app = Flask(__name__)

def get_database_connection():
    conn = sqlite3.connect('/Users/chamku/swing_back/matches.db')
    conn.row_factory = sqlite3.Row
    return conn

@app.route('/api/matches', methods=['GET'])
def get_matches():
    conn = get_database_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Matches")
    matches = [dict(row) for row in cursor.fetchall()]
    conn.close()
    return jsonify(matches)

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)

