# get cover art

usage ()
{
  echo usage: $0 ARTIST ALBUM
  exit
}

PATH=/bin:/usr/local/bin:${TMP%U*}progra~2/mozill~1
hash firefox || exit
[[ $2 ]] || usage
ARTIST=$1
ALBUM=$2

firefox "musicbrainz.org/search?type=release&query=$ARTIST $ALBUM"
firefox "google.com/search?tbm=isch&q=$ARTIST $ALBUM"
firefox "fanart.tv/api/getdata.php?type=2&s=$ARTIST"
firefox "discogs.com/search?q=$ARTIST $ALBUM"
firefox "wikipedia.org/w/index.php?search=${ARTIST// /+}+${ALBUM// /+}"
