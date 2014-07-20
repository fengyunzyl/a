# create high quality video from song and picture
# site:musicbrainz.org acoustid -site:forums.musicbrainz.org
# http://github.com/stedolan/jq/issues/105
: '
blog.musicbrainz.org/2013/03/21/
puids-are-deprecated-and-will-be-removed-on-15-october-2013

blog.musicbrainz.org/2013/09/03/
changes-for-upcoming-schema-change-release-2013-10-14
'

JQ () {
  jq -r "$@" .json | sed 's/\r//'
}

warn () {
  printf '\e[36m%s\e[m\n' "$*" >&2
}

log () {
  unset PS4
  sx=$(( set -x
         : "$@" )2>&1)
  warn "${sx:2}"
  eval "${sx:2}"
}

querystring () {
  sed 'y/ /&/' <<< ${qs[*]}
}

show () {
  for bb
  do
    echo ${bb^}: ${!bb}
  done
}

readu () {
  while :
  do
    show $1
    warn [y,e,q]?
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
    warn y - accept
    warn e - edit
    warn q - quit
  done
}

exten () {
  sed "
  s/[^.]*$//
  s/[^[:alnum:]]//g
  s/$/.$2/
  " <<< ${!1}
}

buffer () {
  powershell '&{
  param($cm)
  sp hkcu:console ScreenBufferSize ("0x{0:x}{1:x4}" -f 2000,$cm)
  sp hkcu:console WindowSize       ("0x{0:x}{1:x4}" -f   25,$cm)
  }' $(( ${#1} ? 88 : 80 ))
  cygstart bash $1
  kill -7 $PPID
}

if (( $# < 2 ))
then
  echo ${0##*/} PICTURE SONGS
  echo
  echo Script will use files to create high quality videos,
  echo then upload videos to YouTube.
  exit
fi

img=$1
shift
songs=("$@")
declare -A artists titles

for song in "${songs[@]}"
do
  warn $song
  . <(fpcalc "$song" | sed 1d)
  qs=(
    client=8XaBELgH
    duration=$DURATION
    fingerprint=$FINGERPRINT
    meta=recordings+sources
  )
  warn connect to acoustid.org...
  curl -s api.acoustid.org/v2/lookup?`querystring` | jq .results[0] > .json
  warn acoustid `JQ .id`
  set .sources "($DURATION - (.duration // 0) | length)"
  rid=$(JQ ".recordings | max_by(.2 * $1 - .8 * $2).id")
  # FIXME allow edit of recording id
  warn musicbrainz recording id $rid
  # hit musicbrainz API for entire album
  if ! (( ${#date} ))
  then
    qs=(
      fmt=json
      inc=artist-credits+labels+discids+recordings
      recording=$rid
    )
    warn connect to musicbrainz.org...
    set '(.media[0].discs | length)' '.["cover-art-archive"].count'
    curl -s musicbrainz.org/ws/2/release?`querystring` |
      jq ".releases | max_by(.3 * $1 + .7 * $2)" > .json
    warn musicbrainz release id `JQ .id`
    cp .json rls.json
    tags=$(JQ '.["artist-credit"][0].name')
    album=`JQ .title`
    show album
    label=$(JQ '.["label-info"][0].label.name')
    show label
    date=`JQ .date`
    readu date
  fi
  # must leave "media" open
  # FIXME use "or" to allow multiple recording ids
  jq ".media[].tracks[] | select(.recording.id == \"$rid\")" rls.json > .json
  artist=$(JQ '[.["artist-credit"][] | .name, .joinphrase] | add')
  show artist
  title=`JQ .title`
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
  log ffmpeg -loop 1 -r 1 -i "$img" -i "$song" -t `JQ .format.duration` \
    -qp 0 -filter:v 'scale=trunc(oh*a/2)*2:720' -b:a 384k -v error \
    -stats `exten song mp4`
done

(( ${#album} <= 30 )) && tags+=,$album
type google || exit

for song in "${songs[@]}"
do
  # category is case sensitive
  log google youtube post `exten song mp4` Music \
    -n "${artists[$song]}, ${titles[$song]}" -s `exten song txt` \
    -t "$tags" -u svnpenn
done

buffer 80
