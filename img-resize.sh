#!/bin/bash

# Check if imagemagick is installed
hash mogrify 2>/dev/null || {
   echo "Error: imagemagick not found"
   exit 1
}

# Initialize variables to hold the values of the "path" and "mtime" options
path=""
maxwidth=""
mtime=""

# Process command-line options
while [ "$1" != "" ]; do
    case "$1" in
        -p|--path)      path="$2"; shift;;
        -t|--mtime)     mtime="$2"; shift;;
        -w|--max-width) maxwidth="$2"; shift;;
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
maxwidth=${maxwidth:-"2560"}

# address a "I/O error : buffer full" output
export BUFFER_SIZE=16000000

# Search for files in the specified directory and its subdirectories
# Exclude hidden files and directories (those that start with a dot)
# Only include regular files
# Only include files modified within the specified number of days
# Only include files with the .jpg, .jpeg or .png extension
find "$path" \
   -not -path '*/.*' \
   -type f \
   -mtime $mtime \
   \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) \
   -print0 \
   | while IFS= read -r -d '' file; do
      # skip images with widths less than the max width
      width=$(identify -format "%w" "$file")
      if [ "$width" -le "$maxwidth" ]; then
         continue
      fi
      
      # Resize remaining images to the specified max width
      # Quiet mode (only print error messages)
      # note: resize includes ">" just in case a smaller files creeps in (shouldn't happen).
      #       The reason identify is used above, to determine the width, is because mogrify
      #       rewrites all images even if they're smaller than max-width.
      mogrify -resize "$maxwidth>" -quiet "$file"
   done
