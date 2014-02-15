# get cover art

[ $OS ] && xdg-open () {
  powershell saps "'$1'"
}

usage () {
  echo ${0##*/} ARTIST ALBUM
  exit
}

(( $# == 2 )) || usage
ARTIST=$1
ALBUM=$2

xdg-open "http://google.com/search?tbm=isch&q=$ARTIST $ALBUM"
xdg-open "http://fanart.tv/api/getdata.php?type=2&s=$ARTIST"
xdg-open "http://discogs.com/search?q=$ARTIST $ALBUM"
xdg-open "http://wikipedia.org/w/index.php?search=${ARTIST// /+}+${ALBUM// /+}"
xdg-open "http://musicbrainz.org/search?type=release&query=$ARTIST $ALBUM"
