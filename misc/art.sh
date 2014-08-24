# get cover art

function browse {
  case $OSTYPE in
  linux-gnu) xdg-open "$1" ;;
  cygwin)    cygstart "$1" ;;
  esac
}

if (( $# != 2 ))
then
  echo ${0##*/} ARTIST ALBUM
  exit
fi

ARTIST=$1
ALBUM=$2

browse "http://google.com/search?tbm=isch&q=$ARTIST $ALBUM"
browse "http://fanart.tv/api/getdata.php?type=2&s=$ARTIST"
browse "http://discogs.com/search?q=$ARTIST $ALBUM"
browse "http://wikipedia.org/w/index.php?search=${ARTIST// /+}+${ALBUM// /+}"
browse "http://musicbrainz.org/search?type=release&query=$ARTIST $ALBUM"
