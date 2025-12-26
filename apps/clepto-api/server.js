const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
require('dotenv').config();
const db = require('./src/config/db');

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// Check DB Connection
db.query('SELECT NOW()', (err, res) => {
    if (err) {
        console.error('❌ Database Connection Failed:', err.message);
    } else {
        console.log('✅ Database Connected:', res.rows[0].now);
    }
});

// Routes
app.get('/', (req, res) => {
    res.json({ message: 'Clepto API v1', status: 'online' });
});

app.listen(port, () => {
    console.log(`🚀 Clepto API running on port ${port}`);
});

