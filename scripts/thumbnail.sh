# Set thumbnail for MP4 video

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

log ()
{
  unset PS4
  qq=$((set -x; : "$@") 2>&1)
  warn "${qq:2}"
  eval "${qq:2}"
}

unquote ()
{
  read -r $1 <<< "${!1//\"}"
}

warn 'Careful, screencaps will dump in current directory.
Drag video here, then press enter (backslashes ok).'
read -r vd
[[ $vd ]] || exit
unquote vd
log atomicparsley "$vd" --artwork REMOVE_ALL --overWrite || exit
. <(ffprobe -v 0 -show_streams -of flat=h=0:s=_ "$vd")

set $(awk '{
  w = $1
  h = $2
  d = $3
  ar = w / h
  pics = ar > 2 ? 36 : 30
  interval = d / pics
  for (ss = interval; ss < d; ss += interval)
    print ss
}' <<< "$stream_0_width $stream_0_height $stream_0_duration")

for ss
do
  log ffmpeg -ss $ss -i "$vd" -frames 1 -v warning $ss.png
done

warn 'Drag picture here, then press enter (backslashes ok).'
read -r pc
[[ $pc ]] || exit
unquote pc
log atomicparsley "$vd" --artwork "$pc" --overWrite
rm *.png
