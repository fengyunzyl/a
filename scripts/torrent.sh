case $OSTYPE in
  cygwin) xdg-open (){ cygstart "$1"; } ;;
    msys) xdg-open (){ start '' "$1"; } ;;
esac

usage () {
  echo "usage: ${0##*/} SEARCH SORT CATEGORY"
  echo
  echo "SORT"
  echo "3  date ↓"
  echo "6  size ↑"
  echo "7  seeders ↓"
  echo
  echo "CATEGORY"
  echo "207  HD Movies"
  echo "208  HD TV shows"
  echo "301  Applications Windows"
  exit
}

(( $# == 3 )) || usage
xdg-open "http://thepiratebay.se/search/$1/0/$2/$3"
