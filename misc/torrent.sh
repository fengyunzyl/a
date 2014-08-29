function browse {
  case $OSTYPE in
  linux-gnu) xdg-open "$1" ;;
  cygwin)    cygstart "$1" ;;
  esac
}

function hr {
  sed '
  1d
  $d
  s/  //
  ' <<< "$1"
}

function warn {
  printf '\e[36m%s\e[m\n' "$*"
}

function log {
  unset PS4
  sx=$((set -x
    : "$@") 2>&1)
  warn "${sx:2}"
  "$@"
}

if (( $# != 3 ))
then
  hr "
  ${0##*/} SEARCH SORT CATEGORY

  SORT
  3  date ↓
  6  size ↑
  7  seeders ↓

  CATEGORY
  100  Audio
  104  Audio FLAC
  201  Video Movies
  205  Video TV shows
  207  Video HD Movies
  208  Video HD TV shows
  301  Applications Windows
  "
  exit
fi

sc=$1
sr=$2
cg=$3

if (( cg != 207 ))
then
  browse "http://thepiratebay.se/search/$sc/0/$sr/$cg"
  exit
fi

cd /tmp
rm -f *.htm
lower=$(awk 'BEGIN {print 1.5 * 1024^3}')
upper=$(awk 'BEGIN {print 3 * 1024^3}')
log curl --com -so search.htm "thepiratebay.se/search/$sc/0/$sr/$cg"

awk '$2 == "torrent" {print $3}' FS=/ search.htm |
while read each
do
  curl --com -so $each.htm thepiratebay.se/torrent/$each
  # check size
  sz=$(awk '/Bytes/ {print $NF}' FPAT=[[:digit:]]+ $each.htm)
  if (( sz < lower ))
  then
    echo too small
    continue
  fi
  if (( sz > upper ))
  then
    echo too large
    continue
  fi
  # check kbps
  br=$(sed '
  /[kK][bB][pP/][sS]/ ! d
  s/[^[:digit:]]//g
  ' $each.htm | sort -nr | head -1)
  if (( br < 1000 ))
  then
    echo bad quality
    continue
  fi
  # check seeders
  sd=$(awk '/Seeders/ {print RT}' RS=[[:digit:]]+ $each.htm)
  if (( sd < 2 ))
  then
    echo low seeders
    continue
  fi
  browse http://thepiratebay.se/torrent/$each
done
