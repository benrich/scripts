#!/bin/bash

# Check if imagemagick is installed, and install it if not
command -v mogrify >/dev/null 2>&1 || {
    echo "imagemagick not found, installing now"
    sudo apt-get install imagemagick
}

# Initialize variables to hold the values of the "path" and "mtime" options
path=""
dimension=""
mtime=""

# Process command-line options
while [ "$1" != "" ]; do
	case $1 in
		-p | --path )			shift
									path=$1
									;;
		-m | --mtime )			shift
									mtime=$1
									;;
		-s | --dimension )	shift
									dimension=$1
									;;
		* )	echo "Error: Unknown option $1"
				exit 1
	esac
	shift
done

# Check if a path was provided
if [ -z "$path" ]
then
    echo "Error: No path provided"
    exit 1
else
    # Change to the provided directory
    cd "$path"
fi

# Check if a dimension was provided
if [ -z "$dimension" ]
then
    # If no dimension was provided, use the default value of 1800
    dimension="1800"
fi

# Check if a mtime value was provided
if [ -z "$mtime" ]
then
    # If no mtime value was provided, use the default value of -7
    mtime="-7"
fi

# Find all the image files in the directory and its subdirectories modified in the last week and pass them to mogrify
find . -type f -mtime "$mtime" \( -name '*.jpg' -o -name '*.jpeg' -o -name '*.png' \) -exec mogrify -resize "$dimension"> {} \;

# Find all the JPEG files in the directory and its subdirectories and pass them to jpegoptim
find . -type f -mtime "$mtime" \( -name '*.jpg' -o -name '*.jpeg' \) -exec jpegoptim --strip-all --max=80 {} \;

# Find all the PNG files in the directory and its subdirectories and pass them to pngquant
find . -type f -mtime "$mtime" -name '*.png' -exec pngquant --force --ext .png --quality=80-95 {} \;




# 0 8 * * 1 /path/to/script/compress_images.sh -p /path/to/images -mtime -7 -dimension 1800
