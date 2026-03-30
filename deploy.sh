#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Deploying Tasks Manager (with Nginx Proxy + Auth)...${NC}"

# Check if we're in the right directory
if [ ! -f "Dockerfile" ] || [ ! -f "index.html" ] || [ ! -f "docker-compose.yml" ]; then
  echo -e "${RED}❌ Error: Must run from project root (with Dockerfile, index.html, docker-compose.yml)${NC}"
  exit 1
fi

# Check if required auth files exist
if [ ! -f "task.htpasswd" ]; then
  echo -e "${YELLOW}⚠️  task.htpasswd not found!${NC}"
  echo "Create it with: htpasswd -c ./task.htpasswd msa"
  exit 1
fi

if [ ! -f "task.conf" ]; then
  echo -e "${YELLOW}⚠️  task.conf (nginx config) not found!${NC}"
  exit 1
fi

# Stop existing containers
echo -e "${YELLOW}🧹 Stopping existing containers...${NC}"
docker-compose down 2>/dev/null || true

# Build image with network=host to fix npm DNS issues
echo -e "${YELLOW}🔨 Building Docker image (this may take 2-3 minutes)...${NC}"
docker build --no-cache --network=host -t tasks-manager .

# Start all services with docker-compose
echo -e "${YELLOW}▶️  Starting services...${NC}"
docker-compose up -d

# Wait for services to be healthy
echo -e "${YELLOW}⏳ Waiting for services to start...${NC}"
sleep 8

# Get server IP
SERVER_IP=$(hostname -I | awk '{print $1}')
if [ -z "$SERVER_IP" ]; then
  SERVER_IP="localhost"
fi

echo ""
echo -e "${GREEN}✅ Deployment complete!${NC}"
echo ""
echo "Services running:"
echo "   📱 App (with auth): http://$SERVER_IP:7778"
echo "   🔧 Backend API:      http://$SERVER_IP:3000 (direct, no auth - internal only)"
echo ""
echo "Authentication:"
echo "   Username: msa"
echo "   Password: (what you set with htpasswd)"
echo ""
echo -e "📋 Useful commands:"
echo "   View all logs:        docker-compose logs -f"
echo "   View nginx logs:      docker-compose logs -f nginx-proxy"
echo "   View app logs:        docker-compose logs -f tasks-manager"
echo "   Stop all:             docker-compose down"
echo "   Restart:              docker-compose restart"
echo "   Backup data:          ./backup.sh"
echo "   Check status:         docker-compose ps"
echo ""
echo -e "${YELLOW}💡 To update after git pull:${NC}"
echo "   git pull && ./deploy.sh"
echo ""
