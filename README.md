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

**Option 3: Docker Deployment - Single Container**
- Single container with backend + frontend
- Runs on port 7777 (no authentication)
- Quick and simple

**Option 4: Docker Deployment - Secure with Nginx Proxy + Basic Auth** ⭐ RECOMMENDED FOR PUBLIC ACCESS
- Nginx reverse proxy with HTTP Basic Authentication
- Protects your site with username/password
- Backend not directly exposed (only through nginx)
- Port 8080 externally (nginx) → port 3000 internally (app)

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

### Option 3: Docker Deployment (Single Container)

Deploy as a single Docker container (backend serves frontend):

```bash
# 1. Build the Docker image
docker build --network=host -t tasks-manager .

# 2. Run the container
docker run -d \
  --name tasks-manager \
  --restart unless-stopped \
  -p 7777:3000 \
  -v tasks-manager-data:/app/data \
  tasks-manager

# 3. Access the app
# Open http://YOUR_SERVER_IP:7777
```

**Data persistence:** Your task data is stored in a Docker volume `tasks-manager-data`. To backup:
```bash
docker run --rm -v tasks-manager-data:/data -v $(pwd):/backup alpine tar czf /backup/data-backup.tar.gz -C /data .
```

**View logs:**
```bash
docker logs -f tasks-manager
```

**Stop/Start:**
```bash
docker stop tasks-manager
docker start tasks-manager
```

**Update to new version:**
```bash
git pull
docker stop tasks-manager
docker rm tasks-manager
docker build --network=host -t tasks-manager .
docker run -d --name tasks-manager --restart unless-stopped -p 7777:3000 -v tasks-manager-data:/app/data tasks-manager
```

---

### Option 4: Docker Deployment with Nginx Proxy + Basic Auth (SECURE - Recommended for Public Access)

This setup uses **Nginx as a reverse proxy** with HTTP Basic Authentication, so your Tasks Manager is protected by a username/password. The backend is not exposed directly to the internet - only nginx can access it.

#### Prerequisites

- Docker & Docker Compose installed
- `htpasswd` utility (from `apache2-utils` on Ubuntu/Debian)

#### Setup Steps

**1. Install htpasswd (if not installed):**
```bash
sudo apt update && sudo apt install apache2-utils -y
```

**2. Create authentication files:**

