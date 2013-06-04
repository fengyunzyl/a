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
  echo "Script will search current directory for FLAC, MP3, PNG or JPG files."
  echo "It will use these files to create high quality videos. Finally it will"
  echo "upload videos to YouTube. Once you are sure environment is correct run"
  echo "$0 -f"
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
    if [[ $line = y ]]
    then
      break
    elif [[ $line = e ]]
    then
      read -ei "${!1}" $1
      break
    elif [[ $line = q ]]
    then
      exit
    else
      warn y - accept
      warn e - edit
      warn q - quit
    fi
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

if (( 0x`reg query 'hkcu\console' | awk /nB/,NF=1 FPAT=....$` < 0x55 ))
then
  reg add 'hkcu\console' -f -t reg_dword -v WindowSize -d 0x190055
  reg add 'hkcu\console' -f -t reg_dword -v ScreenBufferSize -d 0x7d00055
  kill -7 $PPID
fi

shopt -s extglob
img=(
  @(*.png|*.jpg)
)
[ -a $img ] || usage
songs=(
  @(*.flac|*.mp3)
)

[ $1 ] || usage
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
    meta=recordingids+sources
  )
  warn connect to acoustid.org...
  curl -s api.acoustid.org/v2/lookup?`querystring` | jq .results[0] > .json
  warn `JQ .id`
  # FIXME should be length and sources
  rid=$(JQ '.recordings | max_by(.sources).id')
  # hit musicbrainz API for entire album
  if ! [ $date ]
  then
    qs=(
      fmt=json
      inc=artist-credits+labels+discids+recordings
      recording=$rid
    )
    warn connect to musicbrainz.org...
    set 'min_by((.date | tostring) + "4", (.media[0].discs | length) * -1)'
    curl -s musicbrainz.org/ws/2/release?`querystring` |
      jq ".releases | $1" > .json
    cp .json rls.json
    tags=$(JQ '.["artist-credit"][0].name')
    album=`JQ .title`
    show album
    label=$(JQ '.["label-info"][0].label.name')
    show label
    date=`JQ .date`
    readu date
  fi
  jq ".media[0].tracks[] | select(.recording.id == \"$rid\")" rls.json > .json
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
