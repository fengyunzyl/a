#!/bin/sh
# techpatterns.com/forums/about304.html
# Mozilla/5.0 (iPad; U; CPU OS 4_2_1 like Mac OS X; ja-jp) AppleWebKit/533.17.9

# Find the shortest User Agent string
# From my tests it was "iPad"

wget -qO- "techpatterns.com/downloads/firefox/useragentswitcher.xml" |
  tr '"();' '\n' |
  sed "s/^[ \t]*//" |
  sort -u |
  while read aa
  do
    printf "${#aa}\t$aa\n"
  done |
  sort -n |
  cut -f2 |
  while read bb
  do
    echo "$bb"
    wget -qO- -U "$bb" "youtube.com/watch?v=ReP9pN5jJDY" |
      grep -q "videoplayback?" && echo "$bb" >> log
  done
