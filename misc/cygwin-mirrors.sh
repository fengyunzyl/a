function warn {
  printf '\e[36m%s\e[m\n' "$*" >&2
}

wget -qO- sourceware.org/cygwin/mirrors.lst |
cut -d';' -f1 |
while read ee
do
  warn "$ee"
  if wget --quiet --spider --tries 1 --timeout .1 "$ee"
  then
    echo "${#ee} $ee"
  fi
done |
sort
