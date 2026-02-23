#!/bin/bash
# Usage: dropbox_to_s3 <dropbox_url> <dest_key>
# Example: dropbox_to_s3 "https://www.dropbox.com/s/xxx/file.zip" "uploads/20241435/file.zip"

set -e

DROPBOX_URL=$1
DEST_KEY=$2

if [ -z "$DROPBOX_URL" ] || [ -z "$DEST_KEY" ]; then
    echo "Usage: dropbox_to_s3 <dropbox_url> <dest_key>"
    exit 1
fi

TMPFILE=/tmp/$(basename "$DEST_KEY")

# strip ?dl=0 if present and force download
DROPBOX_URL="${DROPBOX_URL%%\?*}?dl=1"

echo "Downloading from Dropbox to $TMPFILE..."
wget -c --progress=bar -O "$TMPFILE" "$DROPBOX_URL" || { echo "ERROR: download failed"; rm -f "$TMPFILE"; exit 1; }

echo "Uploading to s3://floswald/${DEST_KEY}..."
aws s3 cp "$TMPFILE" "s3://floswald/${DEST_KEY}" \
  --endpoint-url "https://${AWS_S3_ENDPOINT}" || { echo "ERROR: upload failed"; exit 1; }

echo "Done! Cleaning up..."
rm -f "$TMPFILE"
echo "Success: s3://floswald/${DEST_KEY}"