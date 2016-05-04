#!/bin/sh
if [ "$#" != 1 ]
then
  echo 'highlight.sh [file]'
  exit
fi
alfa=(
  lang-sh lang-c lang-cs lang-clj lang-coffee lang-css lang-dart lang-pascal
  lang-erlang lang-go lang-hs lang-html lang-java lang-javascript lang-json
  lang-tex lang-lisp lang-lua lang-fs lang-pascal lang-perl lang-php lang-proto
  lang-python lang-r lang-regex lang-ruby lang-rust lang-scala lang-sql
  lang-vhdl lang-vb lang-xml
)
for bravo in ${alfa[*]}
do
  printf '%s\n\n<!-- language: %s -->\n\n' $bravo{,}
  cat "$1"
  echo
done
