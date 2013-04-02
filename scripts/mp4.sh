# MP4 mux

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
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

printf -v nn '\n'
while read -rp "Drag file here, or use a pipe.$nn" aa
do
  unquote aa
  bb="${aa%.*}.mp4"
  log ffmpeg -i "$aa" -c copy -nostdin -v warning "$bb"
  log rm "$aa"
done
