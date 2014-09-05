# cover art
function hr {
  sed '
  1d
  $d
  s/  //
  ' <<< "$1"
}

function bw {
  case $OSTYPE in
  linux-gnu) xdg-open "$1" ;;
  cygwin)    cygstart "$1" ;;
  esac
}

case $# in
0)
  hr '
  art.sh ARTIST ALBUM
  art.sh IMAGE
  '
  exit
;;
1)
  magick "$1" -resize x1000 -compress lossless 1000-"$1"
;;
2)
  ARTIST=$1
  ALBUM=$2
  bw "http://google.com/search?tbm=isch&q=$ARTIST $ALBUM"
  bw "http://fanart.tv/api/getdata.php?type=2&s=$ARTIST"
  bw "http://discogs.com/search?q=$ARTIST $ALBUM"
  bw "http://wikipedia.org/w/index.php?search=${ARTIST// /+}+${ALBUM// /+}"
  bw "http://musicbrainz.org/search?type=release&query=$ARTIST $ALBUM"
;;
esac
