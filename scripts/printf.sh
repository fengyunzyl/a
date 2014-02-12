usage () {
  echo usage: ${0##*/} INPUT
  exit
}

(( $# )) || usage

for foo in {a..z}
do
  awk "BEGIN {printf \"%%$foo\t%$foo\n\", \"$1\"}"
done
