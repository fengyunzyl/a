#!/bin/sh
if [ $# != 1 ]
then
  echo reddit.sh URL
  exit
fi

lynx -dump -listonly -nonumbers "$1" |
sed 0,/Hidden/d |
youtube-dl --format bestaudio --download-archive %.txt --batch-file -
