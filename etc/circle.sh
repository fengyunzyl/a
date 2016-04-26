#!/bin/sh
if [ $# != 6 ]
then
  echo 'circle.sh [in radius] [x] [y] [in file] [out radius] [out file]'
  exit
fi
if ! convert -version &>/dev/null
then
  echo 'convert not found'
  exit
fi

qu=$(($1*2))
ro=$(($5*2))

convert "$4" -extent ${qu}x${qu}+${2}+${3} \
  '(' +clone -alpha transparent -draw "circle $1,$1 $1,0" ')' \
  -compose copyopacity -composite -resize ${ro}x${ro} \
  -define icon:auto-resize=16,48,256 -compress zip "$6"

ie4uinit -ClearIconCache
