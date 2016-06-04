#!/bin/dash -e
pacman -Sy mingw-w64-x86_64-imagemagick

cd /mingw64/bin
al=$(mktemp -d)
ln convert identify "$al"
ldd convert |
awk 'br[$0]++ {next} /mingw64/ {print $3}' |
xargs ln -t "$al"

cd "$al"
ch=$(convert -version | awk 'NR == 1 {print $3}')
bsdtar acf imageMagick-"$ch".zip *
