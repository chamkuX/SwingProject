import sqlite3
import json

# Paths to the database and JSON file
db_path = '/Users/chamku/swing_back/swing_cricket.db'
json_path = '/Users/chamku/swing_back/match-data/1166922.json'

# Connect to the database
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# Step 1: Drop and Create Tables
def create_tables():
    # Drop tables if they already exist to ensure we have a clean start
    cursor.execute("DROP TABLE IF EXISTS Matches")
    cursor.execute("DROP TABLE IF EXISTS Teams")
    cursor.execute("DROP TABLE IF EXISTS Players")
    cursor.execute("DROP TABLE IF EXISTS Balls")
    
    # Create tables with the required schema
    cursor.execute("""
        CREATE TABLE Matches (
            match_id TEXT PRIMARY KEY,
            venue TEXT,
            date TEXT,
            team1_id TEXT,
            team2_id TEXT,
            toss_winner TEXT,
            toss_decision TEXT
        )
    """)
    
    cursor.execute("""
        CREATE TABLE Teams (
            team_id TEXT PRIMARY KEY,
            team_name TEXT
        )
    """)
    
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS Players (
            player_id TEXT PRIMARY KEY,
            player_name TEXT,
            team_id TEXT,
            FOREIGN KEY(team_id) REFERENCES Teams(team_id)
        )
    """)
    
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS Balls (
            match_id TEXT,
            inning_num INTEGER,
            over_num INTEGER,
            ball_num INTEGER,
            batter TEXT,
            bowler TEXT,
            runs INTEGER,
            extras INTEGER,
            total_runs INTEGER,
            FOREIGN KEY(match_id) REFERENCES Matches(match_id)
        )
    """)
    
    conn.commit()

# Step 2: Insert Data Functions
def insert_match_info(meta_info):
    try:
        # Handle case where venue might be a string
        venue = meta_info.get("venue", "Unknown Venue")
        if isinstance(venue, dict):
            venue = venue.get("name", "Unknown Venue")

        cursor.execute("""
            INSERT INTO Matches (match_id, venue, date, team1_id, team2_id, toss_winner, toss_decision)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """, (
            meta_info.get("match_id"),
            venue,
            meta_info.get("date"),
            meta_info.get("team1_id"),
            meta_info.get("team2_id"),
            meta_info.get("toss", {}).get("winner"),
            meta_info.get("toss", {}).get("decision")
        ))
    except sqlite3.IntegrityError as e:
        print(f"Error inserting match info: {e}")

def insert_team_info(teams):
    # Handle case where teams might be a list or dictionary
    if isinstance(teams, dict):
        team_items = teams.items()
    elif isinstance(teams, list):
        team_items = enumerate(teams)
    else:
        print("Error: 'teams' data format is not recognized.")
        return

    for team_id, team in team_items:
        try:
            team_name = team.get("name", "Unknown Team") if isinstance(team, dict) else team
            cursor.execute("""
                INSERT INTO Teams (team_id, team_name)
                VALUES (?, ?)
            """, (
                str(team_id),
                team_name
            ))
        except sqlite3.IntegrityError as e:
            print(f"Error inserting team info: {e}")

def insert_player_info(players, team_id):
    for player in players:
        try:
            cursor.execute("""
                INSERT INTO Players (player_id, player_name, team_id)
                VALUES (?, ?, ?)
            """, (
                player.get("id", None),
                player.get("name", "Unknown Player"),
                team_id
            ))
        except sqlite3.IntegrityError as e:
            print(f"Error inserting player info: {e}")

def insert_ball_by_ball(event, match_id, inning_num, over_num, ball_num):
    try:
        cursor.execute("""
            INSERT INTO Balls (match_id, inning_num, over_num, ball_num, batter, bowler, runs, extras, total_runs)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            match_id,
            inning_num,
            over_num,
            ball_num,
            event.get("batter", "Unknown Batter"),
            event.get("bowler", "Unknown Bowler"),
            event["runs"].get("batter", 0),
            event["runs"].get("extras", 0),
            event["runs"].get("total", 0)
        ))
    except sqlite3.IntegrityError as e:
        print(f"Error inserting ball-by-ball event: {e}")

# Step 3: Load Data from JSON and Insert into Database
def load_data():
    with open(json_path, 'r') as file:
        data = json.load(file)

    # Insert match info
    meta_info = data.get("info", {})
    if meta_info:
        insert_match_info(meta_info)
    else:
        print("Error: Missing 'info' key in JSON data")

    # Insert team info
    teams = meta_info.get("teams", {})
    if teams:
        insert_team_info(teams)
    else:
        print("Error: 'teams' key is missing or empty in JSON data")

    # Insert player info for each team
    if isinstance(teams, dict):
        for team_id, team_data in teams.items():
            players = team_data.get("players", []) if isinstance(team_data, dict) else []
            insert_player_info(players, team_id)
    elif isinstance(teams, list):
        for i, team in enumerate(teams):
            team_id = str(i)  # Convert list index to string as team ID
            players = team.get("players", []) if isinstance(team, dict) else []
            insert_player_info(players, team_id)

    # Insert ball-by-ball events
    innings = data.get("innings", [])
    match_id = meta_info.get("match_id", None)

    for inning_num, inning in enumerate(innings, start=1):
        for over in inning.get("overs", []):
            over_num = over.get("over", 0)
            for ball_num, delivery in enumerate(over.get("deliveries", []), start=1):
                insert_ball_by_ball(delivery, match_id, inning_num, over_num, ball_num)

# Main Execution
create_tables()
load_data()

# Commit and close the database connection
conn.commit()
conn.close()

print("Data imported successfully.")
