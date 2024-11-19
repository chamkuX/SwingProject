// app.js
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const dotenv = require('dotenv');
const authRoutes = require('./routes/authRoutes'); // Import the authRoutes file

dotenv.config();

const app = express();

// Middleware to log incoming requests
app.use((req, res, next) => {
  console.log(`Incoming request: ${req.method} ${req.url}`);
  next(); // Move to the next middleware
});

// Middleware for CORS and parsing JSON
app.use(cors());
app.use(bodyParser.json());

// Routes for authentication (use '/auth' as the base URL for authentication routes)
app.use('/auth', authRoutes);  

// Root route to check if the server is running
app.get('/', (req, res) => {
  res.send('Server is up and running!');
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server is running on http://0.0.0.0:${PORT}`);
});
