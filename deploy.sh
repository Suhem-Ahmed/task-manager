#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Deploying Tasks Manager...${NC}"

# Check if we're in the right directory
if [ ! -f "Dockerfile" ] || [ ! -f "index.html" ]; then
  echo -e "${RED}❌ Error: Must run from project root (where Dockerfile is)${NC}"
  exit 1
fi

# Pull latest from git (optional - uncomment if needed)
# echo -e "${YELLOW}📥 Pulling latest from git...${NC}"
# git pull

# Stop and remove existing container if exists
echo -e "${YELLOW}🧹 Cleaning up old container...${NC}"
docker stop tasks-manager 2>/dev/null || true
docker rm tasks-manager 2>/dev/null || true

# Build new image
echo -e "${YELLOW}🔨 Building Docker image...${NC}"
docker build -t tasks-manager .

# Run new container
echo -e "${YELLOW}▶️  Starting container...${NC}"
docker run -d \
  --name tasks-manager \
  --restart unless-stopped \
  -p 3000:3000 \
  -v tasks-manager-data:/app/data \
  tasks-manager

# Get server IP
SERVER_IP=$(hostname -I | awk '{print $1}')
if [ -z "$SERVER_IP" ]; then
  SERVER_IP="localhost"
fi

echo ""
echo -e "${GREEN}✅ Deployment complete!${NC}"
echo -e "   Access your app at: ${YELLOW}http://$SERVER_IP:3000${NC}"
echo ""
echo -e "📋 Useful commands:"
echo "   View logs:    docker logs -f tasks-manager"
echo "   Stop:         docker stop tasks-manager"
echo "   Start:        docker start tasks-manager"
echo "   Restart:      docker restart tasks-manager"
echo "   Backup data:  ./backup.sh"
echo "   Update:       ./deploy.sh (after git pull)"
echo ""
