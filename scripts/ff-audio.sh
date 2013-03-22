# create high quality video from song and picture

warn ()
{
  printf '\e[36m%s\e[m\n' "$*" >&2
}

log ()
{
  unset PS4
  coproc yy (set -x; : "$@") 2>&1
  read zz <&$yy
  warn ${zz:2}
  "$@"
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

json ()
{
  read $1 < <(jq -r .$2 jq.json)
}

metadata ()
{
  log fpcalc "$1" | sed 's/ //g' > fp.sh
  . fp.sh
  set "client=8XaBELgH&duration=${DURATION}&fingerprint=${FINGERPRINT}"
  curl -s "api.acoustid.org/v2/lookup?${1}&meta=recordings+releaseids" |
    jq .results[0].recordings[0] > jq.json
  json TITLE title
  json ID releases[0].id
  set 'fmt=json&inc=artist-credits+labels'
  log curl -s "musicbrainz.org/ws/2/release/${ID}?${1}" > jq.json
  json ALBUM title
  json ARTIST '["artist-credit"][0].name'
  json LABEL '["label-info"][0].label.name'
  json DATE date
  rm -f fp.sh jq.json sr.txt
  echo "Title: $TITLE" >> sr.txt
  echo "Album: $ALBUM" >> sr.txt
  echo "Artist: $ARTIST" >> sr.txt
  echo "Label: $LABEL" >> sr.txt
  echo "Date: $DATE" >> sr.txt
  cat sr.txt
  warn 'enter "y" if metadata is ok'
  read bb
  [ $bb ] || exit
}

[ $1 ] || usage
mapfile -t songs < <(find -name '*.flac' -o -name '*.mp3')
read img < <(find -name '*.jpg')

if ! [ $img ]
then
  echo no jpg found
  exit
fi

for song in "${songs[@]}"
do
  video=${song%.*}.mp4
  # adding "-preset" would only make small difference in size or speed
  # make sure input picture is at least 720
  log ffmpeg -loop 1 -r 1 -i "$img" -i "$song" -shortest -qp 0 \
    -c:a aac -strict -2 -b:a 495263 -v warning -stats "$video"
  metadata "$song"
  # category is case sensitive
  log google youtube post -c Music -n "$ARTIST, $TITLE" -s sr.txt \
    -t "$ALBUM, $ARTIST" -u svnpenn "$video"
done
