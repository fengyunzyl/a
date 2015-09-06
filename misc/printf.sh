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
  printf -vy '{w=%s}' "$2"
else
  printf -vy '{w="%s"}' "$1"
fi

printf '%s\n' "${z[@]}" | awk "$y"'{printf "%s\t" $0 "\n", $0, w}'
