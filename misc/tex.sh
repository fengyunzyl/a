#!/bin/sh

if [ $# != 1 ]
then
  echo 'tex.sh [tex file]'
  exit
fi

pdflatex -output-directory /tmp "$1" |
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
