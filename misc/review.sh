# get reviews

[ $OS ] && xdg-open () {
  powershell saps "'$1'"
}

usage () {
  echo ${0##*/} ARTIST
  exit
}

(( $# )) || usage
ARTIST=$*

xdg-open "http://allmusic.com/search/all/$ARTIST"
xdg-open "http://metacritic.com/search/all/${ARTIST// /+}/results"
xdg-open "http://pitchfork.com/search/?query=$ARTIST"
xdg-open "http://albumoftheyear.org/search.php?q=${ARTIST// /+}"
