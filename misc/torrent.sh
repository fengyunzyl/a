function hr {
  sed '
  1d
  $d
  s/  //
  ' <<< "$1"
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
  cygstart "http://thepiratebay.se/search/$sc/0/$sr/$cg"
  exit
fi

cd /tmp
rm -f *.htm
lower=$(awk 'BEGIN {print 1.5 * 1024^3}')
upper=$(awk 'BEGIN {print 3 * 1024^3}')

curl "http://thepiratebay.se/search/$sc/0/$sr/$cg" |
awk '$2 == "torrent" {print $3}' FS=/ |
while read each
do
  curl -o $each.htm http://thepiratebay.se/torrent/$each
done

for each in *.htm
do
  # check size
  sz=$(awk '/Bytes/ {print $NF}' FPAT=[[:digit:]]+ $each)
  (( sz < lower )) && continue
  (( sz > upper )) && continue
  # check kbps
  grep -iq 'kb[p/]s' $each || continue
  # check seeders
  sd=$(awk '/Seeders/ {print RT}' RS=[[:digit:]]+ $each)
  (( sd < 2 )) && continue
  cygstart http://thepiratebay.se/torrent/$each
done
