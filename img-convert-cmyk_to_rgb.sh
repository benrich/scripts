#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <path>"
	exit 1
fi

path=$1

find "$path" -type f -name "*.jpg" | while IFS= read -r file; do
	colorspace=$(identify -format "%[colorspace]" "$file")

	if [ "$colorspace" == "CMYK" ]; then
		echo "Converting $file to sRGB color profile"
		mogrify -profile /System/Library/ColorSync/Profiles/Generic\ CMYK\ Profile.icc -profile /System/Library/ColorSync/Profiles/sRGB\ Profile.icc "$file"
	fi
done
