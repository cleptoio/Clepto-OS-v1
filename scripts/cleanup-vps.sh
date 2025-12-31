#!/bin/bash
#
# Clepto OS - VPS Cleanup Script
# Removes all Clepto OS services while preserving Traefik and n8n
#
# Usage: sudo bash scripts/cleanup-vps.sh
#

set -e

echo "🧹 Clepto OS - VPS Cleanup"
echo "=========================="
echo ""
echo "⚠️  This will remove:"
echo "  - All Clepto OS Docker containers"
echo "  - All Clepto OS Docker volumes (databases will be deleted!)"
echo "  - /opt/clepto directory"
echo "  - /opt/clepto-crm directory (if exists)"
echo ""
echo "✅ This will KEEP:"
echo "  - root-traefik-1 (your existing Traefik)"
echo "  - root-n8n-1 (your existing n8n)"
echo "  - root_default network"
echo ""
read -p "Are you SURE you want to proceed? (type 'yes' to confirm): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Cleanup cancelled."
    exit 0
fi

echo ""
echo "🛑 [1/5] Stopping Clepto OS containers..."

# Stop and remove Clepto OS containers
docker stop clepto-db clepto-redis twenty-server twenty-worker clepto-api 2>/dev/null || true
docker rm clepto-db clepto-redis twenty-server twenty-worker clepto-api 2>/dev/null || true

echo "✅ Containers stopped and removed"

echo ""
echo "🗑️  [2/5] Removing Docker volumes..."

# Remove Clepto OS volumes
docker volume rm clepto-postgres-data clepto-redis-data clepto-uploads 2>/dev/null || true
docker volume rm infra_postgres-data infra_redis-data infra_clepto-uploads 2>/dev/null || true

echo "✅ Volumes removed"

echo ""
echo "🗑️  [3/5] Removing Clepto OS directories..."

# Remove Clepto OS directories
rm -rf /opt/clepto
rm -rf /opt/clepto-crm

echo "✅ Directories removed"

echo ""
echo "🧹 [4/5] Cleaning up Docker system..."

# Remove unused Docker images and networks
docker system prune -f

echo "✅ Docker system cleaned"

echo ""
echo "🔍 [5/5] Verifying remaining containers..."

echo ""
echo "Active containers:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "✅ Cleanup Complete!"
echo "==================="
echo ""
echo "📊 Summary:"
echo "  ✅ All Clepto OS services removed"
echo "  ✅ All Clepto OS data deleted"
echo "  ✅ Traefik and n8n preserved"
echo ""
echo "💾 Disk space freed:"
df -h / | tail -1 | awk '{print "  " $4 " available"}'
echo ""
echo "🎉 Your VPS is clean and happy!"