Create the password file (you'll be prompted to enter a password):
```bash
cd ~/VSCODE/task-manager
htpasswd -c ./task.htpasswd msa
# Enter password when prompted (remember this!)
```

Create the nginx configuration file:
```bash
cat > task.conf << 'EOF'
server {
    listen 80;
    server_name _;

    auth_basic "Restricted Access";
    auth_basic_user_file /etc/nginx/.htpasswd;

    location / {
        proxy_pass http://tasks-manager:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF
```

**Important:** Add `task.htpasswd` to your `.gitignore` so you don't commit your password file:
```bash
echo "task.htpasswd" >> .gitignore
```

**3. Deploy with docker-compose:**

We provide a convenience script, or you can run commands manually:

```bash
# Using the deploy script (recommended):
./deploy.sh

# Or manually:
docker-compose down 2>/dev/null || true
docker build --network=host -t tasks-manager .
docker-compose up -d
```

**4. Access your secured site:**

- **Local URL:** `http://YOUR_SERVER_IP:8080`
- **Browser prompt:** Enter username `msa` and the password you created
- **Cloudflared:** Point to `http://localhost:8080` (or `127.0.0.1:8080`)

**5. Test authentication:**

```bash
# Without auth - should return 401
curl -I http://localhost:8080

# With auth - should return 200
curl -I -u msa:YOUR_PASSWORD http://localhost:8080
```

#### Architecture

```
Internet → Cloudflared → Nginx (port 8080, requires auth) → Tasks Manager (port 3000, internal only)
```

- **Nginx** (`nginx-proxy` container) handles authentication and proxies requests
- **Tasks Manager** (`tasks-manager` container) only accessible from within Docker network
- **Port 3000** is NOT exposed to your host machine (only internal Docker network)
- **Port 8080** is the only external port, and it requires authentication

#### Management Commands

```bash
# View all logs
docker-compose logs -f

# View only nginx logs
docker-compose logs -f nginx-proxy

# View only app logs
docker-compose logs -f tasks-manager

# Stop everything
docker-compose down

# Restart services
docker-compose restart

# Check status
docker-compose ps

# Backup data (same as single container)
./backup.sh
```

#### Updating After Code Changes

```bash
git pull
./deploy.sh
```

The deploy script will:
- Stop existing containers
- Build new Docker image (with network=host to avoid npm DNS issues)
- Start both nginx and backend containers
- Everything ready in ~3 minutes

---

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

### With Docker
- Data stored in Docker volume `tasks-manager-data`
- Persists across container restarts and rebuilds
- Backup with `./backup.sh` or manual Docker commands
- To permanently delete data: `docker volume rm task-manager_tasks-manager-data`

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
- `DATA_DIR` — location of data directory

### Frontend Settings
Edit these in `index.html` (top of `<script>`):
- `API_URL` — backend server endpoint (default: `/api/data` relative)
- `STORAGE_KEY` — localStorage namespace (for multiple installations)
- `DEFAULT_CATEGORIES` — initial categories shown on first run

## Security Notes

### For Public Access (Option 4)

- **Always use the Nginx proxy with Basic Auth** when exposing to the internet
- The backend API is NOT directly accessible from outside the Docker network
- Choose a strong password for `task.htpasswd`
- Consider adding HTTPS with Let's Encrypt for production use
- The `task.htpasswd` file should **NEVER** be committed to git (it's in `.gitignore`)

### For Local Network Only

- You can use Option 3 (single container on port 7777) without authentication
- Only accessible from devices on your local network

---

## Deployment Cheatsheet

### First Time Setup (Secure)

```bash
# 1. Clone repo
git clone <your-repo>
cd task-manager

# 2. Install htpasswd
sudo apt update && sudo apt install apache2-utils -y

# 3. Create password
htpasswd -c ./task.htpasswd msa

# 4. Create nginx config
cat > task.conf << 'EOF'
server {
    listen 80;
    server_name _;
    auth_basic "Restricted Access";
    auth_basic_user_file /etc/nginx/.htpasswd;
    location / {
        proxy_pass http://tasks-manager:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

# 5. Deploy
./deploy.sh

# 6. Access at http://YOUR_IP:8080 with username/password
```

---

## Troubleshooting

### "Cannot find module 'express'" error
- This happens if `package-lock.json` exists but is corrupted or incompatible
- Remove `server/package-lock.json` and rebuild
- Use `npm install` not `npm ci` in Dockerfile

### npm registry DNS errors during build (`EAI_AGAIN`)
- Build with `--network=host` flag: `docker build --network=host -t tasks-manager .`
- Or configure Docker DNS in `/etc/docker/daemon.json`: `{"dns":["8.8.8.8","8.8.4.4"]}`

### Port already in use
- Check what's using it: `sudo lsof -i :PORT`
- Stop the conflicting service or change the port mapping

### Container keeps restarting
- Check logs: `docker logs tasks-manager` or `docker-compose logs tasks-manager`
- Common issues: missing dependencies, port conflicts, permission errors

### Authentication not working
- Verify `task.htpasswd` exists and is mounted in nginx container: `docker-compose exec nginx-proxy ls -la /etc/nginx/.htpasswd`
- Check nginx logs: `docker-compose logs nginx-proxy`
- Ensure `task.conf` is correct and has `auth_basic` directives

---

## Development

The project consists of:
- `index.html` — Complete frontend (HTML + CSS + JavaScript)
- `server/` — Node.js/Express backend API server
- `Dockerfile` — Docker image definition
- `docker-compose.yml` — Multi-container orchestration
- `deploy.sh` — Automated deployment script
- `backup.sh` / `restore.sh` — Data backup/restore utilities

To modify the frontend, edit `index.html` directly.
To modify the backend API, edit `server/server.js`.

---

## License

Free to use for personal projects.
