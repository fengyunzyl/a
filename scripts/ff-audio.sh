# create high quality video from song and picture

quote ()
{
  yy='[ #&(;\]'
  if [[ ${!1} =~ $yy ]]
  then
    read -r $1 <<< \"${!1}\"
  fi
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

log ()
{
  for oo
  do
    quote oo
    set -- "$@" $oo
    shift
  done
  warn $*
  eval $*
}

usage ()
{
  echo "script will search the current directory for FLAC files and JPG file."
  echo "It will use these files to create high quality videos."
  echo "Finally it will upload videos to YouTube."
  echo "Once you are sure environment is correct run"
  echo "$0 -f"
  exit
}

[ $1 ] || usage

mapfile -t songs < <(find -name '*.flac')
read img < <(find -name '*.jpg')
for song in "${songs[@]}"
do
  video=${song%.*}.mp4
  # adding "-preset" would only make small difference in size or speed
  # make sure input picture is at least 720
  log ffmpeg -loop 1 -i "$img" -i "$song" -shortest -qp 0 -c:a aac -strict -2 \
    -b:a 495263 -v warning -stats "$video"
  # upload
  ffprobe -show_format -print_format flat=s=, -v error "$song" |
    sed 's/\r//; s/.*,//' > metadata.sh
  . metadata.sh
  set summary.txt
  > $1
  echo "Title: $TITLE" >> $1
  echo "Album: $ALBUM" >> $1
  echo "Artist: $ARTIST" >> $1
  echo "Label: $LABEL" >> $1
  echo "Date: $DATE" >> $1
  # category is case sensitive
  log google youtube post -c Music -n "$ARTIST, $TITLE" -s $1 \
    -t "$ALBUM, $ARTIST" -u svnpenn "$video"
done
