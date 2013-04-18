# count occurances of a tag

usage ()
{
  echo usage: $0 TAG URL
  exit
}

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

[ $2 ] || usage
tag=$1
url=$2

log curl -s "$url" |
awk -vtag=$tag '
BEGIN {
  FS = "(<[^>]*>)+"
  OFS = ","
}
$4 ~ tag {
  print $2, $4, $5
}
' | sort -k3 -rt,
