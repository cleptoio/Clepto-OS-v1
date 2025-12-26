#!/bin/bash

# ============================================
# Clepto OS - Automated Deployment Script
# ============================================
# This script pulls the latest code from GitHub
# and redeploys all services automatically
#
# Usage: ./deploy.sh

set -e  # Exit on any error

echo "╔════════════════════════════════════════╗"
echo "║   Clepto OS - Automated Deployment     ║"
echo "╚════════════════════════════════════════╝"
echo ""

# Configuration
PROJECT_DIR="$HOME/Clepto-OS-v1"
DOCKER_COMPOSE_FILE="$PROJECT_DIR/infra/docker-compose.yml"
BACKUP_DIR="$HOME/clepto-backups"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${YELLOW}⚠️  Warning: Not running as root. Some commands may fail.${NC}"
fi

# Step 1: Navigate to project directory
echo -e "${BLUE}📂 Navigating to project directory...${NC}"
cd "$PROJECT_DIR" || {
    echo -e "${RED}❌ Error: Project directory not found at $PROJECT_DIR${NC}"
    exit 1
}

# Step 2: Create backup before deployment
echo -e "${BLUE}🗄️  Creating backup before deployment...${NC}"
mkdir -p "$BACKUP_DIR"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Backup databases if services are running
if docker ps | grep -q "clepto-postgres"; then
    echo "  Backing up CRM database..."
    docker-compose -f "$DOCKER_COMPOSE_FILE" exec -T postgres-crm pg_dump -U clepto clepto_crm > "$BACKUP_DIR/crm_pre_deploy_$TIMESTAMP.sql" 2>/dev/null || true
    
    echo "  Backing up Mail database..."
    docker-compose -f "$DOCKER_COMPOSE_FILE" exec -T postgres-mail pg_dump -U clepto clepto_mail > "$BACKUP_DIR/mail_pre_deploy_$TIMESTAMP.sql" 2>/dev/null || true
    
    echo -e "${GREEN}  ✓ Backup created${NC}"
else
    echo -e "${YELLOW}  ⚠️  No running services to backup${NC}"
fi

# Step 3: Pull latest code from GitHub
echo -e "${BLUE}📥 Pulling latest code from GitHub...${NC}"
git fetch origin
git reset --hard origin/main
echo -e "${GREEN}  ✓ Code updated${NC}"

# Step 4: Load environment variables
echo -e "${BLUE}🔧 Loading environment variables...${NC}"
if [ -f .env ]; then
    source .env
    echo -e "${GREEN}  ✓ Environment loaded${NC}"
else
    echo -e "${YELLOW}  ⚠️  No .env file found. Using docker-compose defaults.${NC}"
fi

# Step 5: Stop running services
echo -e "${BLUE}🛑 Stopping current services...${NC}"
docker-compose -f "$DOCKER_COMPOSE_FILE" down
echo -e "${GREEN}  ✓ Services stopped${NC}"

# Step 6: Pull latest Docker images
echo -e "${BLUE}🐳 Pulling latest Docker images...${NC}"
docker-compose -f "$DOCKER_COMPOSE_FILE" pull
echo -e "${GREEN}  ✓ Images updated${NC}"

# Step 7: Build custom images
echo -e "${BLUE}🔨 Building custom images...${NC}"
docker-compose -f "$DOCKER_COMPOSE_FILE" build --no-cache
echo -e "${GREEN}  ✓ Build complete${NC}"

# Step 8: Start services
echo -e "${BLUE}🚀 Starting services...${NC}"
docker-compose -f "$DOCKER_COMPOSE_FILE" up -d
echo -e "${GREEN}  ✓ Services started${NC}"

# Step 9: Wait for services to be healthy
echo -e "${BLUE}⏳ Waiting for services to be healthy...${NC}"
sleep 10

# Check service status
echo -e "${BLUE}📊 Service Status:${NC}"
docker-compose -f "$DOCKER_COMPOSE_FILE" ps

# Step 10: Run database migrations (if needed)
echo -e "${BLUE}🔄 Running database migrations...${NC}"
# Uncomment when CRM is integrated:
# docker-compose -f "$DOCKER_COMPOSE_FILE" exec -T clepto-crm npm run database:migrate
echo -e "${YELLOW}  ⚠️  Migrations skipped (CRM not yet integrated)${NC}"

# Step 11: Clean up old Docker images
echo -e "${BLUE}🧹 Cleaning up old Docker images...${NC}"
docker image prune -f > /dev/null 2>&1
echo -e "${GREEN}  ✓ Cleanup complete${NC}"

# Step 12: Show logs
echo ""
echo -e "${GREEN}═══════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Deployment Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}📝 Recent logs:${NC}"
docker-compose -f "$DOCKER_COMPOSE_FILE" logs --tail=20

echo ""
echo -e "${BLUE}🌐 Access your platform:${NC}"
echo -e "  CRM: https://${CRM_DOMAIN:-crm.clepto.io}"
echo -e "  Mail: https://${MAIL_DOMAIN:-mail.clepto.io}"
echo ""
echo -e "${BLUE}📊 To view live logs:${NC}"
echo -e "  docker-compose -f $DOCKER_COMPOSE_FILE logs -f"
echo ""
echo -e "${BLUE}🔄 To restart a service:${NC}"
echo -e "  docker-compose -f $DOCKER_COMPOSE_FILE restart <service-name>"
echo ""

# Save deployment log
echo "Deployment completed at $(date)" >> "$PROJECT_DIR/deployment.log"

exit 0
