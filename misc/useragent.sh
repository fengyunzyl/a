#!/bin/sh
# techpatterns.com/forums/about304.html
# Mozilla/5.0 (iPad; U; CPU OS 4_2_1 like Mac OS X; ja-jp) AppleWebKit/533.17.9

# Find the shortest User Agent string
# From my tests it was "iPad"

wget -qO- "techpatterns.com/downloads/firefox/useragentswitcher.xml" \
  | tr '"();' '\n' \
  | sed "s/^[ \t]*//" \
  | sort -u \
  | while read u; do
      printf "${#u}\t$u\n"
    done \
      | sort -n \
      | cut -f2 \
      | while read v; do
          echo "$v"
          wget -qO- -U "$v" "youtube.com/watch?v=ReP9pN5jJDY" \
            | grep -q "videoplayback?" && break
          sleep .1
        done
