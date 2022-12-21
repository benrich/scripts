#!/bin/bash

# Check if webp is installed
hash cwebp 2>/dev/null || {
   echo "Error: webp not found"
   exit 1
}

# # Check if imagemagick is installed
# hash identify 2>/dev/null || {
#    echo "Error: imagemagick not found"
#    exit 1
# }

# Initialize variables to hold the values of the "path" and "mtime" options
path=""
# maxwidth=""

# Process command-line options
while [ "$1" != "" ]; do
    case "$1" in
        -p|--path)      path="$2"; shift;;
        # -w|--max-width) maxwidth="$2"; shift;;
        *) echo "Error: Unknown option $1"; exit 1;;
    esac
    shift
done

# Check if a directory was specified
[ -z "$path" ] && {
  echo "Error: No path provided"
  exit 1
}


# source: https://www.digitalocean.com/community/tutorials/how-to-create-and-serve-webp-images-to-speed-up-your-website


# convert JPEG images
find "$path" -type f -and \( -iname "*.jpg" -o -iname "*.jpeg" \) \
-exec bash -c '
webp_path="$0.webp";
if [ ! -f "$webp_path" ]; then 
  cwebp -quiet -q 75 "$0" -o "$webp_path";
fi;' {} \;


# convert PNG images
find "$path" -type f -and -iname "*.png" \
-exec bash -c '
webp_path="$0.webp";
if [ ! -f "$webp_path" ]; then 
  cwebp -quiet -lossless "$0" -o "$webp_path";
fi;' {} \;


# # shortcoming: cwebp has the resize option but it will apply the resize to all sizes.  Not just dimensions that are bigger
# # workaround 1: run the resize script before this one
# # workaround 2: find large images with identify and resize those (** !! UNTESTED !! **)
# find "$path" -type f -iname '*.webp' | xargs -I {} identify -format '%w %i\n' {} | awk '$1 > $maxwidth {print $2}' | xargs -0 cwebp -resize $maxwidth 0
