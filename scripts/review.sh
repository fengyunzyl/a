# get reviews

usage ()
{
  echo usage: $0 ARTIST
  exit
}

PATH=/bin:/usr/local/bin:${TMP%U*}progra~2/mozill~1
hash firefox || exit
[[ $1 ]] || usage
ARTIST=$*

firefox "allmusic.com/search/all/$ARTIST"
firefox "metacritic.com/search/all/${ARTIST// /+}/results"
firefox "pitchfork.com/search/?query=$ARTIST"
firefox "albumoftheyear.org/search.php?q=${ARTIST// /+}"
