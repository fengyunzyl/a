[ $OS ] && xdg-open () {
  cygstart "$1"
}

if (( $# != 3 ))
then
  rw=(
    "${0##*/} SEARCH SORT CATEGORY"
    ''
    SORT
    '3  date ↓'
    '6  size ↑'
    '7  seeders ↓'
    ''
    CATEGORY
    '100  Audio'
    '207  HD Movies'
    '208  HD TV shows'
    '301  Applications Windows'
  )
  printf '%s\n' "${rw[@]}"
  exit
fi

xdg-open "http://thepiratebay.se/search/$1/0/$2/$3"
