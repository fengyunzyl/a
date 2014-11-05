if (( ! $# ))
then
  echo test.sh ITEMS
  exit
fi

for ts in a b c d e f g k p r s S t u w x G N
do
  printf '%s  ' $ts
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
done
