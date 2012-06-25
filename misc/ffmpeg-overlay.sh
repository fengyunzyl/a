#!/bin/sh
# Overlay picture onto video!
# stackoverflow.com/questions/8184369

ffmpeg -i short.mp4 -f lavfi -i "
movie=short.mp4 [in];
movie=tiger.jpg,scale=-1:270 [tiger];
[in][tiger] overlay" -map a -map 1 -c:a copy out.mp4
