# Script accepts two arguments, 
# the first is the path to the import directory,
# the second is the path to the export directory
# The script will move all files from the import directory to the export directory
# Filenames will be prefixed with the current date and time
# The script will also create a log file in the export directory
{pkgs}:

pkgs.writeShellScriptBin "endoreg-import-file-mover" ''
#!/usr/bin/env bash

# Check if two arguments are passed
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 IMPORT_DIRECTORY EXPORT_DIRECTORY"
  exit 1
fi

IMPORT_DIR="$1"
EXPORT_DIR="$2"

# Create the log file and start logging
echo "Starting file move operation at $(date +'%Y-%m-%d %H:%M:%S')"

# Check if the import directory exists
if [ ! -d "$IMPORT_DIR" ]; then
  echo "Import directory does not exist: $IMPORT_DIR"
  exit 1
fi

# Check if the export directory exists, create if it does not
if [ ! -d "$EXPORT_DIR" ]; then
  mkdir -p "$EXPORT_DIR"
fi

# Move and rename files
for file in "$IMPORT_DIR"/*; do
  if [ -f "$file" ]; then
    TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')
    FILENAME=$(basename "$file")
    mv "$file" "$EXPORT_DIR/$TIMESTAMP-$FILENAME"
    echo "Moved $file to $EXPORT_DIR/$TIMESTAMP-$FILENAME"
  fi
done

echo "File move operation completed at $(date +'%Y-%m-%d %H:%M:%S')"
''
