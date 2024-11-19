// controllers/authController.js
const db = require('../db/db');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'your_jwt_secret';

// Register User
exports.register = (req, res) => {
  const { name, swingId, password } = req.body;

  if (!name || !swingId || !password) {
    return res.status(400).json({ error: 'Please provide all fields.' });
  }

  // Check if the user already exists
  db.get('SELECT * FROM users WHERE swingId = ?', [swingId], (err, row) => {
    if (err) {
      return res.status(500).json({ error: 'Database error.' });
    }

    if (row) {
      return res.status(400).json({ error: 'User already exists.' });
    }

    // Hash the password
    bcrypt.hash(password, 10, (err, hashedPassword) => {
      if (err) {
        return res.status(500).json({ error: 'Error hashing password.' });
      }

      // Insert new user into the database
      db.run(
        'INSERT INTO users (name, swingId, password) VALUES (?, ?, ?)',
        [name, swingId, hashedPassword],
        function (err) {
          if (err) {
            return res.status(500).json({ error: 'Error registering user.' });
          }

          // Respond with the new user id
          res.status(201).json({ message: 'User registered successfully', id: this.lastID });
        }
      );
    });
  });
};

// Login User
exports.login = (req, res) => {
  const { swingId, password } = req.body;

  if (!swingId || !password) {
    return res.status(400).json({ error: 'Please provide both Swing ID and password.' });
  }

  // Check if the user exists
  db.get('SELECT * FROM users WHERE swingId = ?', [swingId], (err, row) => {
    if (err) {
      return res.status(500).json({ error: 'Database error.' });
    }

    if (!row) {
      return res.status(400).json({ error: 'User does not exist.' });
    }

    // Compare the password
    bcrypt.compare(password, row.password, (err, result) => {
      if (err || !result) {
        return res.status(400).json({ error: 'Invalid password.' });
      }

      // Create JWT token
      const token = jwt.sign({ id: row.id, swingId: row.swingId }, JWT_SECRET, {
        expiresIn: '1h',
      });

      // Respond with the token
      res.json({ message: 'Login successful', token });
    });
  });
};
