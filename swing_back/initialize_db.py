import sqlite3

def initialize_db():
    conn = sqlite3.connect('swing_back.db')
    cursor = conn.cursor()

    # Create Meta table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS Meta (
            match_id TEXT PRIMARY KEY,
            data_version TEXT,
            created TEXT,
            revision INTEGER
        )
    ''')

    # Create Info table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS Info (
            city TEXT,
            venue TEXT,
            teams TEXT,
            toss_winner TEXT,
            toss_decision TEXT,
            player_of_match TEXT,
            match_type TEXT,
            gender TEXT,
            competition TEXT,
            overs INTEGER,
            date TEXT
        )
    ''')

    # Create Innings table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS Innings (
            inning_id INTEGER PRIMARY KEY AUTOINCREMENT,
            team TEXT,
            runs INTEGER,
            wickets INTEGER,
            overs FLOAT,
            deliveries TEXT
        )
    ''')

    conn.commit()
    conn.close()
    print("Database initialized successfully with all tables.")

if __name__ == "__main__":
    initialize_db()
