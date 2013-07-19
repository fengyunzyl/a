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
  # need quotes for github
  read -r $1 <<< "${!1//\"}"
}

warn 'Careful, screencaps will dump in current directory.
Drag video here, then press enter (backslashes ok).'
read -r if
[[ $if ]] || exit
unquote if
cd $(dirname "$if")
if=$(basename "$if")
log atomicparsley "$if" --artwork REMOVE_ALL --overWrite || exit
. <(ffprobe -v 0 -show_streams -of flat=h=0:s=_ "$if")

awk "BEGIN {
  w = $stream_0_width
  h = $stream_0_height
  d = $stream_0_duration
  ar = w / h
  pics = ar > 2 ? 36 : 30
  a = .09 * d
  b = d - a
  interval = (b - a) / (pics - 1)
  for (ss = a; pics-- > 0; ss += interval)
    print ss
}" |
while read ss
do
  printf '%g\r' $ss
  ffmpeg -ss $ss -i "$if" -frames 1 -v error -nostdin $ss.png
done

warn 'Drag picture here, then press enter (backslashes ok).'
read -r pc
[[ $pc ]] || exit
unquote pc
# moov could be anywhere in the file, so we cannot use "dd"
log atomicparsley "${if%.*}~.mp4" --artwork "$pc" --overWrite
rm *.png
