#!/bin/bash
set -e

# ===== 1️⃣ Variables =====
WORKSPACE_DIR="/var/lib/jenkins/${Branch}"
REPO_URL="http://git.stratos.xfusioncorp.com/sarah/web_app.git"
DEPLOY_USER="natasha"
DEPLOY_HOST="ststor01"
DEPLOY_DIR="/var/www/html"

# SSH options to disable host key checking
SSH_OPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

# ===== 2️⃣ Prepare Workspace =====
echo "Creating workspace for branch ${Branch}..."
mkdir -p "$WORKSPACE_DIR"
cd "$WORKSPACE_DIR"

# If repo is already cloned, fetch latest changes
if [ -d ".git" ]; then
    echo "Fetching latest changes for branch ${Branch}..."
    git fetch origin
    git reset --hard origin/${Branch}
else
    echo "Cloning repository for branch ${Branch}..."
    git clone -b ${Branch} $REPO_URL .
fi

# ===== 3️⃣ Deploy to Storage Server using SCP =====
echo "Deploying code to ${DEPLOY_HOST}:${DEPLOY_DIR}..."

# Create deployment directory on server if it doesn't exist
ssh $SSH_OPTS ${DEPLOY_USER}@${DEPLOY_HOST} "mkdir -p ${DEPLOY_DIR}"

# Copy all files from workspace to server
scp $SSH_OPTS -r ${WORKSPACE_DIR}/* ${DEPLOY_USER}@${DEPLOY_HOST}:${DEPLOY_DIR}/

echo "Deployment of branch ${Branch} completed successfully!"
