function warn {
  printf '\e[36m%s\e[m\n' "$*" >&2
}

wget -qO- sourceware.org/mirrors.html |
awk '/<li>/ && /(ftp|http):/ {print $2}' FS='"' |
while read each
do
  warn "$each"
  if wget --quiet --spider --tries 1 --timeout .1 "$each"
  then
    echo "${#each} $each"
  fi
done |
sort
