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

path ()
{
  dn=$(dirname "${!1}")
  bn=$(basename "${!1}")
  cd "$dn"
  read $1 <<< "$PWD/$bn"
  cd ~-
}

[ $1 ] || usage
arg_fmt=$1
flac=nocopy
wav=nocopy

if ! [ ${!arg_fmt} ]
then
  cpy='-c copy'
fi

printf -v nwn '\n'
while read -rp "Drag file here, or use a pipe.$nwn" inf
do
  [[ $inf ]] || exit
  unquote inf
  otf=${inf%.*}.${arg_fmt}
  log ffmpeg -i "$inf" -v error -stats -nostdin $cpy "$otf"
  printf '\n'
  path inf
  log rm "$inf"
done
