
[ $OSTYPE = cygwin ] && xdg-open () {
  cygstart "$1"
}

usage () {
  echo "usage: ${0##*/} SEARCH SORT CATEGORY"
  echo
  echo "SORT"
  echo "3  date descending"
  echo "6  size ascending"
  echo
  echo "CATEGORY"
  echo "207  HD Movies"
  echo "208  HD TV shows"
  echo "301  Applications Windows"
  exit
}

(( $# == 3 )) || usage
xdg-open "http://thepiratebay.se/search/$1/0/$2/$3"
