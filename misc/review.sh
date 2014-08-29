function browse {
  case $OSTYPE in
  linux-gnu) xdg-open "$1" ;;
  cygwin)    cygstart "$1" ;;
  esac
}

if [ ! $# ]
then
  echo ${0##*/} ARTIST
  exit
fi

ARTIST=$*
browse "http://allmusic.com/search/all/$ARTIST"
browse "http://metacritic.com/search/all/${ARTIST// /+}/results"
browse "http://pitchfork.com/search/?query=$ARTIST"
browse "http://albumoftheyear.org/search.php?q=${ARTIST// /+}"
