#!/bin/bash

# ============================================
# Clepto OS - Database Backup Script
# ============================================
# Backs up all Clepto OS databases
# Can be run manually or scheduled via cron
#
# Usage: ./backup.sh

set -e

echo "╔════════════════════════════════════════╗"
echo "║   Clepto OS - Database Backup          ║"
echo "╚════════════════════════════════════════╝"
echo ""

# Configuration
BACKUP_DIR="$HOME/clepto-backups"
RETENTION_DAYS=7
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DATE_READABLE=$(date "+%Y-%m-%d %H:%M:%S")

# Create backup directory
mkdir -p "$BACKUP_DIR"

echo "📅 Backup started: $DATE_READABLE"
echo "📂 Backup directory: $BACKUP_DIR"
echo ""

# Backup CRM Database
echo "🗄️  Backing up CRM database..."
if docker ps | grep -q "clepto-postgres-crm"; then
    docker exec clepto-postgres-crm pg_dump -U clepto clepto_crm > "$BACKUP_DIR/crm_$TIMESTAMP.sql"
    
    # Compress the backup
    gzip "$BACKUP_DIR/crm_$TIMESTAMP.sql"
    
    FILESIZE=$(du -h "$BACKUP_DIR/crm_$TIMESTAMP.sql.gz" | cut -f1)
    echo "  ✓ CRM backup complete: crm_$TIMESTAMP.sql.gz ($FILESIZE)"
else
    echo "  ⚠️  CRM database container not running"
fi

# Backup Mail Database
echo "📧 Backing up Mail database..."
if docker ps | grep -q "clepto-postgres-mail"; then
    docker exec clepto-postgres-mail pg_dump -U clepto clepto_mail > "$BACKUP_DIR/mail_$TIMESTAMP.sql"
    
    # Compress the backup
    gzip "$BACKUP_DIR/mail_$TIMESTAMP.sql"
    
    FILESIZE=$(du -h "$BACKUP_DIR/mail_$TIMESTAMP.sql.gz" | cut -f1)
    echo "  ✓ Mail backup complete: mail_$TIMESTAMP.sql.gz ($FILESIZE)"
else
    echo "  ⚠️  Mail database container not running"
fi

# Cleanup old backups (keep only last N days)
echo ""
echo "🧹 Cleaning up old backups (keeping last $RETENTION_DAYS days)..."
find "$BACKUP_DIR" -name "*.sql.gz" -type f -mtime +$RETENTION_DAYS -delete
find "$BACKUP_DIR" -name "*.sql" -type f -mtime +$RETENTION_DAYS -delete

REMAINING=$(ls -1 "$BACKUP_DIR" | wc -l)
echo "  ✓ Cleanup complete. $REMAINING backups remaining."

# Show disk usage
echo ""
echo "💾 Backup directory size:"
du -sh "$BACKUP_DIR"

# List recent backups
echo ""
echo "📋 Recent backups:"
ls -lht "$BACKUP_DIR" | head -n 6

echo ""
echo "✅ Backup completed successfully!"
echo "🕒 Completed at: $(date "+%Y-%m-%d %H:%M:%S")"

# Optional: Upload to S3 (uncomment if needed)
# if [ ! -z "$BACKUP_S3_BUCKET" ]; then
#     echo ""
#     echo "☁️  Uploading to S3..."
#     aws s3 sync "$BACKUP_DIR" "s3://$BACKUP_S3_BUCKET/clepto-backups/"
#     echo "  ✓ S3 upload complete"
# fi

exit 0
