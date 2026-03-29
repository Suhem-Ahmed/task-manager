#!/bin/bash
set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="tasks-manager-data-backup-$TIMESTAMP.tar.gz"

echo -e "${GREEN}📦 Backing up Tasks Manager data...${NC}"

# Create backup directory if not exists
mkdir -p "$BACKUP_DIR"

# Run backup using Docker
docker run --rm \
  -v tasks-manager-data:/data \
  -v "$(pwd)/$BACKUP_DIR":/backup \
  alpine tar czf "/backup/$BACKUP_FILE" -C /data .

if [ $? -eq 0 ]; then
  echo -e "${GREEN}✅ Backup created: $BACKUP_DIR/$BACKUP_FILE${NC}"
  echo -e "   Size: $(du -h "$BACKUP_DIR/$BACKUP_FILE" | cut -f1)"
else
  echo -e "${RED}❌ Backup failed${NC}"
  exit 1
fi

# List all backups
echo ""
echo -e "Available backups:"
ls -lh "$BACKUP_DIR"/*.tar.gz 2>/dev/null | awk '{print "   "$9" ("$5")"}' || echo "   (none)"
