#!/bin/bash

# === Config ===
DB_SERVER="stdb01.stratos.xfusioncorp.com"
DB_USER="peter"

BACKUP_SERVER="stbkp01.stratos.xfusioncorp.com"
BACKUP_USER="clint"

DB_NAME="kodekloud_db01"
MYSQL_USER="kodekloud_roy"
MYSQL_PASS="asdfgdsd"

BACKUP_FILE="db_$(date +%F).sql"
TMP_PATH="/tmp/${BACKUP_FILE}"
BACKUP_DEST="/home/clint/db_backups/${BACKUP_FILE}"

echo "===== Starting automated database backup ====="

# 1️⃣ Dump the database on DB server
ssh -o StrictHostKeyChecking=no ${DB_USER}@${DB_SERVER} "
    mysqldump -u${MYSQL_USER} -p${MYSQL_PASS} ${DB_NAME} > ${TMP_PATH}
"

if [ $? -ne 0 ]; then
    echo "❌ Database dump failed on DB server!"
    exit 1
else
    echo "✅ Database dump created successfully on ${DB_SERVER} (${TMP_PATH})"
fi

# 2️⃣ Copy dump from DB server → Backup server
ssh -o StrictHostKeyChecking=no ${DB_USER}@${DB_SERVER} "
    scp -o StrictHostKeyChecking=no ${TMP_PATH} ${BACKUP_USER}@${BACKUP_SERVER}:${BACKUP_DEST}
"

if [ $? -ne 0 ]; then
    echo "❌ Failed to copy dump to Backup Server!"
    exit 2
else
    echo "✅ Backup copied successfully to ${BACKUP_SERVER}:${BACKUP_DEST}"
fi

# 3️⃣ Clean up dump file on DB server
ssh -o StrictHostKeyChecking=no ${DB_USER}@${DB_SERVER} "
    rm -f ${TMP_PATH}
"

echo "🎉 Backup process completed successfully!"
