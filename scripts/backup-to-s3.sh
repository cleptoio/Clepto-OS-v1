#!/bin/bash
set -e

BACKUP_DIR="/tmp/clepto-backup"
S3_BUCKET="clepto-backups-prod"
S3_REGION="us-east-1"
RETENTION_DAYS=30

mkdir -p $BACKUP_DIR

# Backup database
echo "Backing up database..."
docker exec clepto-db pg_dump -U postgres clepto_os | gzip > $BACKUP_DIR/clepto-db-$(date +%Y%m%d_%H%M%S).sql.gz

# Upload to S3
echo "Uploading to S3..."
aws s3 sync $BACKUP_DIR s3://$S3_BUCKET/ --region $S3_REGION

# Clean old backups from S3 (keep last 30 days)
echo "Cleaning old backups..."
aws s3 ls s3://$S3_BUCKET/ | while read -r line; do
  date=$(echo $line | awk '{print $1" "$2}')
  dateInSeconds=$(date -d "$date" +%s 2>/dev/null || date -j -f "%Y-%m-%d %H:%M:%S" "$date" +%s)
  now=$(date +%s)
  seconds=$((now - dateInSeconds))
  days=$((seconds / 86400))
  if [ $days -gt $RETENTION_DAYS ]; then
    fileName=$(echo $line | awk '{print $NF}')
    aws s3 rm s3://$S3_BUCKET/$fileName --region $S3_REGION
  fi
done

# Clean local
rm -rf $BACKUP_DIR

echo "✅ Backup completed!"
