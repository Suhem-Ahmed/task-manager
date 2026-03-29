const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;
const DATA_DIR = path.join(__dirname, 'data');
const DATA_FILE = path.join(DATA_DIR, 'data.json');

// Ensure data directory exists
if (!fs.existsSync(DATA_DIR)) {
  fs.mkdirSync(DATA_DIR, { recursive: true });
}

// Middleware
app.use(cors());
app.use(express.json());

// Initialize data file if it doesn't exist
function initializeDataFile() {
  if (!fs.existsSync(DATA_FILE)) {
    const initialData = {
      categories: ["Day2Day", "TASKS", "BASH SCRIPTING"],
      entries: []
    };
    fs.writeFileSync(DATA_FILE, JSON.stringify(initialData, null, 2));
  }
}

// GET /api/data - Retrieve all data
app.get('/api/data', (req, res) => {
  try {
    const data = JSON.parse(fs.readFileSync(DATA_FILE, 'utf8'));
    res.json(data);
  } catch (error) {
    console.error('Error reading data:', error);
    res.status(500).json({ error: 'Failed to read data' });
  }
});

// POST /api/data - Save all data (replace)
app.post('/api/data', (req, res) => {
  try {
    const data = req.body;
    // Validate structure
    if (!data || !Array.isArray(data.categories) || !Array.isArray(data.entries)) {
      return res.status(400).json({ error: 'Invalid data structure' });
    }
    fs.writeFileSync(DATA_FILE, JSON.stringify(data, null, 2));
    res.json({ success: true, message: 'Data saved successfully' });
  } catch (error) {
    console.error('Error saving data:', error);
    res.status(500).json({ error: 'Failed to save data' });
  }
});

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Serve frontend static files (index.html, etc.)
app.use(express.static(__dirname));

// For SPA routing - send index.html for all non-API routes
app.get('*', (req, res) => {
  if (!req.path.startsWith('/api/')) {
    res.sendFile(path.join(__dirname, 'index.html'));
  } else {
    res.status(404).json({ error: 'Not found' });
  }
});

// Start server
initializeDataFile();
app.listen(PORT, () => {
  console.log(`🚀 Tasks Manager running at http://localhost:${PORT}`);
  console.log(`📁 Data file: ${DATA_FILE}`);
});
