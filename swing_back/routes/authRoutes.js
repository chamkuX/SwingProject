// routes/authRoutes.js
const express = require('express');
const router = express.Router();

// POST route for login
router.post('/login', (req, res) => {
  const { username, password } = req.body;

  // Mock authentication logic
  if (username === 'test' && password === 'password') {
    return res.status(200).json({ message: 'Login successful!' });
  } else {
    return res.status(400).json({ message: 'Invalid credentials' });
  }
});

module.exports = router;
