# Set thumbnail for MP4 video

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

usage ()
{
  echo usage: $0 INTERVAL [OUTPUT]
  echo
  echo default OUTPUT is %d.png
  exit
}

log ()
{
  unset PS4
  set $((set -x; : "$@") 2>&1)
  shift
  warn $*
  eval $*
}

unquote ()
{
  read -r $1 <<< "${!1//\"}"
}

[ $1 ] || usage
[ $2 ] || set $1 %d.png
warn 'Careful, screencaps will dump in current directory.
Drag video here, then press enter (backslashes ok).'
read -r vd
unquote vd
log atomicparsley "$vd" --artwork REMOVE_ALL --overWrite || exit

ee=0
ff=0
while :
do
  printf -v gg $2 $ee
  log ffmpeg -ss $ff -i "$vd" -frames 1 -v warning $gg
  [ -a $gg ] || break
  (( ee += 1 ))
  (( ff += $1 ))
done

warn 'Drag picture here, then press enter (backslashes ok).'
read -r pc
unquote pc
log atomicparsley "$vd" --artwork "$pc" --overWrite
ls | grep png | xargs rm -f
