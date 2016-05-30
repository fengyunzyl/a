#!/bin/dash
if [ "$#" = 0 ]
then
  echo 'test.sh [items]'
  exit
fi

for y in a b c d e f g h L k p r s S t u w x O G N
do
  printf '  -%s  ' "$y"
  for z
  do
    if [ -"$y" "$z" ]
    then
      printf T
    else
      printf F
    fi
    printf '  '
  done
  echo
  printf '! -%s  ' "$y"
  for z
  do
    if [ ! -"$y" "$z" ] 2>/dev/null
    then
      printf T
    else
      printf F
    fi
    printf '  '
  done
  echo
done
