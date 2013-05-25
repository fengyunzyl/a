# get cover art

if [[ $OSTYPE =~ linux ]]
then
  FIREFOX ()
  {
    firefox $1
  }
else
  FIREFOX ()
  {
    "$PROGRAMFILES/mozilla firefox/firefox" "$1"
  }
fi

usage ()
{
  echo usage: $0 ARTIST ALBUM
  exit
}

[[ $2 ]] || usage

artist=$1
album=$2

FIREFOX "musicbrainz.org/search?type=release&query=${artist} ${album}"

FIREFOX "google.com/search?tbm=isch&q=${artist} ${album}"

FIREFOX "fanart.tv/api/getdata.php?type=2&s=${artist}"

FIREFOX "discogs.com/search?q=${artist} ${album}"

FIREFOX "wikipedia.org/w/index.php?search=${artist// /+}+${album// /+}"
