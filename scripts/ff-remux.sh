# ffmpeg remux to format of choice

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

usage ()
{
  echo usage: $0 FORMAT
  exit
}

[ $1 ] || usage
arg_fmt=$1
printf -v nn '\n'
while read -rp "Drag file here, or use a pipe.$nn" aa
do
  [[ $aa ]] || exit
  unquote aa
  bb=${aa%.*}.${arg_fmt}
  # "-nostdin" broken, thanks Stefano Sabatini
  log ffmpeg -i "$aa" -c copy -v warning -stats "$bb" </dev/null
  log rm "$aa"
done
