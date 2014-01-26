
[ $OSTYPE = cygwin ] && xdg-open () {
  cygstart "$1"
}

usage () {
  echo "usage: ${0##*/} CATEGORY SEARCH"
  echo "207  HD - Movies"
  echo "208  HD - TV shows"
  exit
}

(( $# < 2 )) && usage
# 6  size ascending
xdg-open "http://thepiratebay.se/search/$2/0/6/$1"
