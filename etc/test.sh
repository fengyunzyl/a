if (( ! $# ))
then
  echo test.sh ITEMS
  exit
fi

for ts in a b c d e f g h L k p r s S t u w x O G N
do
  printf '  -%s  ' $ts
  for each
  do
    if [ -$ts "$each" ]
    then
      printf T
    else
      printf F
    fi
    printf '  '
  done
  echo
  printf '! -%s  ' $ts
  for each
  do
    if [ ! -$ts "$each" ] 2>/dev/null
    then
      printf T
    else
      printf F
    fi
    printf '  '
  done
  echo
done
