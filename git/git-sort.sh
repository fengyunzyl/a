#!/bin/dash -e
cm=$(mktemp)
sz=$(mktemp)
dt=$(mktemp)
ob=$(mktemp)
for pa in *
do
  printf . >&2
  git log --follow --format=%% "$pa" | wc --lines >> $cm
  stat --format %s "$pa" >> $sz
  git log --follow --max-count=1 --diff-filter=AM --date=short \
  --format='%at %ad' "$pa" >> $dt
  echo "$pa" >> $ob
done
echo
awk '
BEGIN {
  OFS = "\t"
}
FILENAME == ARGV[1] {
  cm[FNR] = $0
}
FILENAME == ARGV[2] {
  sz[FNR] = $0
}
FILENAME == ARGV[3] {
  at[FNR] = $1
  ad[FNR] = $2
}
FILENAME == ARGV[4] {
  ob[FNR] = $0
}
END {
  while (++j <= FNR)
    print cm[j] * sz[j] * at[j], cm[j], sz[j], ad[j], ob[j]
}
' $cm $sz $dt $ob
