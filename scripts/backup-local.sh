#!/bin/bash
set -e

# Personalized backup script for Mayank's VPS
# Backs up clepto_os database to /backups/ folder

BACKUP_DIR="/backups/clepto"
RETENTION_DAYS=7
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Create backup directory
mkdir -p $BACKUP_DIR

echo "🔄 Starting Clepto OS database backup..."

# Backup database (using container name from docker-compose.yml)
docker exec clepto-db pg_dump -U ${PG_USER:-postgres} ${PG_DATABASE:-clepto_os} | gzip > \
  $BACKUP_DIR/clepto-db-$TIMESTAMP.sql.gz

echo "✅ Backup created: clepto-db-$TIMESTAMP.sql.gz"

# Clean old backups (keep last 7 days)
find $BACKUP_DIR -name "clepto-db-*.sql.gz" -mtime +$RETENTION_DAYS -delete

echo "🧹 Cleaned backups older than $RETENTION_DAYS days"
echo "📊 Current backups:"
ls -lh $BACKUP_DIR/

echo "✅ Backup completed successfully!"
