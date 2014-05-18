warn () {
  printf '\e[36m%s\e[m\n' "$*" >&2
}

log () {
  unset PS4
  sx=$((set -x
    : "$@") 2>&1)
  warn "${sx:2}"
  "$@"
}

if (( $# != 2 ))
then
  echo ${0##*/} TAG URL
  exit
fi

tag=$1
url=$2

log curl -s $url |
awk '
$4 ~ tag {
  a[b++] = sprintf("%s %s %s %s",$5,$2,$3,$4)
}
END {
  asort(a)
  for (; b > 0; b--)
    print a[b]
}
' FS='(<[^>]*>)+' tag=$tag
