function warn {
  printf '\e[36m%s\e[m\n' "$*" >&2
}

function log {
  unset PS4
  sx=$((set -x
    : "$@") 2>&1)
  warn "${sx:2}"
  "$@"
}

if (( $# != 2 ))
then
  echo tag.sh TAG URL
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
  PROCINFO["sorted_in"] = "@val_num_desc"
  for (b in a) print a[b]
}
' FS='(<[^>]*>)+' tag="$tag"
