#!/bin/bash
# Usage: dropbox_to_s3 <dropbox_url> <dest_key>
# Example: dropbox_to_s3 "https://www.dropbox.com/s/xxx/file.zip" "uploads/20241435/file.zip"
# you need to change your username if you are not me

set -e

DROPBOX_URL=$1
DEST_KEY=$2

if [ -z "$DROPBOX_URL" ] || [ -z "$DEST_KEY" ]; then
    echo "Usage: dropbox_to_s3 <dropbox_url> <dest_key>"
    exit 1
fi

# strip ?dl=0 if present and force download
DROPBOX_URL="${DROPBOX_URL%%\?*}?dl=1"

echo "Streaming from Dropbox to s3://floswald/${DEST_KEY}..."

curl -L --progress-bar "$DROPBOX_URL" | \
aws s3 cp - "s3://floswald/${DEST_KEY}" \
  --endpoint-url "https://${AWS_S3_ENDPOINT}"
