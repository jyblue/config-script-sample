#!/bin/bash

TARGET_DIR="/etc/redis"
echo "Step 01: Checking if directory $TARGET_DIR exists..."
if [ ! -d "$TARGET_DIR" ]; then
    echo "Diriectory $TARGET_DIR does not exist. Proceeding to create the directory.
    mkdir -p "$TARGET_DIR"
    if [ $? -eq 0 ]; then
        echo "Diriectory $TARGET_DIT successfully created."
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
    echo "Diriectory $TARGET_DIR does not exist. Proceeding to create the directory.
    mkdir -p "$TARGET_DIR"
    if [ $? -eq 0 ]; then
        echo "Diriectory $TARGET_DIT successfully created."
    else
        echo "Failed to create directory $TARGET_DIR. Aborting setup script."
        exit 1
    fi
else
    echo "Diriectory $TARGET_DIR already exists. No action needed."
fi

TARGET_DIR="/var/lib/redis"
echo "Step 03: Checking if directory $TARGET_DIR exists..."
if [ ! -d "$TARGET_DIR" ]; then
    echo "Diriectory $TARGET_DIR does not exist. Proceeding to create the directory.
    mkdir -p "$TARGET_DIR"
    if [ $? -eq 0 ]; then
        echo "Diriectory $TARGET_DIT successfully created."
    else
        echo "Failed to create directory $TARGET_DIR. Aborting setup script."
        exit 1
    fi
else
    echo "Diriectory $TARGET_DIR already exists. No action needed."
fi
