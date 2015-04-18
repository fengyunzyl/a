#!/bin/sh
if [ $# != 1 ]
then
  echo reddit.sh SUBREDDIT
  exit
fi

lynx -dump -listonly -nonumbers reddit.com/r/$1 |
sed 0,/Hidden/d |
youtube-dl --format bestaudio --download-archive %.txt --batch-file -
