#!/bin/bash

# Configuration
BACKUP_DIR="/home/gabriel/n8n"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="n8n_backup_${TIMESTAMP}.tar.gz"
REMOTE_NAME="n8n"
REMOTE_DIR="n8n_backups"

# Navigate to directory
cd $BACKUP_DIR

# 1. Dump Database
echo "Creating database dump..."
sudo docker exec n8n-postgres-1 pg_dump -U n8n n8n > n8n_full_backup.sql

# 2. Compress (DB + .env + JSON exports if exist)
echo "Compressing files..."
tar -czf $BACKUP_FILE .env n8n_full_backup.sql workflows.json credentials.json

# 3. Upload to Google Drive
echo "Uploading to Google Drive..."
rclone copy $BACKUP_FILE $REMOTE_NAME:$REMOTE_DIR

# 4. Cleanup
echo "Cleaning up..."
rm $BACKUP_FILE
rm n8n_full_backup.sql

echo "Backup complete: $BACKUP_FILE uploaded to $REMOTE_NAME:$REMOTE_DIR"
