#!/bin/bash

# === Servers ===
APP_SERVER="stapp02.stratos.xfusioncorp.com"
STORAGE_SERVER="ststor01.stratos.xfusioncorp.com"

# === Users (credential-injected by SSH Agent) ===
APP_USER="steve"
STORAGE_USER="natasha"

# === Log paths ===
LOG_PATH="/var/log/httpd"
ACCESS_LOG="access_log"
ERROR_LOG="error_log"
STORAGE_DIR="/usr/src/devops"

echo "===== Starting Apache log copy ====="

# 1️⃣ Copy logs from App Server 2 to Jenkins workspace
ssh -o StrictHostKeyChecking=no ${APP_USER}@${APP_SERVER} "cat ${LOG_PATH}/${ACCESS_LOG}" > ${ACCESS_LOG}
ssh -o StrictHostKeyChecking=no ${APP_USER}@${APP_SERVER} "cat ${LOG_PATH}/${ERROR_LOG}" > ${ERROR_LOG}

# 2️⃣ Copy logs from Jenkins workspace → Storage Server
scp -o StrictHostKeyChecking=no ${ACCESS_LOG} ${STORAGE_USER}@${STORAGE_SERVER}:${STORAGE_DIR}/
scp -o StrictHostKeyChecking=no ${ERROR_LOG} ${STORAGE_USER}@${STORAGE_SERVER}:${STORAGE_DIR}/

# 3️⃣ Clean up workspace
rm -f ${ACCESS_LOG} ${ERROR_LOG}

echo "✅ Apache logs copied successfully using Jenkins SSH credentials!"
