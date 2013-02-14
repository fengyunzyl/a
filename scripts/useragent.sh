#!/bin/sh
# techpatterns.com/forums/about304.html
# Mozilla/5.0 (iPad; U; CPU OS 4_2_1 like Mac OS X; ja-jp) AppleWebKit/533.17.9

# Find the shortest User Agent string
# From my tests it was "iPad"

wget -qO- techpatterns.com/downloads/firefox/useragentswitcher.xml |
  tr '"();' '\n' |
  sort -u |
  while read aa
  do
    printf '%s\t%s\n' "${#aa}" "$aa"
  done |
  sort -n |
  cut -f2 |
  while read aa
  do
    echo $aa
    if wget -qO- -U "$aa" youtube.com/watch?v=ReP9pN5jJDY |
      grep -q videoplayback?
    then
      exit
    fi
  done
