#!/bin/bash

# Configuration
REDIS_GROUP="redis"
REDIS_USER="redis"
DIRECTORIES=(
  "/etc/redis"
  "/var/log/redis"
  "/var/lib/redis"
)
CONFIG_FILES=(
  "./redis-6379.conf:/etc/redis/redis-6379.conf"
  "./redis-server-6379.service:/etc/systemd/system/redis-server-6379.service"
)
SERVICE_NAME="redis-server-6379"

# Utility function to log messages
log() {
    echo "[INFO] $1"
}

error_exit() {
    echo "[ERROR] $1"
    exit 1
}

# Ensure group exists
log "Checking if group $REDIS_GROUP exists..."
if ! getent group "$REDIS_GROUP" > /dev/null; then
    log "Group $REDIS_GROUP does not exist. Creating the group."
    groupadd "$REDIS_GROUP" || error_exit "Failed to create group $REDIS_GROUP."
    log "Group $REDIS_GROUP successfully created."
else
    log "Group $REDIS_GROUP already exists."
fi

# Ensure user exists
log "Checking if user $REDIS_USER exists..."
if ! id "$REDIS_USER" > /dev/null 2>&1; then
    log "User $REDIS_USER does not exist. Creating the user."
    useradd -r -g "$REDIS_GROUP" -M "$REDIS_USER" || error_exit "Failed to create user $REDIS_USER."
    log "User $REDIS_USER successfully created."
else
    log "User $REDIS_USER already exists."
fi

# Ensure directories exist and set ownership
for DIR in "${DIRECTORIES[@]}"; do
    log "Checking if directory $DIR exists..."
    if [ ! -d "$DIR" ]; then
        log "Directory $DIR does not exist. Creating the directory."
        mkdir -p "$DIR" || error_exit "Failed to create directory $DIR."
        log "Directory $DIR successfully created."
    else
        log "Directory $DIR already exists."
    fi

    log "Changing ownership of $DIR to $REDIS_USER..."
    chown -R "$REDIS_USER:$REDIS_GROUP" "$DIR" || error_exit "Failed to change ownership of $DIR to $REDIS_USER."
    log "Ownership of $DIR successfully changed to $REDIS_USER."

done

# Copy configuration files
for FILE_PAIR in "${CONFIG_FILES[@]}"; do
    IFS=":" read -r SRC DEST <<< "$FILE_PAIR"
    log "Checking if source file $SRC exists..."
    [ -f "$SRC" ] || error_exit "Source file $SRC does not exist."

    log "Copying $SRC to $DEST..."
    cp -f "$SRC" "$DEST" || error_exit "Failed to copy $SRC to $DEST."
    log "File successfully copied from $SRC to $DEST."

done

# Manage systemd service
log "Stopping service $SERVICE_NAME if running..."
systemctl stop "$SERVICE_NAME" || log "Service $SERVICE_NAME is not running or failed to stop."

log "Reloading systemd daemon..."
systemctl daemon-reload || error_exit "Failed to reload systemd daemon."

log "Enabling service $SERVICE_NAME..."
systemctl enable "$SERVICE_NAME" || error_exit "Failed to enable service $SERVICE_NAME."

log "Starting service $SERVICE_NAME..."
systemctl start "$SERVICE_NAME" || error_exit "Failed to start service $SERVICE_NAME."

log "Setup completed successfully!"
