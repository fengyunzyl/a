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

awk "BEGIN {
  w = $stream_0_width
  h = $stream_0_height
  d = $stream_0_duration
  ar = w / h
  pics = ar > 2 ? 36 : 30
  a = .06 * d
  b = d - a
  interval = (b - a) / (pics - 1)
  for (ss = a; pics-- > 0; ss += interval)
    print ss
}" |
while read ss
do
  log ffmpeg -ss $ss -i "$vd" -frames 1 -v error -nostdin $ss.png
done

warn 'Drag picture here, then press enter (backslashes ok).'
read -r pc
[[ $pc ]] || exit
unquote pc
log atomicparsley "$vd" --artwork "$pc" --overWrite
rm *.png
