#!/bin/bash

# Check if cwebp is installed
hash cwebp 2>/dev/null || {
   echo "Error: cwebp not found"
   exit 1
}

# Initialize variables to hold the values of the "path" and "mtime" options
# path=""
# dimension=""

# Check if a directory was specified
if [ $# -eq 0 ]; then
  echo "Error: No directory specified."
  exit 1
fi


# source: https://www.digitalocean.com/community/tutorials/how-to-create-and-serve-webp-images-to-speed-up-your-website


# convert JPEG images
find $1 -type f -and \( -iname "*.jpg" -o -iname "*.jpeg" \) \
-exec bash -c '
webp_path="$0.webp";
if [ ! -f "$webp_path" ]; then 
  cwebp -quiet -q 75 "$0" -o "$webp_path";
fi;' {} \;


# convert PNG images
find $1 -type f -and -iname "*.png" \
-exec bash -c '
webp_path="$0.webp";
if [ ! -f "$webp_path" ]; then 
  cwebp -quiet -lossless "$0" -o "$webp_path";
fi;' {} \;


# shortcomings
#
# 1) cwebp has the resize option but it will apply the resize to all sizes.  Not just dimensions that are bigger
# possible workaround but has errors and maybe slow
# find images -type f -iname '*.webp' | xargs -I {} identify -format '%w %i\n' {} | awk '$1 > 2048 {print $2}' | xargs -0 cwebp -resize $dimension 0 
