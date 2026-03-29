#!/bin/bash
set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

BACKUP_DIR="./backups"

echo -e "${YELLOW}Available backups:${NC}"
ls -lh "$BACKUP_DIR"/*.tar.gz 2>/dev/null || { echo -e "${RED}No backups found!${NC}"; exit 1; }

echo ""
read -p "Enter backup filename to restore: " BACKUP_FILE

if [ ! -f "$BACKUP_DIR/$BACKUP_FILE" ]; then
  echo -e "${RED}❌ File not found: $BACKUP_DIR/$BACKUP_FILE${NC}"
  exit 1
fi

echo -e "${YELLOW}⚠️  WARNING: This will OVERWRITE current data!${NC}"
read -p "Are you sure? (type 'yes' to confirm): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
  echo "Cancelled."
  exit 0
fi

# Stop container temporarily
echo -e "${YELLOW}Stopping container...${NC}"
docker stop tasks-manager 2>/dev/null || true

# Restore backup
echo -e "${YELLOW}Restoring from $BACKUP_FILE...${NC}"
docker run --rm \
  -v tasks-manager-data:/data \
  -v "$(pwd)/$BACKUP_DIR":/backup \
  alpine sh -c "rm -rf /data/* && tar xzf /backup/$BACKUP_FILE -C /data"

# Start container
echo -e "${YELLOW}Starting container...${NC}"
docker start tasks-manager 2>/dev/null || true

echo -e "${GREEN}✅ Restore complete!${NC}"
