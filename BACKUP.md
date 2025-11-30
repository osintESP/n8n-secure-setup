# N8N Backup Strategy

This project includes a script to automate backups to Google Drive using `rclone`.

## Prerequisites

1.  **Install rclone**: `sudo apt install rclone`
2.  **Configure Remote**: Run `rclone config` and create a remote named `n8n` connected to your Google Drive.

## Manual Backup

Run the script manually:

```bash
./backup.sh
```

## Automated Backup (Cron)

To run the backup daily at 3 AM:

1.  Open crontab: `crontab -e`
2.  Add the following line:
    ```bash
    0 3 * * * /home/gabriel/n8n/backup.sh >> /home/gabriel/n8n/backup.log 2>&1
    ```

## Restore

To restore a backup:

1.  Download the `.tar.gz` file from Google Drive.
2.  Extract it: `tar -xzf n8n_backup_YYYYMMDD.tar.gz`
3.  Follow the **Migration Guide** (Option B) to restore the database dump (`n8n_full_backup.sql`) and `.env` file.
