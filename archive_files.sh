#!/bin/bash

BASE_DIR="${BASE_DIR:-./probafeladat_1_resz}"
REMOTE_DIR="${REMOTE_DIR:-s3://archive-bucket-for-old-files}"
ARCHIVE_DIR="./archive"

CURRENT_DATE=$(date '+%Y-%m-%d')
MAX_AGE=30

mkdir -p "$ARCHIVE_DIR"

# find old folders and move them to .zip on target, delete archived folders form original directory
find "$BASE_DIR" -mindepth 1 -maxdepth 1 -type d | grep -E '[0-9]{4}-[0-9]{2}-[0-9]{2}'| while read -r dir
do
    DIR_NAME=$(basename "$dir")
    
    # Get the date from the directory name
    DIR_DATE=$(echo "$DIR_NAME" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}')
    DIFF_DATE=$(( ( $(date -d "$CURRENT_DATE" +%s) - $(date -d "$DIR_DATE" +%s) ) / 86400 ))
    
    if [ $DIFF_DATE -gt $MAX_AGE ]
    then
        ZIP_FILE="$ARCHIVE_DIR/$DIR_NAME.zip"
        zip -r "$ZIP_FILE" "$dir"
        
        # Move the zipped directories to the AWS S3 Bucket
        aws s3 cp "$ZIP_FILE" "$REMOTE_DIR"

        # Check if dir was archived successfully, if so, delete the original directory
        if [ $? -eq 0 ]
        then
            rm "$ZIP_FILE"
            rm -r "$dir"
        else
            echo "Failed to archive $dir"
        fi
    fi
done

rm -r "$ARCHIVE_DIR"
