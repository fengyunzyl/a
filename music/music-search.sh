#!/bin/dash
if [ ! "$BROWSER" ]
then
  echo 'BROWSER not set or not exported'
  exit
fi
if [ "$#" != 2 ]
then
  echo 'music-search.sh [artist] [song]'
  exit
fi

while read j
do
  "$BROWSER" "$j"
done <<+
youtube.com/results?q="$1 - Topic" intitle:$2
youtube.com/results?q=-intitle:$1 $1 intitle:$2, hd
youtube.com/results?q=allintitle:$1 $2, hd
youtube.com/results?q=allintitle:$1 $2
google.com/search?tbm=vid&q=$1 intitle:"$2"
+
