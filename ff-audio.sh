# create high quality video from song and picture

JQ ()
{
  jq -r "$@" .json | tr -d '\r'
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*" >&2
}

log ()
{
  unset PS4
  qq=$((set -x; : "$@") 2>&1)
  warn "${qq:2}"
  eval "${qq:2}"
}

usage ()
{
  echo usage: $0 PICTURE SONGS
  echo
  echo Script will use files to create high quality videos,
  echo then upload videos to YouTube.
  exit
}

querystring ()
{
  sed 'y/ /&/' <<< ${qs[*]}
}

show ()
{
  for bb
  do
    echo ${bb^}: ${!bb}
  done
}

readu ()
{
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

exten ()
{
  sed "
  s/[^.]*$//
  s/[^[:alnum:]]//g
  s/$/.$2/
  " <<< ${!1}
}

buffer ()
{
  set $1 $(reg query 'hkcu\console' | grep ScreenBufferSize)
  [ $(( $4 & 0xffff )) = $1 ] && return
  set $(printf '%04x ' $1 2000 25)
  reg add 'hkcu\console' -f -t reg_dword -v ScreenBufferSize -d 0x$2$1
  reg add 'hkcu\console' -f -t reg_dword -v WindowSize -d 0x$3$1
  cygstart bash -l
  kill -7 $$ $PPID
}

buffer 85
[[ $2 ]] || usage
img=$1
shift
songs=("$@")
hash google || exit
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
  set .sources "($DURATION - (.duration // 0) | . * .)"
  rid=$(JQ ".recordings | max_by(.2 * $1 - .8 * $2).id")
  # FIXME allow edit of recording id
  warn musicbrainz recording id $rid
  # hit musicbrainz API for entire album
  if ! [ $date ]
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

for song in "${songs[@]}"
do
  # category is case sensitive
  log google youtube post `exten song mp4` Music \
    -n "${artists[$song]}, ${titles[$song]}" -s `exten song txt` \
    -t "$tags" -u svnpenn
done

buffer 80
