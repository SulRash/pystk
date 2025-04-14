#!/bin/bash

# Script to update cmake_minimum_required VERSION to 3.5 in all CMakeLists.txt files
# Handles both uppercase and lowercase command names, and both X.Y and X.Y.Z version formats

echo "Searching for CMakeLists.txt files..."

# Find all CMakeLists.txt files (ignore case)
for file in $(find . -type f -name "[Cc][Mm][Aa][Kk][Ee][Ll][Ii][Ss][Tt][Ss].txt"); do
    if [ -f "$file" ]; then
        echo "Processing: $file"
        
        # Create a backup
        cp "$file" "${file}.bak"
        
        # Check if the file has cmake_minimum_required (case insensitive)
        if grep -i "cmake_minimum_required" "$file" || grep -i "CMAKE_MINIMUM_REQUIRED" "$file"; then
            # Handle uppercase X.Y.Z format
            sed -i.tmp1 "s/CMAKE_MINIMUM_REQUIRED(VERSION [0-9]\.[0-9]\.[0-9])/CMAKE_MINIMUM_REQUIRED(VERSION 3.5)/g" "$file"
            
            # Handle uppercase X.Y format
            sed -i.tmp2 "s/CMAKE_MINIMUM_REQUIRED(VERSION [0-9]\.[0-9])/CMAKE_MINIMUM_REQUIRED(VERSION 3.5)/g" "$file"
            
            # Handle lowercase X.Y.Z format
            sed -i.tmp3 "s/cmake_minimum_required(VERSION [0-9]\.[0-9]\.[0-9])/cmake_minimum_required(VERSION 3.5)/g" "$file"
            
            # Handle lowercase X.Y format
            sed -i.tmp4 "s/cmake_minimum_required(VERSION [0-9]\.[0-9])/cmake_minimum_required(VERSION 3.5)/g" "$file"
            
            # Clean up temp files
            rm -f "${file}.tmp1" "${file}.tmp2" "${file}.tmp3" "${file}.tmp4"
            
            # Verify the result
            if grep -i "cmake_minimum_required(VERSION 3.5)" "$file" || grep -i "CMAKE_MINIMUM_REQUIRED(VERSION 3.5)" "$file"; then
                echo "✓ Updated: $file"
            else
                echo "! Warning: Could not update version in $file"
                echo "  Current version line:"
                grep -i "cmake_minimum_required" "$file" || grep -i "CMAKE_MINIMUM_REQUIRED" "$file"
            fi
        else
            echo "- No cmake_minimum_required found in $file"
            rm -f "${file}.bak"  # Remove unnecessary backup
        fi
    fi
done

echo "Process completed. Original files were backed up with .bak extension."
