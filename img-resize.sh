#!/bin/bash

# Check if imagemagick is installed
hash mogrify 2>/dev/null || {
   echo "Error: imagemagick not found"
   exit 1
}

# Initialize variables to hold the values of the "path" and "mtime" options
path=""
dimension=""
mtime=""

# Process command-line options
while [ "$1" != "" ]; do
    case "$1" in
        -p|--path)      path="$2"; shift;;
        -t|--mtime)     mtime="$2"; shift;;
        -d|--dimension) dimension="$2"; shift;;
        *) echo "Error: Unknown option $1"; exit 1;;
    esac
    shift
done

# exit if a path wasn't provided
[ -z "$path" ] && {
  echo "Error: No path provided"
  exit 1
}

# Set defaults
mtime=${mtime:-"-7"}
dimension=${dimension:-"2560"}

# address a "I/O error : buffer full" output
export BUFFER_SIZE=16000000

# Search for files in the specified directory and its subdirectories
# Exclude hidden files and directories (those that start with a dot)
# Only include regular files
# Only include files modified within the specified number of days
# Only include files with the .jpg, .jpeg, or .png extension
find "$path" \
   -not -path '*/.*' \
   -type f \
   -mtime $mtime \
   \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) \
   -print0 \
   | while IFS= read -r -d '' file; do
      # Resize larger images to the specified dimension
      # Quiet mode (only print error messages)
      mogrify -resize $dimension> -quiet "$file"
   done
