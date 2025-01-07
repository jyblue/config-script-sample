#!/bin/bash

REDIS_GROUP="redis"
if ! getent group "$REDIS_GROUP" > /dev/null; then
    echo "Group $REDIS_GROUP does not exist. Proceeding to create the group."
    groupadd "$REDIS_GROUP"
    if [ $? -eq 0 ]; then
        echo "group $REDIS_GROUP successfully created."
    else
        echo "Failed to create group $REDIS_GROUP. Aborting setup script."
        exit 1
    fi
else
    echo "Group $REDIS_GROUP already exists. No action needed."
fi

REDIS_USER="redis"
if ! id "$REDIS_USER" > /dev/null 2>&1; then
    echo "User $REDIS_USER does not exist. Creating the user..."
    useradd -r -g "$REDIS_GROUP" -M "$REDIS_USER"
    if [ $? -eq 0 ]; then
        echo "User $REDIS_USER successfully created."
    else
        echo "Failed to create user $REDIS_USER. Aborting setup script."
        exit 1
    fi
else
    echo "User $REDIS_USER already exists. No action needed."
fi

TARGET_DIR="/etc/redis"
echo "Step 01: Checking if directory $TARGET_DIR exists..."
if [ ! -d "$TARGET_DIR" ]; then
    echo "Diriectory $TARGET_DIR does not exist. Proceeding to create the directory."
    mkdir -p "$TARGET_DIR"
    if [ $? -eq 0 ]; then
        echo "Diriectory $TARGET_DIR successfully created."
    else
        echo "Failed to create directory $TARGET_DIR. Aborting setup script."
        exit 1
    fi
else
    echo "Diriectory $TARGET_DIR already exists. No action needed."
fi

TARGET_DIR="/var/log/redis"
echo "Step 02: Checking if directory $TARGET_DIR exists..."
if [ ! -d "$TARGET_DIR" ]; then
    echo "Diriectory $TARGET_DIR does not exist. Proceeding to create the directory."
    mkdir -p "$TARGET_DIR"
    if [ $? -eq 0 ]; then
        echo "Diriectory $TARGET_DIR successfully created."
    else
        echo "Failed to create directory $TARGET_DIR. Aborting setup script."
        exit 1
    fi
else
    echo "Diriectory $TARGET_DIR already exists. No action needed."
fi

echo "Changing ownership of $TARGET_DIR to $REDIS_USER..."
chown -R "$REDIS_USER" "$TARGET_DIR"
if [ $? -eq 0 ]; then
    echo "Ownership of $TARGET_DIR successfully changed to $REDIS_USER."
else
    echo "Failed to change ownership of $TARGET_DIR to $REDIS_USER."
    exit 1
fi

TARGET_DIR="/var/lib/redis"
echo "Step 03: Checking if directory $TARGET_DIR exists..."
if [ ! -d "$TARGET_DIR" ]; then
    echo "Diriectory $TARGET_DIR does not exist. Proceeding to create the directory."
    mkdir -p "$TARGET_DIR"
    if [ $? -eq 0 ]; then
        echo "Diriectory $TARGET_DIR successfully created."
    else
        echo "Failed to create directory $TARGET_DIR. Aborting setup script."
        exit 1
    fi
else
    echo "Diriectory $TARGET_DIR already exists. No action needed."
fi

echo "Changing ownership of $TARGET_DIR to $REDIS_USER..."
chown -R "$REDIS_USER" "$TARGET_DIR"
if [ $? -eq 0 ]; then
    echo "Ownership of $TARGET_DIR successfully changed to $REDIS_USER."
else
    echo "Failed to change ownership of $TARGET_DIR to $REDIS_USER."
    exit 1
fi

SOURCE_FILE="./redis-6379.conf"
DESTINATION_FILE="/etc/redis/redis-6379.conf"
echo "Step 04: Copy and overwrite $DESTINATION_FILE ..."
if [ ! -f "$SOURCE_FILE" ]; then
    echo "Source file $SOURCE_FILE does not exist. Aborting setup script."
    exit 1
fi
cp -f "$SOURCE_FILE" "$DESTINATION_FILE"
if [ $? -eq 0 ]; then
    echo "File successfully copied from $SOURCE_FILE to $DESTINATION_FILE."
else
    echo "Failed to copy file. Aborting setup script."
fi

SOURCE_FILE="./redis-server-6379.service"
DESTINATION_FILE="/etc/systemd/system/redis-server-6379.service"
echo "Step 05: Copy and overwrite $DESTINATION_FILE ..."
if [ ! -f "$SOURCE_FILE" ]; then
    echo "Source file $SOURCE_FILE does not exist. Aborting setup script."
    exit 1
fi
cp -f "$SOURCE_FILE" "$DESTINATION_FILE"
if [ $? -eq 0 ]; then
    echo "File successfully copied from $SOURCE_FILE to $DESTINATION_FILE."
else
    echo "Failed to copy file. Aborting setup script."
fi

SERVICE_NAME="redis-server-6379"
systemctl stop $SERVICE_NAME
echo "Step 06: Stop service $SERVICE_NAME ..."
if [ $? -eq 0 ]; then
    echo "Service $SERVICE_NAME successfully stopped."
else
    echo "Failed to stop service $SERVICE_NAME. Aborting setup script."
fi

systemctl daemon-reload
echo "Step 07: systemd daemon reloading ..."
if [ $? -eq 0 ]; then
    echo "systemd daemon successfully reloaded."
else
    echo "Failed to reload systemd daemon. Aborting setup script."
fi

systemctl enable $SERVICE_NAME
echo "Step 08: Enabling service $SERVICE_NAME ..."
if [ $? -eq 0 ]; then
    echo "Service $SERVICE_NAME successfully enabled."
else
    echo "Failed to enable service $SERVICE_NAME. Aborting setup script."
fi

systemctl start $SERVICE_NAME
echo "Step 09: Starting service $SERVICE_NAME ..."
if [ $? -eq 0 ]; then
    echo "Service $SERVICE_NAME successfully started.."
else
    echo "Failed to start service $SERVICE_NAME. Aborting setup script."
fi
