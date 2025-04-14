#!/bin/bash

# Find the path where the script is running
CURRENT_DIR=$(pwd)

# Navigate to the freetype directory
cd "$CURRENT_DIR/lib/freetype" || {
  echo "Error: Cannot find lib/freetype directory"
  exit 1
}

echo "Looking for files with Byte type issues..."

# First fix the primary configuration file
FTZCONF_PATH="src/gzip/ftzconf.h"
if [ -f "$FTZCONF_PATH" ]; then
  echo "Fixing $FTZCONF_PATH"
  
  # Create backup
  cp "$FTZCONF_PATH" "$FTZCONF_PATH.bak"
  
  # Insert the Byte definition before the first usage
  # Uses sed to insert before line where "typedef Byte FAR Bytef;" appears
  sed -i.tmp '/typedef Byte  FAR Bytef;/i\
typedef unsigned char Byte;  /* 8 bits */
' "$FTZCONF_PATH"
  
  echo "✓ Added Byte definition to $FTZCONF_PATH"
else
  echo "Warning: Could not find $FTZCONF_PATH"
  
  # Try to find all relevant files with "Byte" reference issues
  echo "Searching for all files that might need fixing..."
  
  # Find all C files in the gzip directory
  find src/gzip -name "*.c" -o -name "*.h" | while read -r file; do
    if grep -q "Byte" "$file"; then
      echo "Checking $file"
      
      # Create backup
      cp "$file" "$file.bak"
      
      # Add Byte definition at the beginning of the file, after includes
      sed -i.tmp '/#include/!b;:a;n;/#include/ba;i\
typedef unsigned char Byte;  /* 8 bits */
' "$file"
      
      echo "✓ Added Byte definition to $file"
    fi
  done
fi

# Clean up temporary files
find src -name "*.tmp" -delete

echo "Fix completed. Original files have been backed up with .bak extension."
echo "You can now try building again."
