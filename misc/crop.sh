#!/bin/sh
# Remove borders from image

input="$1"
# Border thickness
bt="6"

# Crop
# width:height:x:y
# iw:ih:0:0

ffmpeg \
-i "$input" \
-qmax 1 \
-vf "crop=iw-2*$bt:ih-2*$bt:$bt:$bt" \
out.jpg
