# Print Cygwin mirrors

warn () {
  printf '\e[36m%s\e[m\n' "$*"
}

log () {
  warn $*
  eval $*
}

wget -qO- sourceware.org/cygwin/mirrors.lst |
  awk '/http/ && /United States/ && NF=1' FS=';' > mirrors.lst

while read ee
do
  if log wget --spider -t1 -T1 -q $ee
  then
    ff+=($ee)
  fi
done < mirrors.lst

for gg in ${ff[*]}
do
  echo "${#gg} $gg"
done |
sort

rm mirrors.lst
