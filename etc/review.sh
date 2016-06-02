#!/bin/dash -e
if [ ! "$BROWSER" ]
then
  echo 'BROWSER not set or not exported'
  exit
fi
if [ "$#" != 1 ]
then
  echo 'review.sh [artist]'
  exit
fi

{
  sed 's/ /+/g' | xargs -l "$BROWSER"
} <<+
http://allmusic.com/search/all/$1
http://metacritic.com/search/all/$1/results
http://pitchfork.com/search/?query=$1
http://albumoftheyear.org/search.php?q=$1
+
