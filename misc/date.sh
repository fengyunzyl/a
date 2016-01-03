#!/bin/sh
usage="\
NAME
  date.sh

SYNOPSIS
  date.sh [date]

EXAMPLE
  date.sh 2015-5-15
"

if [ $# != 1 ]
then
  printf "$usage"
  exit
fi

sq=(
  %a %b %c %d %e %g %h %j %k %l %m %p %r %s %u %w %x %y %z
  %A %B %C %D %F %G %H %I %M %N %P %R %S %T %U %V %W %X %Y %Z %:z %::z %:::z
  %Y%m%d %H%M%S '%b %-d %Y'
)

for each in "${sq[@]}"
do
  printf '%-11s' "$each"
  date -d "$1" +"$each"
done
