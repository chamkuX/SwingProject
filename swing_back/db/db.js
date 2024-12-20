// db/db.js
const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database('./db/users.db', (err) => {
  if (err) {
    console.error("Error opening database:", err);
  } else {
    console.log('Connected to the SQLite database');
  }
});

// Create the users table if not exists
db.run(`
  CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    swingId TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL
  )
`);

module.exports = db;
