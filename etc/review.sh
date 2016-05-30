#!/bin/dash -e
if [ "$#" != 1 ]
then
  echo 'review.sh [artist]'
  exit
fi

{
  sed 's/ /+/g' | xargs -l cygstart
} <<+
http://allmusic.com/search/all/$1
http://metacritic.com/search/all/$1/results
http://pitchfork.com/search/?query=$1
http://albumoftheyear.org/search.php?q=$1
+
