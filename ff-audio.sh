# create high quality video from song and picture

if [[ $OSTYPE =~ linux ]]
then
  FFPROBE ()
  {
    ffprobe "$@"
  }
  JQ ()
  {
    jq -r "$@" .json
  }
else
  FFPROBE ()
  {
    ffprobe "$@" | d2u
  }
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
  set $((set -x; : "$@") 2>&1)
  shift
  warn $*
  eval $*
}

usage ()
{
  echo "Script will search the current directory for JPG file and either FLAC"
  echo "or MP3 files. It will use these files to create high quality videos."
  echo "Finally it will upload videos to YouTube."
  echo "Once you are sure environment is correct run"
  echo "$0 -f"
  exit
}

[ $1 ] || usage
img=(*.jpg)
if ! [ -a $img ]
then
  echo no jpg found
  exit
fi

shopt -s extglob
songs=( @(*.flac|*.mp3) )
declare -A titles

for song in "${songs[@]}"
do
  eval $(log fpcalc "$song" | sed '1d')
  set "client=8XaBELgH&duration=${DURATION}&fingerprint=${FINGERPRINT}"
  curl -so .json "api.acoustid.org/v2/lookup?meta=recordings&${1}"
  warn $(JQ '.results[0].id')
  title=$(JQ '.results[0].recordings[0].title')
  if ! [ $rid ]
  then
    rid=$(JQ '.results[0].recordings[0].id')
    set "fmt=json&inc=artist-credits+labels&recording=${rid}"
    log curl -s "musicbrainz.org/ws/2/release?${1}" |
      jq '.releases | sort_by(.["cover-art-archive"]) | .[length - 1]' > .json
    album=$(JQ '.title')
    artist=$(JQ '.["artist-credit"][0].name')
    label=$(JQ '.["label-info"][0].label.name')
    date=$(JQ '.date')
  fi
  rm .json
  meta=${song%.*}.txt
  {
    echo "Title: ${title}"
    echo "Album: ${album}"
    echo "Artist: ${artist}"
    echo "Label: ${label}"
    echo "Date: ${date}"
  } | tee "$meta"
  warn 'enter "y" if metadata is ok'
  read uu
  [ $uu ] || exit
  titles[$song]=$title
done

for song in "${songs[@]}"
do
  mp3gain -s d "$song"
  video=${song%.*}.mp4
  eval $(FFPROBE -v error -show_format -print_format flat=s=_ "$song")
  # Adding "-preset" would only make small difference in size or speed. Make
  # sure input picture is at least 720. "-shortest" can mess up duration. Adding
  # "-analyzeduration" would only suppress warning, not change file.
  log ffmpeg -loop 1 -r 1 -i "$img" -i "$song" -t $format_duration \
    -qp 0 -filter:v 'crop=trunc(iw/2)*2' \
    -c:a aac -strict -2 -b:a 384k -v error -stats "$video"
done

for song in "${songs[@]}"
do
  meta=${song%.*}.txt
  video=${song%.*}.mp4
  # category is case sensitive
  log google youtube post -c Music -n "${artist}, ${titles[$song]}" \
    -s "${meta}" -t "${album}, ${artist}" \
    -u svnpenn "${video}"
done
