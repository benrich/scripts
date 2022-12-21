#!/bin/bash

# Check if imagemagick is installed
hash mogrify 2>/dev/null || {
   echo "Error: imagemagick not found"
   exit 1
}

# Check if pngquant is installed
hash pngquant 2>/dev/null || {
   echo "Error: pngquant not found"
   exit 1
}

# Initialize variables to hold the values of the "path" and "mtime" options
path=""
mtime=""

# Process command-line options
while [ "$1" != "" ]; do
    case "$1" in
        -p|--path)      path="$2"; shift;;
        -t|--mtime)     mtime="$2"; shift;;
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

# Find all regular files in the specified directory and its subdirectories that are not hidden
# and have been modified within the specified number of days.
# Exclude hidden files and directories (those that start with a dot).
# Only include files with the .jpg or .jpeg extension.
# Print the names of the matching files, separated by null characters.
# Pipe the names to xargs, which will pass them as arguments to jpegoptim.
find "$path" \
   -not -path '*/.*' \
   -type f \
   -mtime $mtime \
   \( -iname '*.jpg' -o -iname '*.jpeg' \) \
   -print0 \
   | xargs -0 jpegoptim -q --strip-all --max=80


# Find all regular files in the specified directory and its subdirectories that are not hidden
# and have been modified within the specified number of days.
# Exclude hidden files and directories (those that start with a dot).
# Only include files with the .png extension.
# Print the names of the matching files, separated by null characters.
# Pipe the names to xargs, which will pass them as arguments to pngquant.
find "$path" \
   -not -path '*/.*' \
   -type f \
   -mtime $mtime \
   -iname '*.png' \
   -print0 \
   | xargs -0 pngquant -q --force --ext .png --quality=80-95 --strip --skip-if-larger
