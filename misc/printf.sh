#!/bin/sh
if [ $# = 0 ]
then
  echo 'printf.sh [-e] [input]'
  echo '-e   treat input as expression instead of string'
  exit
fi

z=(
  %a %b %d %e %.0f %.7f
  %g %h %i %j %k %l %m %n %o %p %q %r %s %t %u %v %w %x %y %z
)

if [ "$1" = -e ]
then
  y='BEGIN {w=%s}'
  shift
else
  y='BEGIN {w="%s"}'
fi

for x in "${z[@]}"
do
  printf "$y"'BEGIN {printf "%%%s\t%s\\n", w}' "$1" "$x" "$x"
done | awk -f-
