#!/bin/sh

if [ $# != 2 ]
then
  echo 'tex.sh [in file] [out file]'
  exit
fi

pa=$1
qu=$(dirname "$2")
ro=$(basename "$2")

pdflatex -halt-on-error -output-directory "$qu" -jobname "$ro" "$pa" |
sed '
/Output/ {
  s/^/\x1b[1;32m/
  s/$/\x1b[m/
}
/Fatal\|Warning\|Overfull\|Underfull/ {
  s/^/\x1b[1;31m/
  s/$/\x1b[m/
}
'
