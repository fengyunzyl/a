# create high quality video from song and picture

if [[ $OSTYPE =~ linux ]]
then
  JQ ()
  {
    jq -r "$@" .json
  }
else
  JQ ()
  {
    jq -r "$@" .json | d2u
  }
fi

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
  sed 's/ /\&/g' <<< ${qs[*]}
}

exten ()
{
  sed "s/[^.]*$/$2/;s/[^.[:alnum:]]/-/g" <<< ${!1}
}

if ! [ -a ~/googlecl ]
then
  echo google not found
  exit
fi

[ $1 ] || usage
shopt -s extglob
img=(
  @(*.png|*.jpg)
)
[ -a $img ] || usage
songs=(
  @(*.flac|*.mp3)
)
declare -A titles

for song in "${songs[@]}"
do
  warn $song
  . <(fpcalc "$song" | sed 1d)
  qs=(
    client=8XaBELgH
    duration=$DURATION
    fingerprint=$FINGERPRINT
    meta=recordings
  )
  warn connect to acoustid.org...
  curl -s api.acoustid.org/v2/lookup?`querystring` | jq .results[0] > .json
  warn `JQ .id`
  rid=$(JQ ".recordings | min_by($DURATION - (.duration // 0) | . * .).id")
  # hit musicbrainz API for entire album
  if ! [ $date ]
  then
    qs=(
      fmt=json
      inc=artist-credits+labels+recordings
      recording=$rid
    )
    warn connect to musicbrainz.org...
    curl -s musicbrainz.org/ws/2/release?`querystring` |
      jq '.releases | max_by(.["cover-art-archive"])' > .json
    cp .json rls.json
    album=`JQ .title`
    label=$(JQ '.["label-info"][0].label.name')
    date=`JQ .date`
  fi
  jq ".media[0].tracks[] | select(.recording.id == \"$rid\")" rls.json > .json
  title=`JQ .title`
  artist=$(JQ '.["artist-credit"][] | .name, .joinphrase')
  {
    echo Title: $title
    echo Album: $album
    echo Artist: $artist
    echo Label: $label
    echo Date: $date
  } | tee `exten song txt`
  warn 'enter "y" if metadata is ok'
  read uu
  [ $uu ] || exit
  titles[$song]=$title
done

for song in "${songs[@]}"
do
  mp3gain -s d "$song"
  ffprobe -v error -show_format -print_format json "$song" > .json
  # Adding "-preset" would only make small difference in size or speed.
  # "-shortest" can mess up duration. Adding "-analyzeduration" would only
  # suppress warning, not change file.
  log ffmpeg -loop 1 -r 1 -i "$img" -i "$song" -t `JQ .format.duration` -qp 0 \
    -filter:v 'scale=trunc(oh*a/2)*2:720' -b:a 384k -v error \
    -stats `exten song mp4`
done

if (( ${#album} > 30 ))
then
  album=${album/ /,}
fi

for song in "${songs[@]}"
do
  # category is case sensitive
  log google youtube post -c Music -n "$artist, ${titles[$song]}" \
    -s `exten song txt` -t "$album, $artist" -u svnpenn `exten song mp4`
done
