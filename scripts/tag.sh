# count occurances of a tag

usage () {
  echo usage: $0 TAG URL
  exit
}

warn () {
  printf '\e[36m%s\e[m\n' "$*" >&2
}

log () {
  unset PS4
  qq=$(( set -x
         : "$@" )2>&1)
  warn "${qq:2}"
  eval "${qq:2}"
}

(( $# < 2 )) && usage
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
