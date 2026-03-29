# Learning Tasks Manager

A simple, elegant task manager for tracking daily learning goals.

## Overview

**Option 1: Static (LocalStorage)**
- Single HTML file works entirely in browser
- Data stored in browser's localStorage
- No installation required, just open `index.html`

**Option 2: With Backend Server** (Recommended for persistent data)
- Data saved on your server in `server/data.json`
- Access from any device/browser
- Automatic persistence across sessions and devices

## Setup

### Option 1: Static (No Backend)

Simply open `index.html` in your browser (Chrome, Firefox, Edge, Safari).

### Option 2: Backend Server (Data Persistence)

**Prerequisites:** Node.js 18+ installed

1. **Install server dependencies:**
   ```bash
   cd server
   npm install
   ```

2. **Start the backend server:**
   ```bash
   npm start
   ```
   Server runs at `http://localhost:3000`

3. **Open the frontend:**
   - You can still open `index.html` directly in your browser
   - The app will automatically connect to `http://localhost:3000/api/data` to save/load data

4. **Access from other devices on your network:**
   - Find your computer's local IP address (e.g., `192.168.1.100`)
   - Edit `index.html` line ~1276, change `API_URL` to `http://192.168.1.100:3000/api/data`
   - Access from other devices on same network

## Features

### Home (Daily View)
- Select a date (YYYY-MM-DD)
- View all tasks across categories for that date
- See counts: Total / Done / Pending
- Export selected date as CSV

### Categories

**Default categories:**
- Day2Day
- TASKS
- BASH SCRIPTING

**You can:**
- Add new categories
- Rename existing categories
- Delete categories (with confirmation)

### Task Management

Each task includes:
- Category
- Date
- Task text
- Optional comment
- Done status

**You can:**
- Add new tasks
- Edit tasks
- Delete tasks (with confirmation)
- Toggle Done/Undone
- Mark all tasks in a category as Done

## Data Storage

### With Backend Server
- Data stored in `server/data.json` on the server
- Changes saved automatically to server
- Accessible from any browser/device that can reach the server
- Automatic offline fallback to browser storage when server is unavailable

### Without Backend (Static)
- Stored in browser using `localStorage`
- Key: `learningTasksData_v4`
- First-time use automatically loads sample data
- ⚠️ Data will be lost if browser storage is cleared — always export JSON for backup

## Import / Export

### Export Options
- **Export JSON** — full backup (all data)
- **Export All CSV** — every entry in one file
- **Export Category CSV** — entries from current category
- **Export Date CSV** — entries for selected date

### Import Options
- Upload a JSON file
- Choose mode:
  - **Merge** — adds data safely without removing existing data
  - **Replace** — completely overwrites current data
- Preview is shown before confirming import

## Undo

Supports one-step undo for destructive actions:
- Delete task
- Delete category

Undo resets after next action or page reload.

## Mobile Support

Fully responsive design:
- Sidebar becomes a slide-out menu on mobile
- Tables convert into mobile-friendly cards

## Configuration

### Backend Server Settings
Edit these in `server/server.js`:
- `PORT` — change server port (default: 3000)
- `DATA_FILE` — location of data file

### Frontend Settings
Edit these in `index.html` (top of `<script>`):
- `API_URL` — backend server endpoint (default: `http://localhost:3000/api/data`)
- `STORAGE_KEY` — localStorage namespace (for multiple installations)
- `DEFAULT_CATEGORIES` — initial categories shown on first run

## Running in Production

For a more robust production deployment:

1. Use a process manager like PM2:
   ```bash
   npm install -g pm2
   pm2 start server/server.js --name tasks-manager
   ```

2. Set up HTTPS with a reverse proxy (nginx/Traefik)

3. Configure firewall to allow only necessary ports

4. Consider adding authentication if exposing to internet

## Tips

- Regularly export JSON backups
- Export before deleting categories
- Use Merge mode when unsure during import
- If using backend, the server will persist data automatically

## Development

The project consists of:
- `index.html` — Complete frontend (HTML + CSS + JavaScript)
- `server/` — Node.js/Express backend API server
- `server/data.json` — Data storage file (auto-created)

To modify the frontend, edit `index.html` directly.
To modify the backend API, edit `server/server.js`.

## License

Free to use for personal projects.
