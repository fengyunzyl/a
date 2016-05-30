#!/bin/sh -e
# create high quality video from song and picture
# site:musicbrainz.org acoustid -site:forums.musicbrainz.org
# http://github.com/stedolan/jq/issues/105
: '
blog.musicbrainz.org/2013/03/21/
puids-are-deprecated-and-will-be-removed-on-15-october-2013

blog.musicbrainz.org/2013/09/03/
changes-for-upcoming-schema-change-release-2013-10-14
'

JQ() {
  jq -r "$@" .json | sed 's/\r//'
}

xc() {
  awk '
  BEGIN {
    x = "\47"
    printf "\33[36m"
    while (++i < ARGC) {
      y = split(ARGV[i], z, x)
      for (j in z) {
        printf z[j] ~ /[^[:alnum:]%+,./:=@_-]/ ? x z[j] x : z[j]
        if (j < y) printf "\\" x
      }
      printf i == ARGC - 1 ? "\33[m\n" : FS
    }
  }
  ' "$@"
  "$@"
}

querystring() {
  sed 'y/ /&/' <<< ${qs[*]}
}

show() {
  for bb
  do
    echo ${bb^}: ${!bb}
  done
}

readu() {
  while :
  do
    show $1
    echo '[y,e,q]?'
    read line
    case $line in
    y) break
       ;;
    e) read -ei "${!1}" $1
       break
       ;;
    q) exit
       ;;
    esac
    echo 'y - accept'
    echo 'e - edit'
    echo 'q - quit'
  done
}

exten() {
  sed "
  s/[^.]*$//
  s/[^[:alnum:]]//g
  s/$/.$2/
  " <<< ${!1}
}

if [ "$#" -lt 2 ]
then
  cat <<+
SYNOPSIS
  music-upload.sh [picture] [songs]

DESCRIPTION
  Script will use files to create high quality videos, then upload videos to
  YouTube.
+
  exit
fi

img=$1
shift
songs=("$@")
declare -A artists titles

for song in "${songs[@]}"
do
  echo "$song"
  . <(fpcalc "$song" | sed 1d)
  qs=(
    client=8XaBELgH
    duration=$DURATION
    fingerprint=$FINGERPRINT
    meta=recordings+sources
  )
  echo 'connect to acoustid.org...'
  curl -s api.acoustid.org/v2/lookup?`querystring` | jq .results[0] > .json
  echo "AcoustID $(JQ .id)"
  set .sources "($DURATION - (.duration // 0) | length)"
  rid=$(JQ ".recordings | max(.2 * $1 - .8 * $2).id")
  # FIXME allow edit of recording id
  echo "musicbrainz recording id $rid"
  # hit musicbrainz API for entire album
  if [ ! "$date" ]
  then
    qs=(
      fmt=json
      inc=artist-credits+labels+discids+recordings
      recording=$rid
    )
    echo 'connect to musicbrainz.org...'
    set '(.media[0].discs | length)' '.["cover-art-archive"].count'
    curl -s musicbrainz.org/ws/2/release?`querystring` |
      jq ".releases | max(.3 * $1 + .7 * $2)" > .json
    echo "Musicbrainz relead ID $(JQ .id)"
    cp .json rls.json
    tags=$(JQ '.["artist-credit"][0].name')
    album=$(JQ .title)
    show album
    label=$(JQ '.["label-info"][0].label.name')
    show label
    date=$(JQ .date)
    readu date
  fi
  # must leave "media" open
  # FIXME use "or" to allow multiple recording ids
  jq ".media[].tracks[] | select(.recording.id == \"$rid\")" rls.json > .json
  artist=$(JQ '[.["artist-credit"][] | .name, .joinphrase] | add')
  show artist
  title=$(JQ .title)
  readu title
  show title album artist label date > `exten song txt`
  titles[$song]=$title
  artists[$song]=$artist
done

for song in "${songs[@]}"
do
  mp3gain -s d "$song"
  ffprobe -v error -show_format -print_format json "$song" > .json
  # Adding "-preset" would only make small difference in size or speed.
  # "-shortest" can mess up duration. Adding "-analyzeduration" would only
  # suppress warning, not change file.
  xc ffmpeg -loop 1 -r 1 -i "$img" -i "$song" -t `JQ .format.duration` \
    -qp 0 -filter:v 'scale=trunc(oh*a/2)*2:720' -b:a 384k -v error \
    -stats `exten song mp4`
done

if [ "${#album}" -lt 30 ]
then
  tags+=,$album
fi

for song in "${songs[@]}"
do
  # category is case sensitive
  xc google youtube post `exten song mp4` Music \
    -n "${artists[$song]}, ${titles[$song]}" -s `exten song txt` \
    -t "$tags" -u svnpenn
done
