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
    '104  Audio FLAC'
    '201  Video Movies'
    '205  Video TV shows'
    '207  Video HD Movies'
    '208  Video HD TV shows'
    '301  Applications Windows'
  )
  printf '%s\n' "${rw[@]}"
  exit
fi

cygstart "http://thepiratebay.se/search/$1/0/$2/$3"
