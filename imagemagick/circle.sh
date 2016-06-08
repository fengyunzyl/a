#!/bin/dash -e
if [ "$#" != 6 ]
then
  echo 'circle.sh [in radius] [x] [y] [in file] [out radius] [out file]'
  exit
fi

qu=$(($1*2))
ro=$(($5*2))

convert "$4" -extent ${qu}x${qu}+${2}+${3} \
  '(' +clone -alpha transparent -draw "circle $1,$1 $1,0" ')' \
  -compose copyopacity -composite -resize ${ro}x${ro} \
  -define icon:auto-resize=256,48,16 -compress zip "$6"

ie4uinit -ClearIconCache
